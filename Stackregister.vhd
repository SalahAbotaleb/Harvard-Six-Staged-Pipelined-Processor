Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--!!!!! Enable must be equal 1 to work
entity Stackregister is
    generic(n:integer := 16);
  port (
    clk,rst,en:in std_logic;
    d:in std_logic_vector(n-1 downto 0) := std_logic_vector(to_unsigned(1023,16));
    q:out std_logic_vector(n-1 downto 0)
);
end Stackregister;
architecture Stackregister_arch of Stackregister is
begin
    PROCESS(clk,rst)
    BEGIN
        IF(rst = '1') THEN
            q <= std_logic_vector(to_unsigned(1023,16));
        ELSIF (clk'event and clk = '1' and en='1') THEN 
            q <= d;
        END IF;
    END PROCESS;
end Stackregister_arch ;