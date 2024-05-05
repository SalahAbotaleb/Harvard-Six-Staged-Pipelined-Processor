Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity BranchUnit is 
    port(
    RetBranch_excute: in std_logic := '0'; --emin(39)
    RetBranch_mem1: in std_logic := '0'; --emout(39)

    RtiBranch_mem2: in std_logic := '0'; --mwbin(37)

    flush_mem1: in std_logic := '0'; --emout(42) at new stage will take new pc and flsuh then fetch
    flush_mem2: in std_logic := '0'; --MM(42) at new stage will take new pc and flsuh then fetch

    take_external: out std_logic;
    jumptaken: in std_logic := '0';
    RetBranch_mem2: in std_logic := '0'; --MM(39) 
    rst: in std_logic := '0'; --reset

    external_pc: out std_logic_vector(15 downto 0);
    initials: in std_logic_vector(15 downto 0);
    jumpadd: in std_logic_vector(15 downto 0);
    jumpadd_memory: in std_logic_vector(15 downto 0);

    flush: out std_logic;

    CCRPop: in std_logic_vector(2 downto 0);
    CCR_alu: in std_logic_vector(2 downto 0);
    CCR: out std_logic_vector(2 downto 0);

    readflag: out std_logic;
    readflag_mem1: in std_logic := '0'; --emout(41)
    readflag_mem2: in std_logic := '0'; --MM(41)
    PCen: out std_logic;

    MemReaden: out std_logic;
    MEMRead: in std_logic := '0' --em(2)
    );
end BranchUnit;

architecture brancharch of BranchUnit is
signal takeit: std_logic := '0';
signal flush_mem1internal: std_logic := '0';
begin
    takeit <= '1' when jumptaken = '1' or RetBranch_mem2 = '1' or rst = '1' else '0';
    flush <= '1' when takeit = '1' or RetBranch_excute = '1' or RetBranch_mem1 = '1' or RtiBranch_mem2 = '1' or flush_mem1 = '1' else '0';
    take_external <= takeit;

    external_pc <=  initials when rst = '1' else
                    jumpadd when jumptaken = '1' else
                    jumpadd_memory when RetBranch_mem2 = '1' else
                    (others => '0');
                    
    readflag <= RtiBranch_mem2;

    CCR <= CCR_alu when readflag_mem2 = '0' else CCRPop;

    PCen <= '0' when flush_mem1 = '1' else '1';

    MemReaden <= '1' when MEMRead = '1' or readflag_mem1 = '1' else '0';

end architecture;