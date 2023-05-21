Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
entity Processor is
    port (
        clk : in std_logic;
        rst : in std_logic;
        interupt : in std_logic;
        inPort: in std_logic_vector(15 downto 0);
        outPort: out std_logic_vector(15 downto 0)
    );
end Processor;

architecture ProcessorArch of Processor is
signal wr_en : std_logic:='0';
signal addAmt : std_logic_vector(1 downto 0);
signal curr_instr_pc : std_logic_vector(15 downto 0);
signal instr : std_logic_vector(31 downto 0);
signal fdin : std_logic_vector(48 downto 0); --going to add 1 signal for interrupt
signal fdout : std_logic_vector(48 downto 0); --going to add 1 signal for interrupt
signal read_port_rs : std_logic_vector(15 downto 0);
signal read_port_rt : std_logic_vector(15 downto 0);
signal data : std_logic_vector(15 downto 0);
signal ALUop : std_logic_vector(4 downto 0);
signal ALUsrc,RegDst,MEMWrite,MEMRead,MemtoReg,RegWrite : std_logic;
signal dein : std_logic_vector(86 downto 0); --going to add 1 signal for interrupt
signal deout : std_logic_vector(86 downto 0):=(others=>'0'); --going to add 1 signal for interrupt
signal DataRes : std_logic_vector(15 downto 0):="0000000000000000";
signal MemdataIn:  std_logic_vector(15 downto 0):="0000000000000000";
signal Memadd : std_logic_vector(15 downto 0):="0000000000000000";
signal MemaddIn: std_logic_vector(9 downto 0):=(others=>'0');
signal AluCCRout : std_logic_vector(2 downto 0):="000";
signal AluCCRin : std_logic_vector(2 downto 0) := "000";
signal SPin : std_logic_vector(15 downto 0);
signal SPout : std_logic_vector(15 downto 0);
signal emin : std_logic_vector(45 downto 0); --going to add 1 signal for interrupt
signal emout : std_logic_vector(45 downto 0); --going to add 1 signal for interrupt
signal MM : std_logic_vector(45 downto 0); 
signal initials : std_logic_vector(31 downto 0);
signal mwbin : std_logic_vector(38 downto 0); --going to add 1 signal for interrupt
signal mwbout : std_logic_vector(38 downto 0); --going to add 1 signal for interrupt
signal RetBranch, RtiBranch: std_logic;
signal external_pc:std_logic_vector(15 downto 0);
signal take_external:std_logic;
signal external_taken:std_logic;
signal read_intial_loc:std_logic;
signal sel1:std_logic_vector(1 downto 0);
signal sel2:std_logic_vector(1 downto 0);
signal Srcdata1:std_logic_vector(15 downto 0);
signal Srcdata2:std_logic_vector(15 downto 0);
signal RtiSPout:std_logic_vector(15 downto 0);
signal RtiFlush:std_logic := '0';
signal readflags:std_logic;
signal Decode_en:std_logic;
signal Fetch_en:std_logic;

-----------------------------------------------
------------------fdin------------------------
--47 downto 32      --current instruction (PC)
--31 downto 27      --opcode
--26 downto 24      --write address
--23 downto 21      --read address 1
--20 downto 18      --read address 2
-----------------------------------------------
------------------dein-------------------------
--85                -- RtiBranch
--84 downto 82      --read address 1
--81 downto 79      --read address 2
--78		        --RetBranch
--77 downto 75      --write back address
--74 downto 59      --current instruction (PC)
--58 downto 43      --immediate
--42 downto 27      --read data 1   (rs)
--26 downto 11      --read data 2   (rt)
--10 downto 6       --ALUop
--5                 --ALUsrc
--4                 --RegDst
--3                 --MEMWrite
--2                 --MEMRead
--1                 --MemtoReg
--0                 --RegWrite
-----------------------------------------------
----------------emin / MM----------------------
--39		        -- RetBranch
--38 downto 36      --write back address
--35 downto 20      --DataRes
--19 downto 4       --Memadd    (13 downto 4)
--3                 --MEMWrite
--2                 --MEMRead
--1                 --MemtoReg
--0                 --RegWrite
-----------------------------------------------
------------------mwbin------------------------
--45  recieveIntrruptInMemory_Flags
--44  recieveIntrruptInMemory_PC

