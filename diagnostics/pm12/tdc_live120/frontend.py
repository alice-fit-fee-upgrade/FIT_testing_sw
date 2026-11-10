"""PM12 clock/reference frontend, following pinned fit.vhd topology."""
from migen import *
from migen.genlib.cdc import MultiReg
from migen.genlib.resetsync import AsyncResetSynchronizer
from receiver import TdcAcquisition

class Frontend(Module):
    def __init__(self, mclk1):
        self.ios = set()
        self.submodules.acquisition = a = TdcAcquisition()
        self.sys_reference = Signal()
        self.ready = Signal(3)
        self.locks = Signal(3)
        self.phased = Signal(3)
        self.alive = Signal(3)
        def differential(name):
            p = Signal(name_override=name+'_P'); n = Signal(name_override=name+'_N')
            self.ios.update({p,n}); v = Signal()
            self.specials += Instance('IBUFDS', p_DIFF_TERM='TRUE', p_IBUF_LOW_PWR='FALSE', i_I=p,i_IB=n,o_O=v)
            return v
        for group in range(3):
            num = group+1
            td = ClockDomain('tdc%d'%num); coarse = ClockDomain('coarse%d'%num)
            setattr(self.clock_domains, 'cd_tdc%d'%num, td)
            setattr(self.clock_domains, 'cd_coarse%d'%num, coarse)
            result = differential('TDCCLK%d'%num)
            self.specials += [Instance('BUFR',p_BUFR_DIVIDE='BYPASS',i_I=result,i_CE=1,i_CLR=0,o_O=td.clk),
                              AsyncResetSynchronizer(td,ResetSignal('sys'))]
            # ARM/STOP epochs and their remote acknowledgements must reset
            # together when SYS MMCM lock is lost, including idle captures.
            reference = mclk1 if group==0 else differential('MCLK%d'%num)
            clock_in=Signal(); bits=Signal(3); st=Signal(); lock=Signal(); done=Signal()
            feedback=Signal(); fb=Signal(); c600=Signal(); c90=Signal(); c300=Signal()
            ps_en=Signal(); ps_dir=Signal(); jump=Signal(); old=Signal(2); s1=Signal(); s2=Signal()
            self.specials += Instance('pin_capt',name='reference_capture%d'%num,i_pin_in=reference,o_pin_out=clock_in,
                i_clk300=coarse.clk,i_clk600=a.clk600[group],i_clk600_90=a.clk600_90[group],o_str=st,o_ptime=bits)
            if group == 0:
                self.comb += self.sys_reference.eq(clock_in)
            self.specials += Instance('MMCME2_ADV',name='tdc_mmcm%d'%num,p_BANDWIDTH='HIGH',p_COMPENSATION='ZHOLD',
                p_CLKIN1_PERIOD=1e9/120e6,p_DIVCLK_DIVIDE=3,p_CLKFBOUT_MULT_F=30.0,
                p_CLKFBOUT_PHASE=3.0,p_CLKFBOUT_USE_FINE_PS='TRUE',
                p_CLKOUT0_DIVIDE_F=2.0,p_CLKOUT1_DIVIDE=2,p_CLKOUT1_PHASE=90.0,p_CLKOUT2_DIVIDE=4,
                i_CLKIN1=clock_in,i_CLKIN2=0,i_CLKINSEL=1,i_CLKFBIN=fb,o_CLKFBOUT=feedback,
                i_RST=ResetSignal('sys'),i_PWRDWN=0,o_LOCKED=lock,
                i_PSCLK=coarse.clk,i_PSEN=ps_en,i_PSINCDEC=ps_dir,
                i_DADDR=0,i_DCLK=0,i_DEN=0,i_DI=0,i_DWE=0,
                o_CLKOUT0=c600,o_CLKOUT1=c90,o_CLKOUT2=c300)
            for raw, target in [(feedback,fb),(c600,a.clk600[group]),(c90,a.clk600_90[group]),(c300,coarse.clk)]:
                self.specials += Instance('BUFH',i_I=raw,o_O=target)
            local_reset=Signal(reset=1)
            self.specials += MultiReg(ResetSignal('sys'),local_reset,odomain='coarse%d'%num,reset=1)
            self.comb += [a.clk300[group].eq(coarse.clk),a.receiver_reset[group].eq(local_reset)]
            self.specials += Instance('autophase',name='autophase%d'%num,i_clk=coarse.clk,i_lock=lock,i_jump=jump,o_psen=ps_en,o_psincdec=ps_dir,o_done=done)
            sync = getattr(self.sync,'coarse%d'%num)
            sync += [a.coarse_count[group].eq(a.coarse_count[group]+1),s1.eq(st),s2.eq(s1),
                If(st & ~s1,a.bc_time[group].eq(Cat(bits,a.coarse_count[group]))),
                If(s1 & ~s2,old.eq(a.bc_time[group][:2])),jump.eq(s1 & ~s2 & (old!=a.bc_time[group][:2]))]
            heartbeat=Signal(5); hb_sys=Signal(); previous=Signal(); age=Signal(13,reset=8191)
            getattr(self.sync,'tdc%d'%num).__iadd__(heartbeat.eq(heartbeat+1))
            self.specials += [MultiReg(heartbeat[4],hb_sys),MultiReg(lock,self.locks[group]),MultiReg(done,self.phased[group])]
            self.sync += [previous.eq(hb_sys),If(hb_sys!=previous,age.eq(0)).Elif(age!=8191,age.eq(age+1))]
            self.comb += [self.alive[group].eq(age<4000),self.ready[group].eq(self.locks[group]&self.phased[group]&self.alive[group])]
            for lane,letter in enumerate('ABCD'):
                ch=group*4+lane
                self.comb += [a.cfd[ch].eq(differential('IN%s%d'%(letter,num))),
                    a.rstr[ch].eq(differential('RS%s%d'%(letter,num))),a.rdata[ch].eq(differential('RD%s%d'%(letter,num)))]
        self.comb += [a.frontend_ready.eq(self.ready==7),a.window.frontend_status.eq(Cat(self.locks,self.phased,self.alive,self.ready))]
