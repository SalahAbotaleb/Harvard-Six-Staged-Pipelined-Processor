Library ieee;
use ieee.std_logic_1164.all;
--!!!!! Enable must be equal 1 to work
entity MynBuffer is
    generic(n:integer :=10);
  port (
    clk,rst,en:in std_logic;d:in std_logic_vector(n-1 downto 0);
    q:out std_logic_vector(n-1 downto 0):= (others=>'0')
  ) ;
end MynBuffer;
architecture MynBufferArch of MynBuffer is
begin
    PROCESS(clk)
    BEGIN
    
    IF (clk'event and clk = '1') then
        if (rst='1') then
            q<= (others=>'0');
        elsif (en='1') then
            q <= d;
        end if;
    END IF;
    END PROCESS;
end MynBufferArch ; -- MynBuffer_arch