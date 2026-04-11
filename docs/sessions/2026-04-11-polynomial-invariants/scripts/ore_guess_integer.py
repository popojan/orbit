"""
Guess holonomic recurrences for integer slopes (k=2, k=3)
using ore_algebra — easy cases first as validation.

Expected:
  k=2: order 3, degree 4
  k=3: order 5, degree 8
"""

import sys
import os

from passagemath_flint import QQ, ZZ, PolynomialRing
from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

# Setup shift operator algebra
Rn = PolynomialRing(QQ, 'n')
n = Rn.gen()
An = OreAlgebra(Rn, 'Sn')
Sn = An.gen()

# Also setup differential operator algebra for ODE
Rx = PolynomialRing(QQ, 'x')
x = Rx.gen()
Ax = OreAlgebra(Rx, 'Dx')
Dx = Ax.gen()

scripts_dir = os.path.dirname(__file__)

for slope_name, filename, expected_ord in [("2 (k=2)", "seq_slope_2.txt", 3),
                                            ("3 (k=3)", "seq_slope_3.txt", 5)]:
    seq_file = os.path.join(scripts_dir, filename)
    if not os.path.exists(seq_file):
        print(f"=== Slope {slope_name}: file {filename} not ready yet, skipping ===\n")
        continue

    with open(seq_file) as f:
        seq = [ZZ(line.strip()) for line in f if line.strip()]

    print(f"=== Slope {slope_name} ({len(seq)} terms) ===")
    print(f"First 10: {seq[:10]}")
    sys.stdout.flush()

    # Guess shift recurrence
    print(f"Guessing recurrence (expected order {expected_ord})...")
    sys.stdout.flush()
    rec = guess(seq, An)
    print(f"  Order: {rec.order()}")
    print(f"  Operator: {rec}")
    print()

    # Print polynomial coefficients
    print("  Coefficients p_i(n):")
    for i in range(rec.order() + 1):
        coeff = rec[i]
        deg = coeff.degree() if hasattr(coeff, 'degree') else '?'
        print(f"    p_{i}(n) = {coeff}  [deg {deg}]")
    print()

    # Guess ODE for GF
    print("  Guessing ODE...")
    sys.stdout.flush()
    try:
        ode = guess(seq, Ax)
        print(f"  ODE order: {ode.order()}")
        print(f"  ODE: {ode}")
    except Exception as e:
        print(f"  ODE guess failed: {e}")
    print()

    # Try to factor the recurrence operator
    print("  Factoring recurrence operator...")
    sys.stdout.flush()
    try:
        factors = rec.factor()
        print(f"  Factors: {factors}")
    except Exception as e:
        print(f"  Factorization failed: {e}")
    print()
    print("=" * 60)
    print()
