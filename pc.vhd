Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity Pc is port(clk,rst,en:in std_logic; --addAmt is the amount to be added by the Pc
addAmt:in std_logic_vector(1 downto 0);
external_pc:in std_logic_vector(15 downto 0);
take_external:in std_logic;
external_taken:out std_logic:='0'; --external_taken: 1 if the Pc taked the external_pc, 0 otherwise
ci:out std_logic_vector(15 downto 0); --ci: current instruction being pointed by the Pcexternal_pc:in std_logic_vector(15 downto 0);
ci_intr:out std_logic_vector(15 downto 0) --ci: current instruction without enable
);
end entity;
architecture Pc_arch of Pc is
signal tmp:std_logic_vector(15 downto 0);
begin
process(clk,rst) --may want to update
BEGIN
if(rst='1') then
tmp<=external_pc;
external_taken<='1';
elsif(rising_edge(clk)) then
    
        if(take_external='0') then
            external_taken<='0';
            if(en='1') then
                tmp<=std_logic_vector(unsigned(tmp)+unsigned(addAmt));
            end if;
            ci_intr<=std_logic_vector(unsigned(tmp)+unsigned(addAmt));
        else 
            external_taken<='1';
            if(en='1') then
                tmp<=external_pc;
            end if;    
            ci_intr<=external_pc;
        end if;
end if;
end process;
ci<=tmp;
end Pc_arch;
