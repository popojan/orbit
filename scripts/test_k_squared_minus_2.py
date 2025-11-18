#!/usr/bin/env python3
"""
Test: Souvisí p ≡ 7 (mod 8) s tvarem k² - 2?

Hypotéza: p ≡ 7 (mod 8) často (vždy?) má tvar p = k² - 2 pro liché k.

Teoreticky:
  k liché → k² ≡ 1 (mod 8) → k² - 2 ≡ 7 (mod 8)

Takže: p = k² - 2 ⟹ p ≡ 7 (mod 8)

Otázka: Je opak pravda? p ≡ 7 (mod 8) ⟹ ∃k: p = k² - 2?
"""

from math import isqrt

def is_prime(n):
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, isqrt(n) + 1, 2):
        if n % i == 0:
            return False
    return True

def primes_up_to(limit):
    return [p for p in range(2, limit) if is_prime(p)]

def check_k_squared_minus_2(p):
    """
    Zkontroluj, jestli p = k² - 2 pro nějaké k.
    Pokud ano, vrať k.
    """
    # p = k² - 2 ⟹ k² = p + 2
    k_squared = p + 2
    k = isqrt(k_squared)

    if k * k == k_squared:
        return k
    else:
        return None

# Test pro p ≡ 7 (mod 8) do 1000
print("=" * 70)
print("TEST: p ≡ 7 (mod 8) vs tvar k² - 2")
print("=" * 70)

primes = primes_up_to(1000)
primes_mod7_8 = [p for p in primes if p % 8 == 7]

print(f"\nCelkem prvočísel p ≡ 7 (mod 8) do 1000: {len(primes_mod7_8)}")

# Zkontroluj, které mají tvar k² - 2
form_k2_minus_2 = []
not_form = []

for p in primes_mod7_8:
    k = check_k_squared_minus_2(p)
    if k is not None:
        form_k2_minus_2.append((p, k))
    else:
        not_form.append(p)

print(f"Prvočísel tvaru k² - 2: {len(form_k2_minus_2)}")
print(f"Prvočísel NENÍ tvaru k² - 2: {len(not_form)}")

print(f"\n{'='*70}")
print(f"p ≡ 7 (mod 8) tvaru k² - 2:")
print(f"{'='*70}")
for p, k in form_k2_minus_2[:20]:
    print(f"  p = {p:3d} = {k}² - 2  (k = {k})")

if len(form_k2_minus_2) > 20:
    print(f"  ... (a dalších {len(form_k2_minus_2) - 20})")

print(f"\n{'='*70}")
print(f"p ≡ 7 (mod 8) NENÍ tvaru k² - 2:")
print(f"{'='*70}")
for p in not_form[:30]:
    # Jak daleko je od nejbližšího perfect square?
    nearest_k = isqrt(p + 2)
    dist_below = p - (nearest_k**2 - 2)
    dist_above = ((nearest_k + 1)**2 - 2) - p
    print(f"  p = {p:3d}  |  nearest: {nearest_k}²-2={nearest_k**2-2:3d}  |  dist: +{dist_below}")

if len(not_form) > 30:
    print(f"  ... (a dalších {len(not_form) - 30})")

# Statistika vzdálenosti od perfect squares
print(f"\n{'='*70}")
print(f"ZÁVĚR:")
print(f"{'='*70}")

frac = len(form_k2_minus_2) / len(primes_mod7_8) if primes_mod7_8 else 0
print(f"Zlomek p ≡ 7 (mod 8) tvaru k² - 2: {frac:.2%}")

if frac < 0.5:
    print(f"→ NE, p ≡ 7 (mod 8) NENÍ ekvivalentní k² - 2")
    print(f"→ Ale VŠECHNA k² - 2 (k liché) ≡ 7 (mod 8)!")
    print(f"\nSpeciální podtřída: p = k² - 2 je 'blízko perfect square'")
else:
    print(f"→ Možná je tam hlubší souvislost!")

# Test hypotézy: u = p pro p = k² - 2?
print(f"\n{'='*70}")
print(f"HYPOTÉZA: Pro p = k² - 2, primitive (u,v) má u = p?")
print(f"{'='*70}")

from inverse_uv_from_x0y0 import pell_fundamental_solution, check_rational_pell
from math import gcd

for p, k in form_k2_minus_2[:5]:
    pell = pell_fundamental_solution(p)
    if pell:
        x0, y0 = pell
        # Najdi primitive (u, v)
        found = False
        for u_test in range(1, min(300, 5*p)):
            for v_test in range(1, min(300, 5*p)):
                if gcd(u_test, v_test) == 1:
                    result = check_rational_pell(u_test, v_test, p)
                    if result and result[0] == x0 and result[1] == y0:
                        print(f"p={p} (={k}²-2): x₀={x0} (mod p: {x0%p}), primitive (u,v)=({u_test},{v_test}), u%p={u_test%p}")
                        found = True
                        break
            if found:
                break
