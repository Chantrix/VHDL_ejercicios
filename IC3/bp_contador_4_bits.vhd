library Ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bp_contador_4_bits is
    constant PERIODO : time := 100 ns;
    end entity;
    
    architecture bp_cont of bp_contador_4_bits is
        
    --1.declaracion de señales
    signal q : std_logic_vector(3 downto 0);
    signal clk  : std_logic := '0';
    signal  en, rst : std_logic;

    --2.declaracion de componente
    component contador_4_bits is
        port(   q           : out std_logic_vector(3 downto 0);
                clk, en, rst     : in std_logic);
    end component;
    
    begin
        
        --3.instanciacion de componente
        uut: contador_4_bits port map (q, clk, en, rst);
        --generar reloj
        clk <= not clk after (PERIODO/2);
        tes_gen : process  is
            variable index : integer := 0;
            begin
            rst <= '1';
            wait for (PERIODO/4);
            en <= '1';
            rst <= '0';
            wait for (PERIODO/4 + PERIODO/2);
            for index in 0 to 10 loop
                wait for PERIODO;
            end loop;
        end process;
    end architecture;
