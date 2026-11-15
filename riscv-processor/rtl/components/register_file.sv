module register_file #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 5
) (
    input  logic                  clk,
    input  logic                  write_enable,
    input  logic [ADDR_WIDTH-1:0] read_addr1,
    input  logic [ADDR_WIDTH-1:0] read_addr2,
    input  logic [ADDR_WIDTH-1:0] write_addr,
    input  logic [DATA_WIDTH-1:0] write_data,
    output logic [DATA_WIDTH-1:0] read_data1,
    output logic [DATA_WIDTH-1:0] read_data2
);
    localparam int REGISTER_COUNT = 1 << ADDR_WIDTH;

    logic [DATA_WIDTH-1:0] registers [0:REGISTER_COUNT-1];

    always_ff @(posedge clk) begin
        if (write_enable && (write_addr != '0))
            registers[write_addr] <= write_data;
    end

    always_comb begin
        read_data1 = '0;
        read_data2 = '0;

        if (read_addr1 != '0)
            read_data1 = registers[read_addr1];
        if (read_addr2 != '0)
            read_data2 = registers[read_addr2];
    end
endmodule
