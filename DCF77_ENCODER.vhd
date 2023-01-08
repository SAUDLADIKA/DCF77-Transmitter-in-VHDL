----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2022 07:13:18 PM
-- Design Name: 
-- Module Name: DCF77_ENCODER - Behavioral
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
--use ieee.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
library xil_defaultlib;
use xil_defaultlib.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DCF77_ENCODER is
    port(CLK_100MHz: in std_logic;
         GO        : in std_logic;  
         RST       : in std_logic; 
         Minute    : in std_logic_vector(6 downto 0);   
         Hour      : in std_logic_vector(5 downto 0);   
         DATE      : in std_logic_vector(5 downto 0);  
         Week_day  : in std_logic_vector(2 downto 0);
         Month     : in std_logic_vector(4 downto 0);       
         Year      : in std_logic_vector(7 downto 0);  
         M1        : out std_logic_vector(7 downto 0);
         DCF_BIT_P : out std_logic_vector(5 downto 0)
			);
end DCF77_ENCODER;

architecture Behavioral of DCF77_ENCODER is
       constant WAIT_1SEC : integer := 1000;  ---- 1 sec for 1 bit
       constant SEND_1    : integer := 200;  ----- 200msec for 1
       constant SEND_0    : integer := 100;  ----- 100msec for 0   
       constant WAIT_2SEC : integer := 2000; ----- 1 sec previous + 1 sec for last bit
       constant WAIT_DIV  : integer := 50000;  --50000 --- convert 100Mhz to 1kHZ                        
signal DCF77_STD : std_logic_vector (59 downto 0);
signal COUNTER : unsigned(5 downto 0) := (others=>'0');
signal Minute_un : unsigned(6 downto 0) := (others=>'0');
signal COUNTER_SEND : unsigned(10 downto 0) := (others=>'0');
signal COUNTER_DIV  : unsigned(17 downto 0) := (others=>'0');
signal SLOW_CLK     : std_logic;

signal P1,P2,P3   : std_logic;
type DCF77_STATES is (GO_IDEAL,IDEAL , ARRANGE_DATA, CHECK, SEND1 , SEND0 , WAIT0 , LAST_SEC);
	signal DCF77_STATE: DCF77_STATES;
begin

Parity_0: entity xil_defaultlib.Parity port map
    (Minute=>Minute, Hour=>Hour, DATE=>DATE, Week_day=>Week_day, Month=>Month, Year=>Year, P1=>P1 , P2 => P2 , P3=> P3);


DCF_BIT_P <= std_logic_vector(COUNTER);
Minute_un <= unsigned(Minute) + 1;


process (CLK_100MHz)
  begin
  
  ---- 100MHZ to 1Khz
  ----- Counrer value = System frequency / Required Frequency * 2
  ----- Counter Value = 100Mhz / 1Khz *2
  ----- Counter vaue = 50000 
  
   if rising_edge(CLK_100MHz) then      
      ----------- After 0.5msec it toggel the clk value (0 for 0.5msec and 1 for 0.5msec)
    if (COUNTER_DIV >= WAIT_DIV - 1 ) then
      COUNTER_DIV <=  (others=>'0');
      SLOW_CLK <= not SLOW_CLK;
    else
      SLOW_CLK <= SLOW_CLK;    
      COUNTER_DIV <= COUNTER_DIV + 1;
    end if;
  end if;	
end process;   
--------------------------------------------------------------------------------
----------------------------------------------------------------------------------

process (SLOW_CLK) --- 1khz
  begin
   if rising_edge(SLOW_CLK) then  
    case DCF77_STATE is
      when GO_IDEAL => 
	  COUNTER_SEND <= (others=>'0'); 
	  COUNTER <= (others=>'0');
	   M1 <= X"FF";  ---- no data is trasmit then the output of dcff is 255(100%)
      if (GO = '0' or RST = '0') then
       DCF77_STATE <= GO_IDEAL;
      else
       DCF77_STATE <= IDEAL;
       end if;
    
    
	 when IDEAL => 
	  COUNTER_SEND <= (others=>'0'); 
	  COUNTER <= (others=>'0');
	   M1 <= X"FF";  ---- no data is trasmit then the output of dcff is 255(100%)
       DCF77_STATE <= ARRANGE_DATA;
       
       
