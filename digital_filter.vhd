library ieee;
use ieee.std_logic_1164.all;

entity digital_filter is

	port(
		in_p : in std_logic;
		in_n : in std_logic;
		clk : in std_logic;
		rst : in std_logic;
		out_p : out std_logic;
		out_n : out std_logic
	);

end digital_filter;

architecture behaviour of digital_filter is

	signal shift_p : std_logic_vector(3 downto 0);
	signal shift_n : std_logic_vector(3 downto 0);
	signal p_en : std_logic;
	signal n_en : std_logic;

	begin

		-- creates the 4 inout or gates
		p_en <= shift_p(0) or shift_p(1) or shift_p(2) or shift_p(3);
		n_en <= shift_n(0) or shift_n(1) or shift_n(2) or shift_n(3);

		-- creates the nands whos inputs are the 4 input or gates
		out_p <= p_en and (not n_en);
		out_n <= n_en and (not p_en);

		process(clk, rst) begin

			if (rst = '0') then

				shift_p <= (others => '0');
				shift_n <= (others => '0');

			-- defines two simple shift registers
			elsif rising_edge(clk) then

				shift_p <= in_p & shift_p(3 downto 1);
				shift_n <= in_n & shift_n(3 downto 1);

			end if;

		end process;


end architecture;
