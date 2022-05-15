/*
	Prj name    : led
	Description : Pattern water lamp
	Author		: Must__
	Date		: 2022 / 5 / 15
*/

module led (
	//input
	input	wire	clk			,
	input	wire	rst_n		,
	input	wire	[3:0]	key	,

	//output
	output	reg		[3:0]	led
);

parameter CNT_MAX = 26'd25_000_000; // 20 * 25000000 = 500ms

//Four flashing modes
//the last is all dark
parameter S1 = 3'b000;
parameter S2 = 3'b001;
parameter S3 = 3'b010;
parameter S4 = 3'b011;
parameter S5 = 3'b100;


//state machine
reg		[2:0]	current_state; 
reg 	[2:0]	next_state;

reg		[1:0]  	mode;//four state of each flashing mode

reg	[25:0] cnt_500ms;  //500ms clk : 50MHz 20ns     26bit  

//cnt of 500ms
always@(posedge clk or negedge rst_n)begin				
	if(~rst_n)begin			
		cnt_500ms <= 26'd0;
	end
	else begin
		if(cnt_500ms == CNT_MAX - 1)begin
			cnt_500ms <= 26'd0;
		end
		else begin
			cnt_500ms <= cnt_500ms + 26'd1;
		end	
	end
end		
//four state of each flashing mode 
always@(posedge clk or negedge rst_n)begin	
	if(~rst_n)begin
		mode <= 2'b00;
	end
	else begin
		if((cnt_500ms == CNT_MAX - 1 && mode == 2'b11) || (next_state != current_state))begin // if()     ; 
			mode <= 2'b00;
		end
		else if(cnt_500ms == CNT_MAX - 1)begin
			mode <= mode + 1'b1;
		end
		else begin
			mode <= mode;
		end
	end
end

//next state -> current state
always@(posedge clk or negedge rst_n)begin    
	if(~rst_n)begin
		current_state <= S5;
	end
	else begin
		current_state <= next_state;
	end
end
//state transformation 
always@(*)begin //
	case(current_state)
		S1	:	begin
			case(key)
				4'b1110:next_state = S1;
				4'b1101:next_state = S2;
				4'b1011:next_state = S3;
				4'b0111:next_state = S4;
				default:next_state = S5;
			endcase
		end
		S2  :	begin
			case(key)
				4'b1110:next_state = S1;
				4'b1101:next_state = S2;
				4'b1011:next_state = S3;
				4'b0111:next_state = S4;
				default:next_state = S5;
			endcase
		end
		S3  :	begin
			case(key)
				4'b1110:next_state = S1;
				4'b1101:next_state = S2;
				4'b1011:next_state = S3;
				4'b0111:next_state = S4;
				default:next_state = S5;
			endcase
		end
		S4  :	begin
			case(key)
				4'b1110:next_state = S1;
				4'b1101:next_state = S2;
				4'b1011:next_state = S3;
				4'b0111:next_state = S4;
				default:next_state = S5;
			endcase
		end
		S5	:	begin
			case(key)
				4'b1110:next_state = S1;
				4'b1101:next_state = S2;
				4'b1011:next_state = S3;
				4'b0111:next_state = S4;
				default:next_state = S5;
			endcase
		end
		default:next_state = S5;
	endcase 
end
//output of led [3:0]
always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		led <= 4'b1111;
	end
	else begin
		case(current_state)
			S1  :begin			//left 
				case(mode)
					2'b00:	led <= 4'b1110;
					2'b01:	led <= 4'b1101;
					2'b10:	led <= 4'b1011;
					2'b11:	led <= 4'b0111;
					default:led <= 4'b1110;
				endcase
			end					
			S2  :begin			//right
				case(mode)
					2'b00:	led <= 4'b0111;
					2'b01:	led <= 4'b1011;
					2'b10:	led <= 4'b1101;
					2'b11:	led <= 4'b1110;
					default:led <= 4'b0111;
				endcase
			end
			S3  :begin			//divergence
				case(mode)
					2'b00:	led <= 4'b1111;
					2'b01:	led <= 4'b1001;
					2'b10:	led <= 4'b0110;
					2'b11:	led <= 4'b1111;
					default:led <= 4'b1111;
				endcase
			end
			S4  :begin			//convergence
				case(mode)
					2'b00:	led <= 4'b1111;
					2'b01:	led <= 4'b0110;
					2'b10:	led <= 4'b1001;
					2'b11:	led <= 4'b1111;
					default:led <= 4'b1111;
				endcase
			end
			S5  :begin			//all dark 
				led <= 4'b1111;
			end
		endcase
	end
end

endmodule 

