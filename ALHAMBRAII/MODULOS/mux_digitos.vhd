-- multiplexor de digitos para display de 7 segmentos
-- generico: numero de digitos y bits por digito
-- habilitacion activo bajo (catodo comun)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_digitos is
    generic(
        N_DIGITOS : integer := 4;   -- numero de digitos
        BITS_DIG  : integer := 4);  -- bits por digito (BCD = 4)
    port(
        bcd    : in  std_logic_vector(N_DIGITOS * BITS_DIG - 1 downto 0);
        sel    : in  integer range 0 to N_DIGITOS - 1;
        digito : out std_logic_vector(BITS_DIG - 1 downto 0);
        hab    : out std_logic_vector(N_DIGITOS - 1 downto 0));  -- activo bajo
end entity;

architecture behavioral of mux_digitos is
begin

    -- selecciona el nibble correspondiente al digito activo
    process (bcd, sel) is
        variable base : integer;
    begin
        base   := (N_DIGITOS - 1 - sel) * BITS_DIG;
        digito <= bcd(base + BITS_DIG - 1 downto base);
    end process;

    -- habilita solo el digito activo (activo bajo: '0' enciende, '1' apaga)
    process (sel) is
    begin
        hab <= (others => '1');         -- todos apagados por defecto
        hab(N_DIGITOS - 1 - sel) <= '0';  -- enciende el activo
    end process;

end architecture;
