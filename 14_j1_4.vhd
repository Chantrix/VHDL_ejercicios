-- Programe en VHDL un banco de pruebas para el circuito que ha diseñado al
-- contestar a la Pregunta 3. El banco de pruebas ha de resetear el circuito y comprobar que se producen correctamente las transiciones de estado hasta alcanzar
-- el estado S5. El banco de pruebas debe comprobar que los valores de las señales
-- de salida de la UUT coinciden con los esperados, mostrando el correspondiente
-- mensaje en caso de que no coincidan. Al final del test, debe mostrarse un mensaje
-- indicando el número total de errores
entity bp_regulador is
    constant PERIODO : time := (1/60)*(10**9) ns;
    constant ts1 : integer := 60*5;
    constant ts2 : integer := 60*5;
    constant ts3 : integer := 60*45;
    constant ts4 : integer := 60*10;
    constant ts5 : integer := 60*45;
    end entity;

architecture bp_reg of bp_regulador is

    component regulador is
        port ( rv, av, vv, rp, vp : out std_logic;
        clk, reset : in std_logic );
        end component;
    signal rv, av, vv, rp, vp :  std_logic;
    signal clk :  std_logic := '0';
    signal  reset :  std_logic ;
    procedure verifica( esperado :  std_logic_vector(4 downto 0); 
                        actual : std_logic_vector(4 downto 0);
                        numErr : inout integer) is
        begin
            if (actual /= esperado) then
                report "Error la señal esperada: " 
                & std_logic'image(esperado(4)) 
                & std_logic'image(esperado(3)) 
                & std_logic'image(esperado(2)) 
                & std_logic'image(esperado(1)) 
                & std_logic'image(esperado(0)) 
                & " es diferente de la señal obtenida: "
                & std_logic'image(actual(4)) 
                & std_logic'image(actual(3)) 
                & std_logic'image(actual(2)) 
                & std_logic'image(actual(1)) 
                & std_logic'image(actual(0)) 
                ;
                numErr := numErr +1;
            end if;
    end procedure;
    begin
        uut : component regulador port map(rv, av, vv, rp, vp, clk, reset);
        reset <= '1' , '0' after PERIODO/4;
        clk <= not clk after PERIODO/2;
        gen_test : process is
            variable numErr : integer := 0;
            begin
                report "comienza la simulación";
                wait for PERIODO/10;
                verifica ("01010",rv&av&vv&rp&vp, numErr);
                wait for PERIODO;
                verifica ("01010",rv&av&vv&rp&vp, numErr);
                wait for ts1 * PERIODO;
                verifica ("10010",rv&av&vv&rp&vp, numErr);
                wait for ts2 * PERIODO;
                verifica ("10001",rv&av&vv&rp&vp, numErr);
                wait for ts3 * PERIODO;
                verifica ("10010",rv&av&vv&rp&vp, numErr);
                wait for ts4 * PERIODO;
                verifica ("00110",rv&av&vv&rp&vp, numErr);
                wait for ts5 * PERIODO;
                verifica ("01010",rv&av&vv&rp&vp, numErr);
                report "test finalizado";
                if (numErr = 0) then
                    report "ningun error de simulación.";
                else 
                    report "HAn ocurrido: " &
                    integer'image(numErr) &
                    " errores.";
                end if;
                wait;
        end process;
            end architecture;
                     