//===-- AddVolatileGlobal.cpp - Example Transformations --------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//


#include "llvm/Transforms/Utils/AddVolatileGlobal.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/Constants.h"

using namespace llvm;

PreservedAnalyses AddVolatileGlobal::run(Module &M,
                                      ModuleAnalysisManager &AM) {

  
  auto *Ty = Type::getInt64Ty(M.getContext());
  GV = new GlobalVariable(
    M,
    Ty,
    false,
    GlobalVariable::ExternalLinkage,
    Constant::getNullValue(Ty),
    "dyn_inst_cnt",
    nullptr,
    GlobalVariable::NotThreadLocal,
    std::nullopt,
    true
  );
  return PreservedAnalyses::none();
}

GlobalVariable *AddVolatileGlobal::getGlobalVariable() {
  return GV;
}
