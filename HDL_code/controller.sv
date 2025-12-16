module controller(input logic [6:0] op,
                  input logic [2:0] funct3,
                  input logic funct7b5,
                  input logic Zero,Lt, Ge,
                  output logic [1:0] ResultSrc,
                  output logic MemWrite,
                  output logic [1:0] PCSrc, 
                  output logic ALUSrc,
                  output logic RegWrite, Jump,
                  output logic [2:0] ImmSrc,
                  output logic [2:0] ALUControl);

    logic [1:0] ALUOp;
    logic Branch;


    mainDecoder md(
        .opcode(op),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp)
    );

    aluDecoder ad(op[5], funct3, funct7b5, ALUOp, ALUControl);


    // PCSrc logic
    always_comb
        case({Jump, Branch})
            2'b00: PCSrc = 2'b00; // Next instruction (PC+4)
            
            // Jumps
            2'b10: begin
                if (op[3]) PCSrc = 2'b01; // JAL
                else       PCSrc = 2'b10; // JALR
            end

            // Branches
            2'b01: 
                case(funct3)
                    3'b000: PCSrc = Zero ? 2'b01 : 2'b00; // BEQ
                    3'b100: PCSrc = Lt   ? 2'b01 : 2'b00; // BLT
                    3'b101: PCSrc = Ge   ? 2'b01 : 2'b00; // BGE
                    default: PCSrc = 2'b00; 
                endcase
                
            default: PCSrc = 2'b00;   
        endcase

endmodule
