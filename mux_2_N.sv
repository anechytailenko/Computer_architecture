module mux_2_N #(parameter N = 32)
			( input logic [N-1 : 0] d0, d1, 
			input logic s, 
			output logic [N-1 : 0] y); 
always_comb 
	begin 
		y = s ? d1 : d0; 
	end 
endmodule