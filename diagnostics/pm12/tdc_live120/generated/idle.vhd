library ieee; use ieee.std_logic_1164.all;
use work.PM12_pkg.all;
entity pm_hdmi_idle is port(clk:in std_logic; phase:in std_logic_vector(2 downto 0); data:out std_logic_vector(3 downto 0));end;
architecture rtl of pm_hdmi_idle is
 signal tt,ta:std_logic_vector(1 downto 0);
 constant times:trig_time:=(others=>(others=>'0'));
 constant amps:trig_ampl0:=(others=>(others=>'0'));
begin
 u:entity work.trigger port map(clk320=>clk,mt_cou=>phase,CH_trigt=>x"000",CH_triga=>x"000",CH_trigb=>x"000",CH_TIME_T=>times,CH_ampl0=>amps,tcm_req=>'0',tt=>tt,ta=>ta);
 process(clk)begin if rising_edge(clk)then data<=ta&tt;end if;end process;
end;
