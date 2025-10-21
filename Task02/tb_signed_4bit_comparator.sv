module tb_signed_4bit_comparator;

    logic signed [3:0] a, b;
    logic a_gt_b, a_eq_b, a_lt_b;

    signed_4bit_comparator dut (
        .a(a),
        .b(b),
        .a_gt_b(a_gt_b),
        .a_eq_b(a_eq_b),
        .a_lt_b(a_lt_b)
    );

    initial begin

        a = 4'sd3; b = 4'sd2; #10;
        assert (a_gt_b == 1 && a_eq_b == 0 && a_lt_b == 0) else $error("Test 3,2 failed");

        a =-4; b =-4; #10;
        assert (a_gt_b == 0 && a_eq_b == 1 && a_lt_b == 0) else $error("Test -4,-4 failed");

        a =-3; b = 1; #10;
        assert (a_gt_b == 0 && a_eq_b == 0 && a_lt_b == 1) else $error("Test -3,1 failed");

        a = 4'sd0; b = 4'sd0; #10;
        assert (a_gt_b == 0 && a_eq_b == 1 && a_lt_b == 0) else $error("Test 0,0 failed");

        a = 4'sd7; b = -8; #10;
        assert (a_gt_b == 1 && a_eq_b == 0 && a_lt_b == 0) else $error("Test 7,-8 failed");

        a =-8; b = 4'sd7; #10;
        assert (a_gt_b == 0 && a_eq_b == 0 && a_lt_b == 1) else $error("Test -8,7 failed");

        $stop;
    end

endmodule
