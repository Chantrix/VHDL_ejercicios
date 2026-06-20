-- ROM parametrizable: BITS_PALABRA bits por palabra, 2^BITS_DIR palabras
-- En la Alhambra II conectar datos a LEDs y addr a pines de entrada
-- en este caso la rom contiene un patron de 16x8
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ROM is
    generic(
        BITS_PALABRA : integer := 8;
        BITS_DIR     : integer := 4
    );
    port(
        datos : out std_logic_vector(BITS_PALABRA-1 downto 0);
        addr  : in  std_logic_vector(BITS_DIR-1 downto 0));
end entity;

architecture behavioral of ROM is
    type memoria is array (0 to 2**BITS_DIR - 1) of std_logic_vector(BITS_PALABRA-1 downto 0);
    constant mem : memoria := (
        0  => "10000000",
        1  => "01000000",
        2  => "00100000",
        3  => "00010000",
        4  => "00001000",
        5  => "00000100",
        6  => "00000010",
        7  => "00000001",
        8  => "00000001",
        9  => "00000010",
        10 => "00000100",
        11 => "00001000",
        12 => "00010000",
        13 => "00100000",
        14 => "01000000",
        15 => "10000000");
begin
    datos <= mem(to_integer(unsigned(addr)));
end architecture;
