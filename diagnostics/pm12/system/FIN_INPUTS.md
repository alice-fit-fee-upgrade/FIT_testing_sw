# DIO-RJ45 FIN input states during HDMI SPI

The local Altium schematic export identifies FIN1101K8X repeaters IC19/IC20.
Each differential path has a termination: R131=100Ω on sideA and R132=100Ω
on sideB. Direction selects opposing repeaters through EN_B_to_A and a BSS138
inverter T25, with R133=10kΩ pulling up an **enable**, not the signal input.
This module direction control is not an independent command to disable both
repeaters. Confirm fitted revision before making hardware changes.

Manufacturer source: [onsemi FIN1101 datasheet](https://www.onsemi.com/download/data-sheet/pdf/fin1101-d.pdf).
It specifies3.0–3.6V supply and differential reception down to100mV, with a
wide common-mode range. Therefore3.3V supply alone does not imply a CMOS-level
mismatch with a valid LVDS signal from a2.5V FPGA bank. Check actual amplitude,
common mode and load; the Kasli IOBUF receiver termination is disabled when
those bidirectional pairs transmit. Other receive paths can have both external
and FPGA termination and need their actual loading checked.

The stated protection is **open-circuit** fail-safe. Do not extrapolate it to a
floating pair still bridged by100Ω, a disconnected conductor, supply sequencing
or opposing transmitters. An undefined differential input can be regenerated
as unintended output transitions. Holding FPGA outputs at stable idle eliminates
one deliberate source of this condition, not every possible electrical cause.

Kasli gateware additionally gates output enable with `ready` (MMCM lock and RX
readiness), so a host read of enable1/status9 after an event is not a continuous
electrical observation of OE. A sufficiently brief readiness disturbance could
be missed by software. No Kasli reprogramming or direction reversal is needed
for the PM-side passive observer.

PM-side return is also relevant: the diagnostic FPGA tristates HMISO when HSEL
is low. The other possible owner is MCU SPID; its actual readiness/enable state
must be established before assuming HMISO has a defined idle level. Do not add
arbitrary pull resistors or enable a second transmitter as a diagnostic shortcut.

Schematic PM12v1.1 sheet5 explicitly maps HSEL→PD4, HMOSI→PD5, HMISO→PD6,
HSCK→PD7. Earlier shorthand listing four signals followed by PD4..7 was not an
ordered pin mapping.

The reset-independent PM observer samples physical HSEL/HSCK/HMOSI and MMCM
status on the MCLK1 reference. The source calls it LHC×3, but the observed watch/SYS ratio and SPI spacing imply approximately40.0787MHz (about25ns samples) in this setup; see the clock-observer evidence. It can establish ordering
and detect sampled spurious transitions; it cannot exclude narrower glitches or
replace differential oscilloscope measurements at FIN input/output and PM clock.
No absence-of-glitch PASS should be inferred from its limited bandwidth.

PLL investigation controls: `@PLL` requests CDCE62005 status, not a frequency
profile write. Nevertheless it is an active shared-SPI transaction. The separate
no-MCU-command experiment issues no UART/PLL command during its observation;
the MCU's autonomous background firmware remains running. All Kasli SPI outputs
and buffer directions stay held in both experiments.
