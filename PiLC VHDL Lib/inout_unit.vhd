--Firma: DESY Hamburg
--Autor: Tobias Spitzbart-Silberer
--Projekt:	 PiLC-IO-config
--Erstellt am: 05.01.2021
--Kurzbeschreibung: Umschaltung zwischen Input und Output
--(c) Copyright 2021 DESY

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY InOut_Unit IS 
	PORT
	(
		Input :  IN  STD_LOGIC;
		Int :  INOUT  STD_LOGIC;
		Ex :  INOUT  STD_LOGIC;
		Status :  OUT  STD_LOGIC
	);
END InOut_Unit;

ARCHITECTURE Verhalten OF InOut_Unit IS 
BEGIN 
PROCESS(Ex,Int,Input)
BEGIN
if (Input = '1') THEN
	Ex <= Int;
	Int <= 'Z';
ELSE
	Ex <= 'Z';
	Int <= Ex;
END IF;
END PROCESS;
Status <= Ex;
END Verhalten;