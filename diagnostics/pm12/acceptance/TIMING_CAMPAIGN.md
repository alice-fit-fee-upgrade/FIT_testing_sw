# Four-CFD timing tests in the campaign

Latest [channels9–12 measurements, raw buffers and39-page PDF](evidence-campaign-timing-20261113/README.md).
The current slot7 port order is **12,11,10,9**, independently established by
16-event discovery on each port. Logical A/B returns are8/9,10/11,12/13,14/15.
USB analog stimulus stays on channel10 and is not used by these timing tests.

The current CPLDs generate both original complementary gates. The old
10November INTB-off notes are historical; do not reprogram CPLDs from those
instructions. Existing PMc7c42d28/Kasli CFD4 images and the common supplied
LHC reference are prerequisites. No new FPGA/MCU/CPLD/PLL/flash writes occur.

Use the pinned hardware interpreter and shared leases already obtained by the
acquisition scripts. Explicit channel order must match the confirmed port map:

```sh
/home/codex-hil/kasli-diot-bringup/.venv/bin/python \
 diagnostics/pm12/tdc_live120/scan_four_cfd.py \
 --channels 12 11 10 9 --out /absolute/NEW-TDC-SCAN
/home/codex-hil/kasli-diot-bringup/.venv/bin/python \
 diagnostics/pm12/cfd_simulator/scan_four_phase.py \
 --channels 12 11 10 9 --intervals 100 --out /absolute/NEW-GATE-SCAN
```

TDC discovery requires exactly16events on the expected physical channel.
It then sends128events at each of25positions, one serializer bit apart,
covering one LHC period. Other channels and eight quiet windows must be empty.
Raw13bits, all fine/coarse histograms and acquisition generations are retained.
Functional phase-response limits are a negative slope−60..−20fine codes/ns
and maximum linear-fit residual10fine codes. These are assembly-screening
limits, not an absolute time calibration or maximum-throughput qualification.

The gate scanner writes internal DAC A only, explicitly initializes/restores
0000, inhibits the shared monitor muxes, and records all eight returns at all
404points. Native hardware phase records are checked against raw ISERDES bits.
The offline adapter independently rebuilds every estimator. Each selected A/B
curve must have101valid points and at least5ns observed excursion; steps larger
than two sampler bins are retained as notes rather than hidden as continuous
range. One gate edge period is48samples, two LHC periods. Time axes assume
40.0787MHz×24; no sub-bin resolution or intrinsic jitter calibration is claimed.

New native receipts include UTC times and executed local dependency snapshots.
The acquisition `pass_` flag alone means collection/cleanup completed. Functional
PASS requires independent raw validation and the explicit campaign criteria:

```sh
python3 diagnostics/pm12/acceptance/campaign_timing_adapter.py tdc \
 --source /absolute/TDC-SCAN --out /absolute/NEW-TDC-RECEIPTS \
 --root /absolute/CAMPAIGN --batch ch09-12-attempt001
python3 diagnostics/pm12/acceptance/campaign_timing_adapter.py gate-phase \
 --source /absolute/GATE-SCAN --out /absolute/NEW-GATE-RECEIPTS \
 --root /absolute/CAMPAIGN --batch ch09-12-attempt001
```

The offline adapter needs the existing Kasli host decoder at
`/home/codex-hil/kasli-phase-tester/host/hdmi_check.py` and repository phase
estimator. Their exact sources accompany each receipt for future reconstruction.
No instrument connection is opened by normalization or report generation.
Import each generated ch09..ch12 folder with `campaign.py record`; first
successful imports freeze the per-method source/settings comparison contracts.
For later fittings use exactly those versions or an explicit campaign revision.

Final acquisition state is DAC A=0000, transmitter enable0/port0, DIO cards6/7
inputs and PM bridge enabled. The13November extra postflight confirmed fresh
MCU/FPGA identity, stable PGOOD, all12TDC frontends ready, all-zero quiet counts,
monitor inhibits and TCA masks0. Other analog controls were preserved; prior
ADC/integrator measurements were not silently repeated after the phase sweep.
