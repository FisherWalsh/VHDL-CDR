library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_rotator is

	port(
		clk : in std_logic;
		rst : in std_logic;
		p_in : in std_logic_vector(7 downto 0);
		inc : in std_logic;
		dec : in std_logic;
		clk_early : out std_logic;
		clk_edge : out std_logic;
		clk_late : out std_logic
	);

end phase_rotator;

architecture behaviour of phase_rotator is

	signal counter : unsigned(2 downto 0);
	signal phase_early : std_logic_vector(7 downto 0);
	signal phase_edge : std_logic_vector(7 downto 0);
	signal phase_late : std_logic_vector(7 downto 0);

	begin
		-- splices the input phase into 3, with a 90 degree offset from one another
		phase_early <= p_in;
		phase_edge <= p_in(1 downto 0) & p_in(7 downto 2);
		phase_late <= p_in(3 downto 0) & p_in(7 downto 4);

		-- since an unsigned is used, it needs to be cast
		clk_early <= phase_early(to_integer(counter));
		clk_edge <= phase_edge(to_integer(counter));
		clk_late <= phase_late(to_integer(counter));
--
		process (clk, rst) begin

			if (rst = '0') then

				counter <= (others => '0');

			-- increment or decrement counter
			elsif rising_edge(clk) then

				if (inc = '1') then

					counter <= counter + 1;

				elsif (dec = '1') then

					counter <= counter - 1;

				end if;

			end if;

		end process;

end behaviour;
