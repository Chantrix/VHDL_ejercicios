-- Ejercicio 2: Registro de desplazamiento
-- Diseña un registro de desplazamiento de 8 bits con las siguientes características:
-- Entradas: clk, rst (reset asíncrono a 0), d_in (1 bit)
-- Salida: d_out de 8 bits (std_logic_vector)
-- En cada flanco de subida de clk, los bits se desplazan hacia la izquierda y el bit nuevo d_in entra por la derecha
-- Con rst = '1' todos los bits se ponen a 0
-- Por ejemplo, si el registro contiene "01101010" y entra d_in = '1', el resultado es "11010101".

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_8bits is
    port(
        d_out           : out   std_logic_vector(7 downto 0);
        clk, rst, d_in  : in    std_logic );
end entity;

architecture arch_reg8 of reg_8bits is
    begin
        process (clk, rst) is
            variable i     :   unsigned(7 downto 0) ;
            variable index :    integer; 
            begin
                if (rst = '1') then
                    i := x"00";
                elsif rising_edge(clk) then
                    for index in 6 downto 0 loop
                        i(index + 1) := i(index);
                    end loop;
                    i(0) := d_in;
                    d_out <= std_logic_vector(i) ;
                    end if;
                        
        end process;
end architecture;