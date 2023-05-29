
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	player_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input		logic [9:0]	NumberKey,
					input		logic	frame_start,
					input    logic [0:1] collisions,
					input 	logic [0:16*16-1][7:0] sprite1,
					input 	logic [0:16*16-1][7:0] sprite2,
					input 	logic [0:16*16-1][7:0] sprite3,
					output   logic [0:4][0:10] new_player_state,
					output   logic [0:9] player_speed,
					output   logic [7:0] output_color
);
const logic [0:4] [0:10] default_player_state = {
	11'd0, // img_id
	11'd166 + 11'd106, // x
	11'd380, // y
	11'd64, //width
	11'd64, //height
};
logic [0:4] [0:10] temp_player_state = default_player_state;

logic [0:15] [0:2] [0:10] death_animation = {
	{ 11'd99, 11'd64, 11'd64 },
	{ 11'd100, 11'd64, 11'd64 },
	{ 11'd101, 11'd64, 11'd64 },
	
	{ 11'd102, 11'd64, 11'd64 },
	{ 11'd103, 11'd64, 11'd64 },
	{ 11'd104, 11'd64, 11'd64 },
	
	{ 11'd105, 11'd64, 11'd64 },
	{ 11'd106, 11'd64, 11'd64 },
	{ 11'd107, 11'd64, 11'd64 },
	
	{ 11'd108, 11'd64, 11'd64 },
	{ 11'd109, 11'd64, 11'd64 },
	{ 11'd110, 11'd64, 11'd64 },
	
	{ 11'd111, 11'd64, 11'd64 },
	{ 11'd111, 11'd64, 11'd64 },
	{ 11'd111, 11'd64, 11'd64 },
	{ 11'd111, 11'd64, 11'd64 }
};

const logic [0:10] min_x = 11'd166;
const logic [0:10] max_x = min_x + 11'd248;

int death_state = -1;
typedef enum { LEFT = -1, RIGHT = 1} move_direction;
move_direction last_moved_direction = LEFT;

int tmp_speed = 0;
int finished = 0; // TODO: move this to be part of the game state

logic should_draw = 1'b0;
collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, temp_player_state[1] } ),
	.top( {21'b0, temp_player_state[2]} ),
	.width( {21'b0, temp_player_state[3]} ),
	.height( {21'b0, temp_player_state[4]} ),
	.should_be_drawn(should_draw)
);


logic[0:15][0:15][7:0] sprite1_2d;
logic[0:15][0:15][7:0] sprite2_2d;
logic[0:15][0:15][7:0] sprite3_2d;
int player_sprite_number;
int player_x_offset;
int player_y_offset;
localparam logic[7:0] MASK_VALUE = 8'h62;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_player_state <= default_player_state;
	end
	
	else begin
		if(frame_start) begin
			// Death animation
			if(death_state != -1) begin
				temp_player_state[1] <= temp_player_state[1] + last_moved_direction;
				death_state <= death_state + 1;
				if(death_state == 8*16) begin
					// reset the player
					temp_player_state <= default_player_state;
					death_state <= -1;
				end
				else begin
					temp_player_state[0] <= death_animation[death_state/8][0];
					temp_player_state[3] <= death_animation[death_state/8][1];
					temp_player_state[4] <= death_animation[death_state/8][2];
				end
			end
			else begin
				// car
				if(collisions[0] == 1'd1) begin
					death_state <= 0;
					tmp_speed <= 0;
				end
				// finish line
				else if (collisions[1] == 1'd1) begin
					finished <= 1;
				end
				else begin
					if(finished == 0 && NumberKey[8] == 1'd1) begin
						if(tmp_speed < 512) begin
							if(tmp_speed > 512 - 2) begin
								tmp_speed <= 512;
							end
							else begin
								tmp_speed <= tmp_speed + 3;
							end
						end
					end
					else if(finished ==1 || NumberKey[5] == 1'd1) begin
						if(tmp_speed > 0) begin
							if(tmp_speed <= 10) begin
								tmp_speed <= 0;
							end
							else begin
								tmp_speed <= tmp_speed - 10;
							end
						end
					end
//					else begin // speed decay?
//						if(tmp_speed <= 2) begin
//							tmp_speed <= 0;
//						end
//						else begin
//							tmp_speed <= tmp_speed - 2;
//						end
//					end
					
					if(finished == 0 && NumberKey[6] == 1'd1) begin
						last_moved_direction <= RIGHT;
						if((temp_player_state[1] + temp_player_state[4]) < max_x) begin
							temp_player_state[1] <= temp_player_state[1] + 11'd2;
						end
						else begin
							death_state <= 0;
							tmp_speed <= 0;
						end
					end
					else if (finished == 0 && NumberKey[4] == 1'd1) begin
						last_moved_direction <= LEFT;
						if(temp_player_state[1] > min_x) begin
							temp_player_state[1] <= temp_player_state[1] - 11'd2;
						end
						else begin
							death_state <= 0;
							tmp_speed <= 0;
						end
					end
				end
			end
			new_player_state <= temp_player_state;
			player_speed <= tmp_speed;
		end
		
		
		if(should_draw) begin
			player_sprite_number <= temp_player_state[0];
			player_x_offset <= temp_player_state[1];
			player_y_offset <= temp_player_state[2];
			// up
			if(player_sprite_number == 0) begin
				output_color <= sprite1_2d[(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			// up-right
			else if(player_sprite_number == 99) begin
				output_color <= sprite2_2d[(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			// right-up
			else if(player_sprite_number == 100) begin
				output_color <= sprite3_2d[(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			// right
			else if(player_sprite_number == 101) begin
				// TODO: car4
				output_color <= sprite1_2d[15-(requested_x-player_x_offset)/4][(requested_y-player_y_offset)/4];
			end
			//right-down
			else if(player_sprite_number == 102) begin
				output_color <= sprite3_2d[15-(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			//down-right
			else if(player_sprite_number == 103) begin
				output_color <= sprite2_2d[15-(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			//down
			else if(player_sprite_number == 104) begin // down
				output_color <= sprite1_2d[15-(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			// //down-left
			else if(player_sprite_number == 105) begin
				output_color <= sprite2_2d[15-(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end
			// left-down
			else if(player_sprite_number == 106) begin
				output_color <= sprite3_2d[15-(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end
			// left
			else if(player_sprite_number == 107) begin
				// todo: change to be car4 maybe
				output_color <= sprite1_2d[(requested_x-player_x_offset)/4][(requested_y-player_y_offset)/4];
			end
			
			// left-up
			else if(player_sprite_number == 108) begin
				output_color <= sprite3_2d[(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end
			// up-left
			else if(player_sprite_number == 109) begin
				output_color <= sprite2_2d[(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end
			// up
			else if(player_sprite_number == 110) begin
				output_color <= sprite1_2d[(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end

			// Default value
			else begin 
				output_color <= MASK_VALUE;
			end
		end
		else begin
			output_color <= MASK_VALUE;
		end
		
		
	end
end


always begin
	integer i, j;
	for (i=0; i<16; i=i+1) for (j=0; j<16; j=j+1) sprite1_2d[j][i] = sprite1[j*16+i];
	for (i=0; i<16; i=i+1) for (j=0; j<16; j=j+1) sprite2_2d[j][i] = sprite2[j*16+i];
	for (i=0; i<16; i=i+1) for (j=0; j<16; j=j+1) sprite3_2d[j][i] = sprite3[j*16+i];
end


endmodule
