
module simple_Score_counter 
	(
   input logic clk, 
   input logic resetN,
	input logic frame_start,
	input logic has_been_hit,
	input logic exploded_on_sides,
	input logic picked_up_boost, 
   output logic Score [15:0]  // counter output matches digits on score Display.
   );
	
	parameter smallboost = 4'd1;
	parameter mediumboost = 4'd5;
	parameter bigboost = 4'd10;
	
   logic [15:0] counter = 0;
   logic [3:0] score_0 = 0;
   logic [3:0] score_1 = 0;
   logic [3:0] score_2 = 0;
   logic [3:0] score_3 = 0;
	
   always_ff@(posedge clk or negedge resetN)
   begin
	if(!resetN)  // Asynchronic reset
	begin 
		counter <= 0;
      score_0 <= 0;
      score_1 <= 0;
      score_2 <= 0;
      score_3 <= 0;
	end    

   else begin			// Synchronic logic	
	 //this logic assumes only one can be true at a time.
	  if (has_been_hit || exploded_on_sides || picked_up_boost) 
	  begin
            counter <= counter + (has_been_hit * smallboost) +
                       (exploded_on_sides * mediumboost) +
                       (picked_up_boost * bigboost);
     end

         score_0 <= counter % 10;
         score_1 <= (counter / 10) % 10;
         score_2 <= (counter / 100) % 10;
         score_3 <= (counter / 1000) % 10;
      end
   end
	assign Score = {score_3, score_2, score_1, score_0};
	 
endmodule
