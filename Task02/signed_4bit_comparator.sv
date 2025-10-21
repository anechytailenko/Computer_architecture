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


module signed_4bit_comparator (
    input  logic signed [3:0] a,
    input  logic signed [3:0] b,
    output logic a_gt_b,
    output logic a_eq_b,
    output logic a_lt_b
);

    logic [3:0] b_neg;
    logic [3:0] sum;
    logic carry0, carry1, carry2, carry3;

    assign b_neg = ~b;

    full_adder fa0 (.a(a[0]), .b(b_neg[0]), .cin(1'b1), .sum(sum[0]), .cout(carry0));
    full_adder fa1 (.a(a[1]), .b(b_neg[1]), .cin(carry0), .sum(sum[1]), .cout(carry1));
    full_adder fa2 (.a(a[2]), .b(b_neg[2]), .cin(carry1), .sum(sum[2]), .cout(carry2));
    full_adder fa3 (.a(a[3]), .b(b_neg[3]), .cin(carry2), .sum(sum[3]), .cout(carry3));

    assign a_eq_b = (sum[0] == 0 & sum[1] == 0 & sum[2] == 0 & sum[3] == 0);

    assign a_gt_b = ~a_eq_b & (sum[3] == 0);
    assign a_lt_b = ~a_eq_b & (sum[3] == 1);

endmodule