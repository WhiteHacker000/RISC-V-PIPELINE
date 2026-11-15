module register_file_tb;
    logic clk;
    logic write_enable;
    logic [4:0] read_addr1;
    logic [4:0] read_addr2;
    logic [4:0] write_addr;
    logic [31:0] write_data;
    logic [31:0] read_data1;
    logic [31:0] read_data2;

    always #5 clk = ~clk;

    register_file dut (
        .clk(clk),
        .write_enable(write_enable),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    initial begin
        clk = 1'b0;
        write_enable = 1'b0;
        read_addr1 = 5'd0;
        read_addr2 = 5'd0;
        write_addr = 5'd0;
        write_data = 32'b0;

        #1;
        if (read_data1 !== 32'b0 || read_data2 !== 32'b0)
            $fatal(1, "x0 must always read as zero");

        write_enable = 1'b1;
        write_addr = 5'd5;
        write_data = 32'h1234_5678;
        @(posedge clk);
        #1;

        read_addr1 = 5'd5;
        read_addr2 = 5'd0;
        #1;
        if (read_data1 !== 32'h1234_5678 || read_data2 !== 32'b0)
            $fatal(1, "register write or asynchronous read failed");

        write_addr = 5'd0;
        write_data = 32'hdead_beef;
        @(posedge clk);
        #1;
        read_addr1 = 5'd0;
        #1;
        if (read_data1 !== 32'b0)
            $fatal(1, "writes to x0 must be ignored");

        $display("register_file_tb PASS");
        $finish;
    end
endmodule
