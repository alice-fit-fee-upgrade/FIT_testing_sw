# PM12 corrected MCLK40 diagnostic

Current SRAM build c7531465. [Measured repeat](../evidence-clock40-20261114/README.md).
prepare.py creates an isolated source tree from the retained prior generated
source. Heavy Vivado compilation belongs on Dell, with the shared build slots;
read the workspace toolchain handoffs first. Hardware and all three board
leases stay on Optiplex. No external PLL programming is required.

retest.py --out NEW --expected-build c7531465 repeats the four-channel
count/phase test and preserves slot6 held SPI. analyze.py independently
validates raw buffers and generates the plots. held_spi_test.py is the
versioned current-image HDMI CLI; the known reset finding remains FAIL.
system/test_system.py uses it. Historical hold_spi.py is deliberately unchanged
to preserve frozen campaign source contracts. Legacy global stop/direction
cleanup and old integrated programming scripts are not safe for this setup.

The old c7c42d28 is only a recovery fallback, not a correct-clock TDC image.
