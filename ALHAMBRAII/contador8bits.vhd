-- implemento un contador de 8 bits para cargarlo en la alhambraii
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity cont_8_b is
    port    (led       :out std_logic_vector(7 downto 0);
            clk         : in std_logic;
            but1, but2  : in std_logic);
end entity;
architecture moore of cont_8_b is
    -- constante para el numero maximo de ciclos
    --el reloj es ed 12 MH para un cambio cada 
    -- medio segundo son 6_000_000 ciclos
    constant MAXCICLOS : integer := 6_000_000;
    --un tipo para definir estados
    type estadoT is (Sinicio,Sup,Sdown);
    signal estado           : estadoT := Sinicio;
    signal estadoSig     : estadoT;
    --estado anterior del but2
    signal but2_prev    : std_logic := '0';
    --bandera para saber si sube o baja el contador led
    signal flag             : std_logic := '0';
    --señal para ir sumando (o restando) al contador
    signal luzVector : unsigned(7 downto 0) := (others => '0');

    begin
        --- proceso de reloj
        process (clk, but1) is
            -- contador de ciclos
            variable cont : integer range 0 to MAXCICLOS := 0;
            begin
                if but1 = '1' then
                    estado <= Sinicio; 
                    luzVector <=(others => '0') ;
                    cont := 0;
                elsif rising_edge(clk) then
                        but2_prev <= but2;
                    if but2 = '1' and but2_prev = '0' then
                        flag <= not flag;
                    elsif (cont = MAXCICLOS - 1) then
                        estado <= estadoSig;
                        cont := 0;
                        if flag = '0' then
                            luzVector <= luzVector +1;
                        else
                            luzVector <= luzVector -1;
                        end if;
                    else cont := cont +1;
                    end if;
                end if;
        end process;


-- proceso para decidir el estado siguiente
        SiguienteEst: process(estado, flag) is

            begin
                case estado is
                    when Sinicio => 
                        if flag ='1' then 
                            estadoSig <=  Sdown;
                        else
                            estadoSig <= Sup;
                        end if;
                    when Sup =>
                        if flag = '1' then
                            estadoSig <= Sdown;
                        else
                            estadoSig <= Sup;
                        end if;
                    when Sdown =>
                        if flag = '0' then
                            estadoSig <= Sup;
                        else
                            estadoSig <= sDown;
                        end if;
                    when others => 
                        estadoSig <= Sinicio;
                    end case;
        end process; 
        --- proceso para escribir los leds
        salida: process (estado, luzVector) is
            begin
                case estado is
                    when Sinicio =>
                    led <= (others => '0');
                    when Sup =>
                    led <= std_logic_vector(luzVector);
                    when Sdown =>
                    led <= std_logic_vector(luzVector); 
                    when others => 
                    led <= (others => '0');
                    end case;
            end process;
end architecture;