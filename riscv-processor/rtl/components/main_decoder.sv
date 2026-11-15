module main_decoder (
    input  logic [6:0] opcode,
    output logic       reg_write,
    output logic       mem_read,
    output logic       mem_write,
    output logic       branch,
    output logic       alu_src,
    output logic [1:0] alu_op,
    output logic       mem_to_reg
);
    always_comb begin
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch = 1'b0;
        alu_src = 1'b0;
        alu_op = 2'b00;
        mem_to_reg = 1'b0;

        case (opcode)
            7'b0110011: begin
                reg_write = 1'b1;
                alu_op = 2'b10;
            end
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
            end
            7'b0000011: begin
                reg_write = 1'b1;
                mem_read = 1'b1;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
            end
            7'b0100011: begin
                mem_write = 1'b1;
                alu_src = 1'b1;
            end
            7'b1100011: begin
                branch = 1'b1;
                alu_op = 2'b01;
            end
            default: begin
            end
        endcase
    end
endmodule
