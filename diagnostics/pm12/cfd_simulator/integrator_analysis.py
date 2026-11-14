"""Signed adjacent-sample change on the observed high-level integration pair.

Capture start has no integrator-cycle phase tag. Align the four-phase template
by its highest adjacent pair; reject clipped data and ambiguous pair selection.
This is waveform-based phase assignment, not a measured external gate epoch.
"""
import math
import statistics


def integration_pair(samples, minimum_separation=30):
    if len(samples) < 40 or any(not math.isfinite(v) or not 0 <= v <= 4095 for v in samples):
        raise ValueError('Invalid ADC samples')
    if any(v <= 1 or v >= 4094 for v in samples):
        raise ValueError('Clipped ADC samples cannot establish balance')
    n = len(samples)//4*4
    x = samples[:n]
    means = [statistics.mean(x[i::4]) for i in range(4)]
    scores = [means[i]+means[(i+1)%4] for i in range(4)]
    order = sorted(range(4), key=lambda i:scores[i], reverse=True)
    if scores[order[0]]-scores[order[1]] < minimum_separation:
        raise ValueError('Ambiguous integration/reset template')
    phase = order[0]
    changes = [x[i+1]-x[i] for i in range(phase,n-1,4)]
    reset = (phase+2)%4
    reset_changes = [x[i+1]-x[i] for i in range(reset,n-1,4)]
    return dict(phase=phase, phase_means=means, mean_change=statistics.mean(changes),
                change_std=statistics.pstdev(changes), cycles=len(changes),
                mean_reset_change=statistics.mean(reset_changes),
                pair_score_margin=scores[order[0]]-scores[order[1]])
