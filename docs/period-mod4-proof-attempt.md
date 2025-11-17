# Direct Proof Attempt: Period mod 4 for √p

**Date**: November 17, 2025
**Status**: ⏳ IN PROGRESS
**Goal**: Prove period mod 4 is determined by p mod 8

---

## Known Facts (Classical)

1. **Lagrange**: √p has periodic CF for non-square p
2. **Pell solutions**: Period n determines fundamental solution at convergent_{n-1} or convergent_{2n-1}
3. **Period parity** (classical):
   - p ≡ 1 (mod 4) ⟹ period is ODD
   - p ≡ 3 (mod 4) ⟹ period is EVEN

## Empirical Observation (300/300 primes)

**Refined period structure:**
```
p ≡ 1 (mod 8) ⟹ period ≡ 1 or 3 (mod 4) [ODD]
p ≡ 3 (mod 8) ⟹ period ≡ 2 (mod 4) [100%]
p ≡ 7 (mod 8) ⟹ period ≡ 0 (mod 4) [100%]
```

## Key Hint (from Math Stack Exchange)

At halfway point of period (position n/2 for even period):
```
convergent satisfies: x² - py² = 2·(-1)^(n/2)
```

### Case p ≡ 3 (mod 8)

Period n is even, so n = 2m. At position m:
```
x_m² - p·y_m² = 2·(-1)^m
```

**Question**: When is this solvable?

**Legendre symbol**: (2/p) = -1 for p ≡ 3 (mod 8)

This means **2 is NOT a quadratic residue mod p**.

If m is even (so n = 4k, period ≡ 0 mod 4):
```
x_m² - p·y_m² = 2  [trying positive case]
```

Modulo p:
```
x_m² ≡ 2 (mod p)
```

But (2/p) = -1, so 2 is NOT a QR mod p. **Contradiction!**

So m cannot be even, meaning **period ≡ 2 (mod 4)** ✓

### Case p ≡ 7 (mod 8)

**Legendre symbol**: (2/p) = +1 for p ≡ 7 (mod 8)

This means **2 IS a quadratic residue mod p**.

For period n = 2m with halfway equation:
```
x_m² - p·y_m² = 2·(-1)^m
```

If m is odd (so n = 4k+2, period ≡ 2 mod 4):
```
x_m² - p·y_m² = -2
```

Modulo p:
```
x_m² ≡ -2 (mod p)
```

For this to have solution, need (-2/p) = +1.

By multiplicativity of Legendre symbol:
```
(-2/p) = (-1/p)·(2/p)
```

For p ≡ 7 (mod 8):
- p ≡ 3 (mod 4), so (-1/p) = -1
- p ≡ -1 (mod 8), so (2/p) = +1

Therefore:
```
(-2/p) = (-1)·(+1) = -1
```

So -2 is NOT a QR mod p. **Contradiction!**

Thus m must be even, meaning **period ≡ 0 (mod 4)** ✓

---

## Summary of Argument

| p mod 8 | (2/p) | (-1/p) | (-2/p) | Halfway eqn | m parity | Period mod 4 |
|---------|-------|--------|--------|-------------|----------|--------------|
| 1       | +1    | +1     | +1     | variable    | variable | 1 or 3 (odd) |
| 3       | -1    | -1     | +1     | 2(-1)^m     | **odd**  | **2**        |
| 7       | +1    | -1     | -1     | 2(-1)^m     | **even** | **0**        |

**Key insight**: The halfway equation x² - py² = 2·(-1)^m forces specific m parity based on which of {2, -2} is a QR mod p!

---

## Verification Against Empirical Data

**p ≡ 3 (mod 8)**: Period ≡ 2 (mod 4)
- Theory: m odd ⟹ n = 2m ≡ 2 (mod 4) ✓
- Data: 100/100 primes ✓

**p ≡ 7 (mod 8)**: Period ≡ 0 (mod 4)
- Theory: m even ⟹ n = 2m ≡ 0 (mod 4) ✓
- Data: 100/100 primes ✓

---

## Remaining Questions

1. **Is the "halfway equation" rigorously established?**
   - Hint from Math Stack Exchange, but need classical reference
   - Likely in Perron's 1950s work (German)

2. **Does this argument constitute a proof?**
   - IF halfway equation is true, THEN argument is rigorous
   - Need to verify halfway equation from CF theory

3. **Reference needed**:
   - Perron's original paper
   - Or modern textbook with full CF theory

---

## Confidence Level

**Argument logic**: 95% (clean, uses only Legendre symbols + halfway equation)

**Halfway equation**: 70% (cited but not proven here)

**Overall**: 85% confident this is the correct approach

---

## Next Steps

1. **Find classical reference** for halfway equation
2. **Prove halfway equation** from CF algorithm
3. **Write rigorous version** with all steps justified

**Alternative**: Accept empirical 300/300 verification + this theoretical argument as "strong evidence" pending full proof.

---

**Status**: Promising approach, needs verification of halfway equation claim.
