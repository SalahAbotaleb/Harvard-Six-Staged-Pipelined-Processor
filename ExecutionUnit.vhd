Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity ExecutionUnit is
    port (
        clk : in std_logic;
        AlUop: in std_logic_vector(4 downto 0);
        src1,src2,imm: in std_logic_vector(15 downto 0);
        ALUsrc,RegDst: in std_logic;
        inPort: in std_logic_vector(15 downto 0);
        res:out std_logic_vector(15 downto 0);
        CCR: out std_logic_vector(2 downto 0) -- Z(zero flag) | N(Negative flag) | C(Carry Flag)	
    );
end ExecutionUnit;

architecture ExecutionUnitArch of ExecutionUnit is
begin
process(clk)
variable opCodeint:integer;
begin
opCodeint:=to_integer(unsigned(ALUop));
if(rising_edge(clk)) then 
    case opCodeint is
        when 0 => res<=(others=>'0');
        when others=> res<=(others=>'0'); 
    end case;
end if;
    end process;
end architecture;