module	sprite_storage	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input    logic frame_start,
					input    logic [0:14][0:10] current_state,
					input    int requested_x,
					input    int requested_y,
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);

logic[0:15][0:15][7:0] car1 = {
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'he4,8'h00,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'he4,8'he4,8'hc0,8'h00,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'he4,8'he4,8'hc0,8'hc0,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'hc0,8'hc0,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'h00,8'he4,8'hc0,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'hff,8'he4,8'he4,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'hff,8'he4,8'he4,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'h00,8'h00,8'h00,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'he4,8'hff,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'he4,8'h00,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'he4,8'h00,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'h00,8'h62,8'h62,8'h62}};

logic[0:15][0:15][7:0] car2 = {
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'hff,8'he4,8'he4,8'he4,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'h00,8'he4,8'he4,8'he4,8'he4,8'he4,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'hff,8'h00,8'h00,8'h00,8'he4,8'he4,8'he4,8'he4,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'hff,8'he4,8'he4,8'h00,8'h00,8'h00,8'he4,8'he4,8'h00,8'h62},
	{8'h62,8'h62,8'he4,8'hff,8'he4,8'h00,8'h00,8'he4,8'he4,8'he4,8'h00,8'he4,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h00,8'he4,8'hc0,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h00,8'h00,8'he4,8'he4,8'he4,8'he4,8'h00,8'hc0,8'hc0,8'hc0,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h00,8'he4,8'he4,8'he4,8'he4,8'hc0,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h00,8'he4,8'he4,8'he4,8'hc0,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h00,8'he4,8'he4,8'he4,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h00,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'h00,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62}};

logic[0:15][0:15][7:0] car3 = {
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'hff,8'he4,8'he4,8'he4,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'h62},
	{8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'hff,8'he4,8'he4,8'h00,8'he4,8'he4,8'he4,8'he4,8'he4,8'h62},
	{8'h62,8'h62,8'he4,8'he4,8'hff,8'he4,8'he4,8'he4,8'h00,8'h00,8'h00,8'he4,8'he4,8'he4,8'he4,8'h62},
	{8'h62,8'he4,8'he4,8'hff,8'h00,8'h00,8'he4,8'he4,8'he4,8'h00,8'h00,8'he4,8'he4,8'he4,8'he4,8'h62},
	{8'h00,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'he4,8'he4,8'h00,8'h00,8'he4,8'he4,8'hc0,8'h00,8'h62},
	{8'h00,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h00,8'he4,8'he4,8'he4,8'hc0,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h00,8'h00,8'he4,8'he4,8'he4,8'h00,8'h00,8'he4,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h00,8'he4,8'he4,8'he4,8'h00,8'h00,8'he4,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h00,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h00,8'he4,8'he4,8'he4,8'he4,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h00,8'he4,8'he4,8'he4,8'hc0,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h00,8'he4,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62,8'h62}};

	
