-- Este circuito realiza la comparación de las señales de 8 bits a y b. Estas señales
-- son interpretadas como números binarios con o sin signo dependiendo del valor
-- de la señal de entrada sel. Si sel=’1’, se realiza la comparación entre a y b
-- interpretándolos como números binarios con signo. Por el contrario, si sel=’0’
-- la comparación entre a y b se hace interpretándolos como números binarios sin
-- signo. El circuito tiene tres salidas, x1, x2 y x3 que valen ‘1’ sólo en el caso de que
-- a > b, a = b y a < b, respectivamente. A continuación se muestra la entity del
-- circuito incluyendo la declaración de las únicas librerías que se han de usar en el
-- diseño.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity comparador is port
( x3, x2, x1 : out std_logic;
a, b : in std_logic_vector(7 downto 0);
sel : in std_logic );
end entity comparador;
architecture comp of comparador is
    begin
        process(a, b, sel) is
            begin
                if sel = '0' then
                    if unsigned(a) > unsigned(b) then x3 <= '1';x2 <= '0';x1 <= '0';
                    elsif unsigned(a) < unsigned(b) then x3 <= '0';x2 <= '0';x1 <= '1';
                    else x3 <= '0';x2 <= '1';x1 <= '0';
                    end if;
                else
                    if signed(a) > signed(b) then x3 <= '1';x2 <= '0';x1 <= '0';
                    elsif signed(a) < signed(b) then x3 <= '0';x2 <= '0';x1 <= '1';
                    else x3 <= '0';x2 <= '1';x1 <= '0';
                    end if;
                end if;
            end process;
        end architecture;