--37 intetrupt
--36 downto 34       --write back address    
--33 downto 18       --DataRes
--17 downto 2        --read_data
--1                  --MemtoReg
--0                  --RegWrite
signal jumpadd:std_logic_vector(15 downto 0);
signal jumptaken:std_logic;
signal read_data:std_logic_vector(15 downto 0);
signal flush: std_logic;
signal CCRd: std_logic_vector(2 downto 0);
signal memreaden: std_logic;
signal branchPCen: std_logic;
signal interruptpcen: std_logic;
signal Pcen: std_logic;
--------------
signal sendIntrruptInMemory_PC : std_logic;
signal sendIntrruptInMemory_Flags: std_logic;
--signal recieveIntrruptInMemory_PC: std_logic;
--signal recieveIntrruptInMemory_Flags: std_logic;
signal CurrentInstr_Interrupt: std_logic_vector(15 downto 0);
signal SPinterrupt: std_logic_vector(15 downto 0);
signal SPinter: std_logic_vector(15 downto 0);
signal SPalu: std_logic_vector(15 downto 0);

signal Intr_flushDecodeExecuteBuffer: std_logic;
signal branchFlush: std_logic;
signal selectSPinterrupt: std_logic;
signal selectPCinterrupt: std_logic;
signal stall1: std_logic;       --output from LoadUse
signal stall2: std_logic;       --output from LoadUse
signal stall_en: std_logic;     --stall1 nor stall2
signal new_control_signals: std_logic_vector(10 downto 0);   
signal DE_en: std_logic := '1';
signal FD_en: std_logic := '1';
signal stall_SH: std_logic := '0';


signal dataTowrite_intr: std_logic_vector(15 downto 0);
signal memadd_intr: std_logic_vector(15 downto 0);
signal pc_take_external: std_logic;
signal pc_external: std_logic_vector(15 downto 0);
signal MEMWrite_Mux: std_logic;
begin
--branchPCen <= '0' when emout(42) = '1' else '1';

