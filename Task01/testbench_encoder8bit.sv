module testbench_encoder8bit();
    logic [7:0] in;
    logic [2:0] index;
    logic       multiple;

    encoder_8bit dut(
        .in(in),
        .index(index),
        .multiple(multiple)
    );

    initial begin
      
        in = 8'b00000000; #10;
        assert(index == 3'd0 && multiple == 1'b0) else $error("00000000 failed");

       
        in = 8'b00000001; #10;
        assert(index == 3'd0 && multiple == 1'b0) else $error("00000001 failed");

        in = 8'b00000010; #10;
        assert(index == 3'd1 && multiple == 1'b0) else $error("00000010 failed");

        in = 8'b00000011; #10;
        assert(index == 3'd1 && multiple == 1'b1) else $error("00000011 failed");


        in = 8'b00000100; #10;
        assert(index == 3'd2 && multiple == 1'b0) else $error("00000100 failed");


        in = 8'b00001100; #10;
        assert(index == 3'd3 && multiple == 1'b1) else $error("00001100 failed");

        in = 8'b10000000; #10;
        assert(index == 3'd7 && multiple == 1'b0) else $error("10000000 failed");

        in = 8'b11000000; #10;
        assert(index == 3'd7 && multiple == 1'b1) else $error("11000000 failed");

        in = 8'b11111111; #10;
        assert(index == 3'd7 && multiple == 1'b1) else $error("11111111 failed");

        $stop;
    end
endmodule