
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller_all	(	
			input	logic	clk,
			input	logic	resetN,
			input [0:10] bin,
			input	logic	startOfFrame, // short pulse every start of frame 30Hz 
			output int distance_drove, // critical code, generating A single pulse in a frame 
			output int bcd 			  // critical code, generating A single pulse in a frame 
);

int distance = 0;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		distance_drove <= 0;
	end 
	else begin 
		distance <= distance + 1;
		distance_drove <= distance;		
	end
end

integer i;
always @(bin) begin
bcd=0;		 	
for (i=0;i<9;i=i+1) begin					//Iterate once for each bit in input number
   if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;		//If any BCD digit is >= 5, add three
	if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
	if (bcd[10:8] >= 5) bcd[10:8] = bcd[10:8] + 3;
		bcd = {bcd[9:0],bin[8-i]};				//Shift one bit, and shift in proper bit from input 
   end
end

endmodule