pc: entity work.pc port map(clk=>clk, rst=>rst, en=>Pcen, external_pc=>pc_external, take_external=>pc_take_external,external_taken=>external_taken ,addAmt =>addAmt , ci=>curr_instr,ci_intr=>CurrentInstr_Interrupt);
FetchUnit: entity work.FetchUnit port map(clk=>clk, rst=>rst, currInstrPc=>curr_instr, instr=>instr, pcNxtAddAmt=>addAmt);
fdin <= interupt & curr_instr & instr;
FD_Buffer: entity work.MynBuffer generic map (49) port map(clk => clk, rst => flush, en=>FD_en , d=>fdin , q=>fdout);
RegFile: entity work.MyMemory generic map (16,3) port map(clk => clk, rst => rst, w_en => mwbout(0), r_add1 => fdout(23 downto 21), r_add2 => fdout(20 downto 18), w_add =>mwbout(36 downto 34), write_port => data, read_port_rs => read_port_rs, read_port_rt => read_port_rt);
ControlUnit: entity work.ControlUnit port map(opcode => fdout(31 downto 27), AlUop => AlUop, AlUsrc => AlUsrc, RegDst => RegDst, MEMWrite => MEMWrite, MEMRead => MEMRead, MemtoReg => MemtoReg, RegWrite => RegWrite,RetBranch=>RetBranch, RtiBranch=>RtiBranch);
dein <= fdout(48) & RtiBranch & fdout(23 downto 21) & fdout(20 downto 18) & RetBranch & fdout(26 downto 24) & fdout(47 downto 32) & fdout(15 downto 0) & read_port_rs & read_port_rt & new_control_signals;    --new_control_signals was AlUop & AlUsrc & RegDst & MEMWrite & MEMRead & MemtoReg & RegWrite
DE_Buffer: entity work.MynBuffer generic map (87) port map(clk => clk , rst => flush, en => DE_en, d => dein, q => deout);
CCR_Buffer: entity work.MynBuffer generic map (3) port map(clk => clk , rst => rst, en => '1', d => CCRd, q => AluCCRin);
SP_Buffer: entity work.Stackregister generic map (16) port map(clk => clk , rst => rst, en => '1', d => SPout, q => SPin);
ExecutionUnit: entity work.ExecutionUnit port map(readflag => readflags,ALUop => deout(10 downto 6),src1 => Srcdata1,src2 => Srcdata2,imm => deout(58 downto 43),inPort => inPort,datares => DataRes,memadd => Memadd, CCRout => AluCCRout,CCRin => AluCCRin, SPin =>SPin, SPout=> SPalu, PCin => deout(74 downto 59),jumpadd => jumpadd,jumptaken => jumptaken);
--RTIPopFlagUnit: entity work.Popflag port map(flush => RtiFlush, RtiBranch => mwbin(37), readflag => readflags);
emin <=sendIntrruptInMemory_Flags & sendIntrruptInMemory_PC & deout(86) & readflags & readflags & deout(85) & deout(78 downto 75) & DataRes & Memadd & deout(3 downto 0);
EM_Buffer: entity work.MynBuffer generic map (46) port map(clk => clk , rst => rst, en => '1', d => emin, q => emout);
MM_Buffer: entity work.MynBuffer generic map (46) port map(clk => clk , rst => rst, en => '1', d => emout, q => MM);
MemoryUnit: entity work.MemoryUnit generic map (16,10) port map(clk => clk, en=>'1', Readadd => emout(13 downto 4), Writeadd => MemaddIn,read_en => memreaden, write_en => MEMWrite_Mux, write_data => MemdataIn, read_data => read_data);
mwbin <= MM(43) & MM(40) & MM(38 downto 36) & MM(35 downto 20) & read_data & MM(1 downto 0);
MWB_Buffer: entity work.MynBuffer generic map (39) port map(clk => clk , rst => rst, en => '1', d => mwbin, q => mwbout);
--take_external<='0';
interrupthandle: entity work.InterruptHandler port map(intrFromExternal => interupt,
                intrFromLastStage => mwbout(38),--may be edited
                sendIntrruptInMemory_PC =>sendIntrruptInMemory_PC,
                sendIntrruptInMemory_Flags=>sendIntrruptInMemory_Flags,
                recieveIntrruptInMemory_Flags=>MM(45),
                recieveIntrruptInMemory_PC=>MM(44),
                PCin=>CurrentInstr_Interrupt,
                SPin=>SPin,
                SPout=>SPinter,
                CCRin=>CCRd,
                pc_enable => interruptpcen,
                memadd_intr => memadd_intr,
                dataTowrite_intr => dataTowrite_intr,
                flushDecodeExecuteBuffer=>Intr_flushDecodeExecuteBuffer,
                selectSPinterrupt=>selectSPinterrupt,
                selectPCinterrupt=>selectPCinterrupt,
                intrFromExecution=>emout(43),
                external_taken=>external_taken
                );
--I think we want a mux on the pc to select between the pc from the interrupt handler and the pc from the pc unit
Pcen <= '0' when branchPCen = '0' or interruptpcen = '0' or stall_en = '1' else '1';
pc_take_external<= take_external or selectPCinterrupt;
pc_external <= initials(15 downto 0) when  selectPCinterrupt = '1' else external_pc;
--I think we want a mux on Stack Pointer to select between the SP from the interrupt handler and the SP from the SP unit(Execution)
SPout <= SPinter when selectSPinterrupt = '1' else SPalu;
--I think we want a mux on data to memory to select between the data from the interrupt handler and the data from the Execute-Memory unit
MemaddIn <= memadd_intr(9 downto 0) when sendIntrruptInMemory_PC = '1' or sendIntrruptInMemory_Flags = '1' else emout(13 downto 4);
MemdataIn<= dataTowrite_intr when sendIntrruptInMemory_PC = '1' or sendIntrruptInMemory_Flags = '1' else emout(35 downto 20);
MEMWrite_Mux<= '1' when sendIntrruptInMemory_PC = '1' or sendIntrruptInMemory_Flags = '1' else emout(3);
--flushdecode excute when interrupt is taken
flush <= '1' when Intr_flushDecodeExecuteBuffer = '1' else branchFlush;

