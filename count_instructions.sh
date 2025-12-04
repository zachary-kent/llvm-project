#!/bin/bash

# Script to gather static instruction counts with different optimization configurations
# Performs ablation study by removing one optimization at a time

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Check if source file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <source_file.c>"
    exit 1
fi

SOURCE_FILE="$1"
SOURCE_NAME=$(basename "$SOURCE_FILE" .c)

# Create output directories
mkdir -p bench/baseline bench/opt bench/ablation

CLANG="$SCRIPT_DIR/build/llvm/bin/clang"
OPT="$SCRIPT_DIR/build/llvm/bin/opt"
LLC="$SCRIPT_DIR/build/llvm/bin/llc"

# IR passes
IR_PASSES="bpfalign,bpffusion"
ALIGN_PLUGIN="$SCRIPT_DIR/align.so"
FUSION_PLUGIN="$SCRIPT_DIR/fusion.so"

# LLC passes
LLC_PASSES="-bpf-enable-const-prop -bpf-enable-dce -bpf-enable-slp -bpf-enable-count"

echo "========================================="
echo "Static Instruction Count Analysis"
echo "Source: $SOURCE_FILE"
echo "========================================="
echo

# Function to extract instruction count from LLC output
extract_count() {
    grep -oP '\d+(?= [Ii]nstructions)' | head -1
}

# Baseline: no optimizations
echo "Building baseline (no optimizations)..."
$CLANG -S -g -target bpf -O2 -emit-llvm "$SOURCE_FILE" -o "bench/baseline/${SOURCE_NAME}.ll" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj -bpf-enable-count "bench/baseline/${SOURCE_NAME}.ll" -o "bench/baseline/${SOURCE_NAME}.o" 2>&1 | tee /tmp/baseline_output.txt > /dev/null
BASELINE_COUNT=$(cat /tmp/baseline_output.txt | extract_count)
[ -z "$BASELINE_COUNT" ] && BASELINE_COUNT=0
echo "Baseline: $BASELINE_COUNT instructions"
echo

# Full optimizations
echo "Building with all optimizations..."
$CLANG -S -g -target bpf -O2 -emit-llvm "$SOURCE_FILE" -o "bench/baseline/${SOURCE_NAME}.ll" 2>&1 > /dev/null
$OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/opt/${SOURCE_NAME}.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj $LLC_PASSES "bench/opt/${SOURCE_NAME}.bc" -o "bench/opt/${SOURCE_NAME}.o" 2>&1 | tee /tmp/full_output.txt > /dev/null
FULL_COUNT=$(cat /tmp/full_output.txt | extract_count)
[ -z "$FULL_COUNT" ] && FULL_COUNT=0
echo "All optimizations: $FULL_COUNT instructions"
echo

echo "========================================="
echo "Ablation Study (removing one at a time)"
echo "========================================="
echo

# Ablation: No IR passes (only LLC passes)
echo "Testing: No IR passes (alignment + fusion)..."
$LLC -march=bpf -filetype=obj $LLC_PASSES "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_ir.o" 2>&1 | tee /tmp/no_ir_output.txt > /dev/null
NO_IR_COUNT=$(cat /tmp/no_ir_output.txt | extract_count)
[ -z "$NO_IR_COUNT" ] && NO_IR_COUNT=0
echo "No IR passes: $NO_IR_COUNT instructions"
echo

# Ablation: No alignment
echo "Testing: No alignment (fusion + LLC passes)..."
$OPT -load-pass-plugin="$FUSION_PLUGIN" -passes="bpffusion" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_align.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj $LLC_PASSES "bench/ablation/${SOURCE_NAME}_no_align.bc" -o "bench/ablation/${SOURCE_NAME}_no_align.o" 2>&1 | tee /tmp/no_align_output.txt > /dev/null
NO_ALIGN_COUNT=$(cat /tmp/no_align_output.txt | extract_count)
[ -z "$NO_ALIGN_COUNT" ] && NO_ALIGN_COUNT=0
echo "No alignment: $NO_ALIGN_COUNT instructions"
echo

