module data_memory_tb;
    logic clk;
    logic mem_read;
    logic mem_write;
    logic [31:0] address;
    logic [31:0] write_data;
    logic [31:0] read_data;

    always #5 clk = ~clk;

    data_memory #(
        .WORD_COUNT(8)
    ) dut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    initial begin
        clk = 1'b0;
        mem_read = 1'b1;
        mem_write = 1'b0;
        address = 32'd0;
        write_data = 32'b0;
        #1;
        if (read_data !== 32'b0)
            $fatal(1, "data memory must initialize to zero");

        mem_write = 1'b1;
        address = 32'd4;
        write_data = 32'hcafe_babe;
        @(posedge clk);
        #1;
        mem_write = 1'b0;
        if (read_data !== 32'hcafe_babe)
            $fatal(1, "word store/load failed: %h", read_data);

        mem_write = 1'b1;
        address = 32'd5;
        write_data = 32'hdead_beef;
        @(posedge clk);
        #1;
        mem_write = 1'b0;
        address = 32'd4;
        #1;
        if (read_data !== 32'hcafe_babe)
            $fatal(1, "unaligned store must not modify memory");

        mem_read = 1'b0;
        #1;
        if (read_data !== 32'b0)
            $fatal(1, "disabled memory read must return zero");

        mem_read = 1'b1;
        address = 32'h0000_0020;
        #1;
        if (read_data !== 32'b0)
            $fatal(1, "out-of-range memory read must return zero");

        $display("data_memory_tb PASS");
        $finish;
    end
endmodule

