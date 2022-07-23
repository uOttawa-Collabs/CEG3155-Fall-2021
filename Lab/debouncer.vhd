--------------------------------------------------------------------------------
-- Title         : Switch Debouncer Circuit - 1st realisation
-- Project       : VHDL Example Programs
-------------------------------------------------------------------------------
-- File          : debouncer.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2004/10/07
-- Last modified : 2007/09/26
-------------------------------------------------------------------------------
-- Description : This file creates a debouncer circuit using a FSM approach.
--		 		 The code is ported from Professor Eduardo Casas from the University
--				 of British Columbia (UBC).
-------------------------------------------------------------------------------
-- Modification history :
-- 2004.10.07 	R. Abielmona		Creation
-- 2007.09.26 	R. Abielmona		Modified copyright notice
-------------------------------------------------------------------------------
-- This file is copyright material of Rami Abielmona, Ph.D., P.Eng., Chief Research
-- Scientist at Larus Technologies.  Permission to make digital or hard copies of part
-- or all of this work for personal or classroom use is granted without fee
-- provided that copies are not made or distributed for profit or commercial
-- advantage and that copies bear this notice and the full citation of this work.
-- Prior permission is required to copy, republish, redistribute or post this work.
-- This notice is adapted from the ACM copyright notice.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY debouncer IS
	PORT(
		i_raw			: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_clean			: OUT	STD_LOGIC);
END debouncer;

ARCHITECTURE fsm OF debouncer IS
	SIGNAL int_currentState, int_nextState : std_logic_vector (1 downto 0);

BEGIN

	-- Combinational logic for next state
	int_nextState <= "00" when i_raw = '0' else
					 "01" when int_currentState = "00" else
					 "10";

	-- Sequential logic
	process(i_clock) begin
		if i_clock'event and i_clock = '1' then
			int_currentState <= int_nextState;
		end if;
	end process;

	--  Concurrent Signal Assignment
	o_clean <= '1' when int_currentState = "10" else 
			   '0';

END fsm;
