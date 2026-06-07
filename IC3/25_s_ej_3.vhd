-- Escriba en VHDL la architecture que describe el comportamiento de un circuito combinacional que tiene como senal de salida el n ˜ umero de ceros que contiene la se ´ nal de entrada de ˜
-- izquierda a derecha hasta que se encuentra el primer uno. La entity del circuito se muestra a
-- continuacion. ´
library ieee;
use ieee.std_logic_1164.all;

entity numCeros is
port( Y : out std_logic_vector(3 downto 0);
X : in std_logic_vector(7 downto 0) );
end entity numCeros;
-- El circuito tiene una senal de entrada de ocho bits ( ˜ X) y una senal de salida de cuatro bits ( ˜ Y).
-- La senal ˜ Y indica en binario sin signo el numero de bits que tiene la entrada ´ X con valor '0'
-- hasta que se encuentra el primer bit con valor '1', empezando a revisar los bits de la senal ˜ X
-- de izquierda a derecha. Por ejemplo, cuando la senal ˜ X tiene el valor "00100101", la senal ˜
-- Y tiene el valor "0010" que se corresponde con el valor decimal 2.
architecture numceros of numCeros is
    begin
    process (x) is
        begin
            if (x(7)= '1') then
                y <= "0000";
            elsif x(7 downto 6) = "01" then
                y <= "0001";
            elsif x(7 downto 5) ="001" then
                y <= "0010";
            elsif x(7 downto 4) = "0001" then
                y <= "0011";
            elsif x(7 downto 3) = "00001" then
                y <= "0100";
            elsif x(7 downto 2) = "000001" then
                y <= "0101";
            elsif x(7 downto 1) = "0000001" then
                y <= "0110";
            elsif x(7 downto 0) = "00000001" then
                y <= "0111";
            else
                y <= "1000";
            end if;
        end process;
end architecture;
