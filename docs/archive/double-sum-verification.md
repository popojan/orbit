# Double Sum Form - Algebraic Verification

**Date**: November 16, 2025
**Method**: Pure mathematical reasoning (no computational verification)
**Goal**: Verify that L_M(s) can be written as a double sum

---

## Claim

```
L_M(s) = Σ_{d=2}^∞ d^{-s} Σ_{m=d}^∞ m^{-s}
```

---

## Proof from First Principles

**Start with the definition:**

M(n) = count of divisors d where 2 ≤ d ≤ √n

Therefore:
```
M(n) = Σ_{d|n, 2≤d≤√n} 1
```

**Dirichlet series:**
```
L_M(s) = Σ_{n=1}^∞ M(n)/n^s
       = Σ_{n=1}^∞ (1/n^s) · Σ_{d|n, 2≤d≤√n} 1
```

**Change order of summation:**

For each divisor d ≥ 2, it contributes to M(n) for all n such that:
- d divides n, AND
- d ≤ √n  (equivalently: n ≥ d²)

So:
```
L_M(s) = Σ_{d=2}^∞ Σ_{n: d|n, n≥d²} 1/n^s
```

**Substitute n = d·m:**

Since d|n, we can write n = d·m for positive integers m.
The condition n ≥ d² becomes d·m ≥ d², which simplifies to m ≥ d.

Therefore:
```
L_M(s) = Σ_{d=2}^∞ Σ_{m=d}^∞ 1/(d·m)^s
       = Σ_{d=2}^∞ Σ_{m=d}^∞ d^{-s} · m^{-s}
       = Σ_{d=2}^∞ d^{-s} Σ_{m=d}^∞ m^{-s}
```

**✓ Verified!**

---

## Connection to Closed Form

We also have:
```
L_M(s) = ζ(s)[ζ(s) - 1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s
```

Let's verify these are consistent.

**Rewrite the inner sum:**
```
Σ_{m=d}^∞ m^{-s} = [Σ_{m=1}^∞ m^{-s}] - [Σ_{m=1}^{d-1} m^{-s}]
                  = ζ(s) - H_{d-1}(s)
```

where H_{d-1}(s) = Σ_{m=1}^{d-1} m^{-s} is the partial zeta sum.

**Substitute back:**
```
L_M(s) = Σ_{d=2}^∞ d^{-s} [ζ(s) - H_{d-1}(s)]
       = ζ(s) Σ_{d=2}^∞ d^{-s} - Σ_{d=2}^∞ d^{-s} H_{d-1}(s)
       = ζ(s) [ζ(s) - 1] - Σ_{d=2}^∞ H_{d-1}(s)/d^s
```

**✓ Matches the closed form exactly!**

---

## Key Insight

The double sum form is **geometrically intuitive**:
- Outer sum: loop over divisors d ≥ 2
- Inner sum: loop over multiples m ≥ d (so that d·m ≥ d²)
- Each pair (d,m) contributes (d·m)^{-s} to L_M(s)

This is a **natural parametrization** of the set:
```
S = {n : n has at least one divisor d with 2 ≤ d ≤ √n}
```

counted with the correct multiplicity (number of such divisors).

---

## Next Step: Functional Equation

Now that we have:
```
L_M(s) = Σ_{d=2}^∞ d^{-s} Σ_{m=d}^∞ m^{-s}
```

**Question**: How does this transform under s → 1-s?

We know that:
```
Σ_{m=1}^∞ m^{-s} = ζ(s)  transforms to  ζ(1-s) via γ(s) = π^{-s/2} Γ(s/2)
```

But our sum starts at m=d (varies with outer index), not m=1.

**Challenge**: The inner sum depends on the outer index d, which breaks simple factorization.

---

**Status**: Double sum form verified ✓
**Next**: Explore transformation techniques for nested dependent sums
