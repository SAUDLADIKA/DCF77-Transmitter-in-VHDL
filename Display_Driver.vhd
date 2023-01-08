----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2022 05:49:10 PM
-- Design Name: 
-- Module Name: Display_Driver - Behavioral
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
library xil_defaultlib;
use xil_defaultlib.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display_Driver is 
 Port (  CLK_100MHz: in std_logic;
         RST       : in std_logic;
         GO        : in std_logic;  
         CE250HZ   : in std_logic; 
         Minute    : in std_logic_vector(6 downto 0);   
         Hour      : in std_logic_vector(5 downto 0);   
         DATE      : in std_logic_vector(5 downto 0);  
         Month     : in std_logic_vector(4 downto 0);       
         Year      : in std_logic_vector(7 downto 0);
         Year0      : in std_logic_vector(7 downto 0);   
         DCF_BIT_P : in std_logic_vector(5 downto 0);
         SEG     : OUT std_logic_vector(6 downto 0);
         EN      : OUT std_logic_vector(3 downto 0);
         DP      : OUT std_logic
 );
end Display_Driver;

architecture Behavioral of Display_Driver is
-------------------------------------------------------------
-------------------------------------------------------------

--------------------------------------------------------------
--------------------------------------------------------------	
signal BINARY_0   : std_logic_vector (7 downto 0);
signal BINARY_1   : std_logic_vector (7 downto 0);
signal BCD_0      : std_logic_vector (3 downto 0);
signal BCD_1      : std_logic_vector (3 downto 0);
signal BCD_2      : std_logic_vector (3 downto 0);
signal BCD_3      : std_logic_vector (3 downto 0);
signal DCF_BIT_UN : unsigned (5 downto 0);
signal MINUS_FLAG : std_logic;
begin
DEC_TO_BCD0: entity xil_defaultlib.DEC_TO_BCD port map(BINARY_IN => BINARY_0 , BCD_0 => BCD_0 , BCD_1 =>BCD_1); 
DEC_TO_BCD1: entity xil_defaultlib.DEC_TO_BCD port map(BINARY_IN => BINARY_1 , BCD_0 => BCD_2 , BCD_1 =>BCD_3);

SEGMENT_DECODER0: entity xil_defaultlib.SEGMENT_DECODER port map(CLK => CLK_100MHz , RST=>RST , CE250HZ => CE250HZ, GO => GO , FLAG => MINUS_FLAG , BCD_0 => BCD_0 , BCD_1 => BCD_1 , BCD_2 => BCD_2 , BCD_3 => BCD_3 , EN => EN, SEG => SEG , DP => DP);   
DCF_BIT_UN <= unsigned (DCF_BIT_P);
process (CLK_100MHz)
  begin
   if rising_edge(CLK_100MHz) then 
    if (DCF_BIT_UN >= 0 and DCF_BIT_UN < 20) then
      BINARY_0 <=  X"00";
      BINARY_1 <=  X"00";
      MINUS_FLAG <= '1';
    elsif (DCF_BIT_UN >= 20 and DCF_BIT_UN < 36) then 
      BINARY_0 <=  "0" & Minute;
      BINARY_1 <=  "00" & Hour;
      MINUS_FLAG <= '0'; 
    elsif (DCF_BIT_UN >= 36 and DCF_BIT_UN < 50) then 
      BINARY_0 <=  "000" & Month;
      BINARY_1 <=  "00" & DATE;
      MINUS_FLAG <= '0'; 
    elsif (DCF_BIT_UN >= 50 and DCF_BIT_UN < 59) then 
      BINARY_0 <=  Year;
      BINARY_1 <=  Year0;
      MINUS_FLAG <= '0';   
    else
      BINARY_0 <=  X"00";
      BINARY_1 <=  X"00";
      MINUS_FLAG <= '0';        
        
    end if;
  end if;	
end process; 

end Behavioral;
