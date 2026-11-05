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
begin
 -- Diagnostic gate drive: both integrator outputs directly mirror the
 -- local ADC sampling clock (CLK80/P27). No division or complement here.
 -- Retain the original divided CLK40 output and ADC/EV mux behavior.
 process(CLK80) begin
  if falling_edge(CLK80) then
   count <= count + 1;
  end if;
 end process;
 CLK40 <= count(0);
 CLK20_P <= CLK80; -- INTA_G_DRV / P53
 CLK20_N <= CLK80; -- INTB_G_DRV / P54
 -- EV is a stable global selector passed down the twelve-CPLD chain.
 EV_out <= EV;
 DOUT(11 downto 0) <= ADC0 when EV='0' else ADC1;
 DOUT(12) <= EV;
 -- STR1/P82 carries the actual local ADC sampling clock.
 DV <= CLK80;
end;
