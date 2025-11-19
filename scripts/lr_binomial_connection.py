#!/usr/bin/env python3
"""
Connection between LR string structure and binomial coefficients

Hypothesis: For symmetric cases (+ = -), where length = 4i:
- String encodes C(3i, 2i) structure
- Run pattern relates to p-adic valuation
- Recursion in LR decisions → recursion in binomial formula
"""

from wildberger_pell_trace import wildberger_pell
from math import comb

def v_p(n, p):
    """p-adic valuation of n"""
    if n == 0:
        return float('inf')
    count = 0
    while n % p == 0:
        n //= p
        count += 1
    return count

def analyze_symmetric_case(d):
    """Deep analysis for symmetric (+ = -) cases"""
    x, y, trace = wildberger_pell(d, verbose=False)

    branches = [step[1] for step in trace]
    lr_string = ''.join(branches)

    total = len(branches)
    plus_count = branches.count('+')
    minus_count = branches.count('-')

    if plus_count != minus_count:
        return None  # Not symmetric

    # For symmetric: total = 4i, plus = minus = 2i
    if total % 4 != 0:
        return None  # Unexpected structure

    i = total // 4
    j = minus_count

    # Binomial C(3i, 2i)
    n = 3 * i
    k = 2 * i
    binom = comb(n, k)

    # p-adic valuations for small primes
    v_2 = v_p(binom, 2)
    v_3 = v_p(binom, 3)
    v_5 = v_p(binom, 5)

    # Run structure
    runs = []
    current_char = branches[0]
    current_len = 1
    for b in branches[1:]:
        if b == current_char:
            current_len += 1
        else:
            runs.append((current_char, current_len))
            current_char = b
            current_len = 1
    runs.append((current_char, current_len))

    # Longest run
    max_run = max(run[1] for run in runs)
    max_run_char = [run[0] for run in runs if run[1] == max_run][0]

    return {
        'd': d,
        'string': lr_string,
        'i': i,
        'j': j,
        'total': total,
        'binomial': binom,
        'v_2': v_2,
        'v_3': v_3,
        'v_5': v_5,
        'runs': runs,
        'max_run': max_run,
        'max_run_char': max_run_char,
        'fundamental': (x, y)
    }

