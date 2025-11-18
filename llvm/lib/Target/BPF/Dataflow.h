#pragma once

#include <stdio.h>
#include <iostream>
#include <queue>
#include <vector>

#include "llvm/IR/Instructions.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/IR/ValueMap.h"
#include "llvm/IR/CFG.h"

namespace llvm {

	enum class Direction {
		Forward,
		Backward
	};

	template<typename T, typename BlockT>
	struct Parameters {
		Direction direction;
		T top;
		T boundary;
		std::function<void(T&, const T&)> meet;
		std::function<void(BlockT&, T&)> transfer;
	};

	// A pair of dataflow values, the IN and OUT value
	// for every basic block
	template<typename T>
	struct Values {
		T in;
		T out;
	};

	template<typename T, typename FnT, typename BlockT>
	DenseMap<BlockT*, Values<T>> compute(const Parameters<T, BlockT> &params, FnT &F) {
		DenseMap<BlockT*, Values<T>> values;
		// Initialize every dataflow value to top
		for (auto &BB : F) {
			values[&BB] = { .in = params.top, .out = params.top };
		}
		switch (params.direction) {
			case Direction::Forward: {
				// For forward analyses, initialize the input of the entry block to the boundary value
				values[&F.front()].in = params.boundary;
				break;
			}
			case Direction::Backward:
				// For backward analyses, initialize the output of every exit block
				// (i.e., those with no successors) to the boundary value
				for (auto &BB : F) {
					if (succ_size(&BB) == 0) {
						values[&BB].out = params.boundary;
					}
				}
				break;
		}
		// worklist of nodes to visit for dataflow analysis, initialized to all nodes
		SetVector<BlockT*> worklist;
		for (auto &BB : F) {
			worklist.insert(&BB);
		}
		while (!worklist.empty()) {
			auto *BB = worklist.pop_back_val();
			switch (params.direction) {
				case Direction::Forward: {
					if (pred_size(BB) > 0) {
						// if this block is not an entry block, compute the input by
						// meeting the dataflow flows of all of the predecessors
						T in = params.top;
						for (auto *pred : predecessors(BB)) {
							params.meet(in, values[pred].out);
						}
						values[BB].in = in;
					}
					T val = values[BB].in;
					// Compute the output value using the transfer function
					params.transfer(*BB, val);
					if (val != values[BB].out) {
						// if the value changed, insert all successors into the worklist
						values[BB].out = val;
						for (auto *succ : successors(BB)) {
							worklist.insert(succ);
						}
					}
					break;
				}
				case Direction::Backward: {
					// And dually for backward passes
					if (succ_size(BB) > 0) {
						T out = params.top;
						for (auto *succ : successors(BB)) {
							params.meet(out, values[succ].in);
						}
						values[BB].out = out;
					}
					T val = values[BB].out;
					params.transfer(*BB, val);
					if (val != values[BB].in) {
						values[BB].in = val;
						for (auto *pred : predecessors(BB)) {
							worklist.insert(pred);
						}
					}
					break;
				}
			}
		}
		return values;
	}

} // end namespace llvm
