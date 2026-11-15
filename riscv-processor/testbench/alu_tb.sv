module alu_tb;

    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [2:0]  alu_control;

    logic [31:0] alu_result;
    logic        zero;

    integer passed = 0;
    integer failed = 0;

    alu dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

    task automatic check_result(
        input logic [2:0] operation,
        input logic [31:0] a,
        input logic [31:0] b,
        input logic [31:0] expected
    );

        begin
            alu_control = operation;
            operand_a = a;
            operand_b = b;

            #1;

            if (alu_result === expected &&
                zero === (expected == 32'b0)) begin

                passed++;

                $display(
                    "PASS | OP=%b | A=%h | B=%h | RESULT=%h",
                    operation, a, b, alu_result
                );

            end
            else begin

                failed++;

                $display(
                    "FAIL | OP=%b | EXPECTED=%h | ACTUAL=%h",
                    operation, expected, alu_result
                );

            end
        end

    endtask

    initial begin

        $dumpfile("simulation/alu.vcd");
        $dumpvars(0, alu_tb);

        $display("\n========== ALU TESTING STARTED ==========\n");

        // ADD
        check_result(3'b000, 10, 20, 30);

        // SUB
        check_result(3'b001, 30, 10, 20);

        // AND
        check_result(3'b010, 32'hFF00, 32'h0FF0, 32'h0F00);

        // OR
        check_result(3'b011, 32'hF000, 32'h00FF, 32'hF0FF);

        // XOR
        check_result(3'b100, 32'hAAAA, 32'h5555, 32'hFFFF);

        // SLT: Signed comparison
        check_result(3'b101, 32'hFFFFFFFF, 1, 1);

        // SLTU: Unsigned comparison
        check_result(3'b110, 32'hFFFFFFFF, 1, 0);

        // ADD: Overflow / wraparound
        check_result(3'b000, 32'hFFFFFFFF, 1, 0);

        // SUB: Zero result
        check_result(3'b001, 100, 100, 0);

        // Default operation
        check_result(3'b111, 10, 20, 0);

        $display("\n========== TEST SUMMARY ==========");
        $display("PASSED: %0d", passed);
        $display("FAILED: %0d", failed);

        if (failed == 0)
            $display("ALU VERIFICATION SUCCESSFUL");
        else
            $fatal(1, "ALU VERIFICATION FAILED");

        $finish;

    end

endmodule