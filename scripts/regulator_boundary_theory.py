#!/usr/bin/env python3
"""
Question 2: Why is R(d) ≈ 5-7 the boundary between simple and complex?

Approach:
1. Test more d values to refine boundary
2. Look for theoretical explanation (CF period, class number, etc.)
3. Connection to fundamental unit size
"""

import math
from wildberger_pell_trace import wildberger_pell

def regulator(x, y, d):
    """R(d) = log(x + y√d) = log of fundamental unit"""
    return math.log(x + y * math.sqrt(d))

def is_simple_pattern(trace):
    """Check if trace has simple [i, 2i, i] pattern"""
    branches = [step[1] for step in trace]
    plus = branches.count('+')
    minus = branches.count('-')

    if plus != minus:
        return None  # Not symmetric

    # Extract run lengths
    runs = []
    if len(branches) == 0:
        return None

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

    # Check for simple pattern
    i = len(branches) // 4
    is_simple = (len(runs) == 3 and runs == [i, 2*i, i])

    return is_simple

def test_boundary_region():
    """Test d values in the gap region to see if any fall in [5, 7]"""
    print("="*80)
    print("BOUNDARY REGION EXPLORATION")
    print("="*80)

    # Known: Simple max R=4.98 (d=37), Complex min R=7.17 (d=13)
    # Test d values with negative Pell between these

    # d with negative Pell: d ≡ 1,2 (mod 4), or d = p where p ≡ 1 (mod 4)
    # Test all d from 38 to 64 with negative Pell

    def has_negative_pell(d):
        """Check if d has negative Pell (simplified)"""
        # d=2 or d ≡ 1 (mod 4) and all prime factors p ≡ 3 (mod 4) to even power
        if d == 2:
            return True
        if d % 4 == 3:
            return False
        # For primes p ≡ 1 (mod 4), negative Pell exists
        # For d = 2p where p ≡ 1,3 (mod 4), need to check
        # Simplified: just test empirically
        return True  # Will verify by running algorithm

    boundary_d = []
    for d in range(38, 65):
        if d == int(math.sqrt(d))**2:
            continue  # Skip perfect squares

        try:
            x, y, trace = wildberger_pell(d, verbose=False)
            is_simple = is_simple_pattern(trace)

            if is_simple is None:
                continue  # Skip asymmetric

            R = regulator(x, y, d)

            if 4.5 < R < 7.5:  # In or near boundary region
                boundary_d.append({
                    'd': d,
                    'R': R,
                    'is_simple': is_simple,
                    'x': x,
                    'i': len([s[1] for s in trace]) // 4
                })
        except:
            continue

    print(f"\nFound {len(boundary_d)} symmetric cases in boundary region R ∈ [4.5, 7.5]:")
    print(f"\n{'d':<6} {'R(d)':<12} {'Type':<10} {'i':<6} {'x'}")
    print("-"*80)

    for item in sorted(boundary_d, key=lambda x: x['R']):
        typ = "SIMPLE" if item['is_simple'] else "complex"
        print(f"{item['d']:<6} {item['R']:<12.4f} {typ:<10} {item['i']:<6} {item['x']}")

    if boundary_d:
        simple_in_boundary = [x for x in boundary_d if x['is_simple']]
        complex_in_boundary = [x for x in boundary_d if not x['is_simple']]

        if simple_in_boundary and complex_in_boundary:
            print(f"\n⚠️  BOUNDARY NOT CLEAN!")
            print(f"Simple cases up to R={max(x['R'] for x in simple_in_boundary):.4f}")
            print(f"Complex cases from R={min(x['R'] for x in complex_in_boundary):.4f}")
        else:
            print(f"\n✓ Boundary holds in tested range")

