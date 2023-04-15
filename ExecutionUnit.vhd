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
        outPort: out std_logic_vector(15 downto 0);
        res1, res2:out std_logic_vector(15 downto 0);
        CCRout: out std_logic_vector(2 downto 0); -- Z(zero flag) | N(Negative flag) | C(Carry Flag)
        CCRin: in std_logic_vector(2 downto 0); -- Z(zero flag) | N(Negative flag) | C(Carry Flag)
        SPin: in std_logic_vector(15 downto 0);
        SPout: out std_logic_vector(15 downto 0)
    );
end ExecutionUnit;

architecture ExecutionUnitArch of ExecutionUnit is
begin
    process(clk)
    variable opCodeint: integer;
    variable result: std_logic_vector(16 downto 0);
    variable SPplus1: std_logic_vector(15 downto 0);
    begin
        opCodeint:=to_integer(unsigned(ALUop));
        if(rising_edge(clk)) then 
            case opCodeint is
                -- NOP
                when 0 => res1<=(others=>'0');
                -- SETC
                when 1 => 
                    CCRout(0) <= '1';
                -- CLRC
                when 2 => 
                    CCRout(0) <= '0';
                -- NOT Rdst, Rsrc1
                when 3 => res1<= not src1;
                -- INC Rdst, Rsrc1
                when 4 => res1<= std_logic_vector(unsigned(src1) + 1);
                -- DEC Rdst, Rsrc1
                when 5 => res1<= std_logic_vector(unsigned(src1) - 1);
                -- OUT Rsrc1
                when 6 => outPort<= src1;
                -- IN Rdst
                when 7 => res1<= inPort;
                -- MOV Rdst, Rsrc1
                when 8 => res1<= src1;
                -- ADD Rdst, Rsrc1, Rsrc2
                when 9 => 
                    result := std_logic_vector(unsigned('0' & src1) + unsigned('0' & src2));
                    res1<= result(15 downto 0);
                    CCRout(0) <= result(16);
                    CCRout(1) <= result(15);
                    if (result(15 downto 0) = (15 downto 0 => '0'))
                    then
                        CCRout(2) <= '1';
                    else
                        CCRout(2) <= '0';
                    end if;

                -- SUB Rdst, Rsrc1, Rsrc2
                when 10 => 
                    result := std_logic_vector(unsigned('0' & src1) - unsigned('0' & src2));
                    res1<= result (15 downto 0);
                    CCRout(0) <= result(16);
                    CCRout(1) <= result(15);
                    if (result(15 downto 0) = (15 downto 0 => '0'))
                    then
                        CCRout(2) <= '1';
                    else
                        CCRout(2) <= '0';
                    end if;
                -- AND Rdst, Rsrc1, Rsrc2
                when 11 => 
                    result := '0' & src1 and '0' & src2;
                    res1<= result (15 downto 0);
                    CCRout(1) <= result(15);
                    if (result(15 downto 0) = (15 downto 0 => '0'))
                    then
                        CCRout(2) <= '1';
                    else
                        CCRout(2) <= '0';
                    end if;
                -- OR Rdst, Rsrc1, Rsrc2
                when 12 => 
                    result := '0' & src1 or '0' & src2;
                    res1<= result (15 downto 0);
                    CCRout(1) <= result(15);
                    if (result(15 downto 0) = (15 downto 0 => '0'))
                    then
                        CCRout(2) <= '1';
                    else
                        CCRout(2) <= '0';
                    end if;
                -- PUSH Rsrc1
                when 13 => 
                    res1 <= src1;
                    res2 <= SPin; -- destination
                    SPout <= std_logic_vector(unsigned(SPin) - 1);
                -- POP Rdst
                when 14 =>
                    res1 <= src1; -- destination
                    res2 <= std_logic_vector(unsigned(SPin) + 1);
                    SPout <= std_logic_vector(unsigned(SPin) + 1);
                -- LDD Rdst, Rsrc1
                when 15 => res1<= imm;
                -- STD Rsrc2, Rsrc1
                when 16 => 
                    res1<= src1;
                    res2<= src2;
                -- JZ Rdst
                when 17 => 
                    if(CCRin(2)='1') then
                        res1<= src1;
                        CCRout(2) <= '0';
                    end if;
                -- JC Rdst
                when 18 => 
                    if(CCRin(0)='1') then
                        res1<= src1;
                        CCRout(0) <= '0';
                    end if;
                -- JMP Rdst
                when 19 => res1<= src1;
                -- CALL Rdst
                when 20 => 
                    -- should update pc
                    res1<= src1;
                    res2<= SPin;
                    SPout <= std_logic_vector(unsigned(SPin) - 1);

                -- RET
                when 21 => 
                    -- should update pc
                    res1<= src1;
                    res2<= std_logic_vector(unsigned(SPin) + 1);
                    SPout <= std_logic_vector(unsigned(SPin) + 1);
                -- RTI
                when 22 =>
                    -- should update pc
                    -- should update flags
                    res1<= src1;
                    res2<= std_logic_vector(unsigned(SPin) + 1);
                    SPout <= std_logic_vector(unsigned(SPin) + 1);
                -- restore flags
                -- IADD Rdst, Rsrc1, Imm
                when 23 => 
                    result := std_logic_vector(unsigned('0' & src1) + unsigned('0' & imm));
                    res1<= result(15 downto 0);
                    CCRout(0) <= result(16);
                    CCRout(1) <= result(15);
                    if (result(15 downto 0) = (15 downto 0 => '0'))
                    then
                        CCRout(2) <= '1';
                    else
                        CCRout(2) <= '0';
                    end if;
                -- LDM Rdst, Imm
                when 24 => res1<= imm;

                when others=> res1<=(others=>'0'); 
            end case;
        end if;
    end process;
end architecture;