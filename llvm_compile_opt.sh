#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

[ $# -eq 1 ] || { echo "need exactly one argument - path to install llvm into "; exit 1; }

TARGET_DIR="$1"

cat << EOF > $SCRIPT_DIR/clang_opt
#!/bin/sh
$SCRIPT_DIR/build/bin/clang -mllvm=-bpf-enable-alias -mllvm=-bpf-enable-alignment -mllvm=-bpf-enable-slp -mllvm=-bpf-enable-fusion -mllvm=-bpf-enable-const-prop -mllvm=-bpf-enable-dce "\$@"
EOF

# $SCRIPT_DIR/build/bin/clang -mllvm=-bpf-enable-alias -mllvm=-bpf-enable-alignment -mllvm=-bpf-enable-slp -mllvm=-bpf-enable-fusion -mllvm=-bpf-enable-const-prop -mllvm=-bpf-enable-dce -mllvm=-bpf-enable-instrumentation "\$@"

chmod +x $SCRIPT_DIR/clang_opt

echo "Starting to compile and install LLVM into $TARGET_DIR"


pushd $SCRIPT_DIR/build

# Install our version
cmake -G Ninja \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_ASM_COMPILER=clang \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_USE_LINKER=lld \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_PROJECTS="clang" \
  -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
  ../llvm

ninja install

# MacroOp pass is put here
# ./build/lib/Target/BPF/CMakeFiles/LLVMBPFCodeGen.dir/BPFMacroOpFusion.cpp.o

popd

set -ex

$SCRIPT_DIR/compile_passes.sh
