module ex_mem (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        stall,
    input  logic        flush,
    input  logic [31:0] alu_result_in,
    input  logic [31:0] store_data_in,
    input  logic [31:0] branch_target_in,
    input  logic        branch_taken_in,
    input  logic [4:0]  rd_in,
    input  logic        mem_read_in,
    input  logic        mem_write_in,
    input  logic        reg_write_in,
    input  logic        mem_to_reg_in,
    input  logic [31:0] pc_plus4_in,
    output logic [31:0] alu_result_out,
    output logic [31:0] store_data_out,
    output logic [31:0] branch_target_out,
    output logic        branch_taken_out,
    output logic [4:0]  rd_out,
    output logic        mem_read_out,
    output logic        mem_write_out,
    output logic        reg_write_out,
    output logic        mem_to_reg_out,
    output logic [31:0] pc_plus4_out
);
    always_ff @(posedge clk) begin
        if (!rst_n || flush) begin
            alu_result_out <= 32'b0;
            store_data_out <= 32'b0;
            branch_target_out <= 32'b0;
            branch_taken_out <= 1'b0;
            rd_out <= 5'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            pc_plus4_out <= 32'b0;
        end else if (!stall) begin
            alu_result_out <= alu_result_in;
            store_data_out <= store_data_in;
            branch_target_out <= branch_target_in;
            branch_taken_out <= branch_taken_in;
            rd_out <= rd_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            pc_plus4_out <= pc_plus4_in;
        end
    end
endmodule
