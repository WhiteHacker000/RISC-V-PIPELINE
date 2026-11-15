# RISC-V Pipelined Processor

A 5-stage pipelined RISC-V (RV32I) processor implementation in SystemVerilog.

## Project Structure

```
RISC-V-Pipelined-Processor/
├── rtl/
│   ├── stages/              # Pipeline stages
│   │   ├── if_stage.sv      # Instruction Fetch
│   │   ├── id_stage.sv      # Instruction Decode
│   │   ├── ex_stage.sv      # Execute
│   │   ├── mem_stage.sv     # Memory Access
│   │   └── wb_stage.sv      # Write Back
│   ├── pipeline_registers/  # Pipeline register modules
│   │   ├── if_id.sv
│   │   ├── id_ex.sv
│   │   ├── ex_mem.sv
│   │   └── mem_wb.sv
│   ├── components/          # Reusable components
│   │   ├── program_counter.sv
│   │   ├── register_file.sv
│   │   ├── alu.sv
│   │   ├── control_unit.sv
│   │   ├── immediate_generator.sv
│   │   ├── instruction_memory.sv
│   │   ├── data_memory.sv
│   │   └── main_decoder.sv
│   └── riscv_top.sv         # Top-level module
├── testbench/
│   ├── alu_tb.sv
│   ├── register_file_tb.sv
│   ├── pipeline_tb.sv
│   └── processor_tb.sv
├── programs/
│   ├── arithmetic.hex
│   ├── memory.hex
│   └── branch.hex
├── verification/
│   ├── reference_model.py
│   └── performance.py
├── simulation/
├── synthesis/
├── docs/
│   ├── architecture.md
│   ├── implementation.md
│   └── performance_analysis.md
└── README.md
```

## Pipeline Stages

1. **IF (Instruction Fetch)**: Fetches instruction from memory using PC
2. **ID (Instruction Decode)**: Decodes instruction, reads register file, generates immediates
3. **EX (Execute)**: Performs ALU operations, branch evaluation
4. **MEM (Memory Access)**: Load/store data memory access
5. **WB (Write Back)**: Writes results back to register file

## Getting Started

### Simulation

```bash
# Using ModelSim/QuestaSim
vlib work
vlog rtl/components/*.sv rtl/pipeline_registers/*.sv rtl/stages/*.sv rtl/riscv_top.sv testbench/processor_tb.sv
vsim processor_tb
```

### Test Programs

Pre-compiled test programs in `programs/`:
- `arithmetic.hex` - Arithmetic operations test
- `memory.hex` - Load/store operations test
- `branch.hex` - Branch/jump operations test

## Documentation

- [Architecture](docs/architecture.md) - Processor architecture overview
- [Implementation](docs/implementation.md) - Implementation details
- [Performance Analysis](docs/performance_analysis.md) - Performance metrics

## ISA Support

RV32I base integer instruction set:
- Arithmetic: ADD, SUB, ADDI
- Logical: AND, OR, XOR, ANDI, ORI, XORI
- Shifts: SLL, SRL, SRA, SLLI, SRLI, SRAI
- Comparison: SLT, SLTU, SLTI, SLTIU
- Branches: BEQ, BNE, BLT, BGE, BLTU, BGEU
- Jumps: JAL, JALR
- Memory: LW, SW, LB, LBU, LH, LHU, SB, SH
- LUI, AUIPC