`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB 
// Engineer: Wu Yuzhang
// 
// Design Name: RISCV-Pipline CPU
// Module Name: ALU
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: ALU unit of RISCV CPU
//////////////////////////////////////////////////////////////////////////////////

//功能和接口说明
	//ALU接受两个操作数，根据AluContrl的不同，进行不同的计算操作，将计算结果输出到AluOut
	//AluContrl的类型定义在Parameters.v中
//推荐格式：
    //case()
    //    `ADD:        AluOut<=Operand1 + Operand2; 
    //   	.......
    //    default:    AluOut <= 32'hxxxxxxxx;                          
    //endcase
//实验要求  
    //补全模块

`include "Parameters.v"   
module ALU(
    input wire [31:0] Operand1,
    input wire [31:0] Operand2,
    input wire [3:0] AluContrl,
    output reg [31:0] AluOut
);    
always @(*) 
begin
    case (AluContrl)
        `SLL:       AluOut <= Operand1 <<  Operand2;
        `SRL:       AluOut <= Operand1 >>  Operand2;
        `SRA:       AluOut <= Operand1 >>> Operand2;
        `ADD:       AluOut <= Operand1  +  Operand2;
        `SUB:       AluOut <= Operand1  -  Operand2;
        `XOR:       AluOut <= Operand1  ^  Operand2;
        `OR:        AluOut <= Operand1  |  Operand2;
        `AND:       AluOut <= Operand1  &  Operand2;
        `SLTU:       begin
            if(Operand1 < Operand2)
                AluOut <= 32'd1;
            else
                AluOut <= 32'd0;
        end
        `SLT:      begin
            case ({Operand1[31],Operand2[31]})
                /*2'b00:begin
                    if(Operand1 < Operand2)
                        AluOut <= 32'd1;
                    else
                        AluOut <= 32'd0;
                end*/
                2'b01:begin
                    AluOut <= 32'd0;
                end
                2'b10:begin
                    AluOut <= 32'd1;
                end
                default:begin
                    if(Operand1 < Operand2)
                        AluOut <= 32'd1;
                    else
                        AluOut <= 32'd0; 
                end
            endcase
        end
        `LUI:   AluOut <= {Operand2[31:12],12'd0};
        default:    ALUout <= 32'h0000_0000;
    endcase
end
endmodule

