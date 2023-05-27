
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	background_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input [0:9] player_speed,
					output   logic [0:4][0:10] new_state
);
logic [0:4] [0:10] default_background_state = {
	11'd31, // img_id
	11'd32, // x 11
	11'd0, // y
	11'd512, //width 13
	11'd480 // height
};
logic [0:4] [0:10] temp_background_state = {
	11'd31, // img_id
	11'd32, // x 11
	11'd0, // y
	11'd512, //width 13
	11'd480// height
};

const logic [0:10] max_x;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_state <= default_background_state;
	end
	
	else begin
		if(frame_start) begin
			temp_background_state[2] = temp_background_state[2] - (player_speed / 32);
		end
		new_state <= temp_background_state;
	end
end

endmodule
