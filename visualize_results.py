#!/usr/bin/env python3
"""
Visualization script for instruction count analysis results.
Generates grouped bar chart, waterfall chart, and stacked bar chart.

Usage: ./visualize_results.py <results_file>
Where results_file contains the output table from count_suricata_instructions.sh
"""

import sys
import re
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import Rectangle
import numpy as np

def parse_results(filename):
    """Parse the results table from the shell script output."""
    data = {}
    with open(filename, 'r') as f:
        content = f.read()
    
    # Find the table section - updated for new format
    table_match = re.search(r'File.*?Baseline.*?Full.*?-SLP.*?-SLP-Fus.*?-SLP-F-A.*?-All\n-+(.*?)(?:TOTAL|$)', content, re.DOTALL)
    if not table_match:
        print("Error: Could not find results table in file")
        sys.exit(1)
    
    table_content = table_match.group(1)
    
    # Parse each line
    for line in table_content.strip().split('\n'):
        if not line.strip() or line.startswith('-'):
            continue
        
        parts = line.split()
        if len(parts) < 7:
            continue
            
        filename = parts[0]
        try:
            baseline = int(parts[1])
            full = int(parts[2])
            no_slp = int(parts[3])
            no_slp_fusion = int(parts[4])
            no_slp_fusion_align = int(parts[5])
            no_all = int(parts[6])
            
            data[filename] = {
                'baseline': baseline,
                'full': full,
                'no_slp': no_slp,
                'no_slp_fusion': no_slp_fusion,
                'no_slp_fusion_align': no_slp_fusion_align,
                'no_all': no_all
            }
        except ValueError:
            continue
    
    return data

def create_grouped_bar_chart(data, output_file='grouped_bar_chart.png'):
    """Create a grouped bar chart showing cumulative removal (normalized to baseline)."""
    files = list(data.keys())
    configs = ['Baseline', 'Full', '-SLP', '-SLP-Fusion', '-SLP-F-Align', 'No Opts']
    
    # Prepare data - normalize to baseline (baseline = 100%)
    config_data = {
        'Baseline': [100.0 for f in files],
        'Full': [100.0 * data[f]['full'] / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files],
        '-SLP': [100.0 * data[f]['no_slp'] / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files],
        '-SLP-Fusion': [100.0 * data[f]['no_slp_fusion'] / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files],
        '-SLP-F-Align': [100.0 * data[f]['no_slp_fusion_align'] / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files],
        'No Opts': [100.0 * data[f]['no_all'] / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files],
    }
    
    x = np.arange(len(files))
    width = 0.14
    
    fig, ax = plt.subplots(figsize=(14, 8))
    
    colors = ['#e74c3c', '#27ae60', '#3498db', '#f39c12', '#9b59b6', '#95a5a6']
    
    for idx, (config, color) in enumerate(zip(configs, colors)):
        offset = (idx - len(configs)/2) * width + width/2
        ax.bar(x + offset, config_data[config], width, label=config, color=color, alpha=0.8)
    
    ax.set_xlabel('Files', fontsize=12, fontweight='bold')
    ax.set_ylabel('Instruction Count (% of Baseline)', fontsize=12, fontweight='bold')
    ax.set_title('Static Instruction Counts - Cumulative Ablation (Normalized)', fontsize=14, fontweight='bold')
    ax.set_xticks(x)
    ax.set_xticklabels(files, rotation=45, ha='right')
    ax.legend(loc='upper left', ncol=2)
    ax.grid(axis='y', alpha=0.3)
    ax.axhline(y=100, color='red', linestyle='--', alpha=0.5, linewidth=1)
    
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"Saved grouped bar chart to {output_file}")
    plt.close()

