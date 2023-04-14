Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity Processor is
    port (
        clk : in std_logic;
        rst : in std_logic;
        inPort: in std_logic_vector(15 downto 0);
        outPort: out std_logic_vector(15 downto 0);
    );
end Processor;

architecture ProcessorArch of Processor is
--signal cont_en : std_logic;
signal addAmt : std_logic_vector(1 downto 0);
signal curr_intsr : std_logic_vector(15 downto 0);
signal instr : std_logic_vector(31 downto 0);
signal fdout : std_logic_vector(31 downto 0);


begin
pc: entity work.pc port map(clk=>clk, rst=>rst, en=>'1', addAmt =>addAmt , ci=>curr_instr);
FetchUnit: entity work.FetchUnit port map(clk=>clk, rst=>rst, currInstrPc=>curr_instr, instr=>instr, pcNxtAddAmt=>addAmt);
RegFile: entity work.MyMemory port map();
FD_Buffer: entity work.MynBuffer generic map (32) port map(clk => clk, rst => rst, en=>'1' , d=>instr , q=>fdout);
DE_Buffer: entity work.MynBuffer port map();


end architecture;