
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	finish_line_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    int distance_drove,
					input    logic [0:19][0:10] current_state,
					output   logic [0:4][0:10] new_state
);
const logic [0:4] [0:10] default_fl_state = {
	11'd10, // img_id
	11'd166, // x
	11'd780, // y
	11'd248, //width
	11'd64, //height
};
logic [0:4] [0:10] temp_fl_state = default_fl_state;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_state <= default_fl_state;
	end
	
	else begin
		if(frame_start) begin
			if(distance_drove > 100000) begin
				temp_fl_state[2] <= distance_drove-100000;
			end
			new_state <= temp_fl_state;
		end
	end
end

endmodule
