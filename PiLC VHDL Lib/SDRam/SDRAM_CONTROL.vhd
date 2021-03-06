-- SDRAM Controller for the IS42S16160G 32MB SDRAM
-- Compile with VHDL-2008!
-- Input SDRAM Clock must be 100MHz!
-- Uses Write/Read Burst of 4!
-- Write Command: enter write address in PI_ADDR_IN and assert PI_CMD_RDY & PI_WR, in addition enter data in PI_DATA_IN and assert PI_DATA_RDY four times.
--                the order of the sequence is not imported, but for best efficiency enter the first data along with the address, and then new data every
--                consecutive clock cycle.
--                Write commands can be written in consecutive cycles as long as PO_DRAM_WR_BUSY is de-asserted.
-- Read Command: enter read assress in PI_ADDR_IN and assert PI_CMD_RDY (de-assert PI_WR). Once data is retrieved from the SDRAM PO_DATA_RDY will be asseted.
--               PO_ADDR_OUT will indicate the read address, and PO_ADDR_DATA will be the first read data from the SDRAM. To get the next data the user 
--               should assert PI_ACK. Next data will be valid once PO_DATA_RDY is asserted again.
--               READ commands can be written in consecutive cycles as long as PO_DRAM_RD_BUSY is de-asserted.
-- The Controller gives precedence to Write commands over Read commands. However, after NUM_WR_B4_RD Write cycles it will execute one Read cycle (if a read
-- command is pending).
-- If ALLOW_DATA_CORRUPTION parameter is false, operation of the current command will be stalled if the Write data FIFO is empty during a Write Burst, or if the
-- Read data Fifo is Full during a Read Burst. Operation will resume once another data word is given by the user (for Write Bursts), or another Data word is read
-- by the user (for a Read Burst). If ALLOW_DATA_CORRUPTION is true, the operation of the SDRAM controller will never stall. In case FIFO conditions are not
-- optimal Written or Read data will be corrupt.
--
--
-- Best Write procedure:    
--									1		2		3		4		5			
--                          __    __    __    __    __    __    __    __    __
-- PI_USER_CLK           __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__
--                          _____                   _____ 
-- PI_WR                 __|     |_________________|     |_________________   
--                          _____                   _____     
-- PI_CMD_RDY            __|     |_________________|     |_________________
--                          ______________________________________________
-- PI_DATA_RDY           __|     |     |     |     |     |     |     |    |
--                          ____  ____  ____  ____  ____  ____  ____  ____
-- PI_ADDR_IN            __< A1 >< X  >< X  >< X  >< A2 >< X  >< X  >< X  >
--                          ____  ____  ____  ____  ____  ____  ____  ____
-- PI_DATA_IN            __< D1 >< D2 >< D3 >< D4 >< D5 >< D6 >< D7 >< D8 >
--
--
-- Best Read procedure:     __    __         __    _       __    _       __    _       __    _       __    _       __    _       __    _       __    _     
-- PI_USER_CLK           __|  |__|  |__...__|  |__|  ...__|  |__|  ...__|  |__|  ...__|  |__|  ...__|  |__|  ...__|  |__|  ...__|  |__|  ...__|  |__|  ...
--                                        
-- PI_WR                 ______________... 
--                          _____ ____     
-- PI_CMD_RDY            __|     |    |...
--                          ____  ____ 
-- PI_ADDR_IN            __< A1 >< A2 >...
--                                           _____         _____         _____         _____         _____         _____         _____         _____
-- PO_DATA_RDY                         ...__|     |__...__|     |__...__|     |__...__|     |__...__|     |__...__|     |__...__|     |__...__|     |__...
--                                                                                                                                          
-- PO_ADDR_OUT                         ...__< A1  >__...__< A1  >__...__< A1  >__...__< A1  >__...__< A2  >__...__< A2  >__...__< A2  >__...__< A2  >__...
--                                                                                                                                          
-- PO_DATA_OUT                         ...__< D1  >__...__< D2  >__...__< D3  >__...__< D4  >__...__< D5  >__...__< D6  >__...__< D7  >__...__< D8  >__...
--                                           _____         _____         _____         _____         _____         _____         _____         _____
-- PI_ACK                              ...__|     |__...__|     |__...__|     |__...__|     |__...__|     |__...__|     |__...__|     |__...__|     |__...

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_MISC.all;

use work.PKG_SDRAM.all;

