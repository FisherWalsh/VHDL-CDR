library ieee;
use ieee.std_logic_1164.all;

entity CDR is
	port (
		clk_ref : in std_logic;
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
end CDR;

architecture behaviour of CDR is

	-- internal wires
	signal p : std_logic_vector(7 downto 0);
	signal clk_early_internal : std_logic;
	signal clk_edge_internal : std_logic;
	signal clk_late_internal : std_logic;
	signal up_internal : std_logic;
	signal down_internal : std_logic;
	signal out_p : std_logic;
	signal out_n : std_logic;
	signal clk_div : std_logic;

	-- registers
	signal clk_rcv_reg : std_logic;
	signal clk_late_reg : std_logic;
	signal clk_div_reg : std_logic;
	signal d_out_reg : std_logic;

	component phase_generator
		port(
			clk : in std_logic;
			rst : in std_logic;
			p_out : out std_logic_vector(7 downto 0)
		);
	end component;

	component phase_rotator
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
	end component;

	component BBPD
		port(
			d_in : in std_logic;
			clk_early : in std_logic;
			clk_edge : in std_logic;
			clk_late : in std_logic;
			up : out std_logic;
			down : out std_logic
		);
	end component;

	component digital_filter
		port(
			in_p : in std_logic;
			in_n : in std_logic;
			clk : in std_logic;
			rst : in std_logic;
			out_p : out std_logic;
			out_n : out std_logic
		);
	end component;

	component clk_divider
		port(
			rst : in std_logic;
			clk_in : in std_logic;
			clk_out : out std_logic
		);
	end component;

	begin

		-- maps internal signals to outputs
		clk_rcv <= clk_rcv_reg;
		up <= up_internal;
		down <= down_internal;
		clk_early <= clk_early_internal;
		clk_edge <= clk_edge_internal;
		clk_late <= clk_late_internal;
		d_out <= d_out_reg;

		u_phase_generator : phase_generator port map (
			clk => clk_ref,
			rst => rst,
			p_out => p
		);

		u_phase_rotator : phase_rotator port map (
			clk => clk_div_reg,
			rst => rst,
			p_in => p,
			inc => out_n,
			dec => out_p,
			clk_early => clk_early_internal,
			clk_edge => clk_edge_internal,
			clk_late => clk_late_internal
		);

		u_phase_detector : BBPD port map (
			d_in => d_in,
			clk_early => clk_early_internal,
			clk_edge => clk_edge_internal,
			clk_late => clk_late_internal,
			up => up_internal,
			down => down_internal
		);

		u_digital_filter : digital_filter port map(
			in_p => up_internal,
			in_n => down_internal,
			clk => clk_late_reg,
			rst => rst,
			out_p => out_p,
			out_n => out_n
		);

		u_clk_divider : clk_divider port map (
			rst => rst,
			clk_in => not clk_late_reg,
			clk_out => clk_div
		);

		-- Retimes the recovered clocks to the reference clock
		-- Ensures predictable behaviour and timing
		process (clk_ref, rst) begin

			if (rst = '0') then

				clk_div_reg <= '0';
				clk_late_reg <= '0';
				clk_rcv_reg <= '0';

			elsif rising_edge(clk_ref) then

				clk_div_reg <= clk_div;
				clk_late_reg <= clk_late_internal;
				clk_rcv_reg <= clk_late_reg;

			end if;

		end process;

		-- Samples input data on the recovered clock edge which
		-- should ideally be perfectly aligned with the data
		process (clk_rcv_reg, rst) begin

			if (rst = '0') then

				d_out_reg <= '0';

			elsif rising_edge(clk_rcv_reg) then

				d_out_reg <= d_in;

			end if;

		end process;

end behaviour;