# Ablation: No fusion
echo "Testing: No fusion (alignment + LLC passes)..."
$OPT -load-pass-plugin="$ALIGN_PLUGIN" -passes="bpfalign" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_fusion.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj $LLC_PASSES "bench/ablation/${SOURCE_NAME}_no_fusion.bc" -o "bench/ablation/${SOURCE_NAME}_no_fusion.o" 2>&1 | tee /tmp/no_fusion_output.txt > /dev/null
NO_FUSION_COUNT=$(cat /tmp/no_fusion_output.txt | extract_count)
[ -z "$NO_FUSION_COUNT" ] && NO_FUSION_COUNT=0
echo "No fusion: $NO_FUSION_COUNT instructions"
echo

# Ablation: No const-prop
echo "Testing: No const-prop (IR passes + other LLC passes)..."
$OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_cprop.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj -bpf-enable-dce -bpf-enable-slp -bpf-enable-count \
    "bench/ablation/${SOURCE_NAME}_no_cprop.bc" -o "bench/ablation/${SOURCE_NAME}_no_cprop.o" 2>&1 | tee /tmp/no_cprop_output.txt > /dev/null
NO_CPROP_COUNT=$(cat /tmp/no_cprop_output.txt | extract_count)
[ -z "$NO_CPROP_COUNT" ] && NO_CPROP_COUNT=0
echo "No const-prop: $NO_CPROP_COUNT instructions"
echo

# Ablation: No DCE
echo "Testing: No DCE (IR passes + other LLC passes)..."
$OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_dce.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj -bpf-enable-const-prop -bpf-enable-slp -bpf-enable-count \
    "bench/ablation/${SOURCE_NAME}_no_dce.bc" -o "bench/ablation/${SOURCE_NAME}_no_dce.o" 2>&1 | tee /tmp/no_dce_output.txt > /dev/null
NO_DCE_COUNT=$(cat /tmp/no_dce_output.txt | extract_count)
[ -z "$NO_DCE_COUNT" ] && NO_DCE_COUNT=0
echo "No DCE: $NO_DCE_COUNT instructions"
echo

# Ablation: No SLP
echo "Testing: No SLP (IR passes + other LLC passes)..."
$OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_slp.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj -bpf-enable-const-prop -bpf-enable-dce -bpf-enable-count \
    "bench/ablation/${SOURCE_NAME}_no_slp.bc" -o "bench/ablation/${SOURCE_NAME}_no_slp.o" 2>&1 | tee /tmp/no_slp_output.txt > /dev/null
NO_SLP_COUNT=$(cat /tmp/no_slp_output.txt | extract_count)
[ -z "$NO_SLP_COUNT" ] && NO_SLP_COUNT=0
echo "No SLP: $NO_SLP_COUNT instructions"
echo

# Summary
echo "========================================="
echo "Summary"
echo "========================================="
echo "Baseline (no opts):           $BASELINE_COUNT instructions"
echo "All optimizations:            $FULL_COUNT instructions"
echo "  Reduction: $(($BASELINE_COUNT - $FULL_COUNT)) instructions ($(echo "scale=2; 100 * ($BASELINE_COUNT - $FULL_COUNT) / $BASELINE_COUNT" | bc)%)"
echo
echo "Ablation Study Results:"
echo "  No IR passes:               $NO_IR_COUNT instructions (impact: $(($NO_IR_COUNT - $FULL_COUNT)))"
echo "  No alignment:               $NO_ALIGN_COUNT instructions (impact: $(($NO_ALIGN_COUNT - $FULL_COUNT)))"
echo "  No fusion:                  $NO_FUSION_COUNT instructions (impact: $(($NO_FUSION_COUNT - $FULL_COUNT)))"
echo "  No const-prop:              $NO_CPROP_COUNT instructions (impact: $(($NO_CPROP_COUNT - $FULL_COUNT)))"
echo "  No DCE:                     $NO_DCE_COUNT instructions (impact: $(($NO_DCE_COUNT - $FULL_COUNT)))"
echo "  No SLP:                     $NO_SLP_COUNT instructions (impact: $(($NO_SLP_COUNT - $FULL_COUNT)))"
echo "========================================="
