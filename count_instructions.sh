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
echo "Ablation Study (removing one by one)"
echo "========================================="
echo

# Ablation: Remove optimizations one by one, starting from full
echo "Testing: All optimizations (baseline for ablation)..."
# Already computed as FULL_COUNT
echo "All opts: $FULL_COUNT instructions"
echo

# Ablation: Remove SLP first
echo "Testing: Remove SLP..."
$OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_slp.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj -bpf-enable-const-prop -bpf-enable-dce -bpf-enable-count \
    "bench/ablation/${SOURCE_NAME}_no_slp.bc" -o "bench/ablation/${SOURCE_NAME}_no_slp.o" 2>&1 | tee /tmp/no_slp_output.txt > /dev/null
NO_SLP_COUNT=$(cat /tmp/no_slp_output.txt | extract_count)
[ -z "$NO_SLP_COUNT" ] && NO_SLP_COUNT=0
echo "No SLP: $NO_SLP_COUNT instructions"
echo

# Ablation: Remove SLP + DCE
echo "Testing: Remove SLP + DCE..."
$OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_slp_dce.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj -bpf-enable-const-prop -bpf-enable-count \
    "bench/ablation/${SOURCE_NAME}_no_slp_dce.bc" -o "bench/ablation/${SOURCE_NAME}_no_slp_dce.o" 2>&1 | tee /tmp/no_slp_dce_output.txt > /dev/null
NO_SLP_DCE_COUNT=$(cat /tmp/no_slp_dce_output.txt | extract_count)
[ -z "$NO_SLP_DCE_COUNT" ] && NO_SLP_DCE_COUNT=0
echo "No SLP + DCE: $NO_SLP_DCE_COUNT instructions"
echo

# Ablation: Remove SLP + DCE + const-prop
echo "Testing: Remove SLP + DCE + const-prop..."
$OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_slp_dce_cp.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj -bpf-enable-count \
    "bench/ablation/${SOURCE_NAME}_no_slp_dce_cp.bc" -o "bench/ablation/${SOURCE_NAME}_no_slp_dce_cp.o" 2>&1 | tee /tmp/no_slp_dce_cp_output.txt > /dev/null
NO_SLP_DCE_CP_COUNT=$(cat /tmp/no_slp_dce_cp_output.txt | extract_count)
[ -z "$NO_SLP_DCE_CP_COUNT" ] && NO_SLP_DCE_CP_COUNT=0
echo "No SLP + DCE + CP: $NO_SLP_DCE_CP_COUNT instructions"
echo

# Ablation: Remove SLP + DCE + const-prop + fusion
echo "Testing: Remove SLP + DCE + const-prop + fusion..."
$OPT -load-pass-plugin="$ALIGN_PLUGIN" -passes="bpfalign" \
    "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_slp_dce_cp_fusion.bc" 2>&1 > /dev/null
$LLC -march=bpf -filetype=obj -bpf-enable-count \
    "bench/ablation/${SOURCE_NAME}_no_slp_dce_cp_fusion.bc" -o "bench/ablation/${SOURCE_NAME}_no_slp_dce_cp_fusion.o" 2>&1 | tee /tmp/no_slp_dce_cp_fusion_output.txt > /dev/null
NO_SLPDCECPFUSION_COUNT=$(cat /tmp/no_slp_dce_cp_fusion_output.txt | extract_count)
[ -z "$NO_SLPDCECPFUSION_COUNT" ] && NO_SLPDCECPFUSION_COUNT=0
echo "No SLP + DCE + CP + Fusion: $NO_SLPDCECPFUSION_COUNT instructions"
echo

# Ablation: Remove all LLC passes + fusion (only alignment left)
echo "Testing: Remove SLP + DCE + const-prop + fusion + alignment..."
$LLC -march=bpf -filetype=obj -bpf-enable-count "bench/baseline/${SOURCE_NAME}.ll" -o "bench/ablation/${SOURCE_NAME}_no_opts.o" 2>&1 | tee /tmp/no_opts_output.txt > /dev/null
NO_OPTS_COUNT=$(cat /tmp/no_opts_output.txt | extract_count)
[ -z "$NO_OPTS_COUNT" ] && NO_OPTS_COUNT=0
echo "No optimizations (baseline): $NO_OPTS_COUNT instructions"
echo

# Summary
echo "========================================="
echo "Summary"
echo "========================================="
echo "Baseline (no opts):           $BASELINE_COUNT instructions"
echo "All optimizations:            $FULL_COUNT instructions"
echo "  Reduction: $(($BASELINE_COUNT - $FULL_COUNT)) instructions ($(echo "scale=2; 100 * ($BASELINE_COUNT - $FULL_COUNT) / $BASELINE_COUNT" | bc)%)"
echo
echo "Ablation Study Results (removing one by one):"
echo "  All opts:                   $FULL_COUNT instructions"
echo "  - SLP:                      $NO_SLP_COUNT instructions (+$(($NO_SLP_COUNT - $FULL_COUNT)))"
echo "  - SLP - DCE:                $NO_SLP_DCE_COUNT instructions (+$(($NO_SLP_DCE_COUNT - $NO_SLP_COUNT)))"
echo "  - SLP - DCE - CP:           $NO_SLP_DCE_CP_COUNT instructions (+$(($NO_SLP_DCE_CP_COUNT - $NO_SLP_DCE_COUNT)))"
echo "  - SLP - DCE - CP - Fusion:  $NO_SLPDCECPFUSION_COUNT instructions (+$(($NO_SLPDCECPFUSION_COUNT - $NO_SLP_DCE_CP_COUNT)))"
echo "  All removed (baseline):     $NO_OPTS_COUNT instructions (+$(($NO_OPTS_COUNT - $NO_SLPDCECPFUSION_COUNT)))"
echo "========================================="
