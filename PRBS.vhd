library ieee;
use ieee.std_logic_1164.all;

entity PRBS is
	port(
		clk : in std_logic;
		rst : in std_logic;
		s_out : out std_logic;
		p_out : out std_logic_vector(9 downto 0)
	);
end PRBS;

architecture behaviour of PRBS is

	signal shift_reg : std_logic_vector(9 downto 0);
	signal xor_z : std_logic;

	begin

		s_out <= shift_reg(9);
		-- compares the data
		xor_z <= shift_reg(6) xor shift_reg(9);
		p_out <= shift_reg;

		process (clk, rst) begin

			-- reset state set to all ones to aid in aligning resets
			-- (practically just means it can be aligned faster)
			if (rst = '0') then

				shift_reg <= "1111111111";


			-- shifts in the new data
			elsif rising_edge(clk) then

				shift_reg <= shift_reg(8 downto 0) & xor_z;

			end if;

		end process;

end behaviour;
