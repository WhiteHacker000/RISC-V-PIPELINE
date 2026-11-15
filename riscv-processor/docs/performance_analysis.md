# Performance Analysis

## Pipeline Performance Metrics

### CPI (Cycles Per Instruction)

| Scenario | CPI |
|----------|-----|
| Ideal (no hazards) | 1.0 |
| With forwarding only | ~1.15 |
| With forwarding + load-use stalls | ~1.25 |
| With branch mispredictions | ~1.35 |

### Hazard Impact Analysis

#### Data Hazards
- **RAW (Read After Write)**: Resolved by forwarding (0 cycles) or stall (1 cycle for load-use)
- **WAR (Write After Read)**: Not possible in in-order pipeline
- **WAW (Write After Write)**: Not possible in in-order pipeline

#### Control Hazards
- **Branch Taken**: 2-cycle penalty (flush IF/ID, ID/EX)
- **Branch Not Taken**: 0-cycle penalty (static prediction)
- **Jump (JAL/JALR)**: 2-cycle penalty

#### Structural Hazards
- None (separate instruction/data memory)

### Branch Prediction

| Predictor | Accuracy | Penalty (mispredict) |
|-----------|----------|---------------------|
| Static Not Taken | ~60% | 2 cycles |
| Static Backward Taken | ~75% | 2 cycles |
| 1-bit Dynamic | ~85% | 2 cycles |
| 2-bit Dynamic | ~92% | 2 cycles |

### Memory Access Patterns

- **Instruction Memory**: Sequential access (high spatial locality)
- **Data Memory**: Depends on program (stack, heap, globals)

### Critical Path Analysis

```
IF:  PC register + IMEM access
ID:  Register file read + Immediate gen + Control decode
EX:  ALU operation (longest path)
MEM: DMEM access
WB:  Register file write + Mux
```

**Critical Path**: EX stage ALU operation
- Estimated: ~5-8 ns (depending on ALU complexity)
- Max Frequency: ~125-200 MHz

### Area Estimation

| Component | Approx. Gates |
|-----------|---------------|
| Register File | 32 × 32-bit ≈ 8K |
| ALU | ~2K |
| Control Unit | ~1K |
| Pipeline Registers | 4 × ~200 bits ≈ 800 |
| Forwarding/Stall Logic | ~500 |
| **Total** | **~12K gates** |

### Power Considerations

- Clock gating on pipeline registers during stall
- Memory enable signals for inactive accesses
- Operand isolation for ALU

### Simulation Results

*To be populated after simulation runs*

| Test Program | Instructions | Cycles | CPI |
|--------------|--------------|--------|-----|
| arithmetic.hex | TBD | TBD | TBD |
| memory.hex | TBD | TBD | TBD |
| branch.hex | TBD | TBD | TBD |

### Optimization Opportunities

1. **Better Branch Prediction**: 2-bit bimodal predictor
2. **Instruction Cache**: Reduce IMEM access latency
3. **Data Cache**: Reduce DMEM access latency
4. **Superscalar**: Dual-issue for independent instructions
5. **Out-of-Order**: Dynamic scheduling for higher ILP