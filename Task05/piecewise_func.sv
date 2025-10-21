module full_adder(
    input  logic a, b, cin,
    output logic sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule


module adder_4bit(
    input  logic [3:0] a, b,
    input  logic cin,
    output logic [3:0] sum,
    output logic cout
);
    logic [4:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 4; i=i+1) begin : fa_gen
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[4];

endmodule


module adder_8bit(
    input  logic signed [7:0] a, b,
    output logic signed [7:0] sum
);
    logic [7:0] temp_sum;
    logic carry;
    logic carry_out;
    
    
    adder_4bit lower(a[3:0], b[3:0], 1'b0, temp_sum[3:0], carry);
    adder_4bit upper(a[7:4], b[7:4], carry, temp_sum[7:4], carry_out);

    assign sum = temp_sum;
endmodule

module multiply_4bit_fa(
    input  logic [3:0] a, b,
    output logic [7:0] product
);
    logic [7:0] partial_sum [4:0];
    logic [7:0] shifted [3:0];

    assign partial_sum[0] = 8'b0;

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : mult_gen
            assign shifted[i] = b[i] ? (a << i) : 8'b0;
            adder_8bit add_inst(
                .a(partial_sum[i]),
                .b(shifted[i]),
                .sum(partial_sum[i+1])
            );
        end
    endgenerate

    assign product = partial_sum[4];
endmodule


module mux2(
    input  logic [7:0] d0, d1,
    input  logic s,
    output logic [7:0] y
);
    assign y = s ? d1 : d0;
endmodule


module piecewise_func(
    input  logic signed [3:0] a, b,
    output logic signed [7:0] result
);
    logic [7:0] sum_result;
    logic [7:0] mul_result;
    logic select_mul;

    
	adder_8bit add_inst(
		.a({{4{a[3]}}, a}),
		.b({{4{b[3]}}, b}),
		.sum(sum_result)
	);


    multiply_4bit_fa mul_inst(
        .a(a),
        .b(b),
        .product(mul_result[7:0])
    );



    assign select_mul = (~a[3]) & (~b[3]);


    mux2 mux_inst(
        .d0(sum_result),
        .d1(mul_result),
        .s(select_mul),
        .y(result)
    );
endmodule
