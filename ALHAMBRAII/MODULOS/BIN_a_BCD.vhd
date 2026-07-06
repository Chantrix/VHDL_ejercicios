-- conversor de binario de 8 bits 0-255 a BCD centenas, decenas y unidades
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BIN_a_BCD is
    port(data_out    : out std_logic_vector(11 downto 0);
        data_in     : in std_logic_vector(7 downto 0));
end entity;

architecture behavioral of BIN_a_BCD is
    signal valor : integer range 0 to 255;
begin
    valor <= to_integer(unsigned(data_in));

    data_out(11 downto 8) <= std_logic_vector(to_unsigned(valor / 100,        4));
    data_out(7  downto 4) <= std_logic_vector(to_unsigned((valor mod 100)/10,  4));
    data_out(3  downto 0) <= std_logic_vector(to_unsigned(valor mod 10,        4));

end architecture;