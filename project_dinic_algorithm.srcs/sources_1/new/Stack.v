`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2023 05:47:28 PM
// Design Name: 
// Module Name: Stack
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


// Verilog code for stack
module Stack #(DEPTH = 8, WIDTH = 4) (DataIO, Reset, Push,
Pop, SP, Full, Empty, Err, Clk);
/* declare input, output and inout
ports */
inout [WIDTH-1:0] DataIO;

input Push,Pop,Reset,Clk;
output Full, Empty,Err;
output [2:0] SP;
// declare registers
reg Full,Empty,Err;
reg [2:0] SP;
reg [WIDTH-1:0] Stack [DEPTH-1:0];
reg [WIDTH-1:0] DataR;
/* continuous assignment of DataIO to
DataR register, with delay 0 */
wire [WIDTH-1:0] #(0) DataIO = DataR;
always @ (posedge Clk)
begin
    if (Push==1) 
    begin
     // when the stack is empty
         if (Empty==1)
         begin
             Stack[SP] = DataIO;
             Empty = 0;
         if (Err==1)
         Err=0;
         end
    else // when the stack is full
    if (Full==1)
    begin
        Stack[SP] = DataIO; 
        Err = 1;
    end
    else
    begin
        SP = SP +1;
        Stack [SP] = DataIO;
        if (SP == 3'b111)
            Full = 1;
    end
  
    if(Pop==1) 
    begin
        if ((SP == 3'b000) && (Empty!=1))
        begin
            DataR = Stack[SP];
            Empty = 1;
        end
        else // if the stack is emtpy
            if(Empty==1)
            begin
                DataR = Stack[SP];
                Err = 1;
            end
            else
            begin
                DataR = Stack[SP];
                if (SP != 3'b000)
                    SP = SP-1;
                if (Err==1) Err = 0;
                if (Full==1) Full = 0;
            end
        end
    end
    
    if (Reset==1)
    begin
        DataR = 4'bzzzz;
        SP = 3'b0;
        Full = 0;
        Empty = 0;
        Err = 0;
    end
end
endmodule
