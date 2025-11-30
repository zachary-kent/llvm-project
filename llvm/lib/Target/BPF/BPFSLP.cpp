#include "BPFAlias.hpp"
#include "llvm/Pass.h"
#include "llvm/CodeGen/MachineFunction.h"

#include "BPF.h"
#include "BPFInstrInfo.h"
#include "BPFAlias.hpp"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/Pass.h"
#include "Dataflow.h"

#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/DenseMap.h"

#include <array>

using namespace llvm;

#define BPF_SLP_PASS_NAME "BPF SLP"

namespace {

constexpr unsigned NUM_DEPS = 10;

class BPFSLP : public MachineFunctionPass {
public:
  static char ID;

  BPFSLP() : MachineFunctionPass(ID) {
    initializeBPFSLPPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  virtual void getAnalysisUsage(llvm::AnalysisUsage &AU) const override;

  StringRef getPassName() const override {
    return BPF_SLP_PASS_NAME;
  }
private:
  DenseMap<MachineInstr*, SmallPtrSet<MachineInstr*, NUM_DEPS>> dependencies;
  DenseMap<MachineInstr*, SmallPtrSet<MachineInstr*, NUM_DEPS>> dependents;
  void dumpBasicBlock(const MachineBasicBlock &MBB) const;
};

char BPFSLP::ID = 0;

constexpr std::array<MCRegister, NUM_BPF_REGS> BPF_REGS {
  BPF::R0, BPF::R1, BPF::R2, BPF::R3, BPF::R4, BPF::R5, 
  BPF::R6, BPF::R7, BPF::R8, BPF::R9, BPF::R10, BPF::R11
};

template<typename T, unsigned N>
void printSet(const SmallPtrSet<T*, N> &Set) {
  outs() << '[';
  for (auto Itr = Set.begin(); Itr != Set.end(); ) {
    outs() << **Itr;
    if (++Itr != Set.end()) {
      outs() << ", ";
    }
  }
  outs() << ']';
}

void BPFSLP::getAnalysisUsage(AnalysisUsage &AU) const {
  MachineFunctionPass::getAnalysisUsage(AU);
  AU.addRequired<BPFAlias>();
}

void BPFSLP::dumpBasicBlock(const MachineBasicBlock &MBB) const {
  for (const auto &MI : MBB) {
    if (MI.isDebugOrPseudoInstr() || MI.isMetaInstruction()) continue;
    outs() << MI << ": ";
    if (dependencies.contains(&MI))
      printSet(dependencies.at(&MI));
    else
      outs() << "Has no deps";
    outs() << '\n';
  }
}

bool BPFSLP::runOnMachineFunction(MachineFunction &MF) {
  MF.dump();
  auto &AliasInfo = getAnalysis<BPFAlias>();

  const auto &TSI = MF.getSubtarget();
  const auto *TRI = TSI.getRegisterInfo();

  for (auto &MBB : MF) {
    for (auto OuterItr = MBB.begin(); OuterItr != MBB.end(); OuterItr++) {
      auto &MI1 = *OuterItr;
      for (auto InnerItr = std::next(OuterItr); InnerItr != MBB.end(); InnerItr++) {
        // Iterate over all instructions after this one
        auto &MI2 = *InnerItr;
        for (auto &Use : OuterItr->all_uses()) {
          auto UseReg = Use.getReg().asMCReg();
          if (InnerItr->definesRegister(UseReg, TRI)) {
            // Later instruction defines one an earlier instruction uses
            // WAR dependency
            dependents[&MI1].insert(&MI2);
            dependencies[&MI2].insert(&MI1);
          }
        }
        for (auto &Def : OuterItr->all_defs()) {
          auto DefReg = Def.getReg().asMCReg();
          if (InnerItr->definesRegister(DefReg, TRI)) {
            // Later instruction defines one a later one also defines
            // WAW dependency
            dependents[&MI1].insert(&MI2);
            dependencies[&MI2].insert(&MI1);
          }
        }
        if (AliasInfo.conflict(MI1, MI2)) {
          // Both MI1 and MI2 are memory ops, at least one store
          // Both operate on overlapping locations
          dependents[&MI1].insert(&MI2);
          dependencies[&MI2].insert(&MI1);
        }
      }
      for (auto InnerItr = MBB.begin(); InnerItr != OuterItr; InnerItr++) {
        // Iterate over all instructions before this instruction
        auto &MI2 = *InnerItr;
        for (auto &Use : OuterItr->all_uses()) {
          if (Use.isReg()) {
            auto UseReg = Use.getReg().asMCReg();
            if (InnerItr->definesRegister(UseReg, TRI)) {
              // Earlier instruction defines a register used by a later one
              dependents[&MI2].insert(&MI1);
              dependencies[&MI1].insert(&MI2);
            }
          }
        }
      }
    }
  }
  for (auto &MBB : MF) {
    for (auto OuterItr = MBB.begin(); OuterItr != MBB.end(); OuterItr++) {
      auto &MI1 = *OuterItr;
      for (auto InnerItr = std::next(OuterItr); InnerItr != MBB.end(); InnerItr++) {
        auto &MI2 = *InnerItr;
        if (dependencies[&MI1].contains(&MI2) || dependencies[&MI2].contains(&MI1))
          // don't pack if not independent
          continue;
        if (AliasInfo.packable(MI1, MI2)) {
          outs() << "Can pack:\n" << MI1 << MI2;
        }
      }
    }
  }
  // for (auto &MBB : MF) {
  //   dumpBasicBlock(MBB);
  //   outs() << "=====================================\n";
  // }
  return false;
}

} // end of anonymous namespace

INITIALIZE_PASS(BPFSLP, "bpf-slp",
                BPF_SLP_PASS_NAME,
                true, // is CFG only?
                false  // is analysis?
)

namespace llvm {

FunctionPass *createBPFSLPPass() {
  return new BPFSLP();
}

} // namespace llvm