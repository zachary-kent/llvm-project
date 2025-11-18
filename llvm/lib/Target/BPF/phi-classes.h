#pragma once

#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/EquivalenceClasses.h"
#include "llvm/IR/ValueMap.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstIterator.h"

#include <memory>

using namespace llvm;

// Whether a value represents a name
bool is_named(Value *Val) {
  return isa<Instruction>(Val) || isa<Argument>(Val);
}

// Calculate phi-function equivalence classes on instructions and arguments.
// Return a map from values to integer indices, and an array where each index is a vector of corresponding values
std::pair<
  std::unique_ptr<ValueMap<Value*, unsigned int>>,
  std::vector<std::vector<Value*>>
> aggregate_phis(Function &f) {
  EquivalenceClasses<Value*> ec;

  // Create a class for every argument
  for (auto &arg : f.args()) {
    ec.insert(&arg);
  }

  for (auto itr = inst_begin(f); itr != inst_end(f); ++itr) {
    // Create a class for every instruction
    ec.insert(&*itr);
    if (auto *Phi = dyn_cast<PHINode>(&*itr)) {
      for (auto &incoming : Phi->incoming_values()) {
        auto *Val = incoming.get();
        if (is_named(Val)) {
          // For every named incoming value to the Phi node, union
          // the classes of the Phi and those incoming values
          ec.insert(Val);
          ec.unionSets(Phi, Val);
        }
      }
    }
  }
  // value -> index
  auto res1 = std::make_unique<ValueMap<Value*, unsigned int>>();
  // index -> list of values
  std::vector<std::vector<Value*>> res2;
  // Iterate over every equivalence class
  for (auto c = ec.begin(); c != ec.end(); ++c) {
    // Add the members to both directions of the map
    auto idx = res2.size();
    std::vector<Value*> this_set;
    for (auto i = ec.member_begin(c); i != ec.member_end(); ++i) {
      (*res1)[*i] = idx;
      this_set.push_back(*i);
    }

    if (!this_set.empty()) {
      res2.push_back(std::move(this_set));
    }
  }

  return { std::move(res1), std::move(res2) };
}
