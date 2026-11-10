"""Histogram centroids for a periodic edge, including the wrap-around bins.

The centroid estimates sampled phase, not calibrated sub-bin physical delay.
No independence of successive edges or jitter distribution is assumed.
"""
from collections import Counter
import math


def scan_codes(intervals=100):
    if type(intervals) is not int or not 1 <= intervals <= 65535:
        raise ValueError('intervals must be 1..65535')
    return [(i * 65535 + intervals // 2) // intervals for i in range(intervals + 1)]


def wrapped_delta(value, reference, period):
    return (value - reference + period / 2) % period - period / 2


def histogram_centroid(histogram, period):
    if not histogram:
        raise ValueError('no rising edges')
    if any(type(k) is not int or not 0 <= k < period or
                            type(v) is not int or v < 0 for k, v in histogram.items()):
        raise ValueError('invalid histogram')
    count = sum(histogram.values())
    if not count:
        raise ValueError('no rising edges')
    anchor = max(histogram, key=lambda k: (histogram[k], -k))
    offsets = {k: wrapped_delta(k, anchor, period) for k in histogram}
    mean = sum(histogram[k] * offsets[k] for k in histogram) / count
    variance = sum(histogram[k] * (offsets[k] - mean) ** 2 for k in histogram) / count
    # Mean is meaningful only for one localized phase cluster. Broad or bimodal
    # distributions are rejected by the scan, rather than silently averaged.
    return dict(mean_bin=(anchor + mean) % period, spread_bins=math.sqrt(variance),
                occupied_span_bins=max(offsets.values()) - min(offsets.values()),
                rising_edges=count)


def estimate(rows, sample_ps, reference_bins=24, edges_per_reference=2):
    if edges_per_reference < 1 or reference_bins % edges_per_reference:
        raise ValueError('edge period must be an integer number of sample bins')
    period = reference_bins // edges_per_reference
    histogram, reference_histogram, intervals = Counter(), Counter(), Counter()
    total_samples = 0
    for row in rows:
        words = row['words']
        if not words or any(type(w) is not int or not 0 <= w <= 255 for w in words):
            raise ValueError('invalid x8 raw samples')
        previous = row['previous']
        if previous not in (0, 1):
            raise ValueError('invalid previous sample')
        rising = []
        for i, bit in enumerate((w >> b) & 1 for w in words for b in range(8)):
            if bit and not previous:
                rising.append(i)
                timestamp = row['start_sample'] + i
                histogram[timestamp % period] += 1
                reference_histogram[timestamp % reference_bins] += 1
            previous = bit
        intervals.update(b - a for a, b in zip(rising, rising[1:]))
        total_samples += len(words) * 8
    result = histogram_centroid(histogram, period)
    bad = sum(n for gap, n in intervals.items() if abs(gap - period) > 1)
    interval_count = sum(intervals.values())
    expected_edges = total_samples / period
    result.update(period_bins=period,period_ns=period*sample_ps/1000,
                  mean_ns=result['mean_bin']*sample_ps/1000,
                  histogram=dict(sorted(histogram.items())),
                  reference_histogram=dict(sorted(reference_histogram.items())),
                  interval_histogram=dict(sorted(intervals.items())),
                  unexpected_interval_fraction=bad/interval_count if interval_count else 1,
                  edge_count_ratio=result['rising_edges']/expected_edges,
                  sample_ps=sample_ps,
                  estimator='occupancy-weighted mean after circular unwrapping around histogram mode',
                  uncertainty='Not calibrated; no sqrt(N) error bar from correlated edges')
    if result['rising_edges'] < 100:
        raise ValueError('too few rising edges (minimum100)')
    if not .95 <= result['edge_count_ratio'] <= 1.05:
        raise ValueError('edge count inconsistent with selected clock frequency')
    if result['unexpected_interval_fraction'] > .01 or result['occupied_span_bins'] > 2:
        raise ValueError('signal is not a localized periodic clock')
    return result
