library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Tb_EX is
end entity;

Architecture exsim of Tb_EX is
signal clk: std_logic;
signal AlUop: std_logic_vector(4 downto 0) := b"00000";
signal src1,src2,imm: std_logic_vector(15 downto 0);
signal ALUsrc,RegDst: std_logic;
signal inPort: std_logic_vector(15 downto 0);
signal outPort: std_logic_vector(15 downto 0);
signal res1, res2: std_logic_vector(15 downto 0) := b"0000000000000000";
signal CCRout: std_logic_vector(2 downto 0); -- Z(zero flag) | N(Negative flag) | C(Carry Flag)
signal CCRin: std_logic_vector(2 downto 0); -- Z(zero flag) | N(Negative flag) | C(Carry Flag)
signal SPin: std_logic_vector(15 downto 0);
signal SPout: std_logic_vector(15 downto 0);
signal PCin: std_logic_vector(15 downto 0);

Begin
    alu: entity work.ExecutionUnit port map (
        AlUop => AlUop,
        src1 => src1,
        src2 => src2,
        imm => imm,
        inPort => inPort,
        outPort => outPort,
        datares => res1,
        memadd => res2,
        CCRout => CCRout,
        CCRin => CCRin,
        SPin => SPin,
        SPout => SPout,
        PCin => PCin,
        readflag => '0'
    );

    src1 <= b"1010101010101010";
    src2 <= b"0101010101010101";
    imm <= b"0110011001100110";
    inPort <= b"1111000011110000";
    CCRin <= b"000";
    SPin <= b"0000111100001111";


    process
    begin
        clk <= '1';
        wait for 100 ps;
        clk <= '0';
        wait for 100 ps;
        AlUop <= std_logic_vector(unsigned(AlUop) + 1);
        if unsigned(AlUop) = 31 then
            wait;
        end if;
    end process;
end exsim;
