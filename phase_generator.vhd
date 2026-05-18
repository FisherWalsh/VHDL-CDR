library ieee;
use ieee.std_logic_1164.all;

entity phase_generator is
	port(
		clk : in std_logic;
		rst : in std_logic;
		p_out : out std_logic_vector(7 downto 0)
	);

end phase_generator;

architecture behaviour of phase_generator is

	signal ring_counter : std_logic_vector(7 downto 0);

	begin

		p_out <= ring_counter;

		-- updates ring counter, which essentially loops a bit through an array like a semaphore
		-- reset state is a 1 in LSB to add that bit

		process (clk, rst) begin

			if (rst = '0') then

				ring_counter <= "00000001";

			elsif rising_edge(clk) then

				ring_counter <= ring_counter(6 downto 0) & ring_counter(7);

			end if;

		end process;

end behaviour;