-------------------------------------------------------------------
-------------------------------------------------------------------
   when ARRANGE_DATA =>       
        M1 <= X"FF";
        COUNTER_SEND <= (others=>'0'); 
        COUNTER <= (others=>'0');
        ---- SAVE ALL DATA IN ONE VARIABLE FOR SENDING
        DCF77_STD <= ('0' & P3 & Year(7 downto 0) & Month(4 downto 0) & Week_day(2 downto 0) & DATE(5 downto 0) & P2 & Hour(5 downto 0) & P1 & std_logic_vector(Minute_un(6 downto 0)) & '1' & "00000" & "00000" & "1111111111");
        DCF77_STATE <= CHECK;          
-------------------------------------------------------------------
-------------------------------------------------------------------  
  when CHECK =>   
  ---- Check the LSB of DCF77_STD and then right shift 
  --- If Lsb is equal to 1 then go to the SENd1 state in send1 state it will stay for 200msec and value is 15% otherwise go to the send0                
         M1 <= X"FF";
         COUNTER_SEND <= (others=>'0');
        if (RST = '0') THEN
         DCF77_STATE <= GO_IDEAL; 
        elsif (DCF77_STD(0) = '1') then
         DCF77_STATE <= SEND1;
         DCF77_STD <= ('0' & DCF77_STD(59 downto 1));  --- right shift 
        else 
         DCF77_STATE <= SEND0;
         DCF77_STD <= ('0' & DCF77_STD(59 downto 1));  --- right shift 
        end if;
        
-------------------------------------------------------------------
-------------------------------------------------------------------  
------- Wait for 100msec
  when SEND0 => 
         M1 <= X"26";        
         COUNTER_SEND <= COUNTER_SEND + 1;       
         if (RST = '0') THEN
         DCF77_STATE <= GO_IDEAL; 
        elsif (COUNTER_SEND < SEND_0) then --- 100ms wait
          DCF77_STATE <= SEND0;         
         else 
         DCF77_STATE <= WAIT0;         
         end if;

-------------------------------------------------------------------
-------------------------------------------------------------------  
------- Wait for 200msec
  when SEND1 => 
         M1 <= X"26";   --- transmit 15% of 255 (38)        
         COUNTER_SEND <= COUNTER_SEND + 1;       
         if (RST = '0') THEN
         DCF77_STATE <= GO_IDEAL; 
        elsif (COUNTER_SEND < SEND_1) then  --- 200ms
          DCF77_STATE <= SEND1;         
         else 
         DCF77_STATE <= WAIT0;         
         end if;

-------------------------------------------------------------------
-------------------------------------------------------------------  
---- After sending 0 or 1, data will be 100% for 800msec or 900msec depends upon the previous state
  when WAIT0 => 
         M1 <= X"FF";
                  
         COUNTER_SEND <= COUNTER_SEND + 1;       
         if (RST = '0') THEN
         DCF77_STATE <= GO_IDEAL; 
        elsif (COUNTER_SEND < WAIT_1SEC) then
          DCF77_STATE <= WAIT0;         
         elsif (COUNTER < 59) then
         DCF77_STATE <= CHECK;
         COUNTER <= COUNTER + 1;
         else
         DCF77_STATE <= LAST_SEC;         
         end if;         
         
-------------------------------------------------------------------
-------------------------------------------------------------------  
------------ Last sec here it will stay for 1 sec 
------------ Previous 1sec + 1 sec present state
  when LAST_SEC => 
         M1 <= X"FF";        
         COUNTER_SEND <= COUNTER_SEND + 1;       
         if (RST = '0') THEN
         DCF77_STATE <= GO_IDEAL; 
        elsif (COUNTER_SEND < WAIT_2SEC) then
          DCF77_STATE <= LAST_SEC;         
         else
         DCF77_STATE <= IDEAL;         
         end if;                    
    end case;
  end if;	
end process;

end Behavioral;
