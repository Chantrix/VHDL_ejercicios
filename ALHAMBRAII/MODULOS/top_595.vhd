-- top level: binario -> BCD -> mux_digitos -> 7seg -> 74HC595
-- dato de prueba fijo: x"A5" = 165 decimal
-- display de 4 digitos, catodo comun
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_595 is
    generic( DIV_MAX : integer := 937);
    port(
        clk   : in  std_logic;
        rst   : in  std_logic;
        rst_rom : in std_logic;
        sclk  : out std_logic;
        mosi  : out std_logic;
        latch : out std_logic;
        hab   : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of top_595 is

    signal   div_cnt : integer range 0 to DIV_MAX := 0;
    signal   clk_div : std_logic := '0';

    --constant DATO : std_logic_vector(7 downto 0) := x"A5";

    signal bcd     : std_logic_vector(15 downto 0);
    signal bcd_12  : std_logic_vector(11 downto 0);
    signal digito  : std_logic_vector(3  downto 0);
    signal seg     : std_logic_vector(7  downto 0);
    signal start   : std_logic := '0';
    signal done    : std_logic;
    signal sel     : integer range 0 to 3 := 0;
    signal iniciado  : std_logic := '0';
    signal addr_show : std_logic_vector(3 downto 0);
    signal DATO      : std_logic_vector(7 downto 0);

    component show_data is
        generic( BITS_ADDR : integer := 4 );
        port ( addr : out std_logic_vector(BITS_ADDR-1 downto 0);
               rst  : in  std_logic;
               clk  : in  std_logic);
    end component;

    component ROM is
        generic(
            BITS_PALABRA : integer := 8;
            BITS_DIR     : integer := 4);
        port(
            datos : out std_logic_vector(BITS_PALABRA-1 downto 0);
            addr  : in  std_logic_vector(BITS_DIR-1 downto 0));
    end component;


    component BIN_a_BCD is
        port(
            data_out : out std_logic_vector(11 downto 0);
            data_in  : in  std_logic_vector(7  downto 0));
    end component;

    component mux_digitos is
        generic(
            N_DIGITOS : integer;
            BITS_DIG  : integer);
        port(
            bcd    : in  std_logic_vector(N_DIGITOS * BITS_DIG - 1 downto 0);
            sel    : in  integer range 0 to N_DIGITOS - 1;
            digito : out std_logic_vector(BITS_DIG - 1 downto 0);
            hab    : out std_logic_vector(N_DIGITOS - 1 downto 0));
    end component;

    component BCD_a_7seg is
        port(
            abcdefgp : out std_logic_vector(7 downto 0);
            bits_in  : in  std_logic_vector(3 downto 0));
    end component;

    component fsm_595 is
        port(
            latch   : out std_logic;
            sclk    : out std_logic;
            mosi    : out std_logic;
            done    : out std_logic;
            clk     : in  std_logic;
            rst     : in  std_logic;
            start   : in  std_logic;
            data_in : in  std_logic_vector(7 downto 0));
    end component;

begin

    bcd <= "0000" & bcd_12;

    -- divisor: clk_div toggle a 1 kHz
    process (clk, rst) is
    begin
        if rst = '1' then
            div_cnt <= 0;
            clk_div <= '0';
        elsif rising_edge(clk) then
            if div_cnt = DIV_MAX then
                div_cnt <= 0;
                clk_div <= not clk_div;
            else
                div_cnt <= div_cnt + 1;
            end if;
        end if;
    end process;

    -- selector de digito: primer start en el primer flanco de clk_div
    process (clk_div, rst) is
    begin
        if rst = '1' then
            sel      <= 0;
            start    <= '0';
            iniciado <= '0';
        elsif rising_edge(clk_div) then
            start <= '0';
            if iniciado = '0' then
                -- primer arranque tras reset
                start    <= '1';
                iniciado <= '1';
            elsif done = '1' then
                if sel = 3 then
                    sel <= 0;
                else
                    sel <= sel + 1;
                end if;
                start <= '1';
            end if;
        end if;
    end process;

    U_SHOW_DATA : show_data
        port map( addr => addr_show, rst => rst_rom, clk => clk);

    U_ROM : ROM
        port map (datos => DATO, addr => addr_show);

    U_BIN_BCD : BIN_a_BCD
        port map (
            data_in  => DATO,
            data_out => bcd_12);

    U_MUX : mux_digitos
        generic map (
            N_DIGITOS => 4,
            BITS_DIG  => 4)
        port map (
            bcd    => bcd,
            sel    => sel,
            digito => digito,
            hab    => hab);

    U_BCD_7SEG : BCD_a_7seg
        port map (
            bits_in  => digito,
            abcdefgp => seg);

    U_FSM : fsm_595
        port map (
            clk     => clk_div,
            rst     => rst,
            start   => start,
            data_in => seg,
            sclk    => sclk,
            mosi    => mosi,
            latch   => latch,
            done    => done);

end architecture rtl;

