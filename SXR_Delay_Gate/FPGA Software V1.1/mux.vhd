library ieee;
use ieee.std_logic_1164.all;

entity mux is
	port (
	Control	: in STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
	in1	: in std_logic;
	out0	: out std_logic
	);
end mux;



architecture verhalten of mux is

begin
	with Control (7 downto 0) select
		out0 <= '1'  when x"02",
					in1 when x"03",
					'1' when others;
	
end verhalten;
	
	