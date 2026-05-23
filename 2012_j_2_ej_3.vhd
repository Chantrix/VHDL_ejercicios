-- Programe en VHDL un banco de pruebas del comparador que ha diseñado al
-- resolver la Pregunta 2. El banco de pruebas debe comprobar el funcionamiento
-- del circuito para los vectores de test siguientes:
-- • a="11111111", b="00000000", sel=’1’
-- • a="11111111", b="00000000", sel=’0’
-- • a="00001110", b="00001111", sel=’1’
-- • a="00001110", b="00001111", sel=’0’
-- • a="01111111", b="01111110", sel=’1’
-- • a="01111111", b="01111110", sel=’0’
-- • a="00011110", b="00011110", sel=’1’
-- • a="00011110", b="00011110", sel=’0’
-- El banco de pruebas debe comprobar para cada vector de test si la salida de la
-- UUT es correcta, mostrar un mensaje cada vez que la salida de la UUT no sea
-- correcta y mostrar un mensaje al finalizar el test en el que se indique el número
-- total de salidas incorrectas.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bp_comp is
    end entity;

architecture bp_comp of bp_comp is
    component comparador is 
    port( x3, x2, x1 : out std_logic;
        a, b : in std_logic_vector(7 downto 0);
        sel : in std_logic );
    end component;
    constant tiempo : time := 50 ns;
    signal x3, x2, x1 :  std_logic;
    signal a, b :  std_logic_vector(7 downto 0);
    signal sel :  std_logic ;
    signal num : integer := 0;
    procedure verifica(s3 :in std_logic; s2 :in std_logic; s1 :in std_logic) is
        begin
            if not(x3 = s3 and x2 = s2 and x1 = s1) then
                report "Error";
                num <= num +1;
            end if;
    end procedure;
    begin 
        uut : component comparador port map(x3, x2, x1, a, b, sel);
        gen_test : process is
            begin
                wait for tiempo;
                a <= "11111111"; b <= "00000000"; sel<='1';
                wait for tiempo;
                verifica ('0','0','1');
                wait for tiempo;
                sel <='0';
                wait for tiempo;
                verifica ('1','0','0');
                wait for tiempo;
                a <= "00001110"; b <= "00001111"; sel<='1';
                wait for tiempo;
                verifica ('0','0','1');
                wait for tiempo;
                sel <='0';
                wait for tiempo;
                verifica ('0','0','1');
                wait for tiempo;
                a <= "01111111"; b <= "01111110"; sel<='1';
                wait for tiempo;
                verifica ('1','0','0');
                wait for tiempo;
                sel <='0';
                wait for tiempo;
                verifica ('1','0','0');
                wait for tiempo;
                a <= "00011110"; b <= "00011110"; sel<='1';
                wait for tiempo;
                verifica ('0','1','0');
                wait for tiempo;
                sel <='0';
                wait for tiempo;
                verifica ('0','1','0');
                wait for tiempo;
                report " Numero de Errores: " & integer'image(num);
                wait;
                end process;
                end architecture;
                