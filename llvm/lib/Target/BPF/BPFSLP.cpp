#include "BPFAlias.hpp"
#include "llvm/Pass.h"
#include "llvm/CodeGen/MachineFunction.h"

#include "BPF.h"
#include "BPFInstrInfo.h"
#include "BPFAlias.hpp"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/Pass.h"
#include "Dataflow.h"

#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/DenseMap.h"

#include <array>
#include <algorithm>
#include <ranges>

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
  // std::vector<BitVector> dependencies
  // DenseMap<MachineInstr*, SmallPtrSet<MachineInstr*, NUM_DEPS>> dependencies;
  // DenseMap<MachineInstr*, SmallPtrSet<MachineInstr*, NUM_DEPS>> dependents;
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

unsigned StoreImmOpcode(unsigned Size) {
  switch (Size) {
    case 1:
      return BPF::STB_imm;
    case 2:
      return BPF::STH_imm;
    case 4:
      return BPF::STW_imm;
    case 8:
      return BPF::STD_imm;
    default: {
      errs() << "Invalid memory operand size: " << Size << '\n';
      std::abort();
    }
  }
}

using Pack = SmallVector<MachineInstr *>;

MachineInstr *createPackedInstr(MachineBasicBlock &MBB, const Pack &pack) {
  assert(!pack.empty() && "Got empty pack");
  auto *First = pack.front();
  unsigned Size = memorySize(*First);
  unsigned PackedSize = pack.size() * Size;
  assert(PackedSize <= 8 && "Pack too large");
  auto *TII = MBB.getParent()->getSubtarget().getInstrInfo();
  auto PackedOpcode = StoreImmOpcode(PackedSize);
  int64_t PackedImm = 0;
  for (auto Itr = pack.rbegin(); Itr != pack.rend(); Itr++) {
    PackedImm <<= Size * 8;
    PackedImm |= (*Itr)->getOperand(2).getImm();
  }
  DebugLoc DL;
  return BuildMI(MBB, MBB.end(), DL, TII->get(PackedOpcode))
    .addImm(PackedImm)
    .addReg(First->getOperand(1).getReg().asMCReg())
    .addImm(First->getOperand(2).getImm());
}

std::vector<unsigned> topologicalSort(const std::vector<BitVector> &G, const std::vector<BitVector> &Transpose) {
  const unsigned V = G.size();
  // Worklist[i] is set iff `i` has any incoming edges
  BitVector Worklist(V);
  for (const auto &BV : G) {
    Worklist |= BV;
  }
  Worklist.flip();
  BitVector Scheduled(V);
  std::vector<unsigned> Schedule;
  Schedule.reserve(V);
  while (!Worklist.empty()) {
    // Pop a node from worklist
    unsigned Next = Worklist.find_first();
    Worklist.reset(Next);
    // Skip if already visited
    if (Scheduled[Next]) continue;
    bool Ready = true;
    for (unsigned pred : Transpose[Next].set_bits()) {
      // Check if all predecessors have been scheduled
      if (!Scheduled[pred]) {
        Ready = false;
        break;
      }
    }
    if (!Ready) continue;
    // Schedule this node
    Scheduled.set(Next);
    Schedule.push_back(Next);
    // Add all successors to worklist
    for (unsigned succ : G[Next].set_bits()) {
      Worklist.set(succ);
    }
  }
  assert(Schedule.size() == V);
  return Schedule;
}

// Compute the transitive, **irreflexive** closure of a graph
std::vector<BitVector> transitiveClosure(const std::vector<BitVector> &G, const std::vector<BitVector> &Transpose) {
  auto Schedule = topologicalSort(G, Transpose);
  const unsigned N = G.size();
  std::vector<BitVector> closure(N, BitVector(N));
  // Iterate over graph in reverse topological ordering
  for (auto I = Schedule.rbegin(); I != Schedule.rend(); I++) {
    unsigned Node = *I;
    // Closure of a node is equal to the union of the reflexvive closure of each succcessor
    for (unsigned succ : G[Node].set_bits()) {
      closure[Node].set(succ) |= closure[succ];
    }
  }
  return closure;
}

