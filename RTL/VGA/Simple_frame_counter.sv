module Simple_frame_counter       	
	(
   // Input, Output Ports
	input  logic clk, 
	input  logic resetN, 
	input  logic startOfFrame,
	output logic  [0:3][0:3] num
   );
	
	

always_ff @(posedge clk or negedge resetN)
begin 
	if(!resetN)  
		num <=16'b0;
	//num 0 to 4 represents a 4 digit decimal number.
	else if (startOfFrame) begin 
		for (int i=0; i<4; i++) begin 
				if (num[i]<9) begin
					num[i] <= num[i]+4'b0001;
					break;
				end
				else if (num[i]==9 && i<3) begin
					num[i]<=0; 
					if (num[i+1] < 9) begin
						num[i+1] <= num[i+1]+4'b0001;
						break;
					end
				end
				if(i==3 && num[i]==9)  
					num<=16'b0;
		end 
	end 

end


endmodule