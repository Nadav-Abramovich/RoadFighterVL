
//not implemented yet
module musix_mux (
	input logic clk,
	input logic resetN,
	input logic frame_start,
	input logic [0:4] game_states,
	input logic [0:1] collision,



	output enable_sound,
	output logic [3:0] sound
	);
	
	
int timer;

enum logic [0:4] {collision_car, bonus, finished_game, collision_edge} state;

always_ff @(posedge clk or negedge resetN) begin
	if(!resetN) begin
		timer <= 5'd0;
	end
	else begin 
		if (collision[0]) begin
			timer <= 5'd3;
			state <= collision_car;
		end
		else if (game_states[1])begin
			timer <= 5'd3;
			state <= collision_edge;
		end 
	   else 	if (collision[1]) begin
			timer <= 5'd4;
			state <= finished_game;
		end 
		else if(game_states[0]) begin 
			timer <= 5'd5;
			state <= bonus;
		end 
	

	
		if(frame_start)
			timer <= timer - 1;
		if (timer>0) begin
			enable_sound=1;
			case (state)
				collision_car: sound <= 4'b0100;
				bonus: sound <= 4'b0111;
				finished_game: sound <= 4'b0110;
				collision_edge: sound <= 4'b0011;
				//default: sound <= 4'b0000;
			endcase
		end
		else  begin
			sound <= 4'b0000;
			enable_sound=0;
		end
	end
end 
endmodule 