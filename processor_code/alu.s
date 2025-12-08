module alu(input logic [31:0] a, b,
           input logic [2:0] alucontrol,
           output logic [31:0] aluresult,
           output logic zero,lt, ge); 
    

    
    always_comb
        case(alucontrol)
            // Arithmetic operations
            4'b000: result = a + b;               // ADD/ADDI
            4'b001: result = a - b;               // SUB
            
            // Logical operations
            4'b010: result = a ^ b;               // XOR/XORI
            4'b011: result = a & b;               // AND/ANDI
            4'b011: result = a | b;               // OR/ORI
            
            // Shift operations
            4'b100: result = a << b[4:0];         // SLLI (logical left shift)
            4'b101: result = a >> b[4:0];         // SRL (logical right shift)

            // lui
            4'b110: result = b;                    // LUI
            
            default: result = 32'b0;               // Default to zero
        endcase
    
    // BEQ flag
    assign zero = (result == 0);
    
    // BLT flag
    assign lt = (result < 0);

    // BGE flag
    assign ge = (result >= 0);
    
endmodule