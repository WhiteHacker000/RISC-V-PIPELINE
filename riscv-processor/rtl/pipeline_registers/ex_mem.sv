module ex_mem (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        flush,
    // Inputs
    input  logic [31:0] pc_in,
    input  logic [31:0] alu_result_in,
    input  logic [31:0] rs2_data_in,
    input  logic [4:0]  rd_in,
    input  logic        reg_write_in,
    input  logic        mem_read_in,
    input  logic        mem_write_in,
    input  logic        branch_in,
    input  logic        zero_flag_in,
    input  logic        mem_to_reg_in,
    // Outputs
    output logic [31:0] pc_out,
    output logic [31:0] alu_result_out,
    output logic [31:0] rs2_data_out,
    output logic [4:0]  rd_out,
    output logic        reg_write_out,
    output logic        mem_read_out,
    output logic        mem_write_out,
    output logic        branch_out,
    output logic        zero_flag_out,
    output logic        mem_to_reg_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_out <= 32'h0;
            alu_result_out <= 32'h0;
            rs2_data_out <= 32'h0;
            rd_out <= 5'h0;
            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            branch_out <= 1'b0;
            zero_flag_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else if (flush) begin
            pc_out <= 32'h0;
            alu_result_out <= 32'h0;
            rs2_data_out <= 32'h0;
            rd_out <= 5'h0;
            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            branch_out <= 1'b0;
            zero_flag_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else begin
            pc_out <= pc_in;
            alu_result_out <= alu_result_in;
            rs2_data_out <= rs2_data_in;
            rd_out <= rd_in;
            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            branch_out <= branch_in;
            zero_flag_out <= zero_flag_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end
endmodule