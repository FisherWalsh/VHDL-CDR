library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity error_counter is
	port (
		clk : in std_logic;
		rst : in std_logic;
		inc : in std_logic;
		disp_0 : out std_logic_vector(6 downto 0);
		disp_1 : out std_logic_vector(6 downto 0);
		disp_2 : out std_logic_vector(6 downto 0);
		disp_3 : out std_logic_vector(6 downto 0)
	);
end error_counter;

architecture behaviour of error_counter is

	-- unsigned is used to make use of easy addition and subtraction
	signal counter : unsigned(15 downto 0);

	component SevenSegDecoder
		PORT(
			in_4bit : IN std_logic_vector(3 downto 0);
			out_HEX : OUT std_logic_vector(6 downto 0)
		);
	end component;

	begin

		process (clk, rst) begin

			if (rst = '0') then

				counter <= (others => '0');

			elsif rising_edge(clk) then

				-- increments counter if error is detected
				if (inc = '1') then

					counter <= counter + 1;

				end if;

			end if;

		end process;

		-- declares 7 seg displays
		hex_0 : SevenSegDecoder port map(
			in_4bit => std_logic_vector(counter(15 downto 12)),
			out_HEX => disp_0
		);

		hex_1 : SevenSegDecoder port map(
			in_4bit => std_logic_vector(counter(11 downto 8)),
			out_HEX => disp_1
		);

		hex_2 : SevenSegDecoder port map(
			in_4bit => std_logic_vector(counter(7 downto 4)),
			out_HEX => disp_2
		);

		hex_3 : SevenSegDecoder port map(
			in_4bit => std_logic_vector(counter(3 downto 0)),
			out_HEX => disp_3
		);

end behaviour;
