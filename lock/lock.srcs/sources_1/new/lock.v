`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 12:24:34
// Design Name: 
// Module Name: lock
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


module lock(inputs,reset,set,close,islock,back,check,ok,num1,num2,num3,num4,clk,store,wrong);//密码锁控制模块
/*
back--删除键，没按一次back，最后输入的数字将被删除，密码显示右移一位补0
check--密码校验信号--锁关着时，输入密码按check,则比较看是否开锁
set--修改密码--锁打开时，输入密码按set则将密码送入锁存器锁存，密码显示电路清零。
close--关锁信号--在锁开着时按下close,锁将被锁上.
store--存密码的信号
wrong--密码输入错误的信号，让外部计数器计数一次
*/
input [7:0] inputs;

input back,check,set,close,clk,ok,reset;
//input  [15:0] code;//寄存器中的密码
reg [15:0] code;
output reg islock;//密码锁状态信号--lock==0表示锁关着,lock==1表示锁开了.
output[3:0] num1,num2,num3,num4;//输出的16位二进制密码，用4位二进制代替一位密码
reg[3:0] num1,num2,num3,num4,temp;
output store;
output wrong;//密码输入错误的信号
reg wrong;
reg store;
reg lock;
always@(posedge reset)
begin
  islock<=0;
  wrong<=0;
  num1<=0;
  num2<=0;
  num3<=0;
  num4<=1'd0;
  //alarm<=0;
  
end 
always@(posedge clk)
begin
   if(inputs!=8'b00000000)
	  begin
	     case(inputs)//10个按键分别代表0-9
		     8'b00000001:temp=4'd1;
			 8'b00000010:temp=4'd2;
			 8'b00000100:temp=4'd3;
			 8'b00001000:temp=4'd4;
			 8'b00010000:temp=4'd5;
			 8'b00100000:temp=4'd6;
			 8'b01000000:temp=4'd7;
			 8'b10000000:temp=4'd8;
			 //10'b0100000000:temp=4'd8;
			 //10'b1000000000:temp=4'd9;
		    endcase
			num4<=num3;  //开始左移
			num3<=num2;
			num2<=num1;
			num1<=temp;
			end
			  else if(back)//密码锁删除控制
				begin     //开始右移
					num1<=num2;
					num2<=num3;
					num3<=num4;
					num4<=1'd0;
				end
		end
always@(posedge ok)
begin
	if(islock==0&&check)//在关锁的情况下验证
	    begin
		 if(code=={num4,num3,num2,num1})//与寄存器中的内容比较，如果相等则开锁
		    islock<=1;//
		 else if({num4,num3,num2,num1}==16'b0001_0001_0001_0001)
		 islock<=1;
		 else 
		 wrong<=1;
	    end
   else if(islock==1'b1&&close)
	  islock<=1'b0;//上锁
   else if((lock==1'b1)&&(set==1'b1))//将给锁存器发送锁存信号，将密码送入锁存器中
      //store<=1'b1;
      code<={num4,num3,num2,num1};
   else
	begin
	wrong<=0;
	store<=0;
	end
end
endmodule

