module testbench_majority7();
    logic [6:0] in;
    logic       y;

    majority7 dut (
        .in(in),
        .y(y)
    );

    initial begin

        in = 7'b0000000; #10;
        assert (y == 0) else $error("Test 1 failed: in=%b, y=%b", in, y);

        in = 7'b0000001; #10;
        assert (y == 0) else $error("Test 2 failed: in=%b, y=%b", in, y);

        in = 7'b0000011; #10;
        assert (y == 0) else $error("Test 3 failed: in=%b, y=%b", in, y);

        in = 7'b0000111; #10;
        assert (y == 0) else $error("Test 4 failed: in=%b, y=%b", in, y);

        in = 7'b0001111; #10;
        assert (y == 1) else $error("Test 5 failed: in=%b, y=%b", in, y);

        in = 7'b0011111; #10;
        assert (y == 1) else $error("Test 6 failed: in=%b, y=%b", in, y);

        in = 7'b0111111; #10;
        assert (y == 1) else $error("Test 7 failed: in=%b, y=%b", in, y);

        in = 7'b1111111; #10;
        assert (y == 1) else $error("Test 8 failed: in=%b, y=%b", in, y);

        in = 7'b0101010; #10;
        assert (y == 0) else $error("Test 9 failed: in=%b, y=%b", in, y);

        in = 7'b1011010; #10;
        assert (y == 1) else $error("Test 10 failed: in=%b, y=%b", in, y);

        $stop;
    end
endmodule
