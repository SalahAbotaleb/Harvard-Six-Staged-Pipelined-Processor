Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity MyDataMemory is
  generic(
  WORD_LENGTH:integer:=16;
  MEMORY_SELECTORS:integer:=16
  );
  port (
    clk,w_en,en:in std_logic;
    r_add,w_add:in std_logic_vector (MEMORY_SELECTORS-1 downto 0);
    write_port:in std_logic_vector(WORD_LENGTH-1 downto 0);
    read_port:out std_logic_vector(WORD_LENGTH-1 downto 0);
    read_en:in std_logic
  ) ;
  
end MyDataMemory;
architecture MyDataMemory_arch of MyDataMemory is
  type ram_type is array (0 to (2**MEMORY_SELECTORS)-1) of std_logic_vector (WORD_LENGTH-1 downto 0);
  signal x: ram_type;
  begin
  process(clk)
  BEGIN
  if(clk'event and clk = '1' and en='1')  then
    if (w_en = '1') then
      x(to_integer(unsigned(w_add)))<=write_port;
    end if;
    if (read_en = '1') then
    --read_en'event and read_en = '1'
    -- if (read_en'event and read_en = '1') then
    --   x(to_integer(unsigned(w_add)))<=write_port;
      read_port<=x(to_integer(unsigned(r_add)));
    end if;
  end if;
  end process;
end MyDataMemory_arch ; 