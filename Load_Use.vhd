Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity Load_Use is
    port (
        Rsrc1,Rsrc2: in std_logic_vector(2 downto 0);--buffer out of the decode stage
        RdAlu: in std_logic_vector(2 downto 0);--buffer out of the Alu stage
        MemReadAlu: in std_logic;--coming from the Alu buffer control signal
        Register_WriteAlu: in std_logic;--coming from the Alu buffer control signal
        RdMem1: in std_logic_vector(2 downto 0);--buffer out of the Mem1 stage
        MemReadMem1: in std_logic;--coming from the Mem1 buffer control signal
        Register_WriteMem1: in std_logic;--coming from the Mem1 buffer control signal
        stall1,stall2: out std_logic
    );
end Load_Use;

architecture Load_UseArch of Load_Use is
begin
process(Rsrc1,Rsrc2,RdAlu,MemReadAlu,Register_WriteAlu,RdMem1,MemReadMem1,Register_WriteMem1)
variable opCodeint:integer;
begin
    if((Rsrc1=RdAlu or Rsrc2=RdAlu) and MemReadAlu = '1' and Register_WriteAlu = '1') then
        stall2<='1';
    else if((Rsrc1=RdMem1 or Rsrc2=RdMem1) and MemReadMem1 = '1' and Register_WriteMem1 = '1') then
        stall1<='1';
    else
        stall2<='0';
        stall1<='0';
    end if;

    end if;
end process;

end architecture;