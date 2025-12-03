// TODO: make this an IR pass, not a machine pass

#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Value.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/AtomicOrdering.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include <unordered_map>

#include "BPF.h"
#include "Dataflow.h"
#include "llvm/IR/InstIterator.h"

using namespace llvm;

uint32_t get_alignment_of_object_size(uint32_t size) {
  if (size % 8 == 0)
    return 8;
  if (size % 4 == 0)
    return 4;
  if (size % 2 == 0)
    return 2;
  return 1;
}

inline int positive_modulo(int i, int n) { return (i % n + n) % n; }

PreservedAnalyses BPFDataAlignment::run(Function &F,
                                        FunctionAnalysisManager &FAM) {
  outs() << "Running BPF Data Alignment pass\n";

  // Data alignment:
  //  The compiler must produce code that is portable across architectures
  //  that have varying alignment needs, so an alignment of 1 is safe in all
  //  cases. However, this can result in suboptimal eBPF code generation. This
  //  pass attempts to find the maximum alignment of accesses allowing the
  //  instruction selection to make better choices.
  //
  // We will determine the offset of all pointers and set the pointer
  // alignment property to the highest value possible while maintaining
  // correctness.

  const auto &DL = F.getParent()->getDataLayout();

  DenseMap<Value *, unsigned> alignment_info;

  constexpr unsigned PTR_ALIGN = 8;

  // First, go through all instructions that generate pointers and setup values
  // in the map Function parameters can (in XDP, this is the CTX pointer for
  // example)
  for (auto &Arg : F.args()) {
    if (Arg.getType()->isPointerTy()) {
      alignment_info.try_emplace(&Arg, PTR_ALIGN);
    }
  }

  SetVector<Instruction *> Worklist;
  for (auto I = inst_begin(F); I != inst_end(F); I++) {
    if (I->getType()->isPointerTy()) {
      Worklist.insert(&*I);
    }
  }

  while (!Worklist.empty()) {
    auto *I = Worklist.pop_back_val();
    if (alignment_info.contains(I)) continue;
    std::optional<unsigned> Alignment;
    if (auto *Alloca = dyn_cast<AllocaInst>(I)) {
      auto size = DL.getTypeAllocSize(Alloca->getAllocatedType());
      uint32_t object_alignment = get_alignment_of_object_size(size);
      Alignment = object_alignment;
      // alignment_info.try_emplace(I, 0, size);
      // At this point, we might was well make sure the allocation alignment
      // actually has the same size as the data type being used
      // This is guaranteed to be safe, don't need the additional checks that
      // later alignment setting has
      // uint32_t object_alignment =
      // get_alignment_of_object_size_zero_is_1(size);
      Alloca->setAlignment(Align(object_alignment));
      outs() << "Setting aligment\n";
    } else if (isa<CallInst>(I)) {
      Alignment = PTR_ALIGN;
      // alignment_info[&I] = AlignInfo{0, 0};
    } else if (isa<IntToPtrInst>(I)) {
      Alignment = PTR_ALIGN;
      // AI.emplace(0);
      // alignment_info[&I] = AlignInfo{0, 0};
    } else if (auto *BC = dyn_cast<BitCastInst>(I)) {
      auto *Ptr = BC->getOperand(0);
      if (alignment_info.contains(Ptr)) {
        Alignment = alignment_info[Ptr];
      }
      // Alignment = alignment_info[Ptr];
      // AI.emplace(alignment_info[Ptr]);
      // auto ptr_original = alignment_info[ptr];
      // alignment_info[&I] = ptr_original;
    } else if (auto *SI = dyn_cast<SelectInst>(I)) {
      auto *Tru = SI->getTrueValue();
      auto *Fls = SI->getFalseValue();
      if (alignment_info.contains(Tru) && alignment_info.contains(Fls)) {
        Alignment = std::min(alignment_info[Tru], alignment_info[Fls]);
      }
    } else if (auto *Phi = dyn_cast<PHINode>(I)) {
      // Get the minimum alignment of all incoming nodes
      Alignment = PTR_ALIGN;
      for (auto &Use : Phi->incoming_values()) {
        auto *Val = Use.get();
        if (isa<ConstantPointerNull>(Val)) {
          continue;
        }
        if (!alignment_info.contains(Val)) {
          // no info
          Alignment.reset();
          break;
        }
        Alignment = std::min(*Alignment, alignment_info[Val]);
      }
      // alignment_info[&I] = AlignInfo{offset, 0};
    } else if (auto *GEP = dyn_cast<GetElementPtrInst>(I)) {
      auto *Ptr = GEP->getPointerOperand();
      if (!alignment_info.contains(Ptr)) {
        continue;
      }
      unsigned PtrAlign = alignment_info[Ptr];

      // GEP has multiple variants with different number of operands
      // Sometimes there are pointers, sometimes just constants
      // Example: Second is pointer, 3rd is offset into array, and 4th is offset
      // into struct If not struct, that index into field not needed. If not
      // array, the array offset also missing

      // Now, we calculate the accumulate offset of the reference
      APInt Offset(DL.getIndexSizeInBits(Ptr->getType()->getPointerAddressSpace()), 0,
        /* isSigned= */ true);
      if (GEP->accumulateConstantOffset(DL, Offset)) {
        Alignment =
            positive_modulo(Offset.getSExtValue() + PtrAlign, PTR_ALIGN);
        if (*Alignment == 0)
          Alignment = 8;
      }
    }
    if (Alignment) {
      assert(*Alignment != 0);
      alignment_info[I] = *Alignment;
      for (auto *User : I->users()) {
        if (auto *UserInstr = dyn_cast<Instruction>(User)) {
          Worklist.insert(UserInstr);
        }
      }
    }
  }

  auto newAlign = [&](Value *Ptr, Type *Ty) -> std::optional<unsigned> {
    if (!alignment_info.contains(Ptr)) return {};
    auto Size = DL.getTypeAllocSize(Ty);
    auto SizeAlign = get_alignment_of_object_size(Size);
    return std::min(SizeAlign, alignment_info[Ptr]);
  };

  // Now that we have seen all pointers to all
  // all allocated objects (throughs allocs, returned objects from functions,
  // etc) Go through all instructions, find the stores and the loads, and change
  // their alignment to match the maximum size they should be

  for (auto &BB : F) {
    for (auto &I : BB) {
      if (auto *Load = dyn_cast<LoadInst>(&I)) {
        auto *Source = Load->getPointerOperand();
        uint32_t old_alignment = Load->getAlign().value();
        auto new_alignment = newAlign(Source, Load->getType());
        if (!new_alignment || *new_alignment > old_alignment) continue;
        Load->setAlignment(Align(*new_alignment));
        outs() << "Set alignment\n";
      } else if (auto *Store = dyn_cast<StoreInst>(&I)) {
        auto *Dest = Store->getPointerOperand();
        uint32_t old_alignment = Store->getAlign().value(); 
        auto new_alignment = newAlign(Dest, Store->getValueOperand()->getType());
        if (!new_alignment || *new_alignment > old_alignment) continue;
        Store->setAlignment(Align(*new_alignment));
        outs() << "Set alignment\n";
      } 
      // else if (auto *Call = dyn_cast<CallInst>(&I)) {
      //   // By default, we cannot detect that pointers in the memcpys are aligned
      //   // But in reality they are and it is used commonly in the things we are
      //   // using
      //   //  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4
      //   //  dereferenceable(16) They really should be aligned to 8
      //   auto *CalledFunction = Call->getCalledFunction();
      //   if (!CalledFunction || !CalledFunction->getName().starts_with("llvm.memcpy.p0.p0.i64"))
      //     continue;
      //   auto Arg0 = Call->getArgOperand(0);
      //   auto Arg1 = Call->getArgOperand(1);
      //   dyn_cast<PointerType>(Arg0->getType())->getEle
      //   auto Align0 = getAlign

      //   if (called_function) {
      //     if (called_function->getName().starts_with("llvm.memcpy.p0.p0.i64")) {
      //       auto arg0 = call->getOperand(0);
      //       auto arg1 = call->getOperand(1);

      //       auto arg0_ptr_info = alignment_info[arg0];
      //       auto arg1_ptr_info = alignment_info[arg1];

      //       uint32_t arg0_new_alignment =
      //           generate_new_alignment(arg0_ptr_info, 1);
      //       uint32_t arg1_new_alignment =
      //           generate_new_alignment(arg1_ptr_info, 1);

      //       // Replace the original alignment of these attributes with these new
      //       // values This changes it AT THE FUNCTION (not the callsite).
      //       auto al = call->getAttributes();
      //       al = al.removeAttributeAtIndex(F.getContext(), 1,
      //                                      Attribute::Alignment);
      //       al = al.removeAttributeAtIndex(F.getContext(), 2,
      //                                      Attribute::Alignment);

      //       Attribute at = Attribute::get(F.getContext(), Attribute::Alignment,
      //                                     arg0_new_alignment);
      //       al = al.addAttributeAtIndex(F.getContext(), 1, at);

      //       at = Attribute::get(F.getContext(), Attribute::Alignment,
      //                           arg1_new_alignment);
      //       al = al.addAttributeAtIndex(F.getContext(), 2, at);

      //       call->setAttributes(al);
      //     }
      //   }
      // }
    }
  }
  // return something to indicate whether the CFG was changed
  return PreservedAnalyses::none();
};

/* New PM Registration */
llvm::PassPluginLibraryInfo getBPFDataAlignPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "bpfalign", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, llvm::FunctionPassManager &PM,
                   ArrayRef<llvm::PassBuilder::PipelineElement>) {
                  if (Name == "bpfalign") {
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
