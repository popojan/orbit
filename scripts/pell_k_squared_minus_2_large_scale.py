#!/usr/bin/env python3
"""
Large-scale verification of k² - 2 theorem.

Test hypothesis on 100+ primes to ensure pattern holds.
"""

from sympy import sqrt, isprime
from sympy.ntheory.continued_fraction import continued_fraction_periodic
import subprocess

def pell_solution(D):
    """Get (x₀, y₀) from CF."""
    if int(sqrt(D))**2 == D:
        return None
    cf = continued_fraction_periodic(0, 1, D)
    period = cf[1]
    h_prev, h_curr = 1, cf[0]
    k_prev, k_curr = 0, 1
    for _ in range(2 * len(period)):
        for a in period:
            h_next = a * h_curr + h_prev
            k_next = a * k_curr + k_prev
            if h_next**2 - D * k_next**2 == 1:
                return (h_next, k_next)
            h_prev, h_curr = h_curr, h_next
            k_prev, k_curr = k_curr, k_next
    return None

def class_number(D):
    """Get h(D) from PARI."""
    try:
        disc = D if D % 4 == 1 else 4 * D
        result = subprocess.run(
            ['gp', '-q', '-f'],
            input=f'print(qfbclassno({disc}))\n',
            capture_output=True, text=True, timeout=10
        )
        return int(result.stdout.strip()) if result.returncode == 0 else None
    except:
        return None

def large_scale_test():
    """Test k² - 2 formula for k ≤ 1000."""

    print("=" * 80)
    print("LARGE SCALE VERIFICATION: p = k² - 2 formula")
    print("=" * 80)
    print()

    print("Testing k ∈ [2, 1000]...")
    print("Progress: ", end="", flush=True)

    results = []
    failures = []

    k_max = 1000

    for k in range(2, k_max + 1):
        if k % 100 == 0:
            print(f"{k} ", end="", flush=True)

        p = k**2 - 2

        if not isprime(p):
            continue

        # Predicted solution
        x0_pred = k**2 - 1
        y0_pred = k

        # Computed solution
        sol = pell_solution(p)
        if sol is None:
            failures.append({
                'k': k,
                'p': p,
                'reason': 'No Pell solution found'
            })
            continue

        x0_comp, y0_comp = sol

        # Verify
        match_x = (x0_comp == x0_pred)
        match_y = (y0_comp == y0_pred)

        if not (match_x and match_y):
            failures.append({
                'k': k,
                'p': p,
                'x0_pred': x0_pred,
                'y0_pred': y0_pred,
                'x0_comp': x0_comp,
                'y0_comp': y0_comp,
                'reason': 'Formula mismatch'
            })

        # Period
        cf = continued_fraction_periodic(0, 1, p)
        tau = len(cf[1])

        # Class number (expensive, skip for very large p)
        if p < 100000:
            h = class_number(p)
        else:
            h = None

        results.append({
            'k': k,
            'p': p,
            'tau': tau,
            'h': h,
            'match': match_x and match_y
        })

    print(f"\n\nCompleted!")
    print()

    # Summary
    print("=" * 80)
    print("RESULTS SUMMARY")
    print("=" * 80)
    print()

    total = len(results)
    matches = sum(1 for r in results if r['match'])

    print(f"Total primes tested: {total}")
    print(f"Formula matches:     {matches}/{total} = {100*matches/total:.2f}%")
    print()

    if failures:
        print(f"FAILURES: {len(failures)}")
        for f in failures:
            print(f"  k={f['k']}, p={f['p']}: {f['reason']}")
            if 'x0_pred' in f:
                print(f"    Predicted: ({f['x0_pred']}, {f['y0_pred']})")
                print(f"    Computed:  ({f['x0_comp']}, {f['y0_comp']})")
    else:
        print("✓ NO FAILURES - Formula verified for all cases!")

    print()

    # Period distribution
    tau_vals = [r['tau'] for r in results]
    from collections import Counter
    tau_dist = Counter(tau_vals)

    print("Period τ distribution:")
    for tau, count in sorted(tau_dist.items()):
        pct = 100 * count / total
        print(f"  τ = {tau:2d}: {count:4d} primes ({pct:5.2f}%)")

    print()

    tau_4_count = tau_dist.get(4, 0)
    print(f"τ = 4 frequency: {tau_4_count}/{total} = {100*tau_4_count/total:.2f}%")

    print()

    # Class number distribution (for p < 100000 only)
    results_with_h = [r for r in results if r['h'] is not None]

    if results_with_h:
        print(f"Class number distribution ({len(results_with_h)} primes with p < 100000):")
        print()

        h_vals = [r['h'] for r in results_with_h]
        h_dist = Counter(h_vals)

        for h_val, count in sorted(h_dist.items()):
            pct = 100 * count / len(results_with_h)
            print(f"  h = {h_val:3d}: {count:4d} primes ({pct:5.2f}%)")

        print()

        h1_count = h_dist.get(1, 0)
        h_gt_1_count = len(results_with_h) - h1_count

        print(f"h = 1:  {h1_count}/{len(results_with_h)} = {100*h1_count/len(results_with_h):.2f}%")
        print(f"h > 1:  {h_gt_1_count}/{len(results_with_h)} = {100*h_gt_1_count/len(results_with_h):.2f}%")

        print()
        print("Comparison with general population:")
        print("  General p ≡ 7 (mod 8): ~16% have h>1")
        print(f"  k²-2 primes:           {100*h_gt_1_count/len(results_with_h):.1f}% have h>1")

    print()
    print("=" * 80)

    return results, failures

if __name__ == "__main__":
    results, failures = large_scale_test()

    # Export for further analysis
    if not failures:
        print("\n✓ Formula VERIFIED on large scale")
        print(f"  Confidence: 100% ({len(results)} test cases)")
