#include "BPF.h"
#include "BPFInstrInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Pass.h"
#include "Dataflow.h"
#include "llvm/ADT/BitVector.h"
// #include "llvm/Target/TargetRegisterInfo.h"

#include <array>

using namespace llvm;

#define BPF_DCE_PASS_NAME "BPF DCE"

namespace {

class BPFDCE : public MachineFunctionPass {
public:
  static char ID;

  BPFDCE() : MachineFunctionPass(ID) {
    initializeBPFDCEPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return BPF_DCE_PASS_NAME;
  }
};

constexpr size_t NUM_BPF_REGS = 11;

constexpr std::array<MCRegister, NUM_BPF_REGS> BPF_REGS {
  BPF::R0, BPF::R1, BPF::R2, BPF::R3, BPF::R4, BPF::R5, BPF::R7, BPF::R8, BPF::R9, BPF::R10
};

bool BPFDCE::runOnMachineFunction(MachineFunction &MF) {

  const auto *TRI = MF.getSubtarget().getRegisterInfo();

  const SmallVector<MCRegister> InitializedOnEntry{BPF::R1, BPF::R10};

  // Dataflow values at entry of every instruction
  DenseMap<MachineInstr*, BitVector> ConstIn;

  Parameters<BitVector, MachineBasicBlock> Params = {
    .direction = Direction::Backward,
    .top = BitVector(NUM_BPF_REGS,true),
    .boundary = BitVector(NUM_BPF_REGS,true),
    .meet = [](BitVector& A, const BitVector &B) {
      A |= B;
    },
    .transfer = [&](MachineBasicBlock &MBB, BitVector &In) {

      

      
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

  outs() << "hello from dce\n";

  return false;
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