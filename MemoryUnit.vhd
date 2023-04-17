Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity MemoryUnit is
    generic(WORD_LENGTH:integer:=16;
    MEMORY_SELECTORS:integer:=16);
    port (
        clk : in std_logic;
        rst:in std_logic; --this reset intialize the Register File to 0
        en: in std_logic;
        Readadd: in std_logic_vector(MEMORY_SELECTORS-1 downto 0);
        Writeadd: in std_logic_vector(MEMORY_SELECTORS-1 downto 0);
        read_en: in std_logic;
        write_en: in std_logic;
        write_data: in std_logic_vector(15 downto 0);
        read_data: out std_logic_vector(15 downto 0)

    );
end MemoryUnit;

architecture MemoryUnitArch of MemoryUnit is
    begin
        MyDataMemory: entity work.MyDataMemory generic map(WORD_LENGTH,MEMORY_SELECTORS) port map(clk=>clk, rst=>rst, w_en=>write_en, r_add =>Readadd , w_add=>Writeadd, write_port=>write_data, read_port=>read_data, read_en=>read_en,en=>en);
end architecture;