module processor_tb;
    logic clk;
    logic rst_n;
    integer independent_writes;
    integer three_addi_writes;
    logic independent_overlap_seen;
    logic load_use_stall_seen;
    logic three_addi_forward_seen;
    logic [2:0] three_addi_ifid_seen;
    logic [2:0] three_addi_idex_seen;
    logic [2:0] three_addi_exmem_seen;
    logic [2:0] three_addi_memwb_seen;
    integer performance_file;

    task automatic report_benchmark(
        input string name,
        input logic [63:0] cycles,
        input logic [63:0] retired,
        input logic [63:0] completed_wb,
        input logic [63:0] stalls,
        input logic [63:0] branch_flushes,
        input logic [63:0] taken_branches,
        input logic [63:0] not_taken_branches
    );
        real cpi;
        real ipc;
        begin
            if (retired == 0) begin
                cpi = 0.0;
                ipc = 0.0;
            end else begin
                cpi = real'(cycles) / real'(retired);
                ipc = real'(retired) / real'(cycles);
            end
            $display("PERF,%s,cycles=%0d,retired=%0d,wb_completed=%0d,stalls=%0d,branch_flushes=%0d,taken=%0d,not_taken=%0d,CPI=%0.3f,IPC=%0.3f",
                     name, cycles, retired, completed_wb, stalls,
                     branch_flushes, taken_branches, not_taken_branches, cpi, ipc);
            $fdisplay(performance_file, "%s,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
                      name, cycles, retired, completed_wb, stalls,
                      branch_flushes, taken_branches, not_taken_branches);
        end
    endtask

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_dependencies.hex"), .IMEM_PROGRAM_LENGTH(6)
    ) u_dependencies (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_independent.hex"), .IMEM_PROGRAM_LENGTH(5)
    ) u_independent (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_load_use.hex"), .IMEM_PROGRAM_LENGTH(4)
    ) u_load_use (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_branches.hex"), .IMEM_PROGRAM_LENGTH(9)
    ) u_branches (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_three_addi.hex"), .IMEM_PROGRAM_LENGTH(3)
    ) u_three_addi (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_long_arithmetic.hex"), .IMEM_PROGRAM_LENGTH(64)
    ) u_long_arithmetic (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(.IMEM_INIT_FILE("programs/processor_independent_50.hex"), .IMEM_PROGRAM_LENGTH(50))
        u_independent_50 (.clk(clk), .rst_n(rst_n));
    riscv_top #(.IMEM_INIT_FILE("programs/processor_independent_100.hex"), .IMEM_PROGRAM_LENGTH(100))
        u_independent_100 (.clk(clk), .rst_n(rst_n));
    riscv_top #(.IMEM_INIT_FILE("programs/processor_dependent_50.hex"), .IMEM_PROGRAM_LENGTH(50))
        u_dependent_50 (.clk(clk), .rst_n(rst_n));
    riscv_top #(.IMEM_INIT_FILE("programs/processor_branch_heavy.hex"), .IMEM_PROGRAM_LENGTH(5))
        u_branch_heavy (.clk(clk), .rst_n(rst_n));

    always #5 clk = ~clk;

    always @(negedge clk) begin
        if (rst_n) begin
            if (u_independent.wb_reg_write &&
                (u_independent.wb_rd != 5'd0)) begin
                case (independent_writes)
                    0: if (u_independent.wb_rd != 5'd1)
                        $fatal(1, "independent program write 0 out of order");
                    1: if (u_independent.wb_rd != 5'd2)
                        $fatal(1, "independent program write 1 out of order");
                    2: if (u_independent.wb_rd != 5'd3)
                        $fatal(1, "independent program write 2 out of order");
                    3: if (u_independent.wb_rd != 5'd4)
                        $fatal(1, "independent program write 3 out of order");
                    4: if (u_independent.wb_rd != 5'd5)
                        $fatal(1, "independent program write 4 out of order");
                    default: $fatal(1, "unexpected extra independent write");
                endcase
                independent_writes <= independent_writes + 1;
            end

            if (u_independent.idex_reg_write &&
                u_independent.exmem_reg_write &&
                u_independent.wb_reg_write)
                independent_overlap_seen <= 1'b1;

            if (u_load_use.load_use_stall)
                load_use_stall_seen <= 1'b1;

            // IF/ID captures each exact instruction word from instruction memory.
            if (u_three_addi.ifid_instruction == 32'h0010_0093)
                three_addi_ifid_seen[0] <= 1'b1;
            if (u_three_addi.ifid_instruction == 32'h0020_8113)
                three_addi_ifid_seen[1] <= 1'b1;
            if (u_three_addi.ifid_instruction == 32'h0031_0193)
                three_addi_ifid_seen[2] <= 1'b1;

            // ID/EX carries the decoded source, destination, immediate and value.
            if (u_three_addi.idex_reg_write && u_three_addi.idex_rd == 1) begin
                if (u_three_addi.idex_rs1 != 0 || u_three_addi.idex_immediate != 1 ||
                    u_three_addi.idex_rs1_data != 0)
                    $fatal(1, "ADDI x1 decoded operands/control mismatch");
                three_addi_idex_seen[0] <= 1'b1;
            end
            if (u_three_addi.idex_reg_write && u_three_addi.idex_rd == 2) begin
                if (u_three_addi.idex_rs1 != 1 || u_three_addi.idex_immediate != 2)
                    $fatal(1, "ADDI x2 decoded operands/control mismatch");
                three_addi_idex_seen[1] <= 1'b1;
            end
            if (u_three_addi.idex_reg_write && u_three_addi.idex_rd == 3) begin
                if (u_three_addi.idex_rs1 != 2 || u_three_addi.idex_immediate != 3)
                    $fatal(1, "ADDI x3 decoded operands/control mismatch");
                three_addi_idex_seen[2] <= 1'b1;
            end

            if (u_three_addi.forward_a != 2'b00)
                three_addi_forward_seen <= 1'b1;

            // EX/MEM and MEM/WB must carry results paired with their rd.
            if (u_three_addi.exmem_reg_write && u_three_addi.exmem_rd != 0) begin
                case (u_three_addi.exmem_rd)
                    1: begin if (u_three_addi.exmem_alu_result != 1) $fatal(1, "EX/MEM x1 result mismatch"); three_addi_exmem_seen[0] <= 1'b1; end
                    2: begin if (u_three_addi.exmem_alu_result != 3) $fatal(1, "EX/MEM x2 result mismatch"); three_addi_exmem_seen[1] <= 1'b1; end
                    3: begin if (u_three_addi.exmem_alu_result != 6) $fatal(1, "EX/MEM x3 result mismatch"); three_addi_exmem_seen[2] <= 1'b1; end
                    default: $fatal(1, "unexpected destination in three-ADDI EX/MEM stream");
                endcase
            end
            if (u_three_addi.wb_reg_write && u_three_addi.wb_rd != 0) begin
                case (three_addi_writes)
                    0: if (u_three_addi.wb_rd != 1 || u_three_addi.wb_write_data != 1) $fatal(1, "first write-back mismatch/order");
                    1: if (u_three_addi.wb_rd != 2 || u_three_addi.wb_write_data != 3) $fatal(1, "second write-back mismatch/order");
                    2: if (u_three_addi.wb_rd != 3 || u_three_addi.wb_write_data != 6) $fatal(1, "third write-back mismatch/order");
                    default: $fatal(1, "duplicate write-back in three-ADDI stream");
                endcase
                three_addi_writes <= three_addi_writes + 1;
                if (u_three_addi.wb_rd == 1) three_addi_memwb_seen[0] <= 1'b1;
                if (u_three_addi.wb_rd == 2) three_addi_memwb_seen[1] <= 1'b1;
                if (u_three_addi.wb_rd == 3) three_addi_memwb_seen[2] <= 1'b1;
            end
        end
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        independent_writes = 0;
        three_addi_writes = 0;
        independent_overlap_seen = 1'b0;
        load_use_stall_seen = 1'b0;
        three_addi_forward_seen = 1'b0;
        three_addi_ifid_seen = '0;
        three_addi_idex_seen = '0;
        three_addi_exmem_seen = '0;
        three_addi_memwb_seen = '0;

        $dumpfile("simulation/processor_tb.vcd");
        $dumpvars(0, processor_tb);

        @(posedge clk);
        #1;
        if (u_independent.perf_total_cycles != 0 ||
            u_independent.perf_instructions_retired != 0 ||
            u_independent.perf_stall_cycles != 0 ||
            u_independent.perf_branch_flushes != 0 ||
            u_independent.perf_instructions_completed_wb != 0)
            $fatal(1, "performance counters did not clear during reset");
        #6 rst_n = 1'b1;
        repeat (130) @(negedge clk);
        #1;

        if (u_dependencies.u_register_file.registers[1] !== 32'd10)
            $fatal(1, "dependency test: x1 expected 10, got %0d",
                   u_dependencies.u_register_file.registers[1]);
        if (u_dependencies.u_register_file.registers[2] !== 32'd20)
            $fatal(1, "dependency test: x2 expected 20, got %0d",
                   u_dependencies.u_register_file.registers[2]);
        if (u_dependencies.u_register_file.registers[3] !== 32'd30)
            $fatal(1, "dependency test: x3 expected 30, got %0d",
                   u_dependencies.u_register_file.registers[3]);
        if (u_dependencies.u_register_file.registers[4] !== 32'd10)
            $fatal(1, "dependency test: x4 expected 10, got %0d",
                   u_dependencies.u_register_file.registers[4]);
        if (u_dependencies.u_register_file.registers[5] !== 32'd30)
            $fatal(1, "dependency test: x5 expected 30, got %0d",
                   u_dependencies.u_register_file.registers[5]);
        if (u_dependencies.u_data_memory.words[0] !== 32'd30)
            $fatal(1, "dependency test: memory[0] expected 30, got %0d",
                   u_dependencies.u_data_memory.words[0]);
        $display("PASS: dependent ALU/store/load sequence");

        if (u_independent.u_register_file.registers[1] !== 32'd1 ||
            u_independent.u_register_file.registers[2] !== 32'd2 ||
            u_independent.u_register_file.registers[3] !== 32'd3 ||
            u_independent.u_register_file.registers[4] !== 32'd0 ||
            u_independent.u_register_file.registers[5] !== 32'd5)
            $fatal(1, "independent instruction results mismatch");
        if (independent_writes != 5)
            $fatal(1, "expected 5 ordered independent writes, observed %0d",
                   independent_writes);
        if (!independent_overlap_seen)
            $fatal(1, "independent instructions did not overlap in the pipeline");
        $display("PASS: independent pipeline overlap and write ordering");

        if (u_load_use.u_register_file.registers[1] !== 32'd42 ||
            u_load_use.u_register_file.registers[2] !== 32'd42 ||
            u_load_use.u_register_file.registers[3] !== 32'd84 ||
            u_load_use.u_data_memory.words[0] !== 32'd42)
            $fatal(1, "load-use interlock test mismatch");
        if (!load_use_stall_seen)
            $fatal(1, "load-use interlock was never asserted");
        if (u_load_use.load_use_stall)
            $fatal(1, "load-use interlock remained asserted after program");
        $display("PASS: load-use interlock and forwarding");

        if (u_branches.u_register_file.registers[1] !== 32'd1 ||
            u_branches.u_register_file.registers[2] !== 32'd2 ||
            u_branches.u_register_file.registers[3] !== 32'd3 ||
            u_branches.u_register_file.registers[4] !== 32'd4 ||
            u_branches.u_register_file.registers[5] !== 32'd0 ||
            u_branches.u_register_file.registers[6] !== 32'd0)
            $fatal(1, "branch redirect/flush test mismatch");
        $display("PASS: BEQ/BNE redirects, not-taken path, and flushes");

        if (u_three_addi.u_register_file.registers[1] !== 32'd1 ||
            u_three_addi.u_register_file.registers[2] !== 32'd3 ||
            u_three_addi.u_register_file.registers[3] !== 32'd6)
            $fatal(1, "three-ADDI final registers mismatch: x1=%0d x2=%0d x3=%0d",
                   u_three_addi.u_register_file.registers[1],
                   u_three_addi.u_register_file.registers[2],
                   u_three_addi.u_register_file.registers[3]);
        if (three_addi_ifid_seen != 3'b111 || three_addi_idex_seen != 3'b111 ||
            three_addi_exmem_seen != 3'b111 || three_addi_memwb_seen != 3'b111)
            $fatal(1, "three-ADDI instruction missing at a pipeline boundary: IFID=%b IDEX=%b EXMEM=%b MEMWB=%b",
                   three_addi_ifid_seen, three_addi_idex_seen,
                   three_addi_exmem_seen, three_addi_memwb_seen);
        if (!three_addi_forward_seen || three_addi_writes != 3)
            $fatal(1, "three-ADDI forwarding/write count mismatch: forwarding=%b writes=%0d",
                   three_addi_forward_seen, three_addi_writes);
        $display("PASS: three-ADDI pipeline flow IF/ID=%b ID/EX=%b EX/MEM=%b MEM/WB=%b",
                 three_addi_ifid_seen, three_addi_idex_seen,
                 three_addi_exmem_seen, three_addi_memwb_seen);
        $display("OBSERVED FINAL REGISTERS: x1=%0d x2=%0d x3=%0d",
                 u_three_addi.u_register_file.registers[1],
                 u_three_addi.u_register_file.registers[2],
                 u_three_addi.u_register_file.registers[3]);
        $display("PASS: three-ADDI forwarding and ordered write-back");

        // Counter assertions cover normal flow, load-use bubbles, and branch flushes.
        if (u_independent.perf_instructions_retired != 5 ||
            u_independent.perf_instructions_completed_wb != 5 ||
            u_independent.perf_stall_cycles != 0 ||
            u_independent.perf_branch_flushes != 0 ||
            u_independent.perf_total_cycles != 9)
            $fatal(1, "independent benchmark counters incorrect");
        if (u_dependencies.perf_instructions_retired != 6 ||
            u_dependencies.perf_instructions_completed_wb != 6 ||
            u_dependencies.perf_stall_cycles != 0 ||
            u_dependencies.perf_total_cycles != 10)
            $fatal(1, "dependent benchmark counters incorrect");
        if (u_load_use.perf_instructions_retired != 4 ||
            u_load_use.perf_instructions_completed_wb != 4 ||
            u_load_use.perf_stall_cycles != 1 ||
            u_load_use.perf_total_cycles != 9)
            $fatal(1, "load-use bubble was miscounted or stall counter incorrect");
        if (u_branches.perf_instructions_retired != 7 ||
            u_branches.perf_instructions_completed_wb != 7 ||
            u_branches.perf_branch_flushes != 2 ||
            u_branches.perf_taken_branches != 2 ||
            u_branches.perf_not_taken_branches != 1)
            $fatal(1, "branch retirement/flush counters incorrect");
        if (u_three_addi.perf_instructions_retired != 3 ||
            u_three_addi.perf_instructions_completed_wb != 3 ||
            u_three_addi.perf_total_cycles != 7 ||
            u_three_addi.perf_stall_cycles != 0)
            $fatal(1, "three-ADDI benchmark counters incorrect");
        if (u_long_arithmetic.perf_instructions_retired != 64 ||
            u_long_arithmetic.perf_instructions_completed_wb != 64 ||
            u_long_arithmetic.perf_total_cycles != 68 ||
            u_long_arithmetic.perf_stall_cycles != 0 ||
            u_long_arithmetic.perf_branch_flushes != 0 ||
            u_long_arithmetic.perf_taken_branches != 0 ||
            u_long_arithmetic.perf_not_taken_branches != 0)
            $fatal(1, "long arithmetic benchmark counters incorrect");
        if (u_long_arithmetic.u_register_file.registers[1] !== 32'd63 ||
            u_long_arithmetic.u_register_file.registers[2] !== 32'd64)
            $fatal(1, "long arithmetic benchmark result mismatch");
        $display("PASS: 64-instruction independent arithmetic stream");

        if (u_independent_50.perf_instructions_retired != 50 ||
            u_independent_50.perf_instructions_completed_wb != 50 ||
            u_independent_50.perf_total_cycles != 54 ||
            u_independent_50.perf_stall_cycles != 0 ||
            u_independent_50.perf_branch_flushes != 0 ||
            u_independent_50.u_register_file.registers[19] !== 32'd50)
            $fatal(1, "50-instruction independent benchmark incorrect");
        if (u_independent_100.perf_instructions_retired != 100 ||
            u_independent_100.perf_instructions_completed_wb != 100 ||
            u_independent_100.perf_total_cycles != 104 ||
            u_independent_100.perf_stall_cycles != 0 ||
            u_independent_100.perf_branch_flushes != 0 ||
            u_independent_100.u_register_file.registers[7] !== 32'd100)
            $fatal(1, "100-instruction independent benchmark incorrect");
        if (u_dependent_50.perf_instructions_retired != 50 ||
            u_dependent_50.perf_instructions_completed_wb != 50 ||
            u_dependent_50.perf_total_cycles != 54 ||
            u_dependent_50.perf_stall_cycles != 0 ||
            u_dependent_50.perf_branch_flushes != 0 ||
            u_dependent_50.u_register_file.registers[1] !== 32'd50)
            $fatal(1, "50-instruction dependent benchmark incorrect");
        if (u_branch_heavy.perf_instructions_retired != 13 ||
            u_branch_heavy.perf_instructions_completed_wb != 13 ||
            u_branch_heavy.perf_branch_flushes != 4 ||
            u_branch_heavy.perf_taken_branches != 4 ||
            u_branch_heavy.perf_not_taken_branches != 1 ||
            u_branch_heavy.u_register_file.registers[1] !== 32'd5 ||
            u_branch_heavy.u_register_file.registers[3] !== 32'd7)
            $fatal(1, "branch-heavy benchmark incorrect");
        $display("PASS: 50/100 independent, 50 dependent, and branch-heavy benchmarks");

        performance_file = $fopen("simulation/performance.csv", "w");
        if (performance_file == 0)
            $fatal(1, "could not create simulation/performance.csv");
        $fdisplay(performance_file, "benchmark,cycles,retired,wb_completed,stalls,branch_flushes,taken_branches,not_taken_branches");
        report_benchmark("independent", u_independent.perf_total_cycles,
            u_independent.perf_instructions_retired, u_independent.perf_instructions_completed_wb,
            u_independent.perf_stall_cycles, u_independent.perf_branch_flushes,
            u_independent.perf_taken_branches, u_independent.perf_not_taken_branches);
        report_benchmark("dependent", u_dependencies.perf_total_cycles,
            u_dependencies.perf_instructions_retired, u_dependencies.perf_instructions_completed_wb,
            u_dependencies.perf_stall_cycles, u_dependencies.perf_branch_flushes,
            u_dependencies.perf_taken_branches, u_dependencies.perf_not_taken_branches);
        report_benchmark("load_use", u_load_use.perf_total_cycles,
            u_load_use.perf_instructions_retired, u_load_use.perf_instructions_completed_wb,
            u_load_use.perf_stall_cycles, u_load_use.perf_branch_flushes,
            u_load_use.perf_taken_branches, u_load_use.perf_not_taken_branches);
        report_benchmark("branches", u_branches.perf_total_cycles,
            u_branches.perf_instructions_retired, u_branches.perf_instructions_completed_wb,
            u_branches.perf_stall_cycles, u_branches.perf_branch_flushes,
            u_branches.perf_taken_branches, u_branches.perf_not_taken_branches);
        report_benchmark("three_addi", u_three_addi.perf_total_cycles,
            u_three_addi.perf_instructions_retired, u_three_addi.perf_instructions_completed_wb,
            u_three_addi.perf_stall_cycles, u_three_addi.perf_branch_flushes,
            u_three_addi.perf_taken_branches, u_three_addi.perf_not_taken_branches);
        report_benchmark("long_arithmetic", u_long_arithmetic.perf_total_cycles,
            u_long_arithmetic.perf_instructions_retired,
            u_long_arithmetic.perf_instructions_completed_wb,
            u_long_arithmetic.perf_stall_cycles, u_long_arithmetic.perf_branch_flushes,
            u_long_arithmetic.perf_taken_branches, u_long_arithmetic.perf_not_taken_branches);
        report_benchmark("independent_50", u_independent_50.perf_total_cycles,
            u_independent_50.perf_instructions_retired, u_independent_50.perf_instructions_completed_wb,
            u_independent_50.perf_stall_cycles, u_independent_50.perf_branch_flushes,
            u_independent_50.perf_taken_branches, u_independent_50.perf_not_taken_branches);
        report_benchmark("independent_100", u_independent_100.perf_total_cycles,
            u_independent_100.perf_instructions_retired, u_independent_100.perf_instructions_completed_wb,
            u_independent_100.perf_stall_cycles, u_independent_100.perf_branch_flushes,
            u_independent_100.perf_taken_branches, u_independent_100.perf_not_taken_branches);
        report_benchmark("dependent_50", u_dependent_50.perf_total_cycles,
            u_dependent_50.perf_instructions_retired, u_dependent_50.perf_instructions_completed_wb,
            u_dependent_50.perf_stall_cycles, u_dependent_50.perf_branch_flushes,
            u_dependent_50.perf_taken_branches, u_dependent_50.perf_not_taken_branches);
        report_benchmark("branch_heavy", u_branch_heavy.perf_total_cycles,
            u_branch_heavy.perf_instructions_retired, u_branch_heavy.perf_instructions_completed_wb,
            u_branch_heavy.perf_stall_cycles, u_branch_heavy.perf_branch_flushes,
            u_branch_heavy.perf_taken_branches, u_branch_heavy.perf_not_taken_branches);
        $fclose(performance_file);
        $display("PASS: retirement, stall, bubble, and flush counter assertions");

        $display("PROCESSOR INTEGRATION TESTS PASSED");
        $finish;
    end
endmodule
