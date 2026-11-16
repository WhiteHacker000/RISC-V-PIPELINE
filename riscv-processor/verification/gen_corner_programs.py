"""Assemble the pipeline_corner_tb programs (ADD/SUB/ADDI/LW/SW/BEQ/BNE only).

Usage, from riscv-processor/:
    python3 verification/gen_corner_programs.py programs

Writes programs/verif_*.hex with one commented instruction word per line.
The encoder was cross-checked against the hand-written processor_*.hex words.
"""
import sys, os

def r(f7, rs2, rs1, f3, rd, op): return (f7<<25)|(rs2<<20)|(rs1<<15)|(f3<<12)|(rd<<7)|op
def i(imm, rs1, f3, rd, op): return ((imm & 0xfff)<<20)|(rs1<<15)|(f3<<12)|(rd<<7)|op
def s(imm, rs2, rs1):
    imm &= 0xfff
    return ((imm>>5)<<25)|(rs2<<20)|(rs1<<15)|(0b010<<12)|((imm&0x1f)<<7)|0b0100011
def b(imm, rs2, rs1, f3):
    imm &= 0x1fff
    return (((imm>>12)&1)<<31)|(((imm>>5)&0x3f)<<25)|(rs2<<20)|(rs1<<15)|(f3<<12)|(((imm>>1)&0xf)<<8)|(((imm>>11)&1)<<7)|0b1100011

def add(rd, a, c): return r(0, c, a, 0, rd, 0b0110011)
def sub(rd, a, c): return r(0b0100000, c, a, 0, rd, 0b0110011)
def addi(rd, a, imm): return i(imm, a, 0, rd, 0b0010011)
def lw(rd, imm, a): return i(imm, a, 0b010, rd, 0b0000011)
def sw(rs2, imm, a): return s(imm, rs2, a)
def beq(a, c, off): return b(off, c, a, 0)
def bne(a, c, off): return b(off, c, a, 1)

