//not used yet

//Idealy i'd use a command like the one below to print out all these... 
		/*`define print(x,y,height,width,word, mult,len,arr) \ 
			for(int i=0; i<len; i++) begin \
				if 	((y<= requested_y)  \
					&& ((y+8*mult) > requested_y) \
					&& ((x +i*8*mult) <= requested_x) \
					&& ((x+8*mult+i*8*mult) > requested_x )) begin \
					output_color <= letters[arr[len-i]][(requested_y-y)/mult][(requested_x-x-(i*8*mult))/mult]; \
					end \
			end	*/
			
			
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

task print(int x, int y, int height, int width, int mult, int len, WORD arr);
    int i;
    for (i = 0; i < len; i++) begin
        if (y <= requested_y &&
            (y + 8 * mult) > requested_y &&
            (x + i * 8 * mult) <= requested_x &&
            (x + 8 * mult + i * 8 * mult) > requested_x) begin
            output_color <= letters[arr[len - i]][(requested_y - y) / mult][(requested_x - x - (i * 8 * mult)) / mult];
        end
    end
endtask