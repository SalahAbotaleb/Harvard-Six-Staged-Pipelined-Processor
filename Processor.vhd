Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity Processor is
    port (
        clk : in std_logic;
        rst : in std_logic;
        inPort: in std_logic_vector(15 downto 0);
        outPort: out std_logic_vector(15 downto 0)
    );
end Processor;

architecture ProcessorArch of Processor is
signal wr_en : std_logic:='0';
signal addAmt : std_logic_vector(1 downto 0);
signal curr_instr : std_logic_vector(15 downto 0);
signal instr : std_logic_vector(31 downto 0);
signal fdin : std_logic_vector(47 downto 0);
signal fdout : std_logic_vector(47 downto 0);
signal read_port_rs : std_logic_vector(15 downto 0);
signal read_port_rt : std_logic_vector(15 downto 0);
signal data : std_logic_vector(15 downto 0);
signal ALUop : std_logic_vector(4 downto 0);
signal ALUsrc,RegDst,MEMWrite,MEMRead,MemtoReg,RegWrite : std_logic;
signal dein : std_logic_vector(74 downto 0);
signal deout : std_logic_vector(74 downto 0);
signal DataRes : std_logic_vector(15 downto 0);
signal Memadd : std_logic_vector(15 downto 0);
signal AluCCRout : std_logic_vector(2 downto 0);
signal AluCCRin : std_logic_vector(2 downto 0) := "000";
signal SPin : std_logic_vector(15 downto 0);
signal SPout : std_logic_vector(15 downto 0);
signal emin : std_logic_vector(35 downto 0);
signal emout : std_logic_vector(35 downto 0);
signal read_data : std_logic_vector(15 downto 0);
signal mwbin : std_logic_vector(33 downto 0);
signal mwbout : std_logic_vector(33 downto 0);
-----------------------------------------------
------------------fdin------------------------
--47 downto 32      --current instruction (PC)
--31 downto 27      --opcode
--26 downto 24      --write address
--23 downto 21      --read address 1
--20 downto 18      --read address 2
-----------------------------------------------
------------------dein-------------------------
--74 downto 59      --current instruction (PC)
--58 downto 43      --immediate
--42 downto 27      --read data 1   (rs)
--26 downto 11      --read data 2   (rt)
--10 downto 6       --ALUop
--5                 --ALUsrc
--4                 --RegDst
--3                 --MEMWrite
--2                 --MEMRead
--1                 --MemtoReg
--0                 --RegWrite
-----------------------------------------------
------------------emin-------------------------
--35 downto 20      --DataRes
--19 downto 4       --Memadd    (13 downto 4)
--3                 --MEMWrite
--2                 --MEMRead
--1                 --MemtoReg
--0                 --RegWrite
-----------------------------------------------
------------------mwbin------------------------
--33 downto 18       --DataRes
--17 downto 2        --read_data
--1                  --MemtoReg
--0                  --RegWrite

begin
pc: entity work.pc port map(clk=>clk, rst=>rst, en=>'1', addAmt =>addAmt , ci=>curr_instr);
FetchUnit: entity work.FetchUnit port map(clk=>clk, rst=>rst, currInstrPc=>curr_instr, instr=>instr, pcNxtAddAmt=>addAmt);
fdin <= curr_instr & instr;
FD_Buffer: entity work.MynBuffer generic map (48) port map(clk => clk, rst => rst, en=>'1' , d=>fdin , q=>fdout);
RegFile: entity work.MyMemory generic map (16,3) port map(clk => clk, rst => rst, w_en => mwbout(0), r_add1 => fdout(23 downto 21), r_add2 => fdout(20 downto 18), w_add =>fdout(26 downto 24), write_port => data, read_port_rs => read_port_rs, read_port_rt => read_port_rt);
ControlUnit: entity work.ControlUnit port map(opcode => fdout(31 downto 27), AlUop => AlUop, AlUsrc => AlUsrc, RegDst => RegDst, MEMWrite => MEMWrite, MEMRead => MEMRead, MemtoReg => MemtoReg, RegWrite => RegWrite);
dein <= fdout(47 downto 32) & fdout(15 downto 0) & read_port_rs & read_port_rt & AlUop & AlUsrc & RegDst & MEMWrite & MEMRead & MemtoReg & RegWrite;
DE_Buffer: entity work.MynBuffer generic map (75) port map(clk => clk , rst => rst, en => '1', d => dein, q => deout);
CCR_Buffer: entity work.MynBuffer generic map (3) port map(clk => clk , rst => rst, en => '1', d => AluCCRout, q => AluCCRin);
SP_Buffer: entity work.MynBuffer generic map (16) port map(clk => clk , rst => rst, en => '1', d => SPout, q => SPin);
ExecutionUnit: entity work.ExecutionUnit port map(clk => clk, ALUop => deout(10 downto 6), src1 => deout(42 downto 27) ,src2 => deout(26 downto 11), imm => deout(58 downto 43), ALUsrc => deout(5), RegDst => deout(4),inPort => inPort, datares => DataRes, memadd => Memadd, CCRout => AluCCRout, CCRin => AluCCRin, SPin =>SPin, SPout=> SPout, PCin => deout(74 downto 59));
emin <= DataRes & Memadd & deout(3 downto 0);
EM_Buffer: entity work.MynBuffer generic map (36) port map(clk => clk , rst => rst, en => '1', d => emin, q => emout);
MemoryUnit: entity work.MemoryUnit generic map (16,10) port map(clk => clk, rst => rst, en=>'1', Readadd => emout(13 downto 4), Writeadd => emout(13 downto 4),read_en => emout(2), write_en => emout(3), write_data => emout(35 downto 20), read_data => read_data);
mwbin <= DataRes & read_data & emout(1 downto 0);
MWB_Buffer: entity work.MynBuffer generic map (34) port map(clk => clk , rst => rst, en => '1', d => mwbin, q => mwbout);

data <= mwbout(33 downto 18) when mwbout(1) = '1' else mwbout(17 downto 2);

end architecture;