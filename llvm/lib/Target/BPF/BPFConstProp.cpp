#include "BPF.h"
#include "BPFInstrInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/Pass.h"
#include "Dataflow.h"

#include <array>

using namespace llvm;

#define BPF_CONST_PROP_PASS_NAME "BPF Constant Propagation"

namespace {

class BPFConstProp : public MachineFunctionPass {
public:
  static char ID;

  BPFConstProp() : MachineFunctionPass(ID) {
    initializeBPFConstPropPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return BPF_CONST_PROP_PASS_NAME;
  }
};

char BPFConstProp::ID = 0;

struct LatticeElement {

  enum class Height {
    UNDEF,
    CONST,
    NAC
  };

  Height height;
  int64_t value;

  bool operator==(const LatticeElement &Other) const {
    return height == Other.height && 
      (height != Height::CONST || value == Other.value);
  }

  bool operator!=(const LatticeElement &Other) const {
    return !(*this == Other);
  }

  bool isConstant() {
    return height == Height::CONST;
  }

  LatticeElement() : height(Height::UNDEF), value(0) {}
  LatticeElement(int64_t value) : height(Height::CONST), value(value) {}

  // static const LatticeElement UNDEF;
  // static const LatticeElement NAC;

  // Mutates this lattice element to its greater lower bound with some other
  void meet(const LatticeElement &Other) {
    switch (height) {
      case Height::UNDEF: {
        // If this is undef, simply set to other
        *this = Other;
        break;
      }
      case Height::NAC: {
        // do nothing, remain NAC
        break;
      }
      case Height::CONST: {
        switch (Other.height) {
          case Height::UNDEF: {
            // do nothing, remain same constant
            break;
          }
          case Height::NAC: {
            height = Height::NAC;
            break;
          }
          case Height::CONST: {
            if (value != Other.value) {
              height = Height::NAC;
            }
            break;
          }
        }
        break;
      }
    }
  }
private:
  LatticeElement(Height height, int64_t value) : height(height), value(value) {}
};

// const LatticeElement LatticeElement::UNDEF{Height::UNDEF, 0};
// const LatticeElement LatticeElement::NAC{Height::NAC, 0};

constexpr size_t NUM_BPF_REGS = 12;

using ConstMap = std::array<LatticeElement, NUM_BPF_REGS>;

constexpr std::array<MCRegister, NUM_BPF_REGS> BPF_REGS {
  BPF::R0, BPF::R1, BPF::R2, BPF::R3, BPF::R4, BPF::R5, 
  BPF::R6, BPF::R7, BPF::R8, BPF::R9, BPF::R10, BPF::R11
};

// Associates Register-Register instructions with corresponding
// Register-Immediate ones
const DenseMap<unsigned, unsigned> RR2RI {
  { BPF::ADD_rr, BPF::ADD_ri },
  { BPF::SUB_rr, BPF::SUB_ri },
  { BPF::MUL_rr, BPF::MUL_ri },
  { BPF::DIV_rr, BPF::DIV_ri },
  { BPF::MOD_rr, BPF::MOD_ri },
  { BPF::OR_rr,  BPF::OR_ri  },
  { BPF::AND_rr, BPF::AND_ri },
  { BPF::XOR_rr, BPF::XOR_ri },
  { BPF::SLL_rr, BPF::SLL_ri },
  { BPF::SRL_rr, BPF::SRL_ri },
  { BPF::SRA_rr, BPF::SRA_ri }
};

bool BPFConstProp::runOnMachineFunction(MachineFunction &MF) {

  const auto &TSI = MF.getSubtarget();
  const auto *TRI = TSI.getRegisterInfo();

  const SmallVector<MCRegister> InitializedOnEntry{BPF::R1, BPF::R10, BPF::R11};

  // Which registers are defined on entry to the program
  ConstMap boundary;

  // Every register initialized on entry is NAC
  for (auto MCR : InitializedOnEntry) {
    boundary[TRI->getEncodingValue(MCR)].height = LatticeElement::Height::NAC;
  }

  // Dataflow values at entry of every instruction
  DenseMap<MachineInstr*, ConstMap> ConstIn;

  Parameters<ConstMap, MachineBasicBlock> Params = {
    .direction = Direction::Forward,
    .top = ConstMap(),
    .meet = [](ConstMap& A, const ConstMap &B) {
      // Pointwise meet
      for (size_t i = 0; i < NUM_BPF_REGS; i++) {
        A[i].meet(B[i]);
      }
    },
    .boundary = std::move(boundary),
    .transfer = [&](MachineBasicBlock &MBB, ConstMap &In) {
      for (auto &MI : MBB) {
        ConstIn[&MI] = In;
        for (const auto &Def : MI.defs()) {
          In[TRI->getEncodingValue(Def.getReg())].height = LatticeElement::Height::NAC;
        }
        if (MI.isMoveImmediate()) {
          auto Dst = MI.getOperand(0).getReg();
          auto Imm = MI.getOperand(1).getImm();
          In[TRI->getEncodingValue(Dst)] = Imm;
        }
        for (const auto &MO : MI.operands()) {
          if (MO.isRegMask()) {
            for (size_t i = 0; i < NUM_BPF_REGS; i++) {
              if (MO.clobbersPhysReg(BPF_REGS[i])) {
                In[i].height = LatticeElement::Height::NAC;
              }
            }
          }
        } 
      }
    }
  };

  compute(Params, MF);

  const auto *TII = TSI.getInstrInfo();

  bool changed = false;
  for (auto &MBB : MF) {
    for (auto &MI : MBB) {
      auto itr = RR2RI.find(MI.getOpcode());
      // Skip non-RR instructions
      if (itr == RR2RI.end()) continue;
      assert(MI.getNumOperands() == 3);
      auto RIOpcode = itr->second;
      auto Src = MI.getOperand(2);
      assert(Src.isReg() && Src.isUse());
      auto SrcReg = Src.getReg();
      auto Value = ConstIn[&MI][TRI->getEncodingValue(SrcReg)];
      // Don't replace if NAC
      if (!Value.isConstant()) continue;
      auto Dst = MI.getOperand(0);
      assert(Dst.isReg() && Dst.isDef());
      auto DstReg = Dst.getReg();
      BuildMI(MBB, MI, MI.getDebugLoc(), TII->get(RIOpcode), DstReg)
        .addReg(MI.getOperand(1).getReg())
        .addImm(Value.value);
      MI.eraseFromParent();
      changed = true;
    }
  }

  return changed;
}

} // end of anonymous namespace

INITIALIZE_PASS(BPFConstProp, "bpf-const-prop",
                BPF_CONST_PROP_PASS_NAME,
                true, // is CFG only?
                false  // is analysis?
)

namespace llvm {

FunctionPass *createBPFConstPropPass() {
  return new BPFConstProp();
}

} // namespace llvm