PROGRAMS = {
 "verif_x0_protection": [
  (addi(0,0,5),   "addi x0, x0, 5      ; write to x0 must be discarded"),
  (add(1,0,0),    "add  x1, x0, x0     ; x0 in EX/MEM must not forward -> x1=0"),
  (add(2,0,0),    "add  x2, x0, x0     ; x0 in MEM/WB must not forward -> x2=0"),
  (add(3,0,0),    "add  x3, x0, x0     ; x0 in WB must not bypass to ID -> x3=0"),
  (addi(4,0,9),   "addi x4, x0, 9      ; x4=9"),
  (sw(4,0,0),     "sw   x4, 0(x0)      ; M[0]=9"),
  (lw(0,0,0),     "lw   x0, 0(x0)      ; load to x0 must be discarded"),
  (add(5,0,4),    "add  x5, x0, x4     ; must NOT load-use stall on x0 -> x5=9"),
  (sub(0,4,0),    "sub  x0, x4, x0     ; another discarded x0 write (9)"),
  (sub(6,4,0),    "sub  x6, x4, x0     ; x6=9 (x0 still reads 0)"),
 ],
 "verif_forward_priority": [
  (addi(1,0,1),   "addi x1, x0, 1      ; older x1"),
  (addi(1,0,2),   "addi x1, x0, 2      ; younger x1"),
  (add(2,1,1),    "add  x2, x1, x1     ; both operands: EX/MEM (2) beats MEM/WB (1) -> 4"),
  (addi(4,0,5),   "addi x4, x0, 5"),
  (addi(5,0,7),   "addi x5, x0, 7"),
  (sub(6,5,4),    "sub  x6, x5, x4     ; rs1 EX/MEM, rs2 MEM/WB -> 2"),
  (addi(8,0,3),   "addi x8, x0, 3"),
  (addi(9,0,11),  "addi x9, x0, 11"),
  (sub(10,8,9),   "sub  x10, x8, x9    ; rs1 MEM/WB, rs2 EX/MEM -> -8"),
  (addi(11,0,100),"addi x11, x0, 100   ; older x11"),
  (addi(11,0,200),"addi x11, x0, 200   ; younger x11"),
  (sub(12,0,11),  "sub  x12, x0, x11   ; rs2-only priority -> -200"),
  (addi(14,0,0x55),"addi x14, x0, 0x55 ; older x14"),
  (addi(14,0,0x66),"addi x14, x0, 0x66 ; younger x14"),
  (sw(14,4,0),    "sw   x14, 4(x0)     ; store data EX/MEM priority -> M[4]=0x66"),
  (addi(15,0,8),  "addi x15, x0, 8     ; base register"),
  (sw(9,0,15),    "sw   x9, 0(x15)     ; store base forwarded from EX/MEM -> M[8]=11"),
 ],
 "verif_dependency_chain": [
  (addi(1,0,1),   "addi x1, x0, 1"),
  (addi(2,0,1),   "addi x2, x0, 1"),
  (add(3,2,1),    "add  x3, x2, x1     ; rs1 dist1, rs2 dist2 -> 2"),
  (add(4,3,2),    "add  x4, x3, x2     ; -> 3"),
  (add(5,4,3),    "add  x5, x4, x3     ; -> 5"),
  (add(6,5,4),    "add  x6, x5, x4     ; -> 8"),
  (add(7,6,5),    "add  x7, x6, x5     ; -> 13"),
  (add(8,7,6),    "add  x8, x7, x6     ; -> 21"),
  (add(9,8,6),    "add  x9, x8, x6     ; rs1 dist1, rs2 dist3 (WB->ID bypass) -> 29"),
  (sub(10,9,9),   "sub  x10, x9, x9    ; same reg both operands -> 0"),
  (addi(10,10,-1),"addi x10, x10, -1   ; -> 0xFFFFFFFF"),
  (sub(11,10,9),  "sub  x11, x10, x9   ; -> -30"),
 ],
 "verif_load_use": [
  (addi(1,0,4),   "addi x1, x0, 4"),
  (addi(2,0,12),  "addi x2, x0, 12"),
  (sw(1,0,0),     "sw   x1, 0(x0)      ; M[0]=4"),
  (sw(2,4,0),     "sw   x2, 4(x0)      ; M[4]=12"),
  (lw(3,0,0),     "lw   x3, 0(x0)      ; x3=4"),
  (lw(4,0,3),     "lw   x4, 0(x3)      ; STALL: load base depends on load -> x4=12"),
  (add(5,1,4),    "add  x5, x1, x4     ; STALL: rs2 load-use -> 16"),
  (lw(6,4,0),     "lw   x6, 4(x0)      ; x6=12"),
  (sw(6,8,0),     "sw   x6, 8(x0)      ; STALL: store data depends on load -> M[8]=12"),
  (lw(7,0,0),     "lw   x7, 0(x0)      ; x7=4"),
  (sw(1,8,7),     "sw   x1, 8(x7)      ; STALL: store base depends on load -> M[12]=4"),
  (lw(8,4,0),     "lw   x8, 4(x0)      ; x8=12"),
  (beq(8,2,8),    "beq  x8, x2, +8     ; STALL: branch operand depends on load; taken"),
  (addi(9,0,99),  "addi x9, x0, 99     ; wrong path, flushed"),
  (lw(10,12,0),   "lw   x10, 12(x0)    ; branch target, x10=4"),
  (addi(11,0,10), "addi x11, x0, 10    ; rs2 FIELD = x10 but ADDI does not read rs2: no stall"),
  (add(12,10,10), "add  x12, x10, x10  ; load at distance 2: no stall, MEM/WB forward -> 8"),
 ],
 "verif_branch_flush": [
  (addi(3,0,0),   "0x00 addi x3, x0, 0"),
  (addi(1,0,3),   "0x04 addi x1, x0, 3"),
  (addi(2,0,0),   "0x08 addi x2, x0, 0"),
  (addi(1,1,-1),  "0x0C loop: addi x1, x1, -1"),
  (addi(2,2,1),   "0x10 addi x2, x2, 1"),
  (bne(1,0,-8),   "0x14 bne  x1, x0, loop  ; backward branch: taken twice, then not taken"),
  (addi(3,3,1),   "0x18 addi x3, x3, 1     ; in bne shadow: must commit exactly once"),
  (addi(4,0,6),   "0x1C addi x4, x0, 6"),
  (addi(5,0,6),   "0x20 addi x5, x0, 6"),
  (beq(4,5,16),   "0x24 beq  x4, x5, +16   ; operands forwarded from MEM/WB and EX/MEM; taken"),
  (sw(4,0,0),     "0x28 sw   x4, 0(x0)     ; wrong path: memory write must be suppressed"),
  (beq(0,0,-0x28),"0x2C beq  x0, x0, -40   ; wrong path branch to 0x04: must not redirect"),
  (addi(6,0,66),  "0x30 addi x6, x0, 66    ; never fetched"),
  (lw(7,0,0),     "0x34 lw   x7, 0(x0)     ; x7=0 proves the flushed store did not write"),
  (beq(0,0,8),    "0x38 beq  x0, x0, +8    ; unconditional taken"),
  (addi(9,0,99),  "0x3C addi x9, x0, 99    ; wrong path register write suppressed"),
  (add(10,7,4),   "0x40 add  x10, x7, x4   ; target -> 6"),
 ],
 "verif_reset": [
  (addi(1,0,0x123),"addi x1, x0, 0x123"),
  (addi(2,0,0x10), "addi x2, x0, 0x10"),
  (sw(1,0,2),      "sw   x1, 0(x2)      ; M[16]=0x123 (reset is asserted while this is in EX/MEM)"),
  (add(3,1,1),     "add  x3, x1, x1     ; 0x246"),
  (lw(4,0,2),      "lw   x4, 0(x2)      ; 0x123"),
  (add(5,4,3),     "add  x5, x4, x3     ; load-use -> 0x369"),
 ],
}

out = sys.argv[1]
for name, prog in PROGRAMS.items():
    with open(os.path.join(out, name + ".hex"), "w") as f:
        f.write(f"// {name}: generated for testbench/pipeline_corner_tb.sv\n")
        for word, text in prog:
            f.write(f"{word:08x}  // {text}\n")
    print(name, len(prog))
