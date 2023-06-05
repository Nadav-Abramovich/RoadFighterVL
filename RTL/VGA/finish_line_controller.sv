

//-- Nadav May 2023
//-- Arie May 2023

module	finish_line_controller	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input    int distance_drove,
					input    int track_length,
					output 	logic stop_signal,
					output   logic [7:0] output_color,
					output   logic [0:4][0:10] new_state
				
);
const logic [0:4] [0:10] default_fl_state = {
	11'd10, // img_id
	11'd166, // x
	11'd780, // y
	11'd248, //width
	11'd64, //height
};
logic [0:4] [0:10] temp_fl_state = default_fl_state;
localparam logic[7:0] MASK_VALUE = 8'h62;
logic should_draw = 1'b0;
const logic[0:15][0:15][7:0] finish_line = {
	{8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00, 8'hFF},
	{8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF, 8'h00},
	{8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00, 8'hFF},
	{8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF, 8'h00},
	{8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00, 8'hFF},
	{8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF, 8'h00},
	{8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00, 8'hFF},
	{8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF, 8'h00},
	{8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00, 8'hFF},
	{8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF, 8'h00},
	{8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00, 8'hFF},
	{8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF, 8'h00},
	{8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00, 8'hFF},
	{8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF, 8'h00},
	{8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00, 8'hFF},
	{8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF,8'h00,8'hFF, 8'h00}};


collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, temp_fl_state[1] } ),
	.top( {21'b0, temp_fl_state[2]} ),
	.width( {21'b0, temp_fl_state[3]} ),
	.height( {21'b0, temp_fl_state[4]} ),
	.should_be_drawn(should_draw)
);
int fl_x_offset, fl_y_offset;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		new_state <= default_fl_state;
	end
	
	else begin
		if(frame_start) begin
			if(distance_drove > track_length) begin
				temp_fl_state[2] <= distance_drove-track_length;
				stop_signal <= 1'b1;
			end
			else begin 
				new_state <= temp_fl_state;
				stop_signal <= 1'b0;
			end
		end
		
		if (should_draw) begin
			fl_x_offset <= {21'b0, temp_fl_state[1]};
			fl_y_offset <= {21'b0, temp_fl_state[2]};
			output_color <= finish_line[(requested_y-fl_y_offset)/4][((requested_x-fl_x_offset)/4)%16];
		end
		else begin
			output_color <= MASK_VALUE;
		end 

	end
end


endmodule
