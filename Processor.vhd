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
signal fdout : std_logic_vector(31 downto 0);
signal read_port_rs : std_logic_vector(15 downto 0);
signal read_port_rt : std_logic_vector(15 downto 0);
signal wbout : std_logic_vector(15 downto 0);
signal ALUop : std_logic_vector(4 downto 0);
signal ALUsrc,RegDst,MEMWrite,MEMRead,MemtoReg,RegWrite : std_logic;
signal dein : std_logic_vector(58 downto 0);
signal deout : std_logic_vector(58 downto 0);
signal Alures : std_logic_vector(15 downto 0);
signal AluCCR : std_logic_vector(2 downto 0);
signal emin : std_logic_vector(38 downto 0)
signal emout : std_logic_vector(38 downto 0);
signal read_port : std_logic_vector(15 downto 0);
signal mwbin : std_logic_vector(17 downto 0);
signal mwbout : std_logic_vector(17 downto 0);
-----------------------------------------------
------------------fdout------------------------
--31 downto 27      --opcode
--26 downto 24      --write address
--23 downto 21      --read address 1
--20 downto 18      --read address 2
-----------------------------------------------
------------------dein-------------------------
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
--38 downto 23      --write data  (rt)
--22 downto 7       --ALU result
--6 downto 4        --CCR
--3                 --MEMWrite
--2                 --MEMRead
--1                 --MemtoReg
--0                 --RegWrite
-----------------------------------------------
begin
pc: entity work.pc port map(clk=>clk, rst=>rst, en=>'1', addAmt =>addAmt , ci=>curr_instr);
FetchUnit: entity work.FetchUnit port map(clk=>clk, rst=>rst, currInstrPc=>curr_instr, instr=>instr, pcNxtAddAmt=>addAmt);
FD_Buffer: entity work.MynBuffer generic map (32) port map(clk => clk, rst => rst, en=>'1' , d=>instr , q=>fdout);
RegFile: entity work.MyMemory generic map (16,3) port map(clk => clk, rst => rst, w_en => wr_en, r_add1 => fdout(23 downto 21), r_add2 => fdout(20 downto 18), w_add =>fdout(26 downto 24), write_port => wbout, read_port_rs => read_port_rs, read_port_rt => read_port_rt);
ControlUnit: entity work.ControlUnit port map(opcode => fdout(31 downto 27), AlUop => AlUop, AlUsrc => AlUsrc, RegDst => RegDst, MEMWrite => MEMWrite, MEMRead => MEMRead, MemtoReg => MemtoReg, RegWrite => RegWrite);
dein <= fdout(15 downto 0) & read_port_rs & read_port_rt & AlUop & AlUsrc & RegDst & MEMWrite & MEMRead & MemtoReg & RegWrite;
DE_Buffer: entity work.MynBuffer generic map (59) port map(clk => clk , rst => rst, en => '1', d => dein, q => deout);
ExecutionUnit: entity work.ExecutionUnit port map(clk => clk, ALUop => deout(11 downto 6), src1 => deout(42 downto 27) ,src2 => deout(26 downto 11), imm => deout(58 downto 43), ALUsrc => deout(5), RegDst => deout(4),inPort => inPort, res => Alures, CCR => AluCCR);
emin <= read_port_rt & Alures & AluCCR & deout(3 downto 0);
EM_Buffer: entity work.MynBuffer generic map (39) port map(clk => clk , rst => rst, en => '1', d => emin, q => emout);
MyDataMemory: entity work.MyMemory generic map (16,16) port map(clk => clk, rst => rst, w_en => emout(3), r_add1 => emout(22 downto 7), w_add => emout(22 downto 7), write_port => emout(38 downto 23), read_port => read_port);
------problem in generic map for address size 16 or 10 bits?????
------read add and write add are same?????????????
------some control signal are not input to mydatamemory
mwbin <= read_port & emout(1 downto 0);
MWB_Buffer: entity work.MynBuffer generic map (16) port map(clk => clk , rst => rst, en => emout(0), d => mwbin, q => mwbout);

end architecture;