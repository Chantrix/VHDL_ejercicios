-- maquina de estados para controlar el bit shifter 74hc595
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm_595 is
    port(
        latch   : out std_logic;
        sclk    : out std_logic;
        mosi    : out std_logic;
        done    : out std_logic;
        clk     : in  std_logic;
        rst     : in  std_logic;
        start   : in  std_logic;
        data_in : in  std_logic_vector(7 downto 0));
end entity;

architecture behavioral of fsm_595 is
    type estadoT is (IDLE, SHIFTING, s_LATCH, s_DONE);
    signal estado      : estadoT := IDLE;
    signal estado_prox : estadoT;
    signal flag        : integer range 0 to 7 := 0;
    signal sclk_i      : std_logic := '0';
begin

    sclk <= sclk_i;

    -- proceso sincrono: estado, sclk interno y contador de bits
    process (clk, rst) is
    begin
        if rst = '1' then
            estado <= IDLE;
            flag   <= 0;
            sclk_i <= '0';
        elsif rising_edge(clk) then
            estado <= estado_prox;
            if estado = SHIFTING then
                sclk_i <= not sclk_i;
                -- flag avanza en el flanco de bajada de sclk (cuando sclk_i pasa de 1 a 0)
                if sclk_i = '1' then
                    if flag = 7 then
                        flag <= 0;
                    else
                        flag <= flag + 1;
                    end if;
                end if;
            else
                sclk_i <= '0';
                flag   <= 0;
            end if;
        end if;
    end process;

    -- proceso combinacional: salidas y siguiente estado
    process (estado, start, data_in, flag, sclk_i) is
    begin
        latch       <= '0';
        mosi        <= '0';
        done        <= '0';
        estado_prox <= estado;

        case estado is
            when IDLE =>
                if start = '1' then
                    estado_prox <= SHIFTING;
                end if;

            when SHIFTING =>
                mosi <= data_in(flag);
                -- transicion tras el flanco de bajada del ultimo bit
                if flag = 7 and sclk_i = '1' then
                    estado_prox <= s_LATCH;
                end if;

            when s_LATCH =>
                latch       <= '1';
                estado_prox <= s_DONE;

            when s_DONE =>
                done        <= '1';
                estado_prox <= IDLE;

            when others =>
                estado_prox <= IDLE;
        end case;
    end process;

end architecture;
