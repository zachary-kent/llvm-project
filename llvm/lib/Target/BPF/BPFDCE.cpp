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

bool shouldAlwaysBeKept(const MachineInstr *MI) {
  // Don't trust this
  return MI->mayStore() || MI->hasUnmodeledSideEffects();
}

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

char BPFDCE::ID = 0;

constexpr size_t NUM_BPF_REGS = 11;

const DenseSet<unsigned> InstructionsThatWriteToARegister {
  { BPF::ADD_rr },{ BPF::ADD_ri },
  { BPF::SUB_rr },{ BPF::SUB_ri },
  { BPF::MUL_rr },{ BPF::MUL_ri },
  { BPF::DIV_rr },{ BPF::DIV_ri },
  { BPF::MOD_rr },{ BPF::MOD_ri },
  { BPF::OR_rr  },{ BPF::OR_ri  },
  { BPF::AND_rr },{ BPF::AND_ri },
  { BPF::XOR_rr },{ BPF::XOR_ri },
  { BPF::SLL_rr },{ BPF::SLL_ri },
  { BPF::SRL_rr },{ BPF::SRL_ri },
  { BPF::SRA_rr },{ BPF::SRA_ri },
  { BPF::MOV_ri },{ BPF::MOV_ri_32 },
  { BPF::MOV_rr },{ BPF::MOV_rr_32 },
};

constexpr std::array<MCRegister, NUM_BPF_REGS> BPF_REGS {
  BPF::R0, BPF::R1, BPF::R2, BPF::R3, BPF::R4, BPF::R5, BPF::R7, BPF::R8, BPF::R9, BPF::R10
};

bool BPFDCE::runOnMachineFunction(MachineFunction &MF) {

  const auto *TRI = MF.getSubtarget().getRegisterInfo();

  const SmallVector<MCRegister> InitializedOnEntry{BPF::R1, BPF::R10};

  // Dataflow values at entry of every instruction
  DenseMap<MachineInstr*, BitVector> live_out;

  Parameters<BitVector, MachineBasicBlock> Params = {
    .direction = Direction::Backward,
    .top = BitVector(NUM_BPF_REGS,true),
    .boundary = BitVector(NUM_BPF_REGS,true),
    .meet = [](BitVector& A, const BitVector &B) {
      A |= B;
    },
    .transfer = [&](MachineBasicBlock &MBB, BitVector &out) {
      for (auto &MI : MBB) {
        // This is mutated during this,
        live_out[&MI] = out;

        if (shouldAlwaysBeKept(&MI)) continue;

        // For all instructions that WRITE to a variable
        if(InstructionsThatWriteToARegister.contains(MI.getOpcode())) {
          auto Dst = MI.getOperand(0).getReg();

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