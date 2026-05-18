library ieee;
use ieee.std_logic_1164.all;

entity BBPD is

	port(
		d_in : in std_logic;
		clk_early : in std_logic;
		clk_edge : in std_logic;
		clk_late : in std_logic;
		up : out std_logic;
		down : out std_logic
	);

end BBPD;

architecture behaviour of BBPD is

	signal early_reg : std_logic;
	signal edge_reg : std_logic;
	signal late_reg : std_logic;

	signal up_xor : std_logic;
	signal down_xor : std_logic;

	begin

		-- combinational xor logic
		up_xor <= early_reg xor edge_reg;
		down_xor <= edge_reg xor late_reg;

		-- check for changes in all clock signals and updates their respective registers
		process (clk_early, clk_edge, clk_late) begin

			if rising_edge(clk_early) then

				early_reg <= d_in;

			end if;

			if rising_edge(clk_edge) then

				edge_reg <= d_in;

			end if;

			if rising_edge(clk_late) then

				late_reg <= d_in;

			end if;


			if falling_edge(clk_late) then

				up <= up_xor;
				down <= down_xor;

			end if;

		end process;


end architecture;
