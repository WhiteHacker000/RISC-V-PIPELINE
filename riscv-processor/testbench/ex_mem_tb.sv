module ex_mem_tb;
    logic clk;
    logic rst_n;
    logic stall;
    logic flush;
    logic [31:0] alu_result_in;
    logic [31:0] store_data_in;
    logic [31:0] branch_target_in;
    logic branch_taken_in;
    logic [4:0] rd_in;
    logic mem_read_in;
    logic mem_write_in;
    logic reg_write_in;
    logic mem_to_reg_in;
    logic [31:0] pc_plus4_in;
    logic [31:0] alu_result_out;
    logic [31:0] store_data_out;
    logic [31:0] branch_target_out;
    logic branch_taken_out;
    logic [4:0] rd_out;
    logic mem_read_out;
    logic mem_write_out;
    logic reg_write_out;
    logic mem_to_reg_out;
    logic [31:0] pc_plus4_out;

    always #5 clk = ~clk;

    ex_mem dut (.*);

    task automatic check_bubble(input string label);
        begin
            if ({alu_result_out, store_data_out, branch_target_out,
                 branch_taken_out, rd_out, mem_read_out, mem_write_out,
                 reg_write_out, mem_to_reg_out, pc_plus4_out} !== '0)
                $fatal(1, "%s: EX/MEM bubble was not zeroed", label);
        end
    endtask

    task automatic check_payload(input string label);
        begin
            if ({alu_result_out, store_data_out, branch_target_out,
                 branch_taken_out, rd_out, mem_read_out, mem_write_out,
                 reg_write_out, mem_to_reg_out, pc_plus4_out} !==
                {32'h1234_5678, 32'h2222_2222, 32'h0000_0100, 1'b1,
                 5'd7, 1'b1, 1'b1, 1'b1, 1'b1, 32'h0000_0084})
                $fatal(1, "%s: EX/MEM payload mismatch", label);
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        stall = 1'b0;
        flush = 1'b0;
        alu_result_in = 32'h1234_5678;
        store_data_in = 32'h2222_2222;
        branch_target_in = 32'h0000_0100;
        branch_taken_in = 1'b1;
        rd_in = 5'd7;
        mem_read_in = 1'b1;
        mem_write_in = 1'b1;
        reg_write_in = 1'b1;
        mem_to_reg_in = 1'b1;
        pc_plus4_in = 32'h0000_0084;

        @(posedge clk);
        #1;
        check_bubble("synchronous reset");

        rst_n = 1'b1;
        @(posedge clk);
        #1;
        check_payload("capture");

        stall = 1'b1;
        alu_result_in = 32'hdead_beef;
        rd_in = 5'd9;
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
        alu_result_in = 32'h1234_5678;
        rd_in = 5'd7;
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

        $display("ex_mem_tb PASS");
        $finish;
    end
endmodule
