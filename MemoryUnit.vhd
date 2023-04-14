Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity MemoryUnit is
    generic(buffersize:integer :=16);
    port (
        clk : in std_logic;
        rst:in std_logic; --this reset intialize the Register File to 0
        en: in std_logic;
        Readadd: in std_logic_vector(15 downto 0);
        Writeadd: in std_logic_vector(15 downto 0);
        Bufferinfo: in std_logic_vector(buffersize-1 downto 0); --to be changed 
        Bufferinfo_out:out std_logic_vector(1 downto 0)
    );
end MemoryUnit;



architecture MemoryUnitArch of MemoryUnit is
    signal instr1,instr2,nxtInstr:std_logic_vector(15 downto 0):=(others=>'0');
begin
nxtInstr<=std_logic_vector(unsigned(currInstrPc)+1);

instructionFile: entity work.MyMemory generic map(16,16)port map(clk=>clk,rst=>rst,w_en=>'0',r_add1=>currInstrPc
,r_add2=>nxtInstr,w_add=>(others=>'0'),write_port=>(others=>'0'),read_port_rs=>instr1,read_port_rt=>instr2);
instr<=instr1&instr2;
process(clk)
begin
if(rising_edge(clk)) then
if(instr1(15 downto 13)="111") then
    pcNxtAddAmt<="10";
else
    pcNxtAddAmt<="01";
end if;
end if;
end process;
end architecture;