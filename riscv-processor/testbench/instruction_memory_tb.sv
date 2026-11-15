module instruction_memory_tb;
    logic [31:0] address;
    logic [31:0] instruction;

    instruction_memory #(
        .DEPTH(16),
        .INIT_FILE("testbench/programs/instruction_memory_tb.hex")
    ) dut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        address = 32'd0;
        #1;
        if (instruction !== 32'h0050_0093)
            $fatal(1, "program word 0 mismatch: %h", instruction);

        address = 32'd4;
        #1;
        if (instruction !== 32'hfff0_0113)
            $fatal(1, "program word 1 mismatch: %h", instruction);

        address = 32'd8;
        #1;
        if (instruction !== 32'h0000_0013)
            $fatal(1, "program word 2 mismatch: %h", instruction);

        address = 32'd12;
        #1;
        if (instruction !== 32'h0000_0013)
            $fatal(1, "uninitialized program word must default to NOP");

        address = 32'd1;
        #1;
        if (instruction !== 32'h0000_0013)
            $fatal(1, "unaligned instruction address must return NOP");

        address = 32'h0000_0100;
        #1;
        if (instruction !== 32'h0000_0013)
            $fatal(1, "out-of-range instruction address must return NOP");

        $display("instruction_memory_tb PASS");
        $finish;
    end
endmodule

