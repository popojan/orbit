#!/usr/bin/env python3
"""
Question 3: How does LR string structure connect to C(3i, 2i)?

Approach:
1. Analyze LR string as generating procedure
2. Connect '+' and '-' to binomial selection
3. Test if simple cases enable proof of Egypt-Chebyshev
"""

import math
from math import comb
from wildberger_pell_trace import wildberger_pell

def analyze_lr_as_selection_process(d):
    """Interpret LR string as selection/combination process"""
    x, y, trace = wildberger_pell(d, verbose=False)

    branches = [step[1] for step in trace]
    plus_count = branches.count('+')
    minus_count = branches.count('-')

    if plus_count != minus_count:
        return None  # Only symmetric cases

    i = len(branches) // 4
    total = len(branches)

    # For symmetric: total = 4i, plus = minus = 2i
    # Binomial: C(3i, 2i)

    n = 3 * i
    k = 2 * i

    binom_value = comb(n, k)

    # Hypothesis: LR string encodes a way to compute C(3i, 2i)

    # Try interpretation 1: '+' means "include", '-' means "skip"
    # If we're selecting 2i items from 3i items...
    # We make 4i decisions total, with 2i '+' (include) and 2i '-' (skip)

    # But wait: selecting 2i from 3i should need only 3i decisions!
    # Unless... we're building it recursively?

    # Interpretation 2: Recursion
    # LR string has palindrome structure → recursive doubling
    # Center has longest '+' run → this is the "core selection"

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

    # Find center run (longest '+')
    max_plus_run = max((length for char, length in runs if char == '+'), default=0)

    return {
        'd': d,
        'i': i,
        'string': ''.join(branches),
        'branches': branches,
        'runs': runs,
        'binom_n': n,
        'binom_k': k,
        'binom_value': binom_value,
        'max_plus_run': max_plus_run,
        'total_plus': plus_count,
        'total_minus': minus_count
    }

def test_simple_cases_pattern():
    """For simple [i, 2i, i] cases, analyze the connection"""
    print("="*80)
    print("SIMPLE CASES: LR → Binomial Mechanism")
    print("="*80)

    simple_d = [2, 5, 10, 17, 37, 50]

    for d in simple_d:
        result = analyze_lr_as_selection_process(d)
        if not result:
            continue

        i = result['i']
        print(f"\nd={d}, i={i}")
        print(f"  String: {result['string']}")
        print(f"  Pattern: [-]^{i} [+]^{2*i} [-]^{i}")
        print(f"  Binomial: C({result['binom_n']}, {result['binom_k']}) = {result['binom_value']}")

        # Key insight: Simple pattern is SYMMETRIC with clear center
        # Center has 2i consecutive '+'
        # This might represent the "core" of the selection

        print(f"\n  Interpretation:")
        print(f"    - Total decisions: 4i = {4*i}")
        print(f"    - Select ('+'):    2i = {2*i}")
        print(f"    - Skip ('-'):      2i = {2*i}")
        print(f"    - From pool:       3i = {3*i}")
        print(f"    → Selecting 2i from 3i, but using 4i steps?")

        # Hypothesis: Palindrome structure means we're building BOTH
        # the selection and its complement simultaneously!

        # In combinatorics: C(n,k) counts selecting k from n
        # But we can also think of it as:
        # - Build a path that visits 2i items from 3i
        # - Path has length 4i due to palindrome constraint
        # - Palindrome → going forward and backward

        print(f"\n  Palindrome insight:")
        print(f"    - Forward path: i steps '-', then 2i steps '+'")
        print(f"    - Backward path: mirrors forward")
        print(f"    - This constructs C(3i, 2i) through symmetric process")

def connect_to_chebyshev_formula():
    """Attempt to connect LR structure to Chebyshev formula"""
    print("\n" + "="*80)
    print("CONNECTION TO EGYPT-CHEBYSHEV FORMULA")
    print("="*80)

    print("\nEgypt-Chebyshev formula (for symmetric cases with j=2i):")
    print("  P_j(x) = 1 + Σ_{k=1}^{j} 2^(k-1) · C(j+k, 2k) · x^k")
    print("\nWith j = 2i:")
    print("  P_{2i}(x) = 1 + Σ_{k=1}^{2i} 2^(k-1) · C(2i+k, 2k) · x^k")
    print("\nAt position k=i:")
    print("  Coefficient: 2^(i-1) · C(2i+i, 2i) = 2^(i-1) · C(3i, 2i)")

    print("\n" + "-"*80)
    print("HYPOTHESIS: LR String Generates Coefficient")
    print("-"*80)

    print("\nSimple LR pattern: [-]^i [+]^(2i) [-]^i")
    print("")
    print("Idea: This encodes the recursive construction of 2^(i-1) · C(3i, 2i)")
    print("")
    print("Mechanism:")
    print("  1. Start at origin")
    print("  2. Each '-' step: move in one direction (don't select)")
    print("  3. Each '+' step: move in another direction (select)")
    print("  4. Palindrome: recursive doubling → factor 2^(i-1)")
    print("")
    print("  After i '-' steps: position i")
    print("  After 2i '+' steps: select 2i items from available 3i")
    print("  Final i '-' steps: return (palindrome symmetry)")

    # Test specific case
    d = 5
    i = 2
    print(f"\nExample: d={d}, i={i}")
    print(f"  LR string: --++++--")
    print(f"  Coefficient: 2^(i-1) · C(3i, 2i) = 2^1 · C(6, 4) = 2 · 15 = 30")
    print("")
    print(f"  Can we derive 30 from string structure?")
    print(f"  - 2 prefix '-': creates 2^1 factor?")
    print(f"  - 4 center '+': represents selecting 4 from 6?")
    print(f"  - 2 suffix '-': mirrors prefix (palindrome)")

