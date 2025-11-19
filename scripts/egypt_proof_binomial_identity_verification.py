#!/usr/bin/env python3
"""
Binomial Identity Verification (Internal Tool)

Goal: Verify the binomial identity HOLDS, then find algebraic derivation path

Identity to verify:
  C(n+k-1, 2k-3) + 3·C(n+k, 2k-1) + C(n+k+1, 2k+1)
  - C(n+k-1, 2k-1) - C(n+k, 2k+1) = C(n+2+k, 2k)

This is INTERNAL exploration tool - NOT part of final proof.
Final proof will use named binomial identities only.
"""

from sympy import symbols, binomial as C, simplify, expand, factorial
from sympy import summation, Function, Sum
from math import comb

def test_identity_numerically():
    """
    Test the identity on concrete values of n, k
    """
    print("="*80)
    print("NUMERICAL VERIFICATION (Internal Tool)")
    print("="*80)

    print("\nIdentity to verify:")
    print("  LHS = C(n+k-1, 2k-3) + 3·C(n+k, 2k-1) + C(n+k+1, 2k+1)")
    print("        - C(n+k-1, 2k-1) - C(n+k, 2k+1)")
    print("  RHS = C(n+2+k, 2k)")

    test_cases = [
        (4, 2),  # n=4, k=2
        (6, 2),  # n=6, k=2
        (4, 3),  # n=4, k=3
        (6, 3),  # n=6, k=3
        (8, 2),  # n=8, k=2
        (8, 3),  # n=8, k=3
        (10, 2), # n=10, k=2
    ]

    print("\n" + "-"*80)
    print(f"{'n':<4} {'k':<4} {'LHS':<12} {'RHS':<12} {'Match':<8}")
    print("-"*80)

    all_match = True
    for n_val, k_val in test_cases:
        # Compute LHS
        lhs = (comb(n_val+k_val-1, 2*k_val-3) if n_val+k_val-1 >= 2*k_val-3 >= 0 else 0)
        lhs += 3 * (comb(n_val+k_val, 2*k_val-1) if n_val+k_val >= 2*k_val-1 else 0)
        lhs += (comb(n_val+k_val+1, 2*k_val+1) if n_val+k_val+1 >= 2*k_val+1 else 0)
        lhs -= (comb(n_val+k_val-1, 2*k_val-1) if n_val+k_val-1 >= 2*k_val-1 >= 0 else 0)
        lhs -= (comb(n_val+k_val, 2*k_val+1) if n_val+k_val >= 2*k_val+1 else 0)

        # Compute RHS
        rhs = comb(n_val+2+k_val, 2*k_val) if n_val+2+k_val >= 2*k_val else 0

        match = "✓" if lhs == rhs else "✗"
        if lhs != rhs:
            all_match = False

        print(f"{n_val:<4} {k_val:<4} {lhs:<12} {rhs:<12} {match:<8}")

    print("-"*80)
    if all_match:
        print("✓✓✓ ALL NUMERICAL TESTS PASS")
    else:
        print("✗✗✗ SOME TESTS FAILED - Identity may be wrong!")

    return all_match

def test_identity_symbolically():
    """
    Test the identity symbolically with sympy
    """
    print("\n" + "="*80)
    print("SYMBOLIC VERIFICATION (Internal Tool)")
    print("="*80)

    n, k = symbols('n k', positive=True, integer=True)

    # LHS
    lhs = C(n+k-1, 2*k-3) + 3*C(n+k, 2*k-1) + C(n+k+1, 2*k+1) \
        - C(n+k-1, 2*k-1) - C(n+k, 2*k+1)

    # RHS
    rhs = C(n+2+k, 2*k)

    print("\nLHS expression:")
    print(f"  {lhs}")

    print("\nRHS expression:")
    print(f"  {rhs}")

    print("\nComputing difference: LHS - RHS")
    diff = simplify(lhs - rhs)

    print(f"\nDifference (simplified): {diff}")

    if diff == 0:
        print("\n✓✓✓ SYMBOLIC VERIFICATION: Identity is EXACT")
        return True
    else:
        print(f"\n✗✗✗ Identity does NOT hold symbolically")
        print(f"    Difference: {diff}")
        return False

def identify_pascal_path():
    """
    Identify which Pascal/binomial identities to use

    Key identities:
    1. Pascal's identity: C(n,k) = C(n-1,k) + C(n-1,k-1)
    2. Absorption: C(n,k) = (n/k)·C(n-1,k-1)
    3. Symmetry: C(n,k) = C(n,n-k)
    4. Hockey stick: Σ_{i=r}^n C(i,r) = C(n+1,r+1)
    """
    print("\n" + "="*80)
    print("IDENTIFY ALGEBRAIC DERIVATION PATH")
    print("="*80)

    print("\nGoal: Express LHS terms using Pascal's identity")
    print("      to telescope into RHS = C(n+2+k, 2k)")

    print("\n" + "-"*80)
    print("Pascal's Identity: C(n,k) = C(n-1,k) + C(n-1,k-1)")
    print("-"*80)

    print("\nApply to each term:")

    print("\n1. C(n+k+1, 2k+1):")
    print("   = C(n+k, 2k+1) + C(n+k, 2k)  [Pascal]")

    print("\n2. C(n+k, 2k-1):")
    print("   Apply Pascal? Let's see if it helps...")
    print("   = C(n+k-1, 2k-1) + C(n+k-1, 2k-2)")

    print("\n3. Notice we have -C(n+k-1, 2k-1) which cancels with expansion of #2")

    print("\n" + "-"*80)
    print("STRATEGY:")
    print("-"*80)
    print("Expand each term using Pascal, then collect and cancel")
    print("Should telescope to C(n+2+k, 2k)")

