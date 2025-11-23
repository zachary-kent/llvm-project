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

#define BPF_INSTRUMENT_INITIAL_PASS_NAME "BPF Instrumentation"

class BPFInstrumentInitial : public MachineFunctionPass {
public:
  static char ID;

  BPFInstrumentInitial() : MachineFunctionPass(ID) {
    initializeBPFInstrumentInitialPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return BPF_INSTRUMENT_INITIAL_PASS_NAME;
  }
};

char BPFInstrumentInitial::ID = 0;

bool BPFInstrumentInitial::runOnMachineFunction(MachineFunction &MF) {
  outs() << "Hello from instrument\n";

  const auto &TSI = MF.getSubtarget();
  const auto *TII = TSI.getInstrInfo();
  auto &MRI = MF.getRegInfo();

  auto &LoadImms = MF.getInfo<BPFFunctionInfo>()->LoadImms;

  auto *M = MF.getFunction().getParent();

  auto *GV = M->getGlobalVariable("dyn_inst_cnt");
  assert(GV && "Error: cannot find global for instrumentation");

  for (auto &MBB : MF) {

    auto NumInstrs = MRI.createVirtualRegister(&BPF::GPR32RegClass);
    auto Addr = MRI.createVirtualRegister(&BPF::GPRRegClass);
    auto Dummy = MRI.createVirtualRegister(&BPF::GPR32RegClass);

    // Add fetch-and-add
    BuildMI(MBB, MBB.getFirstNonPHI(), DebugLoc(), TII->get(BPF::XADDW32), Dummy)
      .addReg(Addr)
      .addImm(0)
      .addReg(NumInstrs);

    // Load address of instrumentation global
    BuildMI(MBB, MBB.getFirstNonPHI(), DebugLoc(), TII->get(BPF::LD_imm64), Addr)
      .addGlobalAddress(GV);

    // Load numbe of instructions in basic blocks
    MachineInstr *LoadNumInstrs =
      BuildMI(MBB, MBB.getFirstNonPHI(), DebugLoc(), TII->get(BPF::MOV_ri_32), NumInstrs)
      .addImm(0);

    LoadImms[&MBB] = LoadNumInstrs;
  }

  return true;
}

#define BPF_INSTRUMENT_FINAL_PASS_NAME "BPF Instrumentation Final"

class BPFInstrumentFinal : public MachineFunctionPass {
public:
  static char ID;

  BPFInstrumentFinal() : MachineFunctionPass(ID) {
    initializeBPFInstrumentFinalPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return BPF_INSTRUMENT_FINAL_PASS_NAME;
  }
};

char BPFInstrumentFinal::ID = 0;

bool BPFInstrumentFinal::runOnMachineFunction(MachineFunction &MF) {
  auto &LoadImms = MF.getInfo<BPFFunctionInfo>()->LoadImms;

  for (auto &MBB : MF) {
    unsigned NumInstrs = 0;
    for (auto &MI : MBB) {
      if (!MI.isMetaInstruction() && !MI.isDebugOrPseudoInstr()) {
        NumInstrs++;
      }
    }
    assert(LoadImms.contains(&MBB));
    auto *LoadImm = LoadImms[&MBB];
    // Patch up load to correspond to actual number of instructions in block
    auto &Imm = LoadImm->getOperand(1);
    // Exclude instrumentation instructions
    Imm.setImm(NumInstrs - 3);
  }

  return true;
}

} // end of anonymous namespace

INITIALIZE_PASS(BPFInstrumentInitial, "bpf-instrument-initial",
                BPF_INSTRUMENT_INITIAL_PASS_NAME,
                true, // is CFG only?
                false  // is analysis?
)

INITIALIZE_PASS(BPFInstrumentFinal, "bpf-instrument-final",
                BPF_INSTRUMENT_FINAL_PASS_NAME,
                true, // is CFG only?
                false  // is analysis?
)

namespace llvm {

FunctionPass *createBPFInstrumentInitialPass() {
  return new BPFInstrumentInitial();
}

FunctionPass *createBPFInstrumentFinalPass() {
  return new BPFInstrumentFinal();
}

} // namespace llvm