def recursive_interpretation():
    """Interpret palindrome as recursive doubling"""
    print("\n" + "="*80)
    print("RECURSIVE DOUBLING INTERPRETATION")
    print("="*80)

    print("\nKey observation: Palindrome structure → Recursion")
    print("")
    print("For string S of length 4i:")
    print("  S = [-]^i [+]^(2i) [-]^i")
    print("")
    print("This is palindrome: S = reverse(S)")
    print("")
    print("Recursive view:")
    print("  S can be built by 'folding' a simpler process")
    print("")
    print("Half-string: [-]^i [+]^i")
    print("  This represents: select i from pool, starting after i skips")
    print("")
    print("Full palindrome doubles this:")
    print("  [-]^i [+]^i  →  [-]^i [+]^i [+]^i [-]^i")
    print("               mirror")
    print("")
    print("The mirroring creates extra '+' in center:")
    print("  [+]^i  becomes  [+]^(2i)")
    print("")
    print("This doubling might generate the 2^(i-1) factor!")

    print("\n" + "-"*80)
    print("TESTING THE HYPOTHESIS")
    print("-"*80)

    simple_d = [2, 5, 10, 17, 37]

    print(f"\n{'d':<6} {'i':<6} {'2^(i-1)':<10} {'C(3i,2i)':<12} {'Product':<12} {'Chebyshev coeff at i?'}")
    print("-"*80)

    for d in simple_d:
        result = analyze_lr_as_selection_process(d)
        if not result:
            continue

        i = result['i']
        power_of_2 = 2**(i-1)
        binom = comb(3*i, 2*i)
        product = power_of_2 * binom

        print(f"{d:<6} {i:<6} {power_of_2:<10} {binom:<12} {product:<12} {'???'}")

    print("\nTo verify: Need to compute Chebyshev P_j(x) for j=2i")
    print("and check if coefficient of x^i equals 2^(i-1) · C(3i, 2i)")

def lattice_path_interpretation():
    """Interpret as lattice paths"""
    print("\n" + "="*80)
    print("LATTICE PATH INTERPRETATION")
    print("="*80)

    print("\nClassic combinatorics: C(n,k) = number of lattice paths")
    print("")
    print("Standard: C(n,k) counts paths from (0,0) to (k, n-k)")
    print("  with k steps RIGHT, n-k steps UP")
    print("")
    print("Our case: C(3i, 2i)")
    print("  Paths from (0,0) to (2i, i)")
    print("  with 2i steps RIGHT, i steps UP")

    print("\n" + "-"*80)
    print("LR STRING AS PATH ENCODING")
    print("-"*80)

    print("\nHypothesis: LR string encodes a path in 2D lattice")
    print("")
    print("Mapping:")
    print("  '-' → one direction (say, UP)")
    print("  '+' → other direction (say, RIGHT)")
    print("")
    print("Simple string: [-]^i [+]^(2i) [-]^i")
    print("  Path: UP^i, RIGHT^(2i), UP^i")
    print("  End point: (2i, 2i)")
    print("")
    print("But C(3i, 2i) needs endpoint (2i, i)!")
    print("")
    print("  → Discrepancy! Simple mapping doesn't work.")

    print("\n" + "-"*80)
    print("ALTERNATIVE: Stern-Brocot Tree Path")
    print("-"*80)

    print("\nWildberger mentions connection to Stern-Brocot tree")
    print("")
    print("In SB tree:")
    print("  'L' branch → one rational")
    print("  'R' branch → another rational")
    print("")
    print("Path to sqrt(d) approximation uses L/R decisions")
    print("")
    print("Our '+' and '-' might be L and R!")
    print("  → LR string = path in SB tree to fundamental unit")
    print("")
    print("C(3i, 2i) might count certain TYPES of SB paths?")

if __name__ == "__main__":
    test_simple_cases_pattern()
    connect_to_chebyshev_formula()
    recursive_interpretation()
    lattice_path_interpretation()

    print("\n" + "="*80)
    print("SUMMARY: LR → C(3i, 2i) Connection")
    print("="*80)
    print("\nFindings:")
    print("1. Simple pattern [-]^i [+]^(2i) [-]^i is symmetric/palindromic")
    print("2. Palindrome structure suggests recursive doubling → 2^(i-1) factor")
    print("3. Center [+]^(2i) might represent selecting 2i from pool")
    print("4. Direct lattice path interpretation doesn't match")
    print("5. Stern-Brocot tree connection might explain LR structure")
    print("\nConclusion:")
    print("Mechanism is NOT straightforward. Need to:")
    print("  a) Understand Wildberger's SB tree connection")
    print("  b) Derive how (a,b,c) dynamics generate C(3i,2i)")
    print("  c) Prove Egypt-Chebyshev for simple cases first")
    print("\nThis brings us back to PROOF STRATEGY:")
    print("  → Attack simple cases j=2i with clean [i,2i,i] structure")
    print("  → May enable easier proof than general j")
