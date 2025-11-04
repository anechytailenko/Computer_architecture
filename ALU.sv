module ALU (input logic[31:0] a, b ,
				input logic [2:0] sel,
				output logic      overflow_flag, carry_flag , negative_flag , zero_flag, 
				output logic[31:0] result );
	logic[31:0] slt_res, or_res, and_res, add_res, sub_res, sum;
	logic cin, cout, cout_add, cout_sub;
	
	ripple_carry_adder addition(
				.a(a),
				.b(b),
				.isSub(1'b0),
				.cin(1'b0),
				.cout(cout_add),
				.sum(add_res)
			);
			
	ripple_carry_adder subtraction(
				.a(a),
				.b(b),
				.isSub(1'b1),
				.cin(1'b1),
				.cout(cout_sub),
				.sum(sub_res)
			);
			
	mux_2_N #(.N(1)) mux_cout(cout_add, cout_sub, sel[0], cout);
	mux_2_N #(.N(32)) mux_sum(add_res, sub_res, sel[0], sum ); 
	mux_5_32 mux_res(and_res, or_res,add_res, sub_res,slt_res , sel, result);
		
		
	always_comb
		begin
			or_res = a | b;
			and_res = a & b;
			
			cin = sel[0];
			
			
			overflow_flag = (~( sel[0] ^ a[31] ^ b[31] )) & (sum[31] ^ a[31]) & (~sel[1]);
			carry_flag = (~sel[1]) & cout;
			
			slt_res = { 31'b0, overflow_flag ^ sum[31] };

			
			negative_flag = result[31];
			zero_flag = &(~result);
		end
endmodule	