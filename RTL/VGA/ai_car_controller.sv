
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	ai_car_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    logic [0:10] random,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input 	logic [0:16*16-1][7:0] sprite,
					input    logic [0:9] player_speed,
					output   logic [0:4][0:10] new_car_state,
					output   logic [7:0] output_color
);

localparam logic[7:0] MASK_VALUE = 8'h62;

logic should_draw = 1'b0;
collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, temp_car_state[1] } ),
	.top( {21'b0, temp_car_state[2]} ),
	.width( {21'b0, temp_car_state[3]} ),
	.height( {21'b0, temp_car_state[4]} ),
	.should_be_drawn(should_draw)
);


const logic [0:4] [0:10] default_car_state = {
	11'd1, // img_id
	11'd256, // x
	11'd380, // y
	11'd64, //width
	11'd64, //height
};
logic [0:4] [0:10] temp_car_state = default_car_state;
logic[0:15][0:15][7:0] sprite_2d;

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
				temp_car_state[2] <= temp_car_state[2] - 11'd6 + {1'd0, player_speed/32};
			end
			new_car_state <= temp_car_state;
		end
		
		if (should_draw) begin
			output_color <= sprite_2d[(requested_y-temp_car_state[2])/4][(requested_x-temp_car_state[1])/4];
		end
		else begin
			output_color <= MASK_VALUE;
		end
		
	end
end

always begin
	integer i, j;
	for (i=0; i<16; i=i+1) for (j=0; j<16; j=j+1) sprite_2d[j][i] = sprite[j*16+i];
end

endmodule
