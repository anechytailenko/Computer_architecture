module testbench_peripheral;

    logic clk;
    logic reset;
    logic [31:0] config_data;
    logic [31:0] status_data;
    logic irrigation_active;
    logic ventilation_active;
    

    // ventilation_active=1, pause=1, irrigation_active=1, enable=1
    localparam CFG_INSTANT_CYCLE = 32'h00200803; 
    
    peripheral dut (
        .clk(clk),
        .reset(reset),
        .config_data(config_data),
        .status_data(status_data),
        .irrigation_active(irrigation_active),
        .ventilation_active(ventilation_active)
    );

    initial begin
        clk = 1'b0;
        forever #2 clk = ~clk; 
    end
    

    initial begin
        
        // reset to go to IDLE state
        reset = 1'b1;
        config_data = 32'h0;
        #5 reset = 1'b0; 
        @(posedge clk);
        
        // this will just show flow of state - to see that FSM go from one to another state in the right order - looks stupid)
        config_data = CFG_INSTANT_CYCLE;
        @(posedge clk); 
        @(posedge clk); 
        @(posedge clk); 
        @(posedge clk); 
        @(posedge clk); 
        @(posedge clk); 
			// enable 0
			config_data = 32'h0;
			@(posedge clk);
			@(posedge clk);
			
			

        $stop;
    end
    
endmodule