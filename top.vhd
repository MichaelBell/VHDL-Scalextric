----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:00:21 01/17/2012 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top is
    Port ( CLK : in  STD_LOGIC;
           SW : in unsigned(7 downto 0);
			  Led : out unsigned(7 downto 0);
           data : in std_logic;
           data_clk : in std_logic;
           PWM : out  STD_LOGIC);
end top;

architecture Behavioral of top is

component data_read is
  Port ( CLK : in STD_LOGIC;
         data_clk : in STD_LOGIC;
         data : in std_logic;
         data_out : out unsigned(7 downto 0) );
end component;

  signal data_out : unsigned(7 downto 0);

begin

data_reader: data_read port map (CLK, data_clk, data, data_out);

  process(CLK)
    variable count_int : unsigned(11 downto 0);
    variable power : unsigned(6 downto 0);
  begin
    if rising_edge(CLK) then
      Led <= data_out;
		if SW(7) = '1' then
        power := SW(6 downto 0);
      else
        power := data_out(7 downto 1);
      end if;
      count_int := count_int + 1;
      if count_int(11 downto 5) < power then
        PWM <= '1';
      else
        PWM <= '0';
      end if;
    end if;
  end process;
end Behavioral;

