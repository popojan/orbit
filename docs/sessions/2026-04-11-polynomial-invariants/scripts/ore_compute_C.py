"""
Compute asymptotic constant C(3/2) to high precision using the recurrence.

Strategy:
1. Use ore_algebra's recurrence of order 12 to extend the sequence far beyond 500 terms
2. Extract C from a(n) * sqrt(pi*n) / 4^n → C as n → ∞
3. Also compute C(k) for integer k and verify against known values

The recurrence p_0(n) a(n) + p_1(n) a(n+1) + ... + p_12(n) a(n+12) = 0
can be used to compute a(n+12) from a(n)...a(n+11) by dividing by p_12(n).
"""

import sys
import os
import time
from fractions import Fraction

from passagemath_flint import QQ, ZZ, PolynomialRing, RealBallField
from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

scripts_dir = os.path.dirname(__file__)

def extend_sequence(seq, rec, target_length):
    """Extend sequence using recurrence, exact rational arithmetic."""
    ord = rec.order()
    coeffs = [rec[i] for i in range(ord + 1)]

    # Convert to Python callables for speed
    n_var = rec.base_ring().gen()

    extended = list(seq)
    for n in range(len(extended) - ord, target_length - ord):
        # Compute a(n+ord) from a(n), ..., a(n+ord-1)
        # p_ord(n) * a(n+ord) = - sum_{i=0}^{ord-1} p_i(n) * a(n+i)
        leading = coeffs[ord](n)
        if leading == 0:
            print(f"  Warning: leading coeff vanishes at n={n}")
            break
        rhs = sum(-coeffs[i](n) * extended[n + i] for i in range(ord))
        val = rhs / leading
        if val.denominator() != 1:
            print(f"  Warning: non-integer at n={n+ord}: {val}")
            break
        extended.append(ZZ(val))

    return extended

def estimate_C(seq, N_values):
    """Estimate C from a(n) * sqrt(pi*n) / 4^n using log arithmetic."""
    import math
    results = []
    for n in N_values:
        if n >= len(seq):
            break
        a_n = int(seq[n])
        if a_n <= 0:
            continue
        # Use math.log on large Python int (works natively)
        log_a = math.log(a_n)
        log_4n = n * math.log(4)
        log_sqrt = 0.5 * math.log(math.pi * n)
        log_C = log_a + log_sqrt - log_4n
        C = math.exp(log_C)
        results.append((n, C))
    return results

# === Slope k=2 (control) ===
print("=== Slope k=2 (control: C = 1/phi^2 = (3-sqrt(5))/2 ≈ 0.38197) ===")
seq_file = os.path.join(scripts_dir, "seq_slope_2.txt")
with open(seq_file) as f:
    seq2 = [ZZ(line.strip()) for line in f if line.strip()]

Rn = PolynomialRing(QQ, 'n')
An = OreAlgebra(Rn, 'Sn')

print("Guessing recurrence...")
rec2 = guess(seq2, An)
print(f"  Order: {rec2.order()}, max deg: {max(rec2[i].degree() for i in range(rec2.order()+1))}")

print("Extending to 2000 terms...")
t0 = time.time()
seq2_ext = extend_sequence(seq2, rec2, 2000)
print(f"  Extended to {len(seq2_ext)} terms in {time.time()-t0:.1f}s")

estimates = estimate_C(seq2_ext, [100, 200, 500, 1000, 1500, 1999])
for n, C in estimates:
    print(f"  n={n:5d}: C ≈ {C:.15f}")

import math
C2_exact = (3 - math.sqrt(5)) / 2
print(f"  Exact:  C = {C2_exact:.15f}")
print()

# === Slope k=3 ===
print("=== Slope k=3 (C = smallest root of x^3 - 4x^2 + 6x - 2 = 0) ===")
seq_file = os.path.join(scripts_dir, "seq_slope_3.txt")
with open(seq_file) as f:
    seq3 = [ZZ(line.strip()) for line in f if line.strip()]

print("Guessing recurrence...")
rec3 = guess(seq3, An)
print(f"  Order: {rec3.order()}, max deg: {max(rec3[i].degree() for i in range(rec3.order()+1))}")

print("Extending to 2000 terms...")
t0 = time.time()
seq3_ext = extend_sequence(seq3, rec3, 2000)
print(f"  Extended to {len(seq3_ext)} terms in {time.time()-t0:.1f}s")

estimates = estimate_C(seq3_ext, [100, 200, 500, 1000, 1500, 1999])
for n, C in estimates:
    print(f"  n={n:5d}: C ≈ {C:.15f}")
print()

# === Slope 3/2 ===
print("=== Slope 3/2 (C likely transcendental) ===")
seq_file = os.path.join(scripts_dir, "seq_slope_3_2.txt")
with open(seq_file) as f:
    seq32 = [ZZ(line.strip()) for line in f if line.strip()]

print("Guessing recurrence...")
rec32 = guess(seq32, An)
print(f"  Order: {rec32.order()}, max deg: {max(rec32[i].degree() for i in range(rec32.order()+1))}")

print("Extending to 5000 terms...")
sys.stdout.flush()
t0 = time.time()
seq32_ext = extend_sequence(seq32, rec32, 5000)
print(f"  Extended to {len(seq32_ext)} terms in {time.time()-t0:.1f}s")

estimates = estimate_C(seq32_ext, [100, 200, 500, 1000, 2000, 3000, 4000, 4999])
for n, C in estimates:
    print(f"  n={n:5d}: C ≈ {C:.15f}")

print()
print("=== Summary ===")
print(f"  C(2) ≈ {C2_exact:.15f} (exact: 1/phi^2)")
if estimates:
    print(f"  C(3/2) ≈ {estimates[-1][1]:.15f} (numerical, n={estimates[-1][0]})")
