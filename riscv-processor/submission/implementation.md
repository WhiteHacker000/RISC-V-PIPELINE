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
- Integrates the PC, instruction and data memories, register file, ALU,
  control/immediate logic, and all four pipeline registers.
- Implements EX/MEM and MEM/WB forwarding, decode-stage write-back bypass,
  load-use interlocking, branch redirects, and wrong-path instruction flushes.

## Pipeline Integration Status

The top-level datapath is integrated for ADD, SUB, ADDI, LW, SW, BEQ, and BNE.
Dedicated `forwarding_unit` and `hazard_detection_unit` modules now provide EX
operand bypass selection and load-use interlocking. The integration testbench
covers dependent arithmetic and memory operations, an independent instruction
stream, load-use interlocking, and branch redirects.
Simulation-only observability in `riscv_top` tracks validity through all four
pipeline registers and counts active benchmark cycles, retirement/WB completion,
load-use stalls, and taken/not-taken branch outcomes without changing the
architectural datapath.
The processor is a focused educational implementation, not a complete RV32I
implementation: exceptions, interrupts, byte/halfword memory operations, and
other RV32I instructions are outside its scope.

## Integrated control signals

| Signal | Meaning in the integrated RTL |
|---|---|
| `stall_pc`, `stall_ifid` | Asserted together for a one-cycle load-use dependency; PC and IF/ID hold their values. |
| `flush_idex` | Inserts a control-zero bubble after load-use detection; also asserted for a taken branch. |
| `ex_branch_taken` | EX branch control and ALU equality result request the redirect; this drives PC redirect and IF/ID flush. |
| `forward_a`, `forward_b` | Select ID/EX (`00`), MEM/WB write-back (`01`) or EX/MEM ALU result (`10`); EX/MEM has priority. |
| `decode_rs1_data`, `decode_rs2_data` | Register-file values with a same-cycle WB-to-ID bypass for nonzero destinations. |
| `ifid_perf_valid` … `memwb_perf_valid` | Simulation validity tags aligned with IF/ID and the three later pipeline registers. |
| `perf_instructions_retired` | Counts valid instructions in MEM/WB, including SW, branches and literal NOPs. |

`flush_idex` is the ID/EX control input. Branch flush on IF/ID is driven
directly by `ex_branch_taken`. The performance-valid tags follow the same stall
and redirect conditions, so bubbles and wrong-path instructions do not retire.

## Verification

### Testbench Strategy
- Unit testbenches for each component
- `testbench/processor_tb.sv` exercises full-pipeline integration
- `testbench/forwarding_unit_tb.sv` and `testbench/hazard_detection_unit_tb.sv`
  check arbitration, x0 exclusion, load suppression, stalls, and redirect priority
- Test programs in programs/ directory

### Test Programs
- `programs/processor_*.hex`: arithmetic, memory, branch, load-use and performance streams.
- `programs/termination_*.hex`: literal-NOP termination regression cases.
- `programs/verif_*.hex`: generated pipeline corner and reset cases.

No instruction-set simulator is currently implemented; `verification/reference_model.py`
is an empty placeholder and is not part of the regression. Architectural results
are checked with directed SystemVerilog assertions and expected register/memory
state in the testbenches.

## Synthesis Considerations

- Memories use initialized arrays; physical memory inference depends on the
  synthesis target and its supported read behavior.
- No combinational latches are intended.
- The PC has an asynchronous active-low reset; pipeline registers have
  synchronous active-low resets. The register file and data memory have no
  reset port.
- Clock domain: single clock
