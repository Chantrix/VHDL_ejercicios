library ieee;
use ieee.std_logic_1164.all;

entity flip_flop_D is
    port(Q         : out std_logic;
        d, en,  set, clk, clear : in std_logic);
end entity;
architecture ffD of flip_flop_D is
    begin
        process( clk, clear, set) is
           begin 
            if set = '1' then
                Q <= '1';
            elsif clear = '1' then
                Q <= '0';
            elsif rising_edge(clk) then
                if en = '1' then Q <= d;
                end if;
            end if;
        end process;
                end architecture;