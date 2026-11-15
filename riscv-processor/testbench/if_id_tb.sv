module if_id_tb;
    logic clk;
    logic rst_n;
    logic stall;
    logic flush;
    logic [31:0] pc_in;
    logic [31:0] pc_plus4_in;
    logic [31:0] instruction_in;
    logic [31:0] pc_out;
    logic [31:0] pc_plus4_out;
    logic [31:0] instruction_out;

    always #5 clk = ~clk;

    if_id dut (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall),
        .flush(flush),
        .pc_in(pc_in),
        .pc_plus4_in(pc_plus4_in),
        .instruction_in(instruction_in),
        .pc_out(pc_out),
        .pc_plus4_out(pc_plus4_out),
        .instruction_out(instruction_out)
    );

    task automatic check(
        input logic [31:0] expected_pc,
        input logic [31:0] expected_pc_plus4,
        input logic [31:0] expected_instruction,
        input string label
    );
        begin
            if ({pc_out, pc_plus4_out, instruction_out} !==
                {expected_pc, expected_pc_plus4, expected_instruction})
                $fatal(1, "%s: IF/ID payload mismatch", label);
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        stall = 1'b0;
        flush = 1'b0;
        pc_in = 32'h100;
        pc_plus4_in = 32'h104;
        instruction_in = 32'h0050_0093;

        @(posedge clk);
        #1;
        check(32'b0, 32'b0, 32'h0000_0013, "synchronous reset");

        rst_n = 1'b1;
        @(posedge clk);
        #1;
        check(32'h100, 32'h104, 32'h0050_0093, "capture");

        stall = 1'b1;
        pc_in = 32'h200;
        pc_plus4_in = 32'h204;
        instruction_in = 32'hfff0_0113;
        @(posedge clk);
        #1;
        check(32'h100, 32'h104, 32'h0050_0093, "stall hold");

        flush = 1'b1;
        @(posedge clk);
        #1;
        check(32'b0, 32'b0, 32'h0000_0013, "flush overrides stall");

        flush = 1'b0;
        stall = 1'b0;
        pc_in = 32'h300;
        pc_plus4_in = 32'h304;
        instruction_in = 32'h0020_81b3;
        @(posedge clk);
        #1;
        check(32'h300, 32'h304, 32'h0020_81b3, "capture after flush");

        rst_n = 1'b0;
        #1;
        check(32'h300, 32'h304, 32'h0020_81b3, "reset is synchronous");
        @(posedge clk);
        #1;
        check(32'b0, 32'b0, 32'h0000_0013, "reset edge");

        $display("if_id_tb PASS");
        $finish;
    end
endmodule
