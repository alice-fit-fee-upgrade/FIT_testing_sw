"""Validate 4x oversampled ADC buses without treating edge quantization as loss.

STR and data pass through independent two-stage synchronizers. The selected
word is the last sample BEFORE STR rises, and must match its preceding sample.
This is a sampled-data integrity check, not a calibrated clock-jitter test.
"""
from collections import Counter


def decode(words, bank=None, strict_edges=False):
    if len(words)!=4096 or any(type(w) is not int or not 0<=w<16384 for w in words):
        raise ValueError('Raw ADC size/reserved-bit error')
    if bank is not None and any(((w>>12)&1)!=bank for w in words):
        raise ValueError('EV selector mismatch')
    rising=[i for i in range(1,len(words)) if not words[i-1]&8192 and words[i]&8192]
    falling=[i for i in range(1,len(words)) if words[i-1]&8192 and not words[i]&8192]
    if not 1023<=len(rising)<=1024 or not 1023<=len(falling)<=1024:
        raise ValueError('Wrong ADC strobe edge count')
    gaps=[b-a for a,b in zip(rising,rising[1:])]
    spans=[]
    for edges in [rising,falling]:
        phase=[edge-4*n for n,edge in enumerate(edges)]
        spans.append(max(phase)-min(phase))
    if any(g not in (3,4,5) for g in gaps) or max(spans)>1:
        raise ValueError('ADC strobe missing/extra edge or cumulative phase drift')
    transitions=sorted(rising+falling)
    if any(not 1<=b-a<=3 for a,b in zip(transitions,transitions[1:])):
        raise ValueError('ADC strobe pulse-width error')
    if strict_edges and any(g!=4 for g in gaps):
        raise ValueError('Strict phase-alignment diagnostic: STR intervals are not all4')
    selected=[edge-1 for edge in rising[1:]]
    unstable=[index for index in selected if (words[index]^words[index-1])&4095]
    if unstable:
        raise ValueError(f'ADC word lacks two-sample stability at {len(unstable)} selected positions; first={unstable[:8]}')
    counts=Counter(gaps)
    timing=dict(status='ALIGNED' if set(counts)=={4} else 'EDGE_QUANTIZED',
                rising_edges=len(rising),falling_edges=len(falling),interval_counts=dict(counts),
                rising_phase_span_samples=spans[0],falling_phase_span_samples=spans[1],
                selected_words_stable=True,selected_word_rule='sample before STR rising, equal to its preceding ADC-data sample',
                scope='4x sampled timing/coherency; not physical clock-jitter qualification')
    return [words[i]&4095 for i in selected],timing
