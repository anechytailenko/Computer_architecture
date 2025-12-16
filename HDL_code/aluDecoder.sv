module aluDecoder(
        input logic opb5,
        input logic [2:0] funct3,
        input logic func7b5,
        input logic [1:0] ALUOp,
        output logic [2:0] ALUControl
    );

    logic RtypeSub;
    assign RtypeSub = opb5 & func7b5;

    always_comb
        case(ALUOp)
            2'b00: ALUControl = 3'b000; // LW, SW, JALR, JAL -> ADD
            2'b01: ALUControl = 3'b001; // branch -> SUB
            2'b10: // R-type and I-type
                case(funct3)
                    3'b000: ALUControl = RtypeSub ? 3'b001 : 3'b000; // SUB or ADD/ADDI
                    3'b111: ALUControl = 3'b011; // AND
                    3'b110: ALUControl = 3'b100; // OR
                    3'b100: ALUControl = 3'b010; // XOR
                    3'b001: ALUControl = 3'b101; // SLLI
                    3'b101: ALUControl = 3'b110; // SRL
                    default: ALUControl = 3'bxxx; // Invalid
                endcase

            2'b11: ALUControl = 3'b111; // LUI -> Pass B    
            default: ALUControl = 3'bxxx; // Invalid
         endcase   

endmodule