Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity InterruptHandler is
    port (
        intrFromLastStage : in std_logic;
        intrFromExternal: in std_logic;
        recieveIntrruptInMemory_PC: in std_logic;
        recieveIntrruptInMemory_Flags: in std_logic;
        sendIntrruptInMemory_PC: out std_logic;
        sendIntrruptInMemory_Flags: out std_logic;
        SPin: in std_logic_vector(15 downto 0);
        SPout: out std_logic_vector(15 downto 0):= std_logic_vector(to_unsigned(1023,16));
        PCin: in std_logic_vector(15 downto 0);
        CCRin: in std_logic_vector(2 downto 0); 
        datatoWrite: out std_logic_vector(15 downto 0);
        memadd: out std_logic_vector(15 downto 0);
        selectPCinterrupt: out std_logic:='0';
        selectSPinterrupt: out std_logic:='0';
        flushFetch: out std_logic:='1';
        pc_enable: out std_logic:='1'
    );
end InterruptHandler;

architecture InterruptHandlerArch of InterruptHandler is
    signal inProcess: std_logic:='0';
begin
    process(intrFromExternal,intrFromLastStage,recieveIntrruptInMemory_PC,recieveIntrruptInMemory_Flags)
    begin
        -- if interrupt signal comes from the writeback stage this
        -- indicates that the pipeline is being empty
        -- then we will send sendIntrruptInMemory_PC to send signal to memory to
        -- store PC in the stack
        -- when the sended signal is recieved through recieveIntrruptInMemory_PC
        -- this indcates that storing pc is done
        -- and we can start storing the flags
        -- this is done by sending sendIntrruptInMemory_Flags to memory
        -- when the sended signal is recieved through recieveIntrruptInMemory_Flags
        -- this indcates that storing flags is done
        -- in parallel we will set the PC with M[0]
        -- once an interrupt is recieved the enable of PC will be set to 0
        -- and a flushing mechanism will be activated that will flush the decode stage
        -- once the travelling interrupt signal is detected in the Execute or Memory or Writeback stage
        -- for the methadology of seeking the latest PC is by using the PC current_instr_interrupt (a special register for interrupt) 
        -- the result of PC selector will be stored in PCin at the moment of recieving             
        -- when the signal of recieveIntrruptInMemory_Flags is activated set the PC with M[0]
        -- and set the enable of PC to 1

        --summarize the steps 
        --1. once an interrupt is recieved the  PC enable will be set to 0
        --2. the interrupt signal is inserted into the pipline to travel to the writeback stage through stages
        --3 a flushing mechanism will be activated that will flush the decode stage (comment)
                 --once the travelling interrupt signal is detected in the Execute or Memory or Writeback stage 
        --4. if interrupt signal comes from the writeback stage this indicates that the pipeline is being empty 
        --5. then we will send sendIntrruptInMemory_PC to send signal to memory to store PC in the stack
        --6. continue mechanism as stated previously
        --7. when the signal of recieveIntrruptInMemory_Flags is activated set the PC with M[1] using take external PC

        if(intrFromExternal='1') then
            pc_enable<='0';
        elsif(intrFromLastStage='1' and inProcess='0') then
            sendIntrruptInMemory_PC<='1';
            selectSPinterrupt <= '1';
            datatoWrite <= PCin; -- data to write in memory
            memadd <= SPin; -- destination
            SPout <= std_logic_vector(unsigned(SPin) - 1);
            inProcess<='1';
        elsif(recieveIntrruptInMemory_PC='1' and inProcess='1') then
            sendIntrruptInMemory_Flags<='1';
            sendIntrruptInMemory_PC<='0';
            selectSPinterrupt <= '1';
            datatoWrite <= (15 downto 3=>'0')&CCRin; -- data to write in memory
            memadd <= SPin; -- destination
            SPout <= std_logic_vector(unsigned(SPin) - 1);
        elsif(recieveIntrruptInMemory_Flags='1' and inProcess='1') then
            sendIntrruptInMemory_Flags<='0';
            selectPCinterrupt <= '1';
            pc_enable<='1';
            inProcess<='0';
        end if;

        --     if(currCounter=0 and intr = '1') then 
        --         --if there are interrupt signal then we need to set the counter to 4 to wait for 4 clock cycles 
        --         --where 2 for DataMemory[Sp]←PC; and 2 for storing flags in stack
        --         --it reads from instruction Memory M[1] and forces pc with it
        --         --it flushes the fetch stage
        --         currCounter := 4; 
        --     elsif(currCounter>0)then
        --             selectPCinterrupt <= '1';
        --             flushFetch <= '1';
        --             if(currCounter=4) then
        --                 selectSPinterrupt <= '1';
        --                 datatoWrite <= PCin; -- data to write in memory
        --                 memadd <= SPin; -- destination
        --                 SPout <= std_logic_vector(unsigned(SPin) - 1);
        --             elsif(currCounter=2) then
        --                 selectSPinterrupt <= '1';
        --                 datatoWrite <= (15 downto 3=>'0')&CCRin; -- data to write in memory
        --                 memadd <= SPin; -- destination
        --                 SPout <= std_logic_vector(unsigned(SPin) - 1);
        --             else
        --                 selectSPinterrupt <= '0';
        --             end if;     
        --             currCounter := currCounter-1;
        --         else
        --             selectPCinterrupt <= '0';
        --             selectSPinterrupt <= '0';
        --             flushFetch <= '0';
        --         end if;
        -- end if;
        -- counter<=currCounter;
    end process;


end architecture;