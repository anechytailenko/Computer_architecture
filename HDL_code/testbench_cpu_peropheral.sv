module testbench_cpu_peropheral;

    logic clk;
    logic reset;
    logic [31:0] WriteData, DataAdr;
    logic MemWrite;

    top dut (
        .clk(clk),
        .reset(reset),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer cycles_completed = 0;

    initial begin
        reset = 1;
        #20;
        reset = 0;
        $display("--- Start Simulation ---");

        #500000; 
        $display("Timeout");
        $stop;
    end

    
    always @(posedge dut.fsm_controller.status_data[0]) begin
        cycles_completed++;
        $display("[%0t ns] Cycle %0d completed)", $time, cycles_completed);
        // by logic of program 6 cycles should be completed because each of 3 config runs 2 times 
        if (cycles_completed == 6) begin
            $display("--- SUCCESS: All 6 cycles completed successfully");
            $finish;
        end
    end

endmodule