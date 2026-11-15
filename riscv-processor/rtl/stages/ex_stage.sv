module ex_stage (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        stall,
    input  logic        flush,
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
    output logic [31:0] pc_out,
    output logic [31:0] alu_result,
    output logic [31:0] rs2_data_out,
    output logic [4:0]  rd_out,
    output logic        reg_write_out,
    output logic        mem_read_out,
    output logic        mem_write_out,
    output logic        branch_out,
    output logic        zero_flag,
    output logic        mem_to_reg_out
);
    // ALU operation, branch evaluation
    assign pc_out = pc_in;
    assign alu_result = 32'h0;
    assign rs2_data_out = rs2_data_in;
    assign rd_out = rd_in;
    assign reg_write_out = reg_write_in;
    assign mem_read_out = mem_read_in;
    assign mem_write_out = mem_write_in;
    assign branch_out = branch_in;
    assign zero_flag = 1'b0;
    assign mem_to_reg_out = mem_to_reg_in;

endmodule