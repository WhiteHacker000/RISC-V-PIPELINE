module mem_stage (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        stall,
    input  logic        flush,
    input  logic [31:0] alu_result_in,
    input  logic [31:0] rs2_data_in,
    input  logic [4:0]  rd_in,
    input  logic        reg_write_in,
    input  logic        mem_read_in,
    input  logic        mem_write_in,
    input  logic        mem_to_reg_in,
    output logic [31:0] alu_result_out,
    output logic [31:0] mem_read_data,
    output logic [4:0]  rd_out,
    output logic        reg_write_out,
    output logic        mem_to_reg_out
);
    // Data memory access
    assign alu_result_out = alu_result_in;
    assign mem_read_data = 32'h0;
    assign rd_out = rd_in;
    assign reg_write_out = reg_write_in;
    assign mem_to_reg_out = mem_to_reg_in;

endmodule