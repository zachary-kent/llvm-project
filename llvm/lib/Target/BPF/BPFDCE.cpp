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

constexpr size_t NUM_BPF_REGS = 12;

constexpr std::array<MCRegister, NUM_BPF_REGS> BPF_REGS {
  BPF::R0, BPF::R1, BPF::R2, BPF::R3, BPF::R4, BPF::R5, 
  BPF::R6, BPF::R7, BPF::R8, BPF::R9, BPF::R10, BPF::R11
};

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

bool BPFDCE::runOnMachineFunction(MachineFunction &MF) {
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