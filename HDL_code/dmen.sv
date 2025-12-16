module dmem(
    input  logic        clk, we,
    input  logic [31:0] a, wd,
    output logic [31:0] rd
);
    logic [31:0] RAM[63:0];
    
    // Initialize data memory to 0
    initial begin
        for (int i = 0; i < 64; i = i + 1)
            RAM[i] = 32'b0;
    end
    
    assign rd = RAM[a[31:2]]; // word aligned
    
    always_ff @(posedge clk)
        if (we) RAM[a[31:2]] <= wd;
endmodule