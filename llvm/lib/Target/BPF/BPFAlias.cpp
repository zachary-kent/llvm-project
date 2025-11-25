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

#define BPF_DCE_PASS_NAME "BPF DCE"

// Copied from "llvm/lib/Target/BPFMISimplifyPatch.h"
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


bool isBPFStore(const MachineInstr *MI) {
  auto opcode = MI->getOpcode();
  return isStoreImm(opcode) || isStore32(opcode) || isStore64(opcode);
}

bool hasSideEffects(const MachineInstr *MI) {
  return isBPFStore(MI)
    || MI->isPseudo()
    || MI->hasUnmodeledSideEffects()
    || MI->isCall()
    || MI->isReturn()
    || MI->isBranch();
}

namespace {

// template<typename T>
// struct Interval {
//   T lo;
//   T hi;
//   Interval(T lo, T hi) : lo(lo), hi(hi) {}
//   Interval(T point) : lo(point), hi(point) {}
//   bool contains(T point) const {
//     return lo <= point && point <= hi;
//   }
//   bool disjoint(const Interval<T> &other) const {
//     return other.hi < lo || hi < other.lo;
//   }
//   bool isPoint() const {
//     return lo == hi;
//   }
// };

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
  std::optional<unsigned> offset;
  Location() : region(Region::Stack), offset(0) {}
  Location(Region region, unsigned offset) : region(region), offset(offset) {}
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
};

class BPFAlias : public MachineFunctionPass {
public:
  struct LatticeElement {

    //       T
    //      / \
    //     DP DNP
    //      \ /
    //      
    enum class Height {
      Top, // Not a pointer
      Pointer, // Pointer residing in one region
      Constant,
      Bot // May alias any pointer
    };
    Height height;
    union {
      // Is constant when height is constant
      unsigned constant;
      // When
      Location loc;
    };
    LatticeElement() : height(Height::Top) {}

    LatticeElement(Location loc) : height(Height::Pointer), loc(std::move(loc)) {}
    LatticeElement(unsigned constant) : height(Height::Constant), constant(constant) {}

    Location &getPointer() {
      assert(height == Height::Pointer && "Is not pointer");
      return loc;
    }

    unsigned getConstant() const {
      assert(height == Height::Constant && "Is not constant");
      return constant;
    }

    bool operator==(const LatticeElement &other) const {
      if (height != other.height)
        return false;
      switch (height) {
        case Height::Top:
        case Height::Bot: {
          return true;
        }
        case Height::Pointer: {
          return loc == other.loc;
        }
        case Height::Constant: {
          return constant == other.constant;
        }
      }
    }

    void meet(const LatticeElement &other) {
      if (height == Height::Bot || other.height == Height::Top)
        return;
      if (height == Height::Top || other.height == Height::Bot) {
        *this = other;
        return;
      }
      // Both are pointer or const
      if (height != other.height) {
        // One is pointer and one is const
        height = Height::Bot;
        return;
      }
      if (height == Height::Constant) {
        if (constant != other.constant) {
          // Both different constants
          height = Height::Bot;
        }
        // otherwise both are same
      } else { // height == Pointer
        auto glb = loc.meet(other.loc);
        if (glb) {
          // greatest lower bound of pointers exist
          // i.e. both point to the same memory region
          loc = std::move(*glb);
        } else {
          // pointers point to different regions
          height = Height::Bot;
        }
      }
    }

  };

  static char ID;

  BPFAlias() : MachineFunctionPass(ID) {
    initializeBPFDCEPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return BPF_DCE_PASS_NAME;
  }

private:
  // Mapping from registers to the pointers they may point to
  DenseMap<Register, LatticeElement> Info;
};

char BPFAlias::ID = 0;

constexpr size_t NUM_BPF_REGS = 12;

Register subRegToReg(Register R) {
  if (R.isVirtual()) return R;
  switch (R.asMCReg()) {
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
      return R;
  }
}



template<typename F>
bool AnyOperand(const MachineInstr &MI, F &&f) {
  static_assert(std::is_invocable_r_v<bool, F, const MachineOperand&>);
  for (const auto &MO : MI.operands()) {
    if (f(MO)) return true;
  }
  return false;
}

template<typename F>
bool AnyDef(const MachineInstr &MI, F &&f) {
  static_assert(std::is_invocable_r_v<bool, F, const Register&>);
  for (const auto &MO : MI.operands()) {
    if (!MO.isReg() || !MO.isDef()) continue;
    if (f(MO.getReg())) return true;
  }
  return false;
}

constexpr std::array<MCRegister, NUM_BPF_REGS> BPF_REGS {
  BPF::R0, BPF::R1, BPF::R2, BPF::R3, BPF::R4, BPF::R5, 
  BPF::R6, BPF::R7, BPF::R8, BPF::R9, BPF::R10, BPF::R11
};

