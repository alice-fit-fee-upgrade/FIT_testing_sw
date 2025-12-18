from artiq.experiment import *


class PmtSimSimpleClock(EnvExperiment):
    
    def build(self):
        self.setattr_device("core")
        self.setattr_device("pmtsim0_ttl_dio_ch0")
        self.setattr_device(f"pmtsim0_ch2")
        self.setattr_device("pmtsim0_dac")
        self.setattr_device("pmtsim0_trig_gen")

    @kernel
    def run(self):
        orbit = 0x9924*24

        self.core.reset()

        self.pmtsim0_trig_gen.set_mask(0x0)

        self.pmtsim0_dac.init()

        # Set same voltage on all channels
        delay(10*ms)
        self.pmtsim0_ch2.write_hit_cal(0, 5.5)
        # self.pmtsim0_ch2.write_hit_cal(0, 5.5)
        delay(10*ms)
        self.pmtsim0_ch2.write_hit_cal(1, 5.5)
        delay(10*ms)

        self.pmtsim0_ttl_dio_ch0.input()
        delay(1*ms)

        while True:
            t0 = now_mu()
            # Added value must be more than orbit but less than 2 orbits
            gate_end = t0 + 1_200_000
            self.pmtsim0_ttl_dio_ch0._set_sensitivity(1)
            # gate_end = self.pmtsim0_ttl_dio_ch0.gate_rising(1.5*ms)
            while True:
                ts = self.pmtsim0_ttl_dio_ch0.timestamp_mu(gate_end)
                if ts < 0:
                    continue
                else:
                    at_mu(ts+orbit-145)
                    self.pmtsim0_ttl_dio_ch0._set_sensitivity(0)
                    break

            # BC 0
            self.pmtsim0_ch2.hit_ttl[0].pulse_mu(15)

            # BC 10 + 24*10 mu
            delay_mu(240-15)
            self.pmtsim0_ch2.hit_ttl[0].pulse_mu(15)
