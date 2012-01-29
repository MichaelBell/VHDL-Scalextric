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
    Port ( CLKIN : in  STD_LOGIC;
           SW : in unsigned(7 downto 0);
           Led : out unsigned(7 downto 0);
           data : in std_logic;
           data_clk : in std_logic;
           PWM : out  STD_LOGIC;
           VS : out  STD_LOGIC;
           HS : out  STD_LOGIC;
           OutRed : out  unsigned(2 downto 0);
           OutGreen : out  unsigned(2 downto 0);
           OutBlue : out  unsigned(2 downto 1));
end top;

architecture Behavioral of top is

  COMPONENT dcm1
  PORT(
    CLKIN_IN : IN std_logic;
    CLKIN_IBUFG_OUT : OUT std_logic;
    CLKFX_OUT : OUT std_logic;
    CLK0_OUT : OUT std_logic
    );
  END COMPONENT;

  signal CLK : std_logic;

  component vga is
    Port ( CLK : in  STD_LOGIC;
           x : in unsigned(7 downto 0);
           y : in unsigned(7 downto 0);
           z : in unsigned(7 downto 0);
           VS : out  STD_LOGIC;
           HS : out  STD_LOGIC;
           OutRed : out  unsigned(2 downto 0);
           OutGreen : out  unsigned(2 downto 0);
           OutBlue : out  unsigned(2 downto 1));
  end component;

  component data_read is
  Port ( CLK : in STD_LOGIC;
         data_clk : in STD_LOGIC;
         data : in std_logic;
         power : out unsigned(7 downto 0);
         x : out unsigned(7 downto 0);
         y : out unsigned(7 downto 0);
         z : out unsigned(7 downto 0)
    );
  end component;

  signal power : unsigned(7 downto 0);
  signal x : unsigned(7 downto 0);
  signal y : unsigned(7 downto 0);
  signal z : unsigned(7 downto 0);

begin

  Inst_dcm1: dcm1 PORT MAP(
    CLKIN_IN => CLKIN,
    CLKFX_OUT => CLK
  );

  data_reader: data_read port map (CLK, data_clk, data, power, x, y, z);
  vga_disp: vga port map (CLK, x, y, z, VS, HS, OutRed, OutGreen, OutBlue);

  process(CLK)
    variable count_int : unsigned(11 downto 0);
    variable power_out : unsigned(7 downto 0);
  begin
    if rising_edge(CLK) then
      Led <= power;
      if SW(7) = '1' then
        power_out := SW(6 downto 0) & "0";
      else
        power_out := power;
      end if;
      count_int := count_int + 1;
      if count_int(11 downto 4) < power_out then
        PWM <= '1';
      else
        PWM <= '0';
      end if;
    end if;
  end process;
end Behavioral;

