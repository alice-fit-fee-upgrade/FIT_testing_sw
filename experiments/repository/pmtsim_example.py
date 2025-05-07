from artiq.experiment import *

class PmtSimExample(EnvExperiment):
    def build(self):
        self.setattr_device("core")
        self.setattr_device("core_dma")
        self.setattr_device("dac_pmtsim0")
        self.channels = []
        for ch in range(6):
            self.setattr_device(f"pmtsim0_ch{ch}")
            self.channels.append(getattr(self, f"pmtsim0_ch{ch}"))

    @kernel
    def record(self):
        with self.core_dma.record("pulses"):
            # self.channels[0].hit_ttl[0].on()
            # self.channels[1].hit_ttl[1].on()
            # delay(20*us)
            # self.channels[0].hit_ttl[0].off()
            # self.channels[1].hit_ttl[1].off()
            # delay(20*us)
            for ch in self.channels:
                ch.hit_ttl[0].on()
            #delay(8*ns)
            # for ch in self.channels:
            #     ch.hit_ttl[1].on()

            delay(8*ns)
            for ch in self.channels:
                ch.hit_ttl[0].off()
            # delay(8*ns)
            # for ch in self.channels:
            #     ch.hit_ttl[1].off()
            # delay(20*ns)

            # self.pmtsim0_ch0.hit_ttl[0].pulse(8*ns)
            # self.pmtsim0_ch0.hit_ttl[1].pulse(8*ns)

    @kernel
    def run(self):
        self.core.reset()
        self.record()
        pulses_handle = self.core_dma.get_handle("pulses")
        self.core.break_realtime()

        # Initialize DAC
        self.dac_pmtsim0.init()
        # Set same voltage on all channels

        for ch in self.channels:
            # delay(500*ms)
            # print(ch.dac.read_reg(0,AD53XX_READ_OFS0))
            # delay(500*ms)
            # print(ch.dac.read_reg(0,AD53XX_READ_AB0))
            delay(1*ms)
            ch.wirte_hit_cal(0, 5.5)
            delay(1*ms)
            ch.wirte_hit_cal(1, 5.5)
            
        
   
        # Pulse all channels
        while True:
            #delay(978.04*us)
            delay(978.0801*us)
            # delay(978112280*ps)
            self.core_dma.playback_handle(pulses_handle)

        

        # # Poniższe dodane przez JMA, niekoniecznie jest to poprawne
        # for ch in self.channels:
        #     for i in range(10):
        #         ch.dac.write_dac(1, 0.5*i)
        #         delay(200*ms)
        #         ch.dac.write_dac(22, 0.5*i)
        #         delay(200*ms)

    # @kernel
    # def krun(self):
    #     self.core.reset()
    #     self.core.break_realtime()

    #     for i in range(10):
    #         for i in range(6):
    #             self.leds[i].on()
    #             delay(200*ms)
    #         delay(500*ms)
    #         for i in range(6):
    #             self.leds[i].off()
    #             delay(200*ms)
    #         delay(500*ms)
                

