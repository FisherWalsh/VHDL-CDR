library ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity frame_recovery is
	port (
		clk : in std_logic;
		rst : in std_logic;
		d_in : in std_logic;
		rst_rx : out std_logic;
		d_out : out std_logic
	);
end frame_recovery;

architecture behaviour of frame_recovery is

	signal shift_reg : std_logic_vector(9 downto 0);
	signal rst_rx_reg : std_logic_vector(9 downto 0);

	begin

		d_out <= shift_reg(9);
		-- check if all bits are the same
		rst_rx <= and_reduce(rst_rx_reg);

		process (clk, rst) begin

			if (rst = '0') then

				shift_reg <= (others => '0');
				rst_rx_reg <= (others => '0');

			-- update registers
			elsif rising_edge(clk) then

				shift_reg <= d_in & shift_reg(9 downto 1);
				rst_rx_reg <= shift_reg; -- changed to register, latch didn't work

			end if;

		end process;

end behaviour;
