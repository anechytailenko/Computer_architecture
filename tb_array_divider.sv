module tb_array_divider();

    // Parameter
    localparam N = 4;

    // Inputs
    logic [N-1:0] A, B;

    // Outputs
    logic [N-1:0] Q, R;

    // Instantiate the unit under test (UUT)
    array_divider #(.N(N)) uut (
        .A(A),
        .B(B),
        .Q(Q),
        .R(R)
    );

    // Task to check result
    task check_div(input int a_val, input int b_val);
        int expected_Q, expected_R;
        begin
            A = a_val;
            B = b_val;
            #5; // wait for combinational logic to settle

            if (b_val != 0) begin
                expected_Q = a_val / b_val;
                expected_R = a_val % b_val;
            end
            else begin
                expected_Q = 0;
                expected_R = 0;
            end

            // Print the results
            $display("A=%0d, B=%0d => Q=%0d (exp %0d), R=%0d (exp %0d)",
                     a_val, b_val, Q, expected_Q, R, expected_R);

            // Assertions for automatic check
            if (b_val != 0) begin
                assert (Q == expected_Q && R == expected_R)
                    else $error("Test FAILED for A=%0d, B=%0d! Got Q=%0d R=%0d (Expected Q=%0d R=%0d)",
                                a_val, b_val, Q, R, expected_Q, expected_R);
            end
            else
                $display("Division by zero handled (A=%0d, B=%0d)", a_val, b_val);

            #5;
        end
    endtask


    // Test sequence
    initial begin
        $display("===== Starting array_divider tests =====");

        // Basic tests
        check_div(9, 3);   // Expect Q=3, R=0
        check_div(7, 2);   // Expect Q=3, R=1
        check_div(8, 4);   // Expect Q=2, R=0
        check_div(15, 4);  // Expect Q=3, R=3
        check_div(5, 2);   // Expect Q=2, R=1
        check_div(10, 5);  // Expect Q=2, R=0
        check_div(10, 0);  // Division by zero case (handled as 0,0)

        $display("===== All tests completed =====");
        $finish;
    end

endmodule
