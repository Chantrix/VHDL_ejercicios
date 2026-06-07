
library ieee;
use ieee.std_logic_1164.all;

entity cont_4 is
    port(Q         : out std_logic_vector(1 downto 0);
        c, clk, reset : in std_logic);
end entity;

architecture moore of cont_4 is
    type estadoT is ( S0, S1, S2, S3, S4);
    signal estado : estadoT := S0;
    begin
        process(reset, clk, c) is
           begin 
            if reset = '1' then
                Q <= "00";
                estado <= S0;
            elsif rising_edge(clk) then
                if c = '0' then
                    case estado is
                        when S0 => Q <= "00"; estado <= S1 ;
                        when S1 => Q <= "01"; estado <= S2 ;
                        when S2 => Q <= "10"; estado <= S3 ;
                        when S3 => Q <= "11"; estado <= S0 ;
                        when others => estado <= S0;
                    end case;
                end if;
                end if;
        end process;
                end architecture;