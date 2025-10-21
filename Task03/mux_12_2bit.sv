module mux_12_2bit(
    input  logic [1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11,
    input  logic [3:0] sel,
    output logic [1:0] out
);

logic [1:0] inputs [0:11];

always_comb begin
	case (sel)
		4'd0:  out = in0;
      4'd1:  out = in1;
      4'd2:  out = in2;
      4'd3:  out = in3;
      4'd4:  out = in4;
      4'd5:  out = in5;
      4'd6:  out = in6;
      4'd7:  out = in7;
      4'd8:  out = in8;
      4'd9:  out = in9;
      4'd10: out = in10;
       4'd11: out = in11;
       default: out = 2'b11;  // when sel > 11
     endcase
end

endmodule