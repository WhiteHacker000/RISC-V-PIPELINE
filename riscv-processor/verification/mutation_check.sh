#!/bin/sh
# Mutation check for the integration testbenches.
#
# Each mutant injects one known hazard/flush/reset/x0 bug into a *temporary
# copy* of the RTL (the working tree is never modified) and reports whether
# processor_tb and pipeline_corner_tb detect it. A useful bench KILLS mutants.
#
# Usage, from riscv-processor/:   sh verification/mutation_check.sh
# Requires verilator and perl. Not part of `make test`.
set -u
VERILATOR=${VERILATOR:-verilator}
SRC=$(pwd)
[ -d "$SRC/rtl" ] || { echo "run from riscv-processor/"; exit 2; }
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

mutant() { # name file perl-substitution
    name=$1; file=$2; sub=$3; dir=$WORK/$name
    mkdir -p "$dir/simulation"
    cp -R "$SRC/rtl" "$SRC/testbench" "$SRC/programs" "$dir/"
    perl -0pi -e "$sub" "$dir/$file"
    if [ "$name" != M0_none ] && cmp -s "$dir/$file" "$SRC/$file"; then
        echo "$name: MUTATION DID NOT APPLY"; return
    fi
    for tb in processor_tb pipeline_corner_tb; do
        (cd "$dir" && $VERILATOR --binary --timing --top-module $tb -Wno-fatal \
            --Mdir b_$tb rtl/components/*.sv rtl/pipeline_registers/*.sv \
            rtl/riscv_top.sv testbench/$tb.sv >/dev/null 2>&1) ||
            { echo "$name $tb: COMPILE FAIL"; continue; }
        if (cd "$dir" && ./b_$tb/V$tb 2>&1 | grep -q 'TESTS PASSED'); then
            echo "$name $tb: survived"
        else
            echo "$name $tb: KILLED"
        fi
    done
}

mutant M0_none rtl/riscv_top.sv 's/(module riscv_top)/$1/'
mutant M1_fwd_exmem_x0 rtl/components/forwarding_unit.sv \
    's/exmem_mem_read && exmem_rd != 5.d0 && exmem_rd == rs1/exmem_mem_read && exmem_rd == rs1/'
mutant M2_fwd_priority_rs2 rtl/components/forwarding_unit.sv \
    's/(if \(exmem_reg_write && !exmem_mem_read && exmem_rd != 5.d0 && exmem_rd == rs2\)\n\s*forward_b = 2.b10;\n\s*else if \(memwb_reg_write && memwb_rd != 5.d0 && memwb_rd == rs2\)\n\s*forward_b = 2.b01;)/if (memwb_reg_write && memwb_rd != 5\x27d0 && memwb_rd == rs2) forward_b = 2\x27b01; else if (exmem_reg_write && !exmem_mem_read && exmem_rd != 5\x27d0 && exmem_rd == rs2) forward_b = 2\x27b10;/'
mutant M3_hdu_no_rs2 rtl/components/hazard_detection_unit.sv \
    's/\|\|\s*\(ifid_uses_rs2 && idex_rd == ifid_rs2\)//'
mutant M4_hdu_x0_stall rtl/components/hazard_detection_unit.sv \
    's/idex_mem_read && \(idex_rd != 5.d0\) &&/idex_mem_read &&/'
mutant M5_ifid_no_flush rtl/riscv_top.sv 's/\.flush\(ex_branch_taken\)/.flush(1\x27b0)/'
mutant M6_idex_no_branch_flush rtl/components/hazard_detection_unit.sv \
    's/flush_idex = branch_taken \|\| load_use_hazard/flush_idex = load_use_hazard/'
mutant M7_rf_writes_x0 rtl/components/register_file.sv \
    's/if \(write_enable && \(write_addr != .0\)\)/if (write_enable)/'
mutant M8_no_wb_id_bypass rtl/riscv_top.sv \
    's/decode_rs1_data = wb_write_data;/decode_rs1_data = register_read1;/; s/decode_rs2_data = wb_write_data;/decode_rs2_data = register_read2;/'
mutant M9_dmem_write_in_reset rtl/riscv_top.sv \
    's/\.mem_write\(rst_n && exmem_mem_write\)/.mem_write(exmem_mem_write)/'
mutant M10_rf_write_in_reset rtl/riscv_top.sv \
    's/\.write_enable\(rst_n && wb_reg_write\)/.write_enable(wb_reg_write)/'
mutant M11_no_load_use_bubble rtl/components/hazard_detection_unit.sv \
    's/flush_idex = branch_taken \|\| load_use_hazard/flush_idex = branch_taken/'
mutant M12_sw_rs2_unused rtl/riscv_top.sv \
    's/(7.b0100011: begin\n\s*uses_rs1 = 1.b1;\n\s*)uses_rs2 = 1.b1;/$1/'
mutant M13_fwd_rs2_x0 rtl/components/forwarding_unit.sv \
    's/exmem_mem_read && exmem_rd != 5.d0 && exmem_rd == rs2/exmem_mem_read && exmem_rd == rs2/'
mutant M14_fwd_memwb_x0 rtl/components/forwarding_unit.sv \
    's/memwb_rd != 5.d0 && memwb_rd == rs1/memwb_rd == rs1/'
