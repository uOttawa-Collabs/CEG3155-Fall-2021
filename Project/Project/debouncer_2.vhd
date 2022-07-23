--------------------------------------------------------------------------------
-- Title         : Switch Debouncer Circuit - 2nd realisation
-- Project       : VHDL Example Programs
-------------------------------------------------------------------------------
-- File          : debouncer_2.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2004/10/07
-- Last modified : 2007/09/26
-------------------------------------------------------------------------------
-- Description : This file creates a debouncer circuit using a RTL approach.
--		 		 The code is written in structural VHDL.
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

ENTITY debouncer_2 IS
	PORT(
		i_resetBar		: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_raw			: IN	STD_LOGIC;
		o_clean			: OUT	STD_LOGIC);
END debouncer_2;

ARCHITECTURE rtl OF debouncer_2 IS
	SIGNAL con_vcc : STD_LOGIC;
	SIGNAL int_notQ1Output, int_q1Output, int_notD1Input, int_d1Input :STD_LOGIC;
	SIGNAL int_q2Output, int_notQ2Output, int_d2Input, int_debouncedRaw, int_feedback : STD_LOGIC;

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;
BEGIN
	con_vcc <= '1';
first: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_notD1Input, 
			  i_enable => con_vcc,
			  i_clock => i_clock,
			  o_q => int_q1Output,
	          o_qBar => int_notQ1Output);

second: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d2Input, 
			  i_enable => con_vcc,
			  i_clock => i_clock,
			  o_q => int_q2Output,
	          o_qBar => int_notQ2Output);

	-- Internal concurrent signal assignment
	int_notD1Input <= not(int_d1Input);
	int_d1Input <= i_raw nand int_feedback;
	int_feedback <= int_q2Output or int_debouncedRaw;
	int_d2Input <= int_notQ1Output and int_notQ2Output and i_raw;
	int_debouncedRaw <= int_q2Output nor int_notQ1Output;

	--  Output Concurrent Signal Assignment
	o_clean <= int_debouncedRaw;

END rtl;
