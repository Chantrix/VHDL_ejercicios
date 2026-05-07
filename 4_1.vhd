library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity codificador_4_2 is
    port(
        valida      : out std_logic;
        codificada  :out std_logic_vector(1 downto 0);
        i3, i2, i1, i0 : in std_logic
    );
    end entity;

architecture arch of codificador_4_2 is

    begin
        process (i3, i2, i1, i0) is

            begin
                if i3 = '1' then
                    codificada <= "11";
                elsif i2 = '1' then
                    codificada <= "10";
                elsif i1 = '1' then
                    codificada <= "01";
                elsif i0 = '1' then
                    codificada <= "00";
                end if;
        end process;
                    valida <= '0' when (i3 & i2 & i1 & i0) = "0000" else '1';
    end architecture;

    entity bp_4_2 is
    end entity;

    architecture bp_4_2 of bp_4_2 is
        --1. declaro señales
        signal valida, i3, i2, i1, i0 : std_logic;
        signal codificada : std_logic_vector(1 downto 0);
        --2. declaro componente
        component codificador_4_2 is
            port(
                valida      : out std_logic;
                codificada  :out std_logic_vector(1 downto 0);
                i3, i2, i1, i0 : in std_logic
            );
        end component;

        begin
            --3. instancio componente
            uut: component codificador_4_2 port map(valida, codificada, i3, i2, i1, i0);
            --4. comienzo el test con process
            gen_test: process is
                variable vector : unsigned(3 downto 0) := "0000";
                begin
                    for i in 0 to 15 loop
                        i3 <= std_logic(vector(3));
                        i2 <= std_logic(vector(2));
                        i1 <= std_logic(vector(1));
                        i0 <= std_logic(vector(0));
                        wait for 100 ns;
                        vector := vector +1;
                    end loop;
                    wait;
            end process;
    end architecture;