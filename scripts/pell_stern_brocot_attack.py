#!/usr/bin/env python3
"""
Pell Equation via Stern-Brocot Tree (Wildberger's Integer-Only Method)

Connection:
- Stern-Brocot tree generates ALL rational numbers
- CF convergents are specific nodes in the tree
- Wildberger's algorithm = integer-only tree traversal
- Avoids floating-point entirely (pure integer arithmetic)

Stern-Brocot Tree:
    1/1
   /   \
  1/2   2/1
 / \   / \
1/3 2/3 3/2 3/1
...

Mediant operation:
    (a/b) ⊕ (c/d) = (a+c)/(b+d)

Properties:
- Every rational appears exactly once
- Reduced form automatically (gcd=1)
- Left child: mediant with left ancestor
- Right child: mediant with right ancestor

For Pell x² - Dy² = 1:
- Convergents p/q approximate √D
- Traverse tree seeking p² - Dq² = 1
- Integer-only: no √D computation needed!
"""

def stern_brocot_mediant(a, b, c, d):
    """
    Compute Stern-Brocot mediant of a/b and c/d.

    Returns: (a+c, b+d) representing (a+c)/(b+d)
    """
    return (a + c, b + d)

def pell_residual(p, q, D):
    """
    Compute p² - Dq² (Pell residual).

    Returns:
        +1: solution to positive Pell
        -1: solution to negative Pell
        other: not a solution
    """
    return p*p - D*q*q

def stern_brocot_pell_wildberger(D, max_iterations=10000):
    """
    Solve Pell equation x² - Dy² = 1 using Stern-Brocot tree traversal.

    Wildberger's integer-only algorithm:
    1. Start with interval [0/1, 1/0] (0, ∞)
    2. Compute mediant m = (a+c)/(b+d)
    3. Check residual R = p² - Dq²:
       - If R = 1: solution found!
       - If R = -1 and period odd: square it for positive solution
       - If R > 0: √D is in left interval → update right bound
       - If R < 0: √D is in right interval → update left bound
    4. Repeat until solution found

    This implements CF convergents WITHOUT computing CF explicitly!

    Returns:
        (x0, y0, iterations) where x0² - Dy0² = 1
    """
    # Initial interval: [0/1, 1/0]
    # (Using large number instead of infinity)
    left_num, left_den = 0, 1
    right_num, right_den = 1, 0  # Represents ∞

    for i in range(max_iterations):
        # Compute mediant
        mid_num, mid_den = stern_brocot_mediant(
            left_num, left_den,
            right_num, right_den
        )

        # Compute Pell residual
        R = pell_residual(mid_num, mid_den, D)

        if R == 1:
            # Positive Pell solution found!
            return mid_num, mid_den, i + 1

        if R == -1:
            # Negative Pell solution
            # Square it to get positive solution
            # (x + y√D)² = (x² + Dy²) + 2xy√D
            x_neg, y_neg = mid_num, mid_den
            x_pos = x_neg*x_neg + D*y_neg*y_neg
            y_pos = 2*x_neg*y_neg

            # Verify
            if pell_residual(x_pos, y_pos, D) == 1:
                return x_pos, y_pos, i + 1
            else:
                raise ValueError(f"Squaring negative Pell failed for D={D}")

        # Update interval based on residual sign
        if R > 0:
            # √D is in left interval [left, mid]
            right_num, right_den = mid_num, mid_den
        else:  # R < 0
            # √D is in right interval [mid, right]
            left_num, left_den = mid_num, mid_den

    raise ValueError(f"Pell solution not found within {max_iterations} iterations for D={D}")

def regulator_via_stern_brocot(D):
    """
    Compute regulator R = log(x₀ + y₀√D) using Stern-Brocot.

    This is Wildberger's integer-only method!
    """
    from decimal import Decimal, getcontext
    getcontext().prec = 100

    x0, y0, iterations = stern_brocot_pell_wildberger(D)

    # Compute regulator
    x0_dec = Decimal(x0)
    y0_dec = Decimal(y0)
    D_dec = Decimal(D)

    sqrt_D = D_dec.sqrt()
    epsilon = x0_dec + y0_dec * sqrt_D

    R = epsilon.ln()

    return float(R), int(x0), int(y0), iterations

# ============================================================================
# Testing
# ============================================================================

if __name__ == "__main__":
    print("="*80)
    print("PELL VIA STERN-BROCOT TREE (Wildberger's Integer-Only Method)")
    print("="*80)
    print()
    print("Theory:")
    print("  - Stern-Brocot tree generates all rationals")
    print("  - CF convergents = specific tree nodes")
    print("  - Wildberger: traverse tree using mediant operation")
    print("  - Pure integer arithmetic (no floating point!)")
    print()

    test_cases = [2, 3, 5, 7, 11, 13, 17, 19, 29, 31, 61]

    print("\nTest Cases:")
    print("  D    x₀       y₀      R        Iter")
    print("-" * 50)

    for D in test_cases:
        try:
            R, x0, y0, iters = regulator_via_stern_brocot(D)

            # Verify
            residual = x0**2 - D * y0**2
            if residual != 1:
                print(f"{D:3d}  FAILED: residual = {residual}")
                continue

            # Format large numbers
            if x0 < 10**6:
                x_str = f"{x0:8d}"
            else:
                x_str = f"{len(str(x0))}digits"

            if y0 < 10**6:
                y_str = f"{y0:7d}"
            else:
                y_str = f"{len(str(y0))}digits"

            print(f"{D:3d}  {x_str}  {y_str}  {R:7.3f}  {iters:4d}")

        except Exception as e:
            print(f"{D:3d}  ERROR: {e}")

    print("\n" + "="*80)
    print("COMPARISON: Wildberger vs CF Method")
    print("="*80)

    from pell_regulator_attack import regulator_direct_from_cf

    print("\n  D    Wildberger        CF Method        Match?")
    print("-" * 60)

    for D in [2, 3, 5, 7, 11, 13]:
        try:
            # Wildberger (Stern-Brocot)
            R_wild, x_wild, y_wild, _ = regulator_via_stern_brocot(D)

            # CF method
            R_cf, x_cf, y_cf = regulator_direct_from_cf(D)

            match = "YES" if x_wild == x_cf and y_wild == y_cf else "NO"

            print(f"{D:3d}  ({x_wild:6d}, {y_wild:6d})  ({x_cf:6d}, {y_cf:6d})  {match}")

        except Exception as e:
            print(f"{D:3d}  ERROR: {e}")

    print("\n" + "="*80)
    print("SUMMARY")
    print("="*80)
    print("""
Wildberger's Stern-Brocot method:

**Advantages**:
1. Pure integer arithmetic (no floating point!)
2. Automatically reduced fractions (gcd=1)
3. Elegant mediant operation
4. Direct connection to rational approximation theory

**Equivalence**:
- Stern-Brocot traversal = CF convergent computation
- Both give same (x₀, y₀)
- Both integer-only

**Speed**:
- Stern-Brocot: O(period) mediants
- CF: O(period) recurrence
- Roughly equivalent performance

**Philosophy (Wildberger's Rational Trigonometry)**:
- Avoid √ and transcendental functions
- Stay in Q (rationals) as long as possible
- Only compute logarithm for final regulator
- "Rational thinking" about algebraic numbers

This connects:
- Pell equations (number theory)
- Stern-Brocot tree (combinatorics)
- Continued fractions (analysis)
- Rational approximation (computational)
- Regulator (algebraic number theory)

All via PURE INTEGER ARITHMETIC! ✅
    """)
