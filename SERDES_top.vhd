library ieee;
use ieee.std_logic_1164.all;

entity SERDES_top is
	port(
--		GPIO_0 : inout std_logic_vector(3 downto 0);
		KEY : in std_logic_vector(1 downto 0);
		CLOCK_50 : in std_logic;
		HEX0 : out std_logic_vector(6 downto 0);
		HEX1 : out std_logic_vector(6 downto 0);
		HEX2 : out std_logic_vector(6 downto 0);
		HEX3 : out std_logic_vector(6 downto 0);

		-- test interface
		error_test : out std_logic;
		frame_recovered : out std_logic;
--		data_aligned_test : out std_logic;
--		data_rx_test : out std_logic

		-- sim inouts
		clk_tx : in std_logic;
		d_in : out std_logic;
		d_out : out std_logic;
		clk: out std_logic
	);
end SERDES_top;

architecture behaviour of SERDES_top is

	component SERDES is
		port(
			-- interface
			clk_tx : in std_logic;
			clk_ref : in std_logic;
			rst : in std_logic;
			rst_tx : in std_logic;

			d_in : out std_logic;
			d_out : out std_logic;
			clk : out std_logic;

			-- seven segment displays
			disp_0 : out std_logic_vector(6 downto 0);
			disp_1 : out std_logic_vector(6 downto 0);
			disp_2 : out std_logic_vector(6 downto 0);
			disp_3 : out std_logic_vector(6 downto 0);

			-- test interface
			error_test : out std_logic;
			frame_recovered : out std_logic
--			data_aligned_test : out std_logic;
--			data_rx_test : out std_logic
		);
	end component;

	begin

		SERDES_u : SERDES port map(
			-- physical io
--			clk_tx => GPIO_0(0),
--			d_in => GPIO_0(1),
--			d_out => GPIO_0(2),
--			clk => GPIO_0(3),
			-- sim io
			clk_tx => clk_tx,
			d_in => d_in,
			d_out => d_out,
			clk => clk,
			clk_ref => CLOCK_50,
			--io
			rst => KEY(0),
			rst_tx => KEY(1),
			disp_0 => HEX0,
			disp_1 => HEX1,
			disp_2 => HEX2,
			disp_3 => HEX3,
			-- test io
			error_test => error_test,
			frame_recovered => frame_recovered
--			data_aligned_test => data_aligned_test,
--			data_rx_test => data_rx_test
		);

end behaviour;
