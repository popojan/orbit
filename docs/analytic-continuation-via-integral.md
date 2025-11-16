# Analytic Continuation via Integral Representation

**Date:** November 17, 2025
**Goal:** Understand where L_M(s) is defined beyond Re(s) > 1
**Method:** Analyze integral representation convergence

---

## Integral Representation (Recall)

```
L_M(s) = 1/Γ(s) ∫₀^∞ t^{s-1} K(t) dt
```

where:
```
K(t) = [Li_s(e^{-t}) - e^{-t}]/(1-e^{-t})
```

and Li_s(z) = Σ_{n=1}^∞ z^n/n^s is the polylogarithm.

---

## Convergence Analysis

### Split Integral at t=1

```
L_M(s) = 1/Γ(s) [∫₀^1 t^{s-1} K(t) dt + ∫₁^∞ t^{s-1} K(t) dt]
```

Analyze each region separately.

---

### Region 1: t ∈ [1,∞) (Large t)

**Behavior of K(t) as t→∞:**

For large t:
```
e^{-t} → 0
Li_s(e^{-t}) = Σ_{n=1}^∞ e^{-nt}/n^s → e^{-t}/1 + e^{-2t}/2^s + ... → e^{-t}
```

So:
```
K(t) = [Li_s(e^{-t}) - e^{-t}]/(1-e^{-t})
     → [e^{-t} + O(e^{-2t}) - e^{-t}]/(1-e^{-t})
     = O(e^{-2t})/(1)
     ~ e^{-2t}
```

**Integral:**
```
∫₁^∞ t^{s-1} · e^{-2t} dt
```

This converges for **all s ∈ ℂ** (exponential decay beats any polynomial growth).

**Conclusion:** No issues for large t.

---

### Region 2: t ∈ [0,1] (Small t) - CRITICAL

**Behavior of K(t) as t→0:**

Need asymptotics of Li_s(e^{-t}) and 1/(1-e^{-t}) near t=0.

**Step 1: Expand e^{-t}**
```
e^{-t} = 1 - t + t²/2 - t³/6 + O(t⁴)
```

**Step 2: Polylogarithm**
```
Li_s(z) = Σ_{n=1}^∞ z^n/n^s
```

For z = e^{-t} = 1 - t + t²/2 + ..., this is **complex** to expand directly.

**Better approach:** Use integral representation of Li_s.

**Alternative: Use known asymptotics**

From literature (e.g., DLMF):
```
Li_s(e^{-t}) ~ ζ(s) - t·ζ(s-1) + t²·ζ(s-2)/2 - ... as t→0
```

for Re(s) > 1, Re(s-1) > 1, etc.

**Step 3: Denominator**
```
1/(1-e^{-t}) = 1/(1-(1-t+t²/2-...))
              = 1/(t - t²/2 + t³/6 - ...)
              = 1/t · 1/(1 - t/2 + t²/6 - ...)
              = (1/t) · [1 + t/2 + O(t²)]
              = 1/t + 1/2 + O(t)
```

**Step 4: Numerator**
```
Li_s(e^{-t}) - e^{-t} ~ [ζ(s) - t·ζ(s-1) + ...] - [1 - t + t²/2 - ...]
                      = [ζ(s) - 1] - t[ζ(s-1) - 1] + O(t²)
```

**Step 5: K(t) near t=0**
```
K(t) = {[ζ(s)-1] - t[ζ(s-1)-1] + O(t²)} · {1/t + 1/2 + O(t)}
     = [ζ(s)-1]/t + [ζ(s)-1]/2 - [ζ(s-1)-1] + O(t)
```

**Leading singularity:** [ζ(s)-1]/t as t→0.

---

### Integral Near t=0

```
∫₀^1 t^{s-1} · K(t) dt ~ ∫₀^1 t^{s-1} · [ζ(s)-1]/t dt
                        = [ζ(s)-1] ∫₀^1 t^{s-2} dt
                        = [ζ(s)-1] · [t^{s-1}/(s-1)]₀^1
                        = [ζ(s)-1]/(s-1)  (if Re(s) > 1)
```

**Convergence condition:** Need Re(s-1) > 0, i.e., **Re(s) > 1**.

**BUT WAIT:** This is the SAME region where Dirichlet series converges!

---

## Going Beyond Re(s) > 1

**Problem:** The 1/t singularity prevents naive continuation to Re(s) ≤ 1.

**Solution:** Subtract the singularity!

### Regularized Integral

**Define:**
```
L_M^{reg}(s) = 1/Γ(s) ∫₀^∞ t^{s-1} [K(t) - [ζ(s)-1]/t · χ(t)] dt
```

where χ(t) is smooth cutoff:
```
χ(t) = { 1  for t ∈ [0,1]
       { 0  for t > 1
```

