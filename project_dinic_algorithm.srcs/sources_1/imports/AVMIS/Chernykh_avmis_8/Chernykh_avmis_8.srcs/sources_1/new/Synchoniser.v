`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2022 11:01:41 AM
// Design Name: 
// Module Name: Synchoniser
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


module Synchoniser(
    input signal,
    input clk,
    output out
    );
    reg a;
    reg b;
    initial
    begin 
        a = 0;
        b = 0;
    end
    
    always  @ (posedge clk)
    begin
        a <= signal;
        b <= a;
    end
    assign out = b && a;
endmodule
