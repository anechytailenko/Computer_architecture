module mux_5_32 (
						input logic [31:0] d0,d1,d2,d3,d4,
						input logic [2:0] sel,
						output logic [31:0] y
);
	logic [31:0] t0,t1,t2;
	
	mux_2_N #(.N(32)) muxA (d2,d3,sel[0],t1);
	mux_2_N #(.N(32)) muxB (d0,d1, sel[0], t0);
	
	mux_2_N #(.N(32)) muxC (t1,t0, sel[1], t2);
	
	mux_2_N #(.N(32)) muxD (t2, d4 , sel[2], y );
endmodule	