# Architecture Overview

## RISC-V Pipelined Processor Architecture

This document describes the architecture of a 5-stage pipelined RISC-V (RV32I) processor.

### Pipeline Stages

```
IF → ID → EX → MEM → WB
```

#### 1. Instruction Fetch (IF)
- Fetches instruction from instruction memory using Program Counter (PC)
- PC updates: PC+4 (sequential) or branch target (taken branch)
- Outputs: PC, Instruction

#### 2. Instruction Decode (ID)
- Decodes instruction fields (opcode, funct3, funct7, rd, rs1, rs2, immediate)
- Reads register file (rs1, rs2)
- Generates immediate values (I-type, S-type, B-type, U-type, J-type)
- Control unit generates control signals
- Outputs: PC, RS1 data, RS2 data, Immediate, Control signals

#### 3. Execute (EX)
- ALU performs arithmetic/logic operations
- Branch evaluation (comparison for conditional branches)
- Calculates branch target address
- Forwarding unit resolves data hazards
- Outputs: ALU result, RS2 data (for store), Branch decision, Control signals

#### 4. Memory Access (MEM)
- Load/Store data memory access
- Load data sign/zero extension
- Outputs: ALU result, Memory read data, Control signals

#### 5. Write Back (WB)
- Writes result to register file (rd)
- Selects between ALU result and memory data (mem_to_reg)
- Outputs: Write data, Register write enable

### Pipeline Registers

| Register | Between Stages | Key Signals |
|----------|---------------|-------------|
| IF/ID    | IF → ID       | PC, Instruction |
| ID/EX    | ID → EX       | PC, RS1, RS2, Imm, RD, Control |
| EX/MEM   | EX → MEM      | PC, ALU Result, RS2, RD, Control |
| MEM/WB   | MEM → WB      | ALU Result, Mem Data, RD, Control |

### Hazard Handling

#### Data Hazards
- **Forwarding (Bypassing)**: EX→EX, MEM→EX, WB→EX
- **Stalling**: Load-use hazard (1 cycle stall)

#### Control Hazards
- **Branch Prediction**: Static (not taken) or dynamic
- **Flush**: Pipeline flush on taken branch

#### Structural Hazards
- Single-port memory: Instruction and data memory separate

### Control Signals

| Signal | Description |
|--------|-------------|
| reg_write | Enable register file write |
| mem_read | Enable data memory read |
| mem_write | Enable data memory write |
| branch | Branch instruction |
| alu_src | ALU source: register (0) or immediate (1) |
| alu_op | ALU operation select |
| mem_to_reg | Write back source: ALU (0) or memory (1) |

### Memory Map

```
0x0000_0000 - 0x0000_FFFF : Instruction Memory (64 KB)
0x0001_0000 - 0x0001_FFFF : Data Memory (64 KB)
```

### ISA Support (RV32I Base)

- **Arithmetic**: ADD, SUB, ADDI
- **Logical**: AND, OR, XOR, ANDI, ORI, XORI
- **Shifts**: SLL, SRL, SRA, SLLI, SRLI, SRAI
- **Comparison**: SLT, SLTU, SLTI, SLTIU
- **Branches**: BEQ, BNE, BLT, BGE, BLTU, BGEU
- **Jumps**: JAL, JALR
- **Loads**: LW, LH, LHU, LB, LBU
- **Stores**: SW, SH, SB
- **Upper Immediate**: LUI, AUIPC