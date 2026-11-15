# Processor Architecture

The core implements a single-issue, in-order 32-bit datapath with stages IF → ID → EX → MEM → WB. Supported instructions are ADD, SUB, ADDI, LW, SW, BEQ, and BNE. Other RV32I operations, exceptions, interrupts, byte/halfword accesses, and privilege modes are unsupported.

## Stages and pipeline state

- **IF:** asynchronous instruction-memory lookup using the PC; normally advances by four.
- **ID:** opcode/control/immediate decode and two register reads. A WB-to-ID bypass handles a same-cycle write/read dependency.
- **EX:** ALU arithmetic and branch comparison. Branch target is `ID/EX.PC + B-immediate`; BEQ takes on equality and BNE takes on inequality.
- **MEM:** aligned word data-memory access.
- **WB:** selects the load value or ALU result and writes nonzero `rd`.

IF/ID stores PC, PC+4, and instruction. ID/EX carries PC, operand values, immediate, register indices, ALU selection, and side-effect controls. EX/MEM carries ALU/store results and memory/writeback controls. MEM/WB carries load/ALU results and register-write controls. Pipeline-register reset is synchronous active-low; PC reset is asynchronous active-low.

## Hazards and priority

`forwarding_unit` selects EX/MEM before MEM/WB independently for both operands; x0 is excluded and an EX/MEM load is not forwarded. The load-use detector stalls PC and IF/ID for one cycle when an ID/EX load destination matches a source actually used by IF/ID, and flushes ID/EX to inject a bubble. A taken EX branch redirects PC and flushes IF/ID and ID/EX; redirect wins over a simultaneous decode stall. Older EX/MEM and MEM/WB instructions continue normally. These controls prevent younger wrong-path register and memory side effects.

```text
        +------+    +------+    +------+    +------+    +------+
PC --->|  IF  |--->|  ID  |--->|  EX  |--->| MEM  |--->|  WB  |
        +------+ IF/ID    ID/EX     EX/MEM     MEM/WB
                      ^      ^
                      |      +-- forwarding from EX/MEM and MEM/WB
                      +--------- load-use interlock / branch flush
```

Instruction and data memories are separate arrays, avoiding a unified-memory structural conflict. Data memory is word addressed through aligned byte addresses. No cache or architectural exception behavior is implemented.
