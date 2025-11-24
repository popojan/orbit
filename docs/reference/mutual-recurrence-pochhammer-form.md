# Mutual Recurrence: Pochhammer Closed Form

**Discovery Date:** 2023 (pre-Chebyshev rediscovery)
**Rediscovered:** 2025-11-24 (during Egypt-Chebyshev proof work)
**Status:** ✅ Verified k=1..5

---

## Formula

For the Chebyshev mutual recurrence relation:
```
T_{k+1}(x) - x·T_k(x) = -(1-x²)·U_{k-1}(x)
```

The right-hand side has the following **closed form with Pochhammer symbols** for **odd U indices**:

```mathematica
a[k_, n_] := 1/4 (1 + 3 (-1)^k) (-1 + 2 n^2 + k) (-1)^n
             · (2^(-3 + 2 k) (-3 + (-1)^k)) / Gamma[2 k]
             · Pochhammer[n - k + 2, 2 (k - 2) + 1]

subnref[x_, k_] := Sum[a[i, k] x^(2 i - 1), {i, 1, k + 1}]
```

**Identity:**
```
subnref[x, k] = T_{2k+1}(x) - x·T_{2k}(x) = -(1-x²)·U_{2k-1}(x)
```

---

## Verification

| k | Formula | Polynomial | Match |
|---|---------|-----------|--------|
| 1 | subnref[x, 1] | T_3(x) - x·T_2(x) | ✓ |
| 2 | subnref[x, 2] | T_5(x) - x·T_4(x) | ✓ |
| 3 | subnref[x, 3] | T_7(x) - x·T_6(x) | ✓ |
| 4 | subnref[x, 4] | T_9(x) - x·T_8(x) | ✓ |
| 5 | subnref[x, 5] | T_11(x) - x·T_10(x) | ✓ |

**Pattern:** Works for U_{2k-1} (odd indices only)

**Example (k=2):**
```
subnref[x, 2] = 4x - 12x³ + 8x⁵
T_5(x) - x·T_4(x) = 4x - 12x³ + 8x⁵  ✓
```

**Verification script:** `scripts/experiments/verify_subnref_fixed.wl`

---

## Historical Context

### 2023 Discovery

Originally discovered during sqrt rationalization exploration, **before** the connection to Chebyshev polynomials was known.

**Why it was "discarded":** After learning the identity equals `T_{k+1}(x) - x·T_k(x)` and that this has simpler closed form via de Moivre formulas, the Pochhammer form appeared less elegant.

### 2025 Rediscovery

During Egypt-Chebyshev algebraic proof work (November 24, 2025), explored whether mutual recurrence's **factorial structure** could help prove:
```
Factorial form ↔ Chebyshev form equivalence
```

**Result:** Dead end for main proof (works only for odd U indices), but confirms theoretical intuition that mutual recurrence has Pochhammer/factorial structure.

---

## Mathematical Significance

### What This Shows

1. **Mutual recurrence has factorial structure** (encoded via Pochhammer symbols)
2. **Alternative closed form** to de Moivre formulas for this specific case
3. **Connects three mathematical structures:**
   - Chebyshev polynomials (T_n, U_n)
   - Factorial/Pochhammer symbols (rising factorials)
   - Mutual recurrence relations

### Limitations

- **Only odd U indices:** subnref[x, k] gives U_{2k-1}, not arbitrary U_n
- **Not generalizable** to even indices or other Chebyshev products
- **More complex** than de Moivre formulas for practical computation

### Why It Matters

Despite limitations, this formula demonstrates that **explicit factorial/Pochhammer expressions exist** for certain Chebyshev polynomial combinations, which is theoretically interesting for:
- Understanding coefficient structure
- Potential connections to combinatorics
- Orthogonal polynomial theory

---

## Relation to Egypt-Chebyshev Connection

During proof work on:
```
1 + Σ[i=1 to k] 2^(i-1)·x^i·(k+i)!/((k-i)!·(2i)!) = T_n(x+1)·[U_m(x+1) - U_{m-1}(x+1)]
```

The factorial structure in mutual recurrence suggested possible connection to factorial form on left side.

**Outcome**: While mutual recurrence didn't directly help with the proof (works only for odd U indices), the exploration led to using **Petkovšek's FactorialSimplify** (from Gosper package), which **algebraically proved** the factorial recurrence in one line! See `scripts/experiments/factorial_simplify_proof_clean.wl`.

**Attempted connection:**
- Both have Pochhammer/factorial structure ✓
- Mutual recurrence connects T and U polynomials ✓
- Our product also involves T and U polynomials ✓

**Why it didn't work:**
- Our product needs U_m - U_{m-1} for **all m** (both even and odd)
- subnref only covers odd U indices (2k-1)
- No direct way to bridge the gap

**Conclusion:** Interesting parallel structure, but not a shortcut to the proof.

---

## Implementation

### Wolfram Language

```mathematica
(* Define coefficient formula *)
a[k_, n_] := 1/4 (1 + 3 (-1)^k) (-1 + 2 n^2 + k) (-1)^n
             (2^(-3 + 2 k) (-3 + (-1)^k))/Gamma[2 k]
             Pochhammer[n - k + 2, 2 (k - 2) + 1];

(* Define polynomial *)
subnref[x_, k_] := Sum[a[i, k] x^(2 i - 1), {i, 1, k + 1}];

(* Example: k=2 *)
subnref[x, 2]
(* Output: 4*x - 12*x^3 + 8*x^5 *)

(* Verify *)
Simplify[subnref[x, 2] - (ChebyshevT[5, x] - x ChebyshevT[4, x])]
(* Output: 0 *)
```

### Performance Note

For practical computation, **use standard Chebyshev formulas** instead:
- Faster (direct recursion)
- More numerically stable
- Works for all indices

Use subnref for **theoretical analysis** of coefficient structure.

---

## Future Research Directions

1. **Generalization:** Can similar Pochhammer form be found for arbitrary U_n - U_{n-1}?
2. **Even indices:** Why does formula only work for odd? What's the structural difference?
3. **Combinatorial interpretation:** What counting problem does a[k, n] solve?
4. **Connection to other orthogonal polynomials:** Do Legendre/Jacobi have similar forms?

---

## References

**Verification:**
- `scripts/experiments/verify_subnref_fixed.wl` - Verification k=1..5
- `scripts/experiments/verify_user_test.wl` - Pattern discovery
- `scripts/experiments/explore_mutual_recurrence_connection.wl` - Egypt-Chebyshev connection attempt

**Related documents:**
- `docs/proofs/egypt-chebyshev-proof-status.md` - Overall proof status
- `docs/sessions/2025-11-23-chebyshev-integral-identity/chebyshev-integral-theorem.md` - Mutual recurrence reference

**Literature:**
- Mason & Handscomb (2003) - *Chebyshev Polynomials* - Mutual recurrence (standard form)

---

**Last updated:** 2025-11-24
**Session:** egypt-chebyshev-proof (mutual recurrence exploration)
