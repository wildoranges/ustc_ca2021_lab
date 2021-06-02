`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB 
// Engineer: Wu Yuzhang
// 
// Design Name: RISCV-Pipline CPU
// Module Name: NPC_Generator
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Choose Next PC value
//////////////////////////////////////////////////////////////////////////////////
//功能说明
    //NPC_Generator是用来生成Next PC值的模块，根据不同的跳转信号选择不同的新PC�?
//输入
    //PCF              旧的PC�?
    //JalrTarget       jalr指令的对应的跳转目标
    //BranchTarget     branch指令的对应的跳转目标
    //JalTarget        jal指令的对应的跳转目标
    //BranchE==1       Ex阶段的Branch指令确定跳转
    //JalD==1          ID阶段的Jal指令确定跳转
    //JalrE==1         Ex阶段的Jalr指令确定跳转
//输出
    //PC_In            NPC的�??
//实验要求  
    //补全模块  

module NPC_Generator(
    input wire [31:0] PCF,JalrTarget, BranchTarget, JalTarget,
    input wire BranchE,JalD,JalrE,
    input wire PCF_SEL,
    input wire [31:0] PCF_PRE,
    input wire [31:0] PCE,
    input wire BTB_FILL,
    input wire BTB_PREFAIL,
    output reg [31:0] PC_In
    );
wire [31:0] PC_raw;
assign PC_raw = PCF_SEL?PCF_PRE:PCF + 4;

always @(*) 
begin
if(BranchE)
begin
    if(BTB_FILL)begin
        PC_In <= BranchTarget;
    end else begin
        PC_In <= PCF + 4;
    end
end
else if(BTB_PREFAIL)
begin
    PC_In <= PCE + 4;
end
else if(JalrE)    
begin
    PC_In <= JalrTarget;
end
else if(JalD)
begin
    PC_In <= JalTarget;
end
else
begin
    PC_In <= PC_raw;
end
end
    
endmodule
