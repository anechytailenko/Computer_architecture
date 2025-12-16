module peripheral (
    input logic clk, reset,
	 input logic [31:0] config_data,
    output logic [31:0] status_data,
    output logic irrigation_active,
    output logic ventilation_active
);

    logic [9:0] dur_irrig, dur_pause, dur_vent;
    logic enable;
    
	 // handle bit of rgegiste as the fields - logic written in the README.md
    assign enable = config_data[0];
    assign dur_irrig = config_data[10:1]; 
    assign dur_pause = config_data[20:11];
    assign dur_vent = config_data[30:21];

    typedef enum logic [2:0] {IDLE, STATE1, STATE2, STATE3, END} state_type;
    state_type state_current, state_next;

    logic [9:0] timer_current, timer_next;
    
	 // handle logic of status reg
    logic done;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state_current <= IDLE;
            timer_current <= 10'h0;
        end 
		  else begin
            state_current <= state_next;
            timer_current <= timer_next;
        end
    end

    always_comb begin
        state_next = state_current;
        timer_next = timer_current;

        if (~enable) begin
            state_next = IDLE;
            timer_next = 10'h0;
        end 
		  else begin
            
            case (state_current)
                
                IDLE: begin
                    if (enable) begin
                        timer_next = dur_irrig;
                        state_next = STATE1;
                    end
                end

                STATE1: begin
                    if (timer_current == 10'h1) begin
                        timer_next = dur_pause;
                        state_next = STATE2;
                    end 
						  else begin
                        timer_next = timer_current - 10'h1;
                    end
                end
                
                STATE2: begin
                    if (timer_current == 10'h1) begin
                        timer_next = dur_vent;
                        state_next = STATE3;
                    end 
						  else begin
                        timer_next = timer_current - 10'h1;
                    end
                end

                STATE3: begin
                    if (timer_current == 10'h1) begin
                        state_next = END;
                    end 
						  else begin
                        timer_next = timer_current - 10'h1;
                    end
                end

                END: begin
                    state_next = END; 
                end

                default: state_next = IDLE;
            endcase
        end
    end

	 
    always_comb begin
	 
        irrigation_active = 1'b0;
        ventilation_active = 1'b0;
        done = 1'b0;

        case (state_current)
            IDLE:   begin 
					done=0;
					irrigation_active = 1'b0;
               ventilation_active = 1'b0;
				end
            
            STATE1: begin
					 done = 0;
				    ventilation_active = 1'b0;
                irrigation_active = 1'b1;
            end
            
            STATE2: begin 
					done=0;
					irrigation_active = 1'b0;
               ventilation_active = 1'b0;
				end
            
            STATE3: begin
				    done=0;
					 irrigation_active = 1'b0;
                ventilation_active = 1'b1;
            end
            
            END: begin
                done = 1'b1;
					 irrigation_active = 1'b0;
                ventilation_active = 1'b0;
            end
            
            default: begin end
        endcase
    end
    
    assign status_data = {31'h0, done};

endmodule