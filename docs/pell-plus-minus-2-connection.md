# Pell ±2 Connection to Period Divisibility

**Date**: 2025-11-17
**Status**: 🔬 NUMERICAL (45 primes < 200: 12 mod 3, 12 mod 7)

---

## Discovery

**Convergent at period/2 always solves Pell ±2:**

**p ≡ 7 (mod 8):**
```
period ≡ 0 (mod 4) ⟺ convergent at period/2 has norm +2
Examples: p=7,23,31,47 all have x²-py²=+2 at half-period
```

**p ≡ 3 (mod 8):**
```
period ≡ 2 (mod 4) ⟺ convergent at period/2 has norm -2
Examples: p=3,11,19,43 all have x²-py²=-2 at half-period
```

**Sample:** 24/24 primes tested, 100% pattern.

---

## Mechanismus

**Period divisibility encodes solvability of Pell ±2:**
- Norm ±2 relates to how prime 2 splits in Q(√p)
- (2/p) Legendre symbol determines p mod 8
- CF period structure reflects this splitting

**Connection:**
```
p mod 8 → (2/p) → splitting of 2 → Pell ±2 solvability → period mod 4
```

---

## Next Test

**Quarter-period (period/4) structure?**

---

**Reference**: `scripts/test_unit_period_connection.wl`