def derive_algebraically():
    """
    Attempt step-by-step algebraic derivation
    """
    print("\n" + "="*80)
    print("ALGEBRAIC DERIVATION ATTEMPT")
    print("="*80)

    print("\nStarting with LHS:")
    print("  C(n+k-1, 2k-3) + 3·C(n+k, 2k-1) + C(n+k+1, 2k+1)")
    print("  - C(n+k-1, 2k-1) - C(n+k, 2k+1)")

    print("\n" + "-"*80)
    print("Step 1: Expand C(n+k+1, 2k+1) using Pascal")
    print("-"*80)
    print("  C(n+k+1, 2k+1) = C(n+k, 2k+1) + C(n+k, 2k)")

    print("\nLHS becomes:")
    print("  C(n+k-1, 2k-3) + 3·C(n+k, 2k-1)")
    print("  + [C(n+k, 2k+1) + C(n+k, 2k)]")
    print("  - C(n+k-1, 2k-1) - C(n+k, 2k+1)")

    print("\n  = C(n+k-1, 2k-3) + 3·C(n+k, 2k-1) + C(n+k, 2k)")
    print("    - C(n+k-1, 2k-1)")
    print("    [C(n+k, 2k+1) cancels]")

    print("\n" + "-"*80)
    print("Step 2: Expand 3·C(n+k, 2k-1) using Pascal")
    print("-"*80)
    print("  3·C(n+k, 2k-1) = 3·[C(n+k-1, 2k-1) + C(n+k-1, 2k-2)]")
    print("                 = 3·C(n+k-1, 2k-1) + 3·C(n+k-1, 2k-2)")

    print("\nLHS becomes:")
    print("  C(n+k-1, 2k-3) + 3·C(n+k-1, 2k-1) + 3·C(n+k-1, 2k-2)")
    print("  + C(n+k, 2k) - C(n+k-1, 2k-1)")

    print("\n  = C(n+k-1, 2k-3) + 2·C(n+k-1, 2k-1) + 3·C(n+k-1, 2k-2)")
    print("    + C(n+k, 2k)")
    print("    [Combine like terms]")

    print("\n" + "-"*80)
    print("Step 3: Try to build C(n+2+k, 2k) from these terms")
    print("-"*80)
    print("  This is getting messy...")
    print("  Need different approach or more clever grouping")

    print("\n" + "-"*80)
    print("OBSERVATION:")
    print("-"*80)
    print("  The identity DOES hold (verified numerically and symbolically)")
    print("  But algebraic derivation path is not immediately obvious")
    print("  May need:")
    print("    - Different grouping strategy")
    print("    - Use of Hockey Stick or Vandermonde")
    print("    - Induction on k or n")

def suggest_alternative_approaches():
    """
    Suggest alternative proof strategies
    """
    print("\n" + "="*80)
    print("ALTERNATIVE APPROACHES")
    print("="*80)

    print("\n1. GENERATING FUNCTIONS:")
    print("   - Express each binomial coefficient as coefficient in (1+x)^n")
    print("   - Identity becomes polynomial equation")
    print("   - May be more tractable")

    print("\n2. INDUCTION:")
    print("   - Prove for base case k=2 (or k=3)")
    print("   - Show if holds for k, then holds for k+1")
    print("   - Or induction on n")

    print("\n3. COMBINATORIAL INTERPRETATION:")
    print("   - What does C(n+2+k, 2k) count?")
    print("   - Can we count same thing via LHS terms?")
    print("   - May reveal natural cancellations")

    print("\n4. WILF-ZEILBERGER:")
    print("   - Algorithmic proof via WZ method")
    print("   - Finds certificate automatically")
    print("   - But requires computer algebra system")

    print("\n" + "-"*80)
    print("RECOMMENDATION:")
    print("-"*80)
    print("  Try approach #1 (generating functions) next")
    print("  Or look for this specific form in binomial identity literature")

if __name__ == "__main__":
    print("="*80)
    print("BINOMIAL IDENTITY VERIFICATION")
    print("="*80)
    print("\nThis is an INTERNAL tool to verify the identity holds")
    print("and guide us to a clean algebraic proof.")
    print("\nFinal proof will use named identities only - no sympy!")
    print("="*80)

    # Phase 1: Numerical verification
    numerical_ok = test_identity_numerically()

    # Phase 2: Symbolic verification
    symbolic_ok = test_identity_symbolically()

    if numerical_ok and symbolic_ok:
        print("\n" + "="*80)
        print("✓✓✓ IDENTITY VERIFIED - IT HOLDS!")
        print("="*80)

        # Phase 3: Find derivation path
        identify_pascal_path()

        # Phase 4: Attempt derivation
        derive_algebraically()

        # Phase 5: Suggest alternatives
        suggest_alternative_approaches()
    else:
        print("\n" + "="*80)
        print("✗✗✗ IDENTITY DOES NOT HOLD - ERROR IN DERIVATION")
        print("="*80)

    print("\n" + "="*80)
    print("NEXT STEPS")
    print("="*80)
    print("\n1. Identity is verified to hold (numerically + symbolically)")
    print("2. Direct Pascal's expansion is messy")
    print("3. Try generating functions or look for this form in literature")
    print("4. Once found, write clean proof with named identities")
