"""B2900 voltage sample validation, SCPI Reference Table 1-2.

Bits absent from the table must be ignored, not treated as failures. Bit0
indicates current sourcing; bits1..5 and13 report compliance/protection/overflow.
"""
import math

FAULT_MASK = 0x203e

def parse_voltage(reply):
    values = [float(x) for x in reply.split(',')]
    if len(values) != 3:
        raise ValueError('Expected VOLT,TIME,STAT')
    voltage, timestamp, raw_status = values
    if not all(math.isfinite(x) for x in values):
        raise ValueError('Nonfinite SMU data')
    if abs(voltage) > 10 or timestamp < 0 or not raw_status.is_integer():
        raise ValueError('Invalid/overrange SMU data')
    status = int(raw_status)
    if status < 0 or status & FAULT_MASK:
        raise ValueError(f'SMU compliance/protection/overflow: {status}')
    if not status & 1:
        raise ValueError('SMU was not in current-source mode')
    return voltage, timestamp, status
