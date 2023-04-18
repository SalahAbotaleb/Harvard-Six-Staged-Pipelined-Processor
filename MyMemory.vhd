Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity MyMemory is
  generic(
  WORD_LENGTH:integer:=16;
  MEMORY_SELECTORS:integer:=10
  );
  port (
    clk,rst,w_en:in std_logic;
    r_add1,r_add2,w_add:in std_logic_vector (MEMORY_SELECTORS-1 downto 0);
    write_port:in std_logic_vector(WORD_LENGTH-1 downto 0);
    read_port_rs:out std_logic_vector(WORD_LENGTH-1 downto 0);
    read_port_rt:out std_logic_vector(WORD_LENGTH-1 downto 0)

  ) ;
end MyMemory;
architecture MyMemory_arch of MyMemory is
  type ram_type is array (0 to (2**MEMORY_SELECTORS)-1) of std_logic_vector (WORD_LENGTH-1 downto 0);
  signal x: ram_type;
begin
  process(clk,rst)
  BEGIN
    if rst='1' then
      x <= (others=>(others=>'0'));
    elsif (falling_edge(clk))  then
      if(w_en = '1') then
        x(to_integer(unsigned(w_add))) <= write_port;
      end if;
    end if;
  end process;
  read_port_rs<=x(to_integer(unsigned(r_add1)));
  read_port_rt<=x(to_integer(unsigned(r_add2)));
end MyMemory_arch ; 