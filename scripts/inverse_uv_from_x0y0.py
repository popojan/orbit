#!/usr/bin/env python3
"""
INVERZNÍ ÚLOHA: (x₀, y₀) → (u, v)

Pro dané fundamentální řešení (x₀, y₀) Pellovy rovnice x² - p·y² = 1,
najdi všechna (u, v) taková, že:

  x₀ = -(u² + p·v²)/(u² - p·v²)
  y₀ = -(2uv)/(u² - p·v²)

Hledáme pattern v (u, v) mod p podle p mod 8.
"""

from math import gcd, isqrt
from fractions import Fraction

def continued_fraction_sqrt(n):
    """Continued fraction representation of sqrt(n)"""
    if isqrt(n)**2 == n:
        return None

    a0 = isqrt(n)
    cf = [a0]

    m, d, a = 0, 1, a0
    seen = {}

    while True:
        m = d * a - m
        d = (n - m * m) // d
        a = (a0 + m) // d

        state = (m, d)
        if state in seen:
            period_start = seen[state]
            return cf[:period_start], cf[period_start:]

        seen[state] = len(cf)
        cf.append(a)

        if len(cf) > 1000:  # safety
            return None

def pell_fundamental_solution(d):
    """Fundamentální řešení x² - d·y² = 1 přes continued fraction"""
    cf_result = continued_fraction_sqrt(d)
    if cf_result is None:
        return None

    a0_list, period = cf_result
    a0 = a0_list[0] if a0_list else 0

    # Compute convergents until we find solution
    p_prev, p_curr = 0, 1
    q_prev, q_curr = 1, 0

    # First convergent
    p_prev, p_curr = p_curr, a0 * p_curr + p_prev
    q_prev, q_curr = q_curr, a0 * q_curr + q_prev

    # Continue with period
    for i in range(len(period) * 2):  # at most 2 full periods
        a = period[i % len(period)]
        p_prev, p_curr = p_curr, a * p_curr + p_prev
        q_prev, q_curr = q_curr, a * q_curr + q_prev

        if p_curr * p_curr - d * q_curr * q_curr == 1:
            return (p_curr, q_curr)

    return None

def check_rational_pell(u, v, p):
    """
    Spočti x, y z parametrizace rsol[p, u, v]

    Vrací (x, y) jako Fraction (nebo None pokud jmenovatel = 0)
    """
    numerator_x = -(u**2 + p * v**2)
    numerator_y = -(2 * u * v)
    denominator = u**2 - p * v**2

    if denominator == 0:
        return None

    x = Fraction(numerator_x, denominator)
    y = Fraction(numerator_y, denominator)

    return (x, y)

def verify_pell(x, y, p):
    """Ověř x² - p·y² = 1"""
    return x**2 - p * y**2 == 1

def find_uv_for_fundamental(p, max_search=500):
    """
    Pro dané p najdi všechna (u, v) ∈ [1, max_search]² taková, že
    rsol[p, u, v] dává fundamentální řešení (x₀, y₀).
    """
    pell = pell_fundamental_solution(p)
    if pell is None:
        return None

    x0, y0 = pell
    print(f"\np = {p} (mod 8 = {p % 8})")
    print(f"Fundamentální řešení: (x₀, y₀) = ({x0}, {y0})")
    print(f"x₀ mod p = {x0 % p}")

    # Analytická kandidátní volba: (u, v) = (y₀·p, x₀ + 1)
    u_analytic = y0 * p
    v_analytic = x0 + 1

    print(f"\nAnalytická volba: (u, v) = ({u_analytic}, {v_analytic})")

    if u_analytic <= max_search and v_analytic <= max_search:
        result = check_rational_pell(u_analytic, v_analytic, p)
        if result and result[0] == x0 and result[1] == y0:
            print(f"  ✓ Funguje!")
            print(f"  u mod p = {u_analytic % p}")
            print(f"  v mod p = {v_analytic % p}")
            print(f"  gcd(u, v) = {gcd(u_analytic, v_analytic)}")
        else:
            print(f"  ✗ Nefunguje: dostali jsme {result}")
    else:
        print(f"  (mimo rozsah)")

    # Brute force: najdi VŠECHNA (u, v)
    print(f"\nHledám všechna (u, v) ∈ [1, {max_search}]²...")
    solutions = []

    for u in range(1, max_search + 1):
        for v in range(1, max_search + 1):
            result = check_rational_pell(u, v, p)
            if result and result[0] == x0 and result[1] == y0:
                solutions.append((u, v))

    if solutions:
        print(f"Našli jsme {len(solutions)} řešení:")
        for u, v in solutions[:10]:  # prvních 10
            g = gcd(u, v)
            print(f"  (u, v) = ({u:4d}, {v:4d})  gcd={g:3d}  u%p={u%p:3d}  v%p={v%p:3d}  u²%p={(u**2)%p:3d}  v²%p={(v**2)%p:3d}")

        if len(solutions) > 10:
            print(f"  ... (a dalších {len(solutions) - 10})")

        # Hledej pattern v mod p
        u_mod_p_set = set((u % p) for u, v in solutions)
        v_mod_p_set = set((v % p) for u, v in solutions)

        print(f"\nPattern mod p:")
        print(f"  u mod p ∈ {sorted(u_mod_p_set)}")
        print(f"  v mod p ∈ {sorted(v_mod_p_set)}")
    else:
        print("Žádná řešení nenalezena v daném rozsahu.")

    return solutions

# Test pro různá p mod 8
test_primes = {
    1: [17, 41, 73],      # p ≡ 1 (mod 8) - PROVEN x₀ ≡ -1
    3: [3, 11, 19, 43],   # p ≡ 3 (mod 8) - CONJECTURED x₀ ≡ -1
    5: [5, 13, 29, 37],   # p ≡ 5 (mod 8) - PROVEN x₀ ≡ -1
    7: [7, 23, 31, 47]    # p ≡ 7 (mod 8) - CONJECTURED x₀ ≡ +1
}

print("=" * 70)
print("INVERZNÍ ÚLOHA: (x₀, y₀) → (u, v)")
print("=" * 70)

for mod8, primes in test_primes.items():
    print(f"\n{'='*70}")
    print(f"p ≡ {mod8} (mod 8)")
    print(f"{'='*70}")

    for p in primes[:2]:  # jen 2 případy pro každou třídu (rychlost)
        solutions = find_uv_for_fundamental(p, max_search=300)

        if solutions:
            # Analýza: existuje pattern?
            print(f"\n→ ANALÝZA pro p = {p}:")

            # Nejmenší řešení (podle normy u² + v²)
            min_sol = min(solutions, key=lambda uv: uv[0]**2 + uv[1]**2)
            u_min, v_min = min_sol
            print(f"   Nejmenší ||·||: (u, v) = ({u_min}, {v_min})")

            # Primitive řešení (gcd = 1)
            primitive = [(u, v) for u, v in solutions if gcd(u, v) == 1]
            if primitive:
                prim_min = min(primitive, key=lambda uv: uv[0]**2 + uv[1]**2)
                u_p, v_p = prim_min
                print(f"   Nejmenší primitive: (u, v) = ({u_p}, {v_p})")
                print(f"     u² mod p = {(u_p**2) % p}")
                print(f"     v² mod p = {(v_p**2) % p}")

print("\n" + "=" * 70)
print("ZÁVĚR: Hledej pattern v mod p vlastnostech primitive řešení!")
print("=" * 70)
