--recorre los datos de una memoria cada segundo
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity show_data is
    generic( BITS_ADDR : integer:= 4 );
    port ( addr :out std_logic_vector(BITS_ADDR -1 downto 0);
        rst     : in std_logic;
        clk     : in std_logic);
end entity;

architecture estructural of show_data is
    -- contador de ciclos de reloj
    signal count : integer range 0 to 12000000;
    --para leer la addr
    signal direcciones : unsigned(BITS_ADDR -1 downto 0) := (others => '0');    
    begin
        process (rst, clk) is

            begin
                if rst = '1' then
                    direcciones <= (others => '0');
                    count <= 0;
                elsif rising_edge(clk)then
                    if count = 12000000 then
                        direcciones <= direcciones + 1;
                        count <= 0;
                    else count <= count +1;
                    end if;
                end if;
                addr <= std_logic_vector(direcciones);
        end process;
    end architecture;