module testbench();
    logic clk;
    logic reset;
    logic [31:0] WriteData, DataAdr;
    logic MemWrite;
    

    integer correct_writes = 0;


    top dut(clk, reset, WriteData, DataAdr, MemWrite);


    initial begin
        $display("=== Testbench Starting ===");
        $display("Time %0t: Asserting reset", $time);
        reset <= 1; 
        # 22; 
        reset <= 0;
        $display("Time %0t: Releasing reset", $time);
        
        // Timeout
        # 80000; 
        $display("=== Simulation Timeout ===");
        $display("Failed to detect all 5 correct writes before timeout.");
        $display("Correct writes detected: %d/5", correct_writes);
        $stop;
    end

    // generate clock to sequence tests
    always begin
        clk <= 1; # 5; clk <= 0; # 5;
    end



    // CHECK RESULTS
    always @(negedge clk) begin
        if(MemWrite) begin
            // Display every write for debugging
            $display(">>> MemWrite at Time %0t: Addr=%h Data=%h (%0d)", $time, DataAdr, WriteData, $signed(WriteData));

            case(DataAdr)
                // 1. Result for 15 / 0 -> Max Positive (0x7FFFFFFF)
                32'h00001028: begin 
                    if (WriteData === 32'h7FFFFFFF) begin
                        $display("[PASS] C[0] (15/0) Correct: %h", WriteData);
                        correct_writes++;
                    end else if (WriteData !== 32'h00000000) begin 
                        // Ignore initialization writes of 0
                        $display("[FAIL] C[0] Expected 7FFFFFFF, got %h", WriteData);
                    end
                end

                // 2. Result for -42 / 0 -> Min Negative (0x80000000)
                32'h0000102c: begin 
                    if (WriteData === 32'h80000000) begin
                        $display("[PASS] C[1] (-42/0) Correct: %h", WriteData);
                        correct_writes++;
                    end else if (WriteData !== 32'h00000000) begin
                        $display("[FAIL] C[1] Expected 80000000, got %h", WriteData);
                    end
                end

                // 3. Result for 88 / -4 -> -22 (0xFFFFFFEA)
                32'h00001030: begin 
                    if (WriteData === 32'hFFFFFFEA) begin
                        $display("[PASS] C[2] (88/-4) Correct: -22 (%h)", WriteData);
                        correct_writes++;
                    end else if (WriteData !== 32'h00000000) begin
                        $display("[FAIL] C[2] Expected FFFFFFEA (-22), got %h", WriteData);
                    end
                end

                // 4. Result for -2 / -1 -> 2 (0x00000002)
                32'h00001034: begin 
                    if (WriteData === 32'h00000002) begin
                        $display("[PASS] C[3] (-2/-1) Correct: 2 (%h)", WriteData);
                        correct_writes++;
                    end else if (WriteData !== 32'h00000000) begin
                        $display("[FAIL] C[3] Expected 00000002, got %h", WriteData);
                    end
                end

                // 5. Result for MinInt / -1 -> Overflow (Max Pos) (0x7FFFFFFF)
                32'h00001038: begin 
                    if (WriteData === 32'h7FFFFFFF) begin
                        $display("[PASS] C[4] (MinInt/-1) Correct: %h", WriteData);
                        correct_writes++;
                    end else if (WriteData !== 32'h00000000) begin
                        $display("[FAIL] C[4] Expected 7FFFFFFF, got %h", WriteData);
                    end
                end
            endcase

  
            if(correct_writes >= 5) begin
                $display("=== ALL SIMULATION TESTS SUCCEEDED ===");
                $stop;
            end
        end
    end
endmodule