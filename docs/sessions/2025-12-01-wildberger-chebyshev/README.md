# Retiring Pi: A Wildberger-Style Look at Chebyshev Lobe Areas

**Date:** December 1, 2025
**Status:** Recreational mathematics with adversarial rigor
**Mood:** Playfully iconoclastic

---

## The Setup

We have the Chebyshev Integral Identity:

$$\sum_{k=1}^{n} A(n,k) = 1 \quad \text{for all } n \geq 3$$

where A(n,k) is the normalized area of the k-th lobe of the n-gon Chebyshev polygon function.

**The question:** Can we express this without π?

---

## The Journey

### Act 1: "What if we set π = 4?"

User's provocation:
> "Zkusme to... položili Pi == 4, dostali bychom spor?"

Computation revealed:
- With π = Pi: Lobe sum = **1** (exactly)
- With π = 4: Lobe sum ≈ **0.876** (not 1!)

**Finding:** The value π is the *unique* constant where the lobe sum equals 1. Setting π = 4 breaks the identity.

But wait... the formula uses cos/sin which are *defined* via π. Circular reasoning!

### Act 2: "Forget the value, make the RATIO rational!"

User's insight:
> "POZOR! Já netrvám na suma lobes == 1, ale na tom, aby poměr byl racionální!"

We explored: Can we find a reference area that gives a rational ratio?

| Reference | Area | Ratio |
|-----------|------|-------|
| Unit disk | π | 1/π (irrational) |
| Inscribed square | 2 | **1/2** (rational!) |
| Circumscribed square | 4 | **1/4** (rational!) |

### Act 3: Adversarial Check #1 - "Is π really gone?"

**Verdict:** π appears in NOTATION (cos 2πk/n), but all VALUES are algebraic.

The ratio 1/2 is genuinely π-free. But π is needed to *ask* the question (why Chebyshev? why [-1,1]?).

Analogy:
```
Q: What is cos(π/3)?
A: 1/2 (rational!)

You need π to ask, not to answer.
```

**Conclusion:** π = Retired Into Philosophy

### Act 4: Adversarial Check #2 - "Is 1/2 geometrically valid?"

**Problem identified:** The polygon's bounding box is [-1,1] × [-1,1], which *exceeds* the inscribed square (vertices at ±0.707).

**Counter-argument:** We compare AREAS, not containment!
- Polygon area = 1 < 2 = inscribed square area
- The ratio 1/2 is valid as an *area comparison*, even if shapes don't nest.

**User's observation:**
> "That is just sqrt(2) difference, is not it?"

YES! The inscribed vs circumscribed square differ by factor 2 = (√2)². Both ratios (1/2 and 1/4) are equally valid.

### Act 5: "We could retire √2 too!"

Using the **circumscribed square** as canonical reference:

| Object | Coordinates | Area |
|--------|-------------|------|
| Circumscribed square | (±1, ±1) | 4 |
| Polygon lobes | — | 1 |
| **Ratio** | — | **1/4** |

**No √2 anywhere!** It only appears in *side lengths*, not *areas*.

---

## The Wildberger Formulation

Norman Wildberger's "Rational Trigonometry" avoids irrationals by using:
- **Quadrance** = distance² (no √)
- **Spread** = sin² (no π)

Our result fits perfectly:

> **Wildberger-Chebyshev Theorem:** For any n-gon Chebyshev polygon (n ≥ 3), the rational area measure equals 1/4 of the bounding quadrance, independent of n.

No limits. No infinitesimals. No transcendentals. **Finite rational arithmetic.**

---

## Final Scorecard

| Constant | Status | Notes |
|----------|--------|-------|
| π | Retired Into Philosophy | Motivation only, not in values |
| √2 | Retired Into Geometry | Use circumscribed square, areas are integers |
| e | Never appeared | Not relevant here |
| i | Hidden | In ζₙ = e^(2πi/n), but results are real |

**Survivors:** 1, 2, 4, and ratios thereof.

---

## The Dialogue

```
Wildberger: "Finally! Students who understand that π and √2
            are unnecessary complications!"

Euler's ghost: *angry German noises*

Chebyshev: "I just wanted to approximate functions..."

User: "π was my best friend, learned first 100 decimal
       digits by heart in high school."

Claude: "π = Retired Into Philosophy. It's not dead,
         just playing a different role now."
```

---

## Serious Mathematical Content

Despite the playful framing, the core results are rigorous:

1. **Σ A(n,k) = 1** for all n ≥ 3 (proven algebraically via roots of unity)

2. **Ratio to circumscribed square = 1/4** (purely rational, no irrationals needed)

3. **Individual A(n,k)** involve cos(2πk/n) which are algebraic numbers (not transcendental)

4. **The sum** collapses to an integer because oscillatory terms cancel (root sum identity)

The reduction to rational arithmetic is genuine, not a trick. We're computing with algebraic numbers that happen to sum to integers.

---

## Code

```mathematica
(* Lobe area - classical formulation *)
A[n_, k_] := (8 - 2 n^2 + n^2 (Cos[2 Pi (k-1)/n] + Cos[2 Pi k/n])) / (8 n - 2 n^3);

(* Verify sum = 1 for any n *)
Table[Sum[A[n, k], {k, n}] // FullSimplify, {n, 3, 12}]
(* Output: {1, 1, 1, 1, 1, 1, 1, 1, 1, 1} *)

(* Ratio to circumscribed square (area = 4) *)
lobeSum = 1;
circumscribedArea = 4;
ratio = lobeSum / circumscribedArea
(* Output: 1/4 *)
```

---

## References

- Wildberger, N.J. "Divine Proportions: Rational Trigonometry to Universal Geometry" (2005)
- Chebyshev polynomial theory (standard references)
- This repository: `docs/drafts/lobe-area-kernel.tex`

---

*"The irrationals are a disease from which mathematics will eventually recover."*
— Leopold Kronecker (paraphrased, probably apocryphal)

*"Hold my compass."*
— Pafnuty Chebyshev (definitely apocryphal)
