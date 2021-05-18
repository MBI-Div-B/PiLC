library IEEE;
use IEEE.STD_LOGIC_1164.all;

package PKG_SDRAM is
 
	function f_log2 (x : positive) return positive;
	function to_stdLogic(X : boolean) return std_logic;
	function max (x,y : positive) return positive;
	
end PKG_SDRAM;

package body PKG_SDRAM is

	function f_log2 (x : positive) return natural is
		variable i : natural;
	begin
		i := 1;  
		while (2**i < x) loop
			i := i + 1;
		end loop;
		return i;
	end function f_log2;
	
	function to_stdLogic(X : boolean) return std_logic is
	begin
		case X is
			when false => return '0';
			when true  => return '1';
		end case;
	end function to_stdLogic;
	
	function max (x,y : positive) return positive is
	begin
		if x>y then
			return x;
		else
			return y;
		end if;
	end function max;
	
 end package body;
 