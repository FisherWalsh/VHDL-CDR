library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_divider is

	port(
		rst : in std_logic;
		clk_in : in std_logic;
		clk_out : out std_logic
	);

end clk_divider;

architecture behaviour of clk_divider is

	signal counter : unsigned(1 downto 0);

	begin
		-- check the second bit of the counter, which should change at
		-- 1/4 the speed of the clock driving it.
		clk_out <= counter(1);

		process (clk_in, rst) begin

			if (rst = '0') then

				counter <= (others => '0');

			elsif rising_edge(clk_in) then

				counter <= counter + 1;

			end if;

		end process;

end behaviour;
