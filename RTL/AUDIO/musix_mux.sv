
//not implemented yet
module musix_mux (
	input logic clk,
	input logic resetN,
	input logic bonus,
	input logic [0:1] collision,
	input logic win,
	input logic lose,
	input logic frame_start,
	
	output logic [3:0] stuff
	);
	
	
int count_collision;
parameter HALFSEC = 15;
always_ff @(posedge clk or negedge resetN) begin

	if (collision[0]) begin
		 count_collision <= HALFSEC;
	end 

	
	if(frame_start && (count_collision>0))
		 count_collision <= count_collision - 1;
	if (count_collision) 
		stuff <= 4'b0100;
	else  
		stuff <= 4'b0000;
		
		
		
	
end 
endmodule 