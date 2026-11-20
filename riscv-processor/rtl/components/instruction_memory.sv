module instruction_memory #(
    parameter int ADDR_WIDTH = 32,
    parameter int DEPTH = 256,
    parameter int PROGRAM_LENGTH = DEPTH,
    parameter INIT_FILE = "",
    parameter logic [31:0] NOP_INSTRUCTION = 32'h0000_0013
) (
    input  logic [ADDR_WIDTH-1:0] address,
    output logic [31:0]           instruction,
    output logic                  instruction_valid
);
    localparam int INDEX_WIDTH = (DEPTH > 1) ? $clog2(DEPTH) : 1;
    localparam logic [ADDR_WIDTH-3:0] DEPTH_LIMIT = (ADDR_WIDTH-2)'(DEPTH);

    logic [31:0] instructions [0:DEPTH-1];
    logic [ADDR_WIDTH-3:0] word_address;
    logic [INDEX_WIDTH-1:0] memory_index;

    assign word_address = address[ADDR_WIDTH-1:2];
    assign memory_index = word_address[INDEX_WIDTH-1:0];

    initial begin
        for (int i = 0; i < DEPTH; i++)
            instructions[i] = NOP_INSTRUCTION;
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, instructions);
    end

    always_comb begin
        instruction = NOP_INSTRUCTION;
        instruction_valid = 1'b0;
        if ((address[1:0] == 2'b00) && (word_address < DEPTH_LIMIT)) begin
            instruction = instructions[memory_index];
            instruction_valid = (word_address < (ADDR_WIDTH-2)'(PROGRAM_LENGTH));
        end
    end
endmodule
