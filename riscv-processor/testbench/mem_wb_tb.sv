module mem_wb_tb;
    logic clk;
    logic rst_n;
    logic stall;
    logic flush;
    logic [31:0] mem_read_data_in;
    logic [31:0] alu_result_in;
    logic [4:0] rd_in;
    logic reg_write_in;
    logic mem_to_reg_in;
    logic [31:0] mem_read_data_out;
    logic [31:0] alu_result_out;
    logic [4:0] rd_out;
    logic reg_write_out;
    logic mem_to_reg_out;

    always #5 clk = ~clk;

    mem_wb dut (.*);

    task automatic check_bubble(input string label);
        begin
            if ({mem_read_data_out, alu_result_out, rd_out,
                 reg_write_out, mem_to_reg_out} !== '0)
                $fatal(1, "%s: MEM/WB bubble was not zeroed", label);
        end
    endtask

    task automatic check_payload(input string label);
        begin
            if ({mem_read_data_out, alu_result_out, rd_out,
                 reg_write_out, mem_to_reg_out} !==
                {32'hcafebabe, 32'h1234_5678, 5'd11, 1'b1, 1'b1})
                $fatal(1, "%s: MEM/WB payload mismatch", label);
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        stall = 1'b0;
        flush = 1'b0;
        mem_read_data_in = 32'hcafe_babe;
        alu_result_in = 32'h1234_5678;
        rd_in = 5'd11;
        reg_write_in = 1'b1;
        mem_to_reg_in = 1'b1;

        @(posedge clk);
        #1;
        check_bubble("synchronous reset");

        rst_n = 1'b1;
        @(posedge clk);
        #1;
        check_payload("capture");

        stall = 1'b1;
        mem_read_data_in = 32'hdead_beef;
        rd_in = 5'd3;
        reg_write_in = 1'b0;
        @(posedge clk);
        #1;
        check_payload("stall hold");

        flush = 1'b1;
        @(posedge clk);
        #1;
        check_bubble("flush overrides stall");

        flush = 1'b0;
        stall = 1'b0;
        mem_read_data_in = 32'hcafe_babe;
        rd_in = 5'd11;
        reg_write_in = 1'b1;
        @(posedge clk);
        #1;
        check_payload("capture before reset");

        rst_n = 1'b0;
        #1;
        check_payload("reset is synchronous");
        @(posedge clk);
        #1;
        check_bubble("reset edge");

        $display("mem_wb_tb PASS");
        $finish;
    end
endmodule
