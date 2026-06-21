-- implemento un contador de 8 bits para cargarlo en la alhambraii
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity cont_8_b is
    port    (led       :out std_logic_vector(7 downto 0);
            display     : out std_logic_vector(3 downto 0);
            segmentos   : out std_logic_vector(6 downto 0);
            clk         : in std_logic;
            but1, but2  : in std_logic);
end entity;
architecture moore of cont_8_b is
    -- constante para el numero maximo de ciclos
    --el reloj es ed 12 MH para un cambio cada 
    -- medio segundo son 6_000_000 ciclos
    constant MAXCICLOS     : integer := 6_000_000;
    -- ~1ms por digito a 12MHz → refresco total ~250Hz (4 digitos)
    constant MAXCICLOS_MUX : integer := 12_000;
    --un tipo para definir estados
    type estadoT is (Sinicio,Sup,Sdown);
    signal estado           : estadoT := Sinicio;
    signal estadoSig        : estadoT;
    --estado anterior del but2
    signal but2_prev        : std_logic := '0';
    --bandera para saber si sube o baja el contador led
    signal flag             : std_logic := '0';
    --señal para ir sumando (o restando) al contador
    signal luzVector        : unsigned(7 downto 0) := (others => '0');
    --señal para pasar numeros decimales
    signal centenas, decenas, unidades : integer;
    -- digito activo del mux (0..3)
    signal digito           : unsigned(1 downto 0) := "00";

    --funcion que dado un digito devuelve la salida necesaria en display de 7 segmentos
    function sieteSeg (numero : integer) return std_logic_vector is
        begin
            case numero is
                when 0 => return "1111110";
                when 1 => return "0110000";
                when 2 => return "1101101";
                when 3 => return "1111001";
                when 4 => return "0110011";
                when 5 => return "1011011";
                when 6 => return "1011111";
                when 7 => return "1110000";
                when 8 => return "1111111";
                when 9 => return "1110011";
                when others => return "0000001";
            end case;
    end function;
            

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

        -- asignaciones concurrentes: descompone el valor en digitos decimales
        centenas <= to_integer(luzVector) / 100;
        decenas  <= (to_integer(luzVector) mod 100) / 10;
        unidades <= to_integer(luzVector) mod 10;

        -- proceso secuencial: avanza el digito activo cada MAXCICLOS_MUX ciclos
        mux_timer: process(clk) is
            variable cont_mux : integer range 0 to MAXCICLOS_MUX := 0;
            begin
                if rising_edge(clk) then
                    if cont_mux = MAXCICLOS_MUX - 1 then
                        cont_mux := 0;
                        digito <= digito + 1;  -- rota 00→01→10→11→00 automaticamente
                    else
                        cont_mux := cont_mux + 1;
                    end if;
                end if;
        end process;

        -- proceso combinacional: selecciona display y segmentos segun digito activo
        -- CC active-low one-hot: el bit en 0 activa ese digito
        --   "1110"=dig0(unidades) "1101"=dig1(decenas)
        --   "1011"=dig2(centenas) "0111"=dig3(apagado, max 255)
        mux_salida: process(digito, centenas, decenas, unidades) is
            begin
                case digito is
                    when "00" => display <= "1110"; segmentos <= sieteSeg(unidades);
                    when "01" => display <= "1101"; segmentos <= sieteSeg(decenas);
                    when "10" => display <= "1011"; segmentos <= sieteSeg(centenas);
                    when others => display <= "0111"; segmentos <= "0000000";
                end case;
        end process;

end architecture;