MCRegister regToSubReg(MCRegister MCR) {
  switch (MCR) {
    case BPF::R0:
      return BPF::W0;
    case BPF::R1:
      return BPF::W1;
    case BPF::R2:
      return BPF::W2;
    case BPF::R3:
      return BPF::W3;
    case BPF::R4:
      return BPF::W4;
    case BPF::R5:
      return BPF::W5;
    case BPF::R6:
      return BPF::W6;
    case BPF::R7:
      return BPF::W7;
    case BPF::R8:
      return BPF::W8;
    case BPF::R9:
      return BPF::W9;
    case BPF::R10:
      return BPF::W10;
    case BPF::R11:
      return BPF::W11;
    default:
      return MCR;
  }
}

bool BPFSLP::runOnMachineFunction(MachineFunction &MF) {
  auto &AliasInfo = getAnalysis<BPFAlias>();

  const auto &TSI = MF.getSubtarget();
  const auto *TRI = TSI.getRegisterInfo();

  for (auto &MBB : MF) {
    DenseMap<MachineBasicBlock *, unsigned> BBIndex;
    unsigned i = 0;
    for (auto &MBB : MF) {
      BBIndex[&MBB] = i++;
    }
    const unsigned N = MBB.size();
    std::vector<BitVector> dependencies(N, BitVector(N));
    std::vector<BitVector> dependents(N, BitVector(N));
    MBB.dump();
    unsigned OuterIdx = 0;
    for (auto OuterItr = MBB.begin(); OuterItr != MBB.end(); OuterItr++) {
      auto &MI1 = *OuterItr;
      unsigned InnerIdx = 0;
      for (auto InnerItr = std::next(OuterItr); InnerItr != MBB.end(); InnerItr++) {
        // Iterate over all instructions after this one
        auto &MI2 = *InnerItr;
        for (auto &Use : OuterItr->all_uses()) {
          auto UseReg = Use.getReg().asMCReg();
          if (InnerItr->definesRegister(UseReg, TRI) || InnerItr->definesRegister(regToSubReg(UseReg), TRI)) {
            // Later instruction defines one an earlier instruction uses
            // WAR dependency
            dependents[OuterIdx].set(InnerIdx);
            dependencies[InnerIdx].set(OuterIdx);
          }
        }
        for (auto &Def : OuterItr->all_defs()) {
          auto DefReg = Def.getReg().asMCReg();
          if (InnerItr->definesRegister(DefReg, TRI) || InnerItr->definesRegister(regToSubReg(DefReg), TRI)) {
            // Later instruction defines one a later one also defines
            // WAW dependency
            dependents[OuterIdx].set(InnerIdx);
            dependencies[InnerIdx].set(OuterIdx);
          }
        }
        if (AliasInfo.conflict(MI1, MI2)) {
          // Both MI1 and MI2 are memory ops, at least one store
          // Both operate on overlapping locations
            dependents[OuterIdx].set(InnerIdx);
            dependencies[InnerIdx].set(OuterIdx);
        }
        InnerIdx++;
      }
      if (OuterItr->isTerminator()) {
        // Terminator depends on all previous instructions
        unsigned InnerIdx = 0;
        for (auto InnerItr = MBB.begin(); InnerItr != OuterItr; InnerItr++) {
          // Iterate over all instructions before this instruction
          auto &MI2 = *InnerItr;
          dependents[InnerIdx].set(OuterIdx);
          dependencies[OuterIdx].set(InnerIdx);
          InnerIdx++;
        }
      } else {
        unsigned InnerIdx = 0;
        for (auto InnerItr = MBB.begin(); InnerItr != OuterItr; InnerItr++) {
          // Iterate over all instructions before this instruction
          auto &MI2 = *InnerItr;
          for (auto &Use : OuterItr->all_uses()) {
            if (Use.isReg()) {
              auto UseReg = Use.getReg().asMCReg();
              if (InnerItr->definesRegister(UseReg, TRI) || InnerItr->definesRegister(regToSubReg(UseReg), TRI)) {
                // Earlier instruction defines a register used by a later one
                dependents[InnerIdx].set(OuterIdx);
                dependencies[OuterIdx].set(InnerIdx);
              }
            }
          }
          InnerIdx++;
        }
      }
      OuterIdx++;
    }
    using Pack = SmallVector<MachineInstr *>;
    DenseMap<MachineInstr*, Pack> packs;
    bool DidPack = false;
    // New Approach
    // Maintain mapping from instructions to dependencies
    // Maintain mapping from region -> size -> instructions
    // for i = 0..=2
    //   for R in regions
    //     let `packs` = packs of size 2^i
    //     sort `packs` by offset
    //     for every `pack` in `packs`
    //        if `pack` not yet packed
    //        for every `pack'` with offset equal to `pack.offset + 2^i`
    //          if `pack'` not yet packed
    //          `DoPack = true`
    //          for inst `I` in `pack'` and `I'` in `pack'`
    //            if  is not independent of I'
    //               `DoPack = false`
    //          if `DoPack`
    //            pack together `pack` and `pack'
    //            Add `pack` to 2^(i + 1)
    //             
    //        let `pack'` be the pack with offset equal to `pack.offset` + 2^i
    //        Merge `pack
    for (auto OuterItr = MBB.begin(); OuterItr != MBB.end(); OuterItr++) {
      auto &MI1 = *OuterItr;
      auto [Itr, Succeed] = packs.try_emplace(&MI1, SmallVector{&MI1});
      if (!Succeed)
        // Already packed this instruction
        continue;
      // singleton pack
      auto &pack = Itr->second;
      for (auto InnerItr = std::next(OuterItr); InnerItr != MBB.end(); InnerItr++) {
        auto &MI2 = *InnerItr;
        if (packs.contains(&MI2))
          // Already packed this instruction
          continue;
        if (dependencies[&MI1].contains(&MI2) || dependencies[&MI2].contains(&MI1))
          // don't pack if not independent
          continue;
        if (AliasInfo.packable(MI1, MI2)) {
          DidPack = true;
          pack.push_back(&MI2);
          std::sort(pack.begin(), pack.end(), [&](MachineInstr *MI1, MachineInstr *MI2) -> bool {
             
          });
          packs[&MI2] = {&MI1, &MI2};
          break;
        } 
      }
    }
    if (!DidPack)
      continue;
    auto getPackDependencies = [&](const Pack &pack) {
      return
        pack 
        | std::views::transform([&](MachineInstr *MI) -> std::vector<MachineInstr*> { 
            return { dependencies[MI].begin(), dependencies[MI].end() };
          })
        | std::views::join
        | std::views::transform([&](MachineInstr *MI) { return packs[MI]; });
    };
    auto getPackDependents = [&](const Pack &pack) {
      return
        pack 
        | std::views::transform([&](MachineInstr *MI) -> std::vector<MachineInstr*> { 
            return { dependents[MI].begin(), dependents[MI].end() };
          })
        | std::views::join
        | std::views::transform([&](MachineInstr *MI) { return packs[MI]; });
    };
    SetVector<Pack> ToSchedule;
    for (auto &[_, pack] : packs) {
      auto deps = getPackDependencies(pack);
      if (deps.begin() == deps.end()) {
        // No deps
        ToSchedule.insert(pack);
      }
    }
    SetVector<Pack> Schedule;
    while (!ToSchedule.empty()) {
      auto pack = ToSchedule.pop_back_val();
      auto deps = getPackDependencies(pack);
      if (std::ranges::all_of(deps, [&](Pack pack) {
        return Schedule.contains(pack);
      })) {
        // Every dependency of the pack has been scheduled
        for (Pack Dependent : getPackDependents(pack)) {
          // Check if all dependents of this pack can now be scheduled
          ToSchedule.insert(std::move(Dependent));
        }
        // Schedule this pack
        Schedule.insert(std::move(pack));
      }
    }
    // Clear basic block to insert new schedule
    for (auto Itr = MBB.begin(); Itr != MBB.end(); ) {
      (Itr++)->removeFromParent();
    }
    // for (auto &MI : MBB) {
      // MI.removeFromParent();
    // }
    DenseSet<MachineInstr *> scheduled;
    for (auto pack : Schedule) {
      assert(!pack.empty() && "Empty pack encountered");
      if (pack.size() == 1) {
        assert(!scheduled.contains(pack.front()));
        scheduled.insert(pack.front());
        // Singleton pack
        // Emit same instruction
        MBB.insert(MBB.end(), pack.front());
      } else {
        createPackedInstr(MBB, pack);
        // Emit new packed instruction
      }
    }
    MBB.dump();
    // if (std::all_of(pack.begin(), pack.end(), 
    // std::all_of(Deps.begin(), Deps.end(), [&](MachineInstr *Dep) {
    //   return Schedule.contains(Dep);
    // })) {
    //   // All dependencies of this instruction have been scheduled
    //   Schedule.insert()
    // }
    }
    return true;
  }
  // for (auto &MBB : MF) {
  //   dumpBasicBlock(MBB);
  //   outs() << "=====================================\n";
  // }

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