#!/usr/bin/env python3
"""
2-adic valuation analysis for binomial coefficients
User's insight: "i+j liché, 2i sudé... souhra sudých a lichých čísel"
Connection to 2-adic valuation in number theory
"""

from math import comb

def v2(n):
    """2-adic valuation: highest power of 2 dividing n"""
    if n == 0:
        return float('inf')

    count = 0
    while n % 2 == 0:
        n //= 2
        count += 1
    return count


def kummer_theorem_check(n, k):
    """
    Kummer's theorem: v_2(C(n,k)) = number of carries when adding k and (n-k) in binary

    Returns: (v2_value, carries, binary_k, binary_n_minus_k)
    """
    # Compute v_2(C(n,k)) directly
    v2_binom = v2(comb(n, k))

    # Count carries in binary addition k + (n-k)
    a = k
    b = n - k
    carries = 0
    carry = 0

    while a > 0 or b > 0 or carry > 0:
        bit_a = a & 1
        bit_b = b & 1

        if bit_a + bit_b + carry >= 2:
            carries += 1
            carry = 1
        else:
            carry = 0

        a >>= 1
        b >>= 1

    return v2_binom, carries, bin(k), bin(n-k)


def analyze_wildberger_binomial(j, i):
    """
    Analyze 2-adic properties of C(j+i, 2i) for Wildberger trace

    j = number of '-' branches
    i = half of '+' branches (so 2i = number of '+' branches)
    total = j + 2i steps
    """
    n = j + i
    k = 2 * i

    print("="*70)
    print(f"WILDBERGER BINOMIAL ANALYSIS: j={j}, i={i}")
    print("="*70)

    print(f"\nParameters:")
    print(f"  j (minus branches) = {j}")
    print(f"  i (parameter) = {i}")
    print(f"  2i (plus branches) = {k}")
    print(f"  Total steps = j + 2i = {j + k}")

    print(f"\nParity check:")
    print(f"  j+i = {n} → {'ODD' if n % 2 == 1 else 'EVEN'}")
    print(f"  2i = {k} → {'ODD' if k % 2 == 1 else 'EVEN'} (always even by construction)")
    print(f"  j = {j} → {'ODD' if j % 2 == 1 else 'EVEN'}")

    print(f"\nBinomial coefficient: C({n}, {k})")

    binom_value = comb(n, k)
    print(f"  Value: {binom_value}")

    # 2-adic valuation
    v2_val, carries, bin_k, bin_n_minus_k = kummer_theorem_check(n, k)

    print(f"\n2-adic valuation:")
    print(f"  v_2(C({n},{k})) = {v2_val}")
    print(f"  Binary k = {bin_k}")
    print(f"  Binary (n-k) = {bin_n_minus_k}")
    print(f"  Carries in binary addition = {carries}")
    print(f"  Kummer check: v_2 = carries? {v2_val == carries}")

    # Factor 2^(i-1) in our formula
    factor_2adic = v2(2**(i-1))
    print(f"\nFormula factor: 2^(i-1) = 2^{i-1}")
    print(f"  v_2(2^(i-1)) = {factor_2adic}")

    # Total 2-adic valuation in formula term
    formula_term = 2**(i-1) * binom_value
    total_v2 = v2(formula_term)
    print(f"\nComplete term: 2^(i-1) * C(j+i, 2i)")
    print(f"  = 2^{i-1} * {binom_value}")
    print(f"  = {formula_term}")
    print(f"  v_2(term) = {total_v2}")
    print(f"  = v_2(2^(i-1)) + v_2(C(j+i,2i))")
    print(f"  = {factor_2adic} + {v2_val} = {factor_2adic + v2_val}")

    return {
        'j': j,
        'i': i,
        'n': n,
        'k': k,
        'j_parity': j % 2,
        'n_parity': n % 2,
        'v2_binom': v2_val,
        'v2_factor': factor_2adic,
        'v2_total': total_v2,
        'carries': carries
    }


