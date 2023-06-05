
module	game_mux	(	
			
			input	logic	clk,
			input	logic	resetN,
			input [0:10] states,
			input logic [0:7] background_color,
			
			input	logic	startOfFrame, // short pulse every start of frame 30Hz 
			input logic [0:7] progress_bar_color,
			input logic [0:7] messageboard,
			input logic [0:7] finish_line_color,
			input logic [0:7] car_bonus,
			input logic [0:7] ai_car_color,
			input logic [0:7] player_car,
			input logic [0:7] truck_color,
			input logic [0:7] ai_car_red,
			input  logic [0:10] requested_x,
			input  logic [0:10] requested_y,
			output logic [0:4] game_states, //0 stands for car bonus .
			output logic [7:0] RGB
);



const logic [0:10] min_x = 11'd166;
const logic [0:10] max_x = min_x + 11'd248;

localparam logic[7:0] MASK_VALUE = 8'h62;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		RGB <= 0;
	end 
		else begin 		
				
				
				
				if ((player_car != MASK_VALUE)&&(car_bonus != MASK_VALUE)) begin	
					game_states[0] <= 1'b1;
				end
				else begin 
					game_states[0] <= 1'b0;
				end
				
				
				if ((player_car != MASK_VALUE)&&((requested_x <= min_x) || (requested_x >=max_x))) begin
					game_states[1] <= 1; //play sound 
				end 
				else begin  
					game_states[1] <= 0;
				end
			
			//// --------------
			//// sprite priority
			//// --------------
			if(player_car != MASK_VALUE) begin
				RGB <= player_car;
			end
		
			else if(ai_car_color != MASK_VALUE) begin
				RGB <= ai_car_color;
			end
			else if(truck_color != MASK_VALUE) begin
				RGB <= truck_color;
			end
			else if(car_bonus != MASK_VALUE) begin
				RGB <= car_bonus;
			end
			else if(ai_car_red != MASK_VALUE) begin
				RGB <= ai_car_red;
			end
			else if(finish_line_color != MASK_VALUE) begin
				RGB <= finish_line_color;
			end
			else if(background_color!=MASK_VALUE)
				RGB<=background_color;
			else 	
				RGB <= 8'b01110110;
			if(progress_bar_color != MASK_VALUE) begin
				RGB <= progress_bar_color;
			end
			if(messageboard != MASK_VALUE) begin
				RGB <= messageboard;
			end
		end		
end
endmodule