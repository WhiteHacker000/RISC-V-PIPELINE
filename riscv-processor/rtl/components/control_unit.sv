module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       reg_write,
    output logic       mem_read,
    output logic       mem_write,
    output logic       branch,
    output logic       branch_not_equal,
    output logic       alu_src,
    output logic [1:0] alu_op,
    output logic [2:0] alu_control,
    output logic       mem_to_reg
);
    logic decoded_reg_write;
    logic decoded_mem_read;
    logic decoded_mem_write;
    logic decoded_branch;
    logic decoded_alu_src;
    logic [1:0] decoded_alu_op;
    logic decoded_mem_to_reg;
    logic instruction_valid;

    main_decoder decoder (
        .opcode(opcode),
        .reg_write(decoded_reg_write),
        .mem_read(decoded_mem_read),
        .mem_write(decoded_mem_write),
        .branch(decoded_branch),
        .alu_src(decoded_alu_src),
        .alu_op(decoded_alu_op),
        .mem_to_reg(decoded_mem_to_reg)
    );

    always_comb begin
        instruction_valid = 1'b0;
        alu_control = 3'b000;

        case (opcode)
            7'b0110011: begin
                if ((funct3 == 3'b000) &&
                    ((funct7 == 7'b0000000) || (funct7 == 7'b0100000))) begin
                    instruction_valid = 1'b1;
                    if (funct7 == 7'b0100000)
                        alu_control = 3'b001;
                end
            end
            7'b0010011: begin
                instruction_valid = (funct3 == 3'b000);
            end
            7'b0000011, 7'b0100011: begin
                instruction_valid = (funct3 == 3'b010);
            end
            7'b1100011: begin
                instruction_valid = (funct3 == 3'b000) || (funct3 == 3'b001);
                alu_control = 3'b001;
            end
            default: begin
            end
        endcase
    end

    always_comb begin
        reg_write = decoded_reg_write && instruction_valid;
        mem_read = decoded_mem_read && instruction_valid;
        mem_write = decoded_mem_write && instruction_valid;
        branch = decoded_branch && instruction_valid;
        branch_not_equal = branch && (funct3 == 3'b001);
        alu_src = decoded_alu_src && instruction_valid;
        alu_op = instruction_valid ? decoded_alu_op : 2'b00;
        mem_to_reg = decoded_mem_to_reg && instruction_valid;
    end
endmodule
