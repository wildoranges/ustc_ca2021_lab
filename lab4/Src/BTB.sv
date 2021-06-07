`timescale 1ns / 1ps
module BTB #(
    parameter  SET_ADDR_LEN  = 6
)(
input wire clk,
input wire rst,
input wire [31:0] PCF,
//input wire [31:0] PCE,
input wire [2:0] BranchTypeE,
input wire BranchE,//FIXME:BRANCH TYPE
input wire [31:0] BranchTarget,
input wire StallD,
input wire StallE,
input wire FlushD,
input wire FlushE,
output wire [31:0] PC_PRE,
output wire PC_SEL,
output wire btb_flush,
output wire btb_prefail,
output wire btb_fill,
output reg [31:0] PCE
);

localparam TAG_ADDR_LEN = 32 - SET_ADDR_LEN;
localparam SET_SIZE     = 1 << SET_ADDR_LEN; 

reg [TAG_ADDR_LEN-1:0] btb_tags   [SET_SIZE];
reg [31:0]             btb_pred   [SET_SIZE];
reg                    btb_stat   [SET_SIZE];

wire [TAG_ADDR_LEN-1:0] pcf_tag;
wire [TAG_ADDR_LEN-1:0] pce_tag;
wire [SET_ADDR_LEN-1:0] pcf_set;
wire [SET_ADDR_LEN-1:0] pce_set;

reg [31:0] PCD;

assign {pce_tag,pce_set} = PCE;
assign {pcf_tag,pcf_set} = PCF;
assign PC_PRE = btb_pred[pcf_set];


wire btb_hit;
wire IFstat;
reg IDstat;
reg EXstat;
reg IDhit;
reg EXhit;


assign PC_SEL = btb_hit&&IFstat;

assign IFstat = btb_stat[pcf_set];
assign btb_hit = (btb_tags[pcf_set] == pcf_tag);

always@(posedge clk or posedge rst)begin
    if(rst)begin
        IDstat <= 0;
        IDhit <= 0;
        EXstat <= 0;
        EXhit <= 0;
        PCD <= 0;
        PCE <= 0;
    end else begin
    if(!StallD)begin
        IDstat <= FlushD?0:IFstat;
        IDhit <= FlushD?0:btb_hit;
        PCD <= FlushD?0:PCF;
    end
    if(!StallE)begin
        EXstat <= FlushE?0:IDstat;
        EXhit <= FlushE?0:IDhit;
        PCE <= FlushE?0:PCD;
    end
    end
end


assign btb_prefail = EXstat && (!BranchE) &&EXhit;
assign btb_fill = ((!EXstat) && BranchE && EXhit) || (!EXhit && BranchE);
assign btb_flush = btb_prefail | btb_fill;

wire next_stat;
wire init_stat;

assign next_stat = BranchE;
assign init_stat = BranchE;

always @(negedge clk or posedge rst)begin
    if(rst)begin
        for(integer i = 0;i < SET_SIZE;i++)begin
            btb_tags[i] <= 0;
            btb_pred[i] <= 0;
            btb_stat[i] <= 0;
        end
    end
    else if(!StallE&&!FlushE)begin
        if(EXhit)begin//TODO:finish this
            btb_stat[pce_set] <= next_stat;
        end else begin
            if(|BranchTypeE)begin
                btb_tags[pce_set] <= pce_tag;
                btb_pred[pce_set] <= BranchTarget;
                btb_stat[pce_set] <= init_stat; 
            end
        end
    end
end
endmodule