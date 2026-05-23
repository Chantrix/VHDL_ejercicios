-- Disene un circuito secuencial s ˜ ´ıncrono, que opere en el flanco de subida de la senal de reloj ˜
-- para el control de dos semaforos que est ´ an situados en un cruce, apuntando el sem ´ aforo 1 en ´
-- una direccion y el sem ´ aforo 2 en otra direcci ´ on. El circuito tiene como se ´ nal de entrada la ˜
-- senal de reloj de 1 bit ˜ clk y la senal de 1 bit ˜ stdby. La senal de reloj de entrada al circuito ˜
-- tiene 60 Hz, por lo que en cada segundo se contabilizan 60 flancos de subida de dicha senal. El ˜
-- circuito tiene 6 senales de salida de 1 bit: ˜ r1, y1, g1, r2, y2, g2 para poner en rojo, amarillo
-- o verde los semaforos 1 o 2, respectivamente. ´
-- La entity del circuito se muestra a continuacion. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regulador is
port ( r1, y1, g1, r2, y2, g2 : out std_logic;
clk, stdby : in std_logic );
end regulador;
-- El circuito tiene los cinco estados de operacion descritos a continuaci ´ on. En cada estado se ´
-- indican las unicas se ´ nales de salida que han de tener valor ˜ '1' en dicho estado, teniendo que
-- tener el resto de senales de salida el valor ˜ '0'.
-- – Estado YY: semaforo 1 en amarillo ( ´ y1='1') y semaforo 2 en amarillo ( ´ y2='1'). Este
-- es el estado con que se inicializa el circuito. Se pasa a este estado de modo as´ıncrono
-- (desde cualquier otro estado) en cuanto se detecta que la senal ˜ stdby tiene el valor
-- '1'. El circuito permanece en este estado mientras que la senal ˜ stdby tenga el valor
-- '1'. Cuando la senal ˜ stdby toma el valor '0', se pasa al estado RY.
-- – Estado RY: semaforo 1 en rojo ( ´ r1='1') y semaforo 2 en amarillo ( ´ y2='1'). El
-- circuito permanece en este estado 5 s, pasando transcurrido este tiempo al estado GR.
-- – Estado GR: semaforo 1 en verde ( ´ g1='1') y semaforo 2 en rojo ( ´ r2='1'). El circuito
-- permanece en este estado 45 s, pasando transcurrido este tiempo al estado YR.
-- – Estado YR: semaforo 1 en amarillo ( ´ y1='1') y semaforo 2 en rojo ( ´ r2='1'). El
-- circuito permanece en este estado 5 s, pasando transcurrido este tiempo al estado RG.
-- – Estado RG: semaforo 1 en rojo ( ´ r1='1') y semaforo 2 en verde ( ´ g2='1'). El circuito
-- permanece en este estado 30 s, pasando transcurrido este tiempo al estado RY.
-- El circuito se ha de disenar como una m ˜ aquina de Moore que opera en el flanco de subida de ´
-- la senal de reloj. Escriba el c ˜ odigo VHDL de la ´ architecture que describe el comportamiento
-- del circuito.
architecture arch of regulador is
    --defino un tipo para los estados
    type estadoT is (YY, RY, YR, RG, GR);
    signal estado : estadoT := YY;
    signal estado_prox : estadoT := YY;
    signal temporizador : integer :=0;
begin
    --proceso sincrono
    process (clk, stdby) is
        variable ciclos : integer := 0;
        begin
            if stdby = '1' then
                estado <= YY;
                ciclos := 0;
            elsif rising_edge(clk) then
                ciclos := ciclos +1;
                if ciclos >= temporizador then
                    estado <= estado_prox;
                    ciclos := 0;
                end if;
            end if;
        end process;
     --proceso asincrono debe cambiar de estado despues del tiempo necesario
     tiempos : process(estado, stdby) is
        begin
        case estado is
            when YY =>
                y1 <= '1';y2 <= '1';
                r1 <= '0'; r2 <= '0';
                g1 <= '0'; g2 <= '0';
                if stdby = '0' then 
                temporizador <= 0;
                estado_prox <= RY;
                end if;
                when RY => 
                y1 <= '0';y2 <= '1';
                r1 <= '1'; r2 <= '0';
                g1 <= '0'; g2 <= '0';
                temporizador <= (60*5) ;
                estado_prox <= GR;
            when GR => 
                y1 <= '0';y2 <= '0';
                r1 <= '0'; r2 <= '1';
                g1 <= '1'; g2 <= '0';
                temporizador <= (60*45);
                estado_prox <= YR;
            when YR =>
                y1 <= '1';y2 <= '0';
                r1 <= '0'; r2 <= '1';
                g1 <= '0'; g2 <= '0';
                temporizador <= (60*5);
                estado_prox <= RG;
            when RG =>
                y1 <= '0';y2 <= '0';
                r1 <= '1'; r2 <= '0';
                g1 <= '0'; g2 <= '1';
                temporizador <= (60*30);
                estado_prox <= RY;
            when others => 
            estado_prox <= YY;
            temporizador <= 0;
        end case;
    end tiempos;
end arch ; -- arch