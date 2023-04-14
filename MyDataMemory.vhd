Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity MyDataMemory is
  generic(
  WORD_LENGTH:integer:=16;
  MEMORY_SELECTORS:integer:=10
  );
  port (
    clk,rst,w_en:in std_logic;
    r_add1,w_add:in std_logic_vector (MEMORY_SELECTORS-1 downto 0);
    write_port:in std_logic_vector(WORD_LENGTH-1 downto 0);
    read_port:out std_logic_vector(WORD_LENGTH-1 downto 0)
  ) ;
  
end MyDataMemory;
architecture MyDataMemory_arch of MyDataMemory is
  type ram_type is array (0 to (2**MEMORY_SELECTORS)-1) of std_logic_vector (WORD_LENGTH-1 downto 0);
  signal x: ram_type;
  signal Clkmod:std_logic;
  begin
  process(clk,rst)
  BEGIN
   if rst='1' then
    x<=(others=>(others=>'0'));
  elsif (clk'event and clk = '1' and en='1')  then
    if (Clkmod = 1) then
      x(to_integer(unsigned(w_add)))<=write_port;
        Clkmod <= 0;
    else
        Clkmod <= 1;
        end if;
  end if;
  end process;
    read_port<=x(to_integer(unsigned(r_add)));
end MyDataMemory_arch ; 