**Subtracted term:**
```
1/Γ(s) ∫₀^1 t^{s-1} · [ζ(s)-1]/t dt = [ζ(s)-1]/(Γ(s)(s-1))
```

**Relation:**
```
L_M(s) = L_M^{reg}(s) + [ζ(s)-1]/(Γ(s)(s-1))
```

**Now L_M^{reg}(s) has no 1/t singularity!**

The integrand:
```
t^{s-1} [K(t) - [ζ(s)-1]/t · χ(t)]
```

behaves as t^{s-1} · O(1) near t=0 (the 1/t terms cancel).

**Convergence:** Need Re(s-1) > -1, i.e., **Re(s) > 0**.

---

## Higher Order Subtraction

**For even larger domain**, subtract more terms:

From K(t) expansion:
```
K(t) ~ [ζ(s)-1]/t + [ζ(s)-1]/2 - [ζ(s-1)-1] + O(t)
```

Subtract first TWO terms:
```
K̃(t) = K(t) - [ζ(s)-1]/t · χ(t) - {[ζ(s)-1]/2 - [ζ(s-1)-1]} · χ(t)
```

Then integrand:
```
t^{s-1} K̃(t) ~ t^{s-1} · O(t) = t^s · O(1)
```

Convergence: **Re(s) > -1**.

**By iterating**, we can extend to **entire complex plane** (except poles of ζ and Γ).

---

## Where Are The Poles?

**From regularization:**
```
L_M(s) = L_M^{reg}(s) + [ζ(s)-1]/(Γ(s)(s-1))
```

**Poles come from:**

1. **ζ(s)-1 has pole at s=1:**
   ```
   ζ(s)-1 ~ 1/(s-1) + γ + ...
   ```

2. **Γ(s) in denominator:**
   Γ(s) has poles at s = 0, -1, -2, -3, ...

3. **Explicit (s-1) in denominator:**
   Pole at s=1

**Combined:**
```
[ζ(s)-1]/(Γ(s)(s-1)) ~ [1/(s-1)]/(Γ(s)(s-1)) = 1/(Γ(s)(s-1)²)
```

At s=1:
- Numerator: ζ(1)-1 has simple pole → 1/(s-1)
- Denominator: (s-1) → gives 1/(s-1)²

**Double pole at s=1** ✓

This matches our Laurent expansion!

---

## Summary of Domains

| Region | Convergence | Method |
|--------|-------------|--------|
| Re(s) > 1 | ✅ Direct | Dirichlet series |
| Re(s) > 0 | ✅ Subtract 1 term | Regularized integral |
| Re(s) > -1 | ✅ Subtract 2 terms | Higher regularization |
| Re(s) > -N | ✅ Subtract N+1 terms | Iterative subtraction |
| All ℂ | ✅ Iterative process | Analytic continuation |

**Poles:**
- s = 1 (double pole from ζ(s)-1 and explicit factor)
- s = 0, -1, -2, ... (from Γ(s) in denominator)

---

## Theoretical Answer: Where Does Integral Define L_M?

**Main result:**

The integral representation:
```
L_M(s) = 1/Γ(s) ∫₀^∞ t^{s-1} K(t) dt
```

converges for **Re(s) > 1** (same as Dirichlet series).

**Analytic continuation:**

By subtracting leading singularities, we can continue to **entire ℂ** (meromorphic).

**Poles:**
- Double pole at s=1
- Simple poles at s=0, -1, -2, ... (from Γ(s))

**This is beautiful!** The integral automatically encodes the pole structure.

---

## Next: Visualize With WolframScript

Now that we understand theory, let's visualize L_M(s) in complex plane:

**Plan:**
1. Implement L_M(s) via integral (for Re(s) > 1)
2. Use built-in analytic continuation (if available)
3. ComplexPlot to see:
   - Pole at s=1
   - Behavior on critical line Re(s)=1/2
   - Schwarz symmetry visually

**Questions for visualization:**
- Magnitude |L_M(s)|?
- Phase arg(L_M(s))?
- Zeros (where are they)?
- Comparison with ζ(s)?

---

## Insights from Continuation

**Why integral is better than Dirichlet series:**

1. **Global definition:** Single formula works everywhere (with subtraction)
2. **Pole structure visible:** Singularities appear explicitly
3. **Functional equation hints:** Integral transforms might reveal symmetries

**For functional equation search:**

The integral form might be better suited for **Mellin transform techniques** or **Poisson summation**.

This could be next step after visualization!

---

## Status

**Theoretical:** ✅ Understood where integral converges
- Re(s) > 1: direct
- Re(s) > 0: with subtraction
- All ℂ: iterative

**Next:** WolframScript visualization via ComplexPlot

**Goal:** See the landscape of L_M(s) in complex plane!
