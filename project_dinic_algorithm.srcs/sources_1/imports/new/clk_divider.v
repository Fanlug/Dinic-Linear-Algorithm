`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2023 01:20:14 PM
// Design Name: 
// Module Name: clk_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_div(
input clk,
output reg clk_div
);
initial 
begin
clk_div = 0;
end 
reg[15:0] clk_counter; 
always@ (posedge clk)
begin
    if (clk_counter >= (2**10 - 1) >> 1) 
    begin
        clk_counter <= 0;
        clk_div <= ~clk_div;
    end
    else
    begin
        clk_counter <= clk_counter + 1;
    end
end
endmodule