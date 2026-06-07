-- Diseñe en VHDL una memoria de acceso aleatorio que contenga 16 palabras de 8
-- bits (RAM 16 × 8). Tal como se muestra en la siguiente figura, la RAM tiene una
-- bus de entrada de datos (data_in), un bus de salida de datos (data_out), un bus
-- de direcciones (addr), una entrada de reloj (clk) y una entrada para habilitar la
-- escritura (wr_ena).
-- RAM
-- word 0
-- word 1
-- word 2
-- …
-- addr
-- data_out
-- data_in
-- clk wr_ena
-- La señal data_in se almacena en la posición indicada por addr cuando la señal
-- wr_ena está a ’1’ y la señal clk está en el flanco de subida.
-- Por otro lado, el bus de salida de datos debe mostrar continuamente los datos
-- seleccionados por addr.
-- Realice el diseño en VHDL de modo que el número de bits de cada palabra (bits)
-- y el número de palabras de la memoria (words) sean constantes de tipo generic.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    generic (bits   : integer := 8;
            word    : integer := 16);
    port(data_out   : out std_logic_vector(bits - 1 downto 0);
        data_in     : in std_logic_vector(bits - 1 downto 0);
        addr        : in std_logic_vector(3 downto 0);
        wr_ena, clk : in std_logic);
end entity;

architecture ram of ram is
    type memoria is array(0 to word -1) of std_logic_vector(bits - 1 downto 0);
    signal celda    : memoria;
    begin
        process(clk) is
            begin
                if rising_edge(clk)  then
                    if (wr_ena = '1') then
                        celda(to_integer(unsigned(addr))) <= data_in;
                    end if;
                end if;
        end process;
        data_out <= celda(to_integer(unsigned(addr)));
        end architecture;
                