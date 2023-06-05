module	collision_detector	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input    int requested_x,
					input    int requested_y,
					
					input    int top,
					input    int left,
					
					input    int width,
					input    int height,
					
				   output logic should_be_drawn
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			should_be_drawn <= 1'b0;
	end
	
	else begin
			should_be_drawn <= ((requested_x > left) & ((left+width-1) > requested_x)) & (((requested_y) > top) & ((top+height-1) > requested_y));
	end
end

endmodule
