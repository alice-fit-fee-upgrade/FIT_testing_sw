"""Generate editable LaTeX chapter from measured SMU DAC curves."""
import argparse
import json
from pathlib import Path

TEMPLATE = r'''\documentclass[a4paper,11pt]{article}
\usepackage[margin=20mm]{geometry}
\usepackage{graphicx,booktabs,hyperref}
\begin{document}
\title{PM12 CFD simulator DAC characterization}
\author{FIT hardware acceptance bench}
\date{10 November 2026}\maketitle
\section{Identification and connections}
Board: PM12-K7-3A17A1B402212223 (previous FPGA DNA identification).
MCU EEPROM serial 1803 was checked in this session.
Four CFD simulators occupy physical PM channels 12, 10, 8 and 6.
Their analog monitor outputs share one measurement bus. Only one MAX4051
monitor output is enabled at a time. All four monitors are inhibited between
transfer curves and on exit. Other GPIO controls are preserved.

Instrument: Keysight B2910BL, serial MY63320299. The monitor bus connects to
Force HI/LO; Sense is unconnected. Local (2-wire) voltage measurement is used,
with a current source setting of 0 A, 1 microampere source range,
6 V compliance, 20 V measurement range and 1 PLC integration.
OUTP is enabled during measurement; automatic output-on is disabled.
OUTP OFF/high impedance is restored on exit. The owner explicitly confirmed
Force wiring and authorized 0 A/OUTP ON operation.
\section{Procedure and scope}
The remaining channels 10, 8 and 6 are scanned. DAC B is observed through
DRV\_OFFSET (monitor 3), DAC C through CFD\_OFFSET (monitor 0), and DAC D
through CFD\_CMP\_OFFSET (monitor 1). Phase DAC A is unchanged.
The resistor networks produce decreasing spans of approximately 40 mV for B
and 20 mV for C, and an increasing span of approximately 1.06 V for D.

Each DAC is scanned over 101 rounded integer codes spanning 0--65535, with
three fresh READ? samples per code and 100 ms settling after each write.
Compliance, protection and overflow bits are checked. Raw status words and
timestamps are retained; unspecified status bits are ignored per the Keysight
SCPI reference, Table 1-2. Each exercised DAC is explicitly set to 0000 on exit.
STORED firmware parameters are not treated as active hardware readback.

This is a functional DC transfer scan, not exhaustive 16-bit INL/DNL or a
calibrated accuracy certificate. Three repeats estimate short-term scatter.
No independent calibrated reference was available; freshness was checked by
switching between the 1.3 V rail and DRV\_VOCM on channel 12.
\section{Measured endpoint summary}
\begin{center}\begin{tabular}{rr rrr r}\toprule
PM ch. & DAC & Code 0 (V) & Code 65535 (V) & Span (V) & Max. $s$ ($\mu$V)\\\midrule
%%ENDPOINT_ROWS%%
\bottomrule\end{tabular}\end{center}
\clearpage
\section{Transfer curves}
\begin{center}\includegraphics[width=\textwidth]{dac-transfer.pdf}\end{center}
The physical channels are overlaid for each DAC.
\begin{center}\includegraphics[width=\textwidth]{dac-channel-differences.pdf}\end{center}
Differences use channel 10 as reference within the same run.
\clearpage
\section{Gain and lower endpoint behavior}
All nine curves are monotonic on the sampled grid. Gain is fitted over
5--95\% of the code range and compared with the nominal DAC/resistor scaling.
The gain deviations below characterize the complete analog chain.
The zero-code residual compares the measured minimum-code voltage with the
extrapolated interior fit. DAC D shows a distinct lower-end departure;
this scan alone does not locate its cause within the DAC and analog stages.
\begin{center}\begin{tabular}{rr rr}\toprule
PM ch. & DAC & Interior gain error (\%) & Zero-code residual (mV)\\\midrule
%%FIT_ROWS%%
\bottomrule\end{tabular}\end{center}
\section{Evidence and final state}
Raw samples: \texttt{samples.csv}. Statistics: \texttt{summary.csv/json}.
Commands, I2C readbacks, restoration receipts, instrument identity and final
state: \texttt{scan-report.json}. Completeness and status checks are in
\texttt{validation.json}; their PASS is not a calibrated analog acceptance limit.
Figures: \texttt{plot\_smu\_dacs.py}; editable chapter:
\texttt{report\_smu\_dacs.py}.
\paragraph{Acquisition completed:} %%COMPLETED%%.
\paragraph{Final SMU output:} %%OUTPUT%% (0 means OFF).
All nine DAC restoration receipts confirm raw code 0000. Final mux inhibition
and disconnected upstream TCA masks are checked before releasing the leases.
\end{document}
'''


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('directory', type=Path)
    d = p.parse_args().directory
    rows = json.loads((d/'summary.json').read_text())
    r = json.loads((d/'scan-report.json').read_text())
    validation = json.loads((d/'validation.json').read_text())
    if not validation['pass_']:
        raise ValueError('Validate acquisition before generating the report')
    endpoints = '\n'.join(
        f"{x['pm_channel']} & {x['dac']} & {x['min_code_V']:.6f} & "
        f"{x['max_code_V']:.6f} & {x['span_V']:.6f} & {x['max_repeatability_std_uV']:.1f} \\\\"
        for x in rows)
    fits = '\n'.join(
        f"{x['pm_channel']} & {x['dac']} & {x['interior_gain_error_percent']:.3f} & "
        f"{x['zero_code_residual_mV']:.3f} \\\\" for x in rows)
    text = TEMPLATE.replace('%%ENDPOINT_ROWS%%',endpoints).replace('%%FIT_ROWS%%',fits)
    text = text.replace('%%COMPLETED%%',str(r.get('scan_complete',False)))
    text = text.replace('%%OUTPUT%%',str(r.get('final',{}).get('OUTP?','UNCONFIRMED')))
    (d/'report.tex').write_text(text)

if __name__ == '__main__':
    main()
