library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
 
entity DEC_TO_BCD is
    port(
        BINARY_IN: in std_logic_vector(7 downto 0);
        BCD_0,BCD_1: out std_logic_vector(3 downto 0)
    );
end DEC_TO_BCD;
 
architecture behaviour of DEC_TO_BCD is 
    signal BINARY_UN: unsigned (7 downto 0);
    signal DISPLAY_0: unsigned (7 downto 0);
    signal DISPLAY_1: unsigned (7 downto 0);

begin
BINARY_UN <= unsigned(BINARY_IN); 
DISPLAY_0 <= (BINARY_UN rem 10);
DISPLAY_1 <= (BINARY_UN / 10);
 
BCD_0 <= std_logic_vector(DISPLAY_0(3 downto 0)); 
BCD_1 <= std_logic_vector(DISPLAY_1(3 downto 0)); 
end behaviour;