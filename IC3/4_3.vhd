
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity bcd_a_7 is
    port(
    a, b, c, d, e, f, g     : out std_logic;
    i3, i2, i1, i0          : in std_logic
    );
end entity;

architecture case_proc of bcd_a_7 is

    begin
        process (i3, i2, i1, i0) is
            variable entrada : std_logic_vector( 3 downto 0 );
            variable seg     : std_logic_vector(6 downto 0);
            begin
                entrada := i3 & i2 & i1 & i0;
                case entrada is
                    when "0000" =>
                    seg := "1111110";
                    when "0001" =>
                    seg := "0110000";
                    when "0010" =>
                    seg := "1101101";
                    when "0011" =>
                    seg := "1111001";
                    when "0100" =>
                    seg := "0110011";
                    when "0101" =>
                    seg := "1011011";
                    when "0110" =>
                    seg := "1011111";
                    when "0111" =>
                    seg := "1110000";
                    when "1000" =>
                    seg := "1111111";
                    when "1001" =>
                    seg := "1110011";
                    when others =>
                    seg := "0000000";
                    end case;
                a <= seg(6);
                b <= seg(5);
                c <= seg(4);
                d <= seg(3);
                e <= seg(2);
                f <= seg(1);
                g <= seg(0);
            end process;
end architecture;

architecture if_proc of bcd_a_7 is

    begin
        process (i3, i2, i1, i0) is
            variable entrada : std_logic_vector( 3 downto 0 );
            variable seg     : std_logic_vector(6 downto 0);
            begin
                entrada := i3 & i2 & i1 & i0;
                    if entrada = "0000" then
                    seg := "1111110";
                    elsif entrada = "0001" then
                    seg := "0110000";
                    elsif entrada = "0010" then
                    seg := "1101101";
                    elsif entrada = "0011" then
                    seg := "1111001";
                    elsif entrada = "0100" then
                    seg := "0110011";
                    elsif entrada = "0101" then
                    seg := "1011011";
                    elsif entrada = "0110" then
                    seg := "1011111";
                    elsif entrada = "0111" then
                    seg := "1110000";
                    elsif entrada = "1000" then
                    seg := "1111111";
                    elsif entrada = "1001" then
                    seg := "1110011";
                    else
                    seg := "0000000";
                    end if;
                a <= seg(6);
                b <= seg(5);
                c <= seg(4);
                d <= seg(3);
                e <= seg(2);
                f <= seg(1);
                g <= seg(0);
            end process;
end architecture;


architecture concurrente_proc of bcd_a_7 is
            signal seg : std_logic_vector(6 downto 0); 
            signal entrada : std_logic_vector(3 downto 0);
            begin
                entrada <= i3 & i2 & i1 & i0;
                seg <=  "1111110" when entrada = "0000" else
                        "0110000" when entrada = "0001" else
                        "1101101" when entrada = "0010" else
                        "1111001" when entrada = "0011" else
                        "0110011" when entrada = "0100" else
                        "1011011" when entrada = "0101" else
                        "1011111" when entrada = "0110" else
                        "1110000" when entrada = "0111" else
                        "1111111" when entrada = "1000" else
                        "1110011" when entrada = "1001" else
                        "0000000" ;
                    
                a <= seg(6);
                b <= seg(5);
                c <= seg(4);
                d <= seg(3);
                e <= seg(2);
                f <= seg(1);
                g <= seg(0);
end architecture;
architecture select_proc of bcd_a_7 is
            signal seg : std_logic_vector(6 downto 0); 
            signal entrada : std_logic_vector(3 downto 0);
            begin
                entrada <= i3 & i2 & i1 & i0;
                with entrada select
                    seg <=  "1111110" when  "0000",
                            "0110000" when  "0001",
                            "1101101" when  "0010",
                            "1111001" when  "0011",
                            "0110011" when  "0100",
                            "1011011" when  "0101",
                            "1011111" when  "0110",
                            "1110000" when  "0111",
                            "1111111" when  "1000",
                            "1110011" when  "1001",
                            "0000000" when others;
                    
                    a <= seg(6);
                    b <= seg(5);
                    c <= seg(4);
                    d <= seg(3);
                    e <= seg(2);
                    f <= seg(1);
                    g <= seg(0);
end architecture;