`timescale 1ns / 1ns    //#10 
module tb_led();

reg				clk;
reg				rst_n;
reg		[3:0]	key;
wire 	[3:0]	led;


//Instantiation
led 		u_led(
	//input
	.clk			(clk),
	.rst_n			(rst_n),
	.key			(key),

	//output
	.led            (led)
);

initial begin
	clk = 0;
	rst_n = 0;
	#25
	rst_n = 1;  
end
initial begin
	key = 4'b1111;//no key
	#100
	key = 4'b1110;//k1
	#2500		
	key = 4'b1101;//k2
	#2500		
	key = 4'b1011;//k3
	#2500		
	key = 4'b0111;//k4
	#2500
	$stop;//system function
end
always#10 clk = ~clk; //20ns 

endmodule 