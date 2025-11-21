# Tracking Where Epsilon Disappeared

**Date:** November 17, 2025
**Question:** Where did ε disappear from formulas going from P-norm to L_M(s)?
**Goal:** See if we can reintroduce ε as regularization for C(s)

---

## Step-by-Step Epsilon Journey

### Step 1: Primal Forest with Epsilon (Original)

**Formula:**
```
F_n(α,ε) = Σ_{d=2}^∞ Σ_{k=0}^∞ [(n-kd-d²)² + ε]^{-α}
```

**ε purpose:** Regularizes division by zero when n = kd+d² (exact factorization).

**Status:** ε is EXPLICIT parameter.

---

### Step 2: Epsilon-Pole Residue Theorem (Limit)

**Proven result:**
```
lim_{ε→0} ε^α · F_n(α,ε) = M(n)
```

where:
```
M(n) = ⌊(τ(n)-1)/2⌋
```

**Key decomposition:**
```
F_n(α,ε) = S_n(ε) + R_n(α,ε)
```

where:
- **S_n(ε)** = Σ over (d,k) with n=kd+d² → each term = ε^{-α}
- **R_n(α,ε)** = Σ over other (d,k) → all terms finite

**Crucial bound (from proof):**
```
R_n(α,ε) ≤ R_n(α,0) = Σ |dist(d,k)|^{-2α} < ∞  for α > 1/2
```

**What happens:**
```
ε^α · F_n = ε^α [M(n)·ε^{-α} + R_n(α,ε)]
          = M(n) + ε^α · R_n(α,ε)
          → M(n) + 0
          = M(n)
```

**EPSILON LOST HERE:** We took lim_{ε→0}!

---

### Step 3: Define L_M(s) (No Epsilon)

**Dirichlet series:**
```
L_M(s) = Σ_{n=2}^∞ M(n)/n^s
```

**Epsilon is GONE:** We use M(n) = lim_{ε→0} ε^α F_n, which already took the limit!

---

### Step 4: Closed Form for L_M(s) (Algebra Only)

**Derivation:**
```
L_M(s) = Σ_{n=2}^∞ [Σ_{d: d|n, 2≤d≤√n} 1]/n^s
       = Σ_{d=2}^∞ Σ_{m=d}^∞ 1/(dm)^s
       = Σ_{d=2}^∞ d^{-s} [ζ(s) - H_{d-1}(s)]
       = ζ(s)[ζ(s)-1] - C(s)
```

**No epsilon anywhere:** Pure combinatorics + zeta functions.

---

## Could We Reintroduce Epsilon?

### Idea 1: Define Epsilon-Regularized L_M

**Analog of F_global:**
```
L_M(s,ε) = Σ_{n=2}^∞ [ε^α · F_n(α,ε)]/n^s
```

**Then:**
```
lim_{ε→0} L_M(s,ε) = Σ_{n=2}^∞ M(n)/n^s = L_M(s)
```

**Expand:**
```
L_M(s,ε) = Σ_{n} [ε^α · S_n(ε) + ε^α · R_n(α,ε)]/n^s
         = Σ_{n} M(n)/n^s + Σ_{n} [ε^α · R_n(α,ε)]/n^s
         = L_M(s) + ε^α · R_global(α,ε,s)
```

where:
```
R_global(α,ε,s) = Σ_{n=2}^∞ R_n(α,ε)/n^s
```

**Question:** What is R_global?

---

### Analysis of R_global

**From proof:** R_n(α,ε) ≤ R_n(α,0) < ∞ for each n.

**Bound:**
```
R_n(α,0) ≤ 2ζ(2α)[ζ(2α)-1]  (from proof, independent of n!)
```

Wait, that can't be right - the bound should depend on n...

Let me re-read the proof more carefully.

**From line 259-266:** For FIXED d,
```
Σ_{k≠k_0} |dist(d,k)|^{-2α} ≤ 2d^{-2α} ζ(2α)
```

Then summing over d≥2:
```
R_n(α,0) ≤ 2ζ(2α) Σ_{d=2}^∞ d^{-2α} = 2ζ(2α)[ζ(2α)-1]
```

**This IS independent of n!** The bound is UNIFORM.

**Therefore:**
```
R_global(α,ε,s) = Σ_{n=2}^∞ R_n(α,ε)/n^s
                 ≤ [2ζ(2α)(ζ(2α)-1)] · Σ_{n=2}^∞ 1/n^s
                 = [2ζ(2α)(ζ(2α)-1)] · [ζ(s)-1]
```

**For s = 1+δ:**
```
R_global(α,ε,1+δ) ≤ [constant] · [ζ(1+δ)-1]
                   ~ [constant]/δ  as δ→0
```

**And:**
```
ε^α · R_global ~ ε^α/δ
```

**As ε→0:** This → 0 for fixed δ > 0.

---

## Connection to C(s)?

**We have:**
```
L_M(s,ε) = L_M(s) + ε^α · R_global(α,ε,s)
```

**And:**
```
L_M(s) = ζ(s)[ζ(s)-1] - C(s)
```

**So:**
```
L_M(s,ε) = ζ(s)[ζ(s)-1] - C(s) + ε^α · R_global
```

**Rearrange:**
```
C(s) = ζ(s)[ζ(s)-1] - L_M(s,ε) + ε^α · R_global
```

**But this doesn't obviously help bound C(s)!**

---

## Alternative: Epsilon in C(s) Directly?

**C(s) formula:**
```
C(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s
```

**Could we regularize partial sums?**
```
H_j(s,ε) = Σ_{k=1}^j [k^{-s} + ε correction]?
```

**Problem:** Not clear what ε would mean here.

**Original ε:** Regularizes distance^2 + ε in P-norm.

**In C(s):** No distances, just zeta partial sums.

**Connection unclear.**

---

## Where Epsilon Is Truly Lost

**The critical step:**

Going from F_n(α,ε) (has ε) to M(n) (no ε) by taking limit.

**Once M(n) is defined** as the limit value, ε is baked into the definition.

**L_M(s) = Σ M(n)/n^s** uses this ε-free M(n).

**To keep ε alive**, we'd need to work with F_n(α,ε) BEFORE taking limit, i.e., study L_M(s,ε) directly.

---

## Possible Path Forward?

### Idea: Study L_M(s,ε) vs L_M(s)

**Define:**
```
L_M(s,ε) = Σ_{n=2}^∞ [ε^α F_n(α,ε)]/n^s
         = L_M(s) + ε^α R_global(α,ε,s)
```

**If we can bound R_global analytically**, then:
```
|L_M(s,ε) - L_M(s)| = ε^α |R_global(α,ε,s)|
                     ≤ ε^α · [bound]
```

**For s = 1+δ:**
```
|L_M(1+δ,ε) - L_M(1+δ)| ≤ ε^α · [constant]/δ
```

**But we want to bound C(1+δ)**, not L_M directly...

---

## Status: Promising Direction But No Immediate Breakthrough

**What we found:**

1. ✅ **Epsilon disappears** when taking lim_{ε→0} to define M(n)
2. ✅ **R_n(α,ε) is uniformly bounded** (key from epsilon-pole proof!)
3. ✅ **Can define L_M(s,ε)** = Σ [ε^α F_n]/n^s
4. ❓ **How this bounds C(s)** is not immediately clear

**Next step:**

Study R_global(α,ε,s) more carefully. Maybe its structure relates to C(s)?

Or: Can we express C(s) in terms of R_n somehow?

---

## User's Questions Addressed

**Q: "Divisory >√n jsou technicky divisors, ale childhood funkce počítá jen hlavní"**
- ✅ Ano, M(n) counts only 2 ≤ d ≤ √n (hlavní divisors)
- Větší divisors d > √n jsou komplementární, excluded from M(n)

**Q: "V kterou chvíli se epsilon ztratilo?"**
- ✅ TRACKED: Lost when taking lim_{ε→0} to define M(n) from F_n(α,ε)
- This happens BEFORE creating L_M(s)

**Q: "Jsme schopni to vytrackovat?"**
- ✅ ANO: Epsilon journey documented step-by-step

**Q: "Třeba Tě to nasměruje?"**
- ✅ Key insight: **R_n(α,ε) is uniformly bounded** (from epsilon-pole proof)
- This might be useful for bounding something related to C(s)
- But connection not yet clear

---

## Conclusion

**Epsilon tracking:** Complete ✓

**Reintroducing epsilon:** Possible via L_M(s,ε) but doesn't immediately solve C(s) bound problem

**Key discovery:** R_n uniform bound from epsilon-pole proof might be useful

**Status:** Need deeper insight to connect R_n boundedness to C(s) analytical bound
