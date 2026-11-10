# DIO5/9 repair verified —2026-11-10

All eight gate-return lanes now have valid edges through404 DAC points.
Four-channel TDC repeat:12,800 phase events, no loss/cross-channel records.
[Post-repair plots, PDF chapter and data](FOUR_CFD_REPAIR_REPEAT.md).
The channel8 sweep has a one-off ADC-period-sized phase step, not reproduced
in three local checks; retained in the report rather than counted as smooth range.

# Four CFD simulators characterized —2026-11-10

Channels12/10/8/6: four-port input discovery and100 TDC phase points PASS,
12,800 events, zero cross-channel/quiet-window events. Internal DAC-A phase
scan404 points complete. INTA return paths10/8 remain HIGH (unresolved).
New Kasli four-port image retained; PMc7c42d28 unchanged after SRAM restore.
[Full results, plots, PDF chapter and raw data](FOUR_CFD_CHARACTERIZATION.md).

# PM12 LHC-clock IPbus / ADC / TDC integration

Latest: the resident PM image is now build`c7c42d28`, adding HDMI diagnostics
and coherent TDC-domain resets. Use the [integrated system suite](../system/README.md).
The a27baa3e receipts and build details below describe the earlier baseline.

Physical functional PASS 2026-11-06 on PM12 S/N1803 and Kasli-DIOT00001.
Resident PM FPGA build a27baa3e, USER1 504d5a04, IPbus504d1202 ABI10002.
No PM CDCE output-frequency writes, MCU/CPLD programming or flash writes.
Owner restarted PM during preparation; physical PGOOD was checked afterwards.

## Physical link and clocking

Kasli SFP0 remains LAN/control192.168.2.241. SFP1 connects directly to PM12
via DAC, at nominal1.202361Gb/s. SFP2 is the standard1.25Gb/s optical LAN
uplink for this bridge. SFP3 is incorrectly connected and not instantiated.
SFP0 is an independent endpoint, not a third bridge port (no forwarding loop).

PM GTX reference stays200.3935MHz, CDCE output3. CPLL N1=4,N2=3,M=1,
output divider4. Kasli uses120.2361MHz from the LHC-clock path, PLL1 times20,
output divider4. Its PLL0 uses the independent fixed125MHz oscillator.
Physical GTP REFCLK0 is LHC/AG14, REFCLK1 is fixed125/AG16.

Kasli must forward MCX120.2361MHz to Si5324 CKIN1. The chip initially had no
usable output. `host/lhc_reference.py` selects CKIN1 and documented Si5324
bypass1:1 (digital hold while changing bypass); this is NOT jitter-cleaner PLL
operation. No Si divider/VCO/ICAL changes are required. Retained setup also
sets PCA9539@74 P1.7 CLK_SEL=0 and P1.1 SFP1 TX_DISABLE=0; @75 P0.1
SFP2 TX_DISABLE=0. All other GPIO bits, including SFP3 controls, are preserved.
The host helper restores mux/service routing; its explicit keep_configuration
flag retained the working volatile clock/SFP setup after the successful test.

PM SYS/IPbus40.0787MHz derives from MGT reference via ODIV2 and MMCM, with
VCO limited below the device ceiling. TDC MMCMs accept MCLK120.2361MHz,
DIVCLK3,MULT30, and generate nominal600/300MHz. Receiver resets synchronize
per coarse domain. Generated clocks are included in async clock-group rules;
original TDC datapath constraints are retained. I2C pads remain inputs.

## Results

See `evidence-20261106/`: original integration receipt, repeat-CLI receipt,
qualification reports and all592 acquired nonzero TDC records as CSV.

- IPbus read both synthetic ADC banks:2*12*4096=98304 exact16-bit values.
  This qualifies transport/buffers, not new physical ADC measurements.
- During those bulk reads bridge drops did not increase (29656/2459 are earlier
  disabled/startup counts). Initial link acquisition needed one read retry;
  there were no further retries during the two bulk downloads.
- CFD input is slot7 channel0, RJ45 pair1/2. Finite OSERDES bursts at nominal
  100kHz yielded16,64,128 records in PM channel12, exactly one per pulse.
- Four phase positions24/30/36/42 each yielded128 records. All other11 channels
  and quiet captures before/after were zero. Repeat CLI16-pulse test also PASS.
- Raw values retain13 bits, reserved upper3 bits zero. Fine/coarse timestamps
  have NOT been calibrated to nanoseconds. The BC reference capture currently
  uses120MHz; this is functional event testing, not validated25ns timestamp
  reconstruction or absolute phase/orbit alignment.

Final resident state: bridge enabled in normal autonegotiated uplink mode1,
PM192.168.2.240 reachable, SFP0 control reachable, TDC clocks/statusFFF/19.
CFD output released, both DIO cards inputs. ADC bank0/physical mode selected
without ARM, so the synthetic ADC capture is invalidated. No MCU/analog DAC
writes were made; the owner's restart may have reapplied MCU stored settings.

## Repeat functional test

On the already initialized/resident setup, with all three shared leases free:

```
cd /home/codex-hil/kasli-phase-tester
./run-python -m host.pm_tdc_test --out /srv/codex-hil-nvme/measurements/NEW-NAME
```

The FIT_testing_sw entry point is `test_tdc_from_kasli.py`; it forwards to the
station Kasli project (local commit561dea9, no remote configured), using its
pinned environment. --kasli-root selects another local checkout.

Options include --counts 16 64 128, --phase-bins 24 30 36 42 and
--expected-channel 1..12. Output directories must be new. The driver holds
PM12/Atmel/Kasli leases, checks PGOOD/identities, waits for TDC STARTED before
stimulus and freezes before downloads. It releases the CFD output/restores DIO
input routing in cleanup. No automatic programming, clock setup or power cycle.
This command was physically exercised with --counts 16 --phase-bins 24.

## Artifacts and rebuild

Heavy builds run on Dell. PM job:
/srv/nvme-fast-1/vivado-work/pm12-tdc-lhc-link-20261106-02.
PM bit SHA2567395e3c0c2bf14901ed45d18a9b5ee15a9e9b79a112c33948235bd31a11ef3d1.
Local bit/qualification:/srv/codex-hil-nvme/pm12-tdc-lhc-link-20261106/candidate/.
Setup+.097ns,hold+.058ns,pulse-width+.314ns, no unclocked/unconstrained internal
endpoints. DRC0 errors, one RTSTAT-10 warning for unused vendor FIFO status nets.

Kasli job:kasli-pm-bridge-20261106-02; local candidate-02 under
/srv/codex-hil-nvme/kasli-pm-bridge-20261106/.
Bit SHA25611aab3df12919c0bf618d0ce11b0caae2f4c56872b8ee35933102dfc81d678f6.
Setup+.196ns,hold+.062ns,DRC0 errors,16 ISERDES,3 GTP channels,1 dual-PLL common.
Current Kasli source regenerates resident RTL/XDC byte-for-byte.

Generate Kasli with --ipbus --cfd-tx --pm-bridge. PM generated/generate.py uses
the pinned Migen/LiteX/LiteEth/LiteICLink environment from fit-bringup and the
root frontend/receiver/buffer sources here. VHDL/upstream manifests retain their
original provenance; they are not new physical validation receipts.

Normal packet operation is qualified. Standalone PRBS qualification is separate:
old runs were affected by TAP mode changes and PCS missing-idle restarts. A
PRBS-watchdog suppression experiment exists only in NVMe/Dell artifacts and
was not loaded/qualified. Do not report a bidirectional PRBS PASS from this test.
