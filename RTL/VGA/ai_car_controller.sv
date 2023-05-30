
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	ai_car_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    logic [0:10] random,
					input     logic [0:14][0:10] current_state,
					output    logic [0:4][0:10] new_car_state
);
const logic [0:4] [0:10] default_car_state = {
	11'd1, // img_id
	11'd256, // x
	11'd380, // y
	11'd64, //width
	11'd64, //height
};
logic [0:4] [0:10] temp_car_state = default_car_state;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_car_state <= default_car_state;
	end
	
	else begin
		if(frame_start) begin
			if(temp_car_state[2] == 480) begin
				temp_car_state[1] <= random;
				temp_car_state[2] <= 0;
			end
			else begin
				temp_car_state[2] <= temp_car_state[2] + 11'd1;
			end
			new_car_state <= temp_car_state;
		end
	end
end

endmodule
