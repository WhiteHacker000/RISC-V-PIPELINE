module program_counter #(
    parameter int WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic             stall,
    input  logic             branch_taken,
    input  logic [WIDTH-1:0] branch_target,
    output logic [WIDTH-1:0] current_pc
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_pc <= '0;
        else if (branch_taken)
            current_pc <= branch_target;
        else if (!stall)
            current_pc <= current_pc + WIDTH'(4);
    end
endmodule
