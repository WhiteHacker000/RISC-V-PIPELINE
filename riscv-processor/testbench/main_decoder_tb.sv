module main_decoder_tb;
    logic [6:0] opcode;
    logic reg_write;
    logic mem_read;
    logic mem_write;
    logic branch;
    logic alu_src;
    logic [1:0] alu_op;
    logic mem_to_reg;

    main_decoder dut (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .mem_to_reg(mem_to_reg)
    );

    task automatic check_decode(
        input logic [6:0] test_opcode,
        input logic [7:0] expected,
        input string name
    );
        begin
            opcode = test_opcode;
            #1;
            if ({reg_write, mem_read, mem_write, branch,
                 alu_src, alu_op, mem_to_reg} !== expected)
                $fatal(1, "%s decode mismatch: %b", name,
                       {reg_write, mem_read, mem_write, branch,
                        alu_src, alu_op, mem_to_reg});
        end
    endtask

    initial begin
        check_decode(7'b0110011, 8'b1000_0100, "R-type");
        check_decode(7'b0010011, 8'b1000_1000, "ADDI");
        check_decode(7'b0000011, 8'b1100_1001, "load");
        check_decode(7'b0100011, 8'b0010_1000, "store");
        check_decode(7'b1100011, 8'b0001_0010, "branch");
        check_decode(7'b1111111, 8'b0000_0000, "unsupported");

        $display("main_decoder_tb PASS");
        $finish;
    end
endmodule

