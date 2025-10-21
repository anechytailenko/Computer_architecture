module testbench_piecewise_func();

    logic signed [3:0] a, b;
    logic signed [7:0] result;

    piecewise_func dut (
        .a(a),
        .b(b),
        .result(result)
    );

   
    function automatic signed [7:0] expected_result(
        input signed [3:0] a_in, b_in
    );
        if (a_in >= 0 && b_in >= 0)
            expected_result = a_in * b_in;
        else
            expected_result = a_in + b_in;
    endfunction

    initial begin

        a = -8; b = -8; #10;
        assert (result === expected_result(a, b))
            else $error("FAILED (-8, -8): got %0d expected %0d", result, expected_result(a,b));

        a = 7; b = 7; #10;
        assert (result === expected_result(a, b))
            else $error("FAILED (7, 7): got %0d expected %0d", result, expected_result(a,b));

        a = -8; b = 7; #10;
        assert (result === expected_result(a, b))
            else $error("FAILED (-8, 7): got %0d expected %0d", result, expected_result(a,b));

        a = 6; b = -4; #10;
        assert (result === expected_result(a, b))
            else $error("FAILED (6, -4): got %0d expected %0d", result, expected_result(a,b));

        a = 0; b = 5; #10;
        assert (result === expected_result(a, b))
            else $error("FAILED (0, 5): got %0d expected %0d", result, expected_result(a,b));

        a = 0; b = 0; #10;
        assert (result === expected_result(a, b))
            else $error("FAILED (0, 0): got %0d expected %0d", result, expected_result(a,b));

        a = -1; b = 3; #10;
        assert (result === expected_result(a, b))
            else $error("FAILED (-1, 3): got %0d expected %0d", result, expected_result(a,b));
        $stop;
    end
endmodule