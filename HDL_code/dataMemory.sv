module dataMemory(
    input logic clk, we,
    input logic [31:0] a, wd,
	 input logic [31:0] status_data,
    output logic [31:0] rd,
    output logic [31:0] config_data
);

    logic [31:0] RAM[2047:0];

    localparam CONTROL_ADDR = 32'hF0000000; // const is from my assembly code
    localparam STATUS_ADDR = 32'hF0000004;  // const s from my assembly code
    
    always_comb begin
        if (a == STATUS_ADDR) begin
            rd = status_data;
        end else begin
            rd = RAM[a[12:2]];
        end
    end
    

    logic [31:0] control_reg = 32'h0;
    
    assign config_data = control_reg;

    always_ff @(posedge clk) begin
        if (we) begin
            if (a == CONTROL_ADDR) begin
                control_reg <= wd;
            end 
            else  begin
                RAM[a[12:2]] <= wd;
            end
        end
    end
    
endmodule