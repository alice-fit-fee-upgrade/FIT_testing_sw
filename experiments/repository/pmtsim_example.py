from artiq.experiment import *


class PmtSimExample(EnvExperiment):
    def build(self):
        self.setattr_device("core")
        self.setattr_device("dac_pmtsim0")
        self.channels = []
        for ch in range(6):
            self.setattr_device(f"pmtsim0_ch{ch}")
            self.channels.append(getattr(self, f"pmtsim0_ch{ch}"))

    @kernel
    def run(self):
        self.core.break_realtime()
        
        # Initialize DAC
        self.dac_pmtsim0.init()

        # Set same voltage on all channels
        for ch in self.channels:
            ch.write_hit_cal(0, 0.5)
            ch.write_hit_cal(1, 0.5)

        # Pulse all channels
        for ch in self.channels:
            ch.hit_ttl[0].pulse(200*ns)
            ch.hit_ttl[1].pulse(200*ns)
