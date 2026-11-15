module alu(
    input logic [31:0] operand_a,
    input logic [31:0] operand_b,
    input logic [2:0] alu_control,
    output logic [31:0] alu_result,
    output logic zero
);

    always_comb begin
        case(alu_control)
            3'b000: alu_result = operand_a + operand_b; // ADD
            3'b001: alu_result = operand_a - operand_b; // SUB
            3'b010: alu_result = operand_a & operand_b; // AND
            3'b011: alu_result = operand_a | operand_b; // OR
            3'b100: alu_result = operand_a ^ operand_b; // XOR
            3'b101: alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0; // SLT
            3'b110: alu_result = (operand_a < operand_b) ? 32'd1 : 32'd0;
            default: alu_result = 32'b0; // Default case

        endcase
    end
    assign zero = (alu_result == 32'b0);

endmodule