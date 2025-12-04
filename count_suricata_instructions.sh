#!/bin/bash

# Script to gather static instruction counts for all Suricata benchmark files
# Performs ablation study by removing one optimization at a time

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

BASELINE_DIR="bench/baseline/suricata"
OPT_DIR="bench/opt/suricata"
ABLATION_DIR="bench/ablation/suricata"

# Create output directories
mkdir -p "$OPT_DIR" "$ABLATION_DIR"

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
echo "Suricata Static Instruction Count Analysis"
echo "========================================="
echo

# Function to extract instruction count from LLC output
extract_count() {
    grep -oP '\d+(?= [Ii]nstructions)' | head -1
}

# Check if baseline directory exists
if [ ! -d "$BASELINE_DIR" ]; then
    echo "Error: Directory $BASELINE_DIR does not exist"
    exit 1
fi

# Find all .ll files
LL_FILES=$(find "$BASELINE_DIR" -name "*.ll" -type f)

if [ -z "$LL_FILES" ]; then
    echo "Error: No .ll files found in $BASELINE_DIR"
    exit 1
fi

# Arrays to store results
declare -A BASELINE_COUNTS
declare -A FULL_COUNTS
declare -A NO_IR_COUNTS
declare -A NO_ALIGN_COUNTS
declare -A NO_FUSION_COUNTS
declare -A NO_CPROP_COUNTS
declare -A NO_DCE_COUNTS
declare -A NO_SLP_COUNTS

