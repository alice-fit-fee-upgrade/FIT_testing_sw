from artiq.experiment import *


class PmtSimExample(EnvExperiment):
    def build(self):
        self.setattr_device("core")
        self.setattr_device("pmtsim0_dac")
        self.channels = []
        for ch in range(6):
            self.setattr_device(f"pmtsim0_ch{ch}")
            self.channels.append(getattr(self, f"pmtsim0_ch{ch}"))
        self.setattr_device("pmtsim0_trig_gen")
        self.setattr_device("pmtsim0_ttl_dio_ch0")

    @kernel
    def run(self):
        self.core.reset()

        # Initialize DAC
        self.pmtsim0_dac.init()

        # Set same voltage on all channels
        for ch in self.channels:
            delay(10*ms)
            ch.write_hit_cal(0, 5.5)
            delay(10*ms)
            ch.write_hit_cal(1, 5.5)
            delay(10*ms)

        # Enable triggering to all channels
        self.pmtsim0_trig_gen.set_mask(0x3F)
        delay(1*ms)

        self.pmtsim0_trig_gen.set_length(1)
        delay(1*ms)
