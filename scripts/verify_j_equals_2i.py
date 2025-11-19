#!/usr/bin/env python3
"""
Verify the j = 2i pattern across multiple d values
Testing hypothesis: Wildberger algorithm always has equal '+' and '-' branches
Which implies: j (minus count) = 2i (plus count)
"""

from wildberger_pell_trace import wildberger_pell


def quick_stats(d):
    """Get quick statistics for given d"""
    x, y, trace = wildberger_pell(d, verbose=False)

    total = len(trace)
    branches = [t[1] for t in trace]
    plus = branches.count('+')
    minus = branches.count('-')

    # Check if j = 2i
    if plus % 2 == 0:
        i = plus // 2
        j = minus
        j_equals_2i = (j == 2 * i)
    else:
        i = None
        j = minus
        j_equals_2i = False

    return {
        'd': d,
        'fundamental': (x, y),
        'total_steps': total,
        'plus': plus,
        'minus': minus,
        'i': i,
        'j': j,
        'j_equals_2i': j_equals_2i,
        'perfect_symmetry': (plus == minus)
    }


def test_multiple_d_values(d_values):
    """Test multiple d values"""
    print("="*80)
    print("TESTING j = 2i PATTERN ACROSS MULTIPLE sqrt(d)")
    print("="*80)

    results = []
    for d in d_values:
        print(f"\nTesting d = {d}...")
        stats = quick_stats(d)
        results.append(stats)

        print(f"  Fundamental solution: ({stats['fundamental'][0]}, {stats['fundamental'][1]})")
        print(f"  Total steps: {stats['total_steps']}")
        print(f"  '+' branches: {stats['plus']}")
        print(f"  '-' branches: {stats['minus']}")
        print(f"  Perfect symmetry (+ = -)? {stats['perfect_symmetry']}")

        if stats['i'] is not None:
            print(f"  i = {stats['i']}, j = {stats['j']}")
            print(f"  j = 2i? {stats['j_equals_2i']} ({stats['j']} = 2·{stats['i']})")
        else:
            print(f"  WARNING: '+' count ({stats['plus']}) is ODD - cannot define i as plus/2")

    # Summary table
    print("\n" + "="*80)
    print("SUMMARY TABLE")
    print("="*80)
    print(f"\n{'d':<8} {'Steps':<10} {'+':<8} {'-':<8} {'i':<8} {'j':<8} {'j=2i?':<10} {'+=-?'}")
    print("-"*80)

    for s in results:
        i_str = str(s['i']) if s['i'] is not None else "N/A"
        j_2i = "✓" if s['j_equals_2i'] else "✗"
        symmetry = "✓" if s['perfect_symmetry'] else "✗"

        print(f"{s['d']:<8} {s['total_steps']:<10} {s['plus']:<8} {s['minus']:<8} "
              f"{i_str:<8} {s['j']:<8} {j_2i:<10} {symmetry}")

    # Check if pattern holds universally
    all_symmetric = all(s['perfect_symmetry'] for s in results)
    all_j_2i = all(s['j_equals_2i'] for s in results if s['i'] is not None)

    print("\n" + "="*80)
    print("CONCLUSIONS")
    print("="*80)

    print(f"\n1. Perfect symmetry (+ = -):")
    print(f"   Holds for ALL tested cases? {all_symmetric}")
    if all_symmetric:
        print(f"   → Universal property: Wildberger algorithm has equal '+' and '-' branches!")

    print(f"\n2. j = 2i property:")
    print(f"   Holds for all cases with even '+' count? {all_j_2i}")
    if all_symmetric and all_j_2i:
        print(f"   → Combined: Since + = - and j = 2i, we have:")
        print(f"     j = minus count")
        print(f"     2i = plus count")
        print(f"     j = 2i ⟹ minus count = plus count ✓")
        print(f"   → Total steps = j + 2i = 2i + 2i = 4i")

    print(f"\n3. Binomial simplification:")
    if all_symmetric and all_j_2i:
        print(f"   C(j+i, 2i) = C(2i+i, 2i) = C(3i, 2i)")
        print(f"   Formula term: 2^(i-1) · C(3i, 2i)")
        print(f"\n   Examples:")
        for s in results:
            if s['i'] is not None:
                n = 3 * s['i']
                k = 2 * s['i']
                print(f"   d={s['d']}: i={s['i']} → 2^{s['i']-1} · C({n}, {k})")

    return results


if __name__ == "__main__":
    # Test various d values
    # Include: squares-1 (no Pell solution), small primes, composite
    test_values = [2, 3, 5, 6, 7, 10, 11, 13, 14, 15, 17, 19, 21, 23, 29, 31, 37, 41, 43, 47, 53, 61]

    # Filter out perfect squares (d+1 must not be perfect square for non-trivial Pell)
    import math
    filtered = [d for d in test_values if int(math.sqrt(d))**2 != d]

    results = test_multiple_d_values(filtered)

    # Check for any violations
    violations = [s for s in results if not s['perfect_symmetry']]
    if violations:
        print(f"\n⚠️  WARNING: Found {len(violations)} cases without perfect symmetry!")
        for v in violations:
            print(f"   d={v['d']}: + count={v['plus']}, - count={v['minus']}")
    else:
        print(f"\n✅ CONFIRMED: Perfect symmetry holds for all {len(results)} tested cases!")
