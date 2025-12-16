module top (input logic clk, reset,
            output logic [31:0] WriteData, DataAdr,
            output logic MemWrite);

    logic [31:0] PC, Instr, ReadData;
    
    logic [31:0] config_reg_out;
    logic [31:0] status_reg_in;
    
    riscvsingle rvsingle(clk,reset,PC, Instr, MemWrite,DataAdr,WriteData,ReadData);

    instructionMemory imem(PC, Instr);
    
    dataMemory dmem (
        .clk(clk), 
        .we(MemWrite),
        .a(DataAdr),
        .wd(WriteData), 
        .rd(ReadData),
        .config_data(config_reg_out),
        .status_data(status_reg_in)
    );

    peripheral fsm_controller (
        .clk(clk), 
        .reset(reset),
        .config_data(config_reg_out),
        .status_data(status_reg_in),
        .irrigation_active(),
        .ventilation_active()
    );
    
endmodule