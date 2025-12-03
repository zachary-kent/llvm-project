#include "BPF.h"
#include "BPFInstrInfo.h"
#include "llvm/IR/Module.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/Pass.h"
#include "Dataflow.h"
#include "BPFTargetMachine.h"

#include <array>

using namespace llvm;

namespace {

#define BPF_COUNT_PASS_NAME "BPF Instruction count"

class BPFCount : public MachineFunctionPass {
public:
  static char ID;

  BPFCount() : MachineFunctionPass(ID) {
    initializeBPFCountPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return BPF_COUNT_PASS_NAME;
  }
};

char BPFCount::ID = 0;

bool BPFCount::runOnMachineFunction(MachineFunction &MF) {
  unsigned count = 0;
  for (auto &MBB : MF) {
    for (auto &MI : MBB) {
      if (!MI.isDebugOrPseudoInstr() && !MI.isMetaInstruction()) {
        count++;
      }
    }
  }
  outs() << count << " Instructions\n";
  return false;
}


} // end of anonymous namespace

INITIALIZE_PASS(BPFCount, "bpf-count",
                BPF_COUNT_PASS_NAME,
                true, // is CFG only?
                true  // is analysis?
)

namespace llvm {

FunctionPass *createBPFCountPass() {
  return new BPFCount();
}


} // namespace llvm