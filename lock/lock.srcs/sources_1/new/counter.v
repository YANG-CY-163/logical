`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 12:37:41
// Design Name: 
// Module Name: counter
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


module counter(CP,Q,CO);//基本计数器模块
//parameter msb=3;
input CP;
output reg[3:0] Q;
output reg CO;
always@(CP)
begin 
   if(Q==4'b1110)
	CO<=1;
	else
	CO<=0;
	Q<=Q+1'b1;
end
endmodule