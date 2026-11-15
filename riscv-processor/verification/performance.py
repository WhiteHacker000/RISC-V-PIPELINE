#!/usr/bin/env python3
"""
Performance Analysis for RISC-V Pipelined Processor
"""

import sys
import os

def analyze_pipeline_performance():
    """Analyze pipeline performance metrics"""
    print("RISC-V Pipeline Performance Analysis")
    print("=" * 40)
    
    # Ideal CPI
    ideal_cpi = 1.0
    print(f"Ideal CPI: {ideal_cpi}")
    
    # Hazard penalties
    load_use_stall = 0.15  # 15% of instructions are load-use
    branch_taken_rate = 0.20  # 20% branches taken
    branch_penalty = 2  # cycles
    
    cpi_with_hazards = ideal_cpi + load_use_stall + (branch_taken_rate * branch_penalty)
    print(f"CPI with hazards: {cpi_with_hazards:.2f}")
    
    # Frequency estimation
    critical_path_ns = 6.5  # EX stage ALU
    max_freq_mhz = 1000 / critical_path_ns
    print(f"Estimated max frequency: {max_freq_mhz:.0f} MHz")
    
    # Throughput
    throughput = max_freq_mhz / cpi_with_hazards
    print(f"Instruction throughput: {throughput:.0f} MIPS")
    
    return {
        'ideal_cpi': ideal_cpi,
        'cpi_with_hazards': cpi_with_hazards,
        'max_freq_mhz': max_freq_mhz,
        'throughput_mips': throughput
    }

def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--json':
        import json
        result = analyze_pipeline_performance()
        print(json.dumps(result, indent=2))
    else:
        analyze_pipeline_performance()

if __name__ == "__main__":
    main()