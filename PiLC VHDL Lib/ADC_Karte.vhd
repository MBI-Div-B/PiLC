--Firma: DESY Hamburg
--Autor: Tobias Spitzbart-Silberer
--Projekt:	 PiLC-ADC-Karte
--Erstellt am: 05.01.2021
--Kurzbeschreibung: Kommunikation zwischen FPGA und ADC-Karte
--(c) Copyright 2021 DESY

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADC_Karte is 
	port ( 	
				CLK: in std_logic;
				ADC: in std_logic;
				Filter_in: in STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				Data_out: out STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
				Data_Ready: out std_logic
				);
	end ADC_Karte;
	
architecture Verhalten of ADC_Karte is

signal prescaler : unsigned(2 downto 0) := "000";            -- clk = 8*Baudrate
signal rxd_sr    : std_logic_vector (2 downto 0) := "111";  -- Flankenerkennung und Eintakten
signal start     : std_logic := '0'; 
signal rxdat     : std_logic_vector (17 downto 0) := "000000000000000000"; 
signal rxbitcnt  : integer range 0 to 18 := 17;
signal Parity_Ready : std_logic := '0';
signal RXD_fin: std_logic := '0';
signal Uart_Ready: std_logic := '0';

signal Daten_counter: integer := 0; 
signal ADC_Mittelwert: integer := 0;
signal Filter: integer := 1;
signal Filter_cnt: integer := 1;
signal ADC_dividend: STD_LOGIC_VECTOR (31 downto 0) := x"FFFFFFFF";


type Mittelwert is (
	Idle,
	Div_Go,
	Div_Done
);
signal Mittelwert_State : Mittelwert ;
begin	
process(CLK)
variable q : std_logic := '0';
begin
----------------------------------------------	
if	(CLK'event and CLK='1') then
--UART Empfangen
	prescaler <= prescaler+1;
	rxd_sr <= rxd_sr(1 downto 0) & ADC;
	if (rxd_sr = "100" and rxbitcnt=18) then   -- fallende Flanke = Startbit
         start <= '1';                           -- 1 FF nötig wegen evtl. Glitches auf Kombinatorik
      end if; 
	if (rxbitcnt<18) then                       -- Empfang läuft
		if (prescaler="101") then               -- In der Bitmitte abtasten
			 prescaler <= "000";  
			rxdat(rxbitcnt) <= rxd_sr(2);        -- Jedes Bit wird sofort nach Empfang ausgegeben --> kein Schieberegister nötig, MUX spart FFs
			rxbitcnt <= rxbitcnt+1;
		end if;	
		else                                       -- warten auf Startbit
         if (start = '1') then                   -- fallende Flanke Startbit erkannt
            prescaler <= "011";                  -- erst mal nur halbe Bitzeit abwarten
            rxbitcnt  <= 0;
            start     <= '0';
				RXD_fin<='0';
         end if;
		 end if;
		 
	if ((rxbitcnt=18) and (RXD_fin='0')) then
		q := '0';
		for i in 1 to 17 loop
			q := q xor rxdat(i);
		end loop;
		Parity_Ready<='1';
		RXD_fin<='1';
	end if;	
	
	if (Parity_Ready='1') then
		Parity_Ready<='0';
		if q='0' then
			Uart_Ready<='1';
		end if;
	end if;

----------------------------------------------		
--ADC Daten im Array speichern
----------------------------------------------		
if (Uart_Ready='1')then
		Daten_counter<=Daten_counter+1;	
		ADC_Mittelwert<=ADC_Mittelwert+to_integer(unsigned(rxdat(17 downto 2)));
		Uart_Ready<='0';
		Data_Ready<= not Data_Ready;
		end if;
----------------------------------------------			
--ADC Wert berechnen
----------------------------------------------		
	case Mittelwert_State  is	
			when Idle =>if Daten_counter=Filter then
								ADC_dividend<=std_logic_vector(to_unsigned((ADC_Mittelwert), 32));
								ADC_Mittelwert<=0;
								Daten_counter<=0;
								case Filter_in(7 downto 0) is 
										when x"01" => Filter<=1;Filter_cnt<=0;
										when x"02" => Filter<=2;Filter_cnt<=1;
										when x"03" => Filter<=4;Filter_cnt<=2;
										when x"04" => Filter<=8;Filter_cnt<=3;
										when x"05" => Filter<=16;Filter_cnt<=4;
										when x"06" => Filter<=32;Filter_cnt<=5;
										when x"07" => Filter<=64;Filter_cnt<=6;
										when x"08" => Filter<=128;Filter_cnt<=7;
										when x"09" => Filter<=256;Filter_cnt<=8;
										when x"0A" => Filter<=512;Filter_cnt<=9;
										when x"0B" => Filter<=1024;Filter_cnt<=10;
										when others => Filter<=1;Filter_cnt<=0;
									end case;
								Mittelwert_State<=Div_Go;
								end if;
			when Div_Go =>  	if Filter_cnt=0 then
										Mittelwert_State<=Div_Done;
									else
										ADC_dividend <= '0' & ADC_dividend(31 downto 1); -- Schieberegister nach rechts
										Filter_cnt<=Filter_cnt-1;
									end if;						
			when Div_Done => 	Data_out<=ADC_dividend;
									if Filter>=2 then
										ADC_Mittelwert<=to_integer(unsigned(ADC_dividend(15 downto 0)));
										Daten_counter<=1;
									end if;
									Mittelwert_State<=Idle;
			when others =>
	end case;	
end if;
end process;	
end Verhalten; 