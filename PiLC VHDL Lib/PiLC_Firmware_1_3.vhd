--Firma: DESY Hamburg
--Autor: Tobias Spitzbart-Silberer
--Projekt:	 PiLC_Firmware 1_3
--Erstellt am: 05.01.2021
--Kurzbeschreibung: SPI-Slave-Schnittstelle zur Kommunikation zwischen FPGA und RPI
--(c) Copyright 2021 DESY

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PiLC_Firmware_1_3 is 
	generic(	
				Projekt_Nr: 		positive:= 1;
				Projekt_Version: 	positive:= 1);
				
	port ( 	PiLC_CLK: in std_logic;
				SDRAM_CLK: in std_logic;
----------------------------------------------
				SPI_CLK: in std_logic;
				SPI_MOSI: in std_logic;
				SPI_EN: in  std_logic;
				SPI_MISO: out std_logic;
----------------------------------------------
				EPCS_DCLK:out std_logic;
				EPCS_DATAIN: out std_logic;
				EPCS_NSCO: out std_logic;
				EPCS_DATAOUT: in std_logic;
----------------------------------------------				
				IO_Event_Out : buffer std_logic;
----------------------------------------------
				Event_Out  : out   std_logic_vector(15 downto 0); 
----------------------------------------------
				Event_In  : in   std_logic_vector(15 downto 0);        
----------------------------------------------
				IO_1_Ex :  INOUT  STD_LOGIC;
				IO_2_Ex :  INOUT  STD_LOGIC;
				IO_3_Ex :  INOUT  STD_LOGIC;
				IO_4_Ex :  INOUT  STD_LOGIC;
				IO_5_Ex :  INOUT  STD_LOGIC;
				IO_6_Ex :  INOUT  STD_LOGIC;
				IO_7_Ex :  INOUT  STD_LOGIC;
				IO_8_Ex :  INOUT  STD_LOGIC;
				IO_9_Ex :  INOUT  STD_LOGIC;
				IO_10_Ex :  INOUT  STD_LOGIC;
				IO_11_Ex :  INOUT  STD_LOGIC;
				IO_12_Ex :  INOUT  STD_LOGIC;
				IO_13_Ex :  INOUT  STD_LOGIC;
				IO_14_Ex :  INOUT  STD_LOGIC;
				IO_15_Ex :  INOUT  STD_LOGIC;
				IO_16_Ex :  INOUT  STD_LOGIC;
----------------------------------------------				
				IO_1 :  INOUT  STD_LOGIC;
				DDR_1 :  IN  STD_LOGIC;
				Data_from_RPi_1 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_1  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------				
				IO_2 :  INOUT  STD_LOGIC;
				DDR_2 :  IN  STD_LOGIC;
				Data_from_RPi_2 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_2  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------				
				IO_3 :  INOUT  STD_LOGIC;
				DDR_3 :  IN  STD_LOGIC;
				Data_from_RPi_3 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_3  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------				
				IO_4 :  INOUT  STD_LOGIC;
				DDR_4 :  IN  STD_LOGIC;
				Data_from_RPi_4 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_4  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------				
				IO_5 :  INOUT  STD_LOGIC;
				DDR_5 :  IN  STD_LOGIC;
				Data_from_RPi_5 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_5  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				IO_6 :  INOUT  STD_LOGIC;
				DDR_6 :  IN  STD_LOGIC;
				Data_from_RPi_6 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_6  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------	
				IO_7 :  INOUT  STD_LOGIC;
				DDR_7 :  IN  STD_LOGIC;
				Data_from_RPi_7 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_7  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				IO_8 :  INOUT  STD_LOGIC;
				DDR_8 :  IN  STD_LOGIC;
				Data_from_RPi_8 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_8  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------				
				IO_9 :  INOUT  STD_LOGIC;
				DDR_9 :  IN  STD_LOGIC;
				Data_from_RPi_9 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_9  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				IO_10 :  INOUT  STD_LOGIC;
				DDR_10 :  IN  STD_LOGIC;
				Data_from_RPi_1_0 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_1_0  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				IO_11 :  INOUT  STD_LOGIC;
				DDR_11 :  IN  STD_LOGIC;
				Data_from_RPi_1_1 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_1_1  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				IO_12 :  INOUT  STD_LOGIC;
				DDR_12 :  IN  STD_LOGIC;
				Data_from_RPi_1_2 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_1_2  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				IO_13 :  INOUT  STD_LOGIC;
				DDR_13 :  IN  STD_LOGIC;
				Data_from_RPi_1_3 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_1_3  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				IO_14 :  INOUT  STD_LOGIC;
				DDR_14 :  IN  STD_LOGIC;
				Data_from_RPi_1_4 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_1_4  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				IO_15 :  INOUT  STD_LOGIC;
				DDR_15 :  IN  STD_LOGIC;
				Data_from_RPi_1_5 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_1_5  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				IO_16 :  INOUT  STD_LOGIC;
				DDR_16 :  IN  STD_LOGIC;
				Data_from_RPi_1_6 : buffer  STD_LOGIC_VECTOR (31 downto 0);
				Data_to_RPi_1_6  : in  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------
				SDRAM_WRITE_Addr: in STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				SDRAM_WRITE_Data_1: in STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				SDRAM_WRITE_Data_2: in STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				
				SDRAM_READ_Addr: in STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				SDRAM_READ_Data_1: out STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				SDRAM_READ_Data_2: out STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				

				PO_DRAM_ADDR  : out   std_logic_vector(12 downto 0);        -- SDRAM Address Bus Interface
				PO_DRAM_BA    : out   std_logic_vector(1 downto 0);			--(f_log2(NUM_OF_BANKS)-1 downto 0); -- SDRAM Bank Interface
				PO_DRAM_DQM   : out   std_logic_vector(1 downto 0);         -- SDRAM Data Mask interface
				PO_DRAM_CAS_N : out   std_logic;                            -- SDRAM CAS_N line
				PO_DRAM_RAS_N : out   std_logic;                            -- SDRAM RAS_N line
				PO_DRAM_CKE   : out   std_logic;                            -- SDRAM CKE line
				PO_DRAM_CLK   : out   std_logic;                            -- SDRAM Input Clock (100 MHz Output from FPGA)
				PO_DRAM_WE_N  : out   std_logic;                            -- SDRAM WE_N line
				PO_DRAM_CS_N  : out   std_logic;                            -- SDRAM CS_N line
				PIO_DRAM_DQ   : inout std_logic_vector(15 downto 0);        -- SDRAM Data Bus Interface
				
				SDRAM_Write_Start: in std_logic;
				SDRAM_Write_Burst: in std_logic;
				SDRAM_Write_Busy: out std_logic;
				
				SDRAM_Read_Start: in std_logic;
				SDRAM_Read_Busy: out std_logic;
	
----------------------------------------------
				ADXL345_clk  : inout   std_logic;   
				ADXL345_CS  : out   std_logic; 
				ADXL345_Int  : in   std_logic; 
				ADXL345_SDIO  : inout  std_logic; 
----------------------------------------------
				PiLC_Time: out STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				PiLC_Time_Offset: out STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				PiLC_Time_FOut: out   std_logic; 
----------------------------------------------
				Reset: in std_logic
			);
	end PiLC_Firmware_1_3;
