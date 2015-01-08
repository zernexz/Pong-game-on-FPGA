`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:09:19 03/10/2014 
// Design Name: 
// Module Name:    top 
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
module top(
input clk,
output tx,
input rx,
output reg LED_1=0,
output reg LED_2=1,
output reg LED_3=0,
output reg LED_0=1
    );
wire rready;
wire [7:0] rdata;

async_receiver ar(.clk(clk),
.RxD(rx),
.RxD_data_ready(rready),
.RxD_data(rdata),
.RxD_idle(),
.RxD_endofpacket()
);
wire sprready;
sp sp1x(.clk(clk),.x(rready),.z(sprready));

reg tstart=0;
reg [7:0] tdata=0;
wire tbusy;
async_transmitter at(.clk(clk),
.TxD_start(tstart),
.TxD_data(tdata),
.TxD(tx),
.TxD_busy(tbusy)
);
parameter clkfeq=100000000;
parameter fps=10;
parameter frm=clkfeq/fps;

reg [7:0] bbuff [255:0];
reg [7:0] bnbuf=0;
reg [7:0] brbuf=0;
reg bstart=0;
reg bbusy=0;
reg bsend=0;
reg [31:0] frmc=0;

parameter scw=50;
parameter sch=20;
reg gstate=0;
reg sdirx=0;
reg dirx=0;
reg diry=0;
reg [7:0] ballx=scw/2;
reg [7:0] bally=sch/2;
reg [7:0] oballx=scw/2;
reg [7:0] obally=sch/2;
reg [7:0] p1barw=4'd3;//set to 5
reg [7:0] p2barw=4'd5;
reg [7:0] p1y=1;//set to scw/2
reg [7:0] p2y=3;//set to scw/2
reg [7:0] sp1=0;
reg [7:0] sp2=0;

reg [7:0] run=0;
reg [7:0] prun=0;
reg draw=0;

wire [3:0] bx [2:0];
wire [3:0] by [2:0];
wire [3:0] obx [2:0];
wire [3:0] oby [2:0];
wire [3:0] sc1 [2:0];
wire [3:0] sc2 [2:0];
wire [3:0] pos [2:0];

wire [7:0] byd=bally+8'd2;
wire [7:0] obyd=obally+8'd2;
wire [7:0] runyd=run+8'd2;
bin2bcd b1(.indata(ballx), .hundreds(bx[2]), .tens(bx[1]),.ones(bx[0]));
bin2bcd b2(.indata(byd), .hundreds(by[2]), .tens(by[1]),.ones(by[0]));
bin2bcd ob1(.indata(oballx), .hundreds(obx[2]), .tens(obx[1]),.ones(obx[0]));
bin2bcd ob2(.indata(obyd), .hundreds(oby[2]), .tens(oby[1]),.ones(oby[0]));

bin2bcd xs1(.indata(sp1), .hundreds(sc1[2]), .tens(sc1[1]),.ones(sc1[0]));
bin2bcd xs2(.indata(sp2), .hundreds(sc2[2]), .tens(sc2[1]),.ones(sc2[0]));
bin2bcd xpos(.indata(runyd), .hundreds(pos[2]), .tens(pos[1]),.ones(pos[0]));

always@(posedge clk)begin
LED_3<=gstate;

	if(sprready)begin
		case(rdata)
			8'h71:begin//q
				if(gstate==1)begin
					//control q
					if(p1y>0)begin
						p1y<=p1y-1;
					end
				end
			end
			8'h61:begin//a
				if(gstate==1)begin
					//control a
					if(p1y<sch-p1barw)begin
						p1y<=p1y+1;
					end
				end
			end
			8'h77:begin//w
				if(gstate==1)begin
					//control w
					if(p2y>0)begin
						p2y<=p2y-1;
					end
				end
			end
			8'h73:begin//s
				if(gstate==0)begin
					gstate<=1;
					bbuff[0]<=8'h1b;//clear screen
					bbuff[1]<=8'h5b;
					bbuff[2]<=8'h32;
					bbuff[3]<=8'h4A;
					bnbuf<=3;
					bstart<=1;
				end
				else if(gstate==1)begin
					//control s
					if(p2y<sch-p2barw)begin
						p2y<=p2y+1;
					end
				end
			end
			8'h20:begin 
				if(gstate==0&&!bbusy)begin
				bbuff[0]<=8'h1b;//clear screen
				bbuff[1]<=8'h5b;
				bbuff[2]<=8'h32;
				bbuff[3]<=8'h4A;
	bbuff[4]<=8'h1b;//move cursor 0,0
	bbuff[5]<=8'h5b;
	bbuff[6]<=8'h30;
	bbuff[7]<=8'h3b;
	bbuff[8]<=8'h30;
	bbuff[9]<=8'h48;
bbuff[10]<=8'd10;
bbuff[11]<=8'd10;
bbuff[12]<=8'd10;
bbuff[13]<=8'd10;
bbuff[14]<=8'd10;
bbuff[15]<=8'd9;
bbuff[16]<=8'd9;
bbuff[17]<=8'd80;
bbuff[18]<=8'd111;
bbuff[19]<=8'd110;
bbuff[20]<=8'd103;
bbuff[21]<=8'd32;
bbuff[22]<=8'd71;
bbuff[23]<=8'd97;
bbuff[24]<=8'd109;
bbuff[25]<=8'd101;
bbuff[26]<=8'd10;
bbuff[27]<=8'd10;
bbuff[28]<=8'd32;
bbuff[29]<=8'd53;
bbuff[30]<=8'd53;
bbuff[31]<=8'd51;
bbuff[32]<=8'd48;
bbuff[33]<=8'd50;
bbuff[34]<=8'd55;
bbuff[35]<=8'd53;
bbuff[36]<=8'd48;
bbuff[37]<=8'd50;
bbuff[38]<=8'd49;
bbuff[39]<=8'd32;
bbuff[40]<=8'd84;
bbuff[41]<=8'd101;
bbuff[42]<=8'd101;
bbuff[43]<=8'd114;
bbuff[44]<=8'd97;
bbuff[45]<=8'd115;
bbuff[46]<=8'd105;
bbuff[47]<=8'd116;
bbuff[48]<=8'd32;
bbuff[49]<=8'd65;
bbuff[50]<=8'd110;
bbuff[51]<=8'd103;
bbuff[52]<=8'd107;
bbuff[53]<=8'd104;
bbuff[54]<=8'd97;
bbuff[55]<=8'd112;
bbuff[56]<=8'd114;
bbuff[57]<=8'd97;
bbuff[58]<=8'd115;
bbuff[59]<=8'd101;
bbuff[60]<=8'd114;
bbuff[61]<=8'd116;
bbuff[62]<=8'd107;
bbuff[63]<=8'd117;
bbuff[64]<=8'd108;
bbuff[65]<=8'd10;
bbuff[66]<=8'd9;
bbuff[67]<=8'd9;
bbuff[68]<=8'd38;
bbuff[69]<=8'd10;
bbuff[70]<=8'd32;
bbuff[71]<=8'd53;
bbuff[72]<=8'd53;
bbuff[73]<=8'd51;
bbuff[74]<=8'd48;
bbuff[75]<=8'd50;
bbuff[76]<=8'd52;
bbuff[77]<=8'd50;
bbuff[78]<=8'd51;
bbuff[79]<=8'd50;
bbuff[80]<=8'd49;
bbuff[81]<=8'd32;
bbuff[82]<=8'd84;
bbuff[83]<=8'd104;
bbuff[84]<=8'd97;
bbuff[85]<=8'd110;
bbuff[86]<=8'd97;
bbuff[87]<=8'd116;
bbuff[88]<=8'd104;
bbuff[89]<=8'd105;
bbuff[90]<=8'd112;
bbuff[91]<=8'd32;
bbuff[92]<=8'd83;
bbuff[93]<=8'd117;
bbuff[94]<=8'd110;
bbuff[95]<=8'd116;
bbuff[96]<=8'd111;
bbuff[97]<=8'd114;
bbuff[98]<=8'd110;
bbuff[99]<=8'd116;
bbuff[100]<=8'd105;
bbuff[101]<=8'd112;
bbuff[102]<=8'd10;
bbuff[103]<=8'd10;
bbuff[104]<=8'd10;
bbuff[105]<=8'd9;
bbuff[106]<=8'd9;
bbuff[107]<=8'd62;
bbuff[108]<=8'd32;
bbuff[109]<=8'd115;
bbuff[110]<=8'd32;
bbuff[111]<=8'd116;
bbuff[112]<=8'd111;
bbuff[113]<=8'd32;
bbuff[114]<=8'd83;
bbuff[115]<=8'd116;
bbuff[116]<=8'd97;
bbuff[117]<=8'd114;
bbuff[118]<=8'd116;
bbuff[119]<=8'd32;
bbuff[120]<=8'd71;
bbuff[121]<=8'd97;
bbuff[122]<=8'd109;
bbuff[123]<=8'd101;
bbuff[124]<=8'd32;
bbuff[125]<=8'd60;
bbuff[126]<=8'd10;
bbuff[127]<=8'd10;
bbuff[128]<=8'd10;
bbuff[129]<=8'd10;


				bnbuf<=8'd129;
				bstart<=1;
				end
			end
		endcase
	end
	
	if(draw)begin
		if(prun==0)begin
			//draw prun score
	
	bbuff[0]<=8'h1b;//score
	bbuff[1]<=8'h5b;
	bbuff[2]<=8'h30;
	bbuff[3]<=8'h3b;
	bbuff[4]<=8'h32;
	bbuff[5]<=8'h31;
	bbuff[6]<=8'h48;
	bbuff[7]<=8'h30+sc1[2];
	bbuff[8]<=8'h30+sc1[1];
	bbuff[9]<=8'h30+sc1[0];
	bbuff[10]<=8'h3a;
	bbuff[11]<=8'h30+sc2[2];
	bbuff[12]<=8'h30+sc2[1];
	bbuff[13]<=8'h30+sc2[0];

	bbuff[14]<=8'h1b;//remove oball
	bbuff[15]<=8'h5b;
	bbuff[16]<=8'h30+oby[2];
	bbuff[17]<=8'h30+oby[1];
	bbuff[18]<=8'h30+oby[0];
	bbuff[19]<=8'h3b;
	bbuff[20]<=8'h30+obx[2];
	bbuff[21]<=8'h30+obx[1];
	bbuff[22]<=8'h30+obx[0];
	bbuff[23]<=8'h48;
	bbuff[24]<=8'h20;
	bbuff[25]<=8'h20;
	
	bbuff[26]<=8'h1b;//drawnewball
	bbuff[27]<=8'h5b;
	bbuff[28]<=8'h30+by[2];
	bbuff[29]<=8'h30+by[1];
	bbuff[30]<=8'h30+by[0];
	bbuff[31]<=8'h3b;
	bbuff[32]<=8'h30+bx[2];
	bbuff[33]<=8'h30+bx[1];
	bbuff[34]<=8'h30+bx[0];
	bbuff[35]<=8'h48;
	bbuff[36]<=8'h5b;
	bbuff[37]<=8'h5d;
	bnbuf<=8'd37;
	bstart<=1;
			LED_0<=0;
			
			prun<=1;
		end
		else if(prun==1)begin
				bstart<=1;
				prun<=2;
		end
		else if(prun==2)begin
			if(!bbusy)begin
				run<=0;
				prun<=3;
			end
		end
		else if(run<=20&&prun>=3)begin
			if(prun==3)begin
				//draw @y run
				
	bbuff[0]<=8'h1b;
	bbuff[1]<=8'h5b;
	bbuff[2]<=8'h30+pos[2];
	bbuff[3]<=8'h30+pos[1];
	bbuff[4]<=8'h30+pos[0];
	bbuff[5]<=8'h3b;
	bbuff[6]<=8'h31;
	bbuff[7]<=8'h48;
	
	if(run>=p1y&&run<p1y+p1barw)begin
		bbuff[8]<=8'h5d;
	end
	else begin
		bbuff[8]<=8'h20;
	end
	
	
	bbuff[9]<=8'h1b;
	bbuff[10]<=8'h5b;
	bbuff[11]<=8'h30+pos[2];
	bbuff[12]<=8'h30+pos[1];
	bbuff[13]<=8'h30+pos[0];
	bbuff[14]<=8'h3b;
	bbuff[15]<=8'h34;
	bbuff[16]<=8'h38;
	bbuff[17]<=8'h48;
	if(run>=p2y&&run<p2y+p2barw)begin
		bbuff[18]<=8'h5b;
	end
	else begin
		bbuff[18]<=8'h20;
	end
	bnbuf<=8'd18;
	bstart<=1;
			LED_2<=1;
				prun<=4;
			end
			if(prun==4)begin
				bstart<=1;
				prun<=5;
			end
			if(prun==5&&!bbusy)begin
				prun<=3;
				run<=run+1;
			end
				
		end
		else if(run>20) begin
			draw<=0;
			prun<=0;
			run<=0;
		end
	end
	
	if(frmc>frm)begin
		frmc<=0;
		LED_1<=~LED_1;
		if(gstate==1)begin
			//draw all gameplay
			run<=0;
			prun<=0;
			draw<=1;
			LED_0<=1;
			LED_2<=0;
			
if(ballx==1)begin
//p2win
sp2<=sp2+1;
sdirx<=~sdirx;
dirx<=sdirx;
ballx<=8'd25;
bally<=8'd10;
end
else if(ballx==47)begin
//p1win
sp1<=sp1+1;
sdirx<=~sdirx;
dirx<=sdirx;
ballx<=8'd25;
bally<=8'd10;

end
else if(ballx==2&&bally>=p1y&&bally<p1y+p1barw)begin
//p1reflect ball
dirx<=~dirx;
ballx<=ballx+((dirx)?1:-1);
end
else if(ballx==46&&bally>=p2y&&bally<p2y+p2barw)begin
//p2reflect ball
dirx<=~dirx;
ballx<=ballx+((dirx)?1:-1);
end
else begin
ballx<=ballx+((dirx)?-1:1);
end


if(bally==0||bally==19)begin
diry<=~diry;
bally<=bally+((diry)?1:-1);
end
else begin
bally<=bally+((diry)?-1:1);
end
oballx<=ballx;
obally<=bally;

		end
	end
	else begin
		frmc<=frmc+1;
	end
	
	if(tstart)begin
		tstart<=0;
	end
	
	if(!bbusy&&bstart)begin
		bstart<=0;
		bbusy<=1;
		brbuf<=0;
		bsend<=0;
	end
	else if(bbusy&&brbuf<=bnbuf)begin
		if(tbusy&&bsend)begin
			bsend<=0;
		end
		if(!tbusy&&!bsend)begin
			bsend<=1;
			brbuf<=brbuf+1;
			tdata<=bbuff[brbuf];
			tstart<=1;
		end
	end
	else if(bbusy&&brbuf>bnbuf)begin
		brbuf<=0;
		bbusy<=0;
	end
end

endmodule
