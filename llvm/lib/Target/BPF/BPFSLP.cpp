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
#include "llvm/ADT/EquivalenceClasses.h"

#include <array>
#include <algorithm>
#include <ranges>

using namespace llvm;

#define BPF_SLP_PASS_NAME "BPF SLP"

namespace {

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
  // for (const auto &MI : MBB) {
  //   if (MI.isDebugOrPseudoInstr() || MI.isMetaInstruction()) continue;
  //   outs() << MI << ": ";
  //   if (dependencies.contains(&MI))
  //     printSet(dependencies.at(&MI));
  //   else
  //     outs() << "Has no deps";
  //   outs() << '\n';
  // }
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
  while (Worklist.any()) {
    // Pop a node from worklist
    int Next = Worklist.find_first();
    assert(Next >= 0);
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

bool disjoint(const BitVector &BV1, const BitVector &BV2) {
  auto Inter = BV1;
  Inter &= BV2;
  return Inter.none();
}

namespace slp {
  struct Pack {
    unsigned First;
    unsigned Offset;
    BitVector Dependents;
    BitVector Members;
    Pack(unsigned First, unsigned Offset, BitVector Dependents) : First(First), Offset(Offset), Dependents(std::move(Dependents)), Members(Dependents.size()) {
      Members.set(First);
    }
    bool operator<(const Pack &Other) const {
      return Offset < Other.Offset;
    }
    bool merge(const Pack &Rht) {
      if (!disjoint(Dependents, Rht.Members) || !disjoint(Rht.Dependents, Members))
        return false;
      Dependents |= Rht.Dependents;
      Members |= Rht.Members;
      return true;
    }
  };
}

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

static bool isStoreInst(unsigned Opcode) {
  return isStoreImm(Opcode) || isStore32(Opcode) || isStore64(Opcode);
}

static bool isLoad32(unsigned Opcode) {
  return Opcode == BPF::LDB32 || Opcode == BPF::LDH32 || Opcode == BPF::LDW32 ||
         Opcode == BPF::LDBACQ32 || Opcode == BPF::LDHACQ32 ||
         Opcode == BPF::LDWACQ32;
}

static bool isLoad64(unsigned Opcode) {
  return Opcode == BPF::LDB || Opcode == BPF::LDH || Opcode == BPF::LDW ||
         Opcode == BPF::LDD || Opcode == BPF::LDDACQ;
}

unsigned memorySize(unsigned Opcode) {
  switch (Opcode) {
    // Store byte
    case BPF::STB: case BPF::STB_imm: case BPF::STB32: case BPF::STBREL32:
    // Load byte
    case BPF::LDB: case BPF::LDB32: case BPF::LDBACQ32: case BPF::LD_ABS_B: case BPF::LD_IND_B:
      return 0;
    // Store half-word
    case BPF::STH: case BPF::STH_imm: case BPF::STH32: case BPF::STHREL32:
    // Load half-word
    case BPF::LDH: case BPF::LDH32: case BPF::LDHACQ32: case BPF::LD_ABS_H: case BPF::LD_IND_H:
      return 1;
    // Store word
    case BPF::STW: case BPF::STW_imm: case BPF::STW32: case BPF::STWREL32:
    // Load word
    case BPF::LDW: case BPF::LDW32: case BPF::LDWACQ32: case BPF::LD_ABS_W: case BPF::LD_IND_W:
      return 2;
    // Store double-word
    case BPF::STD: case BPF::STD_imm:
    // Load double-word
    case BPF::LDD: case BPF::LDDACQ:
      return 3;
    default: {
      errs() << "Unknown opcode " << Opcode << '\n';
      std::abort();
    }
  }
}

unsigned memorySize(const MachineInstr &MI) {
  return memorySize(MI.getOpcode());
}

static bool isLoadSext(unsigned Opcode) {
  return Opcode == BPF::LDBSX || Opcode == BPF::LDHSX || Opcode == BPF::LDWSX;
}

bool isLoadInst(unsigned Opcode) {
  return isLoad32(Opcode) || isLoad64(Opcode) || isLoadSext(Opcode);
}

bool isLoadInst(const MachineInstr &MI) {
  return isLoadInst(MI.getOpcode());
}

bool isStoreInst(const MachineInstr &MI) {
  return isStoreInst(MI.getOpcode());
}

bool isMemInst(unsigned Opcode) {
  return isLoadInst(Opcode) || isStoreInst(Opcode);
}

bool isMemInst(const MachineInstr &MI) {
  return isMemInst(MI.getOpcode());
}

bool isSubset(const BitVector &A, const BitVector &B) {
  auto Copy = A;
  Copy &= B;
  return Copy == A;
}

bool BPFSLP::runOnMachineFunction(MachineFunction &MF) {
  auto &AliasInfo = getAnalysis<BPFAlias>();

  const auto &TSI = MF.getSubtarget();
  const auto *TRI = TSI.getRegisterInfo();

  for (auto &MBB : MF) {
    DenseMap<MachineInstr *, unsigned> InstrIndex;
    std::vector<MachineInstr *> Instrs;
    Instrs.reserve(MBB.size());
    {
      unsigned i = 0;
      for (auto &MI : MBB) {
        InstrIndex[&MI] = i++;
        Instrs.push_back(&MI);
      }
    }
    const unsigned N = MBB.size();
    std::vector<BitVector> dependencies(N, BitVector(N));
    std::vector<BitVector> dependents(N, BitVector(N));
    // MBB.dump();
    unsigned OuterIdx = 0;
    for (auto OuterItr = MBB.begin(); OuterItr != MBB.end(); OuterItr++) {
      auto &MI1 = *OuterItr;
      unsigned InnerIdx = OuterIdx + 1;
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
          dependents[InnerIdx].set(OuterIdx);
          dependencies[OuterIdx].set(InnerIdx);
          InnerIdx++;
        }
      } else {
        unsigned InnerIdx = 0;
        for (auto InnerItr = MBB.begin(); InnerItr != OuterItr; InnerItr++) {
          // Iterate over all instructions before this instruction
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
    EquivalenceClasses<unsigned> Packs;
    constexpr size_t NUM_SIZES = 3;
    constexpr size_t NUM_REGIONS = 4;
    auto transitiveDependencies = transitiveClosure(dependencies, dependents);
    auto transitiveDependents = transitiveClosure(dependents, dependencies);
    std::array<std::array<std::vector<slp::Pack>, NUM_SIZES>, NUM_REGIONS> StoreImms;
    {
      unsigned i = 0;
      for (auto &MI : MBB) {
        Packs.insert(i);
        // Only try to pack store-immediates
        if (isStoreImm(MI.getOpcode())) {
          auto LE = AliasInfo.getInfo(MI);
          // Only pack stores to known locations
          if (LE.level == LatticeElement::Level::Pointer && LE.loc.offset) {
            unsigned Size = memorySize(MI);
            StoreImms[static_cast<size_t>(LE.loc.region)][Size].emplace_back(i, *LE.loc.offset, transitiveDependents[i]);
          }
        }
        ++i;
      }
    }
    bool DidPack = false;
    for (size_t Region = 0; Region < NUM_REGIONS; Region++) {
      for (size_t Size = 0; Size < NUM_SIZES; Size++) {
        auto &SizedPacks = StoreImms[Region][Size];
        BitVector Merged(N);
        // Merge packs of size 2^Size
        std::sort(SizedPacks.begin(), SizedPacks.end());
        for (auto &Lft : SizedPacks) {
          if (Merged[Lft.First])
            // Already merged this pack
            continue;
          // Beginning offset of adjacent operation
          unsigned AdjOff = Lft.Offset + (1 << Size);
          auto lb = std::lower_bound(SizedPacks.begin(), SizedPacks.end(), AdjOff, 
            [](const slp::Pack &P, unsigned Off) {
              return P.Offset < Off;
          });
          for (auto I = std::move(lb); I != SizedPacks.end(); I++) {
            auto &Rht = *I;
            if (Rht.Offset > AdjOff)
              // Not adjacent
              break;
            if (Merged[Rht.First])
              // Already merged this pack
              continue;
            if (Lft.merge(Rht)) {
              DidPack = true;
              // Successful merge
              Merged.set(Lft.First);
              Merged.set(Rht.First);
              Packs.unionSets(Lft.First, Rht.First);
              // Add merged pack to next level
              StoreImms[Region][Size + 1].push_back(std::move(Lft));
              break;
            }   
          }
        }
      }
    }
    if (!DidPack)
      continue;
    // DenseMap<MachineInstr*, Pack> packs;
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

    auto getPackDependencies = [&](unsigned Instr) {
      BitVector PackDependencies(N);
      for (unsigned Member : Packs.members(Instr)) {
        PackDependencies |= dependencies[Member];
      }
      return PackDependencies;
    };

    auto getPackDependents = [&](unsigned Instr) {
      BitVector PackDependents(N);
      for (unsigned Member : Packs.members(Instr)) {
        PackDependents |= dependents[Member];
      }
      return PackDependents;
    };

    SetVector<unsigned> ToSchedule;
    for (const auto *ECV : Packs) {
      if (!ECV->isLeader()) continue;
      unsigned Instr = ECV->getData();
      if (getPackDependencies(Instr).none()) {
        ToSchedule.insert(Instr);
      }
    }
    std::vector<unsigned> Schedule;
    BitVector Scheduled(N);
    while (!ToSchedule.empty()) {
      unsigned Leader = ToSchedule.pop_back_val();
      if (Scheduled[Leader])
        // Already scheduled this pack
        continue;
      auto Deps = getPackDependencies(Leader);
      if (isSubset(Deps, Scheduled)) {
        // All deps have been scheduled
        for (unsigned Dependent : getPackDependents(Leader).set_bits()) {
          // Try to schedule all dependents
          ToSchedule.insert(Packs.getLeaderValue(Dependent));
        }
        // Schedule this instruction
        Schedule.push_back(Leader);
        Scheduled.set(Leader);
      }
    }
    // Clear basic block to insert new schedule
    for (auto Itr = MBB.begin(); Itr != MBB.end(); ) {
      (Itr++)->removeFromParent();
    }

    for (unsigned Leader : Schedule) {
      auto Range = Packs.members(Leader);
      ptrdiff_t NumPacked = std::distance(Range.begin(), Range.end());
      // auto *MI = Instrs[Leader];
      if (NumPacked == 1) {
        // Singleton pack
        // Emit same instruction
        MBB.insert(MBB.end(), Instrs[Leader]);
      } else {
        unsigned PackedSize = 0;
        SmallVector<MachineInstr *> pack;
        for (unsigned Instr : Range) {
          auto *MI = Instrs[Instr];
          pack.push_back(MI);
          PackedSize += (1 << memorySize(*MI));
        }
        std::sort(pack.begin(), pack.end(), [&](const MachineInstr *MI1, const MachineInstr *MI2) {
          return *AliasInfo.getInfo(*MI1, TRI).loc.offset < *AliasInfo.getInfo(*MI2, TRI).loc.offset;
        });
        auto PackedOpcode = StoreImmOpcode(PackedSize);
        int64_t PackedImm = 0;
        for (auto Itr = pack.rbegin(); Itr != pack.rend(); Itr++) {
          auto *MI = *Itr;
          PackedImm <<= (1 << memorySize(*MI)) * 8;
          PackedImm |= MI->getOperand(0).getImm();
        }
        std::bitset<32> set = PackedImm;
        std::cout << set << '\n';
        auto *Base = pack.front();
        DebugLoc DL;
        const auto *TII = TSI.getInstrInfo();
        BuildMI(MBB, MBB.end(), DL, TII->get(PackedOpcode))
          .addImm(PackedImm)
          .addReg(Base->getOperand(1).getReg().asMCReg())
          .addImm(Base->getOperand(2).getImm());
      }
    }
    outs() << "==========================\n";
  }
  return true;
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