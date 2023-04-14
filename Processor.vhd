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
begin
pc: entity work.pc();
FetchUnit: entity work.FetchUnit();
RegFile: entity work.MyMemory();
FD_Buffer: entity work.MynBuffer();
DE_Buffer: entity work.MynBuffer();


end architecture;