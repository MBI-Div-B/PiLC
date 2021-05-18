--Firma: DESY Hamburg
--Autor: Tobias Spitzbart-Silberer
--Projekt:	 PiLC-IO-Output config
--Erstellt am: 05.01.2021
--Kurzbeschreibung: Setzt den FPGA IO auf Output
--(c) Copyright 2021 DESY



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Output_Unit is
    Port ( Output: out std_logic
			  );
end Output_Unit ;

architecture Behavioral of Output_Unit is
				
begin 									
	Output <= '1';
end Behavioral;