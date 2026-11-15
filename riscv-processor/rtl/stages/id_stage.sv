module id_stage (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        stall,
    input  logic        flush,
    input  logic [31:0] pc_in,
    input  logic [31:0] instruction_in,
    output logic [31:0] pc_out,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
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
    // Register file read, immediate generation, control signal generation
    assign pc_out = pc_in;
    assign rs1_data = 32'h0;
    assign rs2_data = 32'h0;
    assign imm_out = 32'h0;
    assign rd_out = 5'h0;
    assign funct3_out = 3'h0;
    assign opcode_out = 7'h0;
    assign reg_write_out = 1'b0;
    assign mem_read_out = 1'b0;
    assign mem_write_out = 1'b0;
    assign branch_out = 1'b0;
    assign alu_src_out = 1'b0;
    assign alu_op_out = 2'h0;
    assign mem_to_reg_out = 1'b0;

endmodule