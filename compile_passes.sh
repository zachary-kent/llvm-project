#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


clang -shared -o ir_passes/align.so $SCRIPT_DIR/build/lib/Target/BPF/CMakeFiles/LLVMBPFCodeGen.dir/BPFDataAlignment.cpp.o
clang -shared -o ir_passes/fusion.so $SCRIPT_DIR/build/lib/Target/BPF/CMakeFiles/LLVMBPFCodeGen.dir/BPFMacroOpFusion.cpp.o

