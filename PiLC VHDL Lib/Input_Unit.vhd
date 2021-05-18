--Firma: DESY Hamburg
--Autor: Tobias Spitzbart-Silberer
--Projekt:	 PiLC-IO-Input config
--Erstellt am: 05.01.2021
--Kurzbeschreibung: Setzt den FPGA IO auf Input
--(c) Copyright 2021 DESY
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Input_Unit is
    Port ( Input: out std_logic
			  );
end Input_Unit ;

architecture Behavioral of Input_Unit is
				
begin 									
	Input <= '0';
end Behavioral;