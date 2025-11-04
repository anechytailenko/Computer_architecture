module row_divider #(parameter N = 4) (
    input  logic [N-1:0] r_in,
    input  logic [N-1:0] b_in,
    output logic [N-1:0] r_out,
    output logic         n_flag
);

    logic [N-1:0] d;
    logic [N:0]   carry_array;
    assign carry_array[0] = 1'b1;

    genvar i;
    generate
        for (i = 0; i < N; i++) begin : gen_sub
            full_adder_1_bit fa (
                .a   (r_in[i]),
                .b   (~b_in[i]),
                .cin (carry_array[i]),
                .s (d[i]),
                .cout(carry_array[i+1])
            );
        end
    endgenerate

    assign n_flag = d[N-1];


    generate
        for (i = 0; i < N; i++) begin : gen_mux
            mux_2_1 m (
                .d0 (d[i]),
                .d1 (r_in[i]),
                .s (n_flag),
                .y (r_out[i])
            );
        end
    endgenerate

endmodule

