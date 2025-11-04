module array_divider #(parameter N = 4) (
    input  logic [N-1:0] A,
    input  logic [N-1:0] B,
    output logic [N-1:0] Q,
    output logic [N-1:0] R
	);

    logic [N-1:0] R_stage [0:N];
   
    assign R_stage[0] = '0;

    genvar i;
    generate
        for (i = 0; i < N; i++) begin : gen_stage
		  
				logic [N-1:0] r_shifted;
				logic [N-1:0] r_next;
				logic n_flag_stage ;
				
            assign r_shifted = {R_stage[i][N-2:0], A[N-1-i]};
				
            row_divider #(.N(N)) row (
                .r_in  (r_shifted),
                .b_in  (B),
                .r_out (r_next),
                .n_flag(n_flag_stage)
            );
				
            assign Q[N-1-i] = ~n_flag_stage;
            assign R_stage[i+1] = r_next;
        end
    endgenerate

    assign R = R_stage[N];

endmodule
