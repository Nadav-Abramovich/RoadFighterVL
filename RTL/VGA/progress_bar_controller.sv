//-- Nadav May 2023
//-- Arie May 2023

module	progress_bar_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input    logic [0:9] player_speed,
					input    int distance_drove,
					input    int track_length,
					input 	logic [0:4] game_states,
					
					output   logic [0:4][0:10] new_state,
					output   logic [7:0] output_color,
					output 	logic [13:0] fuel_val,
					output 	logic [13:0] score_val
);

const logic [0:4] [0:10] default_pb_state = {
	11'd31, // img_id
	11'd0, // x 11
	11'd416, // y
	11'd32, //width 13
	11'd64 // height
};
logic [0:4] [0:10] temp_pb_state = default_pb_state;

const logic [0:4] [0:10] yf_state = {
	11'd32, // img_id
	11'd0, // x 11
	11'd16, // y
	11'd32, //width 13
	11'd32 // height
};

const logic [0:4] [0:10] bf_state = {
	11'd32, // img_id
	11'd0, // x 11
	11'd448, // y
	11'd32, //width 13
	11'd32 // height
};


const logic [0:4] [0:10] score_state = {
	11'd32, // img_id
	11'd549, // x 11
	11'd85, // y
	11'd32, //width 13
	11'd32 // height
};


logic[0:31][0:15][7:0] car_sprite_player = {
	{8'h62,8'h62,8'h62,8'h62,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff,8'h62,8'h62},
	{8'h62,8'h62,8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff,8'h62,8'h62},
	{8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'he4,8'hff,8'hff},
	{8'h62,8'h62,8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff,8'h62,8'h62},
	{8'h62,8'h62,8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff,8'h62,8'h62},
	{8'h62,8'h62,8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff,8'h62,8'h62},
	{8'h62,8'h62,8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff,8'h62,8'h62},
	{8'h62,8'h62,8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff,8'h62,8'h62},
	{8'h62,8'h62,8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff,8'h62,8'h62},
	{8'h62,8'h62,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h62,8'h62},
	{8'h62,8'h62,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'h62,8'h62},
	{8'hff,8'hff,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'hff,8'hff},
	{8'hff,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'hff,8'hff},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62}};

 
 





logic[0:7][0:7][7:0] blue_flag_sprite = {
	{8'h62,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'hff,8'h1f,8'h1f,8'h1f,8'h1f,8'h1f,8'h1f},
	{8'h62,8'hff,8'h1f,8'h1f,8'h1f,8'h1f,8'h1f,8'h62},
	{8'h62,8'hff,8'h1f,8'h1f,8'h1f,8'h1f,8'h62,8'h62},
	{8'h62,8'hff,8'h1f,8'h1f,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62}};





	
logic[0:7][0:7][7:0] yellow_flag_sprite = {
	{8'h62,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'hff,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8},
	{8'h62,8'hff,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'h62},
	{8'h62,8'hff,8'hf8,8'hf8,8'hf8,8'hf8,8'h62,8'h62},
	{8'h62,8'hff,8'hf8,8'hf8,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'hff,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62}};












const logic [0:10] max_x;
int bg_x_offset, bg_y_offset;
localparam logic[7:0] MASK_VALUE = 8'h62;

logic should_draw = 1'b0;
collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, temp_pb_state[1] } ),
	.top( {21'b0, temp_pb_state[2]} ),
	.width( {21'b0, temp_pb_state[3]} ),
	.height( {21'b0, temp_pb_state[4]} ),
	.should_be_drawn(should_draw)
);


// flags
logic should_draw_yf = 1'b0;
collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, yf_state[1] } ),
	.top( {21'b0, yf_state[2]} ),
	.width( {21'b0, yf_state[3]} ),
	.height( {21'b0, yf_state[4]} ),
	.should_be_drawn(should_draw_yf)
);
logic should_draw_bf = 1'b0;
collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, bf_state[1] } ),
	.top( {21'b0, bf_state[2]} ),
	.width( {21'b0, bf_state[3]} ),
	.height( {21'b0, bf_state[4]} ),
	.should_be_drawn(should_draw_bf)
);



const int mult=2;
int digits_position_x, digits_position_y;
// numbers

int car_x_offset, car_y_offset;
int yf_x_offset, yf_y_offset;
int bf_x_offset, bf_y_offset;
logic [0:2][7:0] output_colors;



int score_val_reg = 0;
int fuel_val_reg = 100;
    
int one_sec_point = 0;
logic [3:0][3:0] temp;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_state <= default_pb_state;
		score_val_reg = 0;
		fuel_val_reg = 100;
		one_sec_point = 0;
		temp_pb_state <= default_pb_state;
	end
	
	else begin
	
	if(game_states[0]) begin //player took extra fuel.
		score_val_reg+=100;
		fuel_val_reg+=5;
		if (fuel_val_reg>100)
			fuel_val_reg=0;
	end 
	if(frame_start) begin
		one_sec_point++;
		if(((one_sec_point%16)==0)&& (player_speed>0)) begin
			score_val_reg += player_speed/128;
			score_val = score_val_reg;
		end 
		if(((one_sec_point%64)==0)&& (player_speed>0)) begin
			fuel_val_reg -= player_speed%2;
			if ((fuel_val_reg<0) || (fuel_val_reg > 100)) begin
				//maybe gameover, let's go over that later... 
				fuel_val_reg=0;
			end
			fuel_val = fuel_val_reg;
		end
	end	
		if(frame_start) begin
			temp_pb_state[2] = 416 - (distance_drove/128);
		end
		
		if (should_draw) begin
			car_x_offset <= {21'b0, temp_pb_state[1]};
			car_y_offset <= {21'b0, temp_pb_state[2]};
			output_colors[0] <= car_sprite_player[(requested_y-car_y_offset)/2][(requested_x-car_x_offset)/2];
		end
		else begin
			output_colors[0] <= MASK_VALUE;
		end
		
		if (should_draw_yf) begin
			yf_x_offset <= {21'b0, yf_state[1]};
			yf_y_offset <= {21'b0, yf_state[2]};
			output_colors[1] <= yellow_flag_sprite[(requested_y-yf_y_offset)/4][(requested_x-yf_x_offset)/4];
		end
		else begin
			output_colors[1] <= MASK_VALUE;
		end
		
		if (should_draw_bf) begin
			bf_x_offset <= {21'b0, bf_state[1]};
			bf_y_offset <= {21'b0, bf_state[2]};
			output_colors[2] <= blue_flag_sprite[(requested_y-bf_y_offset)/4][(requested_x-bf_x_offset)/4];
		end
		else begin
			output_colors[2] <= MASK_VALUE;
		end
		
		if(output_colors[0] != MASK_VALUE) begin
			output_color <= output_colors[0];
		end
		else if(output_colors[1] != MASK_VALUE) begin
			output_color <= output_colors[1];
		end
		else if(output_colors[2] != MASK_VALUE) begin
			output_color <= output_colors[2];
		end
		else if(requested_x <= 11'd32) begin
			output_color <= 8'h6d;
		end 
		else begin
			output_color <= MASK_VALUE;
		end 
 		new_state <= temp_pb_state;
	end
end

endmodule
