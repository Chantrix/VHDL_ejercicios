library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bp_detector is
    constant PERIODO : time := 100 ns;
end entity;

architecture bp_test of bp_detector is
    signal det, x, rst  : std_logic;
    signal clk          : std_logic := '0';
    component detector_101 is
        port(
        det         : out   std_logic;
        clk         : in    std_logic;
        rst,x       : in    std_logic
    );
    end component;

    begin
        uut: component detector_101 port map(det, clk, rst, x);
        clk <= not clk after PERIODO/2;
        rst <='1' after PERIODO/4 , '0' after PERIODO;
        x <= '1' after 120 ns , '1' after 220 ns , '0' after 320 ns, '1' after 420 ns,
        '0' after 520 ns , '1' after 620 ns; 
    end architecture;