from artiq.experiment import *


class PmtSimExample(EnvExperiment):
    
    def build(self):
        self.setattr_device("core")
        self.setattr_device("pmtsim0_ttl_dio_ch0")

    @kernel
    def run(self):
        self.core.reset()

        self.pmtsim0_ttl_dio_ch0.input()
        delay(1*ms)
        gate_end = self.pmtsim0_ttl_dio_ch0.gate_rising(10*ms)
        self.core.wait_until_mu(now_mu())
        
        print("Count value (should be approx. equal to number of rising edges in 10ms window):")
        print(self.pmtsim0_ttl_dio_ch0.count(gate_end))