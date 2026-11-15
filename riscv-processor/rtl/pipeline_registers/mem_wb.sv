module mem_wb (
    input  logic        clk,
    input  logic        rst_n,
    // Inputs
    input  logic [31:0] alu_result_in,
    input  logic [31:0] mem_read_data_in,
    input  logic [4:0]  rd_in,
    input  logic        reg_write_in,
    input  logic        mem_to_reg_in,
    // Outputs
    output logic [31:0] alu_result_out,
    output logic [31:0] mem_read_data_out,
    output logic [4:0]  rd_out,
    output logic        reg_write_out,
    output logic        mem_to_reg_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alu_result_out <= 32'h0;
            mem_read_data_out <= 32'h0;
            rd_out <= 5'h0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            mem_read_data_out <= mem_read_data_in;
            rd_out <= rd_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end
endmodule