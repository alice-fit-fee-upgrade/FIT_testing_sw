library ieee;use ieee.std_logic_1164.all;use ieee.numeric_std.all;use std.env.all;
entity tb_spi is end;architecture test of tb_spi is
 signal clk,cs,mosi,miso:std_logic:='0';signal sc,wc:std_logic_vector(15 downto 0);
begin
 dut:entity work.pm12_mcu_spi port map(clk,cs,mosi,miso,sc,wc);
 process
  procedure exchange(constant tx:in std_logic_vector;variable rx:out std_logic_vector) is
  begin
   cs<='0';wait for 100 ns;
   for i in tx'range loop
    mosi<=tx(i);wait for 100 ns;clk<='1';wait for 100 ns;rx(i):=miso;clk<='0';wait for 50 ns;
   end loop;
   cs<='1';wait for 100 ns;
  end;
  function packet(rd:boolean;addr:natural;data:natural) return std_logic_vector is
   variable v:unsigned(31 downto 0):=(others=>'0');
  begin if rd then v(31):='1';end if;v(29 downto 22):=to_unsigned(addr,8);v(15 downto 0):=to_unsigned(data,16);return std_logic_vector(v);end;
  variable r:std_logic_vector(31 downto 0);variable burst,reply:std_logic_vector(63 downto 0);variable short:std_logic_vector(30 downto 0);
  variable p:natural;
 begin
  cs<='1';wait for 100 ns;
  exchange(packet(true,16#41#,0),r);assert r(15 downto 0)=x"504D" severity failure;
  burst:=packet(true,16#41#,0)&x"00000000";exchange(burst,reply);
  assert reply(47 downto 0)=x"504D53500001" severity failure;
  for i in 0 to 31 loop
   if i<16 then p:=2**i;else p:=65535-2**(i-16);end if;
   exchange(packet(false,16#40#,p),r);exchange(packet(true,16#40#,0),r);
   assert unsigned(r(15 downto 0))=p severity failure;
  end loop;
  assert unsigned(wc)=32 severity failure;
  short:=packet(false,16#40#,16#AA55#)(31 downto 1);exchange(short,short);
  assert unsigned(wc)=32 severity failure;
  exchange(packet(true,16#40#,0),r);assert unsigned(r(15 downto 0))=32767 severity failure;
  exchange(packet(true,16#41#,0),r);assert r(15 downto 0)=x"504D" severity failure;
  report "SPI_SIM_PASS: identity, bursts, walking ones/zeros, partial-frame rejection";
  stop;wait;
 end process;
end;