entity SDRAM_CONTROL is
	generic (
		ADDR_WIDTH     : positive := 13;         -- SDRAM Address Bus Width
		DATA_WIDTH     : positive := 16;         -- SDRAM Data Bus Width
		NUM_OF_BANKS   : positive := 4;          -- Number of SDRAM Banks
		NUM_OF_ROWS    : positive := 8192;       -- Number of Rows in each Bank
		NUM_OF_COLS    : positive := 512;        -- Number of Columns in each Row
		NUM_WR_B4_RD   : positive := 4;          -- Number of Write Command cycles before doing a Read Command
		REFRESH_PERIOD : positive := 64;         -- SDRAM Refresh period in ms
		INIT_PERIOD    : positive := 100;        -- SDRAM Init period in us
		ALLOW_DATA_CORRUPTION : boolean := false -- Allow Data Corruption in case of internal FIFOs full/empty (prevent stall)
	);
   port (
		-- DRAM interface
		PO_DRAM_ADDR  : out   std_logic_vector(12 downto 0);           -- SDRAM Address Bus Interface
		PO_DRAM_BA    : out   std_logic_vector(1 downto 0);--(f_log2(NUM_OF_BANKS)-1 downto 0); -- SDRAM Bank Interface
		PO_DRAM_DQM   : out   std_logic_vector(1 downto 0);         -- SDRAM Data Mask interface
		PO_DRAM_CAS_N : out   std_logic;                                         -- SDRAM CAS_N line
		PO_DRAM_RAS_N : out   std_logic;                                         -- SDRAM RAS_N line
		PO_DRAM_CKE   : out   std_logic;                                         -- SDRAM CKE line
		PO_DRAM_CLK   : out   std_logic;                                         -- SDRAM Input Clock (100 MHz Output from FPGA)
		PO_DRAM_WE_N  : out   std_logic;                                         -- SDRAM WE_N line
		PO_DRAM_CS_N  : out   std_logic;                                         -- SDRAM CS_N line
		PIO_DRAM_DQ   : inout std_logic_vector(15 downto 0);           -- SDRAM Data Bus Interface
		
		-- User Interface
		PI_DRAM_CLK     : in  std_logic; -- Clock for SDRAM Controller (Must be 100 MHz!)
		PI_USER_CLK     : in  std_logic; -- User System Clock (arbitrary)
		PI_RESET        : in  std_logic; -- Reset input (should be at least connected to the PLL lock signal)
		PI_ACK          : in  std_logic; -- User Acknoledge of Data Read
		PI_CMD_RDY      : in  std_logic; -- Command to SDRAM Controller is Ready and Valid
		PI_WR           : in  std_logic; -- Current Command is Write on logical '1' and Read on logical '0'
		PI_ADDR_IN      : in  std_logic_vector(21 downto 0); --(f_log2(NUM_OF_BANKS*NUM_OF_ROWS*NUM_OF_COLS)-3 downto 0); -- Address of next 4 Data Words to Read of Write
		PI_DATA_IN      : in  std_logic_vector(15 downto 0);                                   -- Data Input to SDRAM Controller (for Write Commands)
		PI_DATA_RDY     : in  std_logic;                                                                 -- Data Input is Ready and Valid (for Write Commands)
		PO_ADDR_OUT     : out std_logic_vector(21 downto 0); --(f_log2(NUM_OF_BANKS*NUM_OF_ROWS*NUM_OF_COLS)-3 downto 0); -- Address Output from SDRAM Controller (from read Commands)
		PO_DATA_OUT     : out std_logic_vector(15 downto 0);                                   -- Data Output from SDRAM Controller (from read Commands)   
		PO_DATA_RDY     : out std_logic;                                                                 -- Address + Data from SDRAM Controller are Ready and Valid
		PO_DRAM_WR_BUSY : out std_logic;	-- SDRAM Controller is unable to receive additional Write Commands!	
		PO_DRAM_RD_BUSY : out std_logic	-- SDRAM Controller is unable to receive additional Read Commands!	
   );
end entity SDRAM_CONTROL;
	
