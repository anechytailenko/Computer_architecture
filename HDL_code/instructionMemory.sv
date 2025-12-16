module instructionMemory(input logic [31:0] a,
            output logic [31:0] rd);
    
    logic [31:0] RAM[1023:0];
    initial
        $readmemh("/home/user/Desktop/Labs/Lab08/riscvtext.txt",RAM);
    assign rd = RAM[a[31:2]];

endmodule