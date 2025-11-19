//===-- AddVolatileGlobal.h - Insert a Volatile Global ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_UTILS_ADDVOLATILEGLOBAL_H
#define LLVM_TRANSFORMS_UTILS_ADDVOLATILEGLOBAL_H

#include "llvm/IR/PassManager.h"
#include "llvm/IR/GlobalVariable.h"

namespace llvm {

class AddVolatileGlobal : public PassInfoMixin<AddVolatileGlobal> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);
  GlobalVariable *getGlobalVariable();
private:
  GlobalVariable *GV = nullptr;
};

} // namespace llvm

#endif // LLVM_TRANSFORMS_UTILS_ADDVOLATILEGLOBAL_H
