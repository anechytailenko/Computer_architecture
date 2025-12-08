module controller(input logic [6:0] op,
                  input logic [2:0] funct3,
                  input logic funct7b5,
                  input logic Zero,Lt, Ge,
                  output logic [1:0] ResultSrc,
                  output logic MemWrite,
                  output logic [1:0] PCSrc, 
                  output logic ALUSrc,
                  output logic RegWrite, Jump,
                  output logic [1:0] ImmSrc,
                  output logic [2:0] ALUControl);

    logic [1:0] ALUOp;
    logic Branch;
    mainDecoder md(op, ResultSrc, MemWrite,   Branch,ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);
    aluDecoder  ad(op[5], funct3, funct7b5, ALUOp, ALUControl);
    
    // PCSrc logic
    always_comb
        case({Jump, Branch})
            2'b00: PCSrc = 2'b00; // next sequential instruction
            2'b10: PCSrc = 2'b01; // jumpTarget
            2'b01: // branch
                case(funct3)
                    3'b000: PCSrc = Zero ? 2'b10 : 2'b00; // BEQ
                    3'b100: PCSrc = Lt ? 2'b10 : 2'b00; // BLT
                    3'b101: PCSrc = Ge ? 2'b10 : 2'b00; // BGE
                    default: PCSrc = 2'bxx; // invalid
                endcase
            default: PCSrc = 2'bxx; // invalid    
        endcase

endmodule