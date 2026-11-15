module riscv_top #(
    parameter IMEM_INIT_FILE = "",
    parameter int IMEM_DEPTH = 256,
    parameter int DMEM_WORD_COUNT = 256,
    parameter DMEM_INIT_FILE = ""
) (
    input logic clk,
    input logic rst_n
);
    logic [31:0] pc_current;
    logic [31:0] pc_plus4;
    logic [31:0] instruction_fetch;
    logic [31:0] ifid_pc;
    logic [31:0] ifid_pc_plus4;
    logic [31:0] ifid_instruction;

    logic [6:0] decode_opcode;
    logic [4:0] decode_rd;
    logic [2:0] decode_funct3;
    logic [4:0] decode_rs1;
    logic [4:0] decode_rs2;
    logic [6:0] decode_funct7;
    logic [31:0] register_read1;
    logic [31:0] register_read2;
    logic [31:0] decode_rs1_data;
    logic [31:0] decode_rs2_data;
    logic [31:0] decode_immediate;
    logic decode_reg_write;
    logic decode_mem_read;
    logic decode_mem_write;
    logic decode_branch;
    logic decode_branch_not_equal;
    logic decode_alu_src;
    logic [2:0] decode_alu_control;
    logic decode_mem_to_reg;

    logic [31:0] idex_pc;
    logic [31:0] idex_pc_plus4;
    logic [31:0] idex_rs1_data;
    logic [31:0] idex_rs2_data;
    logic [31:0] idex_immediate;
    logic [4:0] idex_rs1;
    logic [4:0] idex_rs2;
    logic [4:0] idex_rd;
    logic [2:0] idex_alu_control;
    logic idex_reg_write;
    logic idex_mem_read;
    logic idex_mem_write;
    logic idex_branch;
    logic idex_branch_not_equal;
    logic idex_alu_src;
    logic idex_mem_to_reg;

    logic [31:0] ex_forwarded_rs1;
    logic [31:0] ex_forwarded_rs2;
    logic [31:0] ex_alu_operand_b;
    logic [31:0] ex_alu_result;
    logic ex_alu_zero;
    logic [31:0] ex_branch_target;
    logic ex_branch_taken;

    logic [31:0] exmem_alu_result;
    logic [31:0] exmem_store_data;
    logic [31:0] exmem_branch_target;
    logic exmem_branch_taken;
    logic [4:0] exmem_rd;
    logic exmem_mem_read;
    logic exmem_mem_write;
    logic exmem_reg_write;
    logic exmem_mem_to_reg;
    logic [31:0] exmem_pc_plus4;

    logic [31:0] mem_read_data;
    logic [31:0] wb_mem_read_data;
    logic [31:0] wb_alu_result;
    logic [4:0] wb_rd;
    logic wb_reg_write;
    logic wb_mem_to_reg;
    logic [31:0] wb_write_data;

    logic uses_rs1;
    logic uses_rs2;
    logic load_use_stall;
    logic [1:0] forward_a;
    logic [1:0] forward_b;
    logic stall_pc;
    logic stall_ifid;
    logic flush_idex;

    assign pc_plus4 = pc_current + 32'd4;
    assign decode_opcode = ifid_instruction[6:0];
    assign decode_rd = ifid_instruction[11:7];
    assign decode_funct3 = ifid_instruction[14:12];
    assign decode_rs1 = ifid_instruction[19:15];
    assign decode_rs2 = ifid_instruction[24:20];
    assign decode_funct7 = ifid_instruction[31:25];
    assign wb_write_data = wb_mem_to_reg ? wb_mem_read_data : wb_alu_result;
    assign ex_alu_operand_b = idex_alu_src ? idex_immediate : ex_forwarded_rs2;
    assign ex_branch_target = idex_pc + idex_immediate;
    assign ex_branch_taken = idex_branch &&
        (idex_branch_not_equal ? !ex_alu_zero : ex_alu_zero);

    program_counter u_program_counter (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall_pc),
        .branch_taken(ex_branch_taken),
        .branch_target(ex_branch_target),
        .current_pc(pc_current)
    );

    instruction_memory #(
        .ADDR_WIDTH(32),
        .DEPTH(IMEM_DEPTH),
        .INIT_FILE(IMEM_INIT_FILE)
    ) u_instruction_memory (
        .address(pc_current),
        .instruction(instruction_fetch)
    );

    if_id u_if_id (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall_ifid),
        .flush(ex_branch_taken),
        .pc_in(pc_current),
        .pc_plus4_in(pc_plus4),
        .instruction_in(instruction_fetch),
        .pc_out(ifid_pc),
        .pc_plus4_out(ifid_pc_plus4),
        .instruction_out(ifid_instruction)
    );

    control_unit u_control_unit (
        .opcode(decode_opcode),
        .funct3(decode_funct3),
        .funct7(decode_funct7),
        .reg_write(decode_reg_write),
        .mem_read(decode_mem_read),
        .mem_write(decode_mem_write),
        .branch(decode_branch),
        .branch_not_equal(decode_branch_not_equal),
        .alu_src(decode_alu_src),
        .alu_op(),
        .alu_control(decode_alu_control),
        .mem_to_reg(decode_mem_to_reg)
    );

    immediate_generator u_immediate_generator (
        .instruction(ifid_instruction),
        .immediate(decode_immediate)
    );

    register_file u_register_file (
        .clk(clk),
        .write_enable(rst_n && wb_reg_write),
        .read_addr1(decode_rs1),
        .read_addr2(decode_rs2),
        .write_addr(wb_rd),
        .write_data(wb_write_data),
        .read_data1(register_read1),
        .read_data2(register_read2)
    );

    always_comb begin
        decode_rs1_data = register_read1;
        decode_rs2_data = register_read2;

        if (wb_reg_write && (wb_rd != 5'b0) && (wb_rd == decode_rs1))
            decode_rs1_data = wb_write_data;
        if (wb_reg_write && (wb_rd != 5'b0) && (wb_rd == decode_rs2))
            decode_rs2_data = wb_write_data;
    end

    always_comb begin
        uses_rs1 = 1'b0;
        uses_rs2 = 1'b0;

        case (decode_opcode)
            7'b0110011, 7'b1100011: begin
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b1;
            end
            7'b0010011, 7'b0000011: begin
                uses_rs1 = 1'b1;
            end
            7'b0100011: begin
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b1;
            end
            default: begin
            end
        endcase

    end

    hazard_detection_unit u_hazard_detection_unit (
        .idex_mem_read(idex_mem_read), .idex_rd(idex_rd),
        .ifid_rs1(decode_rs1), .ifid_rs2(decode_rs2),
        .ifid_uses_rs1(uses_rs1), .ifid_uses_rs2(uses_rs2),
        .branch_taken(ex_branch_taken), .stall_pc(stall_pc),
        .stall_ifid(stall_ifid), .flush_idex(flush_idex)
    );
    assign load_use_stall = stall_pc;

    id_ex u_id_ex (
        .clk(clk),
        .rst_n(rst_n),
        .stall(1'b0),
        .flush(flush_idex),
        .pc_in(ifid_pc),
        .pc_plus4_in(ifid_pc_plus4),
        .rs1_data_in(decode_rs1_data),
        .rs2_data_in(decode_rs2_data),
        .imm_in(decode_immediate),
        .rs1_in(decode_rs1),
        .rs2_in(decode_rs2),
        .rd_in(decode_rd),
        .alu_control_in(decode_alu_control),
        .reg_write_in(decode_reg_write),
        .mem_read_in(decode_mem_read),
        .mem_write_in(decode_mem_write),
        .branch_in(decode_branch),
        .branch_not_equal_in(decode_branch_not_equal),
        .alu_src_in(decode_alu_src),
        .mem_to_reg_in(decode_mem_to_reg),
        .pc_out(idex_pc),
        .pc_plus4_out(idex_pc_plus4),
        .rs1_data_out(idex_rs1_data),
        .rs2_data_out(idex_rs2_data),
        .imm_out(idex_immediate),
        .rs1_out(idex_rs1),
        .rs2_out(idex_rs2),
        .rd_out(idex_rd),
        .alu_control_out(idex_alu_control),
        .reg_write_out(idex_reg_write),
        .mem_read_out(idex_mem_read),
        .mem_write_out(idex_mem_write),
        .branch_out(idex_branch),
        .branch_not_equal_out(idex_branch_not_equal),
        .alu_src_out(idex_alu_src),
        .mem_to_reg_out(idex_mem_to_reg)
    );

    forwarding_unit u_forwarding_unit (
        .rs1(idex_rs1), .rs2(idex_rs2),
        .exmem_rd(exmem_rd), .exmem_reg_write(exmem_reg_write),
        .exmem_mem_read(exmem_mem_read), .memwb_rd(wb_rd),
        .memwb_reg_write(wb_reg_write), .forward_a(forward_a), .forward_b(forward_b)
    );
    always_comb begin
        case (forward_a)
            2'b10: ex_forwarded_rs1 = exmem_alu_result;
            2'b01: ex_forwarded_rs1 = wb_write_data;
            default: ex_forwarded_rs1 = idex_rs1_data;
        endcase
        case (forward_b)
            2'b10: ex_forwarded_rs2 = exmem_alu_result;
            2'b01: ex_forwarded_rs2 = wb_write_data;
            default: ex_forwarded_rs2 = idex_rs2_data;
        endcase
    end

    alu u_alu (
        .operand_a(ex_forwarded_rs1),
        .operand_b(ex_alu_operand_b),
        .alu_control(idex_alu_control),
        .alu_result(ex_alu_result),
        .zero(ex_alu_zero)
    );

    ex_mem u_ex_mem (
        .clk(clk),
        .rst_n(rst_n),
        .stall(1'b0),
        .flush(1'b0),
        .alu_result_in(ex_alu_result),
        .store_data_in(ex_forwarded_rs2),
        .branch_target_in(ex_branch_target),
        .branch_taken_in(ex_branch_taken),
        .rd_in(idex_rd),
        .mem_read_in(idex_mem_read),
        .mem_write_in(idex_mem_write),
        .reg_write_in(idex_reg_write),
        .mem_to_reg_in(idex_mem_to_reg),
        .pc_plus4_in(idex_pc_plus4),
        .alu_result_out(exmem_alu_result),
        .store_data_out(exmem_store_data),
        .branch_target_out(exmem_branch_target),
        .branch_taken_out(exmem_branch_taken),
        .rd_out(exmem_rd),
        .mem_read_out(exmem_mem_read),
        .mem_write_out(exmem_mem_write),
        .reg_write_out(exmem_reg_write),
        .mem_to_reg_out(exmem_mem_to_reg),
        .pc_plus4_out(exmem_pc_plus4)
    );

    data_memory #(
        .ADDR_WIDTH(32),
        .WORD_COUNT(DMEM_WORD_COUNT),
        .INIT_FILE(DMEM_INIT_FILE)
    ) u_data_memory (
        .clk(clk),
        .mem_read(rst_n && exmem_mem_read),
        .mem_write(rst_n && exmem_mem_write),
        .address(exmem_alu_result),
        .write_data(exmem_store_data),
        .read_data(mem_read_data)
    );

    mem_wb u_mem_wb (
        .clk(clk),
        .rst_n(rst_n),
        .stall(1'b0),
        .flush(1'b0),
        .mem_read_data_in(mem_read_data),
        .alu_result_in(exmem_alu_result),
        .rd_in(exmem_rd),
        .reg_write_in(exmem_reg_write),
        .mem_to_reg_in(exmem_mem_to_reg),
        .mem_read_data_out(wb_mem_read_data),
        .alu_result_out(wb_alu_result),
        .rd_out(wb_rd),
        .reg_write_out(wb_reg_write),
        .mem_to_reg_out(wb_mem_to_reg)
    );
endmodule