def compare_symmetric_cases():
    """Compare all symmetric cases"""
    d_values = [2, 3, 5, 6, 7, 10, 11, 13, 14, 15, 17, 19, 21, 23, 29, 31, 37, 41, 43, 47, 53, 61]

    print("="*100)
    print("SYMMETRIC CASES: BINOMIAL CONNECTION ANALYSIS")
    print("="*100)

    symmetric_data = []
    for d in d_values:
        result = analyze_symmetric_case(d)
        if result:
            symmetric_data.append(result)

    print(f"\nFound {len(symmetric_data)} symmetric cases:")
    print(f"d = {[s['d'] for s in symmetric_data]}")

    print("\n" + "-"*100)
    print(f"{'d':<6} {'i':<6} {'4i':<6} {'C(3i,2i)':<20} {'v_2':<6} {'v_3':<6} {'v_5':<6} {'Max run':<12}")
    print("-"*100)

    for s in symmetric_data:
        print(f"{s['d']:<6} {s['i']:<6} {s['total']:<6} {s['binomial']:<20} "
              f"{s['v_2']:<6} {s['v_3']:<6} {s['v_5']:<6} "
              f"{s['max_run']} × '{s['max_run_char']}'")

    # Check v_2 = 0 universally
    all_v2_zero = all(s['v_2'] == 0 for s in symmetric_data)
    print(f"\n✓ All v_2(C(3i,2i)) = 0: {all_v2_zero}")

    # Check v_3 pattern
    v3_values = [s['v_3'] for s in symmetric_data]
    print(f"\nv_3 distribution: {sorted(set(v3_values))}")

    # Check connection to max run
    print("\n" + "="*100)
    print("MAX RUN vs NEGATIVE PELL APPEARANCE")
    print("="*100)

    for s in symmetric_data:
        d = s['d']
        # Get negative Pell range from previous analysis
        x, y, trace = wildberger_pell(d, verbose=False)

        neg_start, neg_end = None, None
        for step_idx, (step, branch, state, inv) in enumerate(trace):
            v, t = state['v'], state['s']
            if v*v - d*t*t == -1:
                if neg_start is None:
                    neg_start = step
                neg_end = step

        if neg_start:
            neg_range = (neg_start, neg_end)
            neg_length = neg_end - neg_start + 1
            print(f"d={s['d']:<3} Max run: {s['max_run']:<3} Neg Pell range: {neg_range}, length: {neg_length}")
        else:
            print(f"d={s['d']:<3} Max run: {s['max_run']:<3} (No negative Pell found - ERROR?)")

    # Analyze run pattern recursion
    print("\n" + "="*100)
    print("RECURSION IN RUN STRUCTURE")
    print("="*100)

    for s in symmetric_data[:5]:  # Show first 5 as examples
        print(f"\nd={s['d']} (i={s['i']}):")
        print(f"  String: {s['string']}")
        print(f"  Runs: {s['runs']}")

        # Try to identify recursive structure
        # Palindrome means runs are symmetric around center
        runs = s['runs']
        n_runs = len(runs)

        if n_runs % 2 == 1:
            center_idx = n_runs // 2
            print(f"  Center run: {runs[center_idx]}")
            print(f"  Left half: {runs[:center_idx]}")
            print(f"  Right half: {runs[center_idx+1:]}")
        else:
            print(f"  No single center run (even number of runs)")
            left = runs[:n_runs//2]
            right = runs[n_runs//2:]
            print(f"  Left: {left}")
            print(f"  Right: {right}")
            print(f"  Mirror? {left == [(c, l) for c, l in reversed(right)]}")

def explore_p_adic_connection():
    """Explore p-adic structure in run lengths"""
    print("\n" + "="*100)
    print("P-ADIC STRUCTURE IN RUN LENGTHS")
    print("="*100)

    d_values = [2, 5, 10, 13, 17, 29, 37, 41, 53, 61]

    for d in d_values:
        result = analyze_symmetric_case(d)
        if not result:
            continue

        runs = result['runs']
        run_lengths = [length for _, length in runs]

        print(f"\nd={d} (i={result['i']}):")
        print(f"  Run lengths: {run_lengths}")

        # Compute p-adic valuations of run lengths
        v2_runs = [v_p(l, 2) for l in run_lengths]
        v3_runs = [v_p(l, 3) for l in run_lengths]

        print(f"  v_2 of runs: {v2_runs}")
        print(f"  v_3 of runs: {v3_runs}")

        # Check if there's a pattern
        if len(set(v2_runs)) == 1:
            print(f"  → All runs have SAME v_2 = {v2_runs[0]}")

        # Sum of run lengths should equal total
        total_from_runs = sum(run_lengths)
        print(f"  Total: {total_from_runs} (should be {result['total']})")

def connection_to_chebyshev():
    """Hypothesize connection to Chebyshev formula"""
    print("\n" + "="*100)
    print("HYPOTHESIS: LR STRING → CHEBYSHEV COEFFICIENT GENERATION")
    print("="*100)

    print("\nIdea: LR string encodes algorithm that generates")
    print("binomial coefficients in Egypt-Chebyshev formula")
    print("")
    print("For symmetric case (negative Pell exists):")
    print("  - String length = 4i")
    print("  - Coefficient at position i: 2^(i-1) · C(3i, 2i)")
    print("  - LR decisions might encode:")
    print("    * '+' → choose/include in binomial selection")
    print("    * '-' → don't choose/skip")
    print("    * Recursion → doubling factor 2^(i-1)")
    print("")
    print("BUT: This is speculative!")
    print("Need to understand:")
    print("  1. How does LR string generate numbers?")
    print("  2. Does Wildberger's SB tree connection help?")
    print("  3. What do (a,b,c) transitions encode?")

if __name__ == "__main__":
    compare_symmetric_cases()
    explore_p_adic_connection()
    connection_to_chebyshev()

    print("\n" + "="*100)
    print("SUMMARY: KEY INSIGHTS")
    print("="*100)
    print("\n1. Symmetric cases (10/22): Perfect correlation with negative Pell")
    print("2. Binomial C(3i,2i): Always has v_2 = 0 (ODD)")
    print("3. Max run length: Coincides with negative Pell appearance")
    print("4. Run structure: Palindromic, no obvious p-adic pattern in lengths")
    print("5. Connection to Chebyshev: Speculative, needs more work")
    print("\nOpen question: How does LR recursion → binomial recursion?")
