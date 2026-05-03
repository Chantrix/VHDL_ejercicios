library IEEE;
use  IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador_4_bits is
    port(   q            : out std_logic_vector(3 downto 0);
            clk, en, rst : in std_logic);
end entity;

architecture arch of contador_4_bits is
begin
    process (clk, rst) is
        variable q_test : unsigned(3 downto 0);
    begin
        if rst = '1' then
            q_test := "0000";
        elsif rising_edge(clk) then
            if en = '1' then
                if q_test = 9 then
                    q_test := "0000";
                else
                    q_test := q_test + 1;
                end if;
            end if;
        end if;
        q <= std_logic_vector(q_test);
    end process;
end architecture;