----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2022 08:42:14 PM
-- Design Name: 
-- Module Name: Parity - Behavioral
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

entity Parity is
 Port (
         Minute    : in std_logic_vector(6 downto 0);   
         Hour      : in std_logic_vector(5 downto 0);   
         DATE      : in std_logic_vector(5 downto 0);  
         Week_day  : in std_logic_vector(2 downto 0);
         Month     : in std_logic_vector(4 downto 0);       
         Year      : in std_logic_vector(7 downto 0);  
         P1        : out std_logic;
         P2        : out std_logic;
         P3        : out std_logic
  );
end Parity;

architecture Behavioral of Parity is

signal P1_0,P1_1,P1_2,P1_3,P1_4,P1_5   : std_logic;
signal P2_0,P2_1,P2_2,P2_3,P2_4        : std_logic;
signal P3_0,P3_1,P3_2,P3_3,P3_4,P3_5,P3_6,P3_7,P3_8,P3_9,P3_10,P3_11 : std_logic;
signal P3_12,P3_13,P3_14,P3_15,P3_16,P3_17,P3_18,P3_19,P3_20         : std_logic;
signal Minute_un : unsigned(6 downto 0) := (others=>'0');
signal Minute_std : std_logic_vector(6 downto 0);
begin


Minute_un <= unsigned(Minute) + 1;
Minute_std <= std_logic_vector(Minute_un);
P1_0 <= Minute_std(0) xor Minute_std(1);
P1_1 <= Minute_std(1) xor P1_0;
P1_2 <= Minute_std(2) xor P1_1;
P1_3 <= Minute_std(3) xor P1_2;
P1_4 <= Minute_std(4) xor P1_3;
P1_5 <= Minute_std(5) xor P1_4;
P1   <= Minute_std(6) xor P1_5;

P2_0 <= Hour(0) xor Hour(1);
P2_1 <= Hour(1) xor P2_0;
P2_2 <= Hour(2) xor P2_1;
P2_3 <= Hour(3) xor P2_2;
P2_4 <= Hour(4) xor P2_3;
P2   <= Hour(5) xor P2_4;


P3_0  <= DATE(0) xor DATE(1);
P3_1  <= DATE(1) xor P3_0;
P3_2  <= DATE(2) xor P3_1;
P3_3  <= DATE(3) xor P3_2;
P3_4  <= DATE(4) xor P3_3;
P3_5  <= DATE(5) xor P3_4;
P3_6  <= Week_day(0) xor P3_5;
P3_7  <= Week_day(1) xor P3_6;
P3_8  <= Week_day(2) xor P3_7;
P3_9  <= Month(4) xor P3_8;
P3_10 <= Month(3) xor P3_9;
P3_11 <= Month(2) xor P3_10;
P3_12 <= Month(1) xor P3_11;
P3_13 <= Month(0) xor P3_12;
P3_14 <= Year(7) xor P3_13;
P3_15 <= Year(6) xor P3_14;
P3_16 <= Year(5) xor P3_15;
P3_17 <= Year(4) xor P3_16;
P3_18 <= Year(3) xor P3_17;
P3_19 <= Year(2) xor P3_18;
P3_20 <= Year(1) xor P3_19;
P3    <= Year(0) xor P3_20;

end Behavioral;
