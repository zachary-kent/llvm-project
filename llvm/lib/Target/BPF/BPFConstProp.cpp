#include "BPF.h"
#include "BPFInstrInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/Pass.h"
#include "Dataflow.h"
// #include "llvm/Target/TargetRegisterInfo.h"

#include <array>

using namespace llvm;

#define BPF_MACHINEINSTR_PRINTER_PASS_NAME "Dummy BPF machineinstr printer pass"

namespace {

class BPFMachineInstrPrinter : public MachineFunctionPass {
public:
  static char ID;

  BPFMachineInstrPrinter() : MachineFunctionPass(ID) {
    initializeBPFMachineInstrPrinterPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return BPF_MACHINEINSTR_PRINTER_PASS_NAME;
  }
};

char BPFMachineInstrPrinter::ID = 0;

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

constexpr size_t NUM_BPF_REGS = 11;

using ConstMap = std::array<LatticeElement, NUM_BPF_REGS>;

constexpr std::array<MCRegister, NUM_BPF_REGS> BPF_REGS {
  BPF::R0, BPF::R1, BPF::R2, BPF::R3, BPF::R4, BPF::R5, BPF::R7, BPF::R8, BPF::R9, BPF::R10
};

bool BPFMachineInstrPrinter::runOnMachineFunction(MachineFunction &MF) {

  const auto *TRI = MF.getSubtarget().getRegisterInfo();

  const SmallVector<MCRegister> InitializedOnEntry{BPF::R1, BPF::R10};

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
        for (const auto &Op : MI.operands()) {
          if (Op.isRegMask()) {
            for (size_t i = 0; i < NUM_BPF_REGS; i++) {
              if (Op.clobbersPhysReg(BPF_REGS[i])) {
                In[i].height = LatticeElement::Height::NAC;
              }
            }
          }
        } 
      }
    }
  };

  compute(Params, MF);

  return false;
}

} // end of anonymous namespace

INITIALIZE_PASS(BPFMachineInstrPrinter, "BPF-machineinstr-printer",
                BPF_MACHINEINSTR_PRINTER_PASS_NAME,
                true, // is CFG only?
                true  // is analysis?
)

namespace llvm {

FunctionPass *createBPFMachineInstrPrinterPass() {
  return new BPFMachineInstrPrinter();
}

} // namespace llvm