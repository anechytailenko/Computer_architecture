module arithmeticControllerTestbench();
	logic clk,reset,ready,add_sub;
	logic[3:0] a,b;
	logic out_valid;
	logic[3:0] out_res;
	
	arithmeticController uut(
		.clk(clk),
		.reset(reset),
    	.ready(ready),
		.add_sub(add_sub),
		.a(a),
		.b(b),
		.out_valid(out_valid),
		.out_res(out_res)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		reset = 1; clk = 1; ready = 0; add_sub = 1; a = 4; b = 3; #10; // reset
		reset = 0; add_sub = 1; a = 4; b = 3;  #10; // reset = 0, ready = 0; currentState= INIT -> exxpected nextState = INIT, out_valid = 0, out_res = 0
		ready = 1; #10; // ready = 1, currentState = INIT -> expected nextState = RDY, out_valid = 0, out_res =0
		ready = 1; #10; // ready = 1, currentState = RDY -> expected nextState = ADD, out_valid = 0, out_res =0
		#10; // currentState = ADD -> expectedState = INIT, out_valid = 1, out_res = 7
		ready = 0; add_sub = 0; #10; // currentState = INIT -> expectedState =INIT; out_valid = 0, out_res= 0
		ready = 1; #10; // ready = 1, currentState = INIT -> expected nextState = RDY, out_valid = 0, out_res =0
		#10; // ready = 1, currentState = RDY -> expected nextState = SUB, out_valid = 0, out_res =0
		#10; // currentState = SUB -> expectedState = INIT, out_valid = 1, out_res = 1
		ready = 0; #10; // currentState= INIT -> exxpected nextState = INIT, out_valid = 0, out_res = 0
		
	end
endmodule	