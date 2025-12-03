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
#include <unordered_map>

#include "Dataflow.h"
#include "BPF.h"

using namespace llvm;

struct AlignInfo {
  uint64_t offset;
  uint64_t known_size;
};

uint32_t get_alignment_of_object_size(uint32_t size){
  if (size % 8 == 0) return 8;
  if (size % 4 == 0) return 4;
  if (size % 2 == 0) return 2;
  return 1;
}

uint32_t get_alignment_of_object_size_zero_is_1(uint32_t size){
  if (size == 0) return 1;
  if (size % 8 == 0) return 8;
  if (size % 4 == 0) return 4;
  if (size % 2 == 0) return 2;
  return 1;
}

uint32_t generate_new_alignment(AlignInfo& align_info, uint32_t current_alignment){
  // This is the ideal alignment based on the object allocation size
  uint32_t alignment_candidate = get_alignment_of_object_size(align_info.offset);

  // However, the object may be misaligned when allocated
  // and if so, we cannot break this alignment
  uint32_t alignment_candidate_due_to_object_size = alignment_candidate;
  // Zero is default - unknown size
  if (align_info.known_size){
    alignment_candidate_due_to_object_size = get_alignment_of_object_size(align_info.known_size);
  }
  
  alignment_candidate = std::min(alignment_candidate,alignment_candidate_due_to_object_size);

  return std::max(alignment_candidate, current_alignment);
}

