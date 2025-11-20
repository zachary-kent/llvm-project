#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd $SCRIPT_DIR/build/bin

# ./clang -O3 -target bpf -c ../../prog.c -o prog.ll -emit-llvm
./clang -O3 -g -target bpf -c ../../prog.c -o prog.o
# ./llc -march=bpf -filetype=obj proc.ll -o proc.o

popd
