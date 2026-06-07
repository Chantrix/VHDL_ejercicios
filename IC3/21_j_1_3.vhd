-- Escriba en VHDL la architecture de un circuito secuencial capaz de detectar cuando le llega la secuencia "00110"
-- por su entrada X. El circuito detecta secuencias no solapadas.
-- El circuito tiene una se˜nal de reloj (clk), una entrada serie de un bit (X), una se˜nal de reset as´ıncrona activa en 0
-- (reset) y una se˜nal de salida de un bit (Y). La se˜nal Y vale '1' cuando se detecta la secuencia. En cualquier otro
-- caso, la se˜nal Y tiene valor '0'. La se˜nal reset pone el circuito en su estado inicial (no se ha reconocido ning´un
-- elemento de la secuencia). Todos los cambios, salvo el reseteo del circuito, tienen lugar en el flanco de subida de
-- la se˜nal de reloj.
-- La entity del circuito se muestra a continuaci´on.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity detector is
port ( Y : out std_logic;
reset : in std_logic;
clk : in std_logic;
X : in std_logic );
end entity detector;

-- Escriba en VHDL la architecture que describe el comportamiento del circuito en t´erminos de una m´aquina de Moore.

architecture moore of detector is
    --declaro la señal de estados, de 3 bits ya que necesito 6 estados.
    -- en la maq de moore la salida depende del estado
    signal estado : std_logic_vector(2 downto 0) := "000";

    begin

        process(clk, reset) is
            begin
                
                if reset = '0' then
                    Y <= '0';
                    estado <= "000";
                elsif rising_edge(clk) then
                    case estado is 
                        when "000" =>
                            if x = '0' then
                                estado <= "001";
                            end if;
                        when "001" =>
                            if x = '0' then
                                estado <= "010";
                            else estado <= "000";
                            end if;
                        when "010" =>
                            if x = '0' then
                                estado <= "010";
                            else estado<= "011";
                            end if;
                        when "011" =>
                            if x = '0' then
                                estado <= "001";
                            else estado <= "100";
                            end if;
                        when "100" =>
                            if x = '0' then
                                estado <= "101";
                                else estado <= "000";
                            end if;
                        when "101" =>
                                estado <= "000";
                        when others => 
                            estado <= "000";
                    end case;
                end if;
            end process;
            y <= '1' when estado = "101" else '0';
end architecture;