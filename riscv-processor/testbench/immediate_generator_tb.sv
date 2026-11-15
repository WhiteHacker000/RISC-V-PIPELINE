module immediate_generator_tb;
    logic [31:0] instruction;
    logic [31:0] immediate;

    immediate_generator dut (
        .instruction(instruction),
        .immediate(immediate)
    );

    function automatic logic [31:0] encode_s(input logic signed [11:0] imm);
        encode_s = {imm[11:5], 5'd2, 5'd1, 3'b010, imm[4:0], 7'b0100011};
    endfunction

    function automatic logic [31:0] encode_b(input logic signed [12:0] imm);
        encode_b = {imm[12], imm[10:5], 5'd2, 5'd1, 3'b000,
                    imm[4:1], imm[11], 7'b1100011};
    endfunction

    initial begin
        instruction = 32'hfff0_0093;
        #1;
        if (immediate !== 32'hffff_ffff)
            $fatal(1, "I-type sign extension failed: %h", immediate);

        instruction = encode_s(-12'sd4);
        #1;
        if (immediate !== 32'hffff_fffc)
            $fatal(1, "S-type reconstruction failed: %h", immediate);

        instruction = encode_b(-13'sd4);
        #1;
        if (immediate !== 32'hffff_fffc)
            $fatal(1, "negative B-type reconstruction failed: %h", immediate);

        instruction = encode_b(13'sd10);
        #1;
        if (immediate !== 32'd10)
            $fatal(1, "positive B-type reconstruction failed: %h", immediate);

        instruction = 32'h0000_0037;
        #1;
        if (immediate !== 32'b0)
            $fatal(1, "unsupported format must produce zero");

        $display("immediate_generator_tb PASS");
        $finish;
    end
endmodule

