-- Escriba en VHDL la architecture que describe el comportamiento de un circuito combinacional rotador a la
-- izquierda/derecha. El circuito ha de rotar la se˜nal de entrada de 0 a 3 bits. En la descripci´on del circuito no se
-- pueden emplear ni operadores ni funciones de desplazamiento l´ogico.
-- La entity del circuito se muestra a continuaci´on.
-- La se˜nal de entrada a se rota un determinado n´umero de bits. El valor de la se˜nal ctrl indica el n´umero de
-- bits a rotar. Cuando la se˜nal dir tiene valor '1' la rotaci´on se produce a la derecha, y cuando tiene valor '0' a la
-- izquierda.
-- Emplee en el dise˜no un bloque process con una sentencia if.
library ieee;
use ieee.std_logic_1164.all;

entity rotador is
port ( y : out std_logic_vector(7 downto 0);
dir: in std_logic;
a : in std_logic_vector(7 downto 0);
ctrl : in std_logic_vector(1 downto 0) );
end entity rotador;

architecture if_proc of rotador is

    begin
        process (dir, a , ctrl) is
            --se combinan en una variable dir y ctrl
            variable vdir : std_logic_vector(2 downto 0);
            begin
                vdir := dir & ctrl;
                --ahora solo quedan 6 casos de if
                if vdir = "001" then
                    --representar bien la rotacion
                    y <= a(6 downto 0) & a(7);
                elsif vdir = "010" then
                    y <= a(5 downto 0) & a(7 downto 6);
                 elsif vdir = "011" then
                     y <= a(4 downto 0) & a(7 downto 5);
                 elsif vdir = "101" then
                     y <= a(0) & a(7 downto 1);
                elsif vdir = "110" then
                    y <= a(1 downto 0) & a(7 downto 2);
                elsif vdir = "111" then
                    y <= a(2 downto 0) & a(7 downto 3);
                else y <= a;

                end if;
            end process;
    end architecture;

--Emplee en el dise˜no un bloque process con una sentencia case.

architecture case_proc of rotador is

    begin
        process (dir, a, ctrl) is
            variable vdir : std_logic_vector(2 downto 0);
            begin
                vdir := dir & ctrl;
                case vdir is
                    when "001" =>
                        y <= a(6 downto 0) & a (7);
                    when "010" =>
                        y <= a(5 downto 0) & a (7 downto 6);
                    when "011" =>
                        y <= a(4 downto 0) & a (7 downto 5);
                    when "101" =>
                        y <= a(0) & a (7 downto 1);
                    when "110" =>
                        y <= a(1 downto 0) & a (7 downto 2);
                    when "111" =>
                        y <= a(2 downto 0) & a (7 downto 3);
                    when others => y <= a;

                end case;
        end process;
end architecture;

--Emplee en el dise˜no una sentencia concurrente when–else

architecture when_else of rotador is
    begin
        y <= a(6 downto 0) & a(7) when (dir &c trl = "001") else
             a(5 downto 0) & a(7) & a(6) when (dir & ctrl = "010") else
             a(4 downto 0) & a(7 downto 5) when (dir & ctrl = "011") else
             a(0) & a(7 downto 1) when (dir & ctrl = "101") else
             a(1) & a(0) & a(7 downto 2) when (dir & ctrl = "110") else
             a(2 downto 0) & a(7 downto 3) when (dir & ctrl = "111") else
             a;
    end architecture;

    --Emplee en el dise˜no una sentencia concurrente with–select.
architecture w_sel of rotador is
    signal vdir : std_logic_vector(2 downto 0);
    begin
        vdir <= (dir & ctrl); 
        with vdir select
        y <=    a(6 downto 0) & a(7) when "001",
                a(5 downto 0) & a(7) & a(6) when  "010",
                a(4 downto 0) & a(7 downto 5) when "011",
                a(0) & a(7 downto 1) when "101",
                a(1) & a(0) & a(7 downto 2) when "110",
                a(2 downto 0) & a(7 downto 3) when "111",
                a when others;

end architecture;