-- modulo que convierte numeros a salida de 
--display de 7 segmentos
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BCD_a_7seg is
    port(
        abcdefgp     : out std_logic_vector(7 downto 0);
        bits_in     : in  std_logic_vector(3 downto 0));
end entity;

architecture behavioral of BCD_a_7seg is
    begin
        process (bits_in) is
        begin
            case bits_in is
                when "0000" => abcdefgp <= "11111100"; -- 0: a,b,c,d,e,f
                when "0001" => abcdefgp <= "01100000"; -- 1: b,c
                when "0010" => abcdefgp <= "11011010"; -- 2: a,b,d,e,g
                when "0011" => abcdefgp <= "11110010"; -- 3: a,b,c,d,g
                when "0100" => abcdefgp <= "01100110"; -- 4: b,c,f,g
                when "0101" => abcdefgp <= "10110110"; -- 5: a,c,d,f,g
                when "0110" => abcdefgp <= "10111110"; -- 6: a,c,d,e,f,g
                when "0111" => abcdefgp <= "11100000"; -- 7: a,b,c
                when "1000" => abcdefgp <= "11111110"; -- 8: todos
                when "1001" => abcdefgp <= "11110110"; -- 9: a,b,c,d,f,g
                when others => abcdefgp <= "00000000";
            end case;
        end process;
end architecture;