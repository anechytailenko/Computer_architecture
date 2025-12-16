module aludec(
    input  logic        opb5,
    input  logic [2:0]  funct3,
    input  logic        funct7b5,
    input  logic [1:0]  ALUOp,
    output logic [2:0]  ALUControl
);
    logic RtypeSub, RtypeSra;
    
    assign RtypeSub = funct7b5 & opb5;  // TRUE for R-type subtract (funct7[5]=1 for sub)
    assign RtypeSra = funct7b5 & (funct3 == 3'b101);  // TRUE for sra (funct7[5]=1)
    
    always_comb
        case(ALUOp)
            2'b00:  ALUControl = 3'b000;  // addition for loads/stores
            2'b01:  ALUControl = 3'b001;  // subtraction for branches
            
            // R-type or I-type ALU
            default: case(funct3)
                3'b000: if (RtypeSub)
                            ALUControl = 3'b001;  // sub
                        else
                            ALUControl = 3'b000;  // add, addi
                3'b001: ALUControl = 3'b110;      // sll, slli
                3'b010: ALUControl = 3'b101;      // slt, slti
                3'b011: ALUControl = 3'b101;      // sltu, sltiu (not used)
                3'b100: ALUControl = 3'b100;      // xor, xori
                3'b101: if (RtypeSra)
                            ALUControl = 3'b111;  // sra
                        else
                            ALUControl = 3'b111;  // srl, srli (using 111 for both)
                3'b110: ALUControl = 3'b011;      // or, ori
                3'b111: ALUControl = 3'b010;      // and, andi
                default: ALUControl = 3'bxxx;     // undefined
            endcase
        endcase
endmodule