-- Escriba en VHDL la architecture de un circuito combinacional que tiene dos se˜nales de entrada y una se˜nal de
-- salida. Las se˜nales de entrada son: la se˜nal de 1 bit En y la se˜nal de 4 bits xnum. La se˜nal de salida tiene 1 bit y
-- se llama y.
-- Si la se˜nal de entrada En tiene valor '1', entonces la se˜nal de salida y toma siempre el valor '0'. Si la se˜nal de
-- entrada En tiene valor '0', entonces la se˜nal de salida y toma el valor '1' si y solo si la se˜nal de entrada xnum
-- tiene el valor decimal 0, 4, 8, 9, 12 o 13. En cualquier otro caso, la se˜nal de salida y tiene valor '0'. La se˜nal
-- xnum(3:0) representa un n´umero binario sin signo siendo el bit 3 el m´as significativo.
--Emplee en el dise˜no un bloque process con una sentencia case.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Circuito2 is
    port( y: out std_logic;
    En: in std_logic;
    xnum: in std_logic_vector ( 3 downto 0));
    end entity Circuito2;

architecture case_proc of Circuito2 is

    begin

        process (xnum, en) is
            variable vnum : std_logic_vector( 4 downto 0);
        begin
            vnum := En & xnum;
                case to_integer(unsigned(vnum)) is
                    when 0 | 4 | 8 | 9 | 12 | 13 => y <= '1';
                    when others => y <= '0';
            end case;
        end process;
    end architecture;