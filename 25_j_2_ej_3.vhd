library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bp_circ is
    end entity;

architecture bp_circ of bp_circ is
    component circ is
        port(y      : out std_logic;
            x       : in std_logic_vector(2 downto 0));
            end component;
        signal y : std_logic;
        signal x : std_logic_vector(2 downto 0);
        begin
            uut : component circ port map (y, x);
            gen_test : process is
                variable test : unsigned(2 downto 0):= "000";
                begin
                    for i in 0 to 7 loop
                        x(2)<= test(2);
                        x(1)<= test(1);
                        x(0)<= test(0);
                        wait for 100 ns;
                        if y='1' then
                            assert (x="000") or (x="001") or (x="110")
                            report "error en " & x(2)'image 
                            & x(1)'image & x(0)'image;
                        else
                            assert not((x="000") or (x="001") or (x="110"))
                            report "error en " & x(2)'image 
                            & x(1)'image & x(0)'image;
                            end if;
                        test := test +1;
                    end loop;
                    wait;
                end process;
end architecture;