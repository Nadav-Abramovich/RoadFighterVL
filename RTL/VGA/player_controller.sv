
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	player_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	minus_is_pressed,
					input		logic	plus_is_pressed,
					input		logic [9:0]	NumberKey,
					input		logic	frame_start,
					input    logic [0:19][0:10] current_state,
					input    logic [0:1] collisions,
					output   logic [0:4][0:10] new_player_state,
					output   logic [0:9] player_speed
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
int finished = 0;
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
	end
end

endmodule
