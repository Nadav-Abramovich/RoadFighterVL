
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	progress_bar_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input    int distance_drove,
					input    int track_length,
					input	   logic [0:32*16-1][7:0] car_sprite,
					input	   logic [0:8*8-1][7:0] blue_flag_sprite,
					input	   logic [0:8*8-1][7:0] yellow_flag_sprite,
					output   logic [0:4][0:10] new_state,
					output   logic [7:0] output_color
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


logic[0:31][0:15][7:0] car_sprite_2d;
logic[0:7][0:7][7:0] blue_flag_sprite_2d;
logic[0:7][0:7][7:0] yellow_flag_sprite_2d;
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



int car_x_offset, car_y_offset;
int yf_x_offset, yf_y_offset;
int bf_x_offset, bf_y_offset;
logic [0:2][7:0] output_colors;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_state <= default_pb_state;
	end
	
	else begin
		if(frame_start) begin
			temp_pb_state[2] = 416 - (distance_drove/128);
		end
		
		if (should_draw) begin
			car_x_offset <= {21'b0, temp_pb_state[1]};
			car_y_offset <= {21'b0, temp_pb_state[2]};
			output_colors[0] <= car_sprite_2d[(requested_y-car_y_offset)/2][(requested_x-car_x_offset)/2];
		end
		else begin
			output_colors[0] <= MASK_VALUE;
		end
		
		if (should_draw_yf) begin
			yf_x_offset <= {21'b0, yf_state[1]};
			yf_y_offset <= {21'b0, yf_state[2]};
			output_colors[1] <= yellow_flag_sprite_2d[(requested_y-yf_y_offset)/4][(requested_x-yf_x_offset)/4];
		end
		else begin
			output_colors[1] <= MASK_VALUE;
		end
		
		if (should_draw_bf) begin
			bf_x_offset <= {21'b0, bf_state[1]};
			bf_y_offset <= {21'b0, bf_state[2]};
			output_colors[2] <= blue_flag_sprite_2d[(requested_y-bf_y_offset)/4][(requested_x-bf_x_offset)/4];
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

always begin
	integer i, j;
	for (i=0; i<32; i=i+1) for (j=0; j<16; j=j+1) car_sprite_2d[i][j] = car_sprite[j*32+i];
	for (i=0; i<8; i=i+1) for (j=0; j<8; j=j+1) blue_flag_sprite_2d[i][j] = blue_flag_sprite[j*8+i];
	for (i=0; i<8; i=i+1) for (j=0; j<8; j=j+1) yellow_flag_sprite_2d[i][j] = yellow_flag_sprite[j*8+i];
end
endmodule
