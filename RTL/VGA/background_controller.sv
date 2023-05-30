
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Nadav May 2023
//-- Ari May 2023

module	background_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input    logic [0:9] player_speed,
					input	   logic [0:32*128-1][7:0] sprite,
					output   logic [0:4][0:10] new_state,
					output   logic [7:0] output_color
);
logic [0:4] [0:10] default_background_state = {
	11'd31, // img_id
	11'd32, // x 11
	11'd0, // y
	11'd512, //width 13
	11'd480 // height
};
logic [0:4] [0:10] temp_background_state = {
	11'd31, // img_id
	11'd32, // x 11
	11'd0, // y
	11'd512, //width 13
	11'd480// height
};

logic [0:31][0:127][7:0]  background_2d;
const logic [0:10] max_x;
int bg_x_offset, bg_y_offset;
localparam logic[7:0] MASK_VALUE = 8'h62;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_state <= default_background_state;
	end
	
	else begin
		if(frame_start) begin
			temp_background_state[2] = temp_background_state[2] - (player_speed / 128);
		end
		
		bg_x_offset <= {21'b0, temp_background_state[1]};
		bg_y_offset <= {21'b0, temp_background_state[2]};
		if ((requested_x > temp_background_state[1]) && 
			 (requested_x < (temp_background_state[1] + temp_background_state[3]))) begin
			output_color <= background_2d[((requested_y+bg_y_offset)/4)%32][(requested_x-bg_x_offset)/4];
		end
		else begin
			output_color <= MASK_VALUE;
		end
		
		new_state <= temp_background_state;
	end
end

always begin
	integer i, j;
	for (i=0; i<128; i=i+1) for (j=0; j<32; j=j+1) background_2d[j][i] = sprite[j*128+i];
end
endmodule
