--Firma: DESY Hamburg
--Autor: Tobias Spitzbart-Silberer
--Projekt:	 PiLC-DAC-Karte
--Erstellt am: 05.01.2021
--Kurzbeschreibung: Kommunikation zwischen FPGA und DAC Karte
--(c) Copyright 2021 DESY

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity DAC_Karte is 	
				--generic(	
				--Data_Test: STD_LOGIC_VECTOR (15 downto 0) := x"FFFF");
	port ( 	
				CLK: in std_logic;
				DAC: out std_logic;
				Data: in  STD_LOGIC_VECTOR (31 downto 0)				
			);
	end DAC_Karte;
	
architecture Verhalten of DAC_Karte is
signal Data_In: STD_LOGIC_VECTOR (15 downto 0) := x"FFFF";
signal Data_TX: unsigned(17 downto 0):= b"111111111111111111";
signal start     : std_logic := '0'; 
signal clk_div     	: integer := 0; 
signal Data_counter: unsigned(15 downto 0) := x"0000"; 
signal parity_ready: std_logic := '0';
signal parity_out : std_logic := '0';
signal parity_calc : std_logic := '0';
begin	
process(CLK)
variable pbit : std_logic := '0';
begin
if	(CLK'event and CLK='1') then

clk_div<=clk_div+1;

if clk_div=5 then
clk_div<=0;

if (Data_In/=Data(15 downto 0)) and (start = '0')then
	Data_In<=Data(15 downto 0);
	parity_calc<='1';
	end if;


if parity_calc='1' then
	parity_calc<='0';
	pbit := '0';
	for i in 0 to 15 loop
		pbit := pbit xor Data_In(i);
		end loop;
	parity_ready<= '1';
end if;


if (parity_ready = '1')then
	parity_out<=pbit;
	parity_ready<= '0';
	start<= '1';
end if;

if (start = '1') then                      											-- fallende Flanke Startbit erkannt
	Data_TX <= unsigned(Data_In(15 downto 0)) & parity_out & '0';            -- MSB zuerst: Stopbit,Pa, 8 Datenbits, Startbit
	Data_counter<=Data_counter+128;
	start<= '0';
else
	Data_TX <= '1' & Data_TX(17 downto 1);         -- MSB zuerst --> nach rechts schieben
end if;

end if;
end if;	
end process;
DAC <= Data_TX(0);	
----------------------------------------



end Verhalten; 