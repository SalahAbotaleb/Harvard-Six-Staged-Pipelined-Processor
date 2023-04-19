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
        datares, memadd:out std_logic_vector(15 downto 0);
        CCRout: out std_logic_vector(2 downto 0); -- Z(zero flag) | N(Negative flag) | C(Carry Flag)
        CCRin: in std_logic_vector(2 downto 0); -- Z(zero flag) | N(Negative flag) | C(Carry Flag)
        SPin: in std_logic_vector(15 downto 0);
        SPout: out std_logic_vector(15 downto 0);
        PCin: in std_logic_vector(15 downto 0)
    );
end ExecutionUnit;

architecture ExecutionUnitArch of ExecutionUnit is
begin
    process(AlUop,src1,src2,imm,ALUsrc,RegDst,CCRin,SPin,PCin,inPort)
    variable opCodeint: integer;
    variable result: std_logic_vector(16 downto 0);
    variable SPplus1: std_logic_vector(15 downto 0);
    variable sr2: std_logic_vector(15 downto 0);
    begin
        if(AlUsrc = '1') then
            sr2 := imm;
        else
            sr2 := src2;
        end if;
        opCodeint:=to_integer(unsigned(ALUop));
        case opCodeint is
            -- NOP
            when 0 => datares<=(others=>'0');
            -- SETC
            when 1 => 
                CCRout(0) <= '1';
            -- CLRC
            when 2 => 
                CCRout(0) <= '0';
            -- NOT Rdst, Rsrc1
            when 3 => 
                result := '0' & not src1;
                datares<= result(15 downto 0);
                CCRout(1) <= result(15);
                if (result(15 downto 0) = (15 downto 0 => '0'))
                then
                    CCRout(2) <= '1';
                else
                    CCRout(2) <= '0';
                end if;
            -- INC Rdst, Rsrc1
            when 4 => 
                result := std_logic_vector(unsigned('0' & src1) + 1);
                datares<= result(15 downto 0);
                CCRout(0) <= result(16);
                CCRout(1) <= result(15);
                if (result(15 downto 0) = (15 downto 0 => '0'))
                then
                    CCRout(2) <= '1';
                else
                    CCRout(2) <= '0';
                end if;
            -- DEC Rdst, Rsrc1
            when 5 => 
                result := std_logic_vector(unsigned('0' & src1) - 1);
                datares<= result(15 downto 0);
                CCRout(0) <= result(16);
                CCRout(1) <= result(15);
                if (result(15 downto 0) = (15 downto 0 => '0'))
                then
                    CCRout(2) <= '1';
                else
                    CCRout(2) <= '0';
                end if;
            -- OUT Rsrc1
            when 6 => outPort<= src1;
            -- IN Rdst
            when 7 => datares<= inPort;
            -- MOV Rdst, Rsrc1
            when 8 => datares<= src1;
            -- ADD Rdst, Rsrc1, Rsrc2
            when 9 => 
                result := std_logic_vector(unsigned('0' & src1) + unsigned('0' & sr2));
                datares<= result(15 downto 0);
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
                result := std_logic_vector(unsigned('0' & src1) - unsigned('0' & sr2));
                datares<= result (15 downto 0);
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
                datares<= src1 and sr2;
            -- OR Rdst, Rsrc1, Rsrc2
            when 12 => 
                datares<= src1 or sr2;
            -- PUSH Rsrc1
            when 13 => 
                datares <= src1;
                memadd <= SPin; -- destination
                SPout <= std_logic_vector(unsigned(SPin) - 1);
            -- POP Rdst
            when 14 =>
                datares <= std_logic_vector(unsigned(SPin) + 1);
                SPout <= std_logic_vector(unsigned(SPin) + 1);
            -- LDD Rdst, Rsrc1
            when 15 => memadd<= src1;
            -- STD Rsrc2, Rsrc1
            when 16 => 
                datares<= src1;
                memadd<= sr2;
            -- JZ Rdst
            when 17 => 
                if(CCRin(2)='1') then
                    datares<= src1;
                    CCRout(2) <= '0';
                end if;
            -- JC Rdst
            when 18 => 
                if(CCRin(0)='1') then
                    datares<= src1;
                    CCRout(0) <= '0';
                end if;
            -- JMP Rdst
            when 19 => datares<= src1;
            -- CALL Rdst
            when 20 => 
                -- should update pc
                datares<= std_logic_vector(unsigned(PCin) + 1);
                memadd<= SPin;
                SPout <= std_logic_vector(unsigned(SPin) - 1);
            -- RET
            when 21 => 
                -- should update pc
                memadd<= std_logic_vector(unsigned(SPin) + 1);
                SPout <= std_logic_vector(unsigned(SPin) + 1);
            -- RTI
            when 22 =>
                -- should update pc
                -- should update flags
                memadd<= std_logic_vector(unsigned(SPin) + 1);
                SPout <= std_logic_vector(unsigned(SPin) + 1);
            -- restore flags
            -- IADD Rdst, Rsrc1, Imm
            when 30 => 
                result := std_logic_vector(unsigned('0' & src1) + unsigned('0' & sr2));
                datares<= result(15 downto 0);
                CCRout(0) <= result(16);
                CCRout(1) <= result(15);
                if (result(15 downto 0) = (15 downto 0 => '0'))
                then
                    CCRout(2) <= '1';
                else
                    CCRout(2) <= '0';
                end if;
            -- LDM Rdst, Imm
            when 31 => datares<= sr2;

            when others=> datares<=(others=>'0'); 
        end case;
    end process;
end architecture;