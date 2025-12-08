module top (input logic clk, reset,
            output logic [31:0] WriteData, DataAdr,
            output logic [31:0] MemWrite);

    logic [31:0] PC, Instr, ReadData;

    riscvsingle rvsingle(clk,reset,PC, Instr, MemWrite,DataAdr,WriteData,ReadData);

    instructionMemory imem(PC, Instr);
    dataMemory dmem (clk, MemWrite,DataAdr,WriteData, ReadData);

    
endmodule    