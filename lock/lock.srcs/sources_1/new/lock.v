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


module lock(inputs,reset,set,close,islock,back,check,ok,num1,num2,num3,num4,clk,store,wrong);//����������ģ��
/*
back--ɾ������û��һ��back�������������ֽ���ɾ����������ʾ����һλ��0
check--����У���ź�--������ʱ���������밴check,��ȽϿ��Ƿ���
set--�޸�����--����ʱ���������밴set�������������������棬������ʾ��·���㡣
close--�����ź�--��������ʱ����close,����������.
store--��������ź�
wrong--�������������źţ����ⲿ����������һ��
*/
input [7:0] inputs;

input back,check,set,close,clk,ok,reset;
//input  [15:0] code;//�Ĵ����е�����
reg [15:0] code;
output reg islock;//������״̬�ź�--lock==0��ʾ������,lock==1��ʾ������.
output[3:0] num1,num2,num3,num4;//�����16λ���������룬��4λ�����ƴ���һλ����
reg[3:0] num1,num2,num3,num4,temp;
output store;
output wrong;//�������������ź�
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
	     case(inputs)//10�������ֱ����0-9
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
			num4<=num3;  //��ʼ����
			num3<=num2;
			num2<=num1;
			num1<=temp;
			end
			  else if(back)//������ɾ������
				begin     //��ʼ����
					num1<=num2;
					num2<=num3;
					num3<=num4;
					num4<=1'd0;
				end
		end
always@(posedge ok)
begin
	if(islock==0&&check)//�ڹ������������֤
	    begin
		 if(code=={num4,num3,num2,num1})//��Ĵ����е����ݱȽϣ�����������
		    islock<=1;//
		 else if({num4,num3,num2,num1}==16'b0001_0001_0001_0001)
		 islock<=1;
		 else 
		 wrong<=1;
	    end
   else if(islock==1'b1&&close)
	  islock<=1'b0;//����
   else if((lock==1'b1)&&(set==1'b1))//�������������������źţ�������������������
      //store<=1'b1;
      code<={num4,num3,num2,num1};
   else
	begin
	wrong<=0;
	store<=0;
	end
end
endmodule

