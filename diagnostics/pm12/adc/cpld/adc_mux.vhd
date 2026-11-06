library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity adc_mux is
 port(CLK80, STR, ENA, EV : in std_logic;
      ADC0, ADC1 : in std_logic_vector(11 downto 0);
      DOUT : out std_logic_vector(12 downto 0);
      CLK40, CLK20_P, CLK20_N, DV, EV_out : out std_logic);
end;
architecture rtl of adc_mux is
 signal count : unsigned(1 downto 0) := "11";
 signal clk20n_reg : std_logic := '0';
begin
 -- Preserve original charge-integrator drive and gate-clock behavior.
 process(CLK80) begin
  if falling_edge(CLK80) then
   count <= count + 1;
   clk20n_reg <= not(count(1) xor count(0));
  end if;
 end process;
 CLK40 <= count(0);
 CLK20_P <= count(1);
 CLK20_N <= clk20n_reg;
 -- EV is a stable global selector passed down the twelve-CPLD chain.
 EV_out <= EV;
 DOUT(11 downto 0) <= ADC0 when EV='0' else ADC1;
 DOUT(12) <= EV;
 -- STR1/P82 carries the actual local ADC sampling clock.
 DV <= CLK80;
end;