architecture arch of SDRAM_CONTROL is
	
	constant NUM_ROWS_BITS  : positive := f_log2(NUM_OF_ROWS);
	constant NUM_BANKS_BITS : positive := f_log2(NUM_OF_BANKS);
	constant NUM_COLS_BITS  : positive := f_log2(NUM_OF_COLS);
	constant USR_ADDR_WIDTH : positive := NUM_BANKS_BITS + NUM_ROWS_BITS + NUM_COLS_BITS - 2;
	
	subtype t_data_vec        is std_logic_vector(DATA_WIDTH-1 downto 0); 
	subtype t_addr_vec        is std_logic_vector(ADDR_WIDTH-1 downto 0);
	subtype t_usr_addr_vec    is std_logic_vector(USR_ADDR_WIDTH-1 downto 0);
	subtype t_usr_data_vec    is std_logic_vector(USR_ADDR_WIDTH+DATA_WIDTH-1 downto 0);
	subtype t_banks_vec       is std_logic_vector(NUM_BANKS_BITS-1 downto 0);
	subtype t_rows_vec        is std_logic_vector(NUM_ROWS_BITS-1 downto 0);
	subtype t_cols_vec        is std_logic_vector(NUM_COLS_BITS-3 downto 0);
	subtype t_sdram_cmd       is std_logic_vector(3 downto 0);
	subtype t_usr_rows_range  is natural range USR_ADDR_WIDTH-1 downto USR_ADDR_WIDTH-NUM_ROWS_BITS;
	subtype t_usr_banks_range is natural range USR_ADDR_WIDTH-NUM_ROWS_BITS-1 downto NUM_COLS_BITS-2;
	subtype t_usr_cols_range  is natural range NUM_COLS_BITS-3 downto 0;
	
	type t_rows_array is array (NUM_OF_BANKS-1 downto 0) of t_rows_vec;

	constant RD_FIFO_FULL_THRESHOLD : positive := 59;
	
	-- reset synchronizer
	component RESET_SYNCH is
	port (
		PI_ARESET : in  std_logic; -- Asynch. Reset signal
		PI_CLK    : in  std_logic; -- Synch. Clock
		PO_RESET  : out std_logic  -- Synch. Reset signal in PI_CLK clock domain
	);
	end component;
	
	signal reset_dram_clk : std_logic;
	signal reset_user_clk : std_logic;
	
	-- simple synchronizer (default reset value '0')
	component SYNCH is
	port (
		PI_RESET1 : in  std_logic; -- Synch. Reset in Clock domain 1
		PI_CLK1   : in  std_logic; -- Synch Clock (domain 1)
		PI_DATA2  : in  std_logic; -- (Asynch) Data in clock domain 
		PO_DATA1  : out std_logic  -- Synch. Data in Clock domain 1 
	);
	end component;
	
	signal init_done      : std_logic;
	signal next_init_done : std_logic;
	signal init_done_user : std_logic;

	-- ODDR for output clock to SDRAM
	component ODDR is
	port (
		datain_h		: in  std_logic_vector(0 downto 0);
		datain_l		: in  std_logic_vector (0 downto 0);
		outclock		: in  std_logic ;
		outclocken  : in  std_logic ;
		dataout		: out std_logic_vector (0 downto 0)
	);
	end component;

	signal po_dram_clk_pad : std_logic_vector(0 downto 0);
	
	-- IO Buffer for the Bi-Directional Data Bus
	component IOBUF is
	port (
		datain		: in    t_data_vec;
		oe		      : in    t_data_vec;
		dataio		: inout t_data_vec;
		dataout		: out   t_data_vec
	);
	end component;

	signal dram_data_oe   : t_data_vec;
	signal dram_data_in   : t_data_vec;
	signal dram_data_in_q : t_data_vec;

	attribute useioff : boolean;
	attribute useioff of dram_data_in_q : signal is true;

	-- FIFO for the read and and write commands Address
	component COMMAND_FIFO is
	port (
		aclr		: in  std_logic;
		data		: in  t_usr_addr_vec;
		rdclk		: in  std_logic ;
		rdreq		: in  std_logic ;
		wrclk		: in  std_logic ;
		wrreq		: in  std_logic ;
		q		   : out t_usr_addr_vec;
		rdempty  : out std_logic ;
		wrfull	: out std_logic 
	);
	end component;

	signal read_user_wr_cmd  : std_logic;
	signal user_wr_cmd_addr  : t_usr_addr_vec;
	signal user_wr_cmd_empty : std_logic;
	signal user_wr_cmd_full  : std_logic;
	signal read_user_rd_cmd  : std_logic;         
	signal user_rd_cmd_addr  : t_usr_addr_vec;
	signal user_rd_cmd_empty : std_logic;
	signal user_rd_cmd_full  : std_logic;

	-- FIFO for the Read commands Data
	component READ_DATA_FIFO is
	port (
		aclr	  : in  std_logic;
		data	  : in  t_usr_data_vec;
		rdclk	  : in  std_logic ;
		rdreq	  : in  std_logic ;
		wrclk	  : in  std_logic ;
		wrreq	  : in  std_logic ;
		q		  : out t_usr_data_vec;
		rdempty : out std_logic ;
		wrusedw : out std_logic_vector(6 downto 0) 
	);
	end component;

	signal user_cmd_addr_out      : t_usr_addr_vec;
	signal rd_data_out_fif0_q     : t_usr_data_vec;
	signal rd_data_out_fifo_empty : std_logic;
	signal rd_data_out_fifo_usedw : std_logic_vector(6 downto 0);
	signal rd_data_out_fifo_full  : std_logic;
	
	-- FIFO for the Write commands Data
	component WRITE_DATA_FIFO is
	port (
		aclr	  : in  std_logic;
		data	  : in  t_data_vec;
		rdclk	  : in  std_logic ;
		rdreq	  : in  std_logic ;
		wrclk	  : in  std_logic ;
		wrreq	  : in  std_logic ;
		q		  : out t_data_vec;
		rdempty : out std_logic ;
		wrfull  : out std_logic 
	);
	end component;

	signal user_wr_data_out   : t_data_vec;
	signal user_wr_data_out_q : t_data_vec;
	signal user_wr_data_empty : std_logic;
	signal user_wr_data_full  : std_logic;
	
	-- From page 9 of IS42S16160G datasheet
   -- Name (Function)        CS# RAS# CAS# WE#  BA   A10     Ax  
   -- DESELECTED (DESL)       H   X    X    X   X     X      X  
   -- NO OPERATION (NOP)      L   H    H    H   X     X      X
   -- ACTIVATE (ACT)          L   L    H    H   Bank  row    row
   -- READ                    L   H    L    H   Bank  L      col 
   -- WRITE                   L   H    L    L   Bank  L      col 
   -- BURST STOP (BST)        L   H    H    L   X     X      X
   -- PRECHARGE (PRE)         L   L    H    L   X     L      X    
   -- AUTO REFRESH (REF)      L   L    L    H   X     X      X
   -- MODE REGISTER SET (MRS) L   L    L    L   L     L      V  
   
   -- Here are the commands mapped to constants   
   constant SDRAM_CMD_DESL  : t_sdram_cmd := "1000";
   constant SDRAM_CMD_NOP   : t_sdram_cmd := "0111";
   constant SDRAM_CMD_ACT   : t_sdram_cmd := "0011";
   constant SDRAM_CMD_READ  : t_sdram_cmd := "0101";
   constant SDRAM_CMD_WRITE : t_sdram_cmd := "0100";
   constant SDRAM_CMD_BST   : t_sdram_cmd := "0110";
   constant SDRAM_CMD_PRE   : t_sdram_cmd := "0010";
   constant SDRAM_CMD_REF   : t_sdram_cmd := "0001";
   constant SDRAM_CMD_MRS   : t_sdram_cmd := "0000";
	
	constant BURST_LENGTH : positive := 4;

   constant MODE_REG     : std_logic_vector(12 downto 0) := 
    -- Reserved, wr bust, OpMode, CAS Latency (2), Burst Type, Burst Length (2)
         "000" &   "0"  &  "00"  &    "010"      &     "0"    &   "010";
			
	constant NS_IN_MS           : positive := 1000000;
	constant NS_IN_US           : positive := 1000;
	constant CLOCK_PERIOD_NS    : positive := 10;
	constant REFRESH_CLOCKS     : positive := REFRESH_PERIOD*NS_IN_MS/CLOCK_PERIOD_NS/NUM_OF_ROWS;
	constant INIT_CLOCKS        : positive := INIT_PERIOD*NS_IN_US/CLOCK_PERIOD_NS;
	constant NUM_CNT_BITS       : positive := MAX(f_log2(2*REFRESH_CLOCKS),f_log2(INIT_CLOCKS));
 
	-- Shared counter for the r efresh cycles and the init process
	signal cnt_refresh          : std_logic_vector(NUM_CNT_BITS downto 0);
	signal cnt_refresh_clr      : std_logic;
	signal refresh_done         : std_logic;
	signal should_refresh       : std_logic; -- time to refresh passed
	signal must_refresh         : std_logic; -- double time to refresh passed
	signal refresh_pending      : std_logic; -- refresh cycle is pending
	signal init_count_done      : std_logic;
	signal init_first_ref_done  : std_logic; -- first of two refresh cycles in init process is done

	signal command_record       : std_logic_vector(NUM_WR_B4_RD-1 downto 0); -- shift register keeps a record of the last commands
	signal all_last_cmds_are_wr : std_logic; -- all of last commands are Write, next command should be Read (if available)
	signal able_to_read         : std_logic; 
	signal able_to_write        : std_logic;
	signal start_rd_command     : std_logic;
	signal start_wr_command     : std_logic;
	signal next_command_is_wr   : std_logic;
	signal next_command_is_rd   : std_logic;
	signal command_pending      : std_logic; -- command is pending
 
	signal rd_burst_shift       : std_logic_vector(BURST_LENGTH-1 downto 0); -- shift register used for the indication that the controller is currently in a Read Burst
	signal wr_burst_shift       : std_logic_vector(BURST_LENGTH-1 downto 0); -- shift register used for the indication that the controller is currently in a Write Burst
	signal start_rd_burst       : std_logic;
	signal start_rd_burst_q1    : std_logic; -- sample 1st stage
	signal start_rd_burst_q2    : std_logic; -- sample 2nd stage
	signal start_wr_burst       : std_logic;
	signal curr_command         : std_logic; -- is current command Write or Read
	signal in_wr_burst          : std_logic; -- controller is currently in a Write Burst
	signal in_wr_burst_q        : std_logic; -- sample 1st stage
	signal in_rd_burst          : std_logic; -- controller is currently in a Read Burst
	signal in_rd_burst_q1       : std_logic; -- sample 1st stage
	signal in_rd_burst_q2       : std_logic; -- sample 2nd stage
  
	signal suspend_needed       : std_logic; -- operation is needed to suspend due to FIFOs empty/full
	signal suspend_needed_q1    : std_logic;
	signal suspend_needed_q2    : std_logic;
	signal suspend_needed_q3    : std_logic;
 
	signal curr_active_rows     : t_rows_array; -- record of currently active rows for each bank
	signal next_active_rows     : t_rows_array;
	signal curr_active_banks    : std_logic_vector(NUM_OF_BANKS-1 downto 0); -- record of currently active banks
	signal next_active_banks    : std_logic_vector(NUM_OF_BANKS-1 downto 0);
	signal next_user_cmd_addr   : t_usr_addr_vec;
	signal curr_user_cmd_addr   : t_usr_addr_vec; -- address of the currently processed command
	signal pending_cmd_address  : t_usr_addr_vec; -- address of the next pending command (from commands FIFO output)
	signal pending_bank         : t_banks_vec;    -- bank of the next pending command
	signal pending_bank_q       : t_banks_vec;    -- sample 1st stage
	signal next_bank            : t_banks_vec;    -- bank of the currently processed command
	signal pending_row          : t_rows_vec;     -- row of the next pending command
	signal active_row           : t_rows_vec;     -- currently active row in the pending bank
	signal next_row             : t_rows_vec;     -- row of the currently processed command
	signal next_col             : t_cols_vec;     -- column of the currently processed command
	signal pend_bank_is_aktiv   : std_logic;      -- is pending bank already active (is active command needed) 
	signal row_change           : std_logic;      -- need to chande to active row (precharge command is needed)
	 
	signal precharge_needed     : std_logic;       -- PRECHARGE command is needed 
	signal activate_needed      : std_logic;       -- ACTIVE command is needed
	signal all_banks_inactive   : std_logic;       -- all the banks are currently not active                                

	-- Control FSM states
	type t_sdram_control_state is (
		INIT_WAIT, INIT_MRS, INIT_FINISHED,                                         -- INITialization process
		AUTO_REF, AUTO_REF1, AUTO_REF2, AUTO_REF3, AUTO_REF4, AUTO_REF5, AUTO_REF6, -- AUTO REFRESH command
		IDLE,                  -- IDLE state
		PRE, PRE1,             -- PRECHARGE command
		ACT, ACT1,             -- ACTIVATE command 
		WR, WR1, WR2, WR3,     -- WRITE command
		RD, RD1, RD2, RD3,     -- READ command
		RD2WR1, RD2WR2, RD2WR3 -- READ to WRITE delay (to avoid bus contention)
	);
	
	signal control_curr_state : t_sdram_control_state;
	signal control_next_state : t_sdram_control_state;

	-- outputs to SDRAM
	signal curr_addr       : t_addr_vec;
	signal curr_ba         : t_banks_vec;
	signal curr_dqm        : std_logic_vector(DATA_WIDTH/8-1 downto 0);
	signal curr_cke        : std_logic;
	signal curr_sdram_cmd  : t_sdram_cmd;	
	signal next_addr       : t_addr_vec;
	signal next_ba         : t_banks_vec;
	signal next_dqm        : std_logic_vector(DATA_WIDTH/8-1 downto 0);
	signal next_cke        : std_logic;
	signal next_sdram_cmd  : t_sdram_cmd;
		
	signal alternate_bank_activate  : std_logic;
	signal write_alternate_bank_act : std_logic;
	signal read_alternate_bank_act  : std_logic;
	signal read_again               : std_logic;
	signal goto_precharge           : std_logic;	                                

