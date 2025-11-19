#!/usr/bin/env python3
"""
Analyze simple vs complex using regulator R(d) = log(x + y√d)

Better than absolute x because it's the natural size measure
"""

import math
from wildberger_pell_trace import wildberger_pell

def regulator(x, y, d):
    """R(d) = log(x + y√d)"""
    return math.log(x + y * math.sqrt(d))

def classify_and_measure(d_values):
    """Measure regulator for simple vs complex"""
    simple = []
    complex_cases = []

    for d in d_values:
        x, y, trace = wildberger_pell(d, verbose=False)

        branches = [step[1] for step in trace]
        plus = branches.count('+')
        minus = branches.count('-')

        if plus != minus:
            continue  # Skip asymmetric

        # Check if simple [i, 2i, i]
        runs = []
        current_char = branches[0]
        current_len = 1
        for b in branches[1:]:
            if b == current_char:
                current_len += 1
            else:
                runs.append(current_len)
                current_char = b
                current_len = 1
        runs.append(current_len)

        i = len(branches) // 4
        is_simple = (len(runs) == 3 and runs == [i, 2*i, i])

        R = regulator(x, y, d)
        R_normalized = R / math.log(d)  # Normalize by input size

        data = {
            'd': d,
            'x': x,
            'y': y,
            'R': R,
            'R_norm': R_normalized,
            'log_x': math.log(x),
            'i': i,
            'is_simple': is_simple
        }

        if is_simple:
            simple.append(data)
        else:
            complex_cases.append(data)

    return simple, complex_cases

if __name__ == "__main__":
    symmetric_d = [2, 5, 10, 13, 17, 29, 37, 41, 53, 61]

    simple, complex_cases = classify_and_measure(symmetric_d)

    print("="*80)
    print("REGULATOR ANALYSIS: Simple vs Complex")
    print("="*80)

    print("\nSIMPLE CASES:")
    print(f"{'d':<6} {'i':<6} {'x':<12} {'R(d)':<12} {'R/log(d)':<12}")
    print("-"*80)
    for s in simple:
        print(f"{s['d']:<6} {s['i']:<6} {s['x']:<12} {s['R']:<12.4f} {s['R_norm']:<12.4f}")

    print("\nCOMPLEX CASES:")
    print(f"{'d':<6} {'i':<6} {'x':<15} {'R(d)':<12} {'R/log(d)':<12}")
    print("-"*80)
    for c in complex_cases:
        print(f"{c['d']:<6} {c['i']:<6} {c['x']:<15} {c['R']:<12.4f} {c['R_norm']:<12.4f}")

    # Find threshold
    simple_R_max = max(s['R'] for s in simple)
    complex_R_min = min(c['R'] for c in complex_cases)

    print("\n" + "="*80)
    print("THRESHOLD ANALYSIS")
    print("="*80)
    print(f"\nSimple max R(d):   {simple_R_max:.4f}  (d={[s['d'] for s in simple if s['R'] == simple_R_max][0]})")
    print(f"Complex min R(d):  {complex_R_min:.4f}  (d={[c['d'] for c in complex_cases if c['R'] == complex_R_min][0]})")
    print(f"Gap: [{simple_R_max:.4f}, {complex_R_min:.4f}]")

    # Normalized threshold
    simple_Rn_max = max(s['R_norm'] for s in simple)
    complex_Rn_min = min(c['R_norm'] for c in complex_cases)

    print(f"\nNormalized R/log(d):")
    print(f"Simple max:   {simple_Rn_max:.4f}")
    print(f"Complex min:  {complex_Rn_min:.4f}")

    # Check correlation with i
    print("\n" + "="*80)
    print("R(d) vs i")
    print("="*80)

    all_data = simple + complex_cases
    all_data.sort(key=lambda x: x['i'])

    print(f"\n{'Type':<10} {'d':<6} {'i':<6} {'R(d)':<12} {'R/i':<12}")
    print("-"*80)
    for item in all_data:
        typ = "SIMPLE" if item['is_simple'] else "complex"
        R_per_i = item['R'] / item['i']
        print(f"{typ:<10} {item['d']:<6} {item['i']:<6} {item['R']:<12.4f} {R_per_i:<12.4f}")

    # Ratio analysis
    print("\n" + "="*80)
    print("R(d) / i Analysis")
    print("="*80)

    simple_ratios = [s['R'] / s['i'] for s in simple]
    complex_ratios = [c['R'] / c['i'] for c in complex_cases]

    print(f"\nSimple R/i:  mean={sum(simple_ratios)/len(simple_ratios):.4f}, "
          f"range=[{min(simple_ratios):.4f}, {max(simple_ratios):.4f}]")
    print(f"Complex R/i: mean={sum(complex_ratios)/len(complex_ratios):.4f}, "
          f"range=[{min(complex_ratios):.4f}, {max(complex_ratios):.4f}]")

    if max(simple_ratios) < min(complex_ratios):
        threshold = (max(simple_ratios) + min(complex_ratios)) / 2
        print(f"\n✓ DISJOINT! Threshold R/i ≈ {threshold:.4f}")
    else:
        print(f"\n✗ Overlapping ranges")
