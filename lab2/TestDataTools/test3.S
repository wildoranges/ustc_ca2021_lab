.org 0x0
 	.global _start
    #CSRRW rd, csr, rs1
_start:
    lui x1,0x1
    csrrw x2,0x000,x1
    lui x1,0x3
    csrrs x2,0x000,x1
    csrrc x2,0x000,x1