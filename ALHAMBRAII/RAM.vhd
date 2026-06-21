-- IMplementacion de una RAM basica 2D de 4x4

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM is
    generic(
        BITS_WORD : integer := 4;
        BITS_ADDR     : integer := 4
    );
    port(
        data_out    : out std_logic_vector(BITS_WORD - 1 downto 0);
        data_in     : in std_logic_vector(BITS_WORD - 1 downto 0);
        addr        : in std_logic_vector(BITS_ADDR - 1 downto 0);
        w_en        : in std_logic;
        clk         : in std_logic);
end entity;

architecture behavioral of RAM is
    --creo un tipo de memoria
    type memoria is array (0 to 2**BITS_ADDR -1) of std_logic_vector(BITS_WORD -1 downto 0);
    -- creo la memoria como una señal
    signal mem : memoria;

    begin
        -- proceso sincrono de lectura/escritura
        process (clk)is
            begin
                if rising_edge(clk) then
                    if w_en = '1' then
                        mem(to_integer(unsigned(addr))) <= data_in;
                    end if;
                    data_out <= mem(to_integer(unsigned(addr)));
                end if;
        end process;
    end architecture;
