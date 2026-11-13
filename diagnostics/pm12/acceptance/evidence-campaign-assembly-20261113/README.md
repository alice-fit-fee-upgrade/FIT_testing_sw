# Assembly verification, fitted group9–12 — 2026-11-13

[52-page report](report.pdf), editable [template](report.tex), [findings](assembly-findings.tex), [content](content.tex), [connection table](assembly-connections.tex), [monitor plot](monitor-assembly.png), [raw campaign](campaign-raw.tar.gz).

Board PM12-K7-3A17A1B402212223. USB stimulus stays on physical10. This is assembly verification, not an unconditional board release: 30 selected cases,28 PASS,2 FAIL,59 NOT_MEASURED.

Fresh scoped JTAG/static connections168/168 in both independent paths, MCU/FPGA32walking patterns, populated rail voltages and functional Ethernet/IPbus transfers PASS. Monitor inputs on9,10,12 PASS.

Two open findings:

* CFD fixture at11 MUX7 reads5.479V raw instead of approximately3.41V. Independently repeated. Inspect its R3=33kΩ to ground and R4=20kΩ from P5V5, soldering or intended variant. The nominal-divider equivalent8.80V is NOT a measured PM rail; independent PM telemetry is5.496V.
* HDMI walking/PRBS/idle data pass, but SYS resets on FPGA-pad release after SPI signature reads. Full HDMI case remains FAIL. Legacy boundary wrapper consequently reports ERROR after restoration; raw evidence retained. Static JTAG PASS is scoped and independently validated, with healthy ADC/TDC after restoration.

Analog9 remains NOT_MEASURED until the next USB move; fixtures1–8 are absent. Existing analog10–12 and timing9–12 remain selected with original settings. The fitted3.8V shunt is1mΩ; host conversion gives nominal3.12A from raw INA data while retaining the stale firmware flag.

Final state: diagnostic SRAM restored, MCU power protection untouched, DIO outputs released, SMU OFF/HIZ/0A, all four monitor muxes inhibited and TCA masks zero. No persistent programming or clock changes.

Reproduce offline: extract campaign-raw.tar.gz to a NEW directory; run campaign_report.py (see --help), then assembly_appendix.py --report REPORT --work EXTRACTED/batches/ch09-12-attempt001/working --latex /path/to/tectonic. Matplotlib is required. Alternatively edit the supplied TeX and run tectonic report.tex in this directory. Figures are generated from raw inputs; no hardware access is required. Test results:37acceptance and46CFD tests PASS.

Later follow-up: the PDF now prepends an erratum. Delayed SPI-related SYS resets also occur with outputs held driven. Earlier release attribution is superseded; see [raw follow-up](../../system/evidence-held-spi-20261113/README.md). The selected historical case results and raw archive are unchanged. Current direction/idle state is held, rather than released.
