-- Escriba el código VHDL de la architecture que describe el comportamiento de
-- un circuito contador binario de 3 bits cuya salida sigue cíclicamente la secuencia
-- “000”, “011”, “110”, 101” y “111”, con señal de reset asíncrona activa a nivel alto.
-- La entity del circuito se muestra a continuación.
library ieee; use ieee.std_logic_1164.all;
entity contador is
port ( count : out std_logic_vector (2 downto 0);
clk, reset : in std_logic );
end contador;
-- Las entradas al circuito son la señal de reloj (clk) y la señal de reset asíncrono
-- activo a nivel alto (reset). La salida del circuito contador es la señal de 3 bits
-- count.
-- El funcionamiento del circuito debe ser el siguiente:
-- – Reset asíncrono activo a nivel alto. Cuando reset pasa a valer ’1’, el contador
-- se pone al valor “000”.
-- – Cuenta síncrona. Mientras reset vale ’0’, el contador pasa en cada flanco
-- de subida de la señal de reloj por la secuencia “000”, “011”, “110”, “101” y
-- “111”.
-- El diseño debe realizarse describiendo el comportamiento del circuito en términos de una máquina de Moore.
architecture moore of contador is
    type estadoT is (s0, s1, s2, s3, s4);
    signal estado : estadoT := s0;
    begin
        process(clk, reset) is
            begin
                if reset = '1'then
                    estado <= s0;
                elsif rising_edge(clk) then
                    case estado is
                        when s0 => estado <= s1;
                        when s1 => estado <= s2;
                        when s2 => estado <= s3;
                        when s3 => estado <= s4;
                        when s4 => estado <= s0;
                        when others => estado <= s0;
                    end case;
                end if;
            end process;
       count <= "000" when estado = s0 else
                "011" when estado = s1 else
                "110" when estado = s2 else
                "101" when estado = s3 else
                "111" ;
    end architecture;