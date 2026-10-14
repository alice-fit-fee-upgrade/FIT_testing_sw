library ieee;use ieee.std_logic_1164.all;use ieee.numeric_std.all;
entity tb is end;
architecture test of tb is
 signal clk:std_logic:='0';signal ev:std_logic_vector(12 downto 0):=(others=>'0');
 type words is array(1 to 12) of std_logic_vector(12 downto 0);
 signal dout:words;signal c40,cp,cn,dv:std_logic_vector(1 to 12);
 signal a,b:std_logic_vector(11 downto 0):=(others=>'0');
begin
 clk<=not clk after 6.25 ns;
 gen:for ch in 1 to 12 generate
  u:entity work.adc_mux port map(clk,'0','0',ev(ch-1),a,b,dout(ch),c40(ch),cp(ch),cn(ch),dv(ch),ev(ch));
 end generate;
 process begin
  for sel in 0 to 1 loop
   if sel=0 then ev(0)<='0';else ev(0)<='1';end if;
   for bit in 0 to 11 loop
    a<=std_logic_vector(to_unsigned(2**bit,12));b<=not std_logic_vector(to_unsigned(2**bit,12));wait for 26 ns;
    for ch in 1 to 12 loop
     assert ev(ch)=ev(0) report "EV chain" severity failure;
     if sel=0 then assert dout(ch)(11 downto 0)=a report "ADC A mapping" severity failure;
     else assert dout(ch)(11 downto 0)=b report "ADC B mapping" severity failure;end if;
     assert dout(ch)(12)=ev(0) report "selector tag" severity failure;
     assert dv(ch)=clk report "ADC clock forward" severity failure;
     assert cp(ch)=not cn(ch) report "integrator complementary clocks" severity failure;
    end loop;
   end loop;
  end loop;
  report "CPLD_CHAIN_SIM_PASS";std.env.stop;
 end process;
end;
