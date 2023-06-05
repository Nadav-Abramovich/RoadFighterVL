
//-- Nadav May 2023
//-- Arie May 2023
//--------------------------------------------------------------------------
// each car takes the random signal and takes the mod_4 of that number.
// then it deduces a unique value (0 to 3) and deduces in order to get a 
// unique lane allocation.
//--------------------------------------------------------------------------

module	ai_bonus_car	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input    logic [0:9] player_speed,
					input    logic [0:9] val_DEBUG,
					input    logic [0:10] random,
					input 	logic [0:4] game_states,
					output   logic [0:4][0:10] new_car_state,
					output   logic [7:0] output_color
);

logic[0:15][0:15][7:0] car_bonus_sprite= {
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'hff,8'he4,8'he4,8'h00,8'h00,8'h00,8'he4,8'he4,8'hff,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hff,8'h00,8'hf8,8'hf8,8'h1f,8'h00,8'hff,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hff,8'h00,8'hf8,8'hf8,8'h1f,8'h00,8'hff,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hff,8'hf8,8'hf8,8'hf8,8'h1f,8'h1f,8'hff,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'hff,8'hf8,8'h00,8'h00,8'h00,8'h00,8'h00,8'h1f,8'hff,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'hff,8'hf8,8'hf8,8'hf8,8'hf8,8'h1f,8'h1f,8'h1f,8'hff,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'hff,8'hf8,8'hf8,8'hf8,8'hf8,8'h1f,8'h1f,8'h1f,8'hff,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62}};
	
	
	
localparam logic[7:0] MASK_VALUE = 8'h62;
parameter DELAY = 500;

	typedef struct {
	bit should_draw;
	int x;
	int y;
	byte height;
	byte width;
} CAR_STATE;
CAR_STATE car_default = '{1'b0,120,380,64,64};
CAR_STATE car_temp = '{1'b0,60,380,64,64};
/*
collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, car_temp.x } ),
	.top( {21'b0, car_temp.y} ),
	.width( {21'b0, car_temp.width} ),
	.height( {21'b0, car_temp.height} ),
	.should_be_drawn(car_temp.should_draw)
); */

	
const logic [0:4] [0:10] default_car_state = {
	11'd1, // img_id
	11'd260, // x
	11'd380, // y
	11'd64, //width
	11'd64, //height
};
const logic [0:3][0:9] rand_x_location  ={10'd180,10'd240,10'd300,10'd360};
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_car_state <= default_car_state;
	end
	else begin
		
		if(game_states[0]==1'b1) begin 
		   car_temp.y<= -127;
		end 
		if(frame_start) begin
			if(car_temp.y > (480+{24'b0,car_temp.width})) begin
				car_temp.x <= random;
				car_temp.y <= -200;
			end
			car_temp.y <= car_temp.y + {1'd0, player_speed/32};
			
			
		end
		
		if 	((car_temp.y<= requested_y) 
				&& ((car_temp.y+64) > requested_y) 
				&& (car_temp.x <= requested_x) 
				&& ((car_temp.x+64) > requested_x )) begin 
			output_color <= car_bonus_sprite[(requested_y-car_temp.y)/4][(requested_x-car_temp.x)/4];
		end
		
		else begin
			output_color <= MASK_VALUE;
		end
		
	end
	
end




endmodule
