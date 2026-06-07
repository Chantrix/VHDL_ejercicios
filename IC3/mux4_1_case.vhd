--Ejercicio 3: Multiplexor 4 a 1 con 1 process y 1 case
-- Diseña un multiplexor de 4 entradas de 8 bits cada una:
-- Entradas: a, b, c, d de 8 bits cada una (std_logic_vector(7 downto 0))
-- Entrada de selección: sel de 2 bits (std_logic_vector(1 downto 0))
-- Salida: y de 8 bits
-- sel	y
-- "00"	a
-- "01"	b
-- "10"	c
-- "11"	d

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4_1 is
    port(
        y           : out   std_logic_vector(7 downto 0);
        a,b,c,d    : in    std_logic_vector(7 downto 0);
        sel         : in    std_logic_vector(1 downto 0)
    );
end entity;

architecture mux_case of mux4_1 is
begin
    process (a, b, c, d, sel) is
        begin
            case sel is
                when "00" =>
                y <= a;
                when "01" =>
                y <= b;
                when "10" => 
                y <= c;
                when "11" => 
                y <= d;
                when others =>
                y <= (others => '0');
            end case;
        end process;
end architecture;

architecture mux_when of mux4_1 is
    begin
        y   <=  a when sel ="00" else
                b when sel ="01" else
                c when sel ="10" else
                d ;
 end architecture;
