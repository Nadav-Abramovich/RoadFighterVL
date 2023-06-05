

//this module supports pre coded messages (short words etc.)
//and can also "print" changing numbers into predetermined coordinates in the screen.
module	messageboard	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input		logic	frame_start,
					input    logic [0:10] requested_x,
					input    logic [0:10] requested_y,
					input 	logic [13:0] fuel_val,
					input 	logic [13:0] score_val,
					input    logic [0:9] player_speed,
					input		int 	distance_drove,
					output   logic [0:4][0:10] new_state,
					output   logic [7:0] output_color,
					output 	logic [15:0] seg_7
);
`include "chars.txt"

typedef struct {
	logic [4:0][0:4] code;
	int x;
	int y;
	byte mult;
	int length;
} WORD;

typedef struct {
	logic [0:3][0:3] bcd;
	int x;
	int y;
	byte mult;
	int length;
} NUMBER;
















localparam logic[7:0] MASK_VALUE = 8'h62;
localparam logic[7:0] COLOR1 = 8'h88;
localparam logic[7:0] ARBTITRARYCOLOR = 8'h99;




//Declaration of words and numbers and their locations.
WORD fuel = '{{5'd5,5'd20,5'd4,5'd11},550,166,2,3};
NUMBER fuel_num = '{{4'b0,4'b0,4'b0,4'b0}, 550, 184, 2, 4};
WORD word_score = '{{5'd18,5'd2,5'd14,5'd17,5'd4},550,204,2,4};
NUMBER score_num = '{{4'b0,4'b0,4'b0,4'b0}, 550, 222, 2, 4};
WORD word_speed ='{{5'd18,5'd15,5'd4,5'd4,5'd3}, 550 , 242, 2, 4};
NUMBER speed_num = '{{4'b0,4'b0,4'b0,4'b0}, 550, 260, 2, 4};
WORD word_distance  = '{{5'd3,5'd8,5'd18,5'd19},550,280,2, 3};
NUMBER distance_num = '{{4'b0,4'b0,4'b0,4'b0}, 550, 298, 2, 4};

WORD word_arie = '{{5'd0,5'd17,5'd8,5'd4},550,10,1,3};
WORD word_nadav = '{{5'd13,5'd0,5'd3,5'd0,5'd21},550,20,1,4};

//NUMBER fuel_gauge = '{fuel_gauge[7:0],550,185,2,127}; temp, add fuel_gauge later
//NUMBER fuel_gauge = '{42,550,185,2,64};
reg [15:0] bcd_score_reg;
reg [15:0] bcd_fuel_reg;
reg [15:0] bcd_speed_reg;
reg [15:0] bcd_distance_reg;

//score conversion to BCD
always @(score_val) begin
    bcd_score_reg=0;		 	
    for (int i=0;i<14;i=i+1) begin																			//Iterate once for each bit in input number
        if (bcd_score_reg[3:0] >= 5) bcd_score_reg[3:0] = bcd_score_reg[3:0] + 3;		//If any BCD digit is >= 5, add three
	if (bcd_score_reg[7:4] >= 5) bcd_score_reg[7:4] = bcd_score_reg[7:4] + 3;
	if (bcd_score_reg[11:8] >= 5) bcd_score_reg[11:8] = bcd_score_reg[11:8] + 3;
	if (bcd_score_reg[15:12] >= 5) bcd_score_reg[15:12] = bcd_score_reg[15:12] + 3;
	bcd_score_reg = {bcd_score_reg[14:0],score_val[13-i]};						//Shift one bit, and shift in proper bit from input 
    end
end





always @(fuel_val) begin
    bcd_fuel_reg=0;		 	
    for (int i=0;i<14;i=i+1) begin					//Iterate once for each bit in input number
        if (bcd_fuel_reg[3:0] >= 5) bcd_fuel_reg[3:0] = bcd_fuel_reg[3:0] + 3;		//If any BCD digit is >= 5, add three
	if (bcd_fuel_reg[7:4] >= 5) bcd_fuel_reg[7:4] = bcd_fuel_reg[7:4] + 3;
	if (bcd_fuel_reg[11:8] >= 5) bcd_fuel_reg[11:8] = bcd_fuel_reg[11:8] + 3;
	if (bcd_fuel_reg[15:12] >= 5) bcd_fuel_reg[15:12] = bcd_fuel_reg[15:12] + 3;
	bcd_fuel_reg = {bcd_fuel_reg[14:0],fuel_val[13-i]};				//Shift one bit, and shift in proper bit from input 
    end
end


logic [13:0] speed_val_fix;
always @(player_speed) begin
	
	 speed_val_fix = (({4'b0,player_speed}*200)/513); // can be optimized later 
    bcd_speed_reg=0;		 	
    for (int i=0;i<14;i=i+1) begin					//Iterate once for each bit in input number
        if (bcd_speed_reg[3:0] >= 5) bcd_speed_reg[3:0] = bcd_speed_reg[3:0] + 3;		//If any BCD digit is >= 5, add three
	if (bcd_speed_reg[7:4] >= 5) bcd_speed_reg[7:4] = bcd_speed_reg[7:4] + 3;
	if (bcd_speed_reg[11:8] >= 5) bcd_speed_reg[11:8] = bcd_speed_reg[11:8] + 3;
	if (bcd_speed_reg[15:12] >= 5) bcd_speed_reg[15:12] = bcd_speed_reg[15:12] + 3;
	bcd_speed_reg = {bcd_speed_reg[14:0],speed_val_fix[13-i]};				//Shift one bit, and shift in proper bit from input 
    end
end

logic [13:0] distnace_fix;
int temp;
always @(distance_drove) begin
	 temp = distance_drove/16;
	 distnace_fix = {temp[13:0]}/4; // can be optimized later 
    bcd_distance_reg=0;		 	
    for (int i=0;i<14;i=i+1) begin					//Iterate once for each bit in input number
        if (bcd_distance_reg[3:0] >= 5) bcd_distance_reg[3:0] = bcd_distance_reg[3:0] + 3;		//If any BCD digit is >= 5, add three
	if (bcd_distance_reg[7:4] >= 5) bcd_distance_reg[7:4] = bcd_distance_reg[7:4] + 3;
	if (bcd_distance_reg[11:8] >= 5) bcd_distance_reg[11:8] = bcd_distance_reg[11:8] + 3;
	if (bcd_distance_reg[15:12] >= 5) bcd_distance_reg[15:12] = bcd_distance_reg[15:12] + 3;
	bcd_distance_reg = {bcd_distance_reg[14:0],distnace_fix[13-i]};				//Shift one bit, and shift in proper bit from input 
    end
end


int i=0;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		output_color <= 0;
	end 
	else begin
		/*if(((requested_y > 200)&&(requested_y < 200+20))&&(fuel_gauge.x<requested_x)&& ((fuel_gauge.x+fuel_gauge.val)>requested_x))  begin
				output_color <= COLOR1;
		end*/ //Buggy code, review later.
		
		
		
		//fuel and value
		
		for(int i=0; i<4; i++) begin
			if 	((fuel.y<= requested_y) 
				&& ((fuel.y+8*fuel.mult) > requested_y) 
				&& ((fuel.x +i*8*fuel.mult) <= requested_x) 
				&& ((fuel.x+8*fuel.mult+i*8*fuel.mult) > requested_x )) begin
					output_color <= letters[fuel.code[fuel.length-i]][(requested_y-fuel.y)/fuel.mult][(requested_x-fuel.x-(i*8*fuel.mult))/fuel.mult];
				end
		end
		
		fuel_num.bcd <= {bcd_fuel_reg[15:12],bcd_fuel_reg[11:8],bcd_fuel_reg[7:4],bcd_fuel_reg[3:0]};
		seg_7<=fuel_num.bcd;
		for(int i=0; i<4; i++) begin
			if 	((fuel_num.y<= requested_y) 
				&& ((fuel_num.y+8*fuel_num.mult) > requested_y) 
				&& ((fuel_num.x +i*8*fuel_num.mult) <= requested_x) 
				&& ((fuel_num.x+8*fuel_num.mult+i*8*fuel_num.mult) > requested_x )) begin
				output_color <= nums[fuel_num.bcd[i]][(requested_y-fuel_num.y)/fuel_num.mult][(requested_x-fuel_num.x-(i*8*fuel_num.mult))/fuel_num.mult];
				end
		end
		
		for(int i=0; i<5; i++) begin
			if 	((word_score.y<= requested_y) 
				&& ((word_score.y+8*word_score.mult) > requested_y) 
				&& ((word_score.x +i*8*word_score.mult) <= requested_x) 
				&& ((word_score.x+8*word_score.mult+i*8*word_score.mult) > requested_x )) begin
					output_color <= letters[word_score.code[word_score.length-i]][(requested_y-word_score.y)/word_score.mult][(requested_x-word_score.x-(i*8*word_score.mult))/word_score.mult];
				end
		end
		
		//score and value
		score_num.bcd <= {bcd_score_reg[15:12],bcd_score_reg[11:8],bcd_score_reg[7:4],bcd_score_reg[3:0]};
		for(int i=0; i<4; i++) begin
			if 	((score_num.y<= requested_y) 
				&& ((score_num.y+8*score_num.mult) > requested_y) 
				&& ((score_num.x +i*8*score_num.mult) <= requested_x) 
				&& ((score_num.x+8*score_num.mult+i*8*score_num.mult) > requested_x )) begin
				output_color <= nums[score_num.bcd[i]][(requested_y-score_num.y)/score_num.mult][(requested_x-score_num.x-(i*8*score_num.mult))/score_num.mult];
				end
		end
		
		
		
		//speed and value
		for(int i=0; i<5; i++) begin
			if 	((word_speed.y <= requested_y) 
				&& ((word_speed.y+8*word_speed.mult) > requested_y) 
				&& ((word_speed.x +i*8*word_speed.mult) <= requested_x) 
				&& ((word_speed.x+8*word_speed.mult+i*8*word_speed.mult) > requested_x )) begin
					output_color <= letters[word_speed.code[word_speed.length-i]][(requested_y-word_speed.y)/word_speed.mult][(requested_x-word_speed.x-(i*8*word_speed.mult))/word_speed.mult];
				end
		end
		
		speed_num.bcd <= {bcd_speed_reg[15:12],bcd_speed_reg[11:8],bcd_speed_reg[7:4],bcd_speed_reg[3:0]};
		for(int i=0; i<4; i++) begin
			if 	((speed_num.y<= requested_y) 
				&& ((speed_num.y+8*speed_num.mult) > requested_y) 
				&& ((speed_num.x +i*8*speed_num.mult) <= requested_x) 
				&& ((speed_num.x+8*speed_num.mult+i*8*speed_num.mult) > requested_x )) begin
				output_color <= nums[speed_num.bcd[i]][(requested_y-speed_num.y)/speed_num.mult][(requested_x-speed_num.x-(i*8*speed_num.mult))/speed_num.mult];
				end
		end
		
		
		//distance and value
		for(int i=0; i<4; i++) begin
			if 	((word_distance.y<= requested_y) 
				&& ((word_distance.y+8*word_distance.mult) > requested_y) 
				&& ((word_distance.x +i*8*word_distance.mult) <= requested_x) 
				&& ((word_distance.x+8*word_distance.mult+i*8*word_distance.mult) > requested_x )) begin
					output_color <= letters[word_distance.code[word_distance.length-i]][(requested_y-word_distance.y)/word_distance.mult][(requested_x-word_distance.x-(i*8*word_distance.mult))/word_distance.mult];
				end
				//buggy
		end
		
		distance_num.bcd <= {bcd_distance_reg[15:12],bcd_distance_reg[11:8],bcd_distance_reg[7:4],bcd_distance_reg[3:0]};
		for(int i=0; i<4; i++) begin
			if 	((distance_num.y<= requested_y) 
				&& ((distance_num.y+8*distance_num.mult) > requested_y) 
				&& ((distance_num.x +i*8*distance_num.mult) <= requested_x) 
				&& ((distance_num.x+8*distance_num.mult+i*8*distance_num.mult) > requested_x )) begin
				output_color <= nums[distance_num.bcd[i]][(requested_y-distance_num.y)/distance_num.mult][(requested_x-distance_num.x-(i*8*distance_num.mult))/distance_num.mult];
				end
		end
		
		
		for(int i=0; i<4; i++) begin
			if 	((word_arie.y<= requested_y) 
				&& ((word_arie.y+8*word_arie.mult) > requested_y) 
				&& ((word_arie.x +i*8*word_arie.mult) <= requested_x) 
				&& ((word_arie.x+8*word_arie.mult+i*8*word_arie.mult) > requested_x )) begin
					output_color <= letters[word_arie.code[word_arie.length-i]][(requested_y-word_arie.y)/word_arie.mult][(requested_x-word_arie.x-(i*8*word_arie.mult))/word_arie.mult];
				end
		end
		
		for(int i=0; i<5; i++) begin
			if 	((word_nadav.y<= requested_y) 
				&& ((word_nadav.y+8*word_nadav.mult) > requested_y) 
				&& ((word_nadav.x +i*8*word_nadav.mult) <= requested_x) 
				&& ((word_nadav.x+8*word_nadav.mult+i*8*word_nadav.mult) > requested_x )) begin
					output_color <= letters[word_nadav.code[word_nadav.length-i]][(requested_y-word_nadav.y)/word_nadav.mult][(requested_x-word_nadav.x-(i*8*word_nadav.mult))/word_nadav.mult];
				end
		end
		/* //Idealy i'd use a command like the one below to print out all these... 
		`define print(x,y,height,width,mult,len,arr) \ 
		for(int i=0; i<len; i++) begin \
			if 	((y<= requested_y)  \
				&& ((y+8*mult) > requested_y) \
				&& ((x +i*8*word_nadav.mult) <= requested_x) \
				&& ((x+8*mult+i*8*mult) > requested_x )) begin \
					output_color <= letters[arr[len-i]][(requested_y-y)/mult][(requested_x-x-(i*8*mult))/mult]; \
				end \
		end
		*/

		
		
		
		
		
		seg_7<=fuel_num.bcd;
	end
end
endmodule