--------------------------------------------------------------------------------
-- Title         : BCD 7-segment Decoder
-- Project       : VHDL Example Programs
-------------------------------------------------------------------------------
-- File          : bcd_7seg.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2004/10/17
-- Last modified : 2007/09/26
-------------------------------------------------------------------------------
-- Description : This file creates a BCD 7-segment decoder from 4-bit inputs.
--		 The code is written in structural VHDL.
-------------------------------------------------------------------------------
-- Modification history :
-- 2004.10.17 	R. Abielmona		Creation
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
library ieee;
use  ieee.std_logic_1164.all;

ENTITY dec_7seg IS
	PORT(i_hexDigit	: IN STD_LOGIC_VECTOR(3 downto 0);
	     o_segment_a, o_segment_b, o_segment_c, o_segment_d, o_segment_e, 
	     o_segment_f, o_segment_g : OUT STD_LOGIC);
END dec_7seg;

ARCHITECTURE rtl OF dec_7seg IS
	SIGNAL int_segment_data : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
	PROCESS  (Hex_digit)
	BEGIN
		CASE i_hexDigit IS
		        WHEN "0000" =>
		            int_segment_data <= "1111110";
		        WHEN "0001" =>
		            int_segment_data <= "0110000";
		        WHEN "0010" =>
		            int_segment_data <= "1101101";
		        WHEN "0011" =>
		            int_segment_data <= "1111001";
		        WHEN "0100" =>
		            int_segment_data <= "0110011";
		        WHEN "0101" =>
		            int_segment_data <= "1011011";
		        WHEN "0110" =>
		            int_segment_data <= "1011111";
		        WHEN "0111" =>
		            int_segment_data <= "1110000";
		        WHEN "1000" =>
		            int_segment_data <= "1111111";
		        WHEN "1001" =>
		            int_segment_data <= "1111011"; 
		        WHEN "1010" =>
		            int_segment_data <= "1110111";
		        WHEN "1011" =>
		            int_segment_data <= "0011111"; 
		        WHEN "1100" =>
		            int_segment_data <= "1001110"; 
		        WHEN "1101" =>
		            int_segment_data <= "0111101"; 
		        WHEN "1110" =>
		            int_segment_data <= "1001111"; 
		        WHEN "1111" =>
		            int_segment_data <= "1000111"; 
			WHEN OTHERS =>
		            int_segment_data <= "0111110";
		END CASE;
	END PROCESS;

-- LED driver is inverted
o_segment_a <= NOT int_segment_data(6);
o_segment_b <= NOT int_segment_data(5);
o_segment_c <= NOT int_segment_data(4);
o_segment_d <= NOT int_segment_data(3);
o_segment_e <= NOT int_segment_data(2);
o_segment_f <= NOT int_segment_data(1);
o_segment_g <= NOT int_segment_data(0);

END rtl;

