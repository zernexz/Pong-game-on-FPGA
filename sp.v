`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:59:12 03/10/2014 
// Design Name: 
// Module Name:    sp 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sp(input clk,input x,output reg z=0
    );
reg a=0;
always@(posedge clk)begin
	if(a==0&&x==1)begin
		a<=1;
		z<=1;
	end
	else begin
		z<=0;
	end
	if(x==0)begin
		a<=0;
	end
end

endmodule
