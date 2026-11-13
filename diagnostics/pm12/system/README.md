# Integrated PM12 / Kasli diagnostic image pair

**2026-11-13 regression:** repeated resident runs reset SYS when FPGA pads are released after SPI signature reads. Walking/PRBS/idle data lanes pass, but the full HDMI test FAILS. Historical qualification below does not qualify the current setup. See [fresh evidence](../acceptance/evidence-campaign-assembly-20261113/README.md). Do not treat SPI release as qualified until fixed and retested.

HDMI is added alongside the resident ADC/TDC and the Kasli SFP bridge. No
production PM firmware, CPLD mux, MCU firmware, PLL profile or flash changes.
Build and physical qualification status is recorded in the evidence directory;
source availability alone is not a physical PASS.

**Qualified2026-11-06:** two complete command-line runs PASS, PM build
`c7c42d28`, Kasli SHA`4299ddd3c87ccc4ad76796127de1d08d2d50943c7679555fca140b1e64261745`.
87141 fast PRBS bits checked across four lanes, zero errors; both runs had no
SYS reset, no new bridge drops and no read retry. See `evidence-20261106/validation.json`.

## One test command

On the attached Optiplex station, with the qualified integrated images loaded:

```
python3 diagnostics/pm12/system/test_system.py --out /srv/codex-hil-nvme/measurements/NEW-NAME
```

`--suites hdmi adc tdc` is the default. A subset may be selected. The runner
holds the PM12, Atmel-ICE and Kasli leases together, checks PGOOD and board
identities, then runs selected suites without reprogramming either FPGA.
The station's existing pinned Kasli environment and local checkout are required;
`--kasli-root` changes that location. There is no automatic clock setup or
programming. Output directories must be new. Stop and close happen on exit.

* HDMI: allowlisted SPI signature reads0/1/2 only; four
  data lane discovery, slow and full-rate PRBS7, original empty trigger frames.
  Native nonempty trigger payloads and production 20 MHz SPI are not qualified.
* ADC: both synthetic banks downloaded and compared across all 12 channels;
  both physical banks acquired with strobe and EV tag checks. This checks the
  digital paths. It does not provide a precision analog stimulus on all channels.
  EV returns to bank A, with a valid physical capture retained.
* TDC: quiet windows, then 64 CFD pulses from slot7/channel0, exactly 64 records
  on physical PM channel12 and zero on other channels. `--expected-channel`
  selects another physically wired channel. No timestamp calibration claim.

## Wiring and direction safety

HDMI remains connected to the top two RJ45 ports of slot6 (Kasli=slot0).
Live discovery found the two RJ45 groups reversed relative to the historical
October test: slot6 channels0..3=data inputs;4=SELECT,5=CLOCK,6=MISO,7=MOSI.
Only4/5/7 drive while enabled; PCF mask is **0x00b0**.
Build option `--hdmi-data-base 0` selects this current wiring. The historical
`--hdmi-data-base 4` selects data4..7 and SPI0..3, mask0x000b. The host reads
the FPGA mapping register and checks static walking data before enabling SPI. Slot7 channel0
is the independent CFD stimulus. The four data lanes use additional capture
buffers, leaving the original 16 phase channels and their addresses unchanged.
SPI output enable resets low and is cleared by STOP or reference loss. The host
releases FPGA pads before buffer direction changes and restores the direction
latches after releasing outputs. At the current baseline both cards are inputs.

PM HDMI SPI is the isolated diagnostic map, not production peripheral control:
active-high select, falling-edge shift, 16-bit header followed by 16-bit data.
Signatures at00/01 are4844/4d49; register02 reports lock.
**HSEL/HSCK/HMOSI/HMISO are shared with ATxmega PD4/5/6/7.** The host
rejects writes, nonzero read payloads and every address outside0/1/2 before
issuing a transaction. The FPGA also has scratch40/count41/complement42, but
these addresses are NOT qualified for use with the live MCU. Earlier arbitrary
pattern writes and later extended reads caused clock/SYS resets. FPGA-only
isolation was insufficient; the exact MCU interaction remains unqualified.
Those experiments are explicitly archived as unqualified diagnostics. The final
allowlisted test passed twice without resets; do not restore the old SPI sweep.
The master holds select after the last falling edge. Default half-bit divider600
means about100 kHz with the shared LHC-derived120.2361 MHz reference.

## PM IPbus addresses (word addresses)

Existing ADC/TDC addresses and ABI10002 are preserved; feature word9 adds bit5.

| Address | Function |
|---|---|
| 0x300 | HDMI extension magic0x48444d31 |
| 0x301 | TX command: bits0..3 static lanes; bits4..5 mode; bit7 PRBS hold/reset |
| 0x302 | TX reference lock status |
| 0x303 / 0x304 | HDMI SPI scratch / write count, synchronized into system domain |

Modes0=static,1=original empty trigger frames,2=PRBS each320 MHz sample,
3=PRBS every256 samples. Seeds01/13/35/57, x7+x6+1. Actual fast clock is
320.6296 MHz with the stated40.0787 MHz reference. I2C pads remain inputs.

