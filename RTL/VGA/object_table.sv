
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	object_table	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	minus_is_pressed,
					input		logic	plus_is_pressed,
					input		logic	frame_start,
					input    logic [10:0] requested_x,
					input    logic [10:0] requested_y,
					
					input    logic [0:4][0:10] new_player_state,
					input    logic [0:4][0:10] new_car1_state,
					input    logic [0:4][0:10] new_bg_state,
					
		  // background 
				   output	int img_id,
					output	int x_to_draw,
					output	int y_to_draw,
					output	int x_offset,
					output	int y_offset,
					output   logic [0:14] [0:10] out_obj_table
);
//[object_id][img_id,x,y,width,height][data]
logic [0:14][0:10] obj_table = {
	// Player
	11'b0, // img_id
	11'b100101100, // x
	11'b111, // y
	11'b10000, //width
	11'b100000, // height
	// Computer Car
	11'b0, // img_id
	11'b100000000, // x
	11'b101111100, // y
	11'b10000, //width
	11'b100000, // height
	// BG (road)
	11'b11111, // img_id
	11'b001101010, // x 11
	11'b111, // y
	11'b100111110, //width 13
	11'b100000 // height
};

int current_x = 0;
int tmp1 = 0;
int tmp2 = 0;
int tmp3 = 0;


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			img_id <= 0;
			x_offset <= 0;
			y_offset <= 0;
			x_to_draw <= 0;
			y_to_draw <= 0;
			
			// TODO: OUTPUT 0s
			out_obj_table <= obj_table;
	end
	
	else begin
		current_x <= {21'b0, requested_x};

//		tmp1 <= {21'b0, obj_table[11]};
//		tmp2 <= {21'b0, obj_table[13]};
//		tmp3 <= obj_table[11] + obj_table[13];
//		
		obj_table[0:4] <= new_player_state;
		obj_table[5:9] <= new_car1_state;
		obj_table[10:14] <= new_bg_state;
		x_to_draw <= requested_x;
		y_to_draw <= requested_y;
//		if(should_draw_1) begin
//			img_id <= {21'b0, obj_table[0]};
//			x_offset <= {21'b0, obj_table[1]};
//			y_offset <= {21'b0, obj_table[2]};
//			x_to_draw <= {21'b0, requested_x};
//			y_to_draw <= {21'b0, requested_y};
//		end
//		else if(should_draw_2) begin
//			img_id <= {21'b0, obj_table[5]};
//			x_offset <= {21'b0, obj_table[6]};
//			y_offset <= {21'b0, obj_table[7]};
//			x_to_draw <= {21'b0, requested_x};
//			y_to_draw <= {21'b0, requested_y};
//		end
//		else if((requested_x > obj_table[11]) && (requested_x < (obj_table[11]+obj_table[13]))) begin
//			img_id <= {21'b0, obj_table[10]};
//			x_offset <= {21'b0, obj_table[11]};
//			y_offset <= {21'b0, obj_table[12]};
//			x_to_draw <= {21'b0, requested_x};
//			y_to_draw <= {21'b0, requested_y};
//		end
//		else begin
//			img_id <= -1;
//			x_offset <= -1;
//			y_offset <= -1;
//			x_to_draw <= -1;
//			y_to_draw <= -1;
//		end
		out_obj_table <= obj_table;
	end
end

endmodule
