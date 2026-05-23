-- Escriba en VHDL la architecture que describe el comportamiento de un circuito
-- contador de c´odigo Gray de dos bits con se˜nal de reset as´ıncrono (reset_n) activa a
-- nivel bajo que pone la cuenta al valor "00". El circuito hace una cuenta ascendente
-- y posteriormente una cuenta descendente. Es decir, la se˜nal de salida (count) del
-- contador de c´odigo Gray ha de pasar en cada flanco de subida de la se˜nal de reloj
-- (clk) de forma c´ıclica consecutivamente por los valores "00", "01", "11", "10",
-- "11","01". A continuaci´on, se muestran la entity del circuito.
library ieee;
use ieee.std_logic_1164.all;

entity gcc_2 is
port ( count : out std_logic_vector(1 downto 0);
reset_n, clk : in std_logic );
end entity gcc_2;

architecture gcc_2 of gcc_2 is
    type estadoT is (s0, s1, s2, s3, s4, s5);
    signal estado : estadoT := s0;
    begin
        process (reset_n, clk) is
            begin
            if reset_n = '0' then 
                estado <= s0; count <= "00";
            elsif rising_edge(clk) then
                case estado is
                    when s0 => count <= "00"; estado <= s1;
                    when s1 => count <= "01"; estado <= s2;
                    when s2 => count <= "11"; estado <= s3;
                    when s3 => count <= "10"; estado <= s4;
                    when s4 => count <= "11"; estado <= s5;
                    when s5 => count <= "01"; estado <= s0;
                    when others => count <= "00"; estado <= s0;
                end case;
            end if;
        end process;
end architecture;
