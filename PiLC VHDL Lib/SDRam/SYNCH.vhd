library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SYNCH is
	generic (
		NUM_STAGES  : positive := 2;
		RESET_VALUE : bit := '0'
	);
	port (
		PI_RESET1 : in  std_logic; -- Synch. Reset in Clock domain 1
		PI_CLK1   : in  std_logic; -- Synch Clock (domain 1)
		PI_DATA2  : in  std_logic; -- (Asynch) Data in clock domain 2
		PO_DATA1  : out std_logic  -- Synch. Data in Clock domain 1 
	);
end entity SYNCH;

architecture ARCH of SYNCH is
	signal synch     : std_logic_vector(NUM_STAGES-1 downto 0);
	signal reset_val : bit_vector(NUM_STAGES-1 downto 0);
	
	attribute keep : boolean;
	attribute keep of synch : signal is true;
	attribute preserve : boolean;
	attribute preserve of synch : signal is true;
	attribute dont_merge : boolean;
	attribute dont_merge of synch : signal is true;
	attribute dont_retime : boolean;
	attribute dont_retime of synch : signal is true;

begin

	reset_val <= (others => RESET_VALUE);

	PROC_SYNCH : process (PI_CLK1) is
	begin
		if rising_edge (PI_CLK1) then
			if (PI_RESET1) then
				synch <= to_stdLogicVector(reset_val);
			else
				synch <= synch(NUM_STAGES-2 downto 0) & PI_DATA2;
			end if;
		end if;
	end process PROC_SYNCH;
	
	PO_DATA1 <= synch(NUM_STAGES-1);
end architecture ARCH;
