from artiq.experiment import *
import numpy as np

# ref period of ARTIQ is 1/120 MHz / 8 ~= 8.33 ns / 8 ~= 1.042 ns
# LHC clock works on 40 MHz
# therefore we need a MULTIPLIER of ref_period * 8 * 3
MULTIPLIER = 24 

CONST_MOD = 145
DEFAULT_PULSE_DURATION_MU = 15

class PmtSimClockScheduling(EnvExperiment):
    
    def build(self):
        self.setattr_device("core")
        self.setattr_device("pmtsim0_ttl_dio_ch0")
        self.setattr_device(f"pmtsim0_ch2")
        self.setattr_device("pmtsim0_dac")
        self.setattr_device("pmtsim0_trig_gen")

        self.setattr_argument("orbit", NumberValue(0x9924, type="int", precision=0, scale=1, step=1))
        self.setattr_argument("orbit_seeker_window", NumberValue(1.25, type="float"))
        self.setattr_argument("smaller_orbit_seeker_window", NumberValue(0.05, type="float"))

        self.orbit_mu = np.int64(self.orbit * MULTIPLIER)

        self.window_length_mu = round(self.orbit_mu * self.orbit_seeker_window)
        self.window_orbit_ratio = self.window_length_mu/self.orbit_mu
        if (self.window_orbit_ratio != self.orbit_seeker_window):
            print("WARNING: Orbit seeker window vs orbit duration ratio changed due to rounding")

        print("Orbit seeker window ratio set to: {} {}".format(self.window_orbit_ratio, self.window_length_mu))
        self.t0 = np.int64(0)

        self.smaller_window = np.int64(self.smaller_orbit_seeker_window*self.orbit_mu)

    @kernel
    def init_pmtsim(self):
        self.pmtsim0_trig_gen.set_mask(0x0) # turn off combinatorial mode

        self.pmtsim0_dac.init()

        # Set same voltage on all channels
        delay(10*ms)
        self.pmtsim0_ch2.write_hit_cal(0, 5.5)
        delay(10*ms)
        self.pmtsim0_ch2.write_hit_cal(1, 5.5)
        delay(10*ms)

        self.pmtsim0_ttl_dio_ch0.input()
        delay(1*ms)



    @kernel
    def find_first_laser_out(self):

        self.t0 = t0 = now_mu()
        gate_end = t0 + self.window_length_mu

        self.pmtsim0_ttl_dio_ch0._set_sensitivity(1)
        while True:
            ts = self.pmtsim0_ttl_dio_ch0.timestamp_mu(gate_end)
            if ts < 0:
                continue
            else:
                if gate_end - ts < self.orbit_mu:

                    next_lout = ts+self.orbit_mu-CONST_MOD
                    at_mu(next_lout)
                    self.pmtsim0_ttl_dio_ch0._set_sensitivity(0)
                    break
                else:
                    continue

    @kernel
    def find_laser_out(self):
        gate_end_mu = self.pmtsim0_ttl_dio_ch0.gate_rising_mu(self.smaller_window)
        self.core.wait_until_mu(gate_end_mu)
        ts = self.pmtsim0_ttl_dio_ch0.timestamp_mu(gate_end_mu)
        if ts < 0:
            raise ValueError("Could not catch Laser out")
        else:
            at_mu(ts + self.orbit_mu - CONST_MOD)


    @kernel
    def hit_bcs(self, mask, slots=16):
        if mask >> slots:   # each bit is one of the 64 available BC; FIXME: 0xFFFFFFFFFFFFFFFF exceeds allowed singed integer value
            raise ValueError("Mask for BCs slots should be smaller than 0xFFFFFFFFFFFFFFFF")
        for i in range(slots): # no of mask bits
            if (mask >> i) & 0b1:
                self.pmtsim0_ch2.hit_ttl[0].pulse_mu(DEFAULT_PULSE_DURATION_MU)
                delay_mu(MULTIPLIER - DEFAULT_PULSE_DURATION_MU)
            else:
                # Empty slot: advance by full slot duration
                delay_mu(MULTIPLIER)

    @kernel
    def planned_seq(self):
        # self.hit_bcs(0b0000_0110_1001_1100)
        self.hit_bcs(0b10)


    @kernel
    def run_rt(self):
        self.core.reset()
        self.core.break_realtime()
        self.init_pmtsim()

        self.find_first_laser_out()

        # now = L2 ts - epsilon
        n = 0
        while True:
            self.find_laser_out()
            # now = l3 ts = l2 + period

            lout_ts = now_mu()
            self.planned_seq()
            # now = somewehere 

            # ensure that we are not exceeded l4 ts
            if (now_mu() - (lout_ts + self.orbit_mu) >= 0):
                raise ValueError("Exeeded maximum allowed time in one orbit.")
            
            # just before l4 ts
            at_mu(lout_ts)
            

    def run(self):
        self.run_rt()
