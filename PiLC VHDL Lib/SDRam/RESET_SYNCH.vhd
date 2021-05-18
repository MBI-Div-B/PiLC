library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RESET_SYNCH is 
	generic (
		NUM_STAGES : positive := 4
	);
	port (
		PI_ARESET : in std_logic; -- Asynch. Reset signal
		PI_CLK    : in std_logic; -- Synch. Clock
		PO_RESET  : out std_logic -- Synch. Reset signal in PI_CLK clock domain
	);
end entity RESET_SYNCH;

architecture ARCH of RESET_SYNCH is
	signal synch : std_logic_vector(NUM_STAGES-1 downto 0);
	
	attribute keep : boolean;
	attribute keep of synch : signal is true;
	attribute preserve : boolean;
	attribute preserve of synch : signal is true;
	attribute dont_merge : boolean;
	attribute dont_merge of synch : signal is true;
	attribute dont_retime : boolean;
	attribute dont_retime of synch : signal is true;
	
begin
	PROC_SYNCH : process (PI_CLK, PI_ARESET) is
	begin
		if (PI_ARESET) then
			synch <= (others => '1');
		elsif rising_edge(PI_CLK) then
			synch <= synch(NUM_STAGES-2 downto 0) & '0';
		end if;
	end process PROC_SYNCH;
	
	PO_RESET <= synch(NUM_STAGES-1);
end architecture ARCH;
	
