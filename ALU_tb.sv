`timescale 1ns/1ps

module ALU_tb;

    logic [31:0] a, b;
    logic [2:0]  sel;

    logic overflow_flag, carry_flag, negative_flag, zero_flag;
    logic [31:0] result;

    integer amount_of_expr = 0;
    integer successful_expr = 0;

    ALU uut (
        .a(a),
        .b(b),
        .sel(sel),
        .overflow_flag(overflow_flag),
        .carry_flag(carry_flag),
        .negative_flag(negative_flag),
        .zero_flag(zero_flag),
        .result(result)
    );

    task automatic check_result(
        input string test_name,
        input [31:0] expected_result,
        input bit expected_zero,
        input bit expected_negative
    );
        begin
            amount_of_expr++;
            #1;

            if (result === expected_result &&
                zero_flag === expected_zero &&
                negative_flag === expected_negative)
            begin
                successful_expr++;
                $display("[PASS] %s | result=%0d | zero=%b | neg=%b", 
                         test_name, result, zero_flag, negative_flag);
            end
            else begin
                $display("[FAIL] %s | result=%0d (exp=%0d) | zero=%b (exp=%b) | neg=%b (exp=%b)",
                         test_name, result, expected_result, expected_zero, zero_flag, negative_flag, expected_negative);
            end
        end
    endtask


    initial begin
        $display("Simulation started...");
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU_tb);
        $vcdpluson; // for ModelSim/QuestaSim
    end

 
    initial begin
        // Initialize
        a = 0; b = 0; sel = 0;
        #10;

        // ---- TEST 1: ADD ----
        sel = 3'b000; a = 32'd10; b = 32'd5; #10;
        check_result("ADD 10 + 5", 32'd15, 0, 0);

        // ---- TEST 2: SUB ----
        sel = 3'b001; a = 32'd15; b = 32'd5; #10;
        check_result("SUB 15 - 5", 32'd10, 0, 0);

        // ---- TEST 3: AND ----
        sel = 3'b010; a = 32'hFF00FF00; b = 32'h0F0F0F0F; #10;
        check_result("AND", (32'hFF00FF00 & 32'h0F0F0F0F), 0, 0);

        // ---- TEST 4: OR ----
        sel = 3'b011; a = 32'hAA00AA00; b = 32'h00FF00FF; #10;
        check_result("OR", (32'hAA00AA00 | 32'h00FF00FF), 0, 0);

        // ---- TEST 5: XOR ----
        sel = 3'b100; a = 32'hAAAA0000; b = 32'h00AAAA00; #10;
        check_result("XOR", (32'hAAAA0000 ^ 32'h00AAAA00), a^b ==0, a^b < 0);

        // ---- TEST 6: SLT ----
        sel = 3'b101; a = 32'd10; b = 32'd20; #10;
        check_result("SLT (10<20)", 32'd1, 0, 0);

        // ---- TEST 7: Zero detection ----
        sel = 3'b000; a = 32'd5; b = -32'd5; #10;
        check_result("ADD 5 + (-5)", 32'd0, 1, 0);

        // ---- TEST 8: Negative result ----
        sel = 3'b001; a = 32'd5; b = 32'd10; #10;
        check_result("SUB 5 - 10", -32'd5, 0, 1);

        // ---- Simulation Summary ----
        #10;
        $display("--------------------------------------------------");
        $display("Simulation finished.");
        $display("Total tests executed: %0d", amount_of_expr);
        $display("Successful tests:     %0d", successful_expr);
        $display("Failed tests:         %0d", amount_of_expr - successful_expr);
        $display("Success rate:         %0.2f%%", (successful_expr * 100.0) / amount_of_expr);
        $display("--------------------------------------------------");

        $finish;
    end

endmodule
