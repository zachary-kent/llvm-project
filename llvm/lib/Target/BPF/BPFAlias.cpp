#include "BPF.h"
#include "BPFInstrInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Pass.h"
#include "Dataflow.h"
#include "BPFAlias.hpp"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/SetVector.h"

// #include "llvm/Target/TargetRegisterInfo.h"
#include <optional>
#include <type_traits>
#include <array>

using namespace llvm;

#define BPF_ALIAS_PASS_NAME "BPF ALIAS"

template<typename T>
std::optional<T> meet(const std::optional<T> &l, const std::optional<T> &r) {
  return l && r && *l == *r ? l : std::nullopt;
}

Location::Location() : region(Region::Stack), offset(0) {}
Location::Location(Region region) : region(region) {}
Location::Location(Region region, int64_t offset) : region(region), offset(offset) {}

bool Location::disjoint(const Location &other) const {
  return region != other.region || (offset && other.offset && *offset != *other.offset);
}

bool Location::disjoint(const Location &other, unsigned Size1, unsigned Size2) const {
  if (region != other.region)
    // Point to different regions, can never alias
    return true;
  if (!offset || !other.offset)
    // One pointer may span entire region
    return false;
  // Either the bytes spanned by this location are
  // strictly less than the other offset, or vice versa
  return *offset + Size1 <= *other.offset || *other.offset + Size2 <= *offset;
}

bool Location::adjacent(const Location &other, unsigned Size1, unsigned Size2) const {
  if (region != other.region)
    // Point to different regions, never adjacent
    return false;
  if (!offset || !other.offset)
    // One pointer may span entire region
    return false;
  // This location directly before or after other
  return *offset + Size1 == *other.offset || *other.offset + Size2 == *offset;
}

bool Location::singleton(const Location &other) const {
  return offset.has_value();
}

bool Location::operator==(const Location &other) const {
  return region == other.region && offset == other.offset;
}

bool Location::operator!=(const Location &other) const {
  return !(*this == other);
}

std::optional<Location> Location::meet(const Location &other) const {
  if (region != other.region) return std::nullopt;
  Location glb = *this;
  if (offset != other.offset) {
    glb.offset.reset();
  }
  return glb;
}

void Location::add(int64_t offset) {
  if (this->offset) {
    *this->offset += offset;
  }
}

raw_ostream &operator<<(raw_ostream &OS, const Location &L) {
  switch (L.region) {
    case Location::Region::Context: {
      OS << "Context ";
      break;
    }
    case Location::Region::Global: {
      OS << "Global ";
      break;
    }
    case Location::Region::Packet: {
      OS << "Packet ";
      break;
    }
    case Location::Region::Stack: {
      OS << "Stack ";
      break;
    }
  }
  OS << L.offset;
  return OS;
}

LatticeElement::LatticeElement() : level(Level::Top) {}

LatticeElement::LatticeElement(Location loc) : level(Level::Pointer), loc(std::move(loc)) {}

Location &LatticeElement::getPointer() {
  assert(level == Level::Pointer && "Is not pointer");
  return loc;
}

bool LatticeElement::operator==(const LatticeElement &other) const {
  if (level != other.level)
    return false;
  switch (level) {
    case Level::Top:
    case Level::Bot: {
      return true;
    }
    case Level::Pointer: {
      return loc == other.loc;
    }
  }
}

void LatticeElement::meet(const LatticeElement &other) {
  if (level == Level::Bot || other.level == Level::Top)
    return;
  if (level == Level::Top || other.level == Level::Bot) {
    *this = other;
    return;
  }
  auto glb = loc.meet(other.loc);
  if (glb) {
    // greatest lower bound of pointers exist
    // i.e. both point to the same memory region
    loc = std::move(*glb);
  } else {
    // pointers point to different regions
    level = Level::Bot;
  }
}

void LatticeElement::addOffset(int64_t offset) {
  if (level == Level::Pointer) {
    loc.add(offset);
  }
}

bool LatticeElement::disjoint(const LatticeElement &Other) const {
  if (level == Level::Bot || Other.level == Level::Bot)
    // Either this or other may alias anything
    return false;
  assert(level != Level::Top && Other.level != Level::Top && "Top encountered");
  // Return whether the abstract locations are disjoint
  return loc.disjoint(Other.loc);
}

bool LatticeElement::disjoint(const LatticeElement &Other, unsigned Size1, unsigned Size2) const {
  if (level == Level::Bot || Other.level == Level::Bot)
    // Either this or other may alias anything
    return false;
  assert(level != Level::Top && Other.level != Level::Top && "Top encountered");
  // Return whether the abstract locations are disjoint
  return loc.disjoint(Other.loc, Size1, Size2);
}

