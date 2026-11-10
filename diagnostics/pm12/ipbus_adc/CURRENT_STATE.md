# PM12 current state,2026-10-15

- Board S/N1803, cable210249A73E43; both PM12/Atmel-ICE leases are released after tests.
- Integrated FPGA SRAM image: build`882901f6`, USER1`504d5a04`.
- Bit SHA256:`d4026ffe30109672224951a61c43d0d6b0b5272bf9b22c9ec0d4cfc5e4ea199d`.
- Exact source/dependencies:[source-manifest.json](source-manifest.json).
- IPbus/uHAL endpoint:`192.168.2.240:50001`, MAC`02:00:00:00:12:01`.
- Frozen ADC capture5, real bankA,12x4096 samples, readable after CPLD restoration.
- CPLD NV AND SRAM restored blank, every row compared with two-pass baseline.
  A new real acquisition needs the CPLD diagnostic mux reloaded; synthetic mode
  remains available with blank CPLDs.
- I2C is input-only at FPGA. ARM only through IPbus0x100. Acquisition2 contains
  145 background events after explicit second ARM, frozen and matched via JTAG/IPbus.
- Original MCU SPI diagnostic remains active. No MCU firmware/EEPROM/fuse or FPGA
  flash writes in this work. Existing PGOOD-qualified MCU firmware is unchanged.
- UART sensors and32-pattern SPI scratch/restore regression PASS. R15 missing:
  INA5 CH1 current remains unavailable; voltage-input reporting retained.
- All recorded ADC codes are static, including zero A/B on channels3 and10.
  AFE/reference initialization and a known analog stimulus remain necessary.

```sh
python3 diagnostics/pm12/ipbus_adc/client.py --out /tmp/pm12-frozen-adc
```

Historical rollback e215a8c3... is the standalone USER1`504d5a03` analyzer and
has a known frozen-trace loss during hardware-manager close/reopen. Its command
protocol differs from this integrated image. Do not use its capture script
against USER1`504d5a04`; use the IPbus-controlled runner provided here.
