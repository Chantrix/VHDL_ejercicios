-- Ejercicio 5: Máquina de Moore — Detector de secuencia "101"
-- Diseña una FSM de Moore que detecte la secuencia "101" en una entrada serie:
-- Entradas: clk, rst (reset asíncrono), x (entrada serie, 1 bit)
-- Salida: det (1 bit), vale '1' cuando se han recibido 1, 0, 1 consecutivos
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity detector_101 is
    port(
        det         : out   std_logic;
        clk, rst,x  : in    std_logic
    );
end entity;

architecture moore of detector_101 is
    constant s0     : std_logic_vector(1 downto 0) :="00";
    constant s1     : std_logic_vector(1 downto 0) :="01";
    constant s2     : std_logic_vector(1 downto 0) := "10";
    constant s3     : std_logic_vector(1 downto 0) := "11";
    signal estado   : std_logic_vector(1 downto 0);
    begin
        process (clk,rst) is
            begin

                if rst = '1' then
                    estado <= s0;
                elsif rising_edge(clk) then
                    case estado is
                        when s0 =>
                        if x ='1' then
                            estado <= s1;
                        end if;
                        when s1 =>
                        if x ='0' then
                            estado <= s2;
                        end if;
                        when s2 =>
                            if x ='0' then
                                estado <= s0;
                            elsif x = '1' then
                                estado <= s3;
                            end if;
                        when s3 =>
                        if x ='0' then
                            estado <= s2;
                        elsif x = '1' then
                            estado <= s1; 
                        end if;
                        when others =>
                        estado <= s0; 
                end case;
            end if;
            end process;
            det <= '1' when (estado = s3) else '0';
    end architecture;

    architecture mealy of detector_101 is
        constant s0     : std_logic_vector(1 downto 0) :="00";
        constant s1     : std_logic_vector(1 downto 0) :="01";
        constant s2     : std_logic_vector(1 downto 0) := "10";
        signal estado   : std_logic_vector(1 downto 0);

        begin
            process (rst, clk) is
                begin
                    if rst = '1' then
                        estado <= s0;
                    elsif rising_edge(clk) then
                        case estado is
                            when s0 =>
                            if x = '1' then
                                estado <= s1;
                            end if;
                            when s1 =>
                            if x = '0' then
                                estado <= s2;
                            end if;
                            when s2 =>
                            if x = '0' then
                                estado <= s0;
                            elsif x = '1' then
                                estado <= s1;
                            end if;
                            when others =>
                            estado <= s0;
                        end case;
                    end if;
            end process;
            det <= '1' when (estado = s2 and x = '1') else '0';
    end architecture;

configuration cfg_moore of bp_detector is
	for bp_test
		for uut : detector_101
			use entity work.detector_101(moore);
		end for;
	end for;
end configuration;