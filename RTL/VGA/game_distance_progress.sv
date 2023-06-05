

module	game_distance_progress(	
			input	logic	clk,
			input	logic	resetN,
			input [0:10] bin,
			input	logic	startOfFrame, 
			input [0:9] player_speed,
			output int distance_drove,
			output int track_length

);
int distance = 0;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) 	begin 
		//why doesn't this work?
		distance_drove = 0;
		distance <= 0;
	end 
	else begin 
		if(startOfFrame) begin
			distance <= distance + (player_speed / 32);
		end
		distance_drove <= distance;		
	end
end

always begin
	track_length = 400*128;
end
endmodule
