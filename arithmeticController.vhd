library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;

entity arithmeticController is
	port(clk, reset, ready, add_sub: in STD_LOGIC;
		  a, b: in STD_LOGIC_VECTOR(3 downto 0);
		  out_valid: out STD_LOGIC;
		  out_res: out STD_LOGIC_VECTOR(3 downto 0));
end;


architecture synch of arithmeticController is 
	type statetype is (INIT, RDY, ADD, SUB);
	signal currentState, nextState: statetype;
begin
	-- state register
	process(clk, reset) begin
		if reset = '1' then	currentState <= INIT;
		elsif rising_edge(clk) then currentState <= nextState;
		end if;
	end process;
	
	-- next state logic
	process(currentState, ready, add_sub) begin 
		case currentState is
		 when INIT =>
			if ready = '1' then nextState <= RDY;
			else                nextState <= INIT;
			end if;
		 when RDY =>
			if add_sub = '1' then nextState <= ADD;
			else                  nextState <= SUB;
			end if;
		 when ADD =>
			nextState <= INIT;
		 when SUB =>
			nextState <= INIT;
		 when others =>
			nextState <= INIT;
		end case;
	end process;
	
	-- output logic
   process(currentState, a, b) begin
		case currentState is
		 when ADD =>
		  out_valid <= '1';
		  out_res <= std_logic_vector(signed(a) + signed(b)); 
		 when SUB =>
		  out_valid <= '1';
		  out_res <=  std_logic_vector(signed(a) - signed(b)); 
		 when others =>
			out_valid <= '0';
			out_res <= B"0000";
		end case;
	end process;
end;