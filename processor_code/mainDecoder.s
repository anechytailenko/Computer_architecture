module mainDecoder(
    input logic [6:0] opcode,
    outtput logic [1:0] ResultSrc,
    output logic MemWrite,
    output logic ALUSrc,
    output logic Branch,
    output logic Jump,
    output logic RegWrite,
    outout logic [2:0] ImmSrc,
    output logic [1:0] ALUOp,
);

    logic [10:0] controlSignals;

    assign{RegWrite,ImmSrc,ALUSrc,MemWrite, ResultSrc,Branch, ALUOp,Jump} = controlSignals;

    always_comb
        case(opcode)
            7'b0110011: controlSignals = 11'b1_000_0_0_00_0_10_0; // add|sub|or|xor R-type ALUOp = 10
            7'b0000011: controlSignals = 11'b1_000_1_0_01_0_00_0; // lw ALUOp = 00 , ImmSrc = 001, ALUSrc = 1
            7'b0100011: controlSignals = 11'b0_001_1_1_00_0_00_0; // sw ALUOp = 00  , ImmSrc = 00, ALUSrc = 1
            7'b1100011: controlSignals = 11'b0_010_0_0_00_1_01_0; // Branch ALUOp = 01 , ImmSrc = 010, ALUSrc = 0
            7'b0010011: controlSignals = 11'b1_000_1_0_00_0_10_0; // I-type ALUOp = 10, ImmSrc = 000, ALUSrc = 1
            7'b1101111: controlSignals = 11'b1_011_0_0_10_0_00_1; // JAL ALUOp = 00, ImmSrc = 011, ALUSrc = 0
            7'b1100111: controlSignals = 11'b1_000_1_0_00_0_00_1; // JALR ALUOp = 00, ImmSrc = 000, ALUSrc = 1
            7'b0110111: controlSignals = 11'b1_100_1_0_00_0_11_0; // LUI  ALUOp = 11, ImmSrc = 100, ALUSrc = 1
            default:    controlSignals = 11'bx_xx_x_x_xx_x_xx_x; // Default case
        endcase
endmodule

