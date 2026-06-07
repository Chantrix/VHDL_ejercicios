library ieee;
use ieee.std_logic_1164.all;

entity latchD is 
    port( Q   :out std_logic;
        d, en     : in std_logic);
end entity;

architecture latchD of latchD is
    begin
        process (en, d) is
            begin
                if en = '1' then 
                    Q <= d;
                end if;
        end process;
    end architecture;

entity bp_latchD is 
end entity;

architecture bp_latchD of bp_latchD is
    signal Q, d, en : std_logic;
    component latchD is
        port( Q   :out std_logic;
        d, en     : in std_logic);
    end component;
    begin
        uut : componen
                                                                                                       t latchD port map(Q, d, en);
        gne_test : process is

            begin
                wait for 100 ns;
                en <= '0';
                wait for 100 ns;
                en <= '1';
                d <= '1';
                wait for 100 ns;
                d <= '0';
                wait for 100 ns;
                en <= '0';
                d <= '1';
                wait;
        end process;
            end architecture;
