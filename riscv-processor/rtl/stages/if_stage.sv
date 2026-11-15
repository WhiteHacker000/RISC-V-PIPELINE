module if_stage (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        stall,
    input  logic        flush,
    input  logic [31:0] pc_next,
    output logic [31:0] pc_current,
    output logic [31:0] instruction
);
    logic [31:0] pc_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_reg <= 32'h0000_0000;
        end else if (!stall) begin
            pc_reg <= pc_next;
        end
    end

    assign pc_current = pc_reg;
    // Instruction memory interface would go here
    assign instruction = 32'h0000_0000; // Placeholder

endmodule