-- Testbench para RAM basica sincrona

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM_tb is
end entity;

architecture behavioral of RAM_tb is

    constant BITS_WORD : integer := 4;
    constant BITS_ADDR : integer := 4;
    constant T_CLK     : time := 10 ns;

    signal clk      : std_logic := '0';
    signal w_en     : std_logic := '0';
    signal addr     : std_logic_vector(BITS_ADDR - 1 downto 0) := (others => '0');
    signal data_in  : std_logic_vector(BITS_WORD - 1 downto 0) := (others => '0');
    signal data_out : std_logic_vector(BITS_WORD - 1 downto 0);

begin

    uut: entity work.RAM
        generic map(
            BITS_WORD => BITS_WORD,
            BITS_ADDR => BITS_ADDR
        )
        port map(
            clk      => clk,
            w_en     => w_en,
            addr     => addr,
            data_in  => data_in,
            data_out => data_out
        );

    clk <= not clk after T_CLK / 2;

    estimulos: process
    begin
        -- Escritura en varias direcciones
        w_en <= '1';

        addr    <= "0000"; data_in <= "1010"; wait until rising_edge(clk);
        addr    <= "0001"; data_in <= "0101"; wait until rising_edge(clk);
        addr    <= "0010"; data_in <= "1111"; wait until rising_edge(clk);
        addr    <= "0011"; data_in <= "0011"; wait until rising_edge(clk);

        -- Lectura de las mismas direcciones
        w_en <= '0';

        addr <= "0000"; wait until rising_edge(clk); wait for 1 ns;
        assert data_out = "1010" report "ERROR lectura addr 0: esperado 1010, obtenido " & to_string(data_out) severity error;

        addr <= "0001"; wait until rising_edge(clk); wait for 1 ns;
        assert data_out = "0101" report "ERROR lectura addr 1: esperado 0101, obtenido " & to_string(data_out) severity error;

        addr <= "0010"; wait until rising_edge(clk); wait for 1 ns;
        assert data_out = "1111" report "ERROR lectura addr 2: esperado 1111, obtenido " & to_string(data_out) severity error;

        addr <= "0011"; wait until rising_edge(clk); wait for 1 ns;
        assert data_out = "0011" report "ERROR lectura addr 3: esperado 0011, obtenido " & to_string(data_out) severity error;

        -- Sobreescritura
        w_en <= '1';
        addr <= "0000"; data_in <= "1100"; wait until rising_edge(clk);

        w_en <= '0';
        addr <= "0000"; wait until rising_edge(clk); wait for 1 ns;
        assert data_out = "1100" report "ERROR sobreescritura addr 0: esperado 1100, obtenido " & to_string(data_out) severity error;

        report "Testbench completado sin errores" severity note;
        wait;
    end process;

end architecture;
