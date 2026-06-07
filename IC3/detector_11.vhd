library ieee;
use ieee.std_logic_1164.all;

entity detector_11 is
    port (
        y                : out std_logic;
        x, rst,clk       : in std_logic
    );
end entity;

architecture moore of detector_11 is
    constant s0 : std_logic_vector(1 downto 0) := "00";
    constant s1 : std_logic_vector(1 downto 0) := "01";
    constant s2 : std_logic_vector(1 downto 0) := "10";
    signal estado : std_logic_vector(1 downto 0) := s0;
    begin
        process (clk, rst) is

            begin
                if rst = '1' then
                    estado <= s0;
                elsif rising_edge(clk) then
                    case estado is
                        when s0 =>
                        if x = '1' then
                            estado <= s1;
                        end if;
                        when s1 => 
                        if x = '0' then
                            estado <= s0;
                        else estado <= s2;
                        end if;
                        when s2 =>
                        if x = '0' then
                            estado <= s0;
                        end if;
                        when others =>
                        estado <= s0;
                    end case;
                end if;
                end process;
                y <= '1' when estado = s2 else '0';
end architecture;

architecture mealy of detector_11 is
    constant s0         : std_logic := '0';
    constant s1         : std_logic := '1';
    signal estado       :std_logic;
    begin
        process (rst, clk) is
            begin
                if rst = '1' then
                    estado <= s0;
                elsif rising_edge(clk) then
                    case estado is
                        when s0 =>
                        if x = '1' then 
                            estado <= s1;
                        end if;
                        when s1 =>
                        if x = '0' then
                            estado <= s0;
                        end if;
                        when others =>
                            estado <= s0;
                    end case;
                end if;
        end process;  
        y <= '1' when ( estado = s1 and x = '1') else '0';  
    end architecture;