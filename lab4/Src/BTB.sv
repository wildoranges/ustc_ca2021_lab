`timescale 1ns / 1ps
module BTB #(
    parameter  SET_ADDR_LEN  = 6
)(
input wire clk,
input wire rst,
input wire [31:0] PCF,
input wire [31:0] PCE,
input wire BranchE,
input wire [31:0] BranchTarget,
input wire Stall,
output wire [31:0] PC_PRE,
output wire PC_SEL,
output wire btb_flush,
output wire btb_prefail,
output wire btb_fill
);

localparam TAG_ADDR_LEN = 32 - SET_ADDR_LEN;
localparam SET_SIZE     = 1 << SET_ADDR_LEN; 

reg [TAG_ADDR_LEN-1:0] btb_tags   [SET_SIZE];
reg [31:0]             btb_pred   [SET_SIZE];
reg                    btb_valid  [SET_SIZE];

wire [TAG_ADDR_LEN-1:0] pcf_tag;
wire [TAG_ADDR_LEN-1:0] pce_tag;
wire [SET_ADDR_LEN-1:0] pcf_set;
wire [SET_ADDR_LEN-1:0] pce_set;

assign {pce_tag,pce_set} = PCE;
assign {pcf_tag,pcf_set} = PCF;
assign PC_PRE = btb_pred[pcf_set];


wire btb_hit;
assign PC_SEL = btb_hit;

wire IFvalid;
reg IDvalid;
reg EXvalid;

assign IFvalid = btb_valid[pcf_set];
assign btb_hit = (IFvalid && (btb_tags[pcf_set] == pcf_tag));

always@(posedge clk or posedge rst)begin
    if(rst)begin
        IDvalid <= 0;
        EXvalid <= 0;
    end else if(!Stall)begin
        IDvalid <= btb_hit;
        EXvalid <= IDvalid;
    end
end


assign btb_prefail = EXvalid && (!BranchE);
assign btb_fill = (!EXvalid) && BranchE;
assign btb_flush = btb_prefail | btb_fill;

always @(posedge clk or posedge rst)begin
    if(rst)begin
        for(integer i = 0;i < SET_SIZE;i++)begin
            btb_tags[i] <= 0;
            btb_pred[i] <= 0;
            btb_valid[i] <= 0;
        end
    end
    else if(!Stall)begin
        if(btb_prefail)begin//TODO:finish this
            btb_valid[pce_set] <= 0;
        end else if(btb_fill) begin
            btb_valid[pce_set] <= 1;
            btb_tags[pce_set] <= pce_tag;
            btb_pred[pce_set] <= BranchTarget; 
        end
    end
end
endmodule