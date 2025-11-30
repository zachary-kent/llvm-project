// TODO: make this an IR pass, not a machine pass

#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/IR/Value.h"
#include "llvm/Pass.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/AtomicOrdering.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/IRBuilder.h"

#include "Dataflow.h"
#include "BPF.h"

using namespace llvm;


bool is_valid_candidate(unsigned int opcode) {
  return opcode == Instruction::Add
    || opcode == Instruction::And
    || opcode == Instruction::Xor
    || opcode == Instruction::Or;
}

AtomicRMWInst::BinOp map_to_target_atomic(unsigned int opcode) {
  switch(opcode){
    case Instruction::Add: return AtomicRMWInst::BinOp::Add;
    case Instruction::And: return AtomicRMWInst::BinOp::And;
    case Instruction::Xor: return AtomicRMWInst::BinOp::Xor;
    case Instruction::Or: return AtomicRMWInst::BinOp::Or;
    default: {
      outs() << "Invalid instruction" << opcode << "\n";
      assert("Invalid instruction");
    }
  }
  outs() << "Invalid instruction" << opcode << "\n";
  assert("Invalid instruction");
}

PreservedAnalyses BPFMacroOpFusion::run(Function &F, FunctionAnalysisManager &FAM) {
  outs() << "Running MacroOpFusion pass\n";

  // This passes does conversions on the following pattern of instructions:
  // LOAD x from memory, BINARY OPERATION on x, STORE x back to memory
  // BPF has the following binary operations on atomics:
  //  ADD, OR, AND, XOR
  // LLVM also supports atomics read/operate/write at the IR level in the form of:
  //  AtomicRMWInst:: AND, XOR, OR, and AND
  // We search for these patterns and swap the instruction sequences
  //  Must check that target addresses of the load/store are identical, and that the load/binary operation instructions only have one user

  for(auto &BB : F) {
    for(auto &I : BB){
      if (LoadInst* load_instruction = dyn_cast<LoadInst>(&I)){
        // Ensure the load only has only one user - we check below that it's the binary operation instruction
        if(!load_instruction->hasOneUser()) continue;
        
        // Doing dyn_cast first makes code cleaner (don't have to check for the load being the last instruction)
        if(BinaryOperator* operation = dyn_cast<BinaryOperator>(load_instruction->getNextNode())){
          if(!is_valid_candidate(operation->getOpcode())) continue;

          // Now, check that one of the operands to the binary operation is the result of the load instruction
          auto op1 = operation->getOperand(0);
          auto op2 = operation->getOperand(1);
          
          Value* other_operand;
          if(op1 == load_instruction) {
            other_operand = op2;
          } else if (op2 == load_instruction) {
            other_operand = op1;
          } else {
            // We don't use the load instruction result
            continue;
          }

          // Now check for the store instruction
          if(StoreInst* store_instruction = dyn_cast<StoreInst>(operation->getNextNode())){
            
            // Ensure the binary operation has user and that it is the store instruction
            if(operation->hasOneUser() && *operation->user_begin() == store_instruction) {
              // Ensure the load and the store go to the same place
              if (store_instruction->getPointerOperand() != load_instruction->getPointerOperand()) continue;
              
              outs() << "Candidate seen" << *load_instruction << "\n" << *operation << "\n" << *store_instruction << "\n";

              // We are now free to do the swap!
              auto target_atomic_opcode = map_to_target_atomic(operation->getOpcode());
              
              // We are iterating in place. To not break the iterator
              // place the instrution before the binary operator (we haven't got there yet)
              IRBuilder<> builder(operation);

              auto inserted_instruction = builder.CreateAtomicRMW(
                target_atomic_opcode,
                store_instruction->getPointerOperand(),
                other_operand,
                store_instruction->getAlign(),
                AtomicOrdering::Monotonic
              );

              store_instruction->eraseFromParent();
              operation->eraseFromParent();

              // DO NOT REMOVE THE LOAD INSTRUCTION
              // DCE will get rid of the load instruction
              // This will otherwise break the iterator.
              // 
              // load_instruction->eraseFromParent();
            }
          }
        }
      }
    }
  }

  // return something to indicate whether the CFG was changed
  return PreservedAnalyses::none();
};


/* New PM Registration */
llvm::PassPluginLibraryInfo getBPFMacroOpFusionPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "bpffusion", LLVM_VERSION_STRING,
    [](PassBuilder &PB){
        PB.registerPipelineParsingCallback(
              [](StringRef Name, llvm::FunctionPassManager &PM,
                  ArrayRef<llvm::PassBuilder::PipelineElement>) {
                if(Name == "bpffusion") {
                  PM.addPass(BPFMacroOpFusion());
                  return true;
                }
                return false;
          });
    }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getBPFMacroOpFusionPluginInfo();
}