bool LatticeElement::adjacent(const LatticeElement &Other, unsigned Size1, unsigned Size2) const {
  if (level == Level::Bot || Other.level == Level::Bot)
    // Either this or other may alias anything
    return false;
  assert(level != Level::Top && Other.level != Level::Top && "Top encountered");
  // Return whether the abstract locations are disjoint
  return loc.adjacent(Other.loc, Size1, Size2);
}

raw_ostream &operator<<(raw_ostream &OS, const LatticeElement &LE) {
  switch (LE.level) {
    case LatticeElement::Level::Top: {
      OS << "Undef";
      break;
    }
    case LatticeElement::Level::Bot: {
      OS << "Unknown";
      break;
    }
    case LatticeElement::Level::Pointer: {
      OS << "Pointer [" << LE.loc << ']';
      break;
    }
  }
  return OS;
}

char BPFAlias::ID = 0;

StringRef BPFAlias::getPassName() const {
  return BPF_ALIAS_PASS_NAME;
}

BPFAlias::BPFAlias() : MachineFunctionPass(ID) {
  initializeBPFDCEPass(*PassRegistry::getPassRegistry());
}

MCRegister subRegToReg(MCRegister MCR) {
  switch (MCR) {
    case BPF::W0:
      return BPF::R0;
    case BPF::W1:
      return BPF::R1;
    case BPF::W2:
      return BPF::R2;
    case BPF::W3:
      return BPF::R3;
    case BPF::W4:
      return BPF::R4;
    case BPF::W5:
      return BPF::R5;
    case BPF::W6:
      return BPF::R6;
    case BPF::W7:
      return BPF::R7;
    case BPF::W8:
      return BPF::R8;
    case BPF::W9:
      return BPF::R9;
    case BPF::W10:
      return BPF::R10;
    case BPF::W11:
      return BPF::R11;
    default:
      return MCR;
  }
}

constexpr std::array<MCRegister, NUM_BPF_REGS> BPF_REGS {
  BPF::R0, BPF::R1, BPF::R2, BPF::R3, BPF::R4, BPF::R5, 
  BPF::R6, BPF::R7, BPF::R8, BPF::R9, BPF::R10, BPF::R11
};

constexpr int64_t BPF_MAP_LOOKUP_INDEX = 1;

template<typename T>
void print_array(const std::array<T, NUM_BPF_REGS> &arr) {
  outs() << '[';
  for (size_t i = 0; i < NUM_BPF_REGS; i++) {
    outs() << 'R' << i << " = " << arr.at(i);
    if (i < NUM_BPF_REGS - 1) {
      outs() << ", ";
    }
  }
  outs() << "]\n";
}

static bool isStoreImm(unsigned Opcode) {
  return Opcode == BPF::STB_imm || Opcode == BPF::STH_imm ||
         Opcode == BPF::STW_imm || Opcode == BPF::STD_imm;
}

static bool isStore32(unsigned Opcode) {
  return Opcode == BPF::STB32 || Opcode == BPF::STH32 || Opcode == BPF::STW32 ||
         Opcode == BPF::STBREL32 || Opcode == BPF::STHREL32 ||
         Opcode == BPF::STWREL32;
}

static bool isStore64(unsigned Opcode) {
  return Opcode == BPF::STB || Opcode == BPF::STH || Opcode == BPF::STW ||
         Opcode == BPF::STD || Opcode == BPF::STDREL;
}

static bool isStoreInst(unsigned Opcode) {
  return isStoreImm(Opcode) || isStore32(Opcode) || isStore64(Opcode);
}

static bool isLoad32(unsigned Opcode) {
  return Opcode == BPF::LDB32 || Opcode == BPF::LDH32 || Opcode == BPF::LDW32 ||
         Opcode == BPF::LDBACQ32 || Opcode == BPF::LDHACQ32 ||
         Opcode == BPF::LDWACQ32;
}

static bool isLoad64(unsigned Opcode) {
  return Opcode == BPF::LDB || Opcode == BPF::LDH || Opcode == BPF::LDW ||
         Opcode == BPF::LDD || Opcode == BPF::LDDACQ;
}

