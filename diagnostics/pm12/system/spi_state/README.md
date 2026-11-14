# SPI-state / clock-reset correlation

Read-only debug ports expose the original HDMI parser's bit counter, reading
flag, address and shift register. Parser behavior is unchanged; debug fanout
and placement can still affect an intermittent condition. IDLE is a decoded
condition(HSEL0,count0,reading0), not a new state introduced in the parser.
The parser has no SYS reset input; idle before SYS reset is not a consequence
of resetting that parser with SYS.

Observer uses nominal40.0787MHz MCLK1 via the existing input passthrough and
a dedicated BUFG; it is not reset with SYS. It records input pins, internal
MISO data (pad is tristated when HSEL0), actual parser fields, fixed/CAP/GTX
LOCK, SYS reset, fixed-MMCM RST and PWRDWN, plus reference heartbeat age.
Frozen records are3words/event: tick; controls+state/address; shift+ages.
Registers380..384 identify/ARM/status/count/frequency/format; memory8000..85ff.
Only magic41524d31 at380 arms it. First8 ticks are ARM/latch settling.

SPI debug buses are sampled asynchronously. Two equal samples set stable;
this is not an atomic CDC guarantee. At observed resets fields are stable
and have been idle for milliseconds. Timing is nominal running watch-clock
time; a common watch/reference clock stop is not represented. Heartbeat age
cannot exclude phase noise, narrow glitches or input-clock degradation.
Capture freezes at1nominal second,512events, or1024ticks after detected reset.

prepare.py derives from exact corrected-clockc7531465 generated HDL. Build
prepared sources on Dell with shared slots; old Migen regeneration omits
instrumentation. spi-state-build.json is the derivative manifest. TB covers
state capture/readout, reset survival, rearm and short LOCK-loss latching.
audit*.tcl inspect original/observer routed checkpoints and actual MMCM fanin.
No logical signal name is treated as proof of its physical connection.

test_state.py --work ROOT uses all three physical board leases, DNA and MCU
identity checks, leaves Kasli driven/unchanged, loads PM SRAM temporarily,
captures SPI/idle cases and restores exactc7531465 finally. Subsequent revision
saves frozen raw records BEFORE ancillary uptime reads, retaining them even
if that optional read times out. The executed.py in raw evidence is authoritative
for the measured series, which used the earlier save order.

analyze.py --result EXTRACTED/hardware/result.json --out NEW_DIR decodes data;
plot.py --summary NEW_DIR/summary.json --out NEW_DIR generates scientific plots.
A partial series is not reported as a completed full sweep. Missing captures
are unknown, not stable PASS. GPIO/clock/profile/flash settings are not changed.
