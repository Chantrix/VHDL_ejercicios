library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bp_numCeros is
    end entity;

architecture bp_numceros of bp_numCeros is
    component numCeros is 
        port( Y : out std_logic_vector(3 downto 0);
            X : in std_logic_vector(7 downto 0) );
    end component;
    signal y : std_logic_vector(3 downto 0);
    signal x : std_logic_vector(7 downto 0);

    procedure verifica (esperado :in std_logic_vector(3 downto 0);
                        actual  : in std_logic_vector(3 downto 0);
                        numErr : inout integer) is
            begin 
            if (esperado /= actual) then
                report "Error";
                numErr := numErr +1;
            end if;
    end procedure;

    begin
        uut : component numCeros port map (y, x);

        gen_test : process is
            variable test : unsigned(7 downto 0):= "0000_0000";
            variable numErr : integer := 0;
            begin
                for i in 0 to 255 loop
                    x <= std_logic_vector(test);
                    wait for 100 ns;
                    if std_match(x, "1-------") then
                            verifica ("0000", y, numErr);
                    elsif std_match(x, "01------") then
                            verifica ("0001", y, numErr);
                    elsif std_match(x, "001-----") then
                            verifica ("0010", y, numErr);
                    elsif std_match(x, "0001----") then
                            verifica ("0011", y, numErr);
                    elsif std_match(x, "00001---") then
                            verifica ("0100", y, numErr);
                    elsif std_match(x, "000001--") then
                            verifica ("0101", y, numErr);
                    elsif std_match(x, "0000001-") then
                            verifica ("0110", y, numErr);
                    elsif std_match(x, "00000001") then
                            verifica ("0111", y, numErr);
                    else  verifica ("1000", y, numErr);
                    end if;
                        test := test +1;
                    end loop;
                    report "numero de errores: " & integer'image(numErr);
                    wait;
                end process;

end architecture;