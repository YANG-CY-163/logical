`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 12:45:13
// Design Name: 
// Module Name: myLock
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


module myLock(clk,inputs,reset,set,change,workstatus,open,close,shut,enter1,enter2,temp);
input clk,reset,change,set,shut,enter1,enter2;
input[7:0] inputs;
output open,close,workstatus;
output[15:0] temp;
reg[2:0] state;
reg[15:0] memory,temp;
reg open,close;
integer i=0;

parameter idle=0,changing=1,unlocking=2,changed=3,right=4,wrong=5;
assign workstatus=1;
always @(posedge(inputs[7]|inputs[6]|inputs[5]|inputs[4]|inputs[3]|inputs[2]|inputs[1]|inputs[0]))
begin
if(i==0)
begin
case (inputs[7:0])
 8'b00000001: temp[3:0]=4'b0000;
 8'b00000010: temp[3:0]=4'b0001;
 8'b00000100: temp[3:0]=4'b0010;
 8'b00001000: temp[3:0]=4'b0011;
 8'b00010000: temp[3:0]=4'b0100;
 8'b00100000: temp[3:0]=4'b0101;
 8'b01000000: temp[3:0]=4'b0110;
 8'b10000000: temp[3:0]=4'b0111;
 //10'b0100000000: temp[3:0]=4'b1000;
 //10'b1000000000: temp[3:0]=4'b1001;
 default:temp[3:0]=4'b0001;
endcase
end
else if(i!=0)
begin
temp=temp<<4;
/*case (inputs[9:0])
 10'b0000000001: temp[3:0]=4'b0000;
 10'b0000000010: temp[3:0]=4'b0001;
 10'b0000000100: temp[3:0]=4'b0010;
 10'b0000001000: temp[3:0]=4'b0011;
 10'b0000010000: temp[3:0]=4'b0100;
 10'b0000100000: temp[3:0]=4'b0101;
 10'b0001000000: temp[3:0]=4'b0110;
 10'b0010000000: temp[3:0]=4'b0111;
 10'b0100000000: temp[3:0]=4'b1000;
 10'b1000000000: temp[3:0]=4'b1001;*/
 case (inputs[7:0])
  8'b00000001: temp[3:0]=4'b0000;
  8'b00000010: temp[3:0]=4'b0001;
  8'b00000100: temp[3:0]=4'b0010;
  8'b00001000: temp[3:0]=4'b0011;
  8'b00010000: temp[3:0]=4'b0100;
  8'b00100000: temp[3:0]=4'b0101;
  8'b01000000: temp[3:0]=4'b0110;
  8'b10000000: temp[3:0]=4'b0111;
 default:temp[3:0]=4'b0001;
endcase
end

i=i+1;
end

always @(posedge clk)

   begin if(!reset) begin open=0;close=0;state=idle;memory=16'h1111;end
       case(state)
       idle: begin if(set)  state=unlocking;  //等待输入--进入开锁状态还是改密状态
             else if(change) state=changing;
             end
       changing:if(!enter1)
                begin if(temp==memory) state=changed;//原密码输入正确
                      else state=wrong;
                end
       unlocking:if(!enter1)
                 begin if(temp==memory)  state=right;  //开锁成功
                       else  state=wrong;
                 end                 
       changed:if(!enter2) begin memory=temp;state=idle;end//修改密码成功
               else state=changed;
       right: begin open=1;
              if(!shut) begin open=0;temp=0;state=idle;end  //关锁并清除显示数码管
              end
       wrong: begin close=1;
              if(!shut) begin close=0;temp=0;state=idle;end  //关锁并清除显示数码管
              end       
        endcase
   end
endmodule
