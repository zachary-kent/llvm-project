#pragma once

#include <optional>
#include "llvm/Support/raw_ostream.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/Pass.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"

constexpr size_t NUM_BPF_REGS = 12;

struct Location {
  enum class Region {
    Packet,
    Stack,
    Context,
    Global
  };
  Region region;
  std::optional<int64_t> offset;
  Location();
  Location(Region region);
  Location(Region region, int64_t offset);
  bool disjoint(const Location &other) const;
  bool disjoint(const Location &other, unsigned Size1, unsigned Size2) const;
  bool adjacent(const Location &other, unsigned Size1, unsigned Size2) const;
  bool singleton(const Location &other) const;
  bool operator==(const Location &other) const;
  bool operator!=(const Location &other) const;
  std::optional<Location> meet(const Location &other) const;
  void add(int64_t offset);
  friend llvm::raw_ostream &operator<<(llvm::raw_ostream &OS, const Location &L);
};

struct LatticeElement {
  //       T
  //      / \
  //     DP DNP
  //      \ /
  //      
  enum class Level {
    Top, // Not a pointer
    Pointer, // Pointer residing in one region
    Bot // May alias any pointer
  };
  Level level;
  Location loc;
  LatticeElement();

  LatticeElement(Location loc);

  Location &getPointer();

  bool operator==(const LatticeElement &other) const;

  void meet(const LatticeElement &other);

  void addOffset(int64_t offset);
  bool disjoint(const LatticeElement &Other) const;
  bool disjoint(const LatticeElement &Other, unsigned Size1, unsigned Size2) const;
  bool adjacent(const LatticeElement &Other, unsigned Size1, unsigned Size2) const;


  friend llvm::raw_ostream &operator<<(llvm::raw_ostream &OS, const LatticeElement &LE);
};

llvm::MCRegister subRegToReg(llvm::MCRegister MCR);

class BPFAlias : public llvm::MachineFunctionPass {
public:
  using PointerInfo = std::array<LatticeElement, NUM_BPF_REGS>;
  static char ID;
  BPFAlias();
  bool runOnMachineFunction(llvm::MachineFunction &MF) override;
  llvm::StringRef getPassName() const override;
  llvm::DenseMap<llvm::MachineInstr*, PointerInfo> PointerIn;
  bool conflict(const llvm::MachineInstr &MI1, const llvm::MachineInstr &MI2) const;
  bool packable(const llvm::MachineInstr &MI1, const llvm::MachineInstr &MI2) const;
  const LatticeElement &getInfo(const llvm::MachineInstr &MI, llvm::MCRegister MCR) const;
  LatticeElement getInfo(const llvm::MachineInstr &MI) const;
};
