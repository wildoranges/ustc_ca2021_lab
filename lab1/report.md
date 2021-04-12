# Comparch Lab01
**PB18111757 陈金宝**
## 1
XOR属于R类型指令。在IF段根据PC从指令内存中取出对应的指令。在ID段将取出的指令的OP(instr[0:6]),func3(instr[12:14]),func7(instr[25:36])送入control unit,产生控制信号:`RegWriteD`,`RegReadD`,`AluControlD`,`Alusrc1D`,`Alusrc2D`。寄存器根据`RegRead`信号以及指令中的`rs`和`rt`，读出对应的寄存器数据(`RegOut1D`,`RegOut2D`)。根据`rd`字段将写入的寄存器号读出。之后将信号以及读出的寄存器数据向后传到EX段。在EX段根据传来的`AluControlE`,alu决定进行xor操作。根据`AluSrc1E`,`AluSrc2E`,`RegOut1E`,`RegOut2E`，alu对指定的数据进行xor操作。计算后的结果`AluOutE`以及`RegWrite`，`rdE`信号继续向后传到M段。M段继续将该信息向后传到W段。W段将`rdW`,`ResultW`,以及`RegWrite`信号传给寄存器，向指定寄存器写入数据。