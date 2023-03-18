`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 03:13:28 PM
// Design Name: 
// Module Name: testbench
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


module testbench();
    reg clk;
    reg BTN_CENTER;
    reg BTN_LEFT;
    reg BTN_RIGHT;
    reg BTN_UP;
    reg BTN_DOWN;
    reg BTN_CPU_RESET;
    reg [3:0] SW;
    reg SW_CALCULATE;
    wire [7:0] AN;
    wire [6:0] SEG;
    wire [15:0] LED;
reg CLOCK_ENABLE = 0;

wire BTN_CENTER_OUT, BTN_CENTER_OUT_ENABLE;
wire BTN_LEFT_OUT, BTN_LEFT_OUT_ENABLE;
wire BTN_RIGHT_OUT, BTN_RIGHT_OUT_ENABLE;
wire BTN_DOWN_OUT, BTN_DOWN_OUT_ENABLE;
wire BTN_UP_OUT, BTN_UP_OUT_ENABLE;
wire BTN_CPU_RESET_OUT, BTN_CPU_RESET_OUT_ENABLE;

wire [31:0] out_fsm;
wire clk_div_out;

initial
begin
        clk = 0;
        BTN_CENTER = 1'b0;
        BTN_RIGHT = 0;
        BTN_LEFT = 0;
        BTN_UP = 0;
        BTN_DOWN = 0;
        BTN_CPU_RESET = 1;
        SW_CALCULATE = 0;
        SW = 4'b0001; #10;
        BTN_RIGHT = 1'b1; #400;
        BTN_RIGHT = 1'b0; #10;
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        
        BTN_RIGHT = 1'b1; #400;
        BTN_RIGHT = 1'b0; #10;
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_DOWN = 1'b1; #400;
        BTN_DOWN = 1'b0; #10;
     
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_RIGHT = 1'b1; #400;
        BTN_RIGHT = 1'b0; #10;
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_DOWN = 1'b1; #400;
        BTN_DOWN = 1'b0; #10;
     
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_RIGHT = 1'b1; #400;
        BTN_RIGHT = 1'b0; #10;
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_DOWN = 1'b1; #400;
        BTN_DOWN = 1'b0; #10;
        
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_RIGHT = 1'b1; #400;
        BTN_RIGHT = 1'b0; #10;
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_DOWN = 1'b1; #400;
        BTN_DOWN = 1'b0; #10;
     
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_RIGHT = 1'b1; #400;
        BTN_RIGHT = 1'b0; #10;
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_DOWN = 1'b1; #400;
        BTN_DOWN = 1'b0; #10;
        
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_RIGHT = 1'b1; #400;
        BTN_RIGHT = 1'b0; #10;
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #10;
        BTN_DOWN = 1'b1; #400;
        BTN_DOWN = 1'b0; #10;
        
        BTN_CENTER = 1'b1; #400;
        BTN_CENTER = 1'b0; #400;
        
        SW_CALCULATE = 1;
        BTN_CENTER = 1'b1; #10000;
        BTN_CENTER = 1'b0; #10;
end
always #10 clk = ~clk;


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