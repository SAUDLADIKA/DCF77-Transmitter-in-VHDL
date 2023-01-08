----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2022 04:36:17 PM
-- Design Name: 
-- Module Name: MAIN_MODULE - Behavioral
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

entity MAIN_MODULE is
    port(CLK_100MHz: in std_logic;
         GO        : in std_logic; 
         RST       : in std_logic; 
         SEL       : in std_logic_vector(1 downto 0);  
         LED       : out std_logic_vector(5 downto 0);
         AN3       : out std_logic;   
         AN2       : out std_logic;
         AN1       : out std_logic;
         AN0       : out std_logic;
         DA        : out std_logic;
         DB        : out std_logic;
         DC        : out std_logic;
         DD        : out std_logic;
         DE        : out std_logic;
         DF        : out std_logic;
         DG        : out std_logic;
         DP        : out std_logic
         
			);
end MAIN_MODULE;

architecture Behavioral of MAIN_MODULE is
signal Minute    : std_logic_vector(6 downto 0);   
signal Hour      : std_logic_vector(5 downto 0);   
signal DATE      : std_logic_vector(5 downto 0);  
signal Week_day  : std_logic_vector(2 downto 0);
signal Month     : std_logic_vector(4 downto 0);       
signal Year      : std_logic_vector(7 downto 0); 
signal Year0     : std_logic_vector(7 downto 0); 
signal Minute_RA : std_logic_vector(6 downto 0);   
signal Hour_RA   : std_logic_vector(5 downto 0);   
signal DATE_RA    : std_logic_vector(5 downto 0);  
signal Month_RA  : std_logic_vector(4 downto 0);       
signal Year_RA   : std_logic_vector(7 downto 0); 
signal Year0_RA  : std_logic_vector(7 downto 0);
signal DCF_BIT_P : std_logic_vector(5 downto 0); 
signal M1        : std_logic_vector(7 downto 0); 
signal SEG : std_logic_vector(6 downto 0); 
signal EN : std_logic_vector(3 downto 0); 
signal CE250HZ   : std_logic;
signal M1_0   : unsigned(7 downto 0) := (others=>'0'); 
signal M1_1   : unsigned(7 downto 0) := (others=>'0'); 
--------------------------------------------------------------
--------------------------------------------------------------
begin
Display_Driver0: entity xil_defaultlib.Display_Driver port map(CLK_100MHz => CLK_100MHz, 
                                         RST        => RST,
                                         GO         => GO,
                                         CE250HZ    => CE250HZ,
                                         Minute     => Minute,
                                         Hour       => Hour,
                                         DATE       => DATE,
                                         Month      => Month, 
                                         Year       => Year,
                                         Year0      => Year0,
                                         DCF_BIT_P  => DCF_BIT_P,
                                         SEG        => SEG,
                                         EN         => EN,
                                         DP         => DP
                                         ); 

       

DCF77_ENCODER_0:  entity xil_defaultlib.DCF77_ENCODER port map(CLK_100MHz => CLK_100MHz, 
                                         RST        => RST,
                                         GO         => GO,
                                         Minute     => Minute,
                                         Hour       => Hour,
                                         DATE       => DATE,
                                         Week_day   => Week_day,
                                         Month      => Month,
                                         Year       => Year,
                                         M1         => M1,
                                         DCF_BIT_P  => DCF_BIT_P
                                         ); 
                                         
DCM_0:             entity xil_defaultlib.DCM port map(CLK_100MHz => CLK_100MHz, 
                                         CE250HZ    => CE250HZ
                                         );   
  

         
PRNG_0:          entity xil_defaultlib.PRNG port map(
                                         CLK_100MHz => CLK_100MHz, 
                                         RST        => RST,
                                         GO         => GO,
                                         SEL        => SEL,
                                         Minute_RA  => Minute_RA,
                                         Hour_RA    => Hour_RA,
                                         DATE_RA    => DATE_RA,
                                         Month_RA   => Month_RA,
                                         Year_RA    => Year_RA,
                                         Year0_RA   => Year0_RA 
                                         
                                         );          
                                     
LED <= DCF_BIT_P; ------ Display the Bit position in the LED
                                         
DA <= SEG(0);
DB <= SEG(1); 
DC <= SEG(2); 
DD <= SEG(3); 

DE <= SEG(4); 
DF <= SEG(5); 
DG <= SEG(6); 

AN0 <= EN(0);                                                                              
AN1 <= EN(1);
AN2 <= EN(2);
AN3 <= EN(3);

---- Counvert Counter value to (unit,ten) (hundred)------
M1_0 <= unsigned(M1) rem 100; 
M1_1 <= unsigned(M1) / 100;
----------------------------------------

    
process (SEL,M1, M1_0,M1_1)
begin
case SEL is 
 when "00" =>
 -----M1 COUNTER ------
 ----01/01/1970-------
   Minute   <= std_logic_vector(M1_0(6 downto 0));  ---- Counter value(Unit,Ten)
    Hour     <= std_logic_vector(M1_1(5 downto 0)); ---- Counter Value(Hundred)
     DATE     <= "00"  & X"1";  ----01
     Week_day <= "001";  ---1
    Month    <= "0" & X"1"; ---- 01
   Year     <= X"46";  --- 70
   Year0    <= X"13";  --- 19
 when "01" =>
 -----00:00 ------
 ----01/01/1983------- 
   Minute   <= "000" & X"0";  ---00 
    Hour     <= "00" & X"0";  -- 00
     DATE      <= "00"  & X"1";  --01
     Week_day <= "001"; 
    Month    <= "0" & X"1";  --01
   Year     <= X"53";  --83
   Year0    <= X"13";  --19
 when "10" =>
  -----12:34------
 ----23/10/2001-------
   Minute   <= "010" & X"2"; ----12
    Hour     <= "00" & X"C"; ---- 34
     DATE      <= "01"  & X"7";  --- 23
     Week_day <= "011"; ----3
    Month    <= "0" & X"A"; -----10
   Year     <= X"01"; ----01
   Year0    <= X"14"; ---20
 when "11" =>
 ------ Random----------
 ------ Random ---------
   Minute   <= Minute_RA;
    Hour     <=  Hour_RA;
     DATE      <= DATE_RA; 
     Week_day <= "101"; 
    Month    <= Month_RA;
   Year     <= Year_RA;
   Year0    <= Year0_RA;
   when others =>
   Minute   <= "000" & X"A";
    Hour     <= "00" & X"B";
     DATE      <= "00"  & X"5"; 
     Week_day <= "101"; 
    Month    <= "0" & X"6";
   Year     <= X"16";
   Year0    <= X"14"; 
end case;
end process;


end Behavioral;
