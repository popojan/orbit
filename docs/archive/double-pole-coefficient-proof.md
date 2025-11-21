# Double Pole Coefficient A=1 - Rigorous Proof

**Date:** November 17, 2025
**Status:** IN PROGRESS
**Goal:** Prove that A = 1 in Laurent expansion L_M(s) = A/(s-1)² + ...

---

## Theorem: Double Pole Coefficient

**Statement:**
```
lim_{s→1} (s-1)² · L_M(s) = 1
```

**Equivalent formulation:** The Laurent expansion of L_M(s) around s=1 has:
```
L_M(s) = 1/(s-1)² + (2γ-1)/(s-1) + B + O(s-1)
```

---

## Proof Strategy

From closed form:
```
L_M(s) = ζ(s)[ζ(s) - 1] - C(s)
```

We know from previous work:
```
ζ(s)[ζ(s)-1] = 1/(s-1)² + (2γ-1)/(s-1) + γ(γ-1) + O(s-1)
```

So the double pole coefficient from ζ² is **1**.

**Key question:** Does C(s) contribute to the double pole?

**If C(s) has NO double pole**, then:
```
A = 1 - 0 = 1 ✓
```

**Plan:** Prove that `lim_{s→1} (s-1)² · C(s) = 0`

---

## Step 1: Structure of C(s)

Recall:
```
C(s) = Σ_{j=2}^∞ H_{j-1}(s) / j^s
```

where:
```
H_j(s) = Σ_{k=1}^j k^{-s}  (finite sum)
```

---

## Step 2: Asymptotic Expansion of H_j(s)

For fixed j and s near 1, expand H_j(s):

```
H_j(s) = Σ_{k=1}^j k^{-s}
       = Σ_{k=1}^j e^{-s ln k}
       = Σ_{k=1}^j e^{-ln k} · e^{-(s-1) ln k}
       = Σ_{k=1}^j (1/k) · [1 - (s-1) ln k + (s-1)²(ln k)²/2 + O((s-1)³)]
```

Collecting terms:
```
H_j(s) = Σ_{k=1}^j (1/k) - (s-1) Σ_{k=1}^j (ln k)/k + (s-1)² Σ_{k=1}^j (ln k)²/(2k) + O((s-1)³)
```

Define:
- H_j = Σ_{k=1}^j 1/k (harmonic number at s=1)
- L_j^{(1)} = Σ_{k=1}^j (ln k)/k (first moment)
- L_j^{(2)} = Σ_{k=1}^j (ln k)²/k (second moment)

Then:
```
H_j(s) = H_j - (s-1) L_j^{(1)} + (s-1)² L_j^{(2)}/2 + O((s-1)³)
```

---

## Step 3: Asymptotics of H_j, L_j^{(1)}, L_j^{(2)}

### Lemma 3.1: Harmonic Number
```
H_j = ln j + γ + 1/(2j) - 1/(12j²) + O(1/j⁴)
```

**Reference:** Euler-Maclaurin formula (standard)

### Lemma 3.2: First Moment
```
L_j^{(1)} = Σ_{k=1}^j (ln k)/k
```

By Euler-Maclaurin or integral approximation:
```
L_j^{(1)} ≈ ∫_1^j (ln x)/x dx = [(ln x)²/2]_1^j = (ln j)²/2
```

More precisely:
```
L_j^{(1)} = (ln j)²/2 + O(ln j)
```

### Lemma 3.3: Second Moment
```
L_j^{(2)} = Σ_{k=1}^j (ln k)²/k
```

Similarly:
```
L_j^{(2)} ≈ ∫_1^j (ln x)²/x dx = [(ln x)³/3]_1^j = (ln j)³/3
```

More precisely:
```
L_j^{(2)} = (ln j)³/3 + O((ln j)²)
```

---

## Step 4: Expansion of j^{-s}

```
j^{-s} = j^{-1} · j^{-(s-1)}
       = (1/j) · e^{-(s-1) ln j}
       = (1/j)[1 - (s-1) ln j + (s-1)²(ln j)²/2 + O((s-1)³)]
```

---

## Step 5: Expansion of H_{j-1}(s) / j^s

Combining Steps 2 and 4:

```
H_{j-1}(s)/j^s = [H_{j-1} - (s-1)L_{j-1}^{(1)} + (s-1)²L_{j-1}^{(2)}/2 + ...]
                 × [(1/j)(1 - (s-1)ln j + (s-1)²(ln j)²/2 + ...)]
```

Expanding to order (s-1)²:

```
= (1/j)[H_{j-1} - (s-1)L_{j-1}^{(1)} + (s-1)²L_{j-1}^{(2)}/2]
  × [1 - (s-1)ln j + (s-1)²(ln j)²/2]
  + O((s-1)³)
```

**Order (s-1)⁰:**
```
H_{j-1}/j
```

**Order (s-1)¹:**
```
(1/j)[-L_{j-1}^{(1)} - H_{j-1} ln j]
```

**Order (s-1)²:**
```
(1/j)[L_{j-1}^{(2)}/2 - L_{j-1}^{(1)} ln j + H_{j-1}(ln j)²/2]
```

