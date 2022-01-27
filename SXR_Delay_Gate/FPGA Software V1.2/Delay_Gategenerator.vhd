--Firma: DESY Hamburg
--Autor: Tobias Spitzbart-Silberer
--Projekt:	 PiLC-Gategenerator
--Erstellt am: 03.03.2021
--Kurzbeschreibung: 
-- Der Gategenerator, kann getriggert oder im Free run mode gestartet werden.
-- IO 1: Gate trigger
-- IO 2: Gate Signal
-- (0x01) Control: 0= Reset, 1=Trigger Mode, 2= Free run mode
-- (0x03) Gate_Time: Zeit in us wie lange das Gate High sein soll, darf nicht 0 sein! Bei Free run ist das Low Signal nur ca. 10ns kurz.
-- (0x05) Gate_quantity: Wie oft das Gate erzeugt werden soll, darf nicht 0 sein!
-- (0x06) Gate_remain: Wie viele "Gates" noch erzeugt werden müssen

-- Bevor der Gategenerator gestartet werden kann, muss Gate_Time und Gate_quantity gesetz sein.
-- Wenn die Anzahl der Gates erzeugt wurden, muss mit Control=0, das System zurückgesetzt werden.
-- Die VFC Werte können nur verarbeitet werden wenn ADC-Karten verbaut sind.

--(c) Copyright 2021 DESY


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Delay_Gategenerator is 
	port ( 	
				CLK		: in std_logic;
				Trigger	: in std_logic;
				Gate		: out std_logic;
				VFC_1		: in std_logic;
				VFC_2		: in std_logic;
				VFC_3		: in std_logic;

				Control			: in STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
				Gate_Time		: in STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
				Gate_quantity	: in STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
				Gate_Delay		: in STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
				VFC_1_Data		: out STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
				VFC_2_Data		: out STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
				VFC_3_Data		: out STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
				Gate_remain		: out STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000"
				);
	end Delay_Gategenerator;
	
architecture Verhalten of Delay_Gategenerator is

type Gate_Steps is (
		Wait_For_Start,
		Wait_For_Trigger,
		Wait_For_Gate_Delay,
		Wait_For_Time,
		Wait_For_Reset
		);

signal Gate_State: Gate_Steps;

signal Trigger_Gate_Start	: bit;
signal Freerun_Gate_Start	: bit;
signal Time1					: integer:= 0;
signal Quantity				: integer:= 0;
signal Delay					: integer:= 0;

signal Trigger_sr 			: std_logic_vector(1 downto 0);

signal Counter_1_sr     	: std_logic_vector(1 downto 0);
signal Counter_1_Value_int : integer := 0;

signal Counter_2_sr     	: std_logic_vector(1 downto 0);
signal Counter_2_Value_int : integer := 0;

signal Counter_3_sr     	: std_logic_vector(1 downto 0);
signal Counter_3_Value_int : integer := 0;


begin	
  process(CLK)
  begin		
    if	(CLK'event and CLK='1') then
-----------------------------------------------	
-- Control_Register auswertung
-----------------------------------------------	

      case Control (7 downto 0) is	
-----------------------------------------------	
		  when x"00" => Trigger_Gate_Start	<= '0';
							 Freerun_Gate_Start	<= '0';
							 Gate_State				<= Wait_For_Start;
							 Counter_1_Value_int	<= 0;
							 Counter_2_Value_int	<= 0;
							 Counter_3_Value_int	<= 0;
							 Quantity				<= 0;
							 Gate						<= '0';
							 Delay					<= 0;
-----------------------------------------------	
		  when x"01" => Freerun_Gate_Start	<= '1';  -- ehemals "Trigger_Gate_Start"
-----------------------------------------------
		  when x"02" => Trigger_Gate_Start	<= '1';	-- ehemals "Freerun_Gate_Start"
-----------------------------------------------		
-- Nachfolgende Bits hinzugefuegt wegen Muxer zur Auswahl der Kameras (siehe Verdrahtunsplan)		  
-----------------------------------------------		
		  when x"03" => Trigger_Gate_Start	<= '1';	
-----------------------------------------------		
		  when x"04" => Trigger_Gate_Start	<= '1';	
-----------------------------------------------		
		  when others =>	

    end case;


-----------------------------------------------
-----------------------------------------------
--Trigger einsync.!
-----------------------------------------------
    Trigger_sr  		<= Trigger_sr (0) & Trigger; 


    case Gate_State is	
		when Wait_For_Start => 	if Trigger_Gate_Start='1' or Freerun_Gate_Start='1'  then
											Quantity		<=	to_integer((unsigned(Gate_quantity)));		
											Gate_State	<= Wait_For_Trigger;
										end if;
										
										
		when Wait_For_Trigger =>if Trigger_sr ="01" or Freerun_Gate_Start='1'  then
											Time1<=to_integer((unsigned(Gate_Time))) * 150;	
											Delay<=to_integer((unsigned(Gate_Delay))) * 150;	
											Gate_State<=Wait_For_Gate_Delay;
											Gate <='0'; -- vorher '1'
										end if;
										
			
		when Wait_For_Gate_Delay => if Delay = 0 then
												Gate_State <= Wait_For_Time;
												Gate <='1';
											 else
												Delay<=Delay-1;
											 end if;
	
										
		when Wait_For_Time =>	if Time1 = 0 then
											Gate <= '0';
											Quantity<=Quantity-1;
											if Quantity = 1 then
												Gate_State<= Wait_For_Reset;
											else
												Gate_State<= Wait_For_Trigger;
											end if;
										else
											Time1<=Time1-1;
											
											Counter_1_sr <= Counter_1_sr(0) & VFC_1;
											if (Counter_1_sr="01") then 
												Counter_1_Value_int<=Counter_1_Value_int+1;
											end if; 
											-----------------------------------------------	
											Counter_2_sr <= Counter_2_sr(0) & VFC_2;
											if (Counter_2_sr="01") then 
												Counter_2_Value_int<=Counter_2_Value_int+1;
											end if; 
											-----------------------------------------------	
											Counter_3_sr <= Counter_3_sr(0) & VFC_3;
											if (Counter_3_sr="01") then 
												Counter_3_Value_int<=Counter_3_Value_int+1;
											end if; 
											
										end if;
										
		when Wait_For_Reset =>	if Trigger_Gate_Start='0' and Freerun_Gate_Start='0' then
											Gate_State<=Wait_For_Start;
										end if;
	end case;

end if;
end process;
VFC_1_Data<=std_logic_vector(to_unsigned(Counter_1_Value_int,32));
VFC_2_Data<=std_logic_vector(to_unsigned(Counter_2_Value_int,32));
VFC_3_Data<=std_logic_vector(to_unsigned(Counter_3_Value_int,32));
Gate_remain<=std_logic_vector(to_unsigned(Quantity,32));
end Verhalten; 