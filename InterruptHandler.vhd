Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity InterruptHandler is
    port (
        clk, reset, intr : in std_logic;
        SPin: in std_logic_vector(15 downto 0);
        SPout: out std_logic_vector(15 downto 0):= std_logic_vector(to_unsigned(1023,16));
        PCin: in std_logic_vector(15 downto 0);
        CCRin: in std_logic_vector(2 downto 0); 
        datatoWrite: out std_logic_vector(15 downto 0);
        memadd: out std_logic_vector(15 downto 0);
        selectPCinterrupt: out std_logic;
        selectSPinterrupt: out std_logic;
        flushFetch: out std_logic
    );
end InterruptHandler;

architecture InterruptHandlerArch of InterruptHandler is
signal counter: integer:=0;
begin
    process(clk, reset)
    variable currCounter: integer:=counter;
    begin
        if(reset = '1') then
            selectPCinterrupt <= '0';
            selectSPinterrupt <= '0';
        elsif(falling_edge(clk)) then
            if(currCounter=0 and intr = '1') then 
                --if there are interrupt signal then we need to set the counter to 4 to wait for 4 clock cycles 
                --where 2 for DataMemory[Sp]←PC; and 2 for storing flags in stack
                --it reads from instruction Memory M[1] and forces pc with it
                --it flushes the fetch stage
                currCounter := 4; 
            elsif(currCounter>0)then
                    selectPCinterrupt <= '1';
                    flushFetch <= '1';
                    if(currCounter=4) then
                        selectSPinterrupt <= '1';
                        datatoWrite <= PCin; -- data to write in memory
                        memadd <= SPin; -- destination
                        SPout <= std_logic_vector(unsigned(SPin) - 1);
                    elsif(currCounter=2) then
                        selectSPinterrupt <= '1';
                        datatoWrite <= (15 downto 3=>'0')&CCRin; -- data to write in memory
                        memadd <= SPin; -- destination
                        SPout <= std_logic_vector(unsigned(SPin) - 1);
                    else
                        selectSPinterrupt <= '0';
                    end if;     
                    currCounter := currCounter-1;
                else
                    selectPCinterrupt <= '0';
                    selectSPinterrupt <= '0';
                    flushFetch <= '0';
                end if;
        end if;
        counter<=currCounter;
    end process;


end architecture;