def create_waterfall_chart(data, output_file='waterfall_chart.png'):
    """Create a waterfall chart showing cumulative optimization removal effect (normalized)."""
    # Calculate totals
    total_baseline = sum(d['baseline'] for d in data.values())
    total_full = sum(d['full'] for d in data.values())
    total_no_slp = sum(d['no_slp'] for d in data.values())
    total_no_slp_fusion = sum(d['no_slp_fusion'] for d in data.values())
    total_no_slp_fusion_align = sum(d['no_slp_fusion_align'] for d in data.values())
    total_no_all = sum(d['no_all'] for d in data.values())
    
    # Normalize to baseline = 100%
    full_pct = 100.0 * total_full / total_baseline
    no_slp_pct = 100.0 * total_no_slp / total_baseline
    no_slp_fusion_pct = 100.0 * total_no_slp_fusion / total_baseline
    no_slp_fusion_align_pct = 100.0 * total_no_slp_fusion_align / total_baseline
    no_all_pct = 100.0 * total_no_all / total_baseline
    
    categories = ['Full', '-SLP', '-SLP\n-Fusion', '-SLP-Fus\n-Align', '-SLP-F-A\n-CP-DCE', 'Baseline']
    values = [full_pct, no_slp_pct - full_pct, no_slp_fusion_pct - no_slp_pct, 
              no_slp_fusion_align_pct - no_slp_fusion_pct, no_all_pct - no_slp_fusion_align_pct, 100.0]
    
    fig, ax = plt.subplots(figsize=(12, 8))
    
    # Calculate positions
    cumulative = [full_pct]
    for v in values[1:-1]:
        cumulative.append(cumulative[-1] + v)
    cumulative.append(100.0)
    
    colors = ['#27ae60', '#3498db', '#f39c12', '#9b59b6', '#e67e22', '#e74c3c']
    
    # Draw bars
    for i in range(len(categories)):
        if i == 0:
            ax.bar(i, cumulative[0], color=colors[0], alpha=0.8, edgecolor='black', linewidth=1.5)
            ax.text(i, cumulative[0]/2, f'{cumulative[0]:.1f}%', ha='center', va='center', fontweight='bold')
        elif i == len(categories) - 1:
            ax.bar(i, 100.0, color=colors[-1], alpha=0.8, edgecolor='black', linewidth=1.5)
            ax.text(i, 50, f'100%', ha='center', va='center', fontweight='bold')
        else:
            start = cumulative[i-1]
            height = values[i]
            ax.bar(i, abs(height), bottom=start, 
                   color=colors[i], alpha=0.8, edgecolor='black', linewidth=1.5)
            ax.text(i, start + height/2, f'+{height:.1f}%', ha='center', va='center', fontweight='bold')
            # Draw connector line
            if i < len(categories) - 1:
                ax.plot([i, i+1], [start+height, start+height], 'k--', alpha=0.3)
    
    ax.set_xticks(range(len(categories)))
    ax.set_xticklabels(categories, rotation=0, ha='center')
    ax.set_ylabel('Instruction Count (% of Baseline)', fontsize=12, fontweight='bold')
    ax.set_title('Cumulative Optimization Removal Effect (Waterfall, Normalized)', fontsize=14, fontweight='bold')
    ax.grid(axis='y', alpha=0.3)
    ax.axhline(y=100, color='red', linestyle='--', alpha=0.5, linewidth=1, label='Baseline')
    ax.axhline(y=full_pct, color='green', linestyle='--', alpha=0.5, linewidth=1, label='Fully Optimized')
    ax.legend()
    
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"Saved waterfall chart to {output_file}")
    plt.close()

def create_stacked_bar_chart(data, output_file='stacked_bar_chart.png'):
    """Create a stacked bar chart showing cumulative optimization removal (normalized)."""
    files = list(data.keys())
    
    # Calculate the incremental cost of removing each optimization (normalized to baseline = 100%)
    optimized = [100.0 * data[f]['full'] / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files]
    slp_cost = [100.0 * (data[f]['no_slp'] - data[f]['full']) / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files]
    fusion_cost = [100.0 * (data[f]['no_slp_fusion'] - data[f]['no_slp']) / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files]
    align_cost = [100.0 * (data[f]['no_slp_fusion_align'] - data[f]['no_slp_fusion']) / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files]
    cp_dce_cost = [100.0 * (data[f]['no_all'] - data[f]['no_slp_fusion_align']) / data[f]['baseline'] if data[f]['baseline'] > 0 else 0 for f in files]    x = np.arange(len(files))
    width = 0.6
    
    fig, ax = plt.subplots(figsize=(14, 8))
    
    # Stack the bars from bottom to top
    p1 = ax.bar(x, optimized, width, label='Fully Optimized', color='#27ae60', alpha=0.9)
    
    bottom = np.array(optimized)
    p2 = ax.bar(x, slp_cost, width, bottom=bottom, label='SLP Impact', color='#3498db', alpha=0.8)
    
    bottom += np.array(slp_cost)
    p3 = ax.bar(x, fusion_cost, width, bottom=bottom, label='Fusion Impact', color='#f39c12', alpha=0.8)
    
    bottom += np.array(fusion_cost)
    p4 = ax.bar(x, align_cost, width, bottom=bottom, label='Alignment Impact', color='#9b59b6', alpha=0.8)
    
    bottom += np.array(align_cost)
    p5 = ax.bar(x, cp_dce_cost, width, bottom=bottom, label='CP + DCE Impact', color='#e67e22', alpha=0.8)
    
    # Add baseline reference line at 100%
    ax.axhline(y=100, color='red', linestyle='--', linewidth=2, label='Baseline (No Opts)', alpha=0.7)
    
    ax.set_xlabel('Files', fontsize=12, fontweight='bold')
    ax.set_ylabel('Instruction Count (% of Baseline)', fontsize=12, fontweight='bold')
    ax.set_title('Cumulative Optimization Removal (Stacked, Normalized)', fontsize=14, fontweight='bold')
    ax.set_xticks(x)
    ax.set_xticklabels(files, rotation=45, ha='right')
    ax.legend(loc='upper left', ncol=2)
    ax.grid(axis='y', alpha=0.3)
    ax.set_ylim(0, 115)  # Leave room at the top
    
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"Saved stacked bar chart to {output_file}")
    plt.close()ked_bar_chart(data)
    
    print("\nDone! Generated 3 visualization files:")
    print("  - grouped_bar_chart.png")
    print("  - waterfall_chart.png")
    print("  - stacked_bar_chart.png")

if __name__ == '__main__':
    main()
