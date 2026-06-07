library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
    port (fin   : out std_logic;
        solucion : out std_logic_vector(3 downto 0);
        opA, opB : in  std_logic_vector(3 downto 0);
        reset, clk   : in std_logic);
end entity;

architecture fsm of gcd is
    type estadoT is (INICIAL,COMPARA, AMB, BMA, AEB);
    signal estado : estadoT := INICIAL;
    begin
        process (clk, reset) is
            variable a, b : unsigned(3 downto 0);
            begin
                
                if reset = '1' then
                    fin <= '0';
                    solucion <= "0000";
                    estado <= INICIAL;
                    elsif rising_edge(clk) then
                        case estado is
                            when INICIAL =>
                            a := unsigned(opA);
                            b := unsigned(opB);
                            estado <= COMPARA;
                            when COMPARA =>
                            if a > b then estado <= AMB;
                            elsif b > a then estado <= BMA;
                            else estado <= AEB;
                            end if;
                            when AMB => a := a - b; estado <= COMPARA;
                            when BMA => b := b -a; estado <= COMPARA;
                            When AEB => fin <= '1'; 
                            solucion <= std_logic_vector(b);
                        end case;
                    end if;
                end process; 
    end architecture;

    architecture libro of gcd is
        signal estado : integer;
        signal a, b : std_logic_vector(3 downto 0);
        begin
            process (clk, reset) is

                if  reset = '1' then
                    estado <= 1;
                    a <= opA;
                    b <= opB;
                    fin <= '0';
                elsif rising_edge(clk) then
                    estado <= estado +1;
                    case estado is
                        when 1 =>
                        if a > b then 
                        a <= std_logic_vector(signed(a) - signed(b));
                        estado <= 1;
                        elsif b > a then 
                        b <= std_logic_vector(signed(b) - signed(a));
                        estado <= 1;
                        enlse
                        estado <= 2;
                        fin <= '1';
                        solucion <= b;
                        end if;
                        when others =>
                        estado <= 2;
                    end case;
                end if;
            end process;
    end architecture;


--architecture euclides of gcd is

        --     begin
        --         euc_bcd : process is
        --             variable a , b, sol : unsigned (3 downto 0);
        --             variable bcd : std_logic := '0';
                    
        --             begin
        --                 a := unsigned(opA);
        --                 b := unsigned(opB);
        --                 if reset = '1' then
        --                     bcd := '0';
        --                     sol := "0000";
        --                 else
        --                     while (a /= b) loop
        --                         if a > b then a := a - b;
        --                         elsif b > a then b := b - a;
        --                         end if;
        --                         wait for 100 ns;
        --                     end loop;
        --                     bcd := '1';
        --                     sol := b;
        --                 end if;
        --                 wait for 100 ns;
        --                 fin <= bcd;
        --                 solucion <= std_logic_vector(sol);
        --                 wait on opA, opB, reset;
        --         end process;
        -- end architecture;