PreservedAnalyses BPFDataAlignment::run(Function &F, FunctionAnalysisManager &FAM) {
  outs() << "Running BPF Data Alignment pass\n";


  // Data alignment:
  //  The compiler must produce code that is portable across architectures
  //  that have varying alignment needs, so an alignment of 1 is safe in all cases. 
  //  However, this can result in suboptimal eBPF code generation.
  //  This pass attempts to find the maximum alignment of accesses allowing
  //  the instruction selection to make better choices.
  // 
  // We will determine the offset of all pointers and set the pointer
  // alignment property to the highest value possible while maintaining correctness.

  const DataLayout& data_layout = F.getParent()->getDataLayout();


  std::unordered_map<const Value*, AlignInfo> alignment_info;

  // First, go through all instructions that generate pointers and setup values in the map
  // Function parameters can (in XDP, this is the CTX pointer for example)
    for (auto& arg : F.args()) {
      if (arg.getType()->isPointerTy()){
          alignment_info[&arg] = AlignInfo(
            0,
            0
          );
      }
  }

  for(auto& BB : F) {
    for(auto& I : BB){

      // If this instruction produces a pointer
      // Examples: alloca, getelementptr, call, IntToPtrInst, pointer conversions 
      if (I.getType()->isPointerTy()){

        if (auto* alloca = dyn_cast<AllocaInst>(&I)){
          auto size = data_layout.getTypeAllocSize(alloca->getAllocatedType());
          alignment_info[&I] = AlignInfo{
            0,
            size
          };
          // At this point, we might was well make sure the allocation alignment
          // actually has the same size as the data type being used
          // This is guaranteed to be safe, don't need the additional checks that later alignment setting has
          auto object_alignment = get_alignment_of_object_size_zero_is_1(size);
          alloca->setAlignment(Align(object_alignment));
        } else if (auto* call = dyn_cast<CallInst>(&I)){
          alignment_info[&I] = AlignInfo{
            0,
            0
          };
        } else if (auto* ptr_conversion = dyn_cast<IntToPtrInst>(&I)){
          alignment_info[&I] = AlignInfo{
            0,
            0
          };
        } else if (auto* bitcast = dyn_cast<BitCastInst>( &I)){
          auto ptr = bitcast->getOperand(0);
          auto ptr_original = alignment_info[ptr];
          alignment_info[&I] = ptr_original;
        } else if (auto* select = dyn_cast<SelectInst>(&I)){
          auto ptr = bitcast->getOperand(1);
          auto ptr_original = alignment_info[ptr];

          alignment_info[&I] = AlignInfo{
            ptr_original.offset,
            ptr_original.known_size,
          };
        } else if (auto* phi = dyn_cast<PHINode>(&I)){
          // Get the minimum alignment of all incoming nodes
          uint64_t offset = 0;
          for (auto& val : phi->incoming_values()) {
            if (isa<ConstantPointerNull>(val)) {continue;}
            auto value = val.get();
            auto src = alignment_info[value];
            if(offset == 0){
              offset = src.offset;
            } else {
              offset = std::min(offset,src.offset);
            }
          }
          
          alignment_info[&I] = AlignInfo{
            offset,
            0
          };
        } else if (auto* gep = dyn_cast<GetElementPtrInst>(&I)){
          auto ptr = gep->getPointerOperand();
          if(!alignment_info.contains(ptr)){
            outs() << "Came across GEP instruction that references a pointer that we haven't seen yet " << *gep << "\n";
            continue;
          }
          auto ptr_info = alignment_info[ptr];

          // This is the type that the original pointer points to
          // This is a type (i32...) that the base pointer points to
          // If a struct - return struct type
          // If array - return type of array element
          Type* target_data_type = gep->getSourceElementType();
          auto target_data_type_size = data_layout.getTypeAllocSize(target_data_type).getFixedValue();

          // GEP has multiple variants with different number of operands
          // Sometimes there are pointers, sometimes just constants
          // Example: Second is pointer, 3rd is offset into array, and 4th is offset into struct
          // If not struct, that index into field not needed.
          // If not array, the array offset also missing
          
          // Now, we calculate the accumulate offset of the reference
          uint64_t accumulated_offset = 0; 

          bool is_constant_index = true;
          // Here, we 
          for (unsigned int i = 1; i < gep->getNumOperands(); i++) {
            auto operand = gep->getOperand(i);
            
            if(auto* constant = dyn_cast<Constant>(operand)){

              // Only constantINT specifically has this property
              int64_t real_value = dyn_cast<ConstantInt>(constant)->getSExtValue();

              // Base offset
              if (i == 1){
                  accumulated_offset += real_value * target_data_type_size;
              } else if (real_value >= 0){
                  // Else, this is the second operand, which is the offset into the type that the base offset is referencing
                  if (auto* struct_type = dyn_cast<StructType>(target_data_type)){
                      // Each type is not necessarily the same, so just need to accumulate the,
                      for (auto j = 0; j < real_value; j++){
                          target_data_type = struct_type->getElementType(j);
                          target_data_type_size = data_layout.getTypeAllocSize(target_data_type).getFixedValue();
                          accumulated_offset += target_data_type_size;
                      }
                      target_data_type = struct_type->getElementType(real_value);

                  } else if(auto* array_type = dyn_cast<ArrayType>(target_data_type)){
                      target_data_type = array_type->getArrayElementType();
                      target_data_type_size = data_layout.getTypeAllocSize(target_data_type).getFixedValue();
                      accumulated_offset += real_value * target_data_type_size;

                  } else if(auto* vec_type = dyn_cast<VectorType>(target_data_type)){
                      target_data_type = vec_type->getElementType();
                      target_data_type_size = data_layout.getTypeAllocSize(target_data_type).getFixedValue();
                      accumulated_offset += real_value * target_data_type_size;

                  } else {
                    is_constant_index = false;
                    outs() << *gep << " Accessing unknown type! Ignoring this GEP instruction\n";
                  }
              }
            } else {
              // It's a non-constant offset
              is_constant_index = false;
              alignment_info[&I] = AlignInfo(
                0,
                ptr_info.known_size
              );
            }

            if(is_constant_index){
              alignment_info[&I] = AlignInfo(
                ptr_info.offset + accumulated_offset,
                ptr_info.known_size
              );
            }
          }
        }
      }
    }
  }

  // Now that we have seen all pointers to all
  // all allocated objects (throughs allocs, returned objects from functions, etc)
  // Go through all instructions, find the stores and the loads, and change their alignment to match
  // the maximum size they should be

  for(auto& BB : F) {
    for(auto& I : BB){
      if(auto* load = dyn_cast<LoadInst>(&I)){
        auto ptr = load->getPointerOperand();
        uint32_t old_alignment = load->getAlign().value();
        if(!alignment_info.contains(ptr)) {
          outs() << "Seeing pointer for first time." << *load << "\n";
          continue;
        }
        uint32_t new_alignment = generate_new_alignment(alignment_info[ptr], old_alignment);

        if(old_alignment != new_alignment) {
          load->setAlignment(Align(new_alignment));
          outs() << "Setting alignment." << *load << "Old: " << old_alignment << " New: "  << new_alignment << "\n";
        }
      } else if (auto* store = dyn_cast<StoreInst>(&I)){
        auto ptr = store->getPointerOperand();
        uint32_t old_alignment = store->getAlign().value();
        if(!alignment_info.contains(ptr)) {
          outs() << "Seeing pointer for first time." << *store << "\n";
          continue;
        }

        uint32_t new_alignment = generate_new_alignment(alignment_info[ptr], old_alignment);

        if(old_alignment != new_alignment) {
          store->setAlignment(Align(new_alignment));
          outs() << "Setting alignment." << *store << "Old: " << old_alignment << " New: "  << new_alignment << "\n";
        }
      }
    }
  }
  // return something to indicate whether the CFG was changed
  return PreservedAnalyses::none();
};



/* New PM Registration */
llvm::PassPluginLibraryInfo getBPFDataAlignPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "bpfalign", LLVM_VERSION_STRING,
    [](PassBuilder &PB){
        PB.registerPipelineParsingCallback(
              [](StringRef Name, llvm::FunctionPassManager &PM,
                  ArrayRef<llvm::PassBuilder::PipelineElement>) {
                if(Name == "bpfalign") {
                  PM.addPass(BPFDataAlignment());
                  return true;
                }
                return false;
          });
    }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getBPFDataAlignPluginInfo();
}

