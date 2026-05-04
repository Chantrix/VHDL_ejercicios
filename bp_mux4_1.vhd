-- banco de pruebas de mux4_1
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bp_mux4_1 is
end entity;

architecture bp_mux4_1 of bp_mux4_1 is
    --1.declaro señales
    signal y, a, b, c, d : std_logic_vector(7 downto 0);
    signal sel           : std_logic_vector(1 downto 0);
    --2.declaro componentes
    component mux4_1 is
        port(
        y           : out   std_logic_vector(7 downto 0);
        a,b,c,d    : in    std_logic_vector(7 downto 0);
        sel         : in    std_logic_vector(1 downto 0)
    );
    end component;

    begin
        --3. instancio componentes
        uut: component mux4_1 port map (y, a, b,c ,d, sel);
        --4. proceso
        gen_test: process is
            variable i  : integer;
            begin
                a <= "00000001";
                b <= "11111110";
                c <= "10101010";
                d <= "00110011";
                for i in 0 to 3 loop
                    wait for 100 ns;
                    sel <= std_logic_vector(to_unsigned(i,2));
                    end loop;
                    wait;
            end process;
end architecture;