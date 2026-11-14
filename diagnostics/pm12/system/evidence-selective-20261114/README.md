# Selective HDMI stimulation — 2026-11-14

PM12-K7-3A17A1B402212223, SRAM c7531465, MCU1803. No programming,
external PLL/profile changes, global STOP, OE release or direction writes.
Slot6 SPI stayed driven; sampled enable/ready checks passed throughout.
This does not rule out a shorter electrical readiness/OE glitch.

Each of four PM-to-Kasli data outputs:160 isolated high/low cycles, no SYS
restart (32 completed trials total). Eight idle controls also stable.
Coupled signature-read SPI frames:
- Divider60:8/16 completed frames restarted SYS; one further frame interrupted
  by a read timeout is retained as incomplete, not counted as PASS.
- Divider600:3/9 restarted SYS.
- Divider6000:4/9 restarted SYS.
- Divider65535: two independent series each5/9 restarted SYS.

At supplied Kasli120.2361MHz these dividers correspond approximately to
1.002MHz,100.197kHz,10.020kHz and917.34Hz SCK. Long frames last35.4ms.
The first long-frame run sampled busy before a blocking read; it cannot
prove a reset while SEL was high. A timed repeat records both sides of the
read. Nominal reset epochs (read completion minus fresh SYS uptime) lie
around41–44ms after start, approximately6–8ms after expected frame completion.
This estimate assumes a running SYS clock and small final reply latency;
it is not a direct electrical reset/SEL latch. SEL deassertion is not ruled
out as a trigger, nor established as the cause.

Analysis uses observed counter decreases only. Earlier executed helpers
also used a host-time ratio, which can misclassify the sample after a delayed
read. Their derived flags are superseded by analyze_selective.py and
summary.json; all original raw data and executed helpers are preserved.

All returned signatures were correct. The data outputs were held static0
through SPI trials. Observed counter discontinuities identify SYS restarts;
this image does not directly record MMCM LOCK. No specific individual SPI
wire or MCU/external-PLL mechanism is proven. The resident SPI master lacks
independent pin overrides: SEL/SCK/MOSI were tested as coupled read frames,
not falsely labeled as individual GPIO tests. Independent overrides require
an added Kasli gateware interface; reloading Kasli would interrupt the current
driven-output condition and was not done here.

Afterwards: original HDMI mode and divider restored, SPI outputs still driven,
MCU power status healthy, frontend0xfff, samec7531465 identity, fresh physical
ADC bankA acquisition/transport PASS for12 channels. No analog controls changed.

raw.tar.gz contains all traces, executed scripts, console logs and final ADC
buffers, including the interrupted first run. summary.json and slow-spi.pdf
summarize the complete cases. Reportable samples remain historical observations,
not a blanket exclusion of data-line or EMI faults under other traffic patterns.
