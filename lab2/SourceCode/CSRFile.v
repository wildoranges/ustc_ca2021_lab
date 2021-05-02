`timescale 1ns / 1ps

module CSRFile (
    input clk,
    input rst,
    input WE,
    input wire [11:0] A,
    input wire [11:0] A1,
    input wire [31:0] WD,
    output wire[31:0] RD
);

assign WE_VALID = (A1[11:10]!=2'b11)&&WE;
reg [31:0] CSRReg[4095:0];
integer i;

always@(negedge clk or posedge rst)
begin
    if(rst) begin
        for(i=0;i<4096;i=i+1)
            CSRReg[i][31:0] <= 32'b0;
    end 
    else if(WE_VALID) begin
        CSRReg[A1] <=  WD;  
    end 
end
assign RD = CSRReg[A];
endmodule