---

## Step 6: Sum Over j for C(s)

Now we must analyze:
```
C(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s
     = Σ_{j=2}^∞ [a_j + (s-1)b_j + (s-1)²c_j + O((s-1)³)]
```

where:
- a_j = H_{j-1}/j
- b_j = (1/j)[-L_{j-1}^{(1)} - H_{j-1} ln j]
- c_j = (1/j)[L_{j-1}^{(2)}/2 - L_{j-1}^{(1)} ln j + H_{j-1}(ln j)²/2]

**Goal:** Show that Σ c_j converges (or at least is finite).

If Σ c_j < ∞, then:
```
(s-1)² · C(s) = (s-1)² · [Σ a_j + (s-1) Σ b_j + (s-1)² Σ c_j + ...]
              → 0  as s → 1
```

---

## Step 7: Convergence of Σ c_j

Using asymptotics from Step 3:
```
H_{j-1} ≈ ln j + γ
L_{j-1}^{(1)} ≈ (ln j)²/2
L_{j-1}^{(2)} ≈ (ln j)³/3
```

Substitute into c_j:
```
c_j ≈ (1/j)[(ln j)³/6 - (ln j)²/2 · ln j + (ln j + γ)(ln j)²/2]
    = (1/j)[(ln j)³/6 - (ln j)³/2 + (ln j)³/2 + γ(ln j)²/2]
    = (1/j)[(ln j)³/6 + γ(ln j)²/2]
```

Hmm, the (ln j)³ terms should cancel more carefully. Let me recompute:

Actually, L_{j-1}^{(1)} ≈ (ln j)²/2, so:
```
-L_{j-1}^{(1)} ln j ≈ -(ln j)²/2 · ln j = -(ln j)³/2
```

And:
```
H_{j-1}(ln j)²/2 ≈ (ln j + γ)(ln j)²/2 = (ln j)³/2 + γ(ln j)²/2
```

And:
```
L_{j-1}^{(2)}/2 ≈ (ln j)³/6
```

So:
```
c_j ≈ (1/j)[(ln j)³/6 - (ln j)³/2 + (ln j)³/2 + γ(ln j)²/2]
    = (1/j)[(ln j)³/6 + γ(ln j)²/2]
```

Hmm, this still diverges! Σ (ln j)³/j diverges.

**Issue:** The (ln j)³ terms are NOT canceling completely.

Let me be more careful...

---

## Step 8: More Careful Analysis (WORK IN PROGRESS)

I need to use more precise asymptotics, not just leading terms.

**Alternative approach:** Use Euler-Maclaurin formula directly on C(s).

**Or:** Compute C(s) - C(1) and show this is O(s-1), meaning (s-1)² · C(s) → 0.

Let me try the integral representation approach instead...

---

## Alternative Approach: Integral Test

Since C(s) = Σ H_{j-1}(s)/j^s, we can compare with:

```
∫_2^∞ H_x(s)/x^s dx
```

For s near 1, H_x(s) ≈ ln x + γ + O(1/x).

So the integral becomes:
```
∫_2^∞ (ln x + γ)/x^s dx
```

At s=1:
```
∫_2^∞ (ln x + γ)/x dx  = ∫_2^∞ (ln x)/x dx + γ ∫_2^∞ dx/x
```

Both integrals **diverge**!

This suggests C(1) might diverge... but numerically we got C(1) ≈ 22 (finite).

**Something is subtle here.** Let me reconsider...

---

## Numerical Evidence

From yesterday (`scripts/compute_A_coefficient.py`):

```python
eps = 10^{-3}: (s-1)² · L_M(s) = 1.0001322125...
eps = 10^{-4}: (s-1)² · L_M(s) = 1.0000152197...
eps = 10^{-5}: (s-1)² · L_M(s) = 1.0000015420...
eps = 10^{-6}: (s-1)² · L_M(s) = 1.0000001545...
eps = 10^{-7}: (s-1)² · L_M(s) = 1.0000000142...
```

Clearly converging to 1.0 with correction ~ O(eps) = O(s-1).

This means:
```
(s-1)² · L_M(s) = 1 + O(s-1)
```

So:
```
(s-1)² · C(s) = (s-1)² · [ζ²-ζ - L_M]
              = (s-1)² · [1/(s-1)² + (2γ-1)/(s-1) + ... - (1/(s-1)² + (2γ-1)/(s-1) + ...)]
              = O((s-1)²) [from cancellation]
```

Actually wait, I need to be more careful about what we're computing.

---

## STATUS: INCOMPLETE

This proof is harder than expected. The asymptotic analysis of Σ H_j(s)/j^s near s=1 requires very careful treatment of logarithmic divergences and cancellations.

**Numerical evidence strongly suggests A=1**, but the rigorous proof is non-trivial.

**Next steps:**
1. Use summation by parts (Abel's theorem)
2. Or: Prove C(s) is Lipschitz continuous at s=1
3. Or: Direct numerical analysis of convergence rates

**To be continued...**