logic[0:15][0:15][7:0] ai_car_red = {
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'hff,8'h00,8'h00,8'h00,8'he4,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h91,8'h00,8'h00,8'h00,8'h00,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'h00,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'h00,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'h00,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'he4,8'he4,8'he4,8'h00,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'h00,8'h00,8'h00,8'he4,8'he4,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'he4,8'h00,8'h00,8'h00,8'h00,8'h00,8'he4,8'h00,8'h00,8'h62,8'h62,8'h62}};

logic[0:15][0:15][7:0] ai_car_yellow = {
	{8'h62,8'h62,8'h62,8'h62,8'h62,8'hf8,8'hff,8'hf8,8'hf8,8'hf8,8'h00,8'h00,8'h62,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'hf8,8'hff,8'hf8,8'hf8,8'hf8,8'hf8,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'hff,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'hff,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'hff,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'hff,8'h00,8'h00,8'h00,8'hf8,8'hf8,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'h91,8'h00,8'h00,8'h00,8'h00,8'hf8,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'h00,8'hf8,8'hf8,8'hf8,8'h00,8'hf8,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'h00,8'hf8,8'hf8,8'hf8,8'h00,8'hf8,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'h00,8'hf8,8'hf8,8'hf8,8'h00,8'hf8,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'h00,8'hf8,8'hf8,8'hf8,8'h00,8'hf8,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'hf8,8'h00,8'h00,8'h00,8'hf8,8'hf8,8'h00,8'h00,8'h00,8'h00,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'h00,8'h00,8'h00,8'h00,8'h00,8'hf8,8'h00,8'h00,8'h00,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'hf8,8'h00,8'h00,8'h62,8'h62,8'h62},
	{8'h62,8'h62,8'h62,8'h62,8'hf8,8'h00,8'h00,8'h00,8'h00,8'h00,8'hf8,8'h00,8'h00,8'h62,8'h62,8'h62}};


logic [0:31][0:127][7:0]  background = {
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h0c,8'h0c,8'h10,8'h34,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hdf,8'h96,8'h00,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h00,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h78,8'h30,8'h04,8'h04,8'h04,8'h04,8'h04,8'h2c,8'h78,8'h78,8'h78,8'h78,8'h78,8'h34,8'h74,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h71,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h0c,8'h04,8'h04,8'h00,8'h00,8'h00,8'h00,8'h00,8'h04,8'h78,8'h78,8'h78,8'h0c,8'h00,8'h04,8'h04,8'h04,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h0c,8'h04,8'h04,8'h2c,8'h04,8'h0c,8'h04,8'h04,8'h00,8'h00,8'h78,8'h34,8'h04,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h2c,8'h04,8'h30,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h71,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h0c,8'h00,8'h00,8'h0c,8'h00,8'h74,8'h30,8'h00,8'h00,8'h00,8'h10,8'h30,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h74,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hbb,8'h71,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h10,8'h0c,8'h99,8'h0c,8'h34,8'h0c,8'h78,8'h10,8'h30,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h04,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'hdf,8'h96,8'h00,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h00,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h0c,8'hbe,8'h78,8'h79,8'h0c,8'h78,8'h04,8'h00,8'h00,8'h04,8'h74,8'h0c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h04,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h9d,8'h9a,8'h2d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h99,8'h0c,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h7c,8'h00,8'h04,8'h30,8'h00,8'h00,8'h04,8'h30,8'h00,8'h04,8'h0c,8'h30,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h04,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h10,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h04,8'h04,8'hbe,8'h00,8'h04,8'h04,8'h00,8'h00,8'h79,8'h38,8'h78,8'h0c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h74,8'h78,8'h04,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h30,8'h34,8'h00,8'h30,8'h04,8'h0c,8'h00,8'h30,8'h10,8'h78,8'h78,8'h78,8'h04,8'h2c,8'h04,8'h0c,8'h00,8'h78,8'h34,8'h10,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h71,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h2d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h0c,8'h04,8'h34,8'h0c,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hdf,8'h96,8'h00,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h00,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hbe,8'h9a,8'h04,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hbe,8'h04,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h04,8'h04,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hbb,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h10,8'h30,8'h78,8'h78,8'h78,8'h34,8'h30,8'h78,8'h78,8'h30,8'h34,8'h78,8'h30,8'h74,8'h78,8'h78,8'h0c,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h34,8'h00,8'h00,8'h00,8'h00,8'h00,8'h2c,8'h30,8'h34,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h2c,8'h2d,8'h00,8'h00,8'h2c,8'h78,8'h74,8'h2d,8'h00,8'h00,8'h04,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h04,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h74,8'h30,8'h30,8'h0c,8'h34,8'h78,8'h78,8'h70,8'h75,8'h00,8'h74,8'h38,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h2c,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hbe,8'h9a,8'h24,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h9e,8'h04,8'h30,8'h78,8'h78,8'h78,8'h78,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h74,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h10,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hdf,8'h96,8'h00,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h00,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h74,8'h74,8'h78,8'h78,8'h34,8'h38,8'h78,8'h74,8'h78,8'h78,8'h78,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h04,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h79,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h71,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h10,8'h30,8'h78,8'h78,8'h78,8'h78,8'h71,8'h2c,8'h00,8'h00,8'h74,8'h78,8'h75,8'h31,8'h04,8'h00,8'h0c,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h10,8'h00,8'h00,8'h00,8'h00,8'h00,8'h04,8'h00,8'h2c,8'h74,8'h0c,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h71,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h0c,8'h31,8'h04,8'h00,8'h04,8'h78,8'h74,8'h2c,8'h04,8'h00,8'h04,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h04,8'h34,8'h30,8'h04,8'h00,8'h78,8'h74,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h79,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h34,8'h78,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hdf,8'h96,8'h00,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hbf,8'hba,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h00,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h34,8'h34,8'h74,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h9d,8'h9a,8'h2d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h99,8'h0c,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h34,8'h0c,8'h04,8'h04,8'h04,8'h04,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h10,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h34,8'h04,8'h04,8'h00,8'h00,8'h00,8'h00,8'h00,8'h34,8'h78,8'h78,8'h78,8'h34,8'h00,8'h30,8'h34,8'h34,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h38,8'h04,8'h04,8'h04,8'h9a,8'h00,8'h04,8'h00,8'h00,8'h00,8'h0c,8'h78,8'h78,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h70,8'h04,8'h78,8'h78,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h04,8'h04,8'h00,8'h0c,8'h04,8'h78,8'h10,8'h00,8'h00,8'h04,8'h34,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h30,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hdf,8'h96,8'h00,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hdf,8'h00,8'h30,8'h78,8'h78,8'h78,8'h78,8'h0c,8'h0c,8'h9a,8'h0c,8'h0c,8'h0c,8'h34,8'h30,8'h04,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h30},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h9e,8'h9a,8'h24,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h9e,8'h04,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h74,8'h75,8'h78,8'h0c,8'h74,8'h74,8'h0c,8'h04,8'h00,8'h04,8'h2c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h04},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h74,8'h00,8'h30,8'h04,8'h04,8'h04,8'h0c,8'h04,8'h00,8'h04,8'h30,8'h04,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h0c,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h30,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'h2c,8'h70,8'h00,8'h00,8'h00,8'h00,8'h00,8'h30,8'h78,8'h78,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h30,8'h2c,8'h30,8'h78},
	{8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hba,8'h6d,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'h78,8'h10,8'h30,8'h78,8'h78,8'h78,8'h78,8'h78,8'h38,8'h0c,8'h30,8'h00,8'h74,8'h04,8'h2c,8'h00,8'h79,8'h0c,8'h78,8'h78,8'h78,8'h00,8'h00,8'h00,8'h00,8'h04,8'h30,8'h34,8'h04,8'h78,8'h78,8'h78},
	{8'h38,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h38,8'h38,8'h38,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'hbe,8'h96,8'h04,8'h00,8'h2d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'h6d,8'hdf,8'hbe,8'h04,8'h30,8'h38,8'h38,8'h78,8'h78,8'h78,8'h78,8'h78,8'h34,8'h10,8'h04,8'h04,8'h04,8'h0c,8'h78,8'h78,8'h78,8'h78,8'h78,8'h10,8'h78,8'h10,8'h78,8'h10,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78}};
int y_pos=0;


logic should_draw_1 = 1'b0;
logic should_draw_2 = 1'b0;
logic should_draw_3 = 1'b0;

collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, current_state[1] } ),
	.top( {21'b0, current_state[2]} ),
	.width( {21'b0, current_state[3]} ),
	.height( {21'b0, current_state[4]} ),
	.should_be_drawn(should_draw_1)
);
collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, current_state[6] } ),
	.top( {21'b0, current_state[7]} ),
	.width( {21'b0, current_state[8]} ),
	.height( {21'b0, current_state[9]} ),
	.should_be_drawn(should_draw_2)
);

collision_detector (
	.clk (clk),
	.resetN( resetN ),
	.requested_x( {21'b0, requested_x} ),
	.requested_y( {21'b0, requested_y} ),
	.left( {21'b0, current_state[11] } ),
	.top( {current_state[12][0], 20'b1, current_state[12][1:10]} ),
	.width( {21'b0, current_state[13]} ),
	.height( {21'b0, current_state[14]} ),
	.should_be_drawn(should_draw_3)
);


int sprite_number = 0;
int x_offset = 0;
int y_offset = 0;
int bg_1 = 0;
int bg_2 = 0;
localparam logic[7:0] MASK_VALUE = 8'h62;
logic	[2:0][7:0] RGBouts = {
	MASK_VALUE,
	MASK_VALUE,
	MASK_VALUE
};

int player_sprite_number;
int player_x_offset;
int player_y_offset;

int ai_car1_sprite_number;
int ai_car1_x_offset;
int ai_car1_y_offset;

int bg_sprite_number;
int bg_x_offset;
int bg_y_offset;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBout <= 1'b0;
	end
	
	else begin
		bg_1 <= {21'b0, current_state[11]};
		bg_2 <= {21'b0, current_state[13]};
		
		if(should_draw_1) begin
			player_sprite_number <= current_state[0];
			player_x_offset <= {21'b0, current_state[1]};
			player_y_offset <= {21'b0, current_state[2]};
			// up
			if(player_sprite_number == 0) begin
				RGBouts[0] <= car1[(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			// up-right
			else if(player_sprite_number == 99) begin
				RGBouts[0] <= car2[(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			// right-up
			else if(player_sprite_number == 100) begin
				RGBouts[0] <= car3[(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			// right
			else if(player_sprite_number == 101) begin
				// TODO: car4
				RGBouts[0] <= car1[15-(requested_x-player_x_offset)/4][(requested_y-player_y_offset)/4];
			end
			//right-down
			else if(player_sprite_number == 102) begin
				RGBouts[0] <= car3[15-(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			//down-right
			else if(player_sprite_number == 103) begin
				RGBouts[0] <= car2[15-(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			//down
			else if(player_sprite_number == 104) begin // down
				RGBouts[0] <= car1[15-(requested_y-player_y_offset)/4][(requested_x-player_x_offset)/4];
			end
			// //down-left
			else if(player_sprite_number == 105) begin
				RGBouts[0] <= car2[15-(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end
			// left-down
			else if(player_sprite_number == 106) begin
				RGBouts[0] <= car3[15-(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end
			// left
			else if(player_sprite_number == 107) begin
				// todo: change to be car4 maybe
				RGBouts[0] <= car1[(requested_x-player_x_offset)/4][(requested_y-player_y_offset)/4];
			end
			
			// left-up
			else if(player_sprite_number == 108) begin
				RGBouts[0] <= car3[(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end
			// up-left
			else if(player_sprite_number == 109) begin
				RGBouts[0] <= car2[(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end
			// up
			else if(player_sprite_number == 110) begin
				RGBouts[0] <= car1[(requested_y-player_y_offset)/4][15-(requested_x-player_x_offset)/4];
			end

			
			// Default value
			else begin 
				RGBouts[0] <= MASK_VALUE;
			end
		end
		else begin
			RGBouts[0] <= MASK_VALUE;
		end
		
		if (should_draw_2) begin
			ai_car1_sprite_number <= current_state[5];
			ai_car1_x_offset <= {21'b0, current_state[6]};
			ai_car1_y_offset <= {21'b0, current_state[7]};
			if(ai_car1_sprite_number == 11'd1) begin
				RGBouts[1] <= ai_car_yellow[(requested_y-ai_car1_y_offset)/4][(requested_x-ai_car1_x_offset)/4];
			end
		end
		else begin
			RGBouts[1] <= MASK_VALUE;
		end 

		if ((requested_x > bg_1) && (requested_x < (bg_1+bg_2))) begin
			bg_sprite_number <= current_state[10];
			bg_x_offset <= {21'b0, current_state[11]};
			bg_y_offset <= {21'b0, current_state[12]};
			if(bg_sprite_number==11'd31) begin
				RGBouts[2] <= background[((requested_y+bg_y_offset)/4)%32][(requested_x-bg_x_offset)/4];
			end
			else begin
				RGBouts[2] <= MASK_VALUE;
			end 
		end
		else begin
			RGBouts[2] <= MASK_VALUE;
		end

		if(RGBouts[0] != MASK_VALUE) begin
			RGBout <= RGBouts[0];
		end
		else if(RGBouts[1] != MASK_VALUE) begin
			RGBout <= RGBouts[1];
		end
		else if(RGBouts[2] != MASK_VALUE) begin
			RGBout <= RGBouts[2];
		end
		else begin
			RGBout <= 8'b0000_0000;
		end
	end
end

endmodule
