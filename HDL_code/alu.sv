module alu(input logic [31:0] a, b,
           input logic [2:0] alucontrol,
           output logic [31:0] aluresult,
           output logic zero,lt, ge); 
    

    
    always_comb
        case(alucontrol)
            // Arithmetic operations
            3'b000: aluresult = a + b;               // ADD/ADDI
            3'b001: aluresult = a - b;               // SUB
            
            // Logical operations
            3'b010: aluresult = a ^ b;               // XOR/XORI
            3'b011: aluresult = a & b;               // AND/ANDI
            3'b100: aluresult = a | b;               // OR/ORI
            
            // Shift operations
            3'b101: aluresult = a << b[4:0];         // SLLI (logical left shift)
            3'b110: aluresult = a >> b[4:0];         // SRL (logical right shift)

            // lui
            3'b111: aluresult = b;                    // LUI
            
            default: aluresult = 32'b0;               // Default to zero
        endcase
    
    // BEQ flag
    assign zero = (aluresult == 0);
    
    // BLT flag
    assign lt = $signed(aluresult) < 0;

    // BGE flag
    assign ge = $signed(aluresult) >= 0;
    
endmodule