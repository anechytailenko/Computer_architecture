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

module adder_4bit(
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       cin,
    output logic [3:0] sum
);
    logic [4:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : ADD_STAGE
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

module accumulator_8bit(
    input  logic [7:0] in,
    output logic [3:0] sum
);
    
    logic [3:0] sums [0:8];

    assign sums[0] = 4'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i++) begin : ADD_LOOP
            adder_4bit add_inst (
                .a(sums[i]),
                .b({3'b0, in[i]}),
                .cin(1'b0),
                .sum(sums[i+1])
            );
        end
    endgenerate

    assign sum = sums[8];
endmodule



module encoder_8bit(
    input  logic [7:0] in,
    output logic [2:0] index,
    output logic       multiple
);
    logic [3:0] bit_count;
    logic [3:0] diff;


    accumulator_8bit acc (
        .in(in),
        .sum(bit_count)
    );

    
    adder_4bit sub1 (
        .a(bit_count),
        .b(4'b1111),
        .cin(1'b1),
        .sum(diff)
    );


    assign multiple = ~diff[3];

    always_comb begin
        casez(in)
            8'b1???????: index = 3'd7;
            8'b01??????: index = 3'd6;
            8'b001?????: index = 3'd5;
            8'b0001????: index = 3'd4;
            8'b00001???: index = 3'd3;
            8'b000001??: index = 3'd2;
            8'b0000001?: index = 3'd1;
            8'b00000001: index = 3'd0;
            default:     index = 3'd0;
        endcase
    end
endmodule