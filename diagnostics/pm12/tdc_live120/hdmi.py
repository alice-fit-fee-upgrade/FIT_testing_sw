"""Isolated HDMI diagnostics alongside ADC/TDC; never controls PM peripherals."""
from migen import *
from migen.genlib.cdc import MultiReg

class HDMI(Module):
    def __init__(self, ready):
        self.ios=set()
        self.address=Signal(32); self.wdata=Signal(32); self.write=Signal(); self.commit=Signal()
        self.selected=Signal(); self.error=Signal(); self.rdata=Signal(32)
        self.command=Signal(8)
        scratch=Signal(16); writes=Signal(16); locked=Signal(); cmd=Signal(8)
        self.specials += [MultiReg(self.command,cmd,odomain='cap'), MultiReg(ready,locked)]
        phase=Signal(3); div=Signal(8); oldmode=Signal(2)
        prbs=[Signal(7,reset=s) for s in [1,0x13,0x35,0x57]]
        self.sync.cap += [phase.eq(phase+1),div.eq(div+1),oldmode.eq(cmd[4:6]),
            If((cmd[4:6]!=oldmode)|cmd[7],div.eq(0),*[x.eq(s) for x,s in zip(prbs,[1,0x13,0x35,0x57])])
            .Elif((cmd[4:6]==2)|((cmd[4:6]==3)&(div==0)),*[x.eq(Cat(x[6]^x[5],x[:6])) for x in prbs])]
        idle=Signal(4); data=Signal(4)
        self.specials += Instance('pm_hdmi_idle',i_clk=ClockSignal('cap'),i_phase=phase,o_data=idle)
        self.comb += data.eq(Mux(cmd[4:6]==0,cmd[:4],Mux(cmd[4:6]==1,idle,Cat(*[x[6] for x in prbs]))))
        for i in range(4):
            p=Signal(name_override='HDMI_P%d'%i); n=Signal(name_override='HDMI_N%d'%i)
            self.ios.update({p,n}); self.specials += Instance('OBUFDS',p_IOSTANDARD='LVDS',p_SLEW='FAST',i_I=data[i],o_O=p,o_OB=n)
        pins={n:Signal(name_override=n) for n in ['HSCK','HSEL','HMOSI','HMISO']};self.ios.update(pins.values())
        mi=Signal(); hs=Signal(16); hw=Signal(16)
        self.specials += [Instance('hdmi_slave',i_clk=pins['HSCK'],i_sel=pins['HSEL'],i_mosi=pins['HMOSI'],i_locked=ready,
            o_miso=mi,o_scratch_out=hs,o_writes_out=hw),Instance('OBUFT',i_I=mi,i_T=~pins['HSEL'],o_O=pins['HMISO']),
            MultiReg(hs,scratch),MultiReg(hw,writes)]
        self.comb += [self.selected.eq((self.address>=0x300)&(self.address<=0x304)),
            self.error.eq(self.write&((self.address!=0x301)|((self.wdata&~0xbf)!=0))),self.rdata.eq(0),
            Case(self.address,{0x300:self.rdata.eq(0x48444d31),0x301:self.rdata.eq(self.command),
                0x302:self.rdata.eq(locked),0x303:self.rdata.eq(scratch),0x304:self.rdata.eq(writes)})]
        self.sync += If(self.commit&self.selected&self.write&~self.error,self.command.eq(self.wdata))
