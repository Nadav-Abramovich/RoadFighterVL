
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller_all	(	
			input	logic	clk,
			input	logic	resetN,
			input [0:10] bin,
			input	logic	startOfFrame, // short pulse every start of frame 30Hz 
			input [0:9] player_speed,
			output int distance_drove,
			output int track_length
//			output int bcd 			  // critical code, generating A single pulse in a frame 
);
int distance = 0;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		distance_drove <= 0;
	end 
	else begin 
		if(startOfFrame) begin
			distance <= distance + player_speed / 32;
		end
		distance_drove <= distance;		
	end
end

always begin
	track_length = 400*128;
end
endmodule
