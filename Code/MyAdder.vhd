LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MyAdder IS
	PORT (a,b,cin : IN  std_logic;
		  s, cout : OUT std_logic );
END MyAdder;

ARCHITECTURE a_my_adder OF MyAdder IS
	BEGIN
		
				s <= a XOR b XOR cin;
				cout <= (a AND b) OR (cin AND (a XOR b));
		
END a_my_adder;