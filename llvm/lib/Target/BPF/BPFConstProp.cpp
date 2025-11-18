#include "BPF.h"
#include "BPFInstrInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/Pass.h"
// #include "llvm/Target/TargetRegisterInfo.h"

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

bool BPFMachineInstrPrinter::runOnMachineFunction(MachineFunction &MF) {

  for (auto &MBB : MF) {
    outs() << "Contents of MachineBasicBlock:\n";
    outs() << MBB << "\n";
    const BasicBlock *BB = MBB.getBasicBlock();
    outs() << "Contents of BasicBlock corresponding to MachineBasicBlock:\n";
    outs() << BB << "\n";
  }

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