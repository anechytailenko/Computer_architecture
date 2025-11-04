module ripple_carry_adder #(parameter width = 32)(
				 input logic[width -1: 0]    a,b,
				 input logic                 cin, isSub,
				 output logic                cout,
				 output logic[width -1: 0]   sum);
				 
	logic [width:0] carry_array;
	logic [width -1: 0] b_actual;
	
	assign carry_array[0] = cin;
	assign cout  = carry_array[width];
	assign b_actual = isSub ? ~b : b;
	
	genvar i;
	generate 
		for (i = 0; i < width; i++ ) begin: fa_chain
			full_adder_1_bit fa_inst (
				.a(a[i]),
				.b(b_actual[i]),
				.cin(carry_array[i]),
				.s(sum[i]),
				.cout(carry_array[i+1])
			);
		end
	endgenerate
endmodule