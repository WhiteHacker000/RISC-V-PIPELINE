module forwarding_unit (
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  exmem_rd,
    input  logic        exmem_reg_write,
    input  logic        exmem_mem_read,
    input  logic [4:0]  memwb_rd,
    input  logic        memwb_reg_write,
    output logic [1:0]  forward_a,
    output logic [1:0]  forward_b
);
    always_comb begin
        forward_a = 2'b00;
        forward_b = 2'b00;
        if (exmem_reg_write && !exmem_mem_read && exmem_rd != 5'd0 && exmem_rd == rs1)
            forward_a = 2'b10;
        else if (memwb_reg_write && memwb_rd != 5'd0 && memwb_rd == rs1)
            forward_a = 2'b01;
        if (exmem_reg_write && !exmem_mem_read && exmem_rd != 5'd0 && exmem_rd == rs2)
            forward_b = 2'b10;
        else if (memwb_reg_write && memwb_rd != 5'd0 && memwb_rd == rs2)
            forward_b = 2'b01;
    end
endmodule
