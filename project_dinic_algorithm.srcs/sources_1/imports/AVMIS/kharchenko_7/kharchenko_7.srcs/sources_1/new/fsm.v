`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2022 10:43:23 PM
// Design Name: 
// Module Name: fns
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


module fsm(
    input [3:0] dataIn,
    input R_I,MOVE_UP,MOVE_RIGHT,MOVE_DOWN,MOVE_LEFT,SW_CALCULATE,
    input reset,
    input clk,
    output [15:0] LED,
    output [31:0] dataOut);

integer i,j;
parameter ENTER = 7'd0;
parameter INITIALIZE_RESIDUAL_GRAPH_LEVEL_FLOW = 7'd1;

parameter BFS_START = 7'd2;
parameter BFS_MAIN = 7'd3;
parameter BFS_MAIN_INCREMENT =  7'd4;
parameter BFS_MAIN_CONDITION = 7'd5;
parameter BFS_MAIN_ASSIGNMENT = 7'd6;
parameter BFS_NODES_BY_LEVEL = 7'd7;
parameter BFS_NODES_BY_LEVEL_INCREMENT = 7'd8;

parameter DFS_START_RESET = 7'd9;
parameter DFS_START_INITIAL = 7'd10;
parameter DFS_STACK_CYCLE = 7'd11;
parameter DFS_CONDITION_CYCLE = 7'd12;
parameter DFS_CONDITION = 7'd13;
parameter DFS_UPDATE_VERIABLES = 7'd14;
parameter DFS_UPDATE_VERIABLES_LAST = 7'd15;
parameter DFS_PUSH = 7'd15;

parameter MAIN_PARTIAL_FLOW_REACHED =  7'd16;
parameter MAIN_BOTTLENECK_SEARCH_INITIALIZE =  7'd17;
parameter MAIN_BOTTLENECK_SEARCH_CYCLE =  7'd18;
parameter MAIN_BOTTLENECK_SEARCH =  7'd19;
parameter MAIN_BOTTLENECK_APPLYING =  7'd20;
parameter MAIN_END =  7'd21;


reg [6:0] state;
reg [3:0] graph [7:0][7:0];
reg [3:0] residual_graph [7:0][7:0];
reg [3:0] nodes_by_level [7:0][7:0];
reg [3:0] nodes_by_level_counter [7:0];
reg [3:0] nodes_by_level_current_node ;
reg [2:0] enter_count_row;
reg [2:0] enter_count_column;
reg [3:0] level [7:0];   
reg [6:0] flow;
reg [15:0] led_row; 
reg [31:0] REG_RES;
reg [31:0] head, tail;
reg [31:0] u, v, c;
reg [31:0] q [0:7];
reg [3:0] current_path[7:0];
reg [3:0] current_path_length;
reg [3:0] stack [7:0][9:0];
reg [3:0] stack_counter;
reg path_found;
reg [12:0] bottleneck;


initial
begin
    for (u = 1; u < 8; u = u + 1) begin
         level[u] <= -1;
         end
    level[0] <= 0;
    state = ENTER;
    REG_RES = 0;
    v = 0;
    u = 0;
    flow = 0;
    head = 0;
    tail = 0;
    c = 0;
    current_path_length = 0;
    enter_count_row = 3'b000;
    enter_count_column = 3'b000;
    stack_counter = 0;
    nodes_by_level_current_node = 0;
    led_row = 0;
    for(i = 0; i < 8; i = i + 1)
        current_path[i] = 0;
    for(i = 0; i < 8; i = i + 1)
        q[i] = 0;
    for(i = 0; i < 8; i = i + 1)
        for(j = 0; j < 8; j = j + 1)
            graph[i][j] = 0;
    for(i = 0; i < 8; i = i + 1)
        for(j = 0; j < 8; j = j + 1)
            residual_graph[i][j] = 0;  
    for(i = 0; i < 8; i = i + 1)
        for(j = 0; j < 8; j = j + 1)
            nodes_by_level[i][j] = 0;    
    for(i = 0; i < 8; i = i + 1)
        for(j = 0; j < 10; j = j + 1)
            stack[i][j] = 0;
    for(i = 0; i < 8; i = i + 1)
            nodes_by_level_counter[i]= 0;     
end

assign dataOut = REG_RES;
always@(posedge clk)
begin
    if (reset)
    begin
        state <= ENTER;
    end
    else
        case(state)
            ENTER:
                begin
                    if(R_I)
                        if(SW_CALCULATE)
                            state <= INITIALIZE_RESIDUAL_GRAPH_LEVEL_FLOW;
                        else 
                            graph [enter_count_row][enter_count_column] = dataIn;
                    else
                        if(MOVE_UP)
                            if(enter_count_row>0)
                                enter_count_row <= enter_count_row - 1;
                        if(MOVE_DOWN)
                            if(enter_count_row<7)
                                enter_count_row <= enter_count_row + 1;
                        if(MOVE_LEFT)
                            if(enter_count_column>0)
                                enter_count_column <= enter_count_column - 1;
                        if(MOVE_RIGHT)
                            if(enter_count_column<7)
                                enter_count_column <= enter_count_column + 1;
                end
            INITIALIZE_RESIDUAL_GRAPH_LEVEL_FLOW:
                begin
                    for(i = 0; i < 8; i = i + 1)
                        for(j = 0; j < 8; j = j + 1)
                            residual_graph[i][j] <= graph[i][j];
                    flow <= 0;
                    state <= BFS_START;
                end    
            BFS_START:
                begin
                    for (u = 1; u < 8; u = u + 1) begin
                        level[u] <= -1;
                    end
                    for (i = 0; u < 8; u = u + 1) begin
                        q[i] <= 0;
                    end
                    level[0] <= 0;
                    head <= 1;
                    tail <= 0;
                    nodes_by_level_current_node <= 0;
                    state <= BFS_MAIN;
                end
            BFS_MAIN:
                begin
                    u <= q[tail];
                    tail <= tail + 1;
                    state <= BFS_MAIN_CONDITION;
                end
            BFS_MAIN_CONDITION:
                begin
                    if (tail > head) 
                        begin
                            state <= BFS_NODES_BY_LEVEL;
                        end
                    else 
                        begin
                            v <= 0;
                            state <= BFS_MAIN_ASSIGNMENT;
                        end
                end
            BFS_MAIN_ASSIGNMENT:
                begin
                    if (level[v] == 4'b1111 && residual_graph[u][v] > 0) 
                        begin
                            level[v] <= level[u] + 1;
                            q[head] <= v;
                            if(head + 1< 8)
                                head <= head + 1;
                        end
                    state <= BFS_MAIN_INCREMENT; 
                end
            BFS_MAIN_INCREMENT:
                begin
                    if(v + 1 <8)
                        begin
                            v <= v + 1;
                            state <= BFS_MAIN_ASSIGNMENT;
                        end
                    else
                        begin
                            state <= BFS_MAIN;  
                        end 
                end
            BFS_NODES_BY_LEVEL:
                begin
                    if(level[7]!=16'hf)
                        if(nodes_by_level_current_node < 8) begin
                            nodes_by_level[level[nodes_by_level_current_node]][nodes_by_level_counter[level[nodes_by_level_current_node]]] <= nodes_by_level_current_node;
                            nodes_by_level_counter[level[nodes_by_level_current_node]] = nodes_by_level_counter[level[nodes_by_level_current_node]] + 1;
                            state <= BFS_NODES_BY_LEVEL_INCREMENT;
                            end
                        else state <= DFS_START_INITIAL;
                    else
                        state <= MAIN_END;
                end
            BFS_NODES_BY_LEVEL_INCREMENT:
                begin
                    nodes_by_level_current_node <= nodes_by_level_current_node + 1;
                    state <= BFS_NODES_BY_LEVEL;
                end
            DFS_START_INITIAL:
                begin
                    for(i = 0; i < 8; i = i + 1) current_path[i] = 0;
                    for(i = 0; i < 8; i = i + 1)
                        for(j = 0; j < 10; j = j + 1)
                            if(i == 0 && j == 1)
                                stack[i][j] <= 1;
                            else
                                stack[i][j] <= 0;
                    u <= 0;
                    v <= 0;
                    path_found <= 0;
                    current_path_length <= 1;
                    stack_counter <= 1; 
                    state <= DFS_STACK_CYCLE;
                end
            DFS_STACK_CYCLE:
                begin;
                    if(stack_counter == 0)
                        state <= MAIN_PARTIAL_FLOW_REACHED;
                    else
                        begin
                            u <= stack[stack_counter-1][0];
                            current_path_length <= stack[stack_counter-1][1];
                            for(j = 2; j < 10; j = j + 1)
                                current_path[j-2] <= stack[stack_counter-1][j];
                            stack_counter <= stack_counter - 1;
                            c <= 0;
                            state <= DFS_CONDITION_CYCLE;
                        end
                end
            DFS_CONDITION_CYCLE:
                begin
                   if(c <=nodes_by_level_counter[level[u]+1])
                        begin
                            c <= c + 1;
                            v <= nodes_by_level[level[u]+1][c];
                            state <= DFS_CONDITION;
                        end
                    else
                        begin

                            state <= DFS_STACK_CYCLE;  
                        end
                 end 
            DFS_CONDITION:
                begin
                    if (level[v] == level[u] + 1 && residual_graph[u][v] > 0) 
                         state <= DFS_UPDATE_VERIABLES;
                     else
                         state <= DFS_CONDITION_CYCLE;
                end
            DFS_UPDATE_VERIABLES:
                begin
                    if(v==7)
                        begin
                            current_path[current_path_length] <= v; 
                            current_path_length <= current_path_length + 1; 
                            path_found <= 1;
                            state <= MAIN_PARTIAL_FLOW_REACHED;
                        end
                    else
                        state <= DFS_PUSH;
                end
            DFS_PUSH:
                begin
                    stack_counter <= stack_counter + 1;
                    stack[stack_counter][0] <= v;
                    stack[stack_counter][1] <= current_path_length+1;
                    for(j = 2; j < 10; j = j + 1)
                        begin
                            if(j-2 == current_path_length)
                                stack[stack_counter][j] <= v;
                            else 
                                stack[stack_counter][j] <= current_path[j-2];
                        end
                    state <= DFS_CONDITION_CYCLE;
                end
            MAIN_PARTIAL_FLOW_REACHED:
                begin
                    if(path_found == 0)
                        state <= BFS_START;
                    else
                        state <= MAIN_BOTTLENECK_SEARCH_INITIALIZE;
                end
            MAIN_BOTTLENECK_SEARCH_INITIALIZE:
                begin
                    bottleneck <= residual_graph[current_path[0]][current_path[1]];
                    c <= 0;
                    state <= MAIN_BOTTLENECK_SEARCH_CYCLE;
                end
            MAIN_BOTTLENECK_SEARCH_CYCLE:
                begin
                 if (c< current_path_length - 2)
                    begin
                        c <= c + 1;
                        state <= MAIN_BOTTLENECK_SEARCH;
                    end
                 else
                    state <= MAIN_BOTTLENECK_APPLYING; 
                end
            MAIN_BOTTLENECK_SEARCH:
                begin
                    if(bottleneck < residual_graph[current_path[c-1]][current_path[c]])
                        bottleneck <= residual_graph[current_path[c-1]][current_path[c]];
                    state <= MAIN_BOTTLENECK_SEARCH_CYCLE;
                end
           
            MAIN_BOTTLENECK_APPLYING:
                begin
                for(i = 0; i+1 <current_path_length; i = i+1)
                    begin
                        residual_graph[current_path[i]][current_path[i+1]] <= residual_graph[current_path[i]][current_path[i+1]] - bottleneck;                   
                    end
                flow <= flow + bottleneck;
                state <= DFS_START_INITIAL;
                end
            MAIN_END:
                begin
                end
        endcase
end

assign LED = led_row;

always@(posedge clk)
begin
    case(state)
        ENTER: 
            begin
                REG_RES <= {graph[enter_count_row][0],graph[enter_count_row][1],graph[enter_count_row][2],
                graph[enter_count_row][3],graph[enter_count_row][4],graph[enter_count_row][5],graph[enter_count_row][6],graph[enter_count_row][7]};
                led_row[15:13] <= enter_count_row;
                led_row[2:0] <= enter_count_column; 
            end
        MAIN_END:
            begin
            REG_RES <= flow; 
            led_row <= 16'b1111111111111111;
            end
        default: 
            begin
            led_row <= 16'b0000000000000000;
            end
        endcase
end

endmodule

