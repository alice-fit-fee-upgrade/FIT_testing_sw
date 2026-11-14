# PM12 clock audit —2026-11-14

No programming, PLL profile/EEPROM writes, SPI probe, Kasli STOP/OE release or direction changes. MCU background power protection remains running. Board PM12-K7-3A17A1B402212223 / MCU1803 / resident c7c42d28. Kasli remains enable1/status9, slot6 mask00b0.

## Established clock tree

HDMI brings the supplied40.0787MHz to CDCE62005 DD3 PRI_REF. Its AUX input uses the onboard nominal40MHz crystal. The installed-candidate firmware startup table at FLASH0x2916..0x293d matches the retained deployed-image SHA f49643c80c6189afebdaa3f7301f4ecebacb55645e60456f66831106d38b9464. Fresh RS reports PRIMARY/PLL LOCKED.

|CDCE output|Firmware divider|Frequency with40.0787MHz primary|Schematic destination|
|---|---:|---:|---|
|U0|10|40.0787MHz|PLL_CLK0→ADCLK854 DD19→12channel reference branches|
|U1|2|200.3935MHz|TDC_CLK→ADCLK846 DD26→TDC_CLK1/2/3|
|U2|10|40.0787MHz|TDC_SYNC→ADCLK846 DD27→MCLK1/2/3|
|U3|2|200.3935MHz|PLL_CLK3→Kintex MGT reference|
|U4|disabled|none|Unused/NC on schematic|

MCLK1 reaches Kintex AA3/AA2 (schematic sheets2,3,27). Main SYS is separately generated from MGT:200.3935/2×12/30=40.0787MHz; CAP=SYS×8=320.6296MHz. MCLK1 is used by the TDC frontend and was used by the temporary independent SYS-reset observer.

Profile calculation: primary predivide1, reference divide1, PLL input divide2, feedback divide20, feedback bypass1; SYNTH=400.787MHz and prescaler5 gives internal VCO2003.935MHz. Output dividers act on SYNTH, not directly on that internal VCO. Startup R5 selects AUX; recovered PLL-lock ISR changes R5 from40040F35 to40040FF5 for automatic PRI→SEC→AUX selection. It does not change output dividers. The separate legacy PC command would load a different output-disable profile; it was not issued.

This is a decoded firmware profile plus physical frequency-ratio checks, **not a newly read dump of all active CDCE RAM registers**. Existing @PLL reads status8 only; arbitrary register read is not exposed by the resident console. U0/U1 settings are source-derived. MCLK1 was corroborated by the independent recorder; MGT by the SYS clock chain and live counters. No reset/reflash was used to obtain the profile.

## Fresh physical checks

Three2second intervals against host monotonic time give Kasli SYS120.2295–120.2374MHz and PM SYS40.0783–40.0814MHz. Kasli MGT-reference monitor counts60.1172–60.1177MHz after its divide2, consistent with120.2361MHz reference. These establish120MHz versus40MHz, not calibrated ppm accuracy; network sampling latency is retained in raw records.

Fresh physical ADC bankA/channel12 capture:1023successive STR rising gaps, all4CAP ticks. Thus the local CLK80/STR signal is approximately80.1574MHz with CAP320.6296MHz. **Do not equate this local ADC strobe with the40.0787MHz CDCE U0 reference branch.** Local/AFE clock generation is a separate path; its full topology is not inferred from these two frequencies alone.

Kasli return lanes8/9 (PM12 integrator A/B): rising gaps all48serial sample ticks (84and85intervals). At approximately961.8888MS/s this is20.03935MHz, matching the local CPLD CLK80 divide4. Both USBs stay on physical10; no stimulus or analog control was changed. The fresh captures replace only volatile diagnostic buffers, not historical campaign files.

## Concrete TDC gateware mismatch

The resident-source TDC frontend declares MCLK120MHz and sets MMCM DIVCLK_DIVIDE=3, CLKFBOUT_MULT_F=30, CLKOUT0/1 divide2 and CLKOUT2 divide4. MCLK1 is40.0787MHz, so those parameters imply VCO400.787MHz and outputs200.3935/100.19675MHz, rather than intended approximately600/300MHz. Minimum MMCM VCO in DS182 table41 is600MHz. This is an actual clock-configuration mismatch to correct; functional TDC event responses do not qualify operation outside that range. MCLK2/3 share DD27's same source, but have not been independently frequency-counter measured here.

This finding **does not prove the separate SYS-MMCM lock-loss root cause**. Its clock source/configuration differs. No Texas PLL settings or FPGA image were changed during this audit; do not silently change external outputs to make incorrect HDL assumptions fit. No historical raw measurements or case statuses were overwritten.

Sources: [TI CDCE62005 SCAS862G](https://www.ti.com/lit/ds/symlink/cdce62005.pdf), tables8/9/13/22/23/24/26/38 and40–48; [AMD Kintex-7 DS182](https://docs.amd.com/v/u/en-US/ds182_Kintex_7_Data_Sheet), table41. Local PM12v1.1 schematic sheets2/3/27 and retained firmware/source excerpts are the board-specific evidence. [Decoded profile](profile.json),[live counters](counters.json),[fresh ADC/gate records](local-clocks.json).

Offline decoder: `python3 ../decode_cdce_profile.py --firmware /path/to/development.bin --reference-hz 40078700 --out profile.json`. The expected40MHz/40.0787MHz profiles were checked independently of hardware access. Unknown divider codes fail closed.
