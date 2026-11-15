# Implementation Details

## Module Descriptions

### rtl/components/

#### program_counter.sv
- Parameterized program counter with asynchronous active-low reset
- Increments by 4 when enabled; branch redirect has priority over stall
- Output: current_pc

#### register_file.sv
- 32 x 32-bit registers (x0 always reads as 0 and ignores writes)
- Two read ports, one write port
- Synchronous write, asynchronous read

#### alu.sv
- Existing 32-bit ALU supporting:
  - Arithmetic: ADD, SUB
  - Logical: AND, OR, XOR
  - Comparison: SLT, SLTU
- Input: operand_a, operand_b, alu_control
- Output: alu_result, zero

#### control_unit.sv
- Combines main opcode decoding with funct3/funct7 validation
- Generates control and ALU signals for ADD, SUB, ADDI, LW, SW, BEQ, BNE
- Combinational logic

#### immediate_generator.sv
- Generates sign-extended 32-bit immediates for:
  - I-type: ADDI and loads
  - S-type: Stores
  - B-type: Branches

#### instruction_memory.sv
- Read-only memory for instructions
- 32-bit instructions addressed by byte address; low two address bits must be zero
- Optional INIT_FILE loaded with $readmemh; unwritten words default to NOP
- Out-of-range and unaligned reads return NOP

#### data_memory.sv
- Word-only LW/SW memory with synchronous writes and asynchronous reads
- Optional INIT_FILE loaded with $readmemh; unwritten words default to zero
- Out-of-range or unaligned accesses do not modify memory and read as zero

#### main_decoder.sv
- Decodes instruction opcode into the main control signals
- Used by control_unit.sv; funct fields are validated there

### rtl/pipeline_registers/

All four pipeline registers use positive-edge clocking and a synchronous
active-low reset. Reset and flush clear the registered control/data fields;
flush takes priority over stall.

- **IF/ID** carries PC, PC+4, and instruction. A flush inserts the ADDI x0,x0,0
  NOP; a stall holds the current instruction.
- **ID/EX** carries PC, PC+4, both source values and register indices, the
  immediate, destination index, ALU control, and execution/memory/write-back
  controls. A stall holds the payload; a flush inserts a control-zero bubble.
- **EX/MEM** carries the ALU result, store data, branch target/decision,
  destination index, PC+4, and memory/register-write controls.
- **MEM/WB** carries memory read data, ALU result, destination index, and
  register-write/write-back-selection controls.

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

## Pipeline Integration Status

The component implementations above are not yet integrated into a processor top
level. Forwarding, load-use stall detection, branch flush wiring, and top-level
stage/pipeline-register connections remain to be implemented.

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