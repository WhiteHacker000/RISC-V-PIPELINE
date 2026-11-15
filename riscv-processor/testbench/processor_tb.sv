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

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_dependencies.hex")
    ) u_dependencies (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_independent.hex")
    ) u_independent (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_load_use.hex")
    ) u_load_use (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_branches.hex")
    ) u_branches (
        .clk(clk),
        .rst_n(rst_n)
    );

    riscv_top #(
        .IMEM_INIT_FILE("programs/processor_three_addi.hex")
    ) u_three_addi (
        .clk(clk),
        .rst_n(rst_n)
    );

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

        #12 rst_n = 1'b1;
        repeat (40) @(negedge clk);
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

        $display("PROCESSOR INTEGRATION TESTS PASSED");
        $finish;
    end
endmodule
