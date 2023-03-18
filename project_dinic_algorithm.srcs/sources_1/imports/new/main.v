`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 11:38:29 AM
// Design Name: 
// Module Name: main
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


module main(
    input clk,
    input BTN_CENTER,
    input BTN_LEFT,
    input BTN_RIGHT,
    input BTN_UP,
    input BTN_DOWN,
    input BTN_CPU_RESET,
    input [3:0] SW,
    input SW_CALCULATE,
    output [7:0] AN,
    output [6:0] SEG,
    output [15:0] LED);
    
reg CLOCK_ENABLE = 0;

wire BTN_CENTER_OUT, BTN_CENTER_OUT_ENABLE;
wire BTN_LEFT_OUT, BTN_LEFT_OUT_ENABLE;
wire BTN_RIGHT_OUT, BTN_RIGHT_OUT_ENABLE;
wire BTN_DOWN_OUT, BTN_DOWN_OUT_ENABLE;
wire BTN_UP_OUT, BTN_UP_OUT_ENABLE;
wire BTN_CPU_RESET_OUT, BTN_CPU_RESET_OUT_ENABLE;

wire [31:0] out_fsm;
wire clk_div_out;
always @(posedge clk)
    CLOCK_ENABLE <= ~CLOCK_ENABLE;

clk_div clk_div1 (.clk(clk),.clk_div(clk_div_out));
SevenSegmentLED seg(.clk(clk_div_out), .RESET(BTN_CPU_RESET_OUT_ENABLE),.NUMBER(out_fsm),.AN_MASK({8'b00000000}),.AN(AN), .SEG(SEG));

FILTER btn_up_filter( .CLK(clk), .CLOCK_ENABLE(CLOCK_ENABLE), .IN_SIGNAL(BTN_UP), .OUT_SIGNAL(BTN_UP_OUT), .OUT_SIGNAL_ENABLE(BTN_UP_OUT_ENABLE));
FILTER btn_down_filter( .CLK(clk), .CLOCK_ENABLE(CLOCK_ENABLE), .IN_SIGNAL(BTN_DOWN), .OUT_SIGNAL(BTN_DOWN_OUT), .OUT_SIGNAL_ENABLE(BTN_DOWN_OUT_ENABLE));
FILTER btn_left_filter( .CLK(clk), .CLOCK_ENABLE(CLOCK_ENABLE), .IN_SIGNAL(BTN_LEFT), .OUT_SIGNAL(BTN_LEFT_OUT), .OUT_SIGNAL_ENABLE(BTN_LEFT_OUT_ENABLE));
FILTER btn_right_filter( .CLK(clk), .CLOCK_ENABLE(CLOCK_ENABLE), .IN_SIGNAL(BTN_RIGHT), .OUT_SIGNAL(BTN_RIGHT_OUT), .OUT_SIGNAL_ENABLE(BTN_RIGHT_OUT_ENABLE));
FILTER btn_center_filter( .CLK(clk), .CLOCK_ENABLE(CLOCK_ENABLE), .IN_SIGNAL(BTN_CENTER), .OUT_SIGNAL(BTN_CENTER_OUT), .OUT_SIGNAL_ENABLE(BTN_CENTER_OUT_ENABLE));
FILTER btn_cpu_reset_filter(.CLK(clk), .CLOCK_ENABLE(CLOCK_ENABLE), .IN_SIGNAL(~BTN_CPU_RESET),.OUT_SIGNAL(BTN_CPU_RESET_OUT), .OUT_SIGNAL_ENABLE(BTN_CPU_RESET_OUT_ENABLE));

fsm FSM(
        .clk(clk), 
        .R_I(BTN_CENTER_OUT_ENABLE),
        .MOVE_UP(BTN_UP_OUT_ENABLE),
        .MOVE_DOWN(BTN_DOWN_OUT_ENABLE),
        .MOVE_LEFT(BTN_LEFT_OUT_ENABLE),
        .MOVE_RIGHT(BTN_RIGHT_OUT_ENABLE),
        .SW_CALCULATE(SW_CALCULATE),
        .reset(BTN_CPU_RESET_OUT_ENABLE), 
        .LED(LED), 
        .dataIn(SW), 
        .dataOut(out_fsm));

endmodule
