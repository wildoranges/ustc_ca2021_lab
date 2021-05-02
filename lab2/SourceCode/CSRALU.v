`timescale 1ns / 1ps

module CSRALU(
    input wire [31:0] Operand1,
    input wire [31:0] Operand2,
    input wire [1:0] AluCTL,
    output reg [31:0] AluOut,  
    output reg [31:0] CSROut
);
always@(*)
begin
    case (AluCTL)
        `SWAP: begin
            AluOut <= Operand2;
            CSROut <= Operand1;
        end
        `SET: begin
            AluOut <= Operand2;
            CSROut <= Operand2 | Operand1;
        end
        `CLEAR: begin
            AluOut <= Operand2;
            CSROut <= (~Operand1) & Operand2;
        end
        default:begin
            AluOut <= Operand1;
            CSROut <= Operand2;
        end
    endcase
end
endmodule