----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2022 04:39:51 PM
-- Design Name: 
-- Module Name: DCM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DCM is
Port ( 
         CLK_100MHz: in std_logic;  
--       CE1HZ   : out std_logic;  
         CE250HZ     : out std_logic  
	 );
end DCM;

architecture Behavioral of DCM is
       constant WAIT_DIV_250  : integer := 400000;
--       constant WAIT_DIV_1    : integer := 100000000;       
signal COUNTER_DIV_250  : unsigned(18 downto 0) := (others=>'0');
--signal COUNTER_DIV_1    : unsigned(26 downto 0) := (others=>'0');
----------------- Counter value = Clock frequency / Output clock
---------------- Counter value = 100,000,000/ 250
---------------- Counter value = 400,000
begin
process (CLK_100MHz)
  begin
   if rising_edge(CLK_100MHz) then 
    if (COUNTER_DIV_250 >= WAIT_DIV_250 - 1 ) then
      COUNTER_DIV_250 <=  (others=>'0');
      CE250HZ <= '1';
    else
      CE250HZ <= '0';    
      COUNTER_DIV_250 <= COUNTER_DIV_250 + 1;
    end if;
  end if;	
end process;   


--process (CLK_100MHz)
--  begin
--   if rising_edge(CLK_100MHz) then 
--    if (COUNTER_DIV_1 >= WAIT_DIV_1 - 1 ) then
--      COUNTER_DIV_1 <=  (others=>'0');
--      CE1HZ <= '1';
--    else
--      CE1HZ <= '0';    
--      COUNTER_DIV_1 <= COUNTER_DIV_1 + 1;
--    end if;
--  end if;	
--end process;   

end Behavioral;
