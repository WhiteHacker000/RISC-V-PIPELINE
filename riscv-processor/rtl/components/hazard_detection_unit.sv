module hazard_detection_unit (
    input  logic       idex_mem_read,
    input  logic [4:0] idex_rd,
    input  logic [4:0] ifid_rs1,
    input  logic [4:0] ifid_rs2,
    input  logic       ifid_uses_rs1,
    input  logic       ifid_uses_rs2,
    input  logic       branch_taken,
    output logic       stall_pc,
    output logic       stall_ifid,
    output logic       flush_idex
);
    logic load_use_hazard;
    always_comb begin
        load_use_hazard = idex_mem_read && (idex_rd != 5'd0) &&
            ((ifid_uses_rs1 && idex_rd == ifid_rs1) ||
             (ifid_uses_rs2 && idex_rd == ifid_rs2));
        // A redirect supersedes a decode stall; the redirecting instruction advances.
        stall_pc = load_use_hazard && !branch_taken;
        stall_ifid = stall_pc;
        flush_idex = branch_taken || load_use_hazard;
    end
endmodule
