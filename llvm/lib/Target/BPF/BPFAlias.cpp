#include "BPF.h"
#include "BPFInstrInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Pass.h"
#include "Dataflow.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/SetVector.h"

// #include "llvm/Target/TargetRegisterInfo.h"
#include <optional>
#include <type_traits>
#include <array>

using namespace llvm;

#define BPF_ALIAS_PASS_NAME "BPF ALIAS"

namespace {

template<typename T>
std::optional<T> meet(const std::optional<T> &l, const std::optional<T> &r) {
  return l && r && *l == *r ? l : std::nullopt;
}

struct Location {
  enum class Region {
    Packet,
    Stack,
    Context,
    Global
  };
  Region region;
  std::optional<int64_t> offset;
  Location() : region(Region::Stack), offset(0) {}
  Location(Region region) : region(region) {}
  Location(Region region, int64_t offset) : region(region), offset(offset) {}
  bool disjoint(const Location &other) const {
    return region != other.region || (offset && other.offset && *offset != *other.offset);
  }
  bool singleton(const Location &other) const {
    return offset.has_value();
  }
  bool operator==(const Location &other) const {
    return region == other.region && offset == other.offset;
  }
  bool operator!=(const Location &other) const {
    return !(*this == other);
  }
  std::optional<Location> meet(const Location &other) const {
    if (region != other.region) return std::nullopt;
    Location glb = *this;
    if (offset != other.offset) {
      glb.offset.reset();
    }
    return glb;
  }
  void add(int64_t offset) {
    if (this->offset) {
      *this->offset += offset;
    }
  }
  friend raw_ostream &operator<<(raw_ostream &OS, const Location &L) {
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
  }
};

struct LatticeElement {
  //       T
  //      / \
  //     DP DNP
  //      \ /
  //      
  enum class Level {
    Top, // Not a pointer
    Pointer, // Pointer residing in one region
    Bot // May alias any pointer
  };
  Level level;
  Location loc;
  LatticeElement() : level(Level::Top) {}

  LatticeElement(Location loc) : level(Level::Pointer), loc(std::move(loc)) {}

  Location &getPointer() {
    assert(level == Level::Pointer && "Is not pointer");
    return loc;
  }

  bool operator==(const LatticeElement &other) const {
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

  void meet(const LatticeElement &other) {
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

  void addOffset(int64_t offset) {
    if (level == Level::Pointer) {
      loc.add(offset);
    }
  }

  friend raw_ostream &operator<<(raw_ostream &OS, const LatticeElement &LE) {
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
      }
    }
  }
};

class BPFAlias : public MachineFunctionPass {
public:
  static char ID;

  BPFAlias() : MachineFunctionPass(ID) {
    initializeBPFDCEPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return BPF_ALIAS_PASS_NAME;
  }
};

char BPFAlias::ID = 0;

constexpr size_t NUM_BPF_REGS = 12;

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
    default: {
      errs() << "Unknown register\n";
      std::abort();
    }
  }
}

using PointerInfo = std::array<LatticeElement, NUM_BPF_REGS>;

constexpr std::array<MCRegister, NUM_BPF_REGS> BPF_REGS {
  BPF::R0, BPF::R1, BPF::R2, BPF::R3, BPF::R4, BPF::R5, 
  BPF::R6, BPF::R7, BPF::R8, BPF::R9, BPF::R10, BPF::R11
};

constexpr int64_t BPF_MAP_LOOKUP_INDEX = 1;

template<typename T>
void print_array(const std::array<T, NUM_BPF_REGS> &arr) {
  outs() << '[';
  for (size_t i = 0; i < NUM_BPF_REGS; i++) {
    outs() << 'R' << i << " = " << arr[i];
    if (i < NUM_BPF_REGS - 1) {
      outs() << ", ";
    }
  }
  outs() << "]\n";
}

bool BPFAlias::runOnMachineFunction(MachineFunction &MF) {
  outs() << "Hello from const prop\n";

  const auto &TSI = MF.getSubtarget();
  const auto *TRI = TSI.getRegisterInfo();

  // Initially, r1 points to the beginning of the context region and r10 to the stack
  PointerInfo boundary;
  boundary[TRI->getEncodingValue(BPF::R1)] = Location(Location::Region::Context, 0);
  boundary[TRI->getEncodingValue(BPF::R10)] = Location(Location::Region::Stack, 0);

  // Dataflow values at entry of every instruction
  DenseMap<MachineInstr*, PointerInfo> PointerIn;

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
      for (auto &MI : MBB) {
        PointerIn[&MI] = In;
        // Bottom out all definitions at first
        switch (MI.getOpcode()) {
          case BPF::MOV_rr:
          case BPF::MOV_rr_32: {
            // Treat as copy
            auto Dst = subRegToReg(MI.getOperand(0).getReg());
            auto Src = subRegToReg(MI.getOperand(1).getReg());
            In[Dst] = In[Src];
          }
          case BPF::ADD_ri:
          case BPF::ADD_ri_32: {
            MCRegister Dst = subRegToReg(MI.getOperand(0).getReg());
            int64_t Off = MI.getOperand(2).getImm();
            In[Dst].addOffset(Off);
          }
          default: {
            for (const auto &Def : MI.defs()) {
              In[TRI->getEncodingValue(subRegToReg(Def.getReg()))].level = LatticeElement::Level::Bot;
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
                In[TRI->getEncodingValue(BPF::R0)] = Location(Location::Region::Global);
              } else {
                In[TRI->getEncodingValue(BPF::R0)].level = LatticeElement::Level::Bot;
              }
            }
          }
        }
      }
    }
  };

  for (auto &MBB : MF) {
    for (auto &MI : MBB) {
      print_array(PointerIn[&MI]);
    }
  }
}

} // end of anonymous namespace

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