module program_counter_tb;
    logic clk = 1'b0;
    logic rst_n;
    logic stall;
    logic branch_taken;
    logic [31:0] branch_target;
    logic [31:0] current_pc;

    always #5 clk = ~clk;

    program_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .current_pc(current_pc)
    );

    initial begin
        rst_n = 1'b0;
        stall = 1'b0;
        branch_taken = 1'b0;
        branch_target = 32'b0;
        #1;
        if (current_pc !== 32'b0)
            $fatal(1, "reset must set PC to zero");

        rst_n = 1'b1;
        @(posedge clk);
        #1;
        if (current_pc !== 32'd4)
            $fatal(1, "sequential PC increment failed: %h", current_pc);

        stall = 1'b1;
        @(posedge clk);
        #1;
        if (current_pc !== 32'd4)
            $fatal(1, "stall must hold PC");

        branch_taken = 1'b1;
        branch_target = 32'h0000_0040;
        @(posedge clk);
        #1;
        if (current_pc !== 32'h0000_0040)
            $fatal(1, "branch redirect must override stall");

        branch_taken = 1'b0;
        stall = 1'b0;
        @(posedge clk);
        #1;
        if (current_pc !== 32'h0000_0044)
            $fatal(1, "sequential increment after branch failed");

        $display("program_counter_tb PASS");
        $finish;
    end
endmodule