unsigned memorySize(unsigned Opcode) {
  switch (Opcode) {
    // Store byte
    case BPF::STB: case BPF::STB_imm: case BPF::STB32: case BPF::STBREL32:
    // Load byte
    case BPF::LDB: case BPF::LDB32: case BPF::LDBACQ32: case BPF::LD_ABS_B: case BPF::LD_IND_B:
      return 1;
    // Store half-word
    case BPF::STH: case BPF::STH_imm: case BPF::STH32: case BPF::STHREL32:
    // Load half-word
    case BPF::LDH: case BPF::LDH32: case BPF::LDHACQ32: case BPF::LD_ABS_H: case BPF::LD_IND_H:
      return 2;
    // Store word
    case BPF::STW: case BPF::STW_imm: case BPF::STW32: case BPF::STWREL32:
    // Load word
    case BPF::LDW: case BPF::LDW32: case BPF::LDWACQ32: case BPF::LD_ABS_W: case BPF::LD_IND_W:
      return 4;
    // Store double-word
    case BPF::STD: case BPF::STD_imm:
    // Load double-word
    case BPF::LDD: case BPF::LDDACQ:
      return 8;
    default: {
      errs() << "Unknown opcode " << Opcode << '\n';
      std::abort();
    }
  }
}

unsigned memorySize(const MachineInstr &MI) {
  return memorySize(MI.getOpcode());
}

static bool isLoadSext(unsigned Opcode) {
  return Opcode == BPF::LDBSX || Opcode == BPF::LDHSX || Opcode == BPF::LDWSX;
}

bool isLoadInst(unsigned Opcode) {
  return isLoad32(Opcode) || isLoad64(Opcode) || isLoadSext(Opcode);
}

bool isLoadInst(const MachineInstr &MI) {
  return isLoadInst(MI.getOpcode());
}

bool isStoreInst(const MachineInstr &MI) {
  return isStoreInst(MI.getOpcode());
}

bool isMemInst(unsigned Opcode) {
  return isLoadInst(Opcode) || isStoreInst(Opcode);
}

bool isMemInst(const MachineInstr &MI) {
  return isMemInst(MI.getOpcode());
}

bool BPFAlias::conflict(const MachineInstr &MI1, const MachineInstr &MI2) const {
  if (!isMemInst(MI1) || !isMemInst(MI2))
    // One instruction not a load or store
    return false;

  if (!isStoreInst(MI1) && !isStoreInst(MI2))
    // Both are loads
    return false;

  auto LE1 = getInfo(MI1);
  unsigned Size1 = memorySize(MI1);

  auto LE2 = getInfo(MI2);
  unsigned Size2 = memorySize(MI2);
  // Abstract locations represented overlap
  return !LE1.disjoint(LE2, Size1, Size2);
}

bool BPFAlias::packable(const MachineInstr &MI1, const MachineInstr &MI2) const {
  if (!isStoreImm(MI1.getOpcode()) || !isStoreImm(MI2.getOpcode()))
    // Only pack store immediates
    return false;
  // Initially, every store imm in its own pack
  // Repeat until convergence:
  //  Merge adjacent, independent packs of same size to create new pack
  //  When merge, ensure that does not introduce circular dep
  //  Maintain mapping from instruction to pack
  // Schedule:
  //  Add to worklist all packs and instrs with no deps
  //  Repeat while worklist non-empty:
  //    let I = pop(worklist)
  //    if all deps of I have been scheduled:
  //      schedule I
  //      add all dependents of I to worklist
  //  Ensure no circular dependencies among packs
  // First find adjacent store imms of same size, create Pairs
  // Keep track of which instructions have been packed
  // Repeatedly merge packs of same size
  // 
  unsigned Size1 = memorySize(MI1);
  unsigned Size2 = memorySize(MI2);
  if (Size1 != Size2 || Size1 == 8)
    // Only pack stores of same size that are not already double word
    return false;

  auto LE1 = getInfo(MI1);
  auto LE2 = getInfo(MI2);
  // Only pack adjacent stores of same size
  return LE1.adjacent(LE2, Size1, Size2);
}

LatticeElement BPFAlias::getInfo(const llvm::MachineInstr &MI) const {
  assert(MI.getOperand(1).isReg());
  assert(MI.getOperand(2).isImm());
  auto Base = MI.getOperand(1).getReg().asMCReg();
  auto Off = MI.getOperand(2).getImm();
  auto LE = getInfo(MI, Base);
  LE.addOffset(Off);
  return LE;
}

const LatticeElement &BPFAlias::getInfo(const llvm::MachineInstr &MI, llvm::MCRegister MCR) const {
  const auto *TRI = MI.getParent()->getParent()->getSubtarget().getRegisterInfo();
  const auto &PtrInfo = PointerIn.at(&MI);
  return PtrInfo.at(TRI->getEncodingValue(subRegToReg(MCR)));
}

