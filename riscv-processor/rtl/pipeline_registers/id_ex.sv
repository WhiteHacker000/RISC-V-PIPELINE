module id_ex (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        flush,
    // Inputs
    input  logic [31:0] pc_in,
    input  logic [31:0] rs1_data_in,
    input  logic [31:0] rs2_data_in,
    input  logic [31:0] imm_in,
    input  logic [4:0]  rd_in,
    input  logic [2:0]  funct3_in,
    input  logic [6:0]  opcode_in,
    input  logic        reg_write_in,
    input  logic        mem_read_in,
    input  logic        mem_write_in,
    input  logic        branch_in,
    input  logic        alu_src_in,
    input  logic [1:0]  alu_op_in,
    input  logic        mem_to_reg_in,
    // Outputs
    output logic [31:0] pc_out,
    output logic [31:0] rs1_data_out,
    output logic [31:0] rs2_data_out,
    output logic [31:0] imm_out,
    output logic [4:0]  rd_out,
    output logic [2:0]  funct3_out,
    output logic [6:0]  opcode_out,
    output logic        reg_write_out,
    output logic        mem_read_out,
    output logic        mem_write_out,
    output logic        branch_out,
    output logic        alu_src_out,
    output logic [1:0]  alu_op_out,
    output logic        mem_to_reg_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_out <= 32'h0;
            rs1_data_out <= 32'h0;
            rs2_data_out <= 32'h0;
            imm_out <= 32'h0;
            rd_out <= 5'h0;
            funct3_out <= 3'h0;
            opcode_out <= 7'h0;
            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            branch_out <= 1'b0;
            alu_src_out <= 1'b0;
            alu_op_out <= 2'h0;
            mem_to_reg_out <= 1'b0;
        end else if (flush) begin
            pc_out <= 32'h0;
            rs1_data_out <= 32'h0;
            rs2_data_out <= 32'h0;
            imm_out <= 32'h0;
            rd_out <= 5'h0;
            funct3_out <= 3'h0;
            opcode_out <= 7'h0;
            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            branch_out <= 1'b0;
            alu_src_out <= 1'b0;
            alu_op_out <= 2'h0;
            mem_to_reg_out <= 1'b0;
        end else begin
            pc_out <= pc_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            imm_out <= imm_in;
            rd_out <= rd_in;
            funct3_out <= funct3_in;
            opcode_out <= opcode_in;
            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            branch_out <= branch_in;
            alu_src_out <= alu_src_in;
            alu_op_out <= alu_op_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end
endmodule