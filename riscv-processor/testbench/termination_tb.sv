module termination_tb;
    logic clk;
    logic rst_n;

    riscv_top #(.IMEM_INIT_FILE("programs/termination_nop_middle.hex"), .IMEM_PROGRAM_LENGTH(3))
        u_nop_middle (.clk(clk), .rst_n(rst_n));
    riscv_top #(.IMEM_INIT_FILE("programs/termination_nop_end.hex"), .IMEM_PROGRAM_LENGTH(2))
        u_nop_end (.clk(clk), .rst_n(rst_n));
    riscv_top #(.IMEM_INIT_FILE("programs/termination_no_nop.hex"), .IMEM_PROGRAM_LENGTH(2))
        u_no_nop (.clk(clk), .rst_n(rst_n));
    riscv_top #(.IMEM_INIT_FILE("programs/termination_dependent.hex"), .IMEM_PROGRAM_LENGTH(3))
        u_dependent (.clk(clk), .rst_n(rst_n));

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        repeat (2) @(posedge clk);
        #1 rst_n = 1'b1;

        wait (u_nop_middle.perf_done && u_nop_end.perf_done &&
              u_no_nop.perf_done && u_dependent.perf_done);
        @(negedge clk);
        #1;

        if (u_nop_middle.u_register_file.registers[1] !== 32'd5 ||
            u_nop_middle.u_register_file.registers[2] !== 32'd12)
            $fatal(1, "middle-NOP program register values are incorrect");
        if (u_nop_middle.perf_instructions_retired != 3)
            $fatal(1, "middle-NOP program retired %0d, expected 3",
                   u_nop_middle.perf_instructions_retired);

        if (u_nop_end.u_register_file.registers[3] !== 32'd9 ||
            u_nop_end.perf_instructions_retired != 2)
            $fatal(1, "trailing-NOP program did not execute and retire both instructions");

        if (u_no_nop.u_register_file.registers[4] !== 32'd4 ||
            u_no_nop.u_register_file.registers[5] !== 32'd5 ||
            u_no_nop.perf_instructions_retired != 2)
            $fatal(1, "program without NOPs has incorrect state or retirement count");

        if (u_dependent.u_register_file.registers[6] !== 32'd3 ||
            u_dependent.u_register_file.registers[7] !== 32'd7 ||
            u_dependent.u_register_file.registers[8] !== 32'd10 ||
            u_dependent.perf_instructions_retired != 3)
            $fatal(1, "dependent program has incorrect state or retirement count");

        if (u_nop_middle.perf_instructions_completed_wb != 3 ||
            u_nop_end.perf_instructions_completed_wb != 2 ||
            u_no_nop.perf_instructions_completed_wb != 2 ||
            u_dependent.perf_instructions_completed_wb != 3)
            $fatal(1, "WB-completion and retirement counts differ");

        if (u_nop_middle.perf_total_cycles != 7 || u_nop_end.perf_total_cycles != 6 ||
            u_no_nop.perf_total_cycles != 6 || u_dependent.perf_total_cycles != 7)
            $fatal(1, "pipeline fill/drain cycle count mismatch");

        if (u_nop_middle.ifid_perf_valid || u_nop_middle.idex_perf_valid ||
            u_nop_middle.exmem_perf_valid || u_nop_middle.memwb_perf_valid ||
            u_nop_end.ifid_perf_valid || u_nop_end.idex_perf_valid ||
            u_nop_end.exmem_perf_valid || u_nop_end.memwb_perf_valid ||
            u_no_nop.ifid_perf_valid || u_no_nop.idex_perf_valid ||
            u_no_nop.exmem_perf_valid || u_no_nop.memwb_perf_valid ||
            u_dependent.ifid_perf_valid || u_dependent.idex_perf_valid ||
            u_dependent.exmem_perf_valid || u_dependent.memwb_perf_valid)
            $fatal(1, "valid instructions remained in the pipeline after completion");

        $display("PASS: explicit program termination, literal NOP retirement and pipeline drain");
        $display("TERMINATION COUNTS: nop_middle=3 nop_end=2 no_nop=2 dependent=3");
        $finish;
    end

    initial begin
        #2000;
        $fatal(1, "termination_tb timed out");
    end
endmodule