bool BPFAlias::runOnMachineFunction(MachineFunction &MF) {
  auto &MRI = MF.getRegInfo();
  assert(!MRI.livein_empty() && "Cannot find context pointer");
  // Initially contains pointer to XDP context structure
  auto [copy, r1] = *MRI.livein_begin();
  Location Ctx(Location::Region::Context, 0);
  Info.try_emplace(r1, Ctx);
  Info.try_emplace(copy, std::move(Ctx));
  
  SetVector<MachineInstr*> worklist;
  // Initialize to all defs
  for (auto &MBB : MF) {
    for (auto &MI : MBB) {
      if (MI.getNumDefs() > 0 || MI.isCall()) {
        worklist.insert(&MI);
      }
      for (auto &Op : MI.operands()) {
        if (Op.isReg()) {
          Info.try_emplace(Op.getReg());
        }
      }
    }
  }
  while (!worklist.empty()) {
    auto *MI = worklist.pop_back_val();
    Register Def;
    if (MI->getNumDefs() > 0) {
      Def = subRegToReg(MI->defs().begin()->getReg());
    } else {
      assert(MI->isCall() && "Instruction has no defs and is not call");
      Def = BPF::R0;
    }
    LatticeElement NewInfo;
    NewInfo.height = LatticeElement::Height::Bot;
    if (MI->isMoveReg()) {
      auto &Src = MI->getOperand(1);
      assert(Src.isReg() && Src.isUse() && "Operand 1 of Mov Reg is not Reg Use");
      NewInfo = Info[subRegToReg(Src.getReg())];
    } else if (MI->isMoveImmediate()) {
      auto &Src = MI->getOperand(1);
      assert(Src.isImm() && Src.isUse() && "Operand 1 of Mov Imm is not Imm Use");
      NewInfo = Src.getImm();
    } else if (MI->isPHI()) {
      // Initialize `NewInfo` to top
      NewInfo = {};
      for (unsigned i = 1; i < MI->getNumOperands(); i += 2) {
        auto IncomingValue = MI->getOperand(i).getReg();
        NewInfo.meet(Info[subRegToReg(IncomingValue)]);
      }
    } else if (MI->isCall()) {
      for (auto &Op : MI->operands()) {
        if (Op.isRegMask()) {
          for (auto MCR : BPF_REGS) {
            if (Info.contains(MCR) && Op.clobbersPhysReg(MCR)) {
              
            }
          }
        }
      }
    } else {
      switch (MI->getOpcode()) {
        case BPF::SUBREG_TO_REG: {
          int64_t index = MI->getOperand(1).getImm();
          assert(index == 0 && "Subreg to reg with nonzero index");
          Register Src = MI->getOperand(2).getReg();
          NewInfo = 
        }
        case
      }
    }
  }

  // In
  outs() << "Starting dce\n";

  const auto *TRI = MF.getSubtarget().getRegisterInfo();

  // Dataflow values at entry of every instruction
  DenseMap<MachineInstr*, BitVector> live_out;

  BitVector boundary(NUM_BPF_REGS);
  boundary.set(0);

  Parameters<BitVector, MachineBasicBlock> Params = {
    .direction = Direction::Backward,
    .top = BitVector(NUM_BPF_REGS),
    .boundary = std::move(boundary),
    .meet = [](BitVector& A, const BitVector &B) {
      A |= B;
    },
    .transfer = [&](MachineBasicBlock &MBB, BitVector &out) {
      for (auto I = MBB.rbegin(); I != MBB.rend(); ++I) {
        auto &MI = *I;
        live_out[&MI] = out;

        bool defines_live_var = AnyDef(MI, [&](const auto &Def) {
          return out[TRI->getEncodingValue(Def)];
        });

        if (!hasSideEffects(&MI) && !defines_live_var) continue;

        // Kill all registers defined
        for (const MachineOperand &def : MI.operands()) {
          // Skip non-definitions
          if (!def.isReg() || !def.isDef()) continue;

          auto dest_reg = def.getReg();
          auto dest_reg_num = TRI->getEncodingValue(dest_reg);

          out.reset(dest_reg_num);
        }

        // Do not propagate liveness on
        // dead instruction with no side effects
        // Gen all variable used
        for (auto &use : MI.uses()) {
          if (use.isReg()) {
            // outs() << "USE - propogating liveness to " << use << "\n";
            auto src_reg_num = TRI->getEncodingValue(use.getReg());
            out.set(src_reg_num);
          }
        }
      }
    }
  };

  compute(Params, MF);

  DenseSet<MachineInstr*> delete_worklist;
  
  bool erased_instruction = false;
  for(auto &MBB : MF) {
    for (auto I = MBB.begin(); I != MBB.end(); ++I) {
      auto &MI = *I;

      // Don't erase if the instruction has side-effects
      if (hasSideEffects(&MI)) continue;

      bool delete_this_instruction = true;

      // If all registers defined by this instruction are not live, we can kill the instruction
      for (const MachineOperand &def : MI.operands()) {
        if (!def.isReg()) continue;
        if (!def.isDef()) continue;
        auto reg = def.getReg();
        auto real_reg_num = TRI->getEncodingValue(reg);

        if (live_out[&MI][real_reg_num]) {
          delete_this_instruction = false;
          break;
        }
      }
  
      if (delete_this_instruction){
        delete_worklist.insert(&MI);
      }
    }
  }

  for(auto MI : delete_worklist) {
    outs() << "Erasing instruction " << *MI << "\n";
    MI->eraseFromParent();
  }


  return erased_instruction;
}

} // end of anonymous namespace

INITIALIZE_PASS(BPFDCE, "bpf-dce",
                BPF_DCE_PASS_NAME,
                true, // is CFG only?
                true  // is analysis?
)

namespace llvm {

FunctionPass *createBPFDCEPass() {
  return new BPFDCE();
}

} // namespace llvm