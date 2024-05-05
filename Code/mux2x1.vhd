library ieee;
use ieee.std_logic_1164.all;
entity mux2x1 is 
generic(n:integer:=10);
port(in0,in1:in std_logic_vector (n-1 downto 0);
sel:in std_logic; out1:out std_logic_vector (n-1 downto 0));
end entity;

architecture mux2x1a of mux2x1 is
begin
out1 <= in0 When sel='0' 
else in1;
end mux2x1a;

