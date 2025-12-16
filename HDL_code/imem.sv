module imem(
    input  logic [31:0] a,
    output logic [31:0] rd
);
    logic [31:0] RAM[63:0];
    
    initial begin
        // Initialize all memory to 0
        for (int i = 0; i < 64; i = i + 1)
            RAM[i] = 32'b0;
        // Load program from file
        $readmemh("riscvtest.txt", RAM);
    end
    
    assign rd = RAM[a[31:2]]; // word aligned
endmodule