library ieee;
use ieee.std_logic_1164.all;
entity mux4x1 is 
generic(n:integer:=10);
port(in0,in1,in2,in3:in std_logic_vector (n-1 downto 0);
sel:in std_logic_vector (1 downto 0); out1:out std_logic_vector (n-1 downto 0));
end entity;

architecture mux4x1a of mux4x1 is
begin
out1 <= in0 When sel="00" 
else in1 When sel="01"
else in2 When sel="10"
else in3;
end mux4x1a;

