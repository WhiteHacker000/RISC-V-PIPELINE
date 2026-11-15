module pipeline_tb;
    logic clk;
    logic rst_n;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        #12 rst_n = 1;
        #1000 $finish;
    end

    // Pipeline stage instances would go here
    // if_stage u_if_stage (...);
    // id_stage u_id_stage (...);
    // ex_stage u_ex_stage (...);
    // mem_stage u_mem_stage (...);
    // wb_stage u_wb_stage (...);
    // Pipeline register instances would go here

    initial begin
        $dumpfile("pipeline_tb.vcd");
        $dumpvars(0, pipeline_tb);
    end
endmodule