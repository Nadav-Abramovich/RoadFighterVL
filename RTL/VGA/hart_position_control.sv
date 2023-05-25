//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2021 


module	Hart_position_control	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic signed	plus_is_pressed,
					input 	logic signed	minus_is_pressed,
					input    logic signed   startOfFrame,
					output 	logic	[10:0] position_y
);

parameter  int OBJECT_HEIGHT_Y = 11'd416;
parameter  int OBJECT_MOVE_SIZE = 11'd1;
int current_position_y = 11'd0;

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		current_position_y <= 0;
	end
	else begin // DEFAULT
		if(startOfFrame != 0) begin
			if(plus_is_pressed == 1'b1 && current_position_y >= OBJECT_MOVE_SIZE) begin
				current_position_y <= current_position_y - OBJECT_MOVE_SIZE;
			end
			//
			if(minus_is_pressed == 1'b1 && current_position_y < (11'd480-OBJECT_HEIGHT_Y)) begin
				current_position_y <= current_position_y + OBJECT_MOVE_SIZE;
			end
		end
	//	
	//	if((current_position_y >> 10) != 11'd0) begin
	//		current_position_y <= 11'd0;
	//	end
	//	if(current_position_y > OBJECT_HEIGHT_Y) begin
	//		current_position_y <= OBJECT_HEIGHT_Y;
	//	end
		position_y <= current_position_y;
	end
end 

endmodule 