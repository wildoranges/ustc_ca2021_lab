`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB 
// Engineer: Wu Yuzhang
// 
// Design Name: RISCV-Pipline CPU
// Module Name: HarzardUnit
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: Deal with harzards in pipline
//////////////////////////////////////////////////////////////////////////////////
//功能说明
    //HarzardUnit用来处理流水线冲突，通过插入气泡，forward以及冲刷流水段解决数据相关和控制相关，组合�?�辑电路
    //可以�??1�??7?后实现�?�前期测试CPU正确性时，可以在每两条指令间插入四条空指令，然后直接把本模块输出定为，不forward，不stall，不flush 
//输入
    //CpuRst                                    外部信号，用来初始化CPU，当CpuRst==1时CPU全局复位清零（所有段寄存器flush），Cpu_Rst==0时cpu�??1�??7?始执行指�??1�??7?
    //ICacheMiss, DCacheMiss                    为后续实验预留信号，暂时可以无视，用来处理cache miss
    //BranchE, JalrE, JalD                      用来处理控制相关
    //Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW     用来处理数据相关，分别表示源寄存�??1�??7?1号码，源寄存�??1�??7?2号码，目标寄存器号码
    //RegReadE RegReadD[1]==1                   表示A1对应的寄存器值被使用到了，RegReadD[0]==1表示A2对应的寄存器值被使用到了，用于forward的处�??1�??7?
    //RegWriteM, RegWriteW                      用来处理数据相关，RegWrite!=3'b0说明对目标寄存器有写入操�??1�??7?
    //MemToRegE                                 表示Ex段当前指�??1�??7? 从Data Memory中加载数据到寄存器中
//输出
    //StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW    控制五个段寄存器进行stall（维持状态不变）和flush（清零）
    //Forward1E, Forward2E                                                              控制forward
//实验要求  
    //补全模块  
    
    
module HarzardUnit(
    input wire CpuRst, ICacheMiss, DCacheMiss, 
    input wire BranchE, JalrE, JalD, 
    input wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input wire [1:0] RegReadE,
    input wire MemToRegE,
    input wire [2:0] RegWriteM, RegWriteW,
    output reg StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW,
    output reg [1:0] Forward1E, Forward2E,
    input wire [11:0] CSRRs2E,
    input wire [11:0] CSRRdM,
    input wire [11:0] CSRRdW,
    input wire CSRReadE,CSRWriteE,CSRWriteM,CSRWriteW,
    output reg [1:0] CSRForwardE
);
wire rs1hitm ;
wire rs1hitw ;
wire rs2hitm ;
wire rs2hitw ;
assign regwem = |RegWriteM;
assign regwew = |RegWriteW;

wire csrrs2hitm;
wire csrrs2hitw;
assign csrrs2hitm = (CSRWriteM)&&(CSRRs2E==CSRRdM)&&(CSRRdM[11:10]!=2'b11)&&(CSRReadE);
assign csrrs2hitw = (CSRWriteW)&&(CSRRs2E==CSRRdW)&&(CSRRdW[11:10]!=2'b11)&&(CSRReadE);

always@(*) begin //checking jump and hazard
    if(CpuRst)begin
        {FlushF, FlushD, FlushE, FlushM, FlushW} <= 5'b11111;
        {StallF, StallD, StallE, StallM, StallW} <= 5'b00000;
    end
    else begin
    if(BranchE)begin
        {FlushF, FlushD, FlushE, FlushM, FlushW} <= 5'b01100;
        {StallF, StallD, StallE, StallM, StallW} <= 5'b00000;
    end
    else if(JalrE)begin
        {FlushF, FlushD, FlushE, FlushM, FlushW} <= 5'b01100;
        {StallF, StallD, StallE, StallM, StallW} <= 5'b00000;
    end
    else if(JalD)begin
        {FlushF, FlushD, FlushE, FlushM, FlushW} <= 5'b01000;
        {StallF, StallD, StallE, StallM, StallW} <= 5'b00000;
    end
    else begin
        if(MemToRegE)begin
            if(Rs1D==RdE||Rs2D==RdE&&RdE!=5'b00000) begin//hazard detected
                {FlushF, FlushD, FlushE, FlushM, FlushW} <= 5'b00100;
                {StallF, StallD, StallE, StallM, StallW} <= 5'b11000;
            end
            else begin
                {FlushF, FlushD, FlushE, FlushM, FlushW} <= 5'b00000;
                {StallF, StallD, StallE, StallM, StallW} <= 5'b00000;
            end
        end
        else begin
            {FlushF, FlushD, FlushE, FlushM, FlushW} <= 5'b00000;
            {StallF, StallD, StallE, StallM, StallW} <= 5'b00000;
        end
    end    
    end
end

assign rs1hitm = (regwem)&&(Rs1E==RdM)&&(RdM!=5'b00000);
assign rs1hitw = (regwew)&&(Rs1E==RdW)&&(RdW!=5'b00000);
assign rs2hitm = (regwem)&&(Rs2E==RdM)&&(RdM!=5'b00000);
assign rs2hitw = (regwew)&&(Rs2E==RdW)&&(RdW!=5'b00000);

always @(*) begin //checking forward
    if(CpuRst) begin
        Forward1E <= 2'b00;
    end
    else begin
    case(RegReadE)
    2'b11:begin
        case({rs1hitm,rs1hitw})
        2'b00:begin
            Forward1E <= 2'b00;
        end
        2'b01:begin
            Forward1E <= 2'b01;
        end
        2'b10:begin
            Forward1E <= 2'b10;
        end
        2'b11:begin
            Forward1E <= 2'b10;
        end
        endcase

        case({rs2hitm,rs2hitw})
        2'b00:begin
            Forward2E <= 2'b00;
        end
        2'b01:begin
            Forward2E <= 2'b01;
        end
        2'b10:begin
            Forward2E <= 2'b10;
        end
        2'b11:begin
            Forward2E <= 2'b10;
        end
        endcase
    end
    2'b10:begin
        Forward2E <= 2'b00;

        case({rs1hitm,rs1hitw})
        2'b00:begin
            Forward1E <= 2'b00;
        end
        2'b01:begin
            Forward1E <= 2'b01;
        end
        2'b10:begin
            Forward1E <= 2'b10;
        end
        2'b11:begin
            Forward1E <= 2'b10;
        end
        endcase
    end
    2'b01:begin
        Forward1E <= 2'b00;

        case({rs2hitm,rs2hitw})
        2'b00:begin
            Forward2E <= 2'b00;
        end
        2'b01:begin
            Forward2E <= 2'b01;
        end
        2'b10:begin
            Forward2E <= 2'b10;
        end
        2'b11:begin
            Forward2E <= 2'b10;
        end
        endcase
    end
    2'b00:begin
        Forward1E <= 2'b00;
        Forward2E <= 2'b00;
    end
    endcase
    end
end

always @(*) begin//csr
    if(CpuRst) begin
        CSRForwardE <= 2'b00;
    end
    else begin
    case({csrrs2hitm,csrrs2hitw})
    2'b00:begin
        CSRForwardE <= 2'b00;
    end
    2'b01:begin
        CSRForwardE <= 2'b01;
    end
    2'b10:begin
        CSRForwardE <= 2'b10;
    end
    2'b11:begin
        CSRForwardE <= 2'b10;
    end
    endcase
    end
end
endmodule

  