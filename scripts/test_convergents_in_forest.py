#!/usr/bin/env python3
"""
Test 1: Do CF convergent denominators dominate primal forest?

Hypothesis: For D (square-free), CF convergent denominators {q_k} of √D
should give the largest contributions to the primal forest sum F_D(α,ε).

Test plan:
1. Compute CF convergents for √D
2. Compute primal forest F_D(α,ε) with contributions from each divisor d
3. Check: Are the top contributors exactly the convergent denominators?
"""

from decimal import Decimal, getcontext
import math

# High precision for continued fractions
getcontext().prec = 100


def cf_of_sqrt(D, max_terms=50):
    """
    Compute continued fraction of √D.
    Returns (a0, period) where √D = [a0; period, period, period, ...]
    """
    if int(math.sqrt(D))**2 == D:
        raise ValueError(f"D={D} is a perfect square")

    a0 = int(math.sqrt(D))

    # Find period
    m, d, a = 0, 1, a0
    period = []
    seen = {}

    while True:
        m = d * a - m
        d = (D - m * m) // d
        a = (a0 + m) // d

        state = (m, d)
        if state in seen:
            break

        seen[state] = len(period)
        period.append(a)

        if len(period) > max_terms:
            break

    return a0, period


def cf_convergents(a0, period, num_convergents):
    """
    Compute convergents p_k/q_k from CF [a0; period repeated].
    Returns list of (p_k, q_k) tuples.
    """
    # Build full CF sequence
    cf_seq = [a0]
    for i in range(num_convergents):
        cf_seq.append(period[i % len(period)])

    # Compute convergents
    convergents = []
    p_prev2, p_prev1 = 0, 1
    q_prev2, q_prev1 = 1, 0

    for a in cf_seq:
        p = a * p_prev1 + p_prev2
        q = a * q_prev1 + q_prev2
        convergents.append((p, q))
        p_prev2, p_prev1 = p_prev1, p
        q_prev2, q_prev1 = q_prev1, q

    return convergents


def pell_residual(p, q, D):
    """Compute Pell residual R = p² - D·q²"""
    return p*p - D*q*q


def primal_forest_contributions(D, alpha=3, epsilon=1e-10, d_max=None):
    """
    Compute primal forest F_D(α,ε) as sum of contributions from each divisor d.

    Returns: list of (d, contribution) sorted by contribution (descending)

    F_D(α,ε) = Σ_{d,k} [(D - kd - d²)² + ε]^{-α}
    """
    if d_max is None:
        d_max = int(math.sqrt(D)) + 50  # Include some beyond √D

    contributions = {}

    for d in range(1, d_max + 1):
        total_contrib = 0.0

        # For each d, sum over valid k
        # We need kd + d² ≈ D, so k ≈ (D - d²)/d
        # Try k values around this
        k_center = max(0, (D - d*d) // d)

        for k in range(max(0, k_center - 10), k_center + 11):
            distance_sq = (D - k*d - d*d)**2
            term = (distance_sq + epsilon)**(-alpha)
            total_contrib += term

        contributions[d] = total_contrib

    # Sort by contribution (descending)
    sorted_contribs = sorted(contributions.items(), key=lambda x: x[1], reverse=True)

    return sorted_contribs


def test_convergents_in_forest(D, alpha=3, epsilon=1e-10, top_n=15):
    """
    Test if CF convergent denominators appear in top contributors to forest.
    """
    print(f"\n{'='*70}")
    print(f"Testing D = {D}")
    print(f"{'='*70}")

    # Step 1: Compute CF convergents
    a0, period = cf_of_sqrt(D)
    print(f"\n√{D} = [{a0}; {period}]")
    print(f"Period length: {len(period)}")

    # Get enough convergents to cover period
    num_conv = 2 * len(period)
    convergents = cf_convergents(a0, period, num_conv)

    # Extract denominators (first 10-15)
    conv_denominators = set()
    print(f"\nFirst {min(15, len(convergents))} convergents:")
    for i, (p, q) in enumerate(convergents[:15]):
        R = pell_residual(p, q, D)
        conv_denominators.add(q)
        print(f"  k={i}: p/q = {p}/{q}, R = {R:+d}")

    print(f"\nConvergent denominators: {sorted(conv_denominators)[:15]}")

    # Step 2: Compute forest contributions
    print(f"\nComputing primal forest contributions (α={alpha}, ε={epsilon:.1e})...")
    contribs = primal_forest_contributions(D, alpha, epsilon)

    print(f"\nTop {top_n} contributors to forest:")
    for i, (d, contrib) in enumerate(contribs[:top_n]):
        marker = " ⭐" if d in conv_denominators else ""
        print(f"  {i+1:2d}. d={d:4d}  contrib={contrib:.6e}{marker}")

    # Step 3: Analysis
    top_divisors = {d for d, _ in contribs[:top_n]}
    overlap = top_divisors & conv_denominators

    print(f"\n{'='*70}")
    print(f"ANALYSIS:")
    print(f"  Convergent denominators in top {top_n}: {len(overlap)}/{len(conv_denominators & set(range(1, 1000)))}")
    print(f"  Overlap: {sorted(overlap)}")

    # What percentage of top contributors are convergent denominators?
    pct = 100 * len(overlap) / top_n
    print(f"  Percentage: {pct:.1f}%")

    if pct > 50:
        print(f"\n  ✅ STRONG SUPPORT for hypothesis!")
    elif pct > 30:
        print(f"\n  ⚠️  MODERATE support for hypothesis")
    else:
        print(f"\n  ❌ WEAK support - hypothesis may be wrong")

    print(f"{'='*70}\n")

    return {
        'D': D,
        'top_divisors': list(top_divisors),
        'conv_denominators': sorted(conv_denominators),
        'overlap': sorted(overlap),
        'overlap_count': len(overlap),
        'percentage': pct
    }


if __name__ == '__main__':
    # Test cases from the hypothesis document
    test_cases = [13, 61, 109]

    print("="*70)
    print("VERIFICATION TEST 1: CF Convergent Denominators in Primal Forest")
    print("="*70)
    print("\nHypothesis: CF convergent denominators {q_k} should dominate")
    print("the primal forest sum F_D(α,ε).")
    print()

    results = []
    for D in test_cases:
        result = test_convergents_in_forest(D, alpha=3, epsilon=1e-10, top_n=15)
        results.append(result)

    # Summary
    print("\n" + "="*70)
    print("SUMMARY")
    print("="*70)
    for r in results:
        print(f"D={r['D']:3d}: {r['overlap_count']:2d} matches ({r['percentage']:5.1f}%)")

    avg_pct = sum(r['percentage'] for r in results) / len(results)
    print(f"\nAverage overlap: {avg_pct:.1f}%")

    if avg_pct > 50:
        print("\n✅ HYPOTHESIS STRONGLY SUPPORTED!")
    elif avg_pct > 30:
        print("\n⚠️  HYPOTHESIS MODERATELY SUPPORTED")
    else:
        print("\n❌ HYPOTHESIS NOT SUPPORTED")