## Kasli registers (byte addresses, divide by4 for IPbus CSR access)

| Address | Function |
|---|---|
| 0x140 | HDMI extension magic0x48444d31 |
| 0x144 | SPI pads enable0/1; write0 aborts/releases and clears error |
| 0x148 | TX packet32; write starts one transfer while enabled and idle |
| 0x14c | Last received32-bit packet; low16 bits are register reply |
| 0x150 | Status ready/busy/error/enabled, bits0..3 |
| 0x154 | Half-bit divider60..65535; default600 |
| 0x158 | Completed SPI transaction counter |
| 0x15c | Capture channel map0x03020100 (current) or0x07060504 (historical) |
| 0x160 / 0x164 | Selected HDMI lane0..3 / raw buffer index |
| 0x168 / 0x16c | Raw word / selected lane count |
| 0x170 / 0x174 | Start sample counter low/high |
| 0x178 / 0x17c | Previous bit / all HDMI buffers valid |

IPbus **word** aperture0x30000+lane*0x1000 reads the four frozen HDMI buffers.
The existing shared ARM/software trigger starts both the original phase buffers
and these HDMI buffers; the host verifies generation, length and equal start
counters before interpretation. Original raw0x10000 and phase0x20000 apertures
are unchanged. Added storage is four4096x8-bit buffers; two data inputs reuse
existing ISERDES, two require new ISERDES. Reset/clock switching do not establish
an absolute calibrated phase origin.

## Source provenance and builds

PM `../tdc_live120/generated/generate.py` adds `../tdc_live120/hdmi.py` to the
existing integrated image. `PM12_pkg.vhd`, `trigger.vhd`, `idle.vhd` and
`hdmi_slave.v` are copied unchanged from the previously physically tested
`kasli-phase-tester/hdmi/pm12` diagnostic. The first two originate from FIT PM
firmware commit857b773eec28282b357d4668ab934e95f41b6fe7. The slave and wrapper
are diagnostic code, not recovered production behavior.

Generate Kasli with `--ipbus --cfd-tx --pm-bridge --hdmi --hdmi-data-base 0` using the existing
pinned environment and LiteX/LiteEth/LiteICLink source paths. Sources and HDL
snapshots are retained with the test evidence. Heavy compilation uses Dell's
full-path Vivado launcher and `dell-build-slot`, four threads per job. Generated
Migen bitstream Tcl exits Vivado: run qualification separately, opening the
routed checkpoint; placing commands after `source gate_phase.tcl` does not
execute them. Check build exit status, timing, DRC and fresh artifact hashes
before programming. Hardware loading remains on Optiplex with all board leases.

The two bidirectional SPI pad receivers are disabled while transmitting. Their
internal driver/control feedback into ISERDES is excluded from synchronous
timing; this exception does not cut the external LVDS data paths. Qualification
uses the actual stated MCX reference120.2361 MHz, not a rounded120 MHz clock.
The routed checkpoint can be reoptimized with these constraints without changing
RTL; the retained final qualification script records the exact sequence.

After FPGA reprogramming, initialize the private SFP1 receiver before expecting
PM reachability: Kasli byte CSR0x100=0x100, wait50ms, then0x100=0; bridge
CSR0x120=1. These can be issued over the retained UART while SFP0 initializes.
Wait/retry SFP0 IPbus startup. This reinitializes the private PHY only; clock
frequencies, MCU, CPLDs and flash are unchanged. An initial attempt without
this sequence timed out; known baseline networking recovered after the reset.

## Reset regression and retained state

A SYS reset previously cleared capture epochs while leaving TDC-domain
acknowledgements intact, permanently blocking the next ARM. The three TDC
domains now use asynchronous assertion/synchronous release from SYS reset.
`../tdc_live120/test_reset_epochs.py` reproduces the old failure and verifies
rearming with coordinated resets. The runner records64-bit PM uptime around
each suite and fails clock health if it decreases; successful individual data
checks cannot hide a reset.

Final PM bitSHA: `1dbafd99033f803a086d4153ed3d873adfc9b4208b806785f00d3024bdfbf1ac`.
PM Dell job: `/srv/nvme-fast-1/vivado-work/pm12-hdmi-integrated-20261106-02`;
setup+.090ns,hold+.074ns,pulse+.314ns, DRC0 errors with the existing RTSTAT-10
unused vendor FIFO warning. Kasli Dell job:
`/srv/nvme-fast-1/vivado-work/kasli-hdmi-integrated-20261106-03`;
setup+.101ns,hold+.043ns,DRC0 errors. Local qualified bits are in
`/srv/codex-hil-nvme/pm12-hdmi-integrated-20261106/{pm,kasli}-final-candidate/`.

Both images remain in SRAM. SPI and CFD outputs are released, both DIO cards
return to inputs, bridge remains enabled, ADC bankA retains a physical capture,
and TDC ends with a frozen quiet capture. MCU/CPLD/configuration flash images
were not programmed. External DAC and CFD analog controls were not written.
The source archive includes the station driver and generated Kasli RTL/XDC;
regeneration matches the final routed input RTL/XDC byte-for-byte.