architecture Verhalten of PiLC_Firmware_1_3 is
----------------------------------------------
--inout_unit einbinden
----------------------------------------------
COMPONENT inout_unit --INOut_unit einbinden
	PORT(Input : IN STD_LOGIC;
		 Int : INOUT STD_LOGIC;
		 Ex : INOUT STD_LOGIC;
		 Status : OUT STD_LOGIC
	);
END COMPONENT;
----------------------------------------------
--SDRAM Controler einbinden
----------------------------------------------
COMPONENT SDRAM_CONTROL 
GENERIC (
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
	PORT(
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
END COMPONENT;
----------------------------------------------
--SPI und Regsiter Verwaltung Signale 
----------------------------------------------
signal Spi_CLK_counter : integer range 0 to 65:= 0;
signal Spi_CLK_counter_sr : std_logic_vector(1 downto 0);
signal Spi_CLK_Burst : bit;
signal Spi_Adr_Data_Fin : bit;
signal Adr_Data_counter_Fin : bit;
signal Data_counter_Ready : bit;
signal CRC_counter_Ready : bit;
signal CRC_counter_Fin : bit;
signal Data_buffer  : STD_LOGIC_VECTOR (31 downto 0);
signal SPI_Data_buffer  : STD_LOGIC_VECTOR (31 downto 0);
signal SPI_Data_MISO: STD_LOGIC_VECTOR (31 downto 0):= x"00000000";
signal SPI_Data_In_Buffer: STD_LOGIC_VECTOR (31 downto 0):= x"00000000";
signal CRC_Data: STD_LOGIC_VECTOR (39 downto 0);
signal RW_Data: STD_LOGIC_VECTOR (7 downto 0);
signal lfsr_q: std_logic_vector (7 downto 0);
signal lfsr_c: std_logic_vector (7 downto 0); 
signal Spi_MISO_En: bit;
signal Adr_Data: STD_LOGIC_VECTOR (7 downto 0);
signal Spi_MISO_En_Ready: bit;
signal EEPROM_EN: std_logic;
signal Burst_EN: bit;
signal Burst_FiFO_EN: bit;
signal Write_EN: bit;
signal Burst_loop: bit;
signal Adr_Ready: bit;
signal Data_Ready: bit;
signal SPI_Data_OUT:  STD_LOGIC_VECTOR(31 downto 0);
signal SPI_Data_In: STD_LOGIC_VECTOR(31 downto 0);
signal IO_Status_Register :  STD_LOGIC_VECTOR(0 TO 15);
signal IO_Status_Register_buffer: STD_LOGIC_VECTOR (15 downto 0):= x"0000";
signal IO_Status_counter : integer range 0 to 1500000 := 0;
signal FPGA_MISO :  STD_LOGIC;

type SPI_Transfer is (
	WT_F_SPI_Trans,
	LD_Data_O,
	CP_Data_O_to_MISO,
	MISO_Update_Data,
	WT_F_Data_I,
	CRC_S_B_Config,
	CRC_calc,
	S_B_Config,
	MISO_Update_CRC,
	CRC_Data_I_check,
	End_of_SPI_Trans
);
signal State_counter : SPI_Transfer;

----------------------------------------------
--SDRAM Signale
----------------------------------------------
signal PI_RESET        : std_logic; -- Reset input (should be at least connected to the PLL lock signal)
signal PI_ACK          : std_logic; -- User Acknoledge of Data Read
signal PI_CMD_RDY      : std_logic; -- Command to SDRAM Controller is Ready and Valid
signal PI_WR           : std_logic; -- Current Command is Write on logical '1' and Read on logical '0'
signal PI_ADDR_IN      : std_logic_vector(21 downto 0); --(f_log2(NUM_OF_BANKS*NUM_OF_ROWS*NUM_OF_COLS)-3 downto 0); -- Address of next 4 Data Words to Read of Write
signal PI_DATA_IN      : std_logic_vector(15 downto 0); -- Data Input to SDRAM Controller (for Write Commands)
signal PI_DATA_RDY     : std_logic;                     -- Data Input is Ready and Valid (for Write Commands)
signal PO_ADDR_OUT     : std_logic_vector(21 downto 0); --(f_log2(NUM_OF_BANKS*NUM_OF_ROWS*NUM_OF_COLS)-3 downto 0); -- Address Output from SDRAM Controller (from read Commands)
signal PO_DATA_OUT     : std_logic_vector(15 downto 0); -- Data Output from SDRAM Controller (from read Commands)   
signal PO_DATA_RDY     : std_logic;                     -- Address + Data from SDRAM Controller are Ready and Valid
signal PO_DRAM_WR_BUSY : std_logic; -- SDRAM Controller is unable to receive additional Write Commands!	
signal PO_DRAM_RD_BUSY : std_logic;	-- SDRAM Controller is unable to receive additional Read Commands!

--signal SDRAM_Read_ADDR_In: STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal SDRAM_Read_ADDR_Out: STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal SDRAM_Last_ADDR_buffer: STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
--signal SDRAM_Read_Data_1: STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
--signal SDRAM_Read_Data_2: STD_LOGIC_VECTOR (31 downto 0) := x"00000000";

signal SDRAM_Read_ADDR_In : integer:=0;
--signal SDRAM_Read_busy: std_logic;
signal SDRAM_Read_Next_ADDR: std_logic;
signal SDRAM_Read_Data_Single_Update : std_logic;

-- SDRAM Write State
type SDRAM_WR_State is (
		Wait_WR_St_H,
		WR_Data_1_L,
		WR_Data_2_H,
		WR_Data_2_L,
		Reset_Data_RDY,
		Wait_WR_S_L
		);
signal SDRAM_Write: SDRAM_WR_State;

-- SDRAM Read State
type SDRAM_RD_State is (
		Wait_Start,
		CK_ADDR_Max,
		Wait_RD_St_H,
		RD_ADDR_Data_1_H,
		RD_Data_1_L,
		RD_Data_2_H,
		RD_Data_2_L,
		Wait_RD_St_L
		);
signal SDRAM_Read: SDRAM_RD_State;
----------------------------------------------
--PiLC_Time
----------------------------------------------
signal NTP_Start_Time : integer  range 0 to 864000000;
signal NTP_Time : integer  range 0 to 864000000;
signal PiLC_Time_Counter : integer  range 0 to 864000000;
--signal PiLC_Timer_100us : integer range 0 to 15100 := 14999;
signal PiLC_Time_y : integer := 0;
signal PiLC_Time_e 	: integer:=0;
signal PiLC_Time_eF 	: integer:=0;
signal PiLC_Time_esum : integer:=0;
signal PiLC_Time_ealt : integer:=0;
signal PiLC_Time_ealt2 : integer:=0;
signal PiLC_Time_ealt3 : integer:=0;
signal PiLC_Timer_100us_Tuning : integer range 0 to 10 := 9;

signal PiLC_Time_Counter_start:  STD_LOGIC;
signal DDS_counter: unsigned (31 downto 0):= x"00000000";


type PiLC_Time_State is (
	Init,
	Compare,
	Filter_e,
	Calc_Esum,
	Limit_Esum,
	Windup,
	Tuning,
	Running
);
signal PiLC_Time_Flow : PiLC_Time_State;


begin	
----------------------------------------------
-- SPI MISO Daten austakten
----------------------------------------------
----------------------------------------------	
process (Spi_CLK,Spi_MISO_En,SPI_Data_In_Buffer)   
begin
	if (Spi_MISO_En='1') then
		SPI_Data_MISO <= SPI_Data_In_Buffer;
	elsif (Spi_CLK'event and Spi_CLK='1')  then     
		SPI_Data_MISO <= SPI_Data_MISO(30 downto 0) & '0'; -- wird MISO aktualisiert
	end if;
end process;
FPGA_MISO <= SPI_Data_MISO(31) when SPI_EN='0' else '0';
----------------------------------------------
---------------------------------------------
-- SPI MOSI eintakten
----------------------------------------------	
process(Spi_CLK,SPI_EN)
begin
if((Spi_CLK'event and Spi_CLK='1')and (SPI_EN='0')) then	
	SPI_Data_buffer   <= SPI_Data_buffer  (30 downto 0) & Spi_MOSI; -- wird MOSI eingetaktet
	end if;
	
if (SPI_EN='1') then
	SPI_Data_buffer <=x"00000000";
end if;
end process;
---------------------------------------------
-- SPI Takte z??hlen
----------------------------------------------	
process(Spi_CLK,SPI_EN,Spi_CLK_Burst)
begin
if (Spi_CLK_Burst='1') then
	Spi_CLK_counter<=16;
elsif((Spi_CLK'event and Spi_CLK='1')and (SPI_EN='0')) then	
	Spi_CLK_counter<=Spi_CLK_counter+1;
end if;

if (SPI_EN='1') then
	Spi_CLK_counter<=0;
end if;
end process;
------------
---------------------------------------------
---SPI Verwaltung
----------------------------------------------	
process(PiLC_CLK,SPI_EN,PO_Data_RDY)
variable Burst_Data: integer range 0 to 63:= 0;
variable Burst_FiFO_Counter : integer range 0 to 4 := 0;
begin		
if	(PiLC_CLK'event and PiLC_CLK='1') then
----------------------------------------------
---SPI Daten einsync.
----------------------------------------------
Spi_CLK_counter_sr  <= Spi_CLK_counter_sr (0) & Spi_CLK; 
if (Spi_CLK_counter_sr ="01")and (SPI_EN='0') then
	Data_buffer   <= SPI_Data_buffer;
	case Spi_CLK_counter is
		when 8 =>  Spi_Adr_Data_Fin<='1';
		when 16 => Adr_Data_counter_Fin<='1';
		when 48 => Data_counter_Ready<='1';
		when 56 => CRC_counter_Ready<='1';
		when 64 => CRC_counter_Fin<='1';
		when others =>
	end case;
end if;
----------------------------------------------
---SPI State Machine
----------------------------------------------	
	case State_counter is
----------------------------------------------
-- Erstes Byte empfangen -> Adresse Daten Speichern
----------------------------------------------	
		when WT_F_SPI_Trans =>	if (Spi_Adr_Data_Fin='1') then 
											State_counter<=LD_Data_O ;
											Adr_Data<=Data_buffer(7 downto 0);
										end if;
----------------------------------------------
---Daten aus dem Registern holen
----------------------------------------------							
		when LD_Data_O => 	Adr_Ready<='1'; 
									State_counter<=CP_Data_O_to_MISO;
----------------------------------------------
-- Wenn Daten breit dann aus dem Register holen -> in Buffer schreiben
----------------------------------------------		
		when CP_Data_O_to_MISO =>if (Spi_MISO_En_Ready='1')then
											SPI_Data_In_Buffer<=SPI_Data_OUT;
											State_counter<=MISO_Update_Data;
										end if;
----------------------------------------------
-- Zweites Byte empfangen, Daten aus dem MISO Bus legen
-- MISO Daten update Aktivieren
----------------------------------------------							
		when MISO_Update_Data =>	if Burst_loop='0' and Adr_Data_counter_Fin='1' then
												RW_Data<=Data_buffer(7 downto 0);
												case Data_buffer (7 downto 6) is
													when "10" => 	Write_EN<='1'; -- Daten schreiben
													when "01" => 	Burst_EN<='1';	-- Burst Daten lesen
																		Burst_Data:=to_integer(signed(Data_buffer(5 downto 0))); -- Anzahl der Register
													when "11" => 	Burst_EN<='1';	-- SDRAM Burst Daten lesen
																		Burst_Data:=to_integer(signed(Data_buffer(5 downto 0))); -- Anzahl der Register
																		Burst_FiFo_EN<='1'; 
																		Burst_FiFO_Counter:=3;
													when others =>
													end case;		
												Spi_MISO_En<='1';	State_counter<=WT_F_Data_I;
											end if;
											if Burst_loop='1' and Data_counter_Ready='1' then
												if Burst_FiFo_EN='1' and Burst_Data=0 then
													State_counter<=WT_F_Data_I;
												else
													Spi_CLK_Burst<='1';
													Spi_MISO_En<='1';	
													State_counter<=WT_F_Data_I;
												end if;
											end if;
----------------------------------------------
-- Warten bis die Daten (4Bytes) ??bertragen w??rden sind
-- Wenn Burst aktiviert ist, wird nicht gewartet.
----------------------------------------------		
		when WT_F_Data_I =>	Spi_MISO_En<='0';	Adr_Ready<='0';
									if Spi_CLK_Burst='1' then 
										Spi_CLK_Burst<='0';
										Data_counter_Ready<='0';
									else
										if (Data_counter_Ready='1') then
											State_counter<=CRC_S_B_Config;
										end if;
										if Burst_EN='1' then
											State_counter<=CRC_S_B_Config;
										end if;
									end if;
----------------------------------------------
-- Einstellungen f??r die CRC8 berechnung
----------------------------------------------							
		when CRC_S_B_Config => 	if Write_EN='1' then
											CRC_Data<=RW_Data&Data_buffer;
											State_counter<=CRC_calc;
										elsif Burst_EN='1' then
												if Burst_Data/=0 then
													CRC_Data<=lfsr_c&SPI_Data_In_Buffer;
													State_counter<=CRC_calc;
												else
													State_counter<=S_B_Config;
												end if;
										else
											CRC_Data<=RW_Data&SPI_Data_In_Buffer;
											State_counter<=CRC_calc;
										end if;
----------------------------------------------
-- CRC8 Berechnung
----------------------------------------------							
		when CRC_calc => 	lfsr_c(0) <= lfsr_q(2) xor lfsr_q(3) xor lfsr_q(7) xor CRC_Data(0) xor CRC_Data(6) xor CRC_Data(7) xor CRC_Data(8) xor CRC_Data(12) xor CRC_Data(14) xor CRC_Data(16) xor CRC_Data(18) xor CRC_Data(19) xor CRC_Data(21) xor CRC_Data(23) xor CRC_Data(28) xor CRC_Data(30) xor CRC_Data(31) xor CRC_Data(34) xor CRC_Data(35) xor CRC_Data(39);
								lfsr_c(1) <= lfsr_q(0) xor lfsr_q(2) xor lfsr_q(4) xor lfsr_q(7) xor CRC_Data(0) xor CRC_Data(1) xor CRC_Data(6) xor CRC_Data(9) xor CRC_Data(12) xor CRC_Data(13) xor CRC_Data(14) xor CRC_Data(15) xor CRC_Data(16) xor CRC_Data(17) xor CRC_Data(18) xor CRC_Data(20) xor CRC_Data(21) xor CRC_Data(22) xor CRC_Data(23) xor CRC_Data(24) xor CRC_Data(28) xor CRC_Data(29) xor CRC_Data(30) xor CRC_Data(32) xor CRC_Data(34) xor CRC_Data(36) xor CRC_Data(39);
								lfsr_c(2) <= lfsr_q(1) xor lfsr_q(2) xor lfsr_q(5) xor lfsr_q(7) xor CRC_Data(0) xor CRC_Data(1) xor CRC_Data(2) xor CRC_Data(6) xor CRC_Data(8) xor CRC_Data(10) xor CRC_Data(12) xor CRC_Data(13) xor CRC_Data(15) xor CRC_Data(17) xor CRC_Data(22) xor CRC_Data(24) xor CRC_Data(25) xor CRC_Data(28) xor CRC_Data(29) xor CRC_Data(33) xor CRC_Data(34) xor CRC_Data(37) xor CRC_Data(39);
								lfsr_c(3) <= lfsr_q(2) xor lfsr_q(3) xor lfsr_q(6) xor CRC_Data(1) xor CRC_Data(2) xor CRC_Data(3) xor CRC_Data(7) xor CRC_Data(9) xor CRC_Data(11) xor CRC_Data(13) xor CRC_Data(14) xor CRC_Data(16) xor CRC_Data(18) xor CRC_Data(23) xor CRC_Data(25) xor CRC_Data(26) xor CRC_Data(29) xor CRC_Data(30) xor CRC_Data(34) xor CRC_Data(35) xor CRC_Data(38);
								lfsr_c(4) <= lfsr_q(3) xor lfsr_q(4) xor lfsr_q(7) xor CRC_Data(2) xor CRC_Data(3) xor CRC_Data(4) xor CRC_Data(8) xor CRC_Data(10) xor CRC_Data(12) xor CRC_Data(14) xor CRC_Data(15) xor CRC_Data(17) xor CRC_Data(19) xor CRC_Data(24) xor CRC_Data(26) xor CRC_Data(27) xor CRC_Data(30) xor CRC_Data(31) xor CRC_Data(35) xor CRC_Data(36) xor CRC_Data(39);
								lfsr_c(5) <= lfsr_q(0) xor lfsr_q(4) xor lfsr_q(5) xor CRC_Data(3) xor CRC_Data(4) xor CRC_Data(5) xor CRC_Data(9) xor CRC_Data(11) xor CRC_Data(13) xor CRC_Data(15) xor CRC_Data(16) xor CRC_Data(18) xor CRC_Data(20) xor CRC_Data(25) xor CRC_Data(27) xor CRC_Data(28) xor CRC_Data(31) xor CRC_Data(32) xor CRC_Data(36) xor CRC_Data(37);
								lfsr_c(6) <= lfsr_q(0) xor lfsr_q(1) xor lfsr_q(5) xor lfsr_q(6) xor CRC_Data(4) xor CRC_Data(5) xor CRC_Data(6) xor CRC_Data(10) xor CRC_Data(12) xor CRC_Data(14) xor CRC_Data(16) xor CRC_Data(17) xor CRC_Data(19) xor CRC_Data(21) xor CRC_Data(26) xor CRC_Data(28) xor CRC_Data(29) xor CRC_Data(32) xor CRC_Data(33) xor CRC_Data(37) xor CRC_Data(38);
								lfsr_c(7) <= lfsr_q(1) xor lfsr_q(2) xor lfsr_q(6) xor lfsr_q(7) xor CRC_Data(5) xor CRC_Data(6) xor CRC_Data(7) xor CRC_Data(11) xor CRC_Data(13) xor CRC_Data(15) xor CRC_Data(17) xor CRC_Data(18) xor CRC_Data(20) xor CRC_Data(22) xor CRC_Data(27) xor CRC_Data(29) xor CRC_Data(30) xor CRC_Data(33) xor CRC_Data(34) xor CRC_Data(38) xor CRC_Data(39);
								lfsr_q <= x"00";
								State_counter<=S_B_Config;
----------------------------------------------
-- Burst Config
----------------------------------------------							
		when S_B_Config=>	if Burst_EN='1' and Burst_Data/=0 then
									Burst_loop<='1';
									Data_counter_Ready<='0';
									if Burst_FiFo_EN='1' then
										Burst_FiFO_Counter:=Burst_FiFO_Counter-1;
										if Burst_FiFO_Counter/=0 then
											Adr_Data<=std_logic_vector(unsigned(Adr_Data) + 2);
											State_counter<=LD_Data_O;
										else
											Burst_FiFO_Counter:=3;
											Burst_Data:=Burst_Data-1;
											Adr_Data<=std_logic_vector(unsigned(Adr_Data) - 4);
											State_counter<=LD_Data_O ;
										end if;
										State_counter<=LD_Data_O;
									else
										Burst_Data:=Burst_Data-1;
										if Burst_Data/=0 then
											Adr_Data<=std_logic_vector(unsigned(Adr_Data) + 2);
											State_counter<=LD_Data_O ;
										end if;
									end if;
								else
									SPI_Data_IN<=Data_buffer;
									SPI_Data_In_Buffer<= lfsr_c&x"000000";
									State_counter<=MISO_Update_CRC;
								end if;
----------------------------------------------
-- Warten bis das 7Byte emfpangen wurden ist
-- Daten das CRC Byte auf den MISO Bus legen
-- MISO Daten update Aktivieren
----------------------------------------------								
		when MISO_Update_CRC=> 	Spi_CLK_Burst<='0';
										if CRC_counter_Ready='1' then
											Spi_MISO_En<='1';
											State_counter<=CRC_Data_I_check;
										end if;
----------------------------------------------
-- Wenn Daten geschrieben werden sollen,
--wird das CRC Byte mit dem berechnet verglich
----------------------------------------------							
		when CRC_Data_I_check=>	Spi_MISO_En<='0';
										if (CRC_counter_Fin='1')then
												if lfsr_c=Data_buffer(7 downto 0) then
													Adr_Ready<='1';
													Data_Ready<='1';
												end if;
												State_counter<=End_of_SPI_Trans;
											end if;
----------------------------------------------
-- Ende der State Machine
----------------------------------------------							
		when 	End_of_SPI_Trans=>Data_Ready<='0';
										Adr_Ready<='0';
										State_counter<=WT_F_SPI_Trans;
										Spi_Adr_Data_Fin<='0';
		when others =>
	end case;
----------------------------------------------
-- Ende der SPI kommunikation
----------------------------------------------		
----------------------------------------------
--Register verwaltung
----------------------------------------------
		if (Adr_Ready='1'and SPI_EN='0') then	
			case Adr_Data is
-----------------------------------------------	
			when x"01" => 	if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_1<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_1; 
								end if;
			when x"02" => SPI_Data_OUT<=Data_to_RPi_1;
-----------------------------------------------		
			when x"03" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_2<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_2;
								end if;
			when x"04" => SPI_Data_OUT<=Data_to_RPi_2;
-----------------------------------------------		
			when x"05" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_3<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_3;
								end if;
			when x"06" => SPI_Data_OUT<=Data_to_RPi_3;
-----------------------------------------------
			when x"07" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_4<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_4;
								end if;
			when x"08" => SPI_Data_OUT<=Data_to_RPi_4; 
-----------------------------------------------
			when x"09" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_5<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_5;
								end if;
			when x"0A" => SPI_Data_OUT<=Data_to_RPi_5; 
-----------------------------------------------
			when x"0B" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_6<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_6;
								end if;
			when x"0C" => SPI_Data_OUT<=Data_to_RPi_6;
-----------------------------------------------	
			when x"0D" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_7<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_7;
								end if;
			when x"0E" => SPI_Data_OUT<=Data_to_RPi_7;
-----------------------------------------------	
			when x"0F" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_8<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_8;
								end if;
			when x"10" => SPI_Data_OUT<=Data_to_RPi_8;
-----------------------------------------------	
			when x"11" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_9<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_9;
								end if;
			when x"12" => SPI_Data_OUT<=Data_to_RPi_9;
-----------------------------------------------	
			when x"13" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_1_0<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_1_0;
								end if;
			when x"14" => SPI_Data_OUT<=Data_to_RPi_1_0;		
-----------------------------------------------	
			when x"15" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_1_1<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_1_1;
								end if;
			when x"16" => SPI_Data_OUT<=Data_to_RPi_1_1;
-----------------------------------------------	
			when x"17" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_1_2<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_1_2;
								end if;
			when x"18" => SPI_Data_OUT<=Data_to_RPi_1_2;
-----------------------------------------------	
			when x"19" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_1_3<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_1_3;
								end if;
			when x"1A" => SPI_Data_OUT<=Data_to_RPi_1_3;
-----------------------------------------------	
			when x"1B" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_1_4<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_1_4;
								end if;
			when x"1C" => SPI_Data_OUT<=Data_to_RPi_1_4;
-----------------------------------------------	
			when x"1D" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_1_5<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_1_5;
								end if;
			when x"1E" => SPI_Data_OUT<=Data_to_RPi_1_5; 
-----------------------------------------------
			when x"1F" => if (Data_Ready='1') and (Write_EN='1') then 
									Data_from_RPi_1_6<=SPI_Data_IN;
								else
									SPI_Data_OUT<=Data_from_RPi_1_6;
								end if;
			when x"20" => SPI_Data_OUT<=Data_to_RPi_1_6; 
-----------------------------------------------	
			when x"21" => SPI_Data_OUT<= 	x"0000" &
													DDR_16 & DDR_15 & DDR_14 & DDR_13 & DDR_12 & DDR_11 & DDR_10 & DDR_9 &
													DDR_8 & DDR_7 & DDR_6 & DDR_5 & DDR_4 & DDR_3 & DDR_2 & DDR_1;
-----------------------------------------------					
			when x"22" => SPI_Data_OUT<= x"0000" & IO_Status_Register_buffer; IO_Event_Out <='0';
-----------------------------------------------					
			when x"30" =>  SPI_Data_OUT<=SDRAM_Last_ADDR_buffer;
								
			when x"31" => 	if (Data_Ready='1') and (Write_EN='1')  then 
									SDRAM_Read_Data_Single_Update<='1';
									SDRAM_Read_ADDR_In<=to_integer(unsigned(SPI_Data_IN));
								else
									SPI_Data_OUT<=std_logic_vector(to_unsigned(SDRAM_Read_ADDR_In, 32));
								end if;
								
			when x"32" => 	SPI_Data_OUT<=SDRAM_Read_ADDR_Out;
								SDRAM_Read_Next_ADDR<='0';
			when x"34" => 	SPI_Data_OUT<=SDRAM_Read_Data_1;
								
			when x"36" => 	SPI_Data_OUT<=SDRAM_Read_Data_2;
								SDRAM_Read_Next_ADDR<='1';
----------------------------------------------		
			when x"40" => SPI_Data_OUT<=std_logic_vector(to_unsigned(PiLC_Time_Counter, 32));
			
			when x"41" => if (Data_Ready='1') and (Write_EN='1') then
									NTP_Start_Time<=to_integer(unsigned(SPI_Data_IN));
									PiLC_Time_Flow<=Init ;
								end if;
							
			when x"42" => if (Data_Ready='1') and (Write_EN='1') then 
									NTP_Time<=to_integer(unsigned(SPI_Data_IN));
									PiLC_Time_Flow<=Compare;
								end if;	
								
			when x"43" => SPI_Data_OUT<=std_logic_vector(to_unsigned(PiLC_Time_y, 32));
			when x"44" => SPI_Data_OUT<=std_logic_vector(to_unsigned(PiLC_Time_eF , 32));	
		
-----------------------------------------------	
			when x"64" => SPI_Data_OUT<= x"000000EC";--ID
-----------------------------------------------	
			when x"65" => SPI_Data_OUT<= x"0000000B";--HW Version
-----------------------------------------------	
			when x"66" => SPI_Data_OUT<= x"0000000B";--FW Version
-----------------------------------------------	
			when x"67" => SPI_Data_OUT<= std_logic_vector(to_unsigned(Projekt_Nr, 32));
-----------------------------------------------	
			when x"68" => SPI_Data_OUT<= std_logic_vector(to_unsigned(Projekt_Version, 32));
-----------------------------------------------	
----------------------------------------------	
			when x"6E" => EEPROM_EN <='1';
-----------------------------------------------	
			when others => SPI_Data_OUT<=x"00000000";
		end case;
----------------------------------------------
			Spi_MISO_En_Ready<='1';
		else
			Spi_MISO_En_Ready<='0';
		end if;
----------------------------------------------
-- Ende der Register verwaltung
----------------------------------------------

----------------------------------------------
-- PiLC Time
----------------------------------------------
----------------------------------------------
---PilC_Time_Flow_ States
----------------------------------------------	
case PiLC_Time_Flow is

when Init	=> PiLC_Time_Counter<=NTP_Start_Time;
					NTP_Time<=NTP_Start_Time;
					PiLC_Time_esum<=0;
					PiLC_Time_ealt<=0;
					PiLC_Time_ealt2<=0;
					PiLC_Time_ealt3<=0;
					PiLC_Time_Flow<=Running;					
----------------------------------------------
when Compare =>PiLC_Time_e<=NTP_Time-PiLC_Time_Counter; --Vergleich
					PiLC_Time_Flow<=Filter_e;		
----------------------------------------------
when Filter_e => 	PiLC_Time_eF<= (PiLC_Time_e+PiLC_Time_ealt+PiLC_Time_ealt2+PiLC_Time_ealt3)/4;
						PiLC_Time_Flow<=Calc_Esum;		
----------------------------------------------
when Calc_Esum =>	PiLC_Time_esum<=PiLC_Time_esum+PiLC_Time_eF ;				--Integration I-Anteil
						PiLC_Time_ealt3<=PiLC_Time_ealt2;
						PiLC_Time_Flow<=Limit_Esum;					
----------------------------------------------					
when Limit_Esum => if PiLC_Time_esum>1 then			--Esum limitieren
							PiLC_Time_esum<=1;
						elsif PiLC_Time_esum<-1 then
							PiLC_Time_esum<=-1;
						end if;
						PiLC_Time_ealt2<=PiLC_Time_ealt;
						PiLC_Time_Flow<=Tuning;
----------------------------------------------	
when Tuning => PiLC_Time_y<=PiLC_Time_eF+PiLC_Time_esum; --Reglergleichung P und I
					PiLC_Time_ealt<=PiLC_Time_eF;
					PiLC_Time_Flow<=Windup;
-------------------------------------------	
when Windup => 	if PiLC_Time_y>3 then				--y limitieren
							PiLC_Time_y<=3;
						elsif PiLC_Time_y<-3 then
							PiLC_Time_y<=-3;
						end if;
						PiLC_Time_Flow<=Running;
----------------------------------------------	
when Running =>DDS_counter<=DDS_counter+(to_unsigned(286332+PiLC_Time_y, 32));
					if (DDS_counter>(x"7FFFFFFF"))then
						PiLC_Time_FOut<='1';
						if PiLC_Time_Counter_start='0' then
						PiLC_Time_Counter_start<='1';
							if PiLC_Time_Counter=863999999 then -- -> 24 Stunden
								PiLC_Time_Counter<=0;
								else
								PiLC_Time_Counter<=PiLC_Time_Counter+1;
							end if;
						end if;
					else
						PiLC_Time_Counter_start<='0';
						PiLC_Time_FOut<='0';
					end if;

					
end case;

---------------------------------------------	
----------------------------------------------
-- IO_Status Update generieren
----------------------------------------------	
		if (SPI_EN='1') then	
		IO_Status_counter<=IO_Status_counter+1;
		if (IO_Status_Register_buffer/=IO_Status_Register)and(IO_Event_Out='0') and (IO_Status_counter<=0) then
				IO_Status_Register_buffer<=IO_Status_Register;
				IO_Event_Out <='1';
			end if;
		end if;
----------------------------------------------
-- Letzte geschriebene SDRAM Addr
----------------------------------------------	
if SDRAM_Write_Burst='0' then
	SDRAM_Last_ADDR_buffer<=SDRAM_WRITE_Addr;
end if;		
----------------------------------------------
-- SDRAM Write
----------------------------------------------	
PI_Reset<='0';
	case SDRAM_Write is
		when Wait_WR_St_H => if SDRAM_WRITE_Start='1' and PI_CMD_RDY='0' and PO_DRAM_WR_BUSY='0'and SDRAM_Read_Busy='0' and SDRAM_Write_Burst='1' then
											SDRAM_Write<=WR_Data_1_L;
											SDRAM_Write_Busy<='1';
											PI_CMD_RDY<='1';
											PI_WR<='1';
											PI_DATA_RDY<='1';
											PI_ADDR_IN<=SDRAM_WRITE_Addr(21 downto 0);
											PI_DATA_IN<=SDRAM_WRITE_Data_1(31 downto 16);
										end if;

		when WR_Data_1_L => 		SDRAM_Write<=WR_Data_2_H;
										PI_CMD_RDY<='0';
										PI_WR<='0';
										PI_DATA_IN<=SDRAM_WRITE_Data_1(15 downto 0);				
						
		when WR_Data_2_H => 		SDRAM_Write<=WR_Data_2_L;
										PI_DATA_IN<=SDRAM_WRITE_Data_2(31 downto 16);
						
		when WR_Data_2_L => 		SDRAM_Write<=Reset_Data_RDY;
										PI_DATA_IN<=SDRAM_WRITE_Data_2(15 downto 0);	
						
		when Reset_Data_RDY =>	SDRAM_Write<=Wait_WR_S_L;	
										PI_DATA_RDY<='0';
						
		when Wait_WR_S_L =>		SDRAM_Write_Busy<='0';
										if SDRAM_Write_Start='0' then
											SDRAM_Write<=Wait_WR_St_H;	
										end if;						
		when others =>
	end case;
----------------------------------------------
-- SDRAM Read
----------------------------------------------	
case SDRAM_Read is		
		when Wait_Start =>	if SDRAM_Read_Data_Single_Update='1' then
										SDRAM_Read<=CK_ADDR_Max;
										SDRAM_Read_Data_Single_Update<='0';
									elsif SDRAM_Read_Next_ADDR='1' then
										SDRAM_Read_ADDR_In<=SDRAM_Read_ADDR_In+1;
										SDRAM_Read<=CK_ADDR_Max;
										SDRAM_Read_Next_ADDR<='0';
									elsif SDRAM_Read_Start='1' then
										SDRAM_Read_ADDR_In<=to_integer(unsigned(SDRAM_READ_Addr));
										SDRAM_Read<=Wait_RD_St_H;	
									end if;
					
		when CK_ADDR_Max=>	if SDRAM_Read_ADDR_In=4194304 then 
										SDRAM_Read_ADDR_In<=0;
									end if;
									SDRAM_Read<=Wait_RD_St_H;	

		when Wait_RD_St_H =>	if PI_CMD_RDY='0' and PO_DRAM_RD_BUSY='0' and SDRAM_Write_Burst='0' then
										PI_ADDR_IN<=std_logic_vector(to_unsigned(SDRAM_Read_ADDR_In, 22));
										SDRAM_Read_Busy<='1';
										SDRAM_Read<=RD_ADDR_Data_1_H;
										PI_CMD_RDY<='1';	
									end if ;

		when RD_ADDR_Data_1_H =>PI_CMD_RDY<='0';
										if PO_Data_RDY='1' then
											SDRAM_Read<=RD_Data_1_L;	
											SDRAM_Read_ADDR_Out(21 downto 0)<=PO_ADDR_OUT ;
											SDRAM_Read_Data_1(31 downto 16)<=PO_DATA_OUT;
										end if;
						
		when RD_Data_1_L =>		if PO_Data_RDY='1' then
											SDRAM_Read<=RD_Data_2_H;	
											SDRAM_Read_Data_1(15 downto 0)<=PO_DATA_OUT;
										end if;
					
		when RD_Data_2_H =>		if PO_Data_RDY='1' then
											SDRAM_Read<=RD_Data_2_L;	
											SDRAM_Read_Data_2(31 downto 16)<=PO_DATA_OUT;
										end if;
						
		when RD_Data_2_L =>		if PO_Data_RDY='1' then
											SDRAM_Read<=Wait_RD_St_L;	
											SDRAM_Read_Data_2(15 downto 0)<=PO_DATA_OUT;
										end if;
						
		when Wait_RD_St_L =>		SDRAM_Read_Busy<='0';
										if SDRAM_Read_Data_Single_Update='0' and SDRAM_Read_Next_ADDR='0' and SDRAM_Read_Start='0'then
											SDRAM_Read<=Wait_Start;	
										end if;				
end case;
----------------------------------------------
--SPI Reset
----------------------------------------------
end if;
	if (SPI_EN='1') then
		--SDRAM_Read<=Wait_Start;	
		--SDRAM_Read_Next_ADDR<='0';
		--SDRAM_Read_Data_Single_Update<='0';
		lfsr_c <= x"00";
		Spi_MISO_En_Ready<='0';
		EEPROM_EN <='0';
		SPI_Data_OUT<=x"00000000";
		Spi_Adr_Data_Fin<='0';
		Adr_Data_counter_Fin<='0';
		Data_counter_Ready<='0';
		CRC_counter_Ready<='0';
		CRC_counter_Fin<='0';
		State_counter<=WT_F_SPI_Trans;
		Adr_Ready<='0';
		Data_Ready<='0';
		Adr_Data<=x"00";
		CRC_Data<=x"0000000000";
		Burst_EN<='0';
		Burst_FiFO_EN<='0';
		Burst_FiFO_Counter:=0;
		Burst_loop<='0';
		Burst_Data:=0;
		--Spi_CLK_counter<=0;
		Write_EN<='0';
	end if;
----------------------------------------------
PI_ACK <= PO_Data_RDY;
end process;	
PiLC_Time<=std_logic_vector(to_unsigned(PiLC_Time_Counter, 32));
PiLC_Time_Offset<=std_logic_vector(to_unsigned(PiLC_Time_eF, 32));
----------------------------------------------
--IO verwaltung
----------------------------------------------	
IO1: inout_unit
PORT MAP(Input => DDR_1,
		 Int => IO_1,
		 Ex => IO_1_Ex,
		 Status => IO_Status_Register(15));	
IO2: inout_unit
PORT MAP(Input => DDR_2,
		 Int => IO_2,
		 Ex => IO_2_Ex,
		 Status => IO_Status_Register(14));	
IO3: inout_unit
PORT MAP(Input => DDR_3,
		 Int => IO_3,
		 Ex => IO_3_Ex,
		 Status => IO_Status_Register(13));
IO4: inout_unit	 
PORT MAP(Input => DDR_4,
		 Int => IO_4,
		 Ex => IO_4_Ex,
		 Status => IO_Status_Register(12));	 
IO5: inout_unit
PORT MAP(Input => DDR_5,
		 Int => IO_5,
		 Ex => IO_5_Ex,
		 Status => IO_Status_Register(11));	
IO6: inout_unit
PORT MAP(Input => DDR_6,
		 Int => IO_6,
		 Ex => IO_6_Ex,
		 Status => IO_Status_Register(10));	
IO7: inout_unit
PORT MAP(Input => DDR_7,
		 Int => IO_7,
		 Ex => IO_7_Ex,
		 Status => IO_Status_Register(9));
IO8: inout_unit	 
PORT MAP(Input => DDR_8,
		 Int => IO_8,
		 Ex => IO_8_Ex,
		 Status => IO_Status_Register(8));
IO9: inout_unit
PORT MAP(Input => DDR_9,
		 Int => IO_9,
		 Ex => IO_9_Ex,
		 Status => IO_Status_Register(7));	
IO10: inout_unit
PORT MAP(Input => DDR_10,
		 Int => IO_10,
		 Ex => IO_10_Ex,
		 Status => IO_Status_Register(6));	
IO11: inout_unit
PORT MAP(Input => DDR_11,
		 Int => IO_11,
		 Ex => IO_11_Ex,
		 Status => IO_Status_Register(5));
IO12: inout_unit	 
PORT MAP(Input => DDR_12,
		 Int => IO_12,
		 Ex => IO_12_Ex,
		 Status => IO_Status_Register(4));	 
IO13: inout_unit
PORT MAP(Input => DDR_13,
		 Int => IO_13,
		 Ex => IO_13_Ex,
		 Status => IO_Status_Register(3));	
IO14: inout_unit
PORT MAP(Input => DDR_14,
		 Int => IO_14,
		 Ex => IO_14_Ex,
		 Status => IO_Status_Register(2));	
IO15: inout_unit
PORT MAP(Input => DDR_15,
		 Int => IO_15,
		 Ex => IO_15_Ex,
		 Status => IO_Status_Register(1));
IO16: inout_unit	 
PORT MAP(Input => DDR_16,
		 Int => IO_16,
		 Ex => IO_16_Ex,
		 Status => IO_Status_Register(0));			 
----------------------------------------------
--EPCS umschaltung
----------------------------------------------			
PROCESS(EPCS_Dataout,EEPROM_EN,FPGA_MISO,SPI_EN)
BEGIN
if (EEPROM_EN = '1') THEN
	SPI_MISO <= EPCS_Dataout;
elsif (NOT(EEPROM_EN OR SPI_EN) = '1') then
	SPI_MISO <= FPGA_MISO;
else 
	SPI_MISO <= '0';
END IF;
END PROCESS;
EPCS_NSCO<=not(EEPROM_EN);
EPCS_DCLK<=SPI_CLK;
EPCS_DATAIN<=SPI_MOSI;
----------------------------------------------
--Event verwaltung
----------------------------------------------	

Event_Out<=Event_In;
----------------------------------------------
--ADXL345 verwaltung
----------------------------------------------	
ADXL345_clk<=ADXL345_Int; 
ADXL345_CS<='1'; 
ADXL345_SDIO<='Z'; 
----------------------------------------------
--SDRAM Signale mappen.
----------------------------------------------	
DRAM: SDRAM_CONTROL
PORT MAP(
PO_DRAM_ADDR  	=> PO_DRAM_ADDR,
PO_DRAM_BA    	=> PO_DRAM_BA, 
PO_DRAM_DQM   	=> PO_DRAM_DQM,
PO_DRAM_CAS_N 	=> PO_DRAM_CAS_N,
PO_DRAM_RAS_N	=> PO_DRAM_RAS_N,
PO_DRAM_CKE		=> PO_DRAM_CKE,
PO_DRAM_CLK		=> PO_DRAM_CLK,
PO_DRAM_WE_N	=> PO_DRAM_WE_N,
PO_DRAM_CS_N 	=> PO_DRAM_CS_N,
PIO_DRAM_DQ  	=> PIO_DRAM_DQ,

PI_USER_CLK => PiLC_CLK,  
PI_DRAM_CLK => SDRAM_CLK,
PI_RESET   	=> PI_RESET, 
PI_ACK      => PI_ACK,  
PI_CMD_RDY  => PI_CMD_RDY,  
PI_WR       => PI_WR,  
PI_ADDR_IN	=> PI_ADDR_IN,
PI_DATA_IN  => PI_DATA_IN,
PI_DATA_RDY => PI_DATA_RDY,   
PO_ADDR_OUT => PO_ADDR_OUT, 
PO_DATA_OUT => PO_DATA_OUT,      
PO_DATA_RDY => PO_DATA_RDY,   
PO_DRAM_WR_BUSY=>PO_DRAM_WR_BUSY,
PO_DRAM_RD_BUSY =>PO_DRAM_RD_BUSY); 
end Verhalten; 