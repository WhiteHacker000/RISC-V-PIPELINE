module wb_stage (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] alu_result_in,
    input  logic [31:0] mem_read_data_in,
    input  logic [4:0]  rd_in,
    input  logic        reg_write_in,
    input  logic        mem_to_reg_in,
    output logic [31:0] write_data,
    output logic [4:0]  rd_out,
    output logic        reg_write_out
);
    // Write back to register file
    assign write_data = mem_to_reg_in ? mem_read_data_in : alu_result_in;
    assign rd_out = rd_in;
    assign reg_write_out = reg_write_in;

endmodule