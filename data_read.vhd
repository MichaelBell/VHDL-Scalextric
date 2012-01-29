----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:00:21 01/17/2012 
-- Design Name: 
-- Module Name:    data_read - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Receiver using protocol:
-- Idle: data_clk LOW, data invalid
-- Start sending: data_clk goes high then low
-- Data: data is read on the next 8 transitions of data_clk from low to high
-- Clock rate must be at least 1KHz, otherwise we assume sender has gone idle
-- After data byte, you must have another start bit, but we don't have a stop bit.
entity data_read is
  Port ( CLK : in STD_LOGIC;
         data_clk : in STD_LOGIC;
         data : in std_logic;
         data_out : out unsigned(7 downto 0) );
end data_read;

architecture Behavioral of data_read is


begin
  process(CLK)
    variable state : std_logic_vector(2 downto 0);
    variable count_clk : unsigned(15 downto 0);
    variable nextbit : unsigned(2 downto 0);
    variable value : unsigned(7 downto 0);
	 variable debounce : unsigned(3 downto 0) := "0000";
  begin
    if rising_edge(CLK) then
      if state = "000" then
        -- Not receiving.  Looking for data_clk to go high.
        if data_clk = '1' then
          debounce := debounce + 1;
          if debounce = "0000" then
            state := "001";
          end if;
        else
          debounce := "0000";
        end if;
      else
        count_clk := count_clk + 1;
        if count_clk = "0000000000000000" then
          state := "000";
        else
          if state = "001" then
            -- Start clock.  Wait for data_clk to go low again.
            if data_clk = '0' then
              debounce := debounce + 1;
              if debounce = "0000" then
                state := "010";
                count_clk := "0000000000000000";
                nextbit := "000";
              end if;
            else
              debounce := "0000";
            end if;
          elsif state = "010" then
            -- Data bit on clk -> high transition.
            if data_clk = '1' then
              debounce := debounce + 1;
              if debounce = "0000" then
                state := "011";
                value(to_integer(nextbit)) := data;
                nextbit := nextbit + 1;
              end if;
            else
              debounce := "0000";
            end if;
          elsif state = "011" then
            if data_clk = '0' then
              debounce := debounce + 1;
              if debounce = "0000" then
                count_clk := "0000000000000000";
                if nextbit = "000" then
                  state := "000";
                  data_out <= value;
                else
                  state := "010";
                end if;
              end if;
            else
              debounce := "0000";
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;
end Behavioral;

