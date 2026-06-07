library ieee;
use ieee.std_logic_1164.all;

entity flip_flop_RS is
    port(Q, Q_n         : out std_logic;
        R, S, clk, reset_n : in std_logic);
end entity;
architecture ffRS of flip_flop_RS is
    begin
        process(reset_n, clk) is
           begin 
            if reset_n = '0' then
                Q <= '0';
                Q_n <= '1';
            elsif rising_edge(clk) then
                case R is
                    when '0' =>
                    if S = '1' then Q <= '1'; Q_n <= '0'; 
                    end if;
                    when '1' =>
                    if S = '0' then Q<= '0'; Q_n <= '1'; 
                    end if;
                    when others =>
                    Q <= '0'; Q_n <= '1';
                    end case;
            end if;
        end process;
                end architecture;

architecture libro of flip_flop_RS is
    signal q_interna : std_logic;
    begin
        Q <= q_interna;
        Q_n <= not q_interna;
        process (reset_n, clk) is
            variable aux : std_logic;
            begin
                if reset_n = '0' then
                    aux := '0';
                elsif rising_edge(clk) then
                    if (R = '0' and S = '1') then aux := '1';
                    elsif (R = '1' and S = '0') then aux := '0';
                    end if;
                end if;
                q_interna <= aux;
            end process;
        end architecture;
            
entity bp_ffRS is
constant PERIODO : time := 200 ns;
    end entity;

architecture bp_ffRS of bp_ffRS is
    component flip_flop_RS is
        port(Q, Q_n         : out std_logic;
        R, S, clk, reset_n : in std_logic);
    end component;
    signal Q, Q_n, R, S, clk, reset_n : std_logic;
    begin
        uut : component flip_flop_RS port map(Q, Q_n, R, S, clk, reset_n);
        clk <= not clk after PERIODO/2;
        gen_test : process is
            begin
                wait for PERIODO/2;
                reset_n <= '0';
                wait for PERIODO/4;
                reset_n <= '1';
                R <= '0'; S <= '1';
                wait for PERIODO;
                R <= '1'; S <= '0';
                wait for PERIODO;
                reset_n <= '0';
                R <= '1'; S <= '0';
                wait;
                end process;
                end architecture;