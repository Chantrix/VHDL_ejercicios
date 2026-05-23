library ieee;
use ieee.std_logic_1164.all;

-- Escriba en VHDL un banco de pruebas que permita comprobar mediante inspeccion visual ´
-- el comportamiento del circuito contador de la Pregunta 2. El banco de pruebas debe realizar
-- consecutivamente los siguientes pasos:
-- Primero, realiza un reseteo del circuito entre los instantes 25 ns y 125 ns.
-- Despues, genera los flancos necesarios de la se ´ nal de reloj para que el circuito cambie de ˜
-- valor 6 veces. Deben transcurrir 100 ns entre cada flanco de subida de la senal de reloj. ˜
-- No realiza mas cambios en la se ´ nal de reloj y muestra el mensaje: ˜
-- "Simulacion finalizada".
entity bp_gcc_2 is
    constant PERIODO : time := 100 ns;
end entity;

architecture bp of bp_gcc_2 is
    component gcc_2 is 
        port(count      : out std_logic_vector(1 downto 0);
            reset_n, clk : in std_logic);
    end component;
    signal count : std_logic_vector(1 downto 0);
    signal reset_n : std_logic;
    signal clk : std_logic := '0' ;

    begin
        uut: component gcc_2 port map(count, reset_n, clk);
        gen_test : process is
            begin
                wait for PERIODO/4;
                reset_n <= '0';
                wait for PERIODO;
                reset_n <= '1';
                for i in 0 to 5 loop
                    clk <= '0';
                    wait for PERIODO/2;
                    clk <= '1';
                    wait for PERIODO/2;
                end loop;
                report "Simulacion Finalizada";
                wait;
            end process;
end architecture; 