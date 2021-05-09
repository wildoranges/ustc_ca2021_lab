# Lab2实验报告

**PB18111757 陈金宝**

## 实验目标

实现RV32I 流水线CPU。

实现SLLI、SRLI、SRAI、ADD、SUB、SLL、SLT、SLTU、XOR、SRL、SRA、OR、AND、ADDI、SLTI、SLTIU、XORI、ORI、ANDI、LUI、AUIPC、JALR、LB、LH、LW、LBU、LHU、SB、SH、SW、BEQ、BNE、BLT、BLTU、BGE、BGEU、JAL指令，处理数据相关。

同时实现CSR指令:CSRRW、CSRRS、CSRRC、CSRRWI、CSRRSI、CSRRCI，处理相关。

## 实验环境和工具

```
实验环境:
Windows 10 20H2
Linux arch 5.11.16-arch1-1 x86_64 GNU/Linux(用于生成测试样例)
工具:
vivado 2019.2(仿真)
vscode 1.56.0(代码编辑)
```

## 实验内容和过程

### 阶段一

第一阶段没有处理相关，每两条指令直接间隔4个nop，主要需要实现Control Unit，ALU和ImmUnit

在Control Unit中使用case语句，对不同类型的指令分情况赋值信号。一阶段实现了R类、I类和U类指令。对每种类型的指令需要区分ImmType，RAluSrc1D，RAluSrc2D，RegWriteD，RegReadD，AluContrlD等信号。

ALU根据ALuControl对操作数进行计算。vivado默认是无符号数。涉及到有符号数的计算或比较时，需要在操作数前加上`$signed` 修饰符。

ImmUnit根据对应的ImmType进行立即数扩展。

一阶段部分测试样例如下:

```assembly
#test1.S (部分)
.org 0x0
 	.global _start
_start:
    lui x1, 0x1
    nop
    nop
    nop
    nop
    lui x2, 0x2
    nop
    nop
    nop
    nop
    add x3,x1,x2
    nop
    nop
    nop
    nop
    addi x3,x2,0x3
    nop
    nop
    nop
    nop
    sub x4,x2,x3
    nop
    nop
    nop
    nop
    lui x1, 0x1
    nop
    nop
    nop
    nop
    lui x2, 0x2
    nop
    nop
    nop
    nop
    srli x2,x2,0xc
    nop
    nop
    nop
    nop
    sll x3,x1,x2
    nop
    nop
    nop
    nop
    slli x3,x1,0x2
    ...
```

测试后各个寄存器的值符合预期

### 阶段二

阶段2实现load，store，branch和jump指令。且需要实现数据相关。

在control unit中实现对应的RJalD,RJalrD,RMemToRegD,RLoadNpcD,BranchType,DMemWriteD等信号

BranchDecisionMaking根据branchtype和两个操作数判断branch是否成功。

由于dataram只处理末二位地址是00的情况，所以实现load和store指令需要额外处理结尾非00的情况。在WBSegReg和DataExt根据LoadedByteSelect以及WE信号进行对应的实现。实现数据存储在结尾非00地址以及结尾非00地址中内容的读取。

NPC_GENERATOR中，branch和jalrd均在EX段跳转，jal在ID段跳转。可能出现冲突的情况。出现冲突时需要Branch和jalr优先。

在hazard unit中检测到branch和jalrd成功时需要清空ID和EX段。检测到jal成功时清空ID段，优先级同上。检测到hazard时（load+use），需要使得IF,ID段进行stall。并flush掉EX段（防止use指令的信号向后传）。控制forward信号时，根据RegReadE，RegWriteM, RegWriteW信号以及Rs1E,Rs2E和RdM,RdW是否相等判断是否有相关。若和Mem段，WB段均产生相关，则forward Mem段。否则forward对应的段。但当Rd是x0时不进行转发。

测试样例实验提供的三个样例。测试后3号寄存器的值均为1，通过测试。仿真截图如下:

![](./media/1.png)


![](./media/2.png)


![](./media/3.png)

### 阶段三

阶段3实现CSR。添加CSR数据通路以及相关处理。添加`CSRFile.v`，`CSRALU.v`。CSR也是五段流水，在WB段写入。MEM段向后传递对应信号。

在`CSRFile.v`中实现CSR寄存器，和RegieterFile类似。共12位地址，4096个。当高两位地址是`2'b11`时是只读的。读寄存器是异步的。

`CSRAlu.v`中实现三种操作，分别是交换(csrrw),置位(csrrs)和清除(csrrc)。对应的CSRAluCtl信号共三种，分别是SWAP,SET,CLEAR。均在`Parameters.v`中添加了定义。CSRAlu的两个操作数分别是Rs1对应的寄存器值和CSR寄存器的值。CSRAlu有两个输出，分别是AluOut和CSROut。CSROut是要写道CSR中的值，ALUout是要写入到RegisterFile中的值。

在ControlUnit添加CSR的控制信号:CSRWriteD,CSRAluCtlD,CSRRead，CSRAlusrc1D,AluOutSrc。CSRWriteD、CSRRead控制CSR的读写。对于 CSRRS和CSRRC指令，如果 rs1＝x0，那么指令将根本不会去写CSR。对应CSRRW，如果 rd＝x0，那么这条指令将不会读该CSR。当CSR是立即数指令（CSRRWI,CSRRSI,CSRRCI）时，设置立即数类型为Ztype（在parameters.v中添加定义）。CSRAluCtlD为CSRALu的控制信号，上面已经介绍。AluOutSrc用于在CSRALu和ALU之间选择输出。当指令是CSR指令时，该信号为1。CSRAlusrc1D则用于选择CSRALU的操作数1是立即数还是Rs1对应的寄存器值（考虑到相关，实际上是ForwardData1E，下面会提到相关）。

在ImmUnit中添加Ztype的对应实现

在HazardUnit中实现对应CSR的相关处理。关于Rs1的相关处理，阶段2已经实现。这里直接复用。即在EX段CSRAlu的Operrand1应从Imm和ForwardData1E中选择，控制信号为CSRAlusrc1。关于CSR的相关处理与之前的类似，考虑CSRRwrite和CSRRead信号。以及当前EX段CSR地址和Mem段、WB段的CSR地址是否相同。

各个段寄存器添加传递对应的CSR信号

## 实验总结

收获：对rv32i指令集、数据通路以及流水线的相关知识更加熟悉。

踩的坑：阶段2涉及到末尾地址非11的数据存储与读取。CSR的相关处理需要考虑rd与rs是x0的情况。

所花时间：control unit花费的时间、阶段2debug以及阶段3构思CSR数据通路的时间较长

## 改进意见

实验课上可以讲一讲数据通路