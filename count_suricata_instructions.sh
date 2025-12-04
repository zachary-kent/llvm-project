#!/bin/bash

# Script to gather static instruction counts for all Suricata benchmark files
# Performs ablation study by removing one optimization at a time

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

BASELINE_DIR="bench/baseline/suricata"
OPT_DIR="bench/opt/suricata"
ABLATION_DIR="bench/ablation/suricata"

# Additional single files to process
SINGLE_FILES=("prog.c" "tunnel.ll")

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

# Find all .ll files in Suricata directory
LL_FILES=$(find "$BASELINE_DIR" -name "*.ll" -type f)

if [ -z "$LL_FILES" ]; then
    echo "Error: No .ll files found in $BASELINE_DIR"
    exit 1
fi

# Add single files to the list
for SINGLE_FILE in "${SINGLE_FILES[@]}"; do
    if [ -f "$SINGLE_FILE" ]; then
        LL_FILES="$LL_FILES $SINGLE_FILE"
    else
        echo "Warning: $SINGLE_FILE not found, skipping..."
    fi
done

# Arrays to store results
declare -A BASELINE_COUNTS
declare -A FULL_COUNTS
declare -A NO_SLP_COUNTS
declare -A NO_SLP_FUSION_COUNTS
declare -A NO_SLP_FUSION_ALIGN_COUNTS
declare -A NO_ALL_COUNTS

