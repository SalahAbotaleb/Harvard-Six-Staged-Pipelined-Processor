Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity Fetch is
    port (
        clk : in std_logic;
        rst:in std_logic; --this reset intialize the Register File to 0
        currInstrPc: in std_logic_vector(15 downto 0);
        instr: out std_logic_vector(31 downto 0);  
        pcNxtAddAmt:out std_logic_vector(1 downto 0); 
    );
end Fetch;

clk,rst,w_en:in std_logic;r_add,w_add:in std_logic_vector (MEMORY_SELECTORS-1 downto 0);
    write_port:in std_logic_vector(WORD_LENGTH-1 downto 0);
    read_port:out std_logic_vector(WORD_LENGTH-1 downto 0)

architecture FetchArch of Fetch is
begin
instructionFile: work.MyMemory generic map(16,)port map(clk=>clk,rst=>rst,w_en=>'0',);
process(clk)
begin
if(rising_edge(clk)) then

end if;
end process;


end architecture;