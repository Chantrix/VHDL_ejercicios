library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Disene un circuito secuencial s ˜ ´ıncrono que permita controlar el funcionamiento de una maqui- ´
-- na expendedora sencilla. El usuario de la maquina puede introducir ´ unicamente monedas ´
-- de 5 centimos y 10 c ´ entimos. Cuando se introducen exactamente 15 c ´ entimos, la m ´ aquina ´
-- expendedora saca un chicle. Este sistema de control debe emitir una senal de apertura (se ˜ nal ˜
-- abrir) cuando ha detectado que se han introducido 15 centimos (una moneda de 5 c ´ entimos ´
-- y una moneda de 10 centimos, o tres monedas de 5 c ´ entimos). No hace falta que considere el ´
-- caso en el cual el importe introducido sea superior a 15 centimos. El sistema de control recibe ´
-- dos senales de entrada: ˜ cinco y diez. La senal ˜ cinco es una senal de entrada del circuito ˜
-- que tiene valor '1' durante un tiempo solo si el usuario introduce una moneda de 5 c ´ entimos. ´
-- La senal ˜ diez es una senal de entrada del circuito que tiene valor ˜ '1' durante un tiempo solo ´
-- si el usuario introduce una moneda de 10 centimos. ´
-- La entity del circuito se muestra a continuacion. ´
entity maquina is
port( abrir : out std_logic;
cinco : in std_logic;
diez : in std_logic;
reset : in std_logic;
clk : in std_logic);
end entity maquina;
-- El circuito tiene una senal de reloj ( ˜ clk), dos entradas de un bit (cinco y diez), una senal ˜
-- de reset as´ıncrona activa en '1' (reset) y una senal de salida de un bit ( ˜ abrir).
-- La senal ˜ reset es la unica se ´ nal as ˜ ´ıncrona del circuito y pone el circuito en su estado inicial.
-- Este estado inicial indica que no ha recibido ninguna moneda.
-- La senal ˜ abrir se pone a '1' solo si la m ´ aquina ha recibido exactamente 15 c ´ entimos. Esta ´
-- senal ha de permanece con el valor ˜ '1' solo durante un periodo de la se ´ nal de reloj ˜ clk.
-- Escriba en VHDL la architecture que describe el comportamiento del circuito en terminos ´
-- de una maquina de Moore. Dibuje el diagrama de estados correspondie ´ nte al circuito que ha
-- disenado.
architecture maquina of maquina is
    type estadoT is (INICIO, CINCO, DIEZ, CHICLE);
    signal estado : estadoT := INICIO;
    begin
        process (reset, clk) is
            begin
                if reset = '1' then 
                    estado <= INICIO;
                    abrir <= '0';
                elsif rising_edge(clk) then
                    case estado is
                        when INICIO => 
                        abrir <= '0';
                        if cinco = '1' then estado <= CINCO;
                        elsif diez = '1' then estado <= DIEZ;
                        end if;
                        when CINCO =>
                        abrir <= '0';
                        if cinco = '1' then estado <= DIEZ;
                        elsif diez = '1' then estado <= CHICLE;
                        end if;
                        when DIEZ =>
                        abrir <= '0';
                        if cinco = '1' then estado <= CHICLE;
                        end if;
                        when CHICLE =>
                        abrir <= '1';
                        estado <= INICIO;
                        when others => 
                        estado <= INICIO;
                    end case;
                end if;
            end process;
end architecture;
