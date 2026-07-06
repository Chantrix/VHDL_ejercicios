-- Espectaculo de luces con RAM en loop
-- but2 arranca/para el show, w_en/addr/data_in permiten cargar patrones

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM_leds is
    generic(
        BITS_WORD : integer := 4;
        BITS_ADDR : integer := 4
    );
    port(
        clk     : in  std_logic;
        but2    : in  std_logic;
        w_en    : in  std_logic;
        addr    : in  std_logic_vector(BITS_ADDR - 1 downto 0);
        data_in : in  std_logic_vector(BITS_WORD - 1 downto 0);
        leds    : out std_logic_vector(BITS_WORD - 1 downto 0)
    );
end entity;

architecture behavioral of RAM_leds is

    type memoria is array (0 to 2**BITS_ADDR - 1) of std_logic_vector(BITS_WORD - 1 downto 0);
    signal mem : memoria := (others => (others => '0'));

    -- contador de velocidad: 1200000 ciclos a 12MHz = ~100ms por paso
    signal count     : integer range 0 to 1200000 := 0;
    signal idx       : integer range 0 to 2**BITS_ADDR - 1 := 0;
    signal but2_prev : std_logic := '0';

    type estadoT is (ENCENDIDO, APAGADO);
    signal estado : estadoT := APAGADO;

begin

    process (clk) is
    begin
        if rising_edge(clk) then
            but2_prev <= but2;

            -- escritura en RAM
            if w_en = '1' then
                mem(to_integer(unsigned(addr))) <= data_in;
            end if;

            -- toggle en flanco de subida de but2
            if but2 = '1' and but2_prev = '0' then
                if estado = APAGADO then
                    estado <= ENCENDIDO;
                else
                    estado <= APAGADO;
                end if;
            end if;

            -- show: avanza idx y saca patron a leds
            if estado = ENCENDIDO then
                if count = 1200000 then
                    count <= 0;
                    if idx = 2**BITS_ADDR - 1 then
                        idx <= 0;
                    else
                        idx <= idx + 1;
                    end if;
                else
                    count <= count + 1;
                end if;
                leds <= mem(idx);
            else
                leds <= mem(to_integer(unsigned(addr))) ;
            end if;
        end if;
    end process;

end architecture;