Branching: entity work.BranchUnit port map(
    RetBranch_excute => emin(39),
    RetBranch_mem1 => emout(39),
    RtiBranch_mem2 => mwbin(37),
    flush_mem1 => emout(42),
    flush_mem2 => MM(42),
    take_external => take_external,
    jumptaken => jumptaken,
    RetBranch_mem2 => MM(39),
    rst => rst,
    external_pc => external_pc,
    initials => initials(31 downto 16),
    jumpadd => jumpadd,
    jumpadd_memory => read_data,
    flush => branchFlush,
    CCRPop => read_data(2 downto 0),
    CCR_alu => AluCCRout,
    CCR => CCRd,
    readflag => readflags,
    readflag_mem1 => emout(41),
    readflag_mem2 => MM(41),
    Pcen => branchPCen,
    MemReaden => memreaden,
    MEMRead => emout(2)
);

--memreaden <= emout(2) or emout(41);
--flush (when a pc is changed) or ret/rti in (excute) or in (mem1) or when waiting for flag 
--flush <= take_external or emin(39) or emout(39) or mwbin(37) or emout(42);
data <= mwbout(33 downto 18) when mwbout(1) = '1' else mwbout(17 downto 2);
initials <= instr when rst='1' else initials;
--external_pc <=  initials(31 downto 16) when rst='1' else 
--                jumpadd when jumptaken = '1' else
--                mwbin(17 downto 2); --data from memory after reading
--take_external <= jumptaken or MM(39) or rst; -- when jump condition or rti/ret in mem2 stage or reset
--CCrd <= mwbin(4 downto 2) when MM(41) = '1' else ALUCCRout; --change flag to read data when rti in mem2 stage 
--read_intial_loc<='1' when rst='1' else '0';
FullForwardingUnit: entity work.FullForwardingUnit port map(srcadd1 => deout(84 downto 82), srcadd2 => deout(81 downto 79), RegWrite_ALU => emout(0), RegWrite_M1 => MM(0), RegWrite_M2 => mwbout(0), rd_ALU_M1 => emout(38 downto 36), rd_M1_M2 => MM(38 downto 36), rd_M2_Wb => mwbout(36 downto 34), sel1 => sel1, sel2 => sel2);

Srcdata1 <= deout(42 downto 27) when sel1 = "00" else emout(35 downto 20) when sel1 = "01" else MM(35 downto 20) when sel1 = "10" else data;
Srcdata2 <= deout(26 downto 11) when sel2 = "00" else emout(35 downto 20) when sel2 = "01" else MM(35 downto 20) when sel2 = "10" else data;

LoadUse: entity work.LoadUse port map(Rsrc1 => fdout(23 downto 21), Rsrc2 => fdout(20 downto 18), RdAlu => deout(77 downto 75), MemReadAlu => deout(2), Register_WriteAlu => deout(0), RdMem1 => emout(38 downto 36), MemReadMem1 => emout(2), Register_WriteMem1 => emout(0), stall1 => stall1, stall2 => stall2);
stall_en <= stall1 or stall2;

new_control_signals <= "00000000000" when stall_en = '1' else AlUop & AlUsrc & RegDst & MEMWrite & MEMRead & MemtoReg & RegWrite;
FD_en <= '0' when stall_en = '1' else '1';

--StructuralHazardDetection: entity work.StructuralHazardDetection port map(MemReadAlu => deout(2), MemWriteAlu => deout(3), MemReadMem1 => emout(2), MemWriteMem1 => emout(3), stall => stall_SH);
--DE_en <= '0' when stall_SH = '0' else '1';

end architecture;