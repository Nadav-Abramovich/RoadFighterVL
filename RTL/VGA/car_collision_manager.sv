module	car_collision_manager(
					input		logic	clk,
					input		logic	resetN,
					input    logic frame_start,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input    logic [0:7] ai_car_yellow,
					input    logic [0:7] player_car_color,
					input    logic [0:7] fl_color,
					input    logic [0:7] ai_car_red,
					input    logic [0:7] ai_car_truck,
					output	logic	[7:0] RGBout, 
					output   logic [0:1] collisions
					
					
);
localparam logic[7:0] MASK_VALUE = 8'h62;
always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin
		RGBout <= 1'b0;
		collisions[1] <= 1'd0;
	end	
	else begin 	
		if(requested_x == 1 && requested_y == 1) begin
		collisions[0] <= 0;
		collisions[1] <= 0;
		end
	
		else begin
		if(player_car_color != MASK_VALUE) begin
				if(ai_car_yellow != MASK_VALUE) begin
					collisions[0] <= 1'd1; // 0 for ai && player
				end	
				if(ai_car_red != MASK_VALUE) begin
					collisions[0] <= 1'd1; // 0 for ai && player
				end
				if(ai_car_truck!= MASK_VALUE) begin
					collisions[0] <= 1'd1; // 0 for ai && player
				end		
				if(fl_color!= MASK_VALUE) begin
					collisions[1] <= 1'd1;
				end
			end
		end
	end
end 


endmodule