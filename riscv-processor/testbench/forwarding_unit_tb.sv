module forwarding_unit_tb;
    logic [4:0] rs1, rs2, exmem_rd, memwb_rd;
    logic exmem_reg_write, exmem_mem_read, memwb_reg_write;
    logic [1:0] forward_a, forward_b;
    forwarding_unit dut(.*);
    task automatic check(input logic [1:0] a, input logic [1:0] b);
        #1;
        if ({forward_a,forward_b} !== {a,b}) $fatal(1,"forward mismatch got %b%b expected %b%b",forward_a,forward_b,a,b);
    endtask
    initial begin
        rs1=5'd3; rs2=5'd4; exmem_rd=5'd3; memwb_rd=5'd4;
        exmem_reg_write=1; exmem_mem_read=0; memwb_reg_write=1; check(2'b10,2'b01);
        exmem_rd=5'd3; memwb_rd=5'd3; check(2'b10,2'b00); // EX/MEM priority
        exmem_mem_read=1; check(2'b01,2'b00); // unavailable load result
        exmem_rd=0; memwb_rd=0; check(0,0); // x0 never forwards
        exmem_reg_write=0; memwb_reg_write=0; check(0,0);
        // Corner cases (added by verification coverage pass)
        rs1=5'd7; rs2=5'd8; exmem_rd=5'd8; memwb_rd=5'd9;
        exmem_reg_write=1; exmem_mem_read=0; memwb_reg_write=1; check(2'b00,2'b10); // rs2-only EX/MEM
        rs2=5'd7; exmem_rd=5'd7; memwb_rd=5'd7; check(2'b10,2'b10); // rs1==rs2: both take EX/MEM
        exmem_reg_write=0; check(2'b01,2'b01); // EX/MEM not writing: fall back to MEM/WB
        exmem_reg_write=1; exmem_mem_read=1; check(2'b01,2'b01); // EX/MEM load on both: MEM/WB
        memwb_reg_write=0; check(2'b00,2'b00); // load in EX/MEM, no MEM/WB writer: no forward
        exmem_mem_read=0; exmem_rd=5'd0; memwb_rd=5'd7; memwb_reg_write=1; check(2'b01,2'b01); // EX/MEM rd=x0 is ignored, MEM/WB used
        rs1=5'd0; rs2=5'd0; exmem_rd=5'd0; memwb_rd=5'd0; check(2'b00,2'b00); // all-x0 with both writers
        rs1=5'd31; rs2=5'd30; exmem_rd=5'd30; memwb_rd=5'd31; check(2'b01,2'b10); // highest registers, crossed sources
        $display("forwarding_unit_tb PASS"); $finish;
    end
endmodule
