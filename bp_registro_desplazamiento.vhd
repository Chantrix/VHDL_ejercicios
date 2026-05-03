library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bp_reg_desp_8bits is
    constant PERIODO : time := 100 ns;
end entity;

architecture reg8 of bp_reg_desp_8bits is
    --1. declaraciones señales
    signal d_out : std_logic_vector(7 downto 0);
    signal clk, rst, d_in : std_logic := '0';
    --2. declaracion componentes
    component reg_8bits is
        port(
            d_out           : out   std_logic_vector(7 downto 0);
            clk, rst, d_in  : in    std_logic );
    end component;
    begin
        --3.instanciacion componente
        uut: component reg_8bits port map (d_out, clk, rst, d_in);
        --4.proceso test
        clk <= not clk after (PERIODO/2);
        test_gen : process is
            variable index : integer;
            begin
            wait for (PERIODO/4);
            rst <= '1';
            wait for (PERIODO/4);
            rst <= '0';
            wait for (PERIODO/2);
            for index in 0 to 8 loop
                wait for (PERIODO/2);
                d_in <= '1';
            end loop;
            wait;
        end process;

    end architecture;