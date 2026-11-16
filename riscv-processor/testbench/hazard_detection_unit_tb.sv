module hazard_detection_unit_tb;
    logic idex_mem_read, ifid_uses_rs1, ifid_uses_rs2, branch_taken;
    logic [4:0] idex_rd, ifid_rs1, ifid_rs2;
    logic stall_pc, stall_ifid, flush_idex;
    hazard_detection_unit dut(.*);
    task automatic check(input logic s, input logic f);
        #1;
        if ({stall_pc,stall_ifid,flush_idex} !== {s,s,f})
            $fatal(1,"hazard mismatch got %b%b%b",stall_pc,stall_ifid,flush_idex);
    endtask
    initial begin
        idex_mem_read=1; idex_rd=5'd5; ifid_rs1=5'd5; ifid_rs2=0;
        ifid_uses_rs1=1; ifid_uses_rs2=0; branch_taken=0; check(1,1);
        ifid_rs1=5'd6; check(0,0); // independent instruction
        ifid_uses_rs2=1; ifid_rs2=5'd5; check(1,1); // second operand dependency
        idex_rd=0; ifid_rs1=0; ifid_rs2=0; check(0,0); // x0
        idex_rd=5'd5; branch_taken=1; check(0,1); // redirect wins, bubble decode
        // Corner cases (added by verification coverage pass)
        branch_taken=0; idex_mem_read=0; idex_rd=5'd5; ifid_rs1=5'd5; ifid_rs2=5'd5;
        ifid_uses_rs1=1; ifid_uses_rs2=1; check(0,0); // ALU producer: forwarding, never a stall
        idex_mem_read=1; check(1,1); // load feeding both operands
        ifid_uses_rs1=0; ifid_uses_rs2=0; check(0,0); // fields match but unused (e.g. no-source decode)
        ifid_uses_rs1=1; ifid_rs1=5'd6; ifid_uses_rs2=0; check(0,0); // ADDI-style: rs2 field matches, unused
        ifid_uses_rs2=1; check(1,1); // SW-style: rs2 is store data, used
        idex_mem_read=0; branch_taken=1; check(0,1); // taken branch without load: flush only
        idex_rd=5'd31; ifid_rs1=5'd31; idex_mem_read=1; branch_taken=0; check(1,1); // x31 boundary
        $display("hazard_detection_unit_tb PASS"); $finish;
    end
endmodule
