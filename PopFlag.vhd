Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity Popflag is 
    port(
    RtiBranch: in std_logic;
    flush: out std_logic;
    readflag: out std_logic
    );
end Popflag;

architecture store of Popflag is
begin
    process(RtiBranch)
    begin
        if(RtiBranch = '1') then
            flush <= '1';
            readflag <= '1';
        else
            flush <= '0';
            readflag <= '0';
        end if;
    end process;
end store;
