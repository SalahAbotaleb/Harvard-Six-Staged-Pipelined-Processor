Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity ExecutionUnit is
    port (
        clk : in std_logic;
        AlUop: in std_logic_vector(4 downto 0);
        src1,src2,imm: in std_logic_vector(15 downto 0);
        ALUsrc,RegDst: in std_logic;
        inPort: in std_logic_vector(15 downto 0);
        res:out std_logic_vector(15 downto 0);
        CCR: out std_logic_vector(2 downto 0) -- Z(zero flag) | N(Negative flag) | C(Carry Flag)	
    );
end ExecutionUnit;

architecture ExecutionUnitArch of ExecutionUnit is
begin
    process(clk)
    variable opCodeint:integer;
    variable result:std_logic_vector(16 downto 0);
    begin
        opCodeint:=to_integer(unsigned(ALUop));
        if(rising_edge(clk)) then 
            case opCodeint is
                -- NOP
                when 0 => res<=(others=>'0');
                -- SETC
                when 1 => 
                    res<=(others=>'0');
                    CCr(0) <= '1';
                -- CLRC
                when 2 => 
                    res<=(others=>'0');
                    CCr(0) <= '0';
                -- NOT Rdst, Rsrc1
                when 3 => res<= not src1;
                -- INC Rdst, Rsrc1
                when 4 => res<= std_logic_vector(unsigned(src1) + 1);
                -- DEC Rdst, Rsrc1
                when 5 => res<= std_logic_vector(unsigned(src1) - 1);
                -- ADD Rdst, Rsrc1, Rsrc2
                when 9 => 
                    result := std_logic_vector(unsigned(src1) + unsigned(src2));
                    res<= result;
                    CCR(0) <= result(16);
                    CCR(1) <= res(15);
                    CCR(2) <= '1' when result(15 downto 0) = others => '0' else '1';

                -- SUB Rdst, Rsrc1, Rsrc2
                when 10 => 
                    result := std_logic_vector(unsigned(src1) - unsigned(src2));
                    res<= result;
                    CCR(0) <= result(16);
                    CCR(1) <= res(15);
                    CCR(2) <= '1' when result(15 downto 0) = others => '0' else '1';
                -- AND Rdst, Rsrc1, Rsrc2
                when 11 => 
                    result := src1 and src2;
                    res<= result;
                    CCR(1) <= res(15);
                    CCR(2) <= '1' when result(15 downto 0) = others => '0' else '1';
                -- OR Rdst, Rsrc1, Rsrc2
                when 12 => 
                    result := src1 or src2;
                    res<= result;
                    CCR(1) <= res(15);
                    CCR(2) <= '1' when result(15 downto 0) = others => '0' else '1';
                -- JZ Rdst
                -- JC Rdst
                -- IADD Rdst, Rsrc1, Imm
                when others=> res<=(others=>'0'); 
            end case;
        end if;
    end process;
end architecture;