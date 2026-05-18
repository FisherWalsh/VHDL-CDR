library ieee;
use ieee.std_logic_1164.all;

entity SERDES is
	port(
		-- inputs
		clk_tx : in std_logic;
		clk_ref : in std_logic;
		rst : in std_logic;
		rst_tx : in std_logic;

		-- outputs
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
		data_aligned_test : out std_logic;
		data_rx_test : out std_logic;
		frame_recovered : out std_logic
	);
end SERDES;

architecture behaviour of SERDES is

	-- Transmitter PRBS

	signal data_tx : std_logic;

	-- Reciever PRBS

	signal rst_rx : std_logic;
	signal data_rx : std_logic;

	-- CDR

	signal clk_recovered : std_logic;
	signal data_recovered : std_logic;

	-- Frame Recovery

	signal data_aligned : std_logic;

	-- Error Counter

	signal error : std_logic;

	-- Delay register

	signal data_rx_reg : std_logic;

	component PRBS is
		port(
			clk : in std_logic;
			rst : in std_logic;
			s_out : out std_logic;
			p_out : out std_logic_vector(9 downto 0)
		);
	end component;

	component CDR is
		port (
			clK_ref : in std_logic;
			d_in : in std_logic;
			rst : in std_logic;
			clk_rcv : out std_logic;
			d_out : out std_logic;
			up : out std_logic;
			down : out std_logic;
			clk_early : out std_logic;
			clk_edge : out std_logic;
			clk_late : out std_logic
		);
	end component;

	component frame_recovery is
		port (
			clk : in std_logic;
			rst : in std_logic;
			d_in : in std_logic;
			rst_rx : out std_logic;
			d_out : out std_logic
		);
	end component;

	component error_counter is
		port(
			clk : in std_logic;
			rst : in std_logic;
			inc : in std_logic;
			disp_0 : out std_logic_vector(6 downto 0);
			disp_1 : out std_logic_vector(6 downto 0);
			disp_2 : out std_logic_vector(6 downto 0);
			disp_3 : out std_logic_vector(6 downto 0)
		);
	end component;

	begin

		-- internal signals to outputs

		d_in <= data_tx;
		d_out <= data_recovered;
		clk <= clk_recovered;

		-- logic

		error <= data_rx_reg xor data_aligned;

		-- test interface

		error_test <= error;
		data_aligned_test <= data_aligned;
		data_rx_test <= data_rx_reg;
		frame_recovered <= rst_rx;

		-- register delay
		-- this was found to be required to align the data
		process (clk_recovered, rst) begin
			if (rst = '0') then

				data_rx_reg <= '0';

			elsif rising_edge(clk_recovered) then

				data_rx_reg <= data_rx;

			end if;
		end process;

		PRBS_tx_u : PRBS port map(
			clk => clk_tx,
			rst => rst_tx,
			s_out => data_tx
		);

		PRBS_rx_u : PRBS port map(
			clk => clk_recovered,
			rst => not rst_rx, -- needs to be inverted since reset is active low
			s_out => data_rx
		);

		CDR_u : CDR port map(
			clk_ref => clk_ref,
			d_in => data_tx,
			rst => rst, -- inverted in block diagram but that doesn't make sense to me
			clk_rcv => clk_recovered,
			d_out => data_recovered
		);

		-- checks if PRBS has gone through one full cycle to align data
		frame_recovery_u : frame_recovery port map(
			clk => clk_recovered,
			rst => rst,
			d_in => data_recovered,
			rst_rx => rst_rx,
			d_out => data_aligned
		);

		-- counts errors and displays them on the 7 seg displays
		error_counter_u : error_counter port map(
			clk => clk_recovered,
			rst => rst,
			inc => error,
			disp_0 => disp_0,
			disp_1 => disp_1,
			disp_2 => disp_2,
			disp_3 => disp_3
		);

end behaviour;
