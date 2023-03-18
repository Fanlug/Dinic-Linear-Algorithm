`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2022 10:21:11 AM
// Design Name: 
// Module Name: parametrisedCounter
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


module parametrisedCounters#(COUNTER_WITDH = 27,STEP = 1,COUNT_FROM = 0, COUNT_TO = 134217728)(
    input wire CLK,
    input RST,
    input ENABLE,
    output reg [COUNTER_WITDH-1:0] CNT
    );
    initial
    begin
        CNT <= COUNT_FROM;
    end
    always @(posedge CLK) 
    begin
    
    if(RST)
        CNT <= COUNT_FROM;
    else
        if(ENABLE)  
        begin
            if(CNT<COUNT_TO)
                CNT <=CNT+STEP;
            else
                CNT <= COUNT_FROM;
        end
    end
endmodule