# Process each file
for LL_FILE in $LL_FILES; do
    # Get just the filename without path and extension
    FILENAME=$(basename "$LL_FILE" .ll)
    
    echo "Processing $FILENAME..."
    
    # Baseline: no optimizations
    $LLC -march=bpf -filetype=obj -bpf-enable-count "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME}_baseline.o" 2>&1 | tee /tmp/baseline_${FILENAME}.txt > /dev/null
    COUNT=$(cat /tmp/baseline_${FILENAME}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    BASELINE_COUNTS[$FILENAME]=$COUNT
    
    # Full optimizations
    $OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
        "$LL_FILE" -o "${OPT_DIR}/${FILENAME}.bc" 2>&1 > /dev/null
    $LLC -march=bpf -filetype=obj $LLC_PASSES "${OPT_DIR}/${FILENAME}.bc" -o "${OPT_DIR}/${FILENAME}.o" 2>&1 | tee /tmp/full_${FILENAME}.txt > /dev/null
    COUNT=$(cat /tmp/full_${FILENAME}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    FULL_COUNTS[$FILENAME]=$COUNT
    
    # No IR passes
    $LLC -march=bpf -filetype=obj $LLC_PASSES "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME}_no_ir.o" 2>&1 | tee /tmp/no_ir_${FILENAME}.txt > /dev/null
    COUNT=$(cat /tmp/no_ir_${FILENAME}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    NO_IR_COUNTS[$FILENAME]=$COUNT
    
    # No alignment
    $OPT -load-pass-plugin="$FUSION_PLUGIN" -passes="bpffusion" \
        "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME}_no_align.bc" 2>&1 > /dev/null
    $LLC -march=bpf -filetype=obj $LLC_PASSES "${ABLATION_DIR}/${FILENAME}_no_align.bc" -o "${ABLATION_DIR}/${FILENAME}_no_align.o" 2>&1 | tee /tmp/no_align_${FILENAME}.txt > /dev/null
    COUNT=$(cat /tmp/no_align_${FILENAME}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    NO_ALIGN_COUNTS[$FILENAME]=$COUNT
    
    # No fusion
    $OPT -load-pass-plugin="$ALIGN_PLUGIN" -passes="bpfalign" \
        "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME}_no_fusion.bc" 2>&1 > /dev/null
    $LLC -march=bpf -filetype=obj $LLC_PASSES "${ABLATION_DIR}/${FILENAME}_no_fusion.bc" -o "${ABLATION_DIR}/${FILENAME}_no_fusion.o" 2>&1 | tee /tmp/no_fusion_${FILENAME}.txt > /dev/null
    COUNT=$(cat /tmp/no_fusion_${FILENAME}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    NO_FUSION_COUNTS[$FILENAME]=$COUNT
    
    # No const-prop
    $OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
        "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME}_no_cprop.bc" 2>&1 > /dev/null
    $LLC -march=bpf -filetype=obj -bpf-enable-dce -bpf-enable-slp -bpf-enable-count \
        "${ABLATION_DIR}/${FILENAME}_no_cprop.bc" -o "${ABLATION_DIR}/${FILENAME}_no_cprop.o" 2>&1 | tee /tmp/no_cprop_${FILENAME}.txt > /dev/null
    COUNT=$(cat /tmp/no_cprop_${FILENAME}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    NO_CPROP_COUNTS[$FILENAME]=$COUNT
    
    # No DCE
    $OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
        "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME}_no_dce.bc" 2>&1 > /dev/null
    $LLC -march=bpf -filetype=obj -bpf-enable-const-prop -bpf-enable-slp -bpf-enable-count \
        "${ABLATION_DIR}/${FILENAME}_no_dce.bc" -o "${ABLATION_DIR}/${FILENAME}_no_dce.o" 2>&1 | tee /tmp/no_dce_${FILENAME}.txt > /dev/null
    COUNT=$(cat /tmp/no_dce_${FILENAME}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    NO_DCE_COUNTS[$FILENAME]=$COUNT
    
    # No SLP
    $OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
        "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME}_no_slp.bc" 2>&1 > /dev/null
    $LLC -march=bpf -filetype=obj -bpf-enable-const-prop -bpf-enable-dce -bpf-enable-count \
        "${ABLATION_DIR}/${FILENAME}_no_slp.bc" -o "${ABLATION_DIR}/${FILENAME}_no_slp.o" 2>&1 | tee /tmp/no_slp_${FILENAME}.txt > /dev/null
    COUNT=$(cat /tmp/no_slp_${FILENAME}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    NO_SLP_COUNTS[$FILENAME]=$COUNT
    
    echo "  Done."
    echo
done

# Print results table
echo "========================================="
echo "Results Summary"
echo "========================================="
echo
printf "%-30s %10s %10s %10s %10s %10s %10s %10s %10s\n" \
    "File" "Baseline" "Full" "NoIR" "NoAlign" "NoFusion" "NoCP" "NoDCE" "NoSLP"
echo "----------------------------------------------------------------------------------------------------------------------------"

TOTAL_BASELINE=0
TOTAL_FULL=0
TOTAL_NO_IR=0
TOTAL_NO_ALIGN=0
TOTAL_NO_FUSION=0
TOTAL_NO_CPROP=0
TOTAL_NO_DCE=0
TOTAL_NO_SLP=0

for LL_FILE in $LL_FILES; do
    FILENAME=$(basename "$LL_FILE" .ll)
    
    B=${BASELINE_COUNTS[$FILENAME]}
    F=${FULL_COUNTS[$FILENAME]}
    NIR=${NO_IR_COUNTS[$FILENAME]}
    NA=${NO_ALIGN_COUNTS[$FILENAME]}
    NF=${NO_FUSION_COUNTS[$FILENAME]}
    NCP=${NO_CPROP_COUNTS[$FILENAME]}
    ND=${NO_DCE_COUNTS[$FILENAME]}
    NS=${NO_SLP_COUNTS[$FILENAME]}
    
    printf "%-30s %10s %10s %10s %10s %10s %10s %10s %10s\n" \
        "$FILENAME" "$B" "$F" "$NIR" "$NA" "$NF" "$NCP" "$ND" "$NS"
    
    TOTAL_BASELINE=$((TOTAL_BASELINE + B))
    TOTAL_FULL=$((TOTAL_FULL + F))
    TOTAL_NO_IR=$((TOTAL_NO_IR + NIR))
    TOTAL_NO_ALIGN=$((TOTAL_NO_ALIGN + NA))
    TOTAL_NO_FUSION=$((TOTAL_NO_FUSION + NF))
    TOTAL_NO_CPROP=$((TOTAL_NO_CPROP + NCP))
    TOTAL_NO_DCE=$((TOTAL_NO_DCE + ND))
    TOTAL_NO_SLP=$((TOTAL_NO_SLP + NS))
done

echo "----------------------------------------------------------------------------------------------------------------------------"
printf "%-30s %10s %10s %10s %10s %10s %10s %10s %10s\n" \
    "TOTAL" "$TOTAL_BASELINE" "$TOTAL_FULL" "$TOTAL_NO_IR" "$TOTAL_NO_ALIGN" "$TOTAL_NO_FUSION" "$TOTAL_NO_CPROP" "$TOTAL_NO_DCE" "$TOTAL_NO_SLP"

echo
echo "========================================="
echo "Optimization Impact (vs Full)"
echo "========================================="
echo "Total reduction: $((TOTAL_BASELINE - TOTAL_FULL)) instructions ($(echo "scale=2; 100 * ($TOTAL_BASELINE - $TOTAL_FULL) / $TOTAL_BASELINE" | bc)%)"
echo
echo "Impact of removing each optimization:"
echo "  No IR passes:     +$((TOTAL_NO_IR - TOTAL_FULL)) instructions"
echo "  No alignment:     +$((TOTAL_NO_ALIGN - TOTAL_FULL)) instructions"
echo "  No fusion:        +$((TOTAL_NO_FUSION - TOTAL_FULL)) instructions"
echo "  No const-prop:    +$((TOTAL_NO_CPROP - TOTAL_FULL)) instructions"
echo "  No DCE:           +$((TOTAL_NO_DCE - TOTAL_FULL)) instructions"
echo "  No SLP:           +$((TOTAL_NO_SLP - TOTAL_FULL)) instructions"
echo "========================================="
