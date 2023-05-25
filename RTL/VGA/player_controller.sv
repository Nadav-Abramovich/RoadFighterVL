
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	player_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	minus_is_pressed,
					input		logic	plus_is_pressed,
					input		logic	frame_start,
					input     logic [0:14][0:10] current_state,
					output    logic [0:4][0:10] new_player_state
);
logic [0:4] [0:10] default_player_state = {
	11'b0, // img_id
	11'b100000000, // x
	11'b101111100, // y
	11'b100000, //width
	11'b0100100, //height
};
logic [0:4] [0:10] temp_player_state = {
	11'b0, // img_id
	11'b100000000, // x
	11'b101111100, // y
	11'b100000, //width
	11'b0100100, //height
};
logic [0:10] max_x = 11'b11110010 + 11'b11110010;
logic [0:10] min_x = 11'b11110010;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_player_state <= default_player_state;
	end
	
	else begin
		if(frame_start) begin
			if(plus_is_pressed) begin
				if((temp_player_state[1] + 11'b100000) < max_x) begin
					temp_player_state[1] <= temp_player_state[1] + 11'b1;
				end
			end
			else if (minus_is_pressed) begin
				if(temp_player_state[1] > min_x) begin
					temp_player_state[1] <= temp_player_state[1] - 11'b1;
				end
			end
			new_player_state <= temp_player_state;
		end
	end
end

endmodule
