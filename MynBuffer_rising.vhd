Library ieee;
use ieee.std_logic_1164.all;
--!!!!! Enable must be equal 1 to work
entity MynBuffer_rising is
    generic(n:integer :=10);
  port (
    clk,rst,en:in std_logic;d:in std_logic_vector(n-1 downto 0);
    q:out std_logic_vector(n-1 downto 0)
  ) ;
end MynBuffer_rising;
architecture MynBuffer_risingArch of MynBuffer_rising is
begin
    PROCESS(clk,rst)
    BEGIN
    IF(rst = '1') THEN
     q <= (others=>'0');
    ELSIF (clk'event and clk = '1' and en='1') THEN 
     q <= d;
    END IF;
    END PROCESS;
end MynBuffer_risingArch ; -- MynBuffer_arch