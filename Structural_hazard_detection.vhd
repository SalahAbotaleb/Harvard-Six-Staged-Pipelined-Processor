Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity Load_Use is
    port (
        MemReadAlu: in std_logic;--coming from the Alu buffer control signal
        MemWriteAlu: in std_logic;--coming from the Alu buffer control signal
        MemReadMem1: in std_logic;--coming from the Mem1 buffer control signal
        MemWriteMem1: in std_logic;--coming from the Mem1 buffer control signals
        stall: out std_logic
    );
end Load_Use;

architecture Load_UseArch of Load_Use is
begin
process(MemReadAlu,MemWriteAlu,MemReadMem1,MemWriteMem1)
variable opCodeint:integer;
begin
    if((MemReadAlu = '1' or MemWriteAlu = '1') and (MemReadMem1 = '1' or MemWriteMem1 = '1')) then
        stall<='1';
    else
        stall<='0';
    end if;
end process;

end architecture;