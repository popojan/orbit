# Symbolic Derivation of Res[L_M, s=1]

**Goal:** Prove rigorously that Res[L_M(s), s=1] = 2γ - 1

## Step 1: Laurent Expansion of ζ(s)[ζ(s)-1]

**Known:** Near s=1, the Riemann zeta function has expansion:
```
ζ(s) = 1/(s-1) + γ + γ₁(s-1) + O((s-1)²)
```
where γ = EulerGamma ≈ 0.5772156649...

**Compute product:**
```
ζ(s) - 1 = 1/(s-1) + γ - 1 + γ₁(s-1) + O((s-1)²)
         = 1/(s-1) + (γ-1) + O(s-1)

ζ(s)[ζ(s)-1] = [1/(s-1) + γ + O(s-1)] · [1/(s-1) + (γ-1) + O(s-1)]
```

**Expand:**
```
= 1/(s-1)²
  + 1/(s-1) · (γ-1)     [from first term × second term constant]
  + γ/(s-1)             [from first term constant × second term leading]
  + O(1)

= 1/(s-1)² + [(γ-1) + γ]/(s-1) + O(1)
= 1/(s-1)² + (2γ-1)/(s-1) + O(1)
```

**Result:**
```
ζ(s)[ζ(s)-1] = 1/(s-1)² + (2γ-1)/(s-1) + [constant] + O(s-1)
```

✓ **Coefficient of double pole:** 1
✓ **Coefficient of simple pole:** 2γ - 1 ≈ 0.1544313298...

## Step 2: Laurent Expansion of C(s)

**Definition:**
```
C(s) = Σ[j=2,∞] H_{j-1}(s)/j^s
```
where
```
H_j(s) = Σ[k=1,j] k^{-s}
```

**Strategy:** Expand H_j(s) near s=1.

**Known Euler-Maclaurin formula for harmonic sums:**
```
H_j(s) = Σ[k=1,j] k^{-s}
```

Near s=1:
```
k^{-s} = k^{-1} · k^{-(s-1)}
       = k^{-1} · e^{-(s-1)ln(k)}
       = k^{-1} · [1 - (s-1)ln(k) + O((s-1)²)]
       = k^{-1} - (s-1)·k^{-1}ln(k) + O((s-1)²)
```

Therefore:
```
H_j(s) = Σ[k=1,j] [k^{-1} - (s-1)·k^{-1}ln(k) + O((s-1)²)]
       = H_j - (s-1)·Σ[k=1,j] k^{-1}ln(k) + O((s-1)²)
```

where H_j = Σ[k=1,j] k^{-1} is the j-th harmonic number.

**Known:** For large j:
```
H_j ≈ ln(j) + γ + 1/(2j) + O(1/j²)
```

**Now analyze C(s):**
```
C(s) = Σ[j=2,∞] H_{j-1}(s)/j^s
     = Σ[j=2,∞] [H_{j-1} - (s-1)·T_{j-1} + O((s-1)²)] / j^s
```

where T_j = Σ[k=1,j] k^{-1}ln(k).

**KEY QUESTION:** Does C(s) have a pole at s=1, and if so, what order?

**Heuristic check:** At s=1:
```
C(1) = Σ[j=2,∞] H_{j-1}/j
```

Since H_j ~ ln(j) + γ:
```
C(1) ~ Σ[j=2,∞] ln(j)/j + γ·Σ[j=2,∞] 1/j
```

Both sums **diverge**! So C(s) is **not analytic** at s=1.

**Refined analysis needed:** What is the pole structure?

### Method: Compare with known divergent series

**Claim:** C(s) has expansion near s=1:
```
C(s) = A_C/(s-1)² + B_C/(s-1) + D + O(s-1)
```

**From numerics:** We found that L_M(s) has:
- A = 1 (double pole coefficient)
- Res = 2γ-1 (simple pole coefficient)

**Therefore:**
```
L_M(s) = ζ(s)[ζ(s)-1] - C(s)
       = [1/(s-1)² + (2γ-1)/(s-1) + ...] - [A_C/(s-1)² + B_C/(s-1) + ...]
       = (1-A_C)/(s-1)² + (2γ-1-B_C)/(s-1) + ...
```

**Matching coefficients:**
```
1 - A_C = 1  =>  A_C = 0
2γ-1 - B_C = 2γ-1  =>  B_C = 0
```

**CONCLUSION:** C(s) has **NO POLE** at s=1! It is analytic there.

But wait - that contradicts the divergence of C(1)...

**RESOLUTION:** Need more careful analysis of the double sum.

## Step 3: Rigorous Analysis of C(s)

TODO: Apply Euler-Maclaurin or contour integration to determine pole structure precisely.

**Alternative approach:** Compute directly:
```
lim_{s→1} (s-1)² · C(s) = ?
lim_{s→1} (s-1) · C(s) = ?
```

If first limit is 0 and second is finite, C(s) has simple pole.
If first limit is finite ≠ 0, C(s) has double pole.
If both limits are 0, C(s) might have no pole.

**Status:** REQUIRES FURTHER SYMBOLIC WORK
