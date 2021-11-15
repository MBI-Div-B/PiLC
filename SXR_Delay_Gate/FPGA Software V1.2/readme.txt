Physische I/O
---------------
I/O 1: Input, Trigger
I/O 2: Output, Gate 1
I/O 3: Input, Camera 1
I/O 4: Output, Gate 2
I/O 3: Input, Camera 2


IO Register
------------

Register fuer Gate 1 (Tobias I/O)
0x01	=> Control
0x02	=> n.c.	
0x03	=> Gate_Time_1
0x04	=> n.c.	
0x05	=> Gate_quantity
0x06	=> Gate_remain
0x07	=> Gate_Delay_1	


virtuelles Register für Keithley
---------------------------------
0x09	=> Gate_Time_2
0x0B	=> Gate_Delay_2

Funktion Controllregister
----------------------------
0 - Stop
1 - Freerunning
2 - Triggered only Laser (Input 1)
3 - Triggered Laser & CCD (Input 1 & Input 3) 
4 - Triggered Laser & CCD (Input 1 & Input 5) 

Frei
-----
0x08	IO_4_Data_Out_Register	x	0	32Bit
# 0x09	IO_5_Data_In_Register	x	x	32Bit
0x0A	IO_5_Data_Out_Register	x	0	32Bit
# 0x0B	IO_6_Data_In_Register	x	x	32Bit
0x0C	IO_6_Data_Out_Register	x	0	32Bit
0x0D	IO_7_Data_In_Register	x	x	32Bit
0x0E	IO_7_Data_Out_Register	x	0	32Bit
0x0F	IO_8_Data_In_Register	x	x	32Bit
0x10	IO_8_Data_Out_Register	x	0	32Bit
0x11	IO_9_Data_In_Register	x	x	32Bit
0x12	IO_9_Data_Out_Register	x	0	32Bit
0x13	IO_10_Data_In_Register	x	x	32Bit
0x14	IO_10_Data_Out_Register	x	0	32Bit
0x15	IO_11_Data_In_Register	x	x	32Bit
0x16	IO_11_Data_Out_Register	x	0	32Bit
0x17	IO_12_Data_In_Register	x	x	32Bit
0x18	IO_12_Data_Out_Register	x	0	32Bit
0x19	IO_13_Data_In_Register	x	x	32Bit
0x1A	IO_13_Data_Out_Register	x	0	32Bit
0x1B	IO_14_Data_In_Register	x	x	32Bit
0x1C	IO_14_Data_Out_Register	x	0	32Bit
0x1D	IO_15_Data_In_Register	x	x	32Bit
0x1E	IO_15_Data_Out_Register	x	0	32Bit
0x1F	IO_16_Data_In_Register	x	x	32Bit
0x20	IO_16_Data_Out_Register	x	0	32Bit
