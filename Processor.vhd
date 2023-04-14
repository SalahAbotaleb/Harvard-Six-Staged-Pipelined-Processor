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
--signal en : std_logic;
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
--31 downto 27      --opcode
--26 downto 24      --write address
--23 downto 21      --read address 1
--20 downto 18      --read address 2
begin
pc: entity work.pc port map(clk=>clk, rst=>rst, en=>'1', addAmt =>addAmt , ci=>curr_instr);
FetchUnit: entity work.FetchUnit port map(clk=>clk, rst=>rst, currInstrPc=>curr_instr, instr=>instr, pcNxtAddAmt=>addAmt);
FD_Buffer: entity work.MynBuffer generic map (32) port map(clk => clk, rst => rst, en=>'1' , d=>instr , q=>fdout);
RegFile: entity work.MyMemory port map(clk => clk, rst => rst, w_en => '1', r_add1 => fdout(23 downto 21), r_add2 => fdout(20 downto 18), w_add =>fdout(26 downto 24), write_port => wbout, read_port_rs => read_port_rs, read_port_rt => read_port_rt);
ControlUnit: entity work.ControlUnit port map(opcode => fdout(31 downto 27), AlUop => AlUop, AlUsrc => AlUsrc, RegDst => RegDst, MEMWrite => MEMWrite, MEMRead => MEMRead, MemtoReg => MemtoReg, RegWrite => RegWrite);
dein <= fdout(15 downto 0) & read_port_rs & read_port_rt & AlUop & AlUsrc & RegDst & MEMWrite & MEMRead & MemtoReg & RegWrite;
DE_Buffer: entity work.MynBuffer generic map (58) port map(clk => clk , rst => rst, en => '1', d => dein, q => deout);
ExecutionUnit: entity work.ExecutionUnit port map(clk => clk, ALUop => deout(11 downto 6), src1 => deout(42 downto 27) ,src2 => deout(26 downto 11), imm => deout(58 downto 43), ALUsrc => deout(10), RegDst => deout(9),inPort => inPort, res => Alures, CCR => AluCCR);

end architecture;