def compare_cases():
    """Compare sqrt(13) and sqrt(61) cases"""
    print("\n" + "="*70)
    print("COMPARISON: sqrt(13) vs sqrt(61)")
    print("="*70)

    # sqrt(13): j=10, i=5
    stats13 = analyze_wildberger_binomial(10, 5)

    print("\n")

    # sqrt(61): j=36, i=18
    stats61 = analyze_wildberger_binomial(36, 18)

    print("\n" + "="*70)
    print("SIDE-BY-SIDE COMPARISON")
    print("="*70)

    print(f"\n{'Property':<30} {'sqrt(13)':<20} {'sqrt(61)'}")
    print("-"*70)
    print(f"{'j (odd/even)':<30} {stats13['j']} ({'ODD' if stats13['j_parity'] else 'EVEN'})")
    print(f"{'i':<30} {stats13['i']:<20} {stats61['i']}")
    print(f"{'j+i (odd/even)':<30} {stats13['n']} ({'ODD' if stats13['n_parity'] else 'EVEN'})")
    print(f"{'v_2(C(j+i, 2i))':<30} {stats13['v2_binom']:<20} {stats61['v2_binom']}")
    print(f"{'v_2(2^(i-1))':<30} {stats13['v2_factor']:<20} {stats61['v2_factor']}")
    print(f"{'v_2(total term)':<30} {stats13['v2_total']:<20} {stats61['v2_total']}")
    print(f"{'Binary carries':<30} {stats13['carries']:<20} {stats61['carries']}")

    print("\n" + "-"*70)
    print("PATTERN OBSERVATIONS")
    print("-"*70)

    # Check if there's a pattern
    print(f"\n1. j+i parity:")
    print(f"   sqrt(13): j+i = {stats13['n']} → {'ODD' if stats13['n_parity'] else 'EVEN'}")
    print(f"   sqrt(61): j+i = {stats61['n']} → {'ODD' if stats61['n_parity'] else 'EVEN'}")

    print(f"\n2. 2-adic valuation of binomial:")
    print(f"   sqrt(13): v_2(C(15,10)) = {stats13['v2_binom']}")
    print(f"   sqrt(61): v_2(C(54,36)) = {stats61['v2_binom']}")

    print(f"\n3. User's insight: 'i+j liché, 2i sudé → souhra sudých a lichých'")
    print(f"   When j+i is odd:")
    print(f"     - 2i is always even (by definition)")
    print(f"     - j must be odd (since odd = odd + even → j = odd)")
    print(f"   Both cases have j+i odd: j+i ∈ {{15, 54}} (both odd)")
    print(f"   Both cases have j even: j ∈ {{10, 36}} (both even)")
    print(f"   WAIT - this contradicts! j should be odd if j+i is odd...")

    # Re-check
    print(f"\n4. Correction check:")
    print(f"   sqrt(13): j={stats13['j']} (even), i={stats13['i']}, j+i={stats13['n']} (odd)")
    print(f"   sqrt(61): j={stats61['j']} (even), i={stats61['i']}, j+i={stats61['n']} (odd)")
    print(f"   Pattern: j even + i odd = j+i odd ✓")
    print(f"   So: i is ODD in both cases!")

    print(f"\n5. Revised insight:")
    print(f"   When i is odd:")
    print(f"     - 2i is even (always, but specifically 2·odd = even)")
    print(f"     - If j is even, then j+i is odd")
    print(f"   This matches both cases: i ∈ {{5, 18}} where 5 is odd, 18 is even...")
    print(f"   WAIT - 18 is even!")

    print(f"\n6. Final check:")
    print(f"   sqrt(13): i={stats13['i']} → {'ODD' if stats13['i'] % 2 else 'EVEN'}")
    print(f"   sqrt(61): i={stats61['i']} → {'ODD' if stats61['i'] % 2 else 'EVEN'}")
    print(f"   Different parity for i! Not a universal pattern.")

    print(f"\n7. What IS universal:")
    print(f"   - Perfect +/- branch symmetry (j = i·2 wait no, j ≠ 2i)")
    print(f"   - Actually: '+' branches = 2i, '-' branches = j")
    print(f"   - Total = j + 2i")
    print(f"   sqrt(13): 10 + 2·5 = 20 ✓")
    print(f"   sqrt(61): 36 + 2·18 = 72 ✓")
    print(f"   Symmetry: j = 2i in both cases!")
    print(f"   sqrt(13): j=10, 2i=10 ✓")
    print(f"   sqrt(61): j=36, 2i=36 ✓")


if __name__ == "__main__":
    compare_cases()
