#pragma once

#include <optional>
#include "llvm/Support/raw_ostream.h"

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

  friend llvm::raw_ostream &operator<<(llvm::raw_ostream &OS, const LatticeElement &LE);
};

class BPFAlias : public llvm::MachineFunctionPass {
public:
  using PointerInfo = std::array<LatticeElement, NUM_BPF_REGS>;
  static char ID;
  BPFAlias();
  bool runOnMachineFunction(llvm::MachineFunction &MF) override;
  llvm::StringRef getPassName() const override;
  llvm::DenseMap<llvm::MachineInstr*, PointerInfo> PointerIn;
};
