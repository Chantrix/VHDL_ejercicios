-- Escriba en VHDL la architecture que describe el comportamiento de un circuito contador
-- binario de 4 bits que opera de modo s´ıncrono en el flanco de subida de la senal de reloj ( ˜ clk).
-- El circuito tiene 5 senales de entrada de un bit y una se ˜ nal de entrada de 4 bits ( ˜ d). El circuito
-- tiene una senal de salida de 4 bits ( ˜ q). A continuacion, se muestra la ´ entity del circuito.
-- El orden de prioridad de las senales de entrada del circuito es: ˜ reset–sync_clr–load–
-- en, siendo la senal ˜ reset la mas prioritaria y la se ´ nal ˜ en la menos prioritaria. Las senales ˜
-- reset, sync_clr, load y en estan activas a nivel alto, por lo que producen cambios ´
-- en la salida del circuito solo cuando tienen valor ´ '1'. Por ejemplo, para que la senal ˜ en
-- produzca un cambio en el circuito tiene que tener un valor '1' y las senales de entrada ˜
-- reset, sync_clr y load tienen que tener valor '0'.
-- Cuando la senal ˜ reset esta activa, se produce un reseteo as ´ ´ıncrono del circuito y todos los
-- bits de la senal de salida ˜ q se ponen a cero.
-- Cuando la senal ˜ sync_clr toma el valor '1' todos los bits de la senal de salida ˜ q se ponen
-- a cero en el siguiente flanco de subida de la senal de reloj. ˜
-- Cuando la senal ˜ load toma el valor '1', se carga en la senal de salida ˜ q el valor de la senal ˜
-- de entrada d.
-- La senal ˜ en habilita la cuenta del circuito. Es decir, cuando tiene el valor '1' se incrementa
-- el valor de la senal de salida ˜ q en uno cada ciclo de reloj. Sin embargo, cuando la senal ˜ en
-- tiene el valor '0', la senal de salida ˜ q no cambia de valor.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity contador is
    port ( q                    : out std_logic_vector(3 downto 0);
            clk, reset          : in std_logic;
            sync_clr, en, load  : in std_logic;
            d                   : in std_logic_vector(3 downto 0) );
end entity contador;

architecture arch of contador is
    --para poder leer q debo usar una SEÑAL!!
    signal q_sal : std_logic_vector(3 downto 0);
    begin
        
        --proceso con clk
        process (clk, reset) is

            begin
                if reset = '1' then
                    q_sal <= "0000";
                elsif rising_edge(clk) then
                    if  sync_clr = '1' then
                        q_sal <= "0000";
                    elsif load = '1' then
                        q_sal <= d;                        
                    elsif en = '1' then
                        q_sal <= std_logic_vector(unsigned(q_sal) + 1);
                    end if;
                    end if;
        end process;
        --q se actualiza con cada cambio de q_sal
        q <= q_sal;
    end architecture;