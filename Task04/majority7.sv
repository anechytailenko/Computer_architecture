module full_adder(
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule



module adder #(
    parameter int WIDTH = 4
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic             cin,
    output logic [WIDTH-1:0] sum
);
    logic [WIDTH:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin : ADD_STAGE
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
endmodule


module accumulator #(
    parameter int N = 7,
    parameter int WIDTH = $clog2(N + 1)
)(
    input  logic [N-1:0] in,
    output logic [WIDTH-1:0] sum
);
    logic [WIDTH-1:0] sums [0:N];
    assign sums[0] = '0;

    genvar i;
    generate
        for (i = 0; i < N; i++) begin : ADD_LOOP
            adder #(.WIDTH(WIDTH)) add_inst (
                .a(sums[i]),
                .b({{(WIDTH-1){1'b0}}, in[i]}),
                .cin(1'b0),
                .sum(sums[i+1])
            );
        end
    endgenerate

    assign sum = sums[N];
endmodule



module majority7(
    input  logic [6:0] in,
    output logic y
);
    localparam int WIDTH = $clog2($bits(in) + 1);
    localparam logic [WIDTH-1:0] THRESHOLD = 4;
	 
    logic [WIDTH-1:0] total_sum;
    logic [WIDTH-1:0] diff;

    accumulator #(.N($bits(in))) acc_inst (
        .in(in),
        .sum(total_sum)
    );

    adder #(.WIDTH(WIDTH)) subtractor (
        .a(total_sum),
        .b(~THRESHOLD),
        .cin(1'b1),
        .sum(diff)
    );

    assign y = ~diff[WIDTH-1];
endmodule