bool BPFAlias::runOnMachineFunction(MachineFunction &MF) {
  const auto &TSI = MF.getSubtarget();
  const auto *TRI = TSI.getRegisterInfo();

  // Initially, r1 points to the beginning of the context region and r10 to the stack
  PointerInfo boundary;
  boundary[TRI->getEncodingValue(BPF::R1)] = Location(Location::Region::Context, 0);
  boundary[TRI->getEncodingValue(BPF::R10)] = Location(Location::Region::Stack, 0);

  Parameters<PointerInfo, MachineBasicBlock> Params = {
    .direction = Direction::Forward,
    .top = PointerInfo(),
    .boundary = std::move(boundary),
    .meet = [](PointerInfo &A, const PointerInfo &B) {
      // Pointwise meet
      for (size_t i = 0; i < NUM_BPF_REGS; i++) {
        A[i].meet(B[i]);
      }
    },
    .transfer = [&](MachineBasicBlock &MBB, PointerInfo &In) {
      auto getInfo = [&](MCRegister MCR) -> LatticeElement& {
        return In[TRI->getEncodingValue(subRegToReg(MCR))];
      };
      for (auto &MI : MBB) {
        PointerIn[&MI] = In;
        // Bottom out all definitions at first
        switch (MI.getOpcode()) {
          case BPF::MOV_rr:
          case BPF::MOV_rr_32: {
            // Treat as copy
            assert(MI.getOperand(0).isReg() && "Dest not reg");
            assert(MI.getOperand(1).isReg() && "Src not reg");
            auto Dst = MI.getOperand(0).getReg();
            auto Src = MI.getOperand(1).getReg();
            getInfo(Dst) = getInfo(Src);
            break;
          }
          case BPF::LDW32: {
            assert(MI.getOperand(0).isReg() && "Dest not reg");
            assert(MI.getOperand(1).isReg() && "Base not reg");
            assert(MI.getOperand(2).isImm() && "Offset not immediate");
            auto Dest = MI.getOperand(0).getReg();
            auto Base = MI.getOperand(1).getReg();
            auto Off = MI.getOperand(2).getImm();
            const auto &BaseInfo = getInfo(Base);
            if (BaseInfo.level == LatticeElement::Level::Pointer 
                && BaseInfo.loc.region == Location::Region::Context
                && (BaseInfo.loc.offset == -Off || BaseInfo.loc.offset == 4 - Off)) {
              getInfo(Dest) = Location(Location::Region::Packet);
            } else {
              getInfo(Dest).level = LatticeElement::Level::Bot;
            }
            break;
          }
          case BPF::ADD_ri:
          case BPF::ADD_ri_32: {
            assert(MI.getOperand(0).isReg() && "Dest not reg");
            MCRegister Dst = MI.getOperand(0).getReg();
            int64_t Off = MI.getOperand(2).getImm();
            getInfo(Dst).addOffset(Off);
            break;
          }
          default: {
            for (const auto &Def : MI.defs()) {
              assert(Def.isReg() && "Dest not reg");
              getInfo(Def.getReg()).level = LatticeElement::Level::Bot;
            }
            if (MI.isCall()) {
              for (const auto &MO : MI.operands()) {
                if (MO.isRegMask()) {
                  for (size_t i = 0; i < NUM_BPF_REGS; i++) {
                    if (MO.clobbersPhysReg(BPF_REGS[i])) {
                      In[i].level = LatticeElement::Level::Bot;
                    }
                  }
                }
              }
              if (MI.getOperand(0).getImm() == BPF_MAP_LOOKUP_INDEX) {
                getInfo(BPF::R0) = Location(Location::Region::Global, 0);
              } else {
                getInfo(BPF::R0).level = LatticeElement::Level::Bot;
              }
            }
          }
        }
      }
    }
  };

  compute(Params, MF);

  // for (auto &MBB : MF) {
  //   for (auto &MI : MBB) {
  //     if (!MI.isMetaInstruction() && !MI.isDebugOrPseudoInstr()) {
  //       outs() << MI;
  //       print_array(PointerIn[&MI]);
  //     }
  //   }
  // }

  return false;
}

INITIALIZE_PASS(BPFAlias, "bpf-alias",
                BPF_ALIAS_PASS_NAME,
                true, // is CFG only?
                false  // is analysis?
)

namespace llvm {

FunctionPass *createBPFAliasPass() {
  return new BPFAlias();
}

} // namespace llvm