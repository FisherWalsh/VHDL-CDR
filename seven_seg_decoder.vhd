LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY seven_seg_decoder IS
	PORT(	in_4bit : IN std_logic_vector(3 downto 0);
			out_HEX : OUT std_logic_vector(6 downto 0));
END seven_seg_decoder;

ARCHITECTURE behaviour of seven_seg_decoder IS
BEGIN
	PROCESS (in_4bit)
	BEGIN
		CASE in_4bit IS
			when "0000" => out_HEX <= "1000000";
			when "0001" => out_HEX <= "1111001";
			when "0010" => out_HEX <= "0100100";
			when "0011" => out_HEX <= "0110000";
			when "0100" => out_HEX <= "0011001";
			when "0101" => out_HEX <= "0010010";
			when "0110" => out_HEX <= "0000010";
			when "0111" => out_HEX <= "1111000";
			when "1000" => out_HEX <= "0000000";
			when "1001" => out_HEX <= "0010000";
			when "1010" => out_HEX <= "0001000";
			when "1011" => out_HEX <= "0000011";
			when "1100" => out_HEX <= "1000110";
			when "1101" => out_HEX <= "0100001";
			when "1110" => out_HEX <= "0000110";
			when "1111" => out_HEX <= "0001110";
			when others => out_HEX <= "0000000";
		END CASE;
	END PROCESS;
END behaviour;