begin

	-- ODDR for output clock to SDRAM
	ODDR_CLK : ODDR
	port map (
		datain_h   => (0 => '1'),
		datain_l   => (0 => '0'),
		outclock   => PI_DRAM_CLK,
		outclocken => not reset_dram_clk,
		dataout    => po_dram_clk_pad
	);
	
	PO_DRAM_CLK <= po_dram_clk_pad(0);
	
	-- synchronize the reset to dram clock domain
	RESET_SYNCH_DRAM : RESET_SYNCH
	port map (
		PI_ARESET => PI_RESET,
		PI_CLK    => PI_DRAM_CLK,
		PO_RESET  => reset_dram_clk
	);
	
	-- synchronize the dram clock domain reset to the user system clock domain
	RESET_SYNCH_USER : RESET_SYNCH
	port map (
		PI_ARESET => reset_dram_clk,
		PI_CLK    => PI_USER_CLK,
		PO_RESET  => reset_user_clk
	);
	
	-- IO Buffer for the Bi-Directional Data Bus
	IOBUF_DATA : IOBUF
	port map (
		datain  => user_wr_data_out_q,
		oe      => dram_data_oe,
		dataio  => PIO_DRAM_DQ,
		dataout => dram_data_in
	);
	
	dram_data_oe <= (others => in_wr_burst_q);
	
	-- synchronize init process indication to the user system clock domain
	SYNCH_INIT_DONE : SYNCH
	port map (
		PI_RESET1 => reset_user_clk,
		PI_CLK1   => PI_USER_CLK,
		PI_DATA2  => init_done,
		PO_DATA1  => init_done_user
	);
	
	-- FIFO for the write commands Address
	FIFO_CMD_WRITE : COMMAND_FIFO
	port map (
		aclr    => reset_dram_clk,
		data    => PI_ADDR_IN,
		rdclk   => PI_DRAM_CLK,
		rdreq   => read_user_wr_cmd and (not suspend_needed),
		wrclk   => PI_USER_CLK,
		wrreq   => PI_CMD_RDY and PI_WR,
		q       => user_wr_cmd_addr,
		rdempty => user_wr_cmd_empty,
		wrfull  => user_wr_cmd_full
	);
	
	-- FIFO for the Write commands Data
	FIFO_WR_DATA_IN : WRITE_DATA_FIFO
	port map (
		aclr    => reset_dram_clk,
		data    => PI_DATA_IN,
		rdclk   => PI_DRAM_CLK,
		rdreq   => in_wr_burst and (not suspend_needed),
		wrclk   => PI_USER_CLK,
		wrreq   => PI_DATA_RDY,
		q       => user_wr_data_out,
		rdempty => user_wr_data_empty,
		wrfull  => user_wr_data_full
	);
	
	PO_DRAM_WR_BUSY <= user_wr_data_full or user_wr_cmd_full or reset_user_clk or (not init_done_user);

	-- FIFO for the read commands Address
	FIFO_CMD_READ : COMMAND_FIFO
	port map (
		aclr    => reset_dram_clk,
		data    => PI_ADDR_IN,
		rdclk   => PI_DRAM_CLK,
		rdreq   => read_user_rd_cmd and (not suspend_needed),
		wrclk   => PI_USER_CLK,
		wrreq   => PI_CMD_RDY and (not PI_WR),
		q       => user_rd_cmd_addr,
		rdempty => user_rd_cmd_empty,
		wrfull  => user_rd_cmd_full
	);
	
	PO_DRAM_RD_BUSY <= user_rd_cmd_full or reset_user_clk or (not init_done_user);
	
	-- FIFO for the Read commands Data
	FIFO_RD_DATA_OUT : READ_DATA_FIFO
	port map (
		aclr    => reset_dram_clk,
		data    => user_cmd_addr_out & dram_data_in_q, 
		rdclk   => PI_USER_CLK,
		rdreq   => PI_ACK,
		wrclk   => PI_DRAM_CLK,
		wrreq   => in_rd_burst_q2 and (not suspend_needed_q3),
		q       => rd_data_out_fif0_q,
		rdempty => rd_data_out_fifo_empty,
		wrusedw => rd_data_out_fifo_usedw
	);
	
	PO_ADDR_OUT <= rd_data_out_fif0_q(rd_data_out_fif0_q'left downto DATA_WIDTH);
	PO_DATA_OUT <= rd_data_out_fif0_q(DATA_WIDTH-1 downto 0);
	PO_DATA_RDY <= not rd_data_out_fifo_empty;
	
	rd_data_out_fifo_full <= to_stdLogic(rd_data_out_fifo_usedw > RD_FIFO_FULL_THRESHOLD);
	
   -- Shared counter for the refresh cycles and the init process	
	PROC_CNT_REFRESH : process (PI_DRAM_CLK) is
	begin
		if rising_edge(PI_DRAM_CLK) then
			if (reset_dram_clk) or (cnt_refresh_clr) then
				cnt_refresh <= (others => '0');
			elsif (refresh_done and init_done) then
				cnt_refresh <= cnt_refresh - REFRESH_CLOCKS;
			elsif (NAND_REDUCE(cnt_refresh)) then
				cnt_refresh <= cnt_refresh + 1;
			end if;
		end if;
	end process PROC_CNT_REFRESH;
		
	should_refresh  <= to_stdLogic(cnt_refresh >= REFRESH_CLOCKS-1);
	must_refresh    <= to_stdLogic(cnt_refresh >= 2*REFRESH_CLOCKS-1);
	refresh_pending <= must_refresh or should_refresh;
	init_count_done  <= to_stdLogic(cnt_refresh >= INIT_CLOCKS-1);
	
	-- shift register keeps a record of the last commands
	PROC_WR_B4_RD : process (PI_DRAM_CLK) is
	begin
		if rising_edge(PI_DRAM_CLK) then
			if (reset_dram_clk) then
				command_record <= (others => '0');
			elsif ((start_wr_command or start_rd_command) and (not suspend_needed)) then
				command_record <= command_record(NUM_WR_B4_RD-2 downto 0) & start_wr_command;
			end if;
		end if;
	end process PROC_WR_B4_RD;
	
	curr_command         <= command_record(0); -- is current command Write or Read
	all_last_cmds_are_wr <= AND_REDUCE(command_record);
	able_to_write        <= (not user_wr_cmd_empty) and (not user_wr_data_empty);
	able_to_read         <= (not user_rd_cmd_empty) and to_stdLogic(rd_data_out_fifo_usedw < RD_FIFO_FULL_THRESHOLD);
	next_command_is_wr   <= ((not all_last_cmds_are_wr) or (not able_to_read)) and able_to_write;
	next_command_is_rd   <= (not next_command_is_wr) and able_to_read;
	command_pending      <= next_command_is_rd or next_command_is_wr;  -- command is pending
	
	-- shift register used for the indication that the controller is currently in a Write Burst
	PROC_WR_BURSTS_SHIFT : process (PI_DRAM_CLK) is
	begin
		if rising_edge(PI_DRAM_CLK) then
			if (reset_dram_clk) then
				wr_burst_shift <= (others => '0');
			elsif (not suspend_needed) then
				wr_burst_shift <= wr_burst_shift(BURST_LENGTH-2 downto 0) & start_wr_burst;
			end if;
		end if;
	end process PROC_WR_BURSTS_SHIFT;

	-- shift register used for the indication that the controller is currently in a Read Burst
	PROC_RD_BURSTS_SHIFT : process (PI_DRAM_CLK) is
	begin
		if rising_edge(PI_DRAM_CLK) then
			if (reset_dram_clk) then
				rd_burst_shift <= (others => '0');
			elsif (not suspend_needed_q1) then
				rd_burst_shift <= rd_burst_shift(BURST_LENGTH-2 downto 0) & start_rd_burst;
			end if;
		end if;
	end process PROC_RD_BURSTS_SHIFT;
	
	in_rd_burst    <= OR_REDUCE(rd_burst_shift); -- controller is currently in a Read Burst
	in_wr_burst    <= OR_REDUCE(wr_burst_shift); -- controller is currently in a Write Burst
	
	-- operation is needed to suspend
	suspend_needed <= ((in_wr_burst and user_wr_data_empty) or (in_rd_burst and rd_data_out_fifo_full)) and to_stdLogic(not ALLOW_DATA_CORRUPTION);
	
	pending_cmd_address <= user_wr_cmd_addr when (next_command_is_wr) else user_rd_cmd_addr; -- address of the next pending command (from commands FIFO output)
	pending_bank        <= pending_cmd_address(t_usr_banks_range);                           -- bank of the next pending command
	pending_row         <= pending_cmd_address(t_usr_rows_range);                            -- row of the next pending command
 	pend_bank_is_aktiv  <= curr_active_banks(conv_integer(pending_bank));                    -- is pending bank already active (is active command needed) 
	active_row          <= curr_active_rows(conv_integer(pending_bank));                     -- currently active row in the pending bank                     
	row_change          <= to_stdLogic(pending_row /= active_row);                           -- need to change the active row (precharge command is needed)
	precharge_needed    <= command_pending and pend_bank_is_aktiv and row_change;            -- PRECHARGE command is needed 
	activate_needed     <= command_pending and (not pend_bank_is_aktiv);                     -- ACTIVE command is needed
	
	all_banks_inactive  <= NOR_REDUCE(curr_active_banks);                                    -- all the banks are currently not active
	
	-- Controller Finite State Machine registers (need to be reset)
	PROC_CONTROL_FSM_STATE : process (PI_DRAM_CLK) is
	begin
		if rising_edge(PI_DRAM_CLK) then
			if (reset_dram_clk) then
				control_curr_state  <= INIT_WAIT;
				init_first_ref_done <= '0';
			else
				control_curr_state <= control_next_state;
				if (control_curr_state = AUTO_REF6) then
					init_first_ref_done <= '1';
	 			end if;	
			end if;
		end if;
	end process PROC_CONTROL_FSM_STATE;
	
	-- System registers that do not need to be reset
	PROC_REGISTERS : process (PI_DRAM_CLK) is
	begin
		if rising_edge(PI_DRAM_CLK) then
			if (not suspend_needed) then
				curr_addr       <= next_addr;             
				curr_ba         <= next_ba;              
				curr_dqm        <= next_dqm;              
				curr_sdram_cmd  <= next_sdram_cmd;
			end if;
			curr_active_banks  <= next_active_banks;
			curr_active_rows   <= next_active_rows;
			suspend_needed_q1  <= suspend_needed;
			suspend_needed_q2  <= suspend_needed_q1;
			suspend_needed_q3  <= suspend_needed_q2;
			in_wr_burst_q      <= in_wr_burst;
			in_rd_burst_q1     <= in_rd_burst;
			in_rd_burst_q2     <= in_rd_burst_q1;
			init_done          <= next_init_done;
			start_rd_burst_q1  <= start_rd_burst;
			start_rd_burst_q2  <= start_rd_burst_q1;
			dram_data_in_q     <= dram_data_in;
			user_wr_data_out_q <= user_wr_data_out;
			if (read_user_rd_cmd or read_user_wr_cmd) then
				curr_user_cmd_addr <= next_user_cmd_addr;
			end if;
			if (start_wr_command or start_rd_command) then
				if (next_command_is_wr)  then
					next_user_cmd_addr <= user_wr_cmd_addr;
				else
					next_user_cmd_addr <= user_rd_cmd_addr;
				end if;
			end if;
			if (start_rd_burst_q2) then
				user_cmd_addr_out <= curr_user_cmd_addr;
			end if;
			if (control_next_state = PRE) and (control_curr_state /= PRE) then
				pending_bank_q <= pending_bank;
			end if;
		end if;
	end process PROC_REGISTERS;
	

	next_bank     <= next_user_cmd_addr(t_usr_banks_range);
	next_row      <= next_user_cmd_addr(t_usr_rows_range);
	next_col      <= next_user_cmd_addr(t_usr_cols_range);
	
	alternate_bank_activate  <= (not must_refresh) and activate_needed and (not precharge_needed);
	write_alternate_bank_act <= alternate_bank_activate and next_command_is_wr;
	read_alternate_bank_act  <= alternate_bank_activate and next_command_is_rd;
	read_again               <= next_command_is_rd and (not precharge_needed);
	goto_precharge           <= must_refresh or precharge_needed;
		
	-- Controller Finite State Machine implementation
	PROC_CONTROL_FSM_LOGIC: process (all) is
	begin
		control_next_state <= control_curr_state;
		refresh_done       <= '0';
		start_wr_command   <= '0';
		start_rd_command   <= '0';
		start_wr_burst     <= '0';
		start_rd_burst     <= '0';
		next_addr	       <= next_row;
		next_ba 	          <= next_bank;
		next_dqm	          <= "00";
		next_cke	          <= '1';
		next_sdram_cmd     <= SDRAM_CMD_NOP;
		read_user_wr_cmd   <= '0';
		read_user_rd_cmd   <= '0';
		next_init_done     <= init_done;
		next_active_banks  <= curr_active_banks;
		next_active_rows   <= curr_active_rows;
		cnt_refresh_clr    <= '0';
		case(control_curr_state) is
			when INIT_WAIT => 
				next_init_done <= '0';
				if (init_count_done) then
					control_next_state <= PRE;
				end if;
			when INIT_MRS => 
				next_sdram_cmd     <= SDRAM_CMD_MRS;
				next_addr          <= MODE_REG;
				control_next_state <= INIT_FINISHED;
			when INIT_FINISHED =>
				next_init_done     <= '1';
				cnt_refresh_clr    <= '1';
				control_next_state <= IDLE;
			when AUTO_REF => 
				next_sdram_cmd     <= SDRAM_CMD_REF;
				refresh_done       <= '1';
				control_next_state <= AUTO_REF1;
			when AUTO_REF1 => 
				control_next_state <= AUTO_REF2;
			when AUTO_REF2 => 
				control_next_state <= AUTO_REF3;
			when AUTO_REF3 => 
				control_next_state <= AUTO_REF4;
			when AUTO_REF4 => 
				control_next_state <= AUTO_REF5;
			when AUTO_REF5 => 
				control_next_state <= AUTO_REF6;
			when AUTO_REF6 =>
				if (not init_done) then
					if (not init_first_ref_done) then
						control_next_state <= AUTO_REF;
					else
						control_next_state <= INIT_MRS;
					end if;
				else
					control_next_state <= IDLE;
				end if;
			when IDLE => 
				if refresh_pending then
					if all_banks_inactive then
						control_next_state <= AUTO_REF;
					else 
						control_next_state <= PRE;
					end if;
				elsif precharge_needed then
					control_next_state <= PRE;
				elsif command_pending then 
					if (activate_needed) then
						control_next_state <= ACT;
					elsif (next_command_is_wr) then
						control_next_state <= WR;
						start_wr_burst     <= '1';
					else
						control_next_state <= RD;
					end if;
					if next_command_is_wr then
						start_wr_command   <= '1';
					end if;
					if next_command_is_rd then
						start_rd_command   <= '1';
					end if;
				end if;
			when PRE => 
				next_ba        <= pending_bank_q;
				next_sdram_cmd <= SDRAM_CMD_PRE;
				if ((refresh_pending and (not (suspend_needed or suspend_needed_q1 or suspend_needed_q2))) or (not init_done)) then
					next_addr(10)     <= '1';
					next_active_banks <= (others => '0');
				else
					next_addr(10) <= '0';
					next_active_banks(conv_integer(pending_bank_q)) <= '0';
				end if;
				control_next_state <= PRE1;
			when PRE1 =>
				if ((refresh_pending and all_banks_inactive) or (not init_done)) then
					control_next_state <= AUTO_REF;
				elsif (precharge_needed or (refresh_pending and (not all_banks_inactive))) then
					control_next_state <= PRE;
				elsif (command_pending) then
					if (activate_needed) then 
						control_next_state <= ACT;
					elsif (next_command_is_rd) then
						control_next_state <= RD;
					else
						control_next_state <= WR;
						start_wr_burst     <= '1';
					end if;
					if next_command_is_wr then
						start_wr_command <= '1';
					end if;
					if next_command_is_rd then
						start_rd_command <= '1';
					end if;
				else
					control_next_state <= IDLE;
				end if;
			when ACT => 
				next_sdram_cmd     <= SDRAM_CMD_ACT;
				control_next_state <= ACT1;
				next_active_banks(conv_integer(next_bank)) <= '1';      -- save active bank indication
				next_active_rows(conv_integer(next_bank))  <= next_row; -- save active row indication
			when ACT1 => 
				if curr_command = '1' then
					control_next_state <= WR;
					start_wr_burst     <= '1';
				else
					control_next_state <= RD;
				end if;
			when WR => 
				next_sdram_cmd        <= SDRAM_CMD_WRITE;
				read_user_wr_cmd      <= '1';
				control_next_state    <= WR1;
				next_addr(1 downto 0) <= "00"; 
				next_addr(10)         <= '0';
				next_addr(NUM_COLS_BITS-1 downto 2) <= next_col;
			when WR1 => 
				if (write_alternate_bank_act) then
					control_next_state <= ACT;
					start_wr_command   <= '1';
				else
					control_next_state <= WR2;
				end if;
			when WR2 => 
				if (write_alternate_bank_act) then
					control_next_state <= ACT;
					start_wr_command   <= '1';
				else
					control_next_state <= WR3;
				end if;
			when WR3 =>
				if (goto_precharge) then
					control_next_state <= PRE;
				elsif (command_pending) then
					if (next_command_is_rd) then
						start_rd_command <= '1';
					end if;
					if (next_command_is_wr) then
						start_wr_command <= '1';
					end if;
					if (activate_needed) then
						control_next_state <= ACT;
					elsif (next_command_is_rd) then
						control_next_state <= RD;
					else
						control_next_state <= WR;
						start_wr_burst     <= '1';
					end if;
				else
					control_next_state <= IDLE;
				end if;
			when RD => 
				next_sdram_cmd        <= SDRAM_CMD_READ;
				control_next_state    <= RD1;
				read_user_rd_cmd      <='1';
				next_addr(1 downto 0) <= "00"; 
				next_addr(10)         <= '0';
				next_addr(NUM_COLS_BITS-1 downto 2) <= next_col;
			when RD1 => 
				start_rd_burst <= '1';
				if (read_alternate_bank_act) then
					control_next_state <= ACT;
					start_rd_command   <= '1';
				else
					control_next_state <= RD2;
				end if;
			when RD2 => 
				if (read_alternate_bank_act) then
					control_next_state <= ACT;
					start_rd_command   <= '1';
				else
					control_next_state <= RD3;
				end if;
			when RD3 => 
				if (must_refresh) then
					control_next_state <= PRE;
				elsif (read_again) then
					start_rd_command <= '1';
					if (activate_needed) then
						control_next_state <= ACT;
					else
						control_next_state <= RD;
					end if;
				else
					control_next_state <= RD2WR1;
				end if;
			when RD2WR1 => 
				next_dqm <= "11";
				if (must_refresh) then
					control_next_state <= PRE;
				elsif (read_again) then
					start_rd_command <= '1';
					if (activate_needed) then
						control_next_state <= ACT;
					else
						control_next_state <= RD;
					end if;
				else
					control_next_state <= RD2WR2;
				end if;
			when RD2WR2 => 
				next_dqm <= "11";
				if (must_refresh) then
					control_next_state <= PRE;
				elsif (read_again) then
					start_rd_command <= '1';
					if (activate_needed) then
						control_next_state <= ACT;
					else
						control_next_state <= RD;
					end if;
				else
					control_next_state <= RD2WR3;
				end if;
			when RD2WR3 =>
				next_dqm <= "11";
				if (goto_precharge) then
					control_next_state <= PRE;
				elsif (command_pending) then
					if (next_command_is_rd) then
						start_rd_command <= '1';
					end if;
					if (next_command_is_wr) then
						start_wr_command <= '1';
					end if;
					if (activate_needed) then
						control_next_state <= ACT;
					elsif (next_command_is_rd) then
						control_next_state <= RD;
					else
						control_next_state <= WR;
						start_wr_burst     <= '1';
					end if;
				else
					control_next_state <= IDLE;
				end if;
			when others => 
				control_next_state <= INIT_WAIT;
		end case;
		if (suspend_needed) then 
			control_next_state <= control_curr_state;
			next_cke <= '0';
		end if;
	end process PROC_CONTROL_FSM_LOGIC;
	
		-- outputs to SDRAM
	PO_DRAM_ADDR  <= curr_addr;
	PO_DRAM_BA    <= curr_ba;
	PO_DRAM_DQM   <= curr_dqm;
	PO_DRAM_CAS_N <= curr_sdram_cmd(1);
	PO_DRAM_RAS_N <= curr_sdram_cmd(2);
	PO_DRAM_CKE   <= next_cke;
	PO_DRAM_WE_N  <= curr_sdram_cmd(0);
	PO_DRAM_CS_N  <= curr_sdram_cmd(3);

end architecture arch;