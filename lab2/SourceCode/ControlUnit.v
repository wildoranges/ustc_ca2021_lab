`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB 
// Engineer: Wu Yuzhang
// 
// Design Name: RISCV-Pipline CPU
// Module Name: ControlUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: RISC-V Instruction Decoder
//////////////////////////////////////////////////////////////////////////////////
//功能和接口说明
    //ControlUnit       是本CPU的指令译码器，组合逻辑电路
//输入
    // Op               是指令的操作码部分
    // Fn3              是指令的func3部分
    // Fn7              是指令的func7部分
//输出
    // JalD==1          表示Jal指令到达ID译码阶段
    // JalrD==1         表示Jalr指令到达ID译码阶段
    // RegWriteD        表示ID阶段的指令对应的寄存器写入模式
    // MemToRegD==1     表示ID阶段的指令需要将data memory读取的值写入寄存器,
    // MemWriteD        共4bit，为1的部分表示有效，对于data memory的32bit字按byte进行写入,MemWriteD=0001表示只写入最低1个byte，和xilinx bram的接口类似
    // LoadNpcD==1      表示将NextPC输出到ResultM
    // RegReadD         表示A1和A2对应的寄存器值是否被使用到了，用于forward的处理
    // BranchTypeD      表示不同的分支类型，所有类型定义在Parameters.v中
    // AluContrlD       表示不同的ALU计算功能，所有类型定义在Parameters.v中
    // AluSrc2D         表示Alu输入源2的选择
    // AluSrc1D         表示Alu输入源1的选择
    // ImmType          表示指令的立即数格式
//实验要求  
    //补全模块  

`include "Parameters.v"   
module ControlUnit(
    input wire [6:0] Op,
    input wire [2:0] Fn3,
    input wire [6:0] Fn7,
    output wire JalD,
    output wire JalrD,
    output reg [2:0] RegWriteD,
    output wire MemToRegD,
    output reg [3:0] MemWriteD,
    output wire LoadNpcD,
    output reg [1:0] RegReadD,
    output reg [2:0] BranchTypeD,
    output reg [3:0] AluContrlD,
    output wire [1:0] AluSrc2D,
    output wire AluSrc1D,
    output reg [2:0] ImmType        
    ); 
reg RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D;
reg [1:0] RAluSrc2D;
assign {JalD,JalrD,MemToRegD,LoadNpcD,AluSrc1D} = {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D};
assign AluSrc2D = RAluSrc2D;
always @(*) 
begin
    case(Op)
    7'b0110011:begin//Rtype
        {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b00000;
        RAluSrc2D <= 2'b00;
        BranchTypeD <= `NOBRANCH;
        MemWriteD <= 4'b0000;//32bit
        ImmType <= `RTYPE;
        case(Fn3)
        3'b000:begin
            case(Fn7)
            7'b0000000:begin//ADD
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `ADD;
            end
            7'b0100000:begin//SUB
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `SUB;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//2regs
                AluContrlD <= 4'd11;
            end
            endcase
        end 
        3'b001:begin
            case(Fn7)
            7'b0000000:begin//SLL
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `SLL;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//2regs
                AluContrlD <= 4'd11;
            end
            endcase
        end
        3'b010:begin
            case(Fn7)
            7'b0000000:begin//SLT
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `SLT;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//2regs
                AluContrlD <= 4'd11;
            end
            endcase
        end
        3'b011:begin
            case(Fn7)
            7'b0000000:begin//SLTU
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `SLTU;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//2regs
                AluContrlD <= 4'd11;
            end
            endcase
        end
        3'b100:begin
            case(Fn7)
            7'b0000000:begin//XOR
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `XOR;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//2regs
                AluContrlD <= 4'd11;
            end
            endcase
        end
        3'b101:begin
            case(Fn7)
            7'b0000000:begin//SRL
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `SRL;
            end
            7'b0100000:begin//SRA
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `SRA;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//2regs
                AluContrlD <= 4'd11;
            end
            endcase
        end
        3'b110:begin
            case(Fn7)
            7'b0000000:begin//OR
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `OR;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//2regs
                AluContrlD <= 4'd11;
            end
            endcase
        end
        3'b111:begin
            case(Fn7)
            7'b0000000:begin//AND
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b11;//2regs
                AluContrlD <= `AND;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//2regs
                AluContrlD <= 4'd11;
            end
            endcase
        end
        default:begin
            RegWriteD <= `NOREGWRITE;//32bit
            RegReadD <= 2'b00;//
            AluContrlD <= 4'd11;
        end
        endcase
    end
    7'b0010011:begin//Itype
        if(Fn3==3'b001)
        begin
            {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b00000;
            RAluSrc2D <= 2'b01;
            BranchTypeD <= `NOBRANCH;
            MemWriteD <= 4'b0000;//32bit
            ImmType <= `RTYPE;
            case(Fn7)
            7'b0000000:begin//SLLI
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b10;//
                AluContrlD <= `SLL;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//
                AluContrlD <= 4'd11;
            end
            endcase
        end
        else if(Fn3==3'b101)
        begin
            {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b00000;
            RAluSrc2D <= 2'b01;
            BranchTypeD <= `NOBRANCH;
            MemWriteD <= 4'b0000;//32bit
            ImmType <= `RTYPE;
            case(Fn7)
            7'b0000000:begin//SRLI
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b10;//
                AluContrlD <= `SRL;
            end
            7'b0100000:begin//SRAI
                RegWriteD <= `LW;//32bit
                RegReadD <= 2'b10;//
                AluContrlD <= `SRA;
            end
            default:begin
                RegWriteD <= `NOREGWRITE;//32bit
                RegReadD <= 2'b00;//
                AluContrlD <= 4'd11;
            end
            endcase
        end
        else
        begin
            {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b00000;
            RAluSrc2D <= 2'b10;
            BranchTypeD <= `NOBRANCH;
            MemWriteD <= 4'b0000;//32bit
            RegWriteD <= `LW;//32bit
            RegReadD <= 2'b10;//rs1
            ImmType <= `ITYPE;
            case(Fn3)
            3'b000:begin//ADDI
                AluContrlD <= `ADD;
            end
            3'b010:begin
                AluContrlD <= `SLT;
            end
            3'b011:begin
                AluContrlD <= `SLTU;
            end
            3'b100:begin
                AluContrlD <= `XOR;
            end
            3'b110:begin
                AluContrlD <= `OR;
            end
            3'b111:begin
                AluContrlD <= `AND;
            end
            default:begin
                AluContrlD <= 4'd11;
            end
            endcase                
        end
    end
    7'b0100011:begin//stype
        {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b00000;
        RAluSrc2D <= 2'b10;//imm
        BranchTypeD <= `NOBRANCH;
        //MemWriteD <= 4'b0000;//32bit
        RegWriteD <= `NOREGWRITE;//32bit
        RegReadD <= 2'b11;//rs1 rs2
        ImmType <= `STYPE;
        AluContrlD <= `ADD;
        case(Fn3)
        3'b000:begin//store byte
            MemWriteD <= 4'b0001;
        end
        3'b001:begin//store half word
            MemWriteD <= 4'b0011;
        end
        3'b010:begin//store word
            MemWriteD <= 4'b1111;
        end
        default:begin
            MemWriteD <= 4'b0000;
        end
        endcase
    end
    7'b0000011:begin//load
        
    end
    7'b1100011:begin//branch
        {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b00000;
        RAluSrc2D <= 2'b00;
        //BranchTypeD <= `NOBRANCH;
        MemWriteD <= 4'b0000;//32bit
        RegWriteD <= `NOREGWRITE;//32bit
        RegReadD <= 2'b11;//rs1 rs2
        ImmType <= `BTYPE;
        AluContrlD <= 4'd11;
        case(Fn3)
        3'b000:begin
            BranchTypeD <= `BEQ;
        end
        3'b001:begin
            BranchTypeD <= `BNE;
        end
        3'b100:begin
            BranchTypeD <= `BLT;
        end
        3'b101:begin
            BranchTypeD <= `BGE;
        end
        3'b110:begin
            BranchTypeD <= `BLTU;
        end
        3'b111:begin
            BranchTypeD <= `BGEU;
        end
        default:begin
            BranchTypeD <= `NOBRANCH;
        end
        endcase
    end
    7'b1100111:begin//jalr
        {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b01010;
        RAluSrc2D <= 2'b10;//imm
        BranchTypeD <= `NOBRANCH;
        MemWriteD <= 4'b0000;//32bit
        RegWriteD <= `LW;//32bit
        RegReadD <= 2'b10;//rs1
        ImmType <= `ITYPE;
        AluContrlD <= `ADD;
    end
    7'b1101111:begin//jal
        {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b10010;
        RAluSrc2D <= 2'b00;//no rs2
        BranchTypeD <= `NOBRANCH;
        MemWriteD <= 4'b0000;//32bit
        RegWriteD <= `LW;//32bit
        RegReadD <= 2'b00;//
        ImmType <= `JTYPE;
        AluContrlD <= 4'd11;
    end
    7'b0010111:begin//AUIPC
        {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b00001;
        RAluSrc2D <= 2'b10;//imm
        BranchTypeD <= `NOBRANCH;
        MemWriteD <= 4'b0000;//32bit
        RegWriteD <= `LW;//32bit
        RegReadD <= 2'b00;//
        ImmType <= `UTYPE;
        AluContrlD <= `ADD;
    end
    7'b0110111:begin
        {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b00000;
        RAluSrc2D <= 2'b10;//imm
        BranchTypeD <= `NOBRANCH;
        MemWriteD <= 4'b0000;//32bit
        RegWriteD <= `LW;//32bit
        RegReadD <= 2'b00;//
        ImmType <= `UTYPE;
        AluContrlD <= `LUI;
    end
    default:begin
        {RJalD,RJalrD,RMemToRegD,RLoadNpcD,RAluSrc1D} <= 5'b00000;
        RAluSrc2D <= 2'b00;
        BranchTypeD <= `NOBRANCH;
        MemWriteD <= 4'b0000;//32bit
        RegWriteD <= `NOREGWRITE;//32bit
        RegReadD <= 2'b00;//
        ImmType <= `RTYPE;
        AluContrlD <= 4'd11;
    end
    endcase    
end

endmodule

