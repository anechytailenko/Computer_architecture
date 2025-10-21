module testbench_mux_12_2bit;

    logic [1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11;
    logic [3:0] sel;
    logic [1:0] out;

    mux_12_2bit dut (
        .in0(in0),   .in1(in1),   .in2(in2),   .in3(in3),
        .in4(in4),   .in5(in5),   .in6(in6),   .in7(in7),
        .in8(in8),   .in9(in9),   .in10(in10), .in11(in11),
        .sel(sel),
        .out(out)
    );

    initial begin
 
        in0 = 2'b00; in1 = 2'b01; in2 = 2'b10; in3 = 2'b11;
        in4 = 2'b00; in5 = 2'b01; in6 = 2'b10; in7 = 2'b11;
        in8 = 2'b00; in9 = 2'b01; in10 = 2'b10; in11 = 2'b11;

        sel = 4'd0; #10; assert(out == in0)   else $error("sel=0 failed.");
        sel = 4'd1; #10; assert(out == in1)   else $error("sel=1 failed.");
        sel = 4'd5; #10; assert(out == in5)   else $error("sel=5 failed.");
        sel = 4'd11; #10; assert(out == in11) else $error("sel=11 failed.");

        sel = 4'd12; #10; assert(out == 2'b11) else $error("sel=12 failed.");
        sel = 4'd13; #10; assert(out == 2'b11) else $error("sel=13 failed.");
        sel = 4'd15; #10; assert(out == 2'b11) else $error("sel=15 failed.");

        $stop;
    end

endmodule
