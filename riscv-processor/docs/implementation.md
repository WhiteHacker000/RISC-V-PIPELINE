# Implementation Details

## Module Descriptions

### rtl/components/

#### program_counter.sv
- 32-bit program counter with synchronous reset
- Input: next_pc, stall, flush
- Output: current_pc

#### register_file.sv
- 32 x 32-bit registers (x0 hardwired to 0)
- Two read ports, one write port
- Synchronous write, asynchronous read

#### alu.sv
- 32-bit ALU supporting:
  - Arithmetic: ADD, SUB
  - Logical: AND, OR, XOR
  - Shifts: SLL, SRL, SRA
  - Comparison: SLT, SLTU
- Input: op_a, op_b, alu_control
- Output: result, zero_flag

#### control_unit.sv
- Main decoder + ALU decoder
- Generates all control signals from opcode/funct3/funct7
- Combinational logic

#### immediate_generator.sv
- Generates 32-bit immediates for all formats:
  - I-type: ADDI, loads, JALR
  - S-type: Stores
  - B-type: Branches
  - U-type: LUI, AUIPC
  - J-type: JAL

#### instruction_memory.sv
- Read-only memory for instructions
- 32-bit address, 32-bit data
- Combinational read

#### data_memory.sv
- Read/write memory for data
- 32-bit address, 32-bit data
- Byte/half-word/word access with sign/zero extension
- Synchronous write, asynchronous read

#### main_decoder.sv
- Decodes opcode to main control signals
- Part of control unit

### rtl/pipeline_registers/

Each pipeline register module:
- Synchronous with active-low reset
- Supports stall (hold) and flush (clear) signals
- Passes all stage signals to next stage

### rtl/stages/

Each stage module:
- Pure combinational logic (except PC register in IF)
- Takes inputs from previous pipeline register
- Outputs to next pipeline register
- No internal state (except IF stage PC)

### rtl/riscv_top.sv
- Top-level integration
- Instantiates all stages and pipeline registers
- Connects hazard/forwarding units
- Memory interfaces

## Hazard Unit

### Forwarding Unit
Detects RAW hazards and selects forwarded data:
- EX hazard: EX/MEM.rd == ID/EX.rs1/rs2
- MEM hazard: MEM/WB.rd == ID/EX.rs1/rs2
- Priority: EX > MEM > Register File

### Stall Unit
Detects load-use hazard:
- ID/EX.mem_read && (ID/EX.rd == IF/ID.rs1 || ID/ID.rs2)
- Inserts 1-cycle stall

### Flush Unit
Flushes pipeline on taken branch:
- EX stage branch_taken signal
- Flushes IF/ID and ID/EX registers

## Verification

### Testbench Strategy
- Unit testbenches for each component
- Integration testbench for full pipeline
- Test programs in programs/ directory

### Test Programs
- arithmetic.hex: ADD, SUB, AND, OR, XOR, shifts
- memory.hex: LW, SW, LB, LH, SB, SH
- branch.hex: BEQ, BNE, BLT, BGE, JAL, JALR

### Reference Model
- Python-based ISS (Instruction Set Simulator)
- Compares register/memory state after each instruction
- Located in verification/reference_model.py

## Synthesis Considerations

- All memories inferred as block RAM
- No latches (complete case/default in casez)
- Synchronous resets for all registers
- Clock domain: single clock