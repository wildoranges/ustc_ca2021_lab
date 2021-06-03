# 伪矩阵乘法  汇编代码
# 我们的 RV32I CPU 没有实现乘法指令，所以在伪矩阵乘法中，使用按位或代替加法，用加法代替乘法，完成矩阵运算。
# 虽然不是真的矩阵乘法，但能够模仿矩阵乘法对RAM的访问过程，对cache的性能研究起到作用
#

.org 0x0
    .global _start
_start:
    xori   a4, zero, 4     #0  # a4寄存器决定了计算的规模，矩阵规模=N*N，N=2^a4。例如a4=4，则矩阵为 2^4=16阶方阵。该值可以修改。当然，矩阵规模变化后，DataRam的内存分配方式也要同步的变化，才能运行出正确结果

    # 以下指令计算3个矩阵（目的矩阵，源矩阵1，源矩阵2）在内存中的起始地址。
    # 这三个矩阵在内存中顺序而紧挨着存放，例如 a4=4，则N=16，则每个矩阵占N*N=256个字，即1024个字节
    # 则 目的矩阵起始地址为0，  源矩阵1起始地址为1024，  源矩阵2起始地址为2048
    # 目的矩阵起始地址放在a2里，源矩阵1起始地址放在a0里，源矩阵2起始地址放在a1里
    xori   a3, zero, 4#4
    sll    a3, a3  , a4#8
    xor    a2, zero, zero#12
    sll    a0, a3  , a4#16
    add    a1, a0  , a0#20
    
    # 开始矩阵乘法，使用伪矩阵乘法公式：c_{ij} = \sigma c_{ik}*b{kj} ， 循环嵌套顺序（从内向外）为 i,j,k 。 分别使用 t0,t1,t2 存放 i,j,k
    xor    t0, zero, zero#24
    MatMulLoopI:
        xor    t1, zero, zero#28
        MatMulLoopJ:
            xor    t3, zero, zero #32   #用t3存放最内求和循环的累加和，首先将t3清零
            xor    t2, zero, zero #36
            MatMulLoopK:
                sll  t4, t0, a4 #40
                add  t4, t4, t2 #44
                add  t4, t4, a0 #48
                lw   t4, (t4) #52
                sll  t5, t2, a4 #56
                add  t5, t5, t1 #60
                add  t5, t5, a1 #64
                lw   t5, (t5) #68
                and  t4, t4, t5 #72
                add  t3, t3, t4 #76
                addi t2, t2, 4 #80
            blt    t2, a3, MatMulLoopK #84
            sll    t4, t0, a4 #88
            add    t4, t4, t1 #92
            add    t4, t4, a2 #96
            sw     t3, (t4) #100
            addi   t1, t1, 4 #104
        blt    t1, a3, MatMulLoopJ#108
        addi   t0, t0, 4#112
    blt    t0, a3, MatMulLoopI#116
    
    # 计算结束，死循环


    # 计算结束，死循环
    add    t0, zero, 1#120
    sll    t0, t0, a4#124
    sll    t0, t0, a4#128
    slli   t0, t0, 2#132
    addi   t1, zero, 0#136
Loop:
    lw     t2, (t1)#140
    addi   t1, t1, 4#144
    blt    t1, t0, Loop#148
InfLoop:
    jal    zero, InfLoop#152
    