`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 14:26:24
// Design Name: 
// Module Name: sim_lock
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


module sim_lock();
reg [7:0] inputs;
reg reset,set,close,back,check,ok,clk;
wire num1,num2,num3,num4,wrong,store,islock;


initial begin
    set = 0;
    reset = 0;
    close=0;
    back=0;
    check=0;
    ok=0;
    #10 
    reset =1;
    #10
    reset=0;
end

always
begin
#10
check=1;
#5
inputs = 8'b00000001;
#5
clk=1;
#2
clk=0;

inputs = 8'b00000001;
#5
clk=1;
#2
clk=0;
inputs = 8'b00000001;
#5
clk=1;
#2
clk=0;
inputs = 8'b00000001;
#5
clk=1;
#2
clk=0;
#2
ok=1;
#2
ok=0;
end

lock u1(inputs,reset,set,close,islock,back,check,ok,num1,num2,num3,num4,clk,store,wrong);
endmodule
