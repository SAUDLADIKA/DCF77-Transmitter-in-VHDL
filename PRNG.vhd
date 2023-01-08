----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2022 09:25:03 PM
-- Design Name: 
-- Module Name: PRNG - Behavioral
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

entity PRNG is
 Port ( CLK_100MHz :  in std_logic;
         RST       :  in std_logic;
         GO        :  in std_logic;
         SEL       :  in std_logic_vector(1 downto 0);  
         Minute_RA :  out std_logic_vector(6 downto 0);   
         Hour_RA   :  out std_logic_vector(5 downto 0);   
         DATE_RA   :  out std_logic_vector(5 downto 0);  
         Month_RA  :  out std_logic_vector(4 downto 0);       
         Year_RA   :  out std_logic_vector(7 downto 0);
         Year0_RA  :  out std_logic_vector(7 downto 0) 
 );
end PRNG;

architecture Behavioral of PRNG is
signal Minute : std_logic_vector(4 downto 0);
signal Hour   : std_logic_vector(5 downto 0);
signal DATE   : std_logic_vector(5 downto 0);
signal Month  : std_logic_vector(4 downto 0);
signal Year   : std_logic_vector(5 downto 0);
signal Year_0 : std_logic_vector(5 downto 0);

signal Min,Ho,Da,Mon,Yea,Yea_0 : std_logic;

type LOAD_DATA_0 is (IDEAL , LOAD , WAIT_FOR_CHANGE_SWITCH_STATE);
	signal LOAD_DATA: LOAD_DATA_0;
begin

Min   <= Minute(4) xor Minute(1);
Ho    <= Hour(5)  xor  Hour(1);
Da    <= DATE(5) xor DATE(2);
Mon   <= Month(4) xor Month(0);
Yea   <= Year(5) xor Year(0);
Yea_0 <= Year_0(5) xor Year_0(2);
process (CLK_100MHz) --- 1khz
  begin
   if rising_edge(CLK_100MHz) then  
    case LOAD_DATA is
	 when IDEAL =>
      if (SEL = "11") then
        LOAD_DATA <= LOAD;
      else
        LOAD_DATA <= IDEAL;
      end if; 
      
      
	 when LOAD =>
        LOAD_DATA <= WAIT_FOR_CHANGE_SWITCH_STATE;
        Minute_RA <= "00" & Minute; 
        Hour_RA   <= Hour;
        DATE_RA   <= DATE;
        Month_RA  <= Month;
        Year_RA   <= "00" & Year;   
        Year0_RA  <= "00" & Year_0;  
        
        
     when WAIT_FOR_CHANGE_SWITCH_STATE =>
      if (SEL = "11" or GO = '1') then
        LOAD_DATA <= WAIT_FOR_CHANGE_SWITCH_STATE;
      else
        LOAD_DATA <= IDEAL;
      end if;          
    end case;
  end if;	
end process;



process (CLK_100MHz) --- 1khz
  begin
   if rising_edge(CLK_100MHz) then 
    if (RST = '0') then
     Minute <= "00000";
     Hour   <= "000000";
     DATE   <= "000000";
     Month  <= "00000";
     Year   <= "000000";
     Year_0 <= "000000";
    else
    ---------- Random number Minute-------------
      Minute(0) <= Min;
      Minute(1) <= Minute(0);
      Minute(2) <= Minute(1);
      Minute(3) <= Minute(2);
      Minute(4) <= Minute(3);
    ---------- Random number Hour------------- 
      Hour(0) <= Ho;
      Hour(1) <= Hour(0);
      Hour(2) <= Hour(1);
      Hour(3) <= Hour(2);
      Hour(4) <= Hour(3);
      Hour(5) <= Hour(4);
    ---------- Random number DATE------------- 
      DATE(0) <= Da;
      DATE(1) <= DATE(0);  
      DATE(2) <= DATE(1);  
      DATE(3) <= DATE(2);  
      DATE(4) <= DATE(3);  
      DATE(5) <= DATE(4); 
    ---------- Random number Month------------- 
      Month(0) <= Mon;
      Month(1) <= Month(0);  
      Month(2) <= Month(1); 
      Month(3) <= Month(2); 
      Month(4) <= Month(3); 
    ---------- Random number Year------------- 
      Year(0) <= Yea;
      Year(1) <= Year(0);
      Year(2) <= Year(1);
      Year(3) <= Year(2);
      Year(4) <= Year(3);
      Year(5) <= Year(4); 
      
      
      Year_0(0) <= Yea_0;
      Year_0(1) <= Year_0(0);
      Year_0(2) <= Year_0(1);
      Year_0(3) <= Year_0(2);
      Year_0(4) <= Year_0(3);
      Year_0(5) <= Year_0(4); 
      
    end if;
   end if;	
end process;  


end Behavioral;
