----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2022 06:43:13 PM
-- Design Name: 
-- Module Name: SEGMENT_DECODER - Behavioral
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

entity SEGMENT_DECODER is
Port (
      CLK: IN std_logic; 
      CE250HZ : IN std_logic;
      GO      : IN std_logic; 
      RST     : IN std_logic;
      FLAG    : IN std_logic;   
      BCD_0   : IN std_logic_vector(3 downto 0);
      BCD_1   : IN std_logic_vector(3 downto 0);
      BCD_2   : IN std_logic_vector(3 downto 0);
      BCD_3   : IN std_logic_vector(3 downto 0);
      EN      : OUT std_logic_vector(3 downto 0);
      SEG     : OUT std_logic_vector(6 downto 0);
      DP      : OUT std_logic
 
 );
end SEGMENT_DECODER;


architecture Behavioral of SEGMENT_DECODER is
signal COUNTER : unsigned (1 downto 0) := (others=>'0');
signal BCD     : std_logic_vector (3 downto 0);
signal ON_OFF  : std_logic;
type START_DIS is (IDEAL , START);
	signal START_DISPLAY: START_DIS;

begin
DP <= '1';

process (CLK) --- 1khz
  begin
   if rising_edge(CLK) then  
    case START_DISPLAY is
	 when IDEAL =>
	  ON_OFF <= '0';
      if (GO = '0' or RST = '0') then
        START_DISPLAY <= IDEAL;
      else
        START_DISPLAY <= START;
      end if; 
      
        
     when START =>
      ON_OFF <= '1';
      if (RST = '0') then
        START_DISPLAY <= IDEAL;
      else
        START_DISPLAY <= START;
      end if;          
    end case;
  end if;	
end process;



    process(CE250HZ)
    begin
        if rising_edge(CE250HZ) then
          COUNTER <= COUNTER + 1;
        end if;
    end process;
----------------------------------------------------------
----------------------------------------------------------
process(CLK)
    begin
        if rising_edge(CLK) then
   if (ON_OFF = '1') then
case (COUNTER) is
 when "00" =>
  EN <= "1110";
  BCD <= BCD_0;        
  
 when "01" =>
  EN <= "1101";
  BCD <= BCD_1;  

 when "10" =>
  EN <= "1011";
  BCD <= BCD_2; 

 when "11" =>
  EN <= "0111";
  BCD <= BCD_3;  
  when others =>
  EN <= "0111";
  BCD <= BCD_3;    
end case;
 else
  EN <= "1111"; 
  BCD <="0000";
end if;
        end if;
end process;    
----------------------------------------------------------
----------------------------------------------------------


----------------------------------------------------------
----------------------------------------------------------
process(CLK)
 begin
  if rising_edge(CLK) then
   if (FLAG = '1') then   
    SEG <= "0111111";
    else
    ---G F E D C B A
     case BCD is
      when "0000" => SEG <= "1000000"; ----0  --128
      when "0001" => SEG <= "1111001"; ----1  --121
      when "0010" => SEG <= "0100100";  ----2  --36
      when "0011" => SEG <= "0110000";----3  --48
      when "0100" => SEG <= "0011001";----4  --25
      when "0101" => SEG <= "0010010";----5  --18
      when "0110" => SEG <= "0000010";----6  --2
      when "0111" => SEG <= "1111000";----7  --120
      when "1000" => SEG <= "0000000";----8  --0
      when "1001" => SEG <= "0010000";----9  --16   
      when  others => SEG <= "1111111";----9  --16  
end case;
 end if; 
end if;
end process;    
----------------------------------------------------------
----------------------------------------------------------
end Behavioral;
