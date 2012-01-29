----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:53:21 09/16/2010 
-- Design Name: 
-- Module Name:    vga - Behavioral 
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

entity vga is
    Port ( CLK : in  STD_LOGIC;
           x : in unsigned(7 downto 0);
           y : in unsigned(7 downto 0);
           z : in unsigned(7 downto 0);
           VS : out  STD_LOGIC;
           HS : out  STD_LOGIC;
           OutRed : out  unsigned(2 downto 0);
           OutGreen : out  unsigned(2 downto 0);
           OutBlue : out  unsigned(2 downto 1));
end vga;

architecture Behavioral of vga is

component driver is
    Port ( CLK : in  STD_LOGIC;
           VS : out  STD_LOGIC;
           HS : out  STD_LOGIC;
        Active : out STD_LOGIC;
        ActiveIn2 : out STD_LOGIC;
           CountX : out  unsigned (9 downto 0);
           CountY : out  unsigned (9 downto 0));
end component;

  signal VSint : std_logic;
  signal HSint : std_logic;
  signal active : std_logic;
  signal activein2 : std_logic;
  signal start_row : std_logic;
  signal countX : unsigned(9 downto 0);
  signal countY : unsigned(9 downto 0);
  
begin

  gen: driver port map (CLK, VSint, HSint, active, activein2, countx, county);
  VS <= VSint;
  HS <= HSint;

process(CLK)

  
  variable pixel_out : unsigned(7 downto 0);
  variable last_hs : std_logic := '0';
  
begin
  if rising_edge(CLK)  then    
    if active = '1' then
      if countY >= 508 and countY < 520 and 
         countX(9 downto 1) - 128 >= z and countX(9 downto 1) - 128 < (z + 2) then
        pixel_out := "11100000";
      elsif countY >= 512 and countY < 516 then
        pixel_out := "11111111";
      elsif countX(9 downto 1) - 128 > (x - 3) and countX(9 downto 1) - 128 < (x + 3) and 
            countY(9 downto 1) > (y - 3) and countY(9 downto 1) < (y + 3) then
        pixel_out := "11000000";
      else
        pixel_out := "00000000";
      end if;
    else
      pixel_out := "00000000";
    end if;
    OutRed <= pixel_out(7 downto 5);
    OutGreen <= pixel_out(4 downto 2);
    OutBlue <= pixel_out(1 downto 0);
    if last_hs = '1' and HSint = '0' then
      start_row <= '1';
    else
      start_row <= '0';
    end if;
    last_hs := HSint;
  end if;
end process;

end Behavioral;
