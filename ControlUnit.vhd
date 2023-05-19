Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity ControlUnit is
    port (
        opCode: in std_logic_vector(4 downto 0);
        AlUop: out std_logic_vector(4 downto 0);	
        ALUsrc,RegDst,MEMWrite,MEMRead,MemtoReg,RegWrite,RetBranch,RtiBranch: out std_logic
    );
end ControlUnit;

architecture ControlUnitArch of ControlUnit is
begin
process(opCode)
variable opCodeint:integer;
begin
opCodeint:=to_integer(unsigned(opCode));
ALUop<=opCode;
CASE opCodeint IS
WHEN 0 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 1 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 2 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 3 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 4 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 5 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 6 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 7 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 8 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 9 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 10 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 11 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 12 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 13 => ALUsrc<='0';RegDst<='0';MEMWrite<='1';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 14 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='1';MemtoReg<='0';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 15 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='1';MemtoReg<='0';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 16 => ALUsrc<='0';RegDst<='0';MEMWrite<='1';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 17 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 18 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 19 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 20 => ALUsrc<='0';RegDst<='0';MEMWrite<='1';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
WHEN 21 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='1';MemtoReg<='0';RegWrite<='0';RetBranch<='1';RtiBranch<='0';
WHEN 22 => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='1';MemtoReg<='0';RegWrite<='0';RetBranch<='1';RtiBranch<='1';
WHEN 30 => ALUsrc<='1';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='1';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN 31 => ALUsrc<='1';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='0';RegWrite<='1';RetBranch<='0';RtiBranch<='0';
WHEN others => ALUsrc<='0';RegDst<='0';MEMWrite<='0';MEMRead<='0';MemtoReg<='0';RegWrite<='0';RetBranch<='0';RtiBranch<='0';
END CASE;
end process;

end architecture;