`timescale 1ns / 1ps
module PRED #(
    parameter  SET_ADDR_LEN  = 6
)(
input wire clk,
input wire rst,
input wire [31:0] PCF,
//input wire [31:0] PCE,
input wire [2:0] BranchTypeE,
input wire BranchE,
input wire [31:0] BranchTarget,
input wire StallD,
input wire StallE,
input wire FlushD,
input wire FlushE,
output wire [31:0] PC_PRE,
output wire PC_SEL,
output wire flush,
output wire prefail,
output wire fill,
output wire [31:0] PCE
);

wire b_flush;
wire b_prefail;
wire b_fill;
wire b_pcsel;
wire [31:0] b_pcpre;

BTB #(SET_ADDR_LEN)BTB1(
    .clk(clk),
    .rst(rst),
    .PCF(PCF),
    .BranchE(BranchE),
    .BranchTypeE(BranchTypeE),
    .BranchTarget(BranchTarget),
    .StallD(StallD),//TODO:UPDATE
    .StallE(StallE),
    .FlushD(FlushD),
    .FlushE(FlushE),
    .PC_PRE(b_pcpre),
    .PC_SEL(b_pcsel),
    .btb_flush(b_flush),
    .btb_prefail(b_prefail),
    .btb_fill(b_fill),
    .PCE(PCE)
);

localparam TAG_ADDR_LEN = 32 - SET_ADDR_LEN;
localparam SET_SIZE     = 1 << SET_ADDR_LEN; 

reg [TAG_ADDR_LEN-1:0] bht_tags   [SET_SIZE];
//reg [31:0]             bht_pred   [SET_SIZE];
reg [1:0]              bht_stat   [SET_SIZE];

wire [TAG_ADDR_LEN-1:0] pcf_tag;
wire [TAG_ADDR_LEN-1:0] pce_tag;
wire [SET_ADDR_LEN-1:0] pcf_set;
wire [SET_ADDR_LEN-1:0] pce_set;

assign {pce_tag,pce_set} = PCE;
assign {pcf_tag,pcf_set} = PCF;

wire bht_hit;
wire [1:0] IFstat;
reg [1:0] IDstat;
reg IDhit;
reg [1:0] EXstat;
reg EXhit;
wire pre_taken;
reg IDPretaken;
reg EXPretaken;

assign PC_SEL = bht_hit && b_pcsel && IFstat[1];
assign PC_PRE = b_pcpre;

assign pre_taken = PC_SEL;
assign IFstat = bht_stat[pcf_set];
assign bht_hit = (bht_tags[pcf_set] == pcf_tag);

always @(posedge clk or posedge rst)begin//FIXME:signal passing?
    if(rst)begin
        IDstat <= 0;
        IDhit <= 0;
        EXstat <= 0;
        EXhit <= 0;
        IDPretaken <= 0;
        EXPretaken <= 0;
    end else begin
        if(!StallD)begin
        IDstat <= FlushD?0:IFstat;
        IDhit <= FlushD?0:bht_hit;
        IDPretaken <= FlushD?0:pre_taken;
        end
        if(!StallE)begin
        EXstat <= FlushE?0:IDstat;
        EXhit <= FlushE?0:IDhit;
        EXPretaken <= FlushE?0:IDPretaken;
        end
    end
end

assign prefail = EXPretaken && (!BranchE);
assign fill = (!EXPretaken) && BranchE;
assign flush = prefail | fill;

reg [1:0] next_stat;
reg [1:0] init_stat;

always@(*)begin
    if(BranchE)begin
        init_stat <= 2'b01;
        if(EXstat[1])begin
            next_stat <= 2'b11;
        end else begin
            if(EXstat[0])begin
                next_stat <= 2'b10;
            end else begin
                next_stat <= 2'b01;
            end
        end
    end else begin
        init_stat <= 2'b00;
        if(EXstat[1])begin
            next_stat <= EXstat << 1;
        end else begin
            next_stat <= 2'b00;
        end
    end
end
/* 
assign next_stat = BranchE?(EXstat[1]?2'b11:EXstat << 1):(EXstat[1]?EXstat << 1:2'b00); 
assign init_stat = BranchE?2'b01:2'b00; */

always @(negedge clk or posedge rst)begin
    if(rst)begin
        for(integer i = 0;i < SET_SIZE;i++)begin
            bht_tags[i] <= 0;
            bht_stat[i] <= 0;
        end
    end
    else if(!StallE&&!FlushE)begin
        if(EXhit/* &&(|BranchTypeE) */)begin
            bht_stat[pce_set] <= next_stat;
        end else begin
            if(|BranchTypeE)begin
                bht_tags[pce_set] <= pce_tag;
                bht_stat[pce_set] <= init_stat;
            end
        end
    end
end
endmodule