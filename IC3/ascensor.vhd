library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Escriba la architecture que describe el comportamiento de un circuito para controlar un ascensor de una vivienda de 4 pisos (numerados de 0 a 3) como una maquina de Moore s ´ ´ıncrona,
-- con transiciones en el flanco de subida de la senal de reloj. El ascensor tiene 4 botones, uno ˜
-- por cada piso y debe ir al piso indicado por sus 4 botones. Cuando llega al piso deseado abre
-- las puertas, que permaneceran as ´ ´ı hasta que reciba otra llamada. El ascensor no tiene memoria,
-- por lo que no le afecta que se pulsen los botones mientras esta subiendo/bajando. ´
-- Las entradas del circuito controlador son: la senal ˜ piso de dos bits que indica el piso en que
-- se encuentra el ascensor (0, 1, 2 o 3 en binario), la senal de 4 bits ˜ boton que indica el piso al
-- que el usuario desea ir, la senal de reloj ˜ clk, una senal de reset as ˜ ´ıncrona (reset) y la senal ˜
-- celula que indica si existe un objeto en la puerta del ascensor. El circuito tiene dos senales ˜
-- de salida: motor y puerta.
-- La entity del circuito se muestran a continuacion. ´
entity ctrlAscensor is
port ( motor : out std_logic_vector(1 downto 0);
puerta : out std_logic;
boton : in std_logic_vector(3 downto 0);
piso : in std_logic_vector(1 downto 0);
clk, reset, celula : in std_logic );
end ctrlAscensor;
-- El significado de las senales de salida y entrada al circuito es el siguiente. ˜
-- – La senal ˜ motor tiene dos bits cuyo valor puede ser "00", "10" o "01" para parar,
-- accionar el motor para que suba o accionarlo para que baje el ascensor, respectivamente.
-- Mientras la senal ˜ motor tiene el valor "10", el motor sube el ascensor. Cuando la senal ˜
-- motor tiene el valor "01", el motor baja el ascensor. Finalmente, el motor esta parado ´
-- si la senal ˜ motor tiene el valor "00".
-- – La senal ˜ puerta esta a ´ '1' mientras la puerta del ascensor esta abierta. Cuando el valor ´
-- de la senal ˜ puerta esta a ´ '0', la puerta del ascensor esta cerrada. ´
-- – La senal ˜ boton tiene 4 bits, uno por cada piso. Solo puede tener un bit el valor uno, ´
-- siendo la posicion de dicho bit el n ´ umero del piso al que el usuario desea ir. Por ejemplo, ´
-- si boton tiene el valor "1000", quiere decir que el usuario del ascensor quiere ir al piso
-- 3. Por otro lado, si la senal ˜ boton tiene el valor "0000", quiere decir que el usuario del
-- ascensor no ha indicado el piso al que desea ir.
-- – La senal ˜ piso tiene 2 bits, indicando su valor en binario el piso en que esta el ascensor. ´
-- Por ejemplo, si piso tiene el valor "10", quiere decir que el ascensor se encuentra en
-- el piso 2.
-- – Senal de reloj ˜ clk.
-- – La senal ˜ celula esta a ´ '1' mientras la fotocelula de la puerta detecta un objeto. Si no ´
-- se detecta ningun objeto, esta se ´ nal tiene valor ˜ '0'.
-- – El circuito tiene una senal de reset ( ˜ reset) as´ıncrona activa a nivel alto. El reseteo del
-- circuito provoca que el circuito vaya as´ıncronamente al estado Inicial, que se describe a
-- continuacion. ´
-- Este circuito puede ser descrito con 4 estados: Inicial, Cerrado, Subiendo, Bajando.
-- En el estado Inicial la puerta esta abierta, el motor est ´ a parado y se guarda el piso al que el ´
-- usuario desea ir. Si el piso al que el usuario quiere ir es distinto al piso en el que estamos, se
-- pasa al estado Cerrado. Por el contrario, si el piso al que el usuario quiere ir es igual que el
-- piso en el que estamos, no hay cambio de estado.
-- En el estado Cerrado, el motor esta parado y la puerta est ´ a abierta. Se sale de este estado ´
-- cuando la fotocelula no detecta objetos en la puerta. En este caso, se pasa al ´ estado Subiendo
-- si el piso al que el usuario quiere ir es mayor que el piso en el que estamos. En caso contrario,
-- se pasa al estado Bajando.
-- En el estado Bajando, la senal ˜ motor acciona el motor para que baje y la puerta esta cerrada. ´
-- Cuando llegamos al piso deseado, se pasa al estado Inicial.
-- En el estado Subiendo, la senal ˜ motor acciona el motor para que suba y la puerta esta cerrada. ´
-- Cuando llegamos al piso deseado, se pasa al estado Inicial.

architecture ascensor of ctrlAscensor is
    type estados is (Inicial, Cerrado, Subiendo, Bajando);
    signal estado : estados := Inicial;
    function simplifica (vector : std_logic_vector(3 downto 0)) 
        return std_logic_vector(1 downto 0) is
        begin
            case vector is
                when "0001" => return "00";
                when "0010" => return "01";
                when "0100" => return "10";
                when "1000" => return "11";
                when others => return "00";
            end case;
        end function;
    begin
        process (clk, reset) is
            variable piso_obj : std_logic_vector(1 downto 0);
            begin
            if reset = '1' then 
            estado <= Inicial;
            motor <= "00";
            puerta <= '1';
            elsif rising_edge(clk) then
                case estado is
                    when Inicial =>
                        piso_obj := simplifica(boton);
                        motor <= "00"; 
                        puerta <= '1';
                        if (piso /= piso_obj)then estado <= Cerrado;
                        end if;
                    when Cerrado =>
                        motor <="00"; 
                        puerta <= '1';
                        if celula = '0' then 
                            puerta <= '0';
                            if piso < piso_obj then estado <= Subiendo;
                            elsif piso > piso_obj then estado <= Bajando;
                            end if;
                        end if;
                    when Bajando =>
                        motor <= "01";
                        puerta <= '0';
                        if piso = piso_obj then estado <= Inicial;
                        end if;
                    when Subiendo =>
                        motor <= "10";
                        puerta <= '0';
                        if piso = piso_obj then estado <= Inicial;
                        end if; 
                    when others => estado <= Inicial;
                    end case;
                end if;
            end process;
   end architecture;                         
