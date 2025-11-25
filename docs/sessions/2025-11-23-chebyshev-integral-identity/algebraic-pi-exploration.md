# Algebraic π Exploration - Work in Progress

**Date:** 2025-11-25
**Status:** WIP - context overflow, to be continued

## Summary

Exploring connection between two constructions that "eliminate" π:

1. **Algebraic circle parametrization** (circj/circi) → integer period
2. **Chebyshev integral identity** → ratio 1/π invariant

## Key Findings

### Two Parametrizations

**circj** (unit circle, r=1):
```
z = (a - i)^(4k) / (a² + 1)^(2k)
```

**circi** (circle r=√2):
```
z = (1 + i) · ((a + i)^4)^k / (a² + 1)^(2k)
```

For a = √3: both have period 3.
For a = cot(π/(2n)): period = n (algebraic for constructible n).

### Integral Identity

For f_k(x) = T_{k+1}(x) - x·T_k(x):
```
∫_{-1}^{1} |f_k(x)| dx = 1  for k ≥ 2
```

### Scaling Law (NEW)

For circle with radius r, define:
```
g_k(x) = r · f_k(x/r)
```

Then:
```
∫_{-r}^{r} |g_k(x)| dx = r²
```

Ratio to circle area:
```
r² / (π·r²) = 1/π
```

**Invariant for all r!**

Verified numerically for r = 1, √2, √3, 2, 3.

### Connection via Cyclotomic Fields

Both constructions use same algebraic values:
- cos(nπ/k) — roots of f_k
- cot(π/(2n)) — parametrization constant

These live in cyclotomic fields Q(ζ_m) where ζ_m = e^(2πi/m).

Key insight: ζ_m is **algebraic** (root of x^m - 1 = 0), so π is "hidden" in algebraic structure.

Example:
- e^(iπ/3) = (1 + i√3)/2 — transcendental form
- (1 + i√3)/2 is root of z^6 = 1 — algebraic form

Same object, two representations.

### Points on Circle - Rotation Relationship

For k=3:
- Points from x² + f_k(x)² = 1: angles π/2, -5π/6, -π/6
- Points from circj parametrization: angles 0, -2π/3, 2π/3

Both form equilateral triangle, rotated by π/2 relative to each other.

## Open Questions

1. **Direct relationship?** Is there a formula connecting:
   - Integer period from algebraic parametrization
   - 1/π ratio from integral identity

2. **Algebraic definition of π?** Can we define π purely algebraically via:
   ```
   π = r² / ∫_{-r}^{r} |g_k(x)| dx
   ```
   (Problem: integral not algebraic in closed form)

3. **Cyclotomic connection:** Both use Q(ζ_{2k}). Is this the deep link?

4. **Farey connection:** Partial sums of signed integral J_k are Farey neighbors of 1/2. Related to algebraic parametrization?

## Technical Notes

### Verified Algebraically

```mathematica
(* Period 3 for a = √3 *)
(Sqrt[3] - I)^12 == 4096  (* = 4^6 = (1+3)^6 *)

(* Points from circj *)
circjAlg[k_, a_] := (a - I)^(4k) / (a^2 + 1)^(2k);
circjAlg[3, Sqrt[3]] == circjAlg[0, Sqrt[3]] == 1  (* True *)

(* Scaling law *)
fk[x_, k_] := ChebyshevT[k+1, x] - x*ChebyshevT[k, x];
NIntegrate[Abs[r * fk[x/r, k]], {x, -r, r}] == r^2  (* for any r, k≥2 *)
```

### Files

- `/home/jan/github/orbit/docs/reference/algebraic-circle-parametrizations.md` — original doc
- `/home/jan/github/orbit/scripts/experiments/visualize_circles.wl` — circi/circj code
- `/home/jan/github/orbit/docs/sessions/2025-11-23-chebyshev-integral-identity/arxiv-note-draft.tex` — paper

## Next Steps

1. Formalize cyclotomic field connection
2. Look for direct formula linking period and 1/π ratio
3. Consider if this deserves separate paper or just extended remark
4. Consult literature on algebraic geometry / transcendence theory

---

**Note:** This exploration started from user question "Could we combine 1/π observation with algebraic circle parametrization where π vanishes?"
