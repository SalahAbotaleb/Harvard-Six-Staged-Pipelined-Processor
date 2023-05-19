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
signal curr_instr : std_logic_vector(15 downto 0);
signal instr : std_logic_vector(31 downto 0);
signal fdin : std_logic_vector(47 downto 0); --going to add 1 signal for interrupt
signal fdout : std_logic_vector(47 downto 0); --going to add 1 signal for interrupt
signal read_port_rs : std_logic_vector(15 downto 0);
signal read_port_rt : std_logic_vector(15 downto 0);
signal data : std_logic_vector(15 downto 0);
signal ALUop : std_logic_vector(4 downto 0);
signal ALUsrc,RegDst,MEMWrite,MEMRead,MemtoReg,RegWrite : std_logic;
signal dein : std_logic_vector(85 downto 0); --going to add 1 signal for interrupt
signal deout : std_logic_vector(85 downto 0); --going to add 1 signal for interrupt
signal DataRes : std_logic_vector(15 downto 0);
signal Memadd : std_logic_vector(15 downto 0);
signal AluCCRout : std_logic_vector(2 downto 0);
signal AluCCRin : std_logic_vector(2 downto 0) := "000";
signal SPin : std_logic_vector(15 downto 0);
signal SPout : std_logic_vector(15 downto 0);
signal emin : std_logic_vector(40 downto 0); --going to add 1 signal for interrupt
signal emout : std_logic_vector(40 downto 0); --going to add 1 signal for interrupt
signal MM : std_logic_vector(40 downto 0); 
signal initials : std_logic_vector(31 downto 0);
signal mwbin : std_logic_vector(37 downto 0); --going to add 1 signal for interrupt
signal mwbout : std_logic_vector(37 downto 0); --going to add 1 signal for interrupt
signal RetBranch, RtiBranch: std_logic;
signal external_pc:std_logic_vector(15 downto 0);
signal take_external:std_logic;
signal read_intial_loc:std_logic;
signal sel1:std_logic_vector(1 downto 0);
signal sel2:std_logic_vector(1 downto 0);
signal Srcdata1:std_logic_vector(15 downto 0);
signal Srcdata2:std_logic_vector(15 downto 0);
signal RtiSPout:std_logic_vector(15 downto 0);
signal RtiFlush:std_logic;
signal readflags:std_logic;

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
--77 downto 59      --write back address
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
--36 downto 34       --write back address    
--33 downto 18       --DataRes
--17 downto 2        --read_data
--1                  --MemtoReg
--0                  --RegWrite
signal jumpadd:std_logic_vector(15 downto 0);
signal jumptaken:std_logic;
signal read_data:std_logic_vector(15 downto 0);
begin
pc: entity work.pc port map(clk=>clk, rst=>rst, en=>'1', external_pc=>external_pc, take_external=>take_external, addAmt =>addAmt , ci=>curr_instr);
FetchUnit: entity work.FetchUnit port map(clk=>clk, rst=>rst, currInstrPc=>curr_instr, instr=>instr, pcNxtAddAmt=>addAmt);
fdin <= curr_instr & instr;
FD_Buffer: entity work.MynBuffer generic map (48) port map(clk => clk, rst => rst, en=>'1' , d=>fdin , q=>fdout);
RegFile: entity work.MyMemory generic map (16,3) port map(clk => clk, rst => rst, w_en => mwbout(0), r_add1 => fdout(23 downto 21), r_add2 => fdout(20 downto 18), w_add =>mwbout(36 downto 34), write_port => data, read_port_rs => read_port_rs, read_port_rt => read_port_rt);
ControlUnit: entity work.ControlUnit port map(opcode => fdout(31 downto 27), AlUop => AlUop, AlUsrc => AlUsrc, RegDst => RegDst, MEMWrite => MEMWrite, MEMRead => MEMRead, MemtoReg => MemtoReg, RegWrite => RegWrite,RetBranch=>RetBranch, RtiBranch=>RtiBranch);
dein <= RtiBranch & fdout(23 downto 21) & fdout(20 downto 18) & RetBranch & fdout(26 downto 24) & fdout(47 downto 32) & fdout(15 downto 0) & read_port_rs & read_port_rt & AlUop & AlUsrc & RegDst & MEMWrite & MEMRead & MemtoReg & RegWrite;
DE_Buffer: entity work.MynBuffer generic map (86) port map(clk => clk , rst => rst, en => '1', d => dein, q => deout);
CCR_Buffer: entity work.MynBuffer generic map (3) port map(clk => clk , rst => rst, en => '1', d => AluCCRout, q => AluCCRin);
SP_Buffer: entity work.Stackregister generic map (16) port map(clk => clk , rst => rst, en => '1', d => SPout, q => SPin);
ExecutionUnit: entity work.ExecutionUnit port map(ALUop => deout(10 downto 6),src1 => Srcdata1,src2 => Srcdata2,imm => deout(58 downto 43),ALUsrc => deout(5), RegDst => deout(4),inPort => inPort,datares => DataRes,memadd => Memadd, CCRout => AluCCRout,CCRin => AluCCRin, SPin =>SPin, SPout=> SPout, PCin => deout(74 downto 59),jumpadd => jumpadd,jumptaken => jumptaken);
RTIPopFlagUnit: entity work.Popflag port map(SPin => SPin, SPout => RtiSPout, flush => RtiFlush, RtiBranch => mwbout(37), readflag => readflags);
emin <= deout(85) & deout(78 downto 75) & DataRes & Memadd & deout(3 downto 0);
EM_Buffer: entity work.MynBuffer generic map (41) port map(clk => clk , rst => rst, en => '1', d => emin, q => emout);
MM_Buffer: entity work.MynBuffer generic map (41) port map(clk => clk , rst => rst, en => '1', d => emout, q => MM);
MemoryUnit: entity work.MemoryUnit generic map (16,10) port map(clk => clk, en=>'1', Readadd => emout(13 downto 4), Writeadd => emout(13 downto 4),read_en => emout(2), write_en => emout(3), write_data => emout(35 downto 20), read_data => read_data);
mwbin <= MM(40) & MM(38 downto 36) & MM(35 downto 20) & read_data & MM(1 downto 0);
MWB_Buffer: entity work.MynBuffer generic map (38) port map(clk => clk , rst => rst, en => '1', d => mwbin, q => mwbout);
--take_external<='0';
data <= mwbout(33 downto 18) when mwbout(1) = '1' else mwbout(17 downto 2);
initials <= instr when rst='1' else initials;
external_pc <= initials(31 downto 16) when rst='1' else 
                jumpadd when jumptaken = '1' else
                mwbout(17 downto 2); --3ayza tt3dl la tnsa ya moaaz
take_external <= jumptaken or mwbout(37) or rst;
--read_intial_loc<='1' when rst='1' else '0';
FullForwardingUnit: entity work.FullForwardingUnit port map(srcadd1 => deout(84 downto 82), srcadd2 => deout(81 downto 79), RegWrite_ALU => emout(0), RegWrite_M1 => MM(0), RegWrite_M2 => mwbout(0), rd_ALU_M1 => emout(38 downto 36), rd_M1_M2 => MM(38 downto 36), rd_M2_Wb => mwbout(36 downto 34), sel1 => sel1, sel2 => sel2);

Srcdata1 <= deout(42 downto 27) when sel1 = "00" else emout(35 downto 20) when sel1 = "01" else MM(35 downto 20) when sel1 = "10" else data; --  or mbwout(33 downto 18)
Srcdata2 <= deout(26 downto 11) when sel2 = "00" else emout(35 downto 20) when sel2 = "01" else MM(35 downto 20) when sel2 = "10" else data; --  or mbwout(33 downto 18)
end architecture;