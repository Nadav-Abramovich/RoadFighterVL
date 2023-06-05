
//-- Nadav May 2023
//-- Arie May 2023

//--------------------------------------------------------------------------
// each car takes the random signal and takes the mod_4 of that number.
// then it deduces a unique value (0 to 3) and deduces in order to get a 
// unique lane allocation.
//--------------------------------------------------------------------------

module	ai_car_red	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input    logic [0:9] player_speed,
					input    logic [0:10] random,
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

const logic[0:15][0:15][7:0] car_sprite_red = {
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'h00,8'h00,8'h00,8'he4,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h91,8'h00,8'h00,8'h00,8'h00,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'h00,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'h00,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'h00,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'h00,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'h00,8'h00,8'h00,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62}};
	
const logic [0:4] [0:10] default_car_state = {
	11'd1, // img_id
	11'd256, // x
	11'd380, // y
	11'd64, //width
	11'd64, //height
};
logic [0:4] [0:10] temp_car_state = default_car_state;
const logic [0:3][0:9] rand_x_location  ={10'd140,10'd180,10'd220,10'd260};




always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_car_state <= default_car_state;
	end
	
	else begin
		
		if(frame_start) begin
			if(temp_car_state[2] == 480) begin
				temp_car_state[1] <= rand_x_location[2];
				temp_car_state[2] <= 0;
			end
			else begin
				temp_car_state[2] <= temp_car_state[2] - 11'd3 + {1'd0, player_speed/32};
			end
			new_car_state <= temp_car_state;
		end
		
		if (should_draw) begin
			output_color <= car_sprite_red[(requested_y-temp_car_state[2])/4][(requested_x-temp_car_state[1])/4];
		end
		else begin
			output_color <= MASK_VALUE;
		end
		
	end
end


endmodule