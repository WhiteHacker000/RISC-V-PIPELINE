module control_unit_tb;
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic reg_write;
    logic mem_read;
    logic mem_write;
    logic branch;
    logic branch_not_equal;
    logic alu_src;
    logic [1:0] alu_op;
    logic [2:0] alu_control;
    logic mem_to_reg;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .branch_not_equal(branch_not_equal),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .alu_control(alu_control),
        .mem_to_reg(mem_to_reg)
    );

    task automatic check_decode(
        input logic [6:0] test_opcode,
        input logic [2:0] test_funct3,
        input logic [6:0] test_funct7,
        input logic [11:0] expected,
        input string name
    );
        begin
            opcode = test_opcode;
            funct3 = test_funct3;
            funct7 = test_funct7;
            #1;
            if ({reg_write, mem_read, mem_write, branch,
                 branch_not_equal, alu_src, alu_op,
                 alu_control, mem_to_reg} !== expected)
                $fatal(1, "%s decode mismatch: %b", name,
                       {reg_write, mem_read, mem_write, branch,
                        branch_not_equal, alu_src, alu_op,
                        alu_control, mem_to_reg});
        end
    endtask

    initial begin
        check_decode(7'b0110011, 3'b000, 7'b0000000,
                     12'b100000_100_000, "ADD");
        check_decode(7'b0110011, 3'b000, 7'b0100000,
                     12'b100000_100_010, "SUB");
        check_decode(7'b0010011, 3'b000, 7'b0000000,
                     12'b100001_000_000, "ADDI");
        check_decode(7'b0000011, 3'b010, 7'b0000000,
                     12'b110001_000_001, "LW");
        check_decode(7'b0100011, 3'b010, 7'b0000000,
                     12'b001001_000_000, "SW");
        check_decode(7'b1100011, 3'b000, 7'b0000000,
                     12'b000100_010_010, "BEQ");
        check_decode(7'b1100011, 3'b001, 7'b0000000,
                     12'b000110_010_010, "BNE");
        check_decode(7'b0110011, 3'b111, 7'b0000000,
                     12'b000000_000_000, "unsupported R-type");

        $display("control_unit_tb PASS");
        $finish;
    end
endmodule