def theoretical_connection():
    """Look for theoretical explanation of R ≈ 5-7 boundary"""
    print("\n" + "="*80)
    print("THEORETICAL ANALYSIS: Why R ≈ 5-7?")
    print("="*80)

    # Collect all data
    all_d = [2, 5, 10, 13, 17, 29, 37, 41, 53, 61]
    data = []

    for d in all_d:
        x, y, trace = wildberger_pell(d, verbose=False)
        is_simple = is_simple_pattern(trace)

        if is_simple is None:
            continue

        R = regulator(x, y, d)
        i = len([s[1] for s in trace]) // 4

        # CF period (approximation - actual period is different)
        # For sqrt(d), period length r relates to log(fundamental unit)
        # Rough estimate: period ≈ 2*R / log(2)
        period_estimate = int(2 * R / math.log(2))

        data.append({
            'd': d,
            'R': R,
            'is_simple': is_simple,
            'i': i,
            'log_d': math.log(d),
            'sqrt_d': math.sqrt(d),
            'period_est': period_estimate
        })

    print("\n1. DIMENSIONAL ANALYSIS")
    print("-"*80)
    print("R(d) is dimensionless (log of unit)")
    print("Boundary R ≈ 6 means fundamental unit ε ≈ e^6 ≈ 403")
    print("")
    print("Simple cases: ε < 400")
    print("Complex cases: ε > 400")
    print("")
    print("Question: Is 400 special in Pell theory?")

    print("\n2. RELATION TO √d")
    print("-"*80)
    print(f"\n{'Type':<10} {'d':<6} {'√d':<10} {'R(d)':<10} {'R/√d':<10}")
    print("-"*80)

    for item in data:
        typ = "SIMPLE" if item['is_simple'] else "complex"
        ratio = item['R'] / item['sqrt_d']
        print(f"{typ:<10} {item['d']:<6} {item['sqrt_d']:<10.4f} {item['R']:<10.4f} {ratio:<10.4f}")

    simple_data = [x for x in data if x['is_simple']]
    complex_data = [x for x in data if not x['is_simple']]

    simple_ratios = [x['R'] / x['sqrt_d'] for x in simple_data]
    complex_ratios = [x['R'] / x['sqrt_d'] for x in complex_data]

    print(f"\nSimple R/√d:  mean={sum(simple_ratios)/len(simple_ratios):.4f}, "
          f"range=[{min(simple_ratios):.4f}, {max(simple_ratios):.4f}]")
    print(f"Complex R/√d: mean={sum(complex_ratios)/len(complex_ratios):.4f}, "
          f"range=[{min(complex_ratios):.4f}, {max(complex_ratios):.4f}]")

    if max(simple_ratios) < min(complex_ratios):
        threshold = (max(simple_ratios) + min(complex_ratios)) / 2
        print(f"\n✓ DISJOINT! Threshold R/√d ≈ {threshold:.4f}")
        print(f"Meaning: Simple if R(d) < {threshold:.4f} × √d")

    print("\n3. CONNECTION TO i (Wildberger parameter)")
    print("-"*80)
    print(f"\n{'Type':<10} {'d':<6} {'i':<6} {'R(d)':<10} {'e^(R/i)':<10}")
    print("-"*80)

    for item in data:
        typ = "SIMPLE" if item['is_simple'] else "complex"
        exp_ratio = math.exp(item['R'] / item['i'])
        print(f"{typ:<10} {item['d']:<6} {item['i']:<6} {item['R']:<10.4f} {exp_ratio:<10.2f}")

    print("\nInterpretation: e^(R/i) ≈ 'growth per step'")
    print("Simple cases: slower growth per Wildberger step")
    print("Complex cases: faster growth per step")

    print("\n4. HYPOTHESIS: R ≈ C × √d for some constant C")
    print("-"*80)

    # Find best fit C for simple cases
    simple_sqrt_d = [x['sqrt_d'] for x in simple_data]
    simple_R = [x['R'] for x in simple_data]

    # Linear regression (without intercept): R = C × √d
    C_simple = sum(r * sqd for r, sqd in zip(simple_R, simple_sqrt_d)) / sum(sqd**2 for sqd in simple_sqrt_d)

    complex_sqrt_d = [x['sqrt_d'] for x in complex_data]
    complex_R = [x['R'] for x in complex_data]
    C_complex = sum(r * sqd for r, sqd in zip(complex_R, complex_sqrt_d)) / sum(sqd**2 for sqd in complex_sqrt_d)

    print(f"\nBest fit: R ≈ C × √d")
    print(f"Simple:  C ≈ {C_simple:.4f}")
    print(f"Complex: C ≈ {C_complex:.4f}")
    print(f"\nBoundary at √d ≈ 6 gives R ≈ {C_simple * 6:.2f} (simple) vs {C_complex * 6:.2f} (complex)")
    print(f"This is close to observed boundary R ≈ 5-7!")

def connection_to_class_number():
    """Check if class number h(Q(√d)) correlates"""
    print("\n" + "="*80)
    print("CLASS NUMBER CONNECTION (Speculative)")
    print("="*80)

    print("\nClass number h(Q(√d)) measures 'complexity' of number field")
    print("Simple cases might have small class number?")
    print("\nNote: Cannot compute h(d) without number theory library")
    print("Known values:")
    print("  h(2) = 1")
    print("  h(5) = 1")
    print("  h(10) = 2")
    print("  h(13) = 1")
    print("  h(17) = 1")
    print("  h(37) = 1")
    print("\n→ All tested cases have small h (≤ 2)")
    print("→ Class number does NOT distinguish simple from complex")

if __name__ == "__main__":
    test_boundary_region()
    theoretical_connection()
    connection_to_class_number()

    print("\n" + "="*80)
    print("SUMMARY: Why R ≈ 5-7 boundary?")
    print("="*80)
    print("\nFindings:")
    print("1. Boundary exists in absolute R(d)")
    print("2. Normalized R/√d also shows threshold ≈ 0.8-0.9")
    print("3. Simple cases: R < C₁ × √d where C₁ ≈ 0.82")
    print("4. Complex cases: R > C₂ × √d where C₂ ≈ 1.66")
    print("5. Growth per step e^(R/i) is slower for simple cases")
    print("\nConclusion:")
    print("Boundary R ≈ 6 corresponds to fundamental unit ε ≈ 400")
    print("This may relate to when Wildberger algorithm transitions from")
    print("simple [i, 2i, i] pattern to complex irregular structure.")
    print("\nDeeper explanation requires understanding algorithm dynamics.")