# Process each file
for LL_FILE in $LL_FILES; do
    # Get just the filename without path and extension
    FILENAME=$(basename "$LL_FILE")
    FILENAME_BASE="${FILENAME%.*}"
    
    echo "Processing $FILENAME..."
    
    # For .c files, compile to .ll first
    if [[ "$LL_FILE" == *.c ]]; then
        $CLANG -target bpf -O2 -emit-llvm -S -o "${ABLATION_DIR}/${FILENAME_BASE}.ll" "$LL_FILE"
        LL_FILE="${ABLATION_DIR}/${FILENAME_BASE}.ll"
    fi
    
    # Baseline: no optimizations
    $LLC -march=bpf -filetype=obj -bpf-enable-count "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME_BASE}_baseline.o" 2>&1 | tee /tmp/baseline_${FILENAME_BASE}.txt > /dev/null
    COUNT=$(cat /tmp/baseline_${FILENAME_BASE}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    BASELINE_COUNTS[$FILENAME_BASE]=$COUNT
    
    # Full optimizations
    $OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
        "$LL_FILE" -o "${OPT_DIR}/${FILENAME_BASE}.bc" 2>&1 > /dev/null
    $LLC -march=bpf -filetype=obj $LLC_PASSES "${OPT_DIR}/${FILENAME_BASE}.bc" -o "${OPT_DIR}/${FILENAME_BASE}.o" 2>&1 | tee /tmp/full_${FILENAME_BASE}.txt > /dev/null
    COUNT=$(cat /tmp/full_${FILENAME_BASE}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    FULL_COUNTS[$FILENAME_BASE]=$COUNT
    
    # Remove SLP (keep Fusion, Alignment, CP, DCE)
    $OPT -load-pass-plugin="$ALIGN_PLUGIN" -load-pass-plugin="$FUSION_PLUGIN" -passes="$IR_PASSES" \
        "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME_BASE}_no_slp.bc" 2>&1 > /dev/null
    $LLC -march=bpf -filetype=obj -bpf-enable-const-prop -bpf-enable-dce -bpf-enable-count \
        "${ABLATION_DIR}/${FILENAME_BASE}_no_slp.bc" -o "${ABLATION_DIR}/${FILENAME_BASE}_no_slp.o" 2>&1 | tee /tmp/no_slp_${FILENAME_BASE}.txt > /dev/null
    COUNT=$(cat /tmp/no_slp_${FILENAME_BASE}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    NO_SLP_COUNTS[$FILENAME_BASE]=$COUNT
    
    # Remove SLP + Fusion (keep Alignment, CP, DCE)
    $OPT -load-pass-plugin="$ALIGN_PLUGIN" -passes="bpfalign" \
        "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME_BASE}_no_slp_fusion.bc" 2>&1 > /dev/null
    $LLC -march=bpf -filetype=obj -bpf-enable-const-prop -bpf-enable-dce -bpf-enable-count \
        "${ABLATION_DIR}/${FILENAME_BASE}_no_slp_fusion.bc" -o "${ABLATION_DIR}/${FILENAME_BASE}_no_slp_fusion.o" 2>&1 | tee /tmp/no_slp_fusion_${FILENAME_BASE}.txt > /dev/null
    COUNT=$(cat /tmp/no_slp_fusion_${FILENAME_BASE}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    NO_SLP_FUSION_COUNTS[$FILENAME_BASE]=$COUNT
    
    # Remove SLP + Fusion + Alignment (keep CP, DCE)
    $LLC -march=bpf -filetype=obj -bpf-enable-const-prop -bpf-enable-dce -bpf-enable-count \
        "$LL_FILE" -o "${ABLATION_DIR}/${FILENAME_BASE}_no_slp_fusion_align.o" 2>&1 | tee /tmp/no_slp_fusion_align_${FILENAME_BASE}.txt > /dev/null
    COUNT=$(cat /tmp/no_slp_fusion_align_${FILENAME_BASE}.txt | extract_count)
    [ -z "$COUNT" ] && COUNT=0
    NO_SLP_FUSION_ALIGN_COUNTS[$FILENAME_BASE]=$COUNT
    
    # Remove all optimizations (same as baseline)
    NO_ALL_COUNTS[$FILENAME_BASE]=${BASELINE_COUNTS[$FILENAME_BASE]}
    
    echo "  Done."
    echo
done

# Print results table
echo "========================================="
echo "Results Summary"
echo "========================================="
echo
printf "%-30s %10s %10s %10s %10s %10s %10s\n" \
    "File" "Baseline" "Full" "-SLP" "-SLP-Fus" "-SLP-F-A" "-All"
echo "----------------------------------------------------------------------------------------------------------------------------"

TOTAL_BASELINE=0
TOTAL_FULL=0
TOTAL_NO_SLP=0
TOTAL_NO_SLP_FUSION=0
TOTAL_NO_SLP_FUSION_ALIGN=0
TOTAL_NO_ALL=0

for LL_FILE in $LL_FILES; do
    FILENAME=$(basename "$LL_FILE")
    FILENAME_BASE="${FILENAME%.*}"
    
    B=${BASELINE_COUNTS[$FILENAME_BASE]}
    F=${FULL_COUNTS[$FILENAME_BASE]}
    NS=${NO_SLP_COUNTS[$FILENAME_BASE]}
    NSF=${NO_SLP_FUSION_COUNTS[$FILENAME_BASE]}
    NSFA=${NO_SLP_FUSION_ALIGN_COUNTS[$FILENAME_BASE]}
    NA=${NO_ALL_COUNTS[$FILENAME_BASE]}
    
    printf "%-30s %10s %10s %10s %10s %10s %10s\n" \
        "$FILENAME_BASE" "$B" "$F" "$NS" "$NSF" "$NSFA" "$NA"
    
    TOTAL_BASELINE=$((TOTAL_BASELINE + B))
    TOTAL_FULL=$((TOTAL_FULL + F))
    TOTAL_NO_SLP=$((TOTAL_NO_SLP + NS))
    TOTAL_NO_SLP_FUSION=$((TOTAL_NO_SLP_FUSION + NSF))
    TOTAL_NO_SLP_FUSION_ALIGN=$((TOTAL_NO_SLP_FUSION_ALIGN + NSFA))
    TOTAL_NO_ALL=$((TOTAL_NO_ALL + NA))
done

echo "----------------------------------------------------------------------------------------------------------------------------"
printf "%-30s %10s %10s %10s %10s %10s %10s\n" \
    "TOTAL" "$TOTAL_BASELINE" "$TOTAL_FULL" "$TOTAL_NO_SLP" "$TOTAL_NO_SLP_FUSION" "$TOTAL_NO_SLP_FUSION_ALIGN" "$TOTAL_NO_ALL"

echo
echo "========================================="
echo "Optimization Impact (Cumulative Removal)"
echo "========================================="
REDUCTION=$((TOTAL_BASELINE - TOTAL_FULL))
REDUCTION_PCT=$(echo "scale=2; 100 * $REDUCTION / $TOTAL_BASELINE" | bc)
echo "Total reduction: $REDUCTION instructions ($REDUCTION_PCT%)"
echo
echo "Impact of removing optimizations one by one:"
echo "  All opts:                     $TOTAL_FULL instructions"
echo "  - SLP:                        $TOTAL_NO_SLP instructions (+$((TOTAL_NO_SLP - TOTAL_FULL)))"
echo "  - SLP - Fusion:               $TOTAL_NO_SLP_FUSION instructions (+$((TOTAL_NO_SLP_FUSION - TOTAL_NO_SLP)))"
echo "  - SLP - Fusion - Alignment:   $TOTAL_NO_SLP_FUSION_ALIGN instructions (+$((TOTAL_NO_SLP_FUSION_ALIGN - TOTAL_NO_SLP_FUSION)))"
echo "  - SLP - Fusion - Align - CP/DCE: $TOTAL_NO_ALL instructions (+$((TOTAL_NO_ALL - TOTAL_NO_SLP_FUSION_ALIGN)))"
echo "========================================="

# Output CSV file
CSV_FILE="results.csv"
echo "File,Baseline,Full,-SLP,-SLP-Fusion,-SLP-Fusion-Align,-All" > "$CSV_FILE"
for LL_FILE in $LL_FILES; do
    FILENAME=$(basename "$LL_FILE")
    FILENAME_BASE="${FILENAME%.*}"
    
    B=${BASELINE_COUNTS[$FILENAME_BASE]}
    F=${FULL_COUNTS[$FILENAME_BASE]}
    NS=${NO_SLP_COUNTS[$FILENAME_BASE]}
    NSF=${NO_SLP_FUSION_COUNTS[$FILENAME_BASE]}
    NSFA=${NO_SLP_FUSION_ALIGN_COUNTS[$FILENAME_BASE]}
    NA=${NO_ALL_COUNTS[$FILENAME_BASE]}
    
    echo "$FILENAME_BASE,$B,$F,$NS,$NSF,$NSFA,$NA" >> "$CSV_FILE"
done
echo "TOTAL,$TOTAL_BASELINE,$TOTAL_FULL,$TOTAL_NO_SLP,$TOTAL_NO_SLP_FUSION,$TOTAL_NO_SLP_FUSION_ALIGN,$TOTAL_NO_ALL" >> "$CSV_FILE"

echo
echo "Results saved to $CSV_FILE"
