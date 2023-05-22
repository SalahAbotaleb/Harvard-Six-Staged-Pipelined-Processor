Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity ExecutionUnit is
    port (
        jumptaken: out std_logic;
        jumpadd: out std_logic_vector(15 downto 0);
        AlUop: in std_logic_vector(4 downto 0);
        src1,src2,imm: in std_logic_vector(15 downto 0);
        readflag: in std_logic;
        inPort: in std_logic_vector(15 downto 0);
        outPort: out std_logic_vector(15 downto 0):="0000000000000000";
        datares, memadd:out std_logic_vector(15 downto 0):="0000000000000000";
        CCRout: out std_logic_vector(2 downto 0) := "000" ; -- Z(zero flag) | N(Negative flag) | C(Carry Flag)
        CCRin: in std_logic_vector(2 downto 0); -- Z(zero flag) | N(Negative flag) | C(Carry Flag)
        SPin: in std_logic_vector(15 downto 0);
        SPout: out std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(1023,16));
        PCin: in std_logic_vector(15 downto 0)
    );
end ExecutionUnit;

architecture ExecutionUnitArch of ExecutionUnit is
begin
    process(AlUop,src1,src2,imm,CCRin,SPin,PCin,inPort,readflag)
    variable opCodeint: integer;
    variable result: std_logic_vector(16 downto 0);
    begin
        if(readflag = '1') then
            opCodeint := 14;
        else
            opCodeint:=to_integer(unsigned(ALUop));
        end if;
        
        case opCodeint is
            -- NOP
            when 0 => 
                datares<=(others=>'0');
                jumptaken <= '0';
                CCRout <= CCRin;
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- SETC
            when 1 => 
                CCRout(0) <= '1';
                datares<=(others=>'0');
                jumptaken <= '0';
                CCRout(2 downto 1) <= CCRin(2 downto 1);
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- CLRC
            when 2 => 
                CCRout(0) <= '0';
                jumptaken <= '0';
                datares<=(others=>'0');
                CCRout(2 downto 1) <= CCRin(2 downto 1);
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
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

                jumptaken <= '0';
                CCRout(0) <= CCRin(0);
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
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

                jumptaken <= '0';
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
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

                jumptaken <= '0';
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- OUT Rsrc1
            when 6 => 
                outPort<= src1;
                datares<=(others=>'0');
                jumptaken <= '0';
                CCRout <= CCRin;
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
            -- IN Rdst
            when 7 => 
                datares<= inPort;
                jumptaken <= '0';
                CCRout <= CCRin;
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- MOV Rdst, Rsrc1
            when 8 => 
                datares<= src1;
                jumptaken <= '0';
                CCRout <= CCRin;
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- ADD Rdst, Rsrc1, Rsrc2
            when 9 => 
                result := std_logic_vector(unsigned('0' & src1) + unsigned('0' & src2));
                datares<= result(15 downto 0);
                CCRout(0) <= result(16);
                CCRout(1) <= result(15);
                if (result(15 downto 0) = (15 downto 0 => '0'))
                then
                    CCRout(2) <= '1';
                else
                    CCRout(2) <= '0';
                end if;

                jumptaken <= '0';
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- SUB Rdst, Rsrc1, Rsrc2
            when 10 => 
                result := std_logic_vector(unsigned('0' & src1) - unsigned('0' & src2));
                datares<= result (15 downto 0);
                CCRout(0) <= result(16);
                CCRout(1) <= result(15);
                if (result(15 downto 0) = (15 downto 0 => '0'))
                then
                    CCRout(2) <= '1';
                else
                    CCRout(2) <= '0';
                end if;

                jumptaken <= '0';
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- AND Rdst, Rsrc1, Rsrc2
            when 11 => 
                result := '0' & src1 and '0' & src2;
                datares<= result(15 downto 0);
                CCRout(1) <= result(15);
                if (result(15 downto 0) = (15 downto 0 => '0'))
                then
                    CCRout(2) <= '1';
                else
                    CCRout(2) <= '0';
                end if;

                jumptaken <= '0';
                SPout <= SPin;
                CCRout(0) <= CCRin(0);
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- OR Rdst, Rsrc1, Rsrc2
            when 12 => 
                result := '0' & src1 or '0' & src2;
                datares<= result(15 downto 0);
                CCRout(1) <= result(15);
                if (result(15 downto 0) = (15 downto 0 => '0'))
                then
                    CCRout(2) <= '1';
                else
                    CCRout(2) <= '0';
                end if;

                jumptaken <= '0';
                SPout <= SPin;
                CCRout(0) <= CCRin(0);
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- PUSH Rsrc1
            when 13 => 
                datares <= src1;
                memadd <= SPin; -- destination
                SPout <= std_logic_vector(unsigned(SPin) - 1);

                jumptaken <= '0';
                CCRout <= CCRin;
                jumpadd <= (others => '0');
                outPort <= (others => '0');
            -- POP Rdst
            when 14 =>
                memadd <= std_logic_vector(unsigned(SPin) + 1);
                SPout <= std_logic_vector(unsigned(SPin) + 1);

                datares<=(others=>'0');
                jumptaken <= '0';
                CCRout <= CCRin;
                jumpadd <= (others => '0');
                outPort <= (others => '0');
            -- LDD Rdst, Rsrc1
            when 15 => 
                memadd<= src1;

                datares<=(others=>'0');
                jumptaken <= '0';
                CCRout <= CCRin;
                SPout <= SPin;
                jumpadd <= (others => '0');
                outPort <= (others => '0');
            -- STD Rsrc2, Rsrc1
            when 16 => 
                datares<= src1;
                memadd<= src2;

                jumptaken <= '0';
                CCRout <= CCRin;
                SPout <= SPin;
                jumpadd <= (others => '0');
                outPort <= (others => '0');
            -- JZ Rdst
            when 17 => 
                jumpadd <= src1;
                if(CCRin(2)='1') then
                    jumptaken <= '1';
                    CCRout(2) <= '0';
                else
                    jumptaken <= '0';
                    CCRout(2) <= CCRin(2);
                end if;

                datares<=(others=>'0');
                CCRout(1 downto 0) <= CCRin(1 downto 0);
                SPout <= SPin;
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- JC Rdst
            when 18 => 
                jumpadd <= src1;
                if(CCRin(0)='1') then
                    jumptaken <= '1';
                    CCRout(0) <= '0';
                else
                    jumptaken <= '0';
                    CCRout(0) <= CCRin(0);
                end if;

                datares<=(others=>'0');
                CCRout(2 downto 1) <= CCRin(2 downto 1);
                SPout <= SPin;
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- JMP Rdst
            when 19 => 
                jumpadd <= src1;
                jumptaken <= '1';

                datares<=(others=>'0');
                CCRout <= CCRin;
                SPout <= SPin;
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- CALL Rdst
            when 20 => 
                datares<= std_logic_vector(unsigned(PCin) + 1);
                memadd<= SPin;
                SPout <= std_logic_vector(unsigned(SPin) - 1);
                jumpadd <= src1;
                jumptaken <= '1';

                CCRout <= CCRin;
                outPort <= (others => '0');
            -- RET
            when 21 => 
                -- should update pc
                jumptaken <= '0';
                memadd<= std_logic_vector(unsigned(SPin) + 1);
                SPout <= std_logic_vector(unsigned(SPin) + 1);

                datares<=(others=>'0');
                CCRout <= CCRin;
                jumpadd <= (others => '0');
                outPort <= (others => '0');
            -- RTI
            when 22 =>
                -- should update pc
                -- should update flags
                jumptaken <= '0';
                memadd<= std_logic_vector(unsigned(SPin) + 1);
                SPout <= std_logic_vector(unsigned(SPin) + 1);

                datares<=(others=>'0');
                CCRout <= CCRin;
                jumpadd <= (others => '0');
                outPort <= (others => '0');
            -- restore flags
            -- IADD Rdst, Rsrc1, Imm
            when 30 => 
                result := std_logic_vector(unsigned('0' & src1) + unsigned('0' & imm));
                datares<= result(15 downto 0);
                CCRout(0) <= result(16);
                CCRout(1) <= result(15);
                if (result(15 downto 0) = (15 downto 0 => '0'))
                then
                    CCRout(2) <= '1';
                else
                    CCRout(2) <= '0';
                end if;

                jumptaken <= '0';
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
            -- LDM Rdst, Imm
            when 31 => 
                datares <= imm;

                memadd<=(others=>'0');
                jumptaken <= '0';
                CCRout <= CCRin;
                SPout <= SPin;
                jumpadd <= (others => '0');
                outPort <= (others => '0');

            when others=> 
                datares<=(others=>'0');
                jumptaken <= '0';
                CCRout <= CCRin;
                SPout <= SPin;
                jumpadd <= (others => '0');
                memadd <= (others => '0');
                outPort <= (others => '0');
        end case;
    end process;
end architecture;