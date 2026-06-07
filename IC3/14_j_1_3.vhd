
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Diseñe un circuito secuencial síncrono para la regulación de un paso de peatones.
-- El paso de peatones tiene dos semáforos: el semáforo de los vehículos y el semáforo de los peatones. El semáforo de los vehículos tiene tres lámparas: verde,
-- amarillo y rojo. El semáforo de los peatones tiene dos lámparas: verde y rojo. La
-- entity del circuito se muestra a continuación.
entity regulador is
port ( rv, av, vv, rp, vp : out std_logic;
clk, reset : in std_logic );
end regulador;
-- Las entradas al circuito son la señal de reloj (clk) de 60 Hz y la señal de reset
-- (reset) asíncrona y activa a nivel alto. Las señales de salida rv, av, vv, rp, vp
-- controlan, respectivamente, las lámparas roja, amarilla y verde del semáforo de
-- vehículos y las lámparas roja y verde del semáforo de peatones. La lámpara está
-- encendida cuando la señal que controla dicha lámpara está a ‘1’ y está apagada
-- cuando está a ‘0’.
-- El circuito funciona como una máquina de 6 estados cuyo diagrama de estados
-- se muestra en la siguiente figura. Las transiciones entre estados se producen en el
-- flanco de subida de la señal de reloj. En cada estado se indican las únicas señales
-- de salida que valen ‘1’ en dicho estado.
-- 6 Dpto. de Informática y Automática, UNED
-- – Mientras la señal de reset esté a ‘1’ el circuito permanece en el estado S0.
-- En el estado S0 sólo están encendidas la lámpara amarilla del semáforo de
-- vehículos y la roja del semáforo de peatones.
-- – En el estado S1 permanece un tiempo tS1 (5 s) y sólo están encendidas
-- la lámpara amarilla del semáforo de vehículos y la roja del semáforo de
-- peatones.
-- – En el estado S2 permanece un tiempo tS2 (5 s) y sólo están encendidas la
-- lámpara roja del semáforo de vehículos y la roja del semáforo de peatones.
-- – En el estado S3 permanece un tiempo tS3 (45 s) y sólo están encendidas la
-- lámpara roja del semáforo de vehículos y la verde del semáforo de peatones.
-- – En el estado S4 permanece un tiempo tS4 (10 s) y sólo están encendidas la
-- lámpara roja del semáforo de vehículos y la roja del semáforo de peatones.
-- – En el estado S5 permanece un tiempo tS5 (45 s) y sólo están encendidas la
-- lámpara verde del semáforo de vehículos y la roja del semáforo de peatones.
-- Escriba el código VHDL de la architecture que describe el comportamiento
-- del circuito siguiendo el diagrama de estados mostrado anteriormente.
architecture sem of regulador is
    constant ts1 : integer := 60*5;
    constant ts2 : integer := 60*5;
    constant ts3 : integer := 60*45;
    constant ts4 : integer := 60*10;
    constant ts5 : integer := 60*45;
    type estadoT is (s0,s1,s2,s3,s4,s5);
    signal estado, prox_estado : estadoT;
    signal timer, ciclo : integer;
    begin 
        process(estado) is
            begin
                rv<='0';av<='0';vv<='0';rp<='0';vp<='0';
                case estado is
                    when s0 => av<='1';rp<='1';prox_estado<=s1;timer<=0;
                    when s1 => av<='1';rp<='1';prox_estado<=s2;timer<=ts1;
                    when s2 => rv<='1';rp<='1';prox_estado<=s3;timer<=ts2;
                    when s3 => rv<='1';vp<='1';prox_estado<=s4;timer<=ts3;
                    when s4 => rv<='1';rp<='1';prox_estado<=s5;timer<=ts4;
                    when s5 => vv<='1';rp<='1';prox_estado<=s1;timer<=ts5;
                    when others => prox_estado<=s0;
                end case;
            end process;

        process(reset, clk) is
            begin 
                if reset = '1' then estado <= s0;ciclo <= 0;
                elsif rising_edge(clk) then
                    ciclo <= ciclo +1;
                    if ciclo = timer then
                        estado <= prox_estado;
                        ciclo <= 0;
                    end if;
                end if;
            end process;
    end architecture;