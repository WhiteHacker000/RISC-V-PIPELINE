module data_memory #(
    parameter int ADDR_WIDTH = 32,
    parameter int WORD_COUNT = 256,
    parameter INIT_FILE = ""
) (
    input  logic                  clk,
    input  logic                  mem_read,
    input  logic                  mem_write,
    input  logic [ADDR_WIDTH-1:0] address,
    input  logic [31:0]           write_data,
    output logic [31:0]           read_data
);
    localparam int INDEX_WIDTH = (WORD_COUNT > 1) ? $clog2(WORD_COUNT) : 1;
    localparam logic [ADDR_WIDTH-3:0] WORD_COUNT_LIMIT =
        (ADDR_WIDTH-2)'(WORD_COUNT);

    logic [31:0] words [0:WORD_COUNT-1];
    logic [ADDR_WIDTH-3:0] word_address;
    logic [INDEX_WIDTH-1:0] memory_index;

    assign word_address = address[ADDR_WIDTH-1:2];
    assign memory_index = word_address[INDEX_WIDTH-1:0];

    initial begin
        for (int i = 0; i < WORD_COUNT; i++)
            words[i] = 32'b0;
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, words);
    end

    always_ff @(posedge clk) begin
        if (mem_write && (address[1:0] == 2'b00) &&
            (word_address < WORD_COUNT_LIMIT))
            words[memory_index] <= write_data;
    end

    always_comb begin
        read_data = 32'b0;
        if (mem_read && (address[1:0] == 2'b00) &&
            (word_address < WORD_COUNT_LIMIT))
            read_data = words[memory_index];
    end
endmodule
