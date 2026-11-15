module id_ex_tb;
    logic clk;
    logic rst_n;
    logic stall;
    logic flush;
    logic [31:0] pc_in;
    logic [31:0] pc_plus4_in;
    logic [31:0] rs1_data_in;
    logic [31:0] rs2_data_in;
    logic [31:0] imm_in;
    logic [4:0] rs1_in;
    logic [4:0] rs2_in;
    logic [4:0] rd_in;
    logic [2:0] alu_control_in;
    logic reg_write_in;
    logic mem_read_in;
    logic mem_write_in;
    logic branch_in;
    logic branch_not_equal_in;
    logic alu_src_in;
    logic mem_to_reg_in;
    logic [31:0] pc_out;
    logic [31:0] pc_plus4_out;
    logic [31:0] rs1_data_out;
    logic [31:0] rs2_data_out;
    logic [31:0] imm_out;
    logic [4:0] rs1_out;
    logic [4:0] rs2_out;
    logic [4:0] rd_out;
    logic [2:0] alu_control_out;
    logic reg_write_out;
    logic mem_read_out;
    logic mem_write_out;
    logic branch_out;
    logic branch_not_equal_out;
    logic alu_src_out;
    logic mem_to_reg_out;

    always #5 clk = ~clk;

    id_ex dut (.*);

    task automatic check_bubble(input string label);
        begin
            if ({pc_out, pc_plus4_out, rs1_data_out, rs2_data_out, imm_out,
                 rs1_out, rs2_out, rd_out, alu_control_out, reg_write_out,
                 mem_read_out, mem_write_out, branch_out,
                 branch_not_equal_out, alu_src_out, mem_to_reg_out} !== '0)
                $fatal(1, "%s: ID/EX bubble was not zeroed", label);
        end
    endtask

    task automatic check_payload(input string label);
        begin
            if ({pc_out, pc_plus4_out, rs1_data_out, rs2_data_out, imm_out,
                 rs1_out, rs2_out, rd_out, alu_control_out, reg_write_out,
                 mem_read_out, mem_write_out, branch_out,
                 branch_not_equal_out, alu_src_out, mem_to_reg_out} !==
                {32'h100, 32'h104, 32'h1111_1111, 32'h2222_2222,
                 32'hffff_fffc, 5'd1, 5'd2, 5'd3, 3'b001, 1'b1, 1'b1,
                 1'b1, 1'b1, 1'b1, 1'b1, 1'b1})
                $fatal(1, "%s: ID/EX payload mismatch", label);
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        stall = 1'b0;
        flush = 1'b0;
        pc_in = 32'h100;
        pc_plus4_in = 32'h104;
        rs1_data_in = 32'h1111_1111;
        rs2_data_in = 32'h2222_2222;
        imm_in = 32'hffff_fffc;
        rs1_in = 5'd1;
        rs2_in = 5'd2;
        rd_in = 5'd3;
        alu_control_in = 3'b001;
        reg_write_in = 1'b1;
        mem_read_in = 1'b1;
        mem_write_in = 1'b1;
        branch_in = 1'b1;
        branch_not_equal_in = 1'b1;
        alu_src_in = 1'b1;
        mem_to_reg_in = 1'b1;

        @(posedge clk);
        #1;
        check_bubble("synchronous reset");

        rst_n = 1'b1;
        @(posedge clk);
        #1;
        check_payload("capture");

        stall = 1'b1;
        pc_in = 32'h200;
        rs1_data_in = 32'hdead_beef;
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
        pc_in = 32'h100;
        rs1_data_in = 32'h1111_1111;
        rd_in = 5'd3;
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

        $display("id_ex_tb PASS");
        $finish;
    end
endmodule
