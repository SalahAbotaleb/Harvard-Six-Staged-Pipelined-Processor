entity ExecutionUnit is
    port (
        clk : in std_logic;
        AlUop: in std_logic_vector(4 downto 0);
        src1,src2,imm: in std_logic_vector(15 downto 0);
        ALUsrc,RegDst: in std_logic;
        inPort: in std_logic_vector(15 downto 0);
        res:out std_logic_vector(15 downto 0);
        CCR: out std_logic_vector(2 downto 0); -- Z(zero flag) | N(Negative flag) | C(Carry Flag)	
    );
end ExecutionUnit;

architecture ExecutionUnitArch of ExecutionUnit is
begin
process(clk)
variable opCodeint:integer;
begin
opCodeint:=to_integer(unsigned(ALUop));
if(rising_edge(clk)) begin 
    case opCodeint is
        when 0 => res<=(others=>'0');
        when 1 => res<=src1-src2;
        when 2 => res<=src1*src2;
        when 3 => res<=src1/src2;
        when 4 => res<=src1 and src2;
        when 5 => res<=src1 or src2;
        when 6 => res<=src1 xor src2;
        when 7 => res<=src1 nor src2;
        when 8 => res<=src1 nand src2;
        when 9 => res<=src1+imm;
        when 10 => res<=src1-imm;
        when 11 => res<=src1*imm;
        when 12 => res<=src1/imm;
        when 13 => res<=src1 and imm;
        when 14 => res<=src1 or imm;
        when 15 => res<=src1 xor imm;
        when 16 => res<=src1 nor imm;
        when 17 => res<=src1 nand imm;
        when 18 => res<=src1+inPort;
        when 19 => res<=src1-inPort;
        when 20 => res<=src1*inPort;
        when 21 => res<=src1/inPort;
        when 22 => res<=src1 and inPort;
        when 30 => res<=src1/src2;
        when 31 => res<=src1 and src2;
        when others=> res<=(others=>'0'); 
    end case;
end if;
end;


end architecture;