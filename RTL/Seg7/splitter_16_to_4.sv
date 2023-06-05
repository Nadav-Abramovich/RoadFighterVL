module splitter_16_to_4 (
	input logic [15:0] arr,
	
	output logic [3:0] arm_1,
	output logic [3:0] arm_2,
	output logic [3:0] arm_3,
	output logic [3:0] arm_4
);

always_comb
begin
		arm_1 = arr[3:0];
		arm_2 = arr[7:4];
		arm_3 = arr[11:8];
		arm_4 = arr[15:12];
end
endmodule

	
	