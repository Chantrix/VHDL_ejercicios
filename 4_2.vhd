library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity det_menor_5 is
    port(
        y   : out std_logic;
        x3, x2, x1, x0 : in std_logic 
    );
end entity;

architecture arch of det_menor_5 is
    begin
        y <= (not x3 and not x2) or ( not x3 and x2 and not x1 and not x0) ;

             
end architecture;