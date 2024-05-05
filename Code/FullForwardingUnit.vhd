library IEEE;
use IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.all;

entity FullForwardingUnit is
    Port ( srcadd1 : in  std_logic_vector (2 downto 0);
           srcadd2 : in  std_logic_vector (2 downto 0);

           RegWrite_ALU : in  std_logic;
           RegWrite_M1 : in  std_logic;
           RegWrite_M2 : in  std_logic;
           rd_ALU_M1 : in  std_logic_vector (2 downto 0);
           rd_M1_M2 : in  std_logic_vector (2 downto 0);
           rd_M2_Wb : in  std_logic_vector (2 downto 0);
           
           sel1 : out  std_logic_vector (1 downto 0);
           sel2 : out  std_logic_vector (1 downto 0)
    );
end FullForwardingUnit;

architecture FFU of FullForwardingUnit is
begin
    process(RegWrite_ALU, RegWrite_M1, RegWrite_M2, rd_ALU_M1, rd_M1_M2, rd_M2_Wb, srcadd1, srcadd2)
    begin
        if (RegWrite_ALU = '1' and rd_ALU_M1 = srcadd1) then
            sel1 <= "01";
        elsif (RegWrite_M1 = '1' and rd_M1_M2 = srcadd1) then
            sel1 <= "10";
        elsif (RegWrite_M2 = '1' and rd_M2_Wb = srcadd1) then
            sel1 <= "11";
        else
            sel1 <= "00";
        end if;
        
        if (RegWrite_ALU = '1' and rd_ALU_M1 = srcadd2) then
            sel2 <= "01";
        elsif (RegWrite_M1 = '1' and rd_M1_M2 = srcadd2) then
            sel2 <= "10";
        elsif (RegWrite_M2 = '1' and rd_M2_Wb = srcadd2) then
            sel2 <= "11";
        else
            sel2 <= "00";
        end if;
    end process;


end FFU;