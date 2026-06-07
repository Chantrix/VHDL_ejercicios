library IEEE;
use ieee.std_logic_1164.all;

entity divisor_frecuencia_6 is
    port(clk6       : out std_logic;
        clk, resetn : in std_logic);
end entity;

architecture div6 of divisor_frecuencia_6 is
    type estado is (s0, s1, s2, s3, s4, s5, s6);
    signal estado_actual : estado := s0;
    begin
        process (clk, resetn) is
            begin
                if (resetn ='0') then
                    estado_actual <= s0;
                    clk6 <= '0';
                elsif rising_edge(clk) then
                    case estado_actual is
                        when s0 => estado_actual <= s1; clk6<= '1';
                        when s1 => estado_actual <= s2;
                        when s2 => estado_actual <= s3;
                        when s3 => estado_actual <= s4; clk6 <='0';
                        when s4 => estado_actual <= s5;
                        when s5 => estado_actual <= s6;
                        when s6 => estado_actual <= s1; clk6 <='1';
                        when others => estado_actual <= s0;
                    end case;
                end if;
            end process;
end architecture;