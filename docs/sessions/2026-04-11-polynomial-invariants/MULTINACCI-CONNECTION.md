# C(α) and the Multinacci Constants: Equation-First Perspective

**Date:** 2026-04-11 (continuation)
**Context:** Shift from "what number is C(α)?" to "what equation defines C(α)?"

## The Key Realization

We spent significant effort trying to identify C(φ) and C(Bessel) as numbers: computing CFs, running PSLQ, testing algebraicity. This was the wrong focus. The polynomial family that DEFINES C(k) is the fundamental object, not the root.

## The Polynomial Family r_k(u)

Starting from (1−C)^{k+1} = 1−2C, substitute u = 1−C:

**u^{k+1} = 2u − 1**

Factor out (u−1):

**r_k(u) = u^k + u^{k−1} + ... + u − 1 = 0**

Equivalently: Σ_{j=1}^k u^j = 1.

**Recurrence:** r_{k+1}(u) = r_k(u) + u^{k+1} — each step adds one power.

## Connection to k-nacci Constants

Substituting v = 1/u in r_k(u) = 0:

**v^k = v^{k−1} + v^{k−2} + ... + v + 1**

This is the **k-nacci equation** — the characteristic equation of the k-step generalized Fibonacci recurrence. The dominant root τ_k is the **k-nacci constant** (also called the k-step Fibonacci constant or multinacci constant).

| k | Name | τ_k | u(k) = 1/τ_k | C(k) = 1 − 1/τ_k | OEIS (τ_k) |
|---|------|-----|-------------|-------------------|------------|
| 2 | Golden ratio | φ ≈ 1.6180 | 0.6180 | 0.3820 | [A001622](https://oeis.org/A001622) |
| 3 | Tribonacci constant | ≈ 1.8393 | 0.5437 | 0.4563 | [A058265](https://oeis.org/A058265) |
| 4 | Tetranacci constant | ≈ 1.9275 | 0.5188 | 0.4812 | [A086088](https://oeis.org/A086088) |
| 5 | Pentanacci constant | ≈ 1.9659 | 0.5087 | 0.4913 | [A103814](https://oeis.org/A103814) |
| k→∞ | — | 2 | 1/2 | 1/2 | — |

**Result:** The asymptotic constant for lattice paths under y ≤ kx satisfies **C(k) = 1 − 1/τ_k**, where τ_k is the k-nacci constant.

## Properties of k-nacci Constants (Known)

### Pisot–Vijayaraghavan (PV) Numbers

All τ_k are **Pisot numbers**: algebraic integers > 1 whose Galois conjugates all have absolute value < 1.

**References:**
- Wolfram MathWorld: [Pisot Number](https://mathworld.wolfram.com/PisotNumber.html)
- Dresden & Du (2014): "A Simplified Binet Formula for k-Generalized Fibonacci Numbers" — gives explicit Binet-like formula for k-nacci sequences using τ_k. [Journal of Integer Sequences, Vol. 17, Article 14.4.7](https://cs.uwaterloo.ca/journals/JIS/VOL17/Dresden/dresden6.html)
- Miles (1960): "Generalized Fibonacci Numbers and Associated Matrices" — original study of k-step Fibonacci recurrences. [The American Mathematical Monthly, 67(8), 745-752](https://doi.org/10.2307/2308649)

### Substitution Dynamics

The k-nacci constant τ_k is the growth rate of the k-step Fibonacci substitution:
- k=2: a → ab, b → a (Fibonacci substitution, growth rate φ)
- k=3: a → ab, b → ac, c → a (tribonacci substitution, growth rate τ₃)
- k=4: analogous 4-letter substitution

**References:**
- Rauzy (1982): "Nombres algébriques et substitutions" — introduced the Rauzy fractal for the tribonacci substitution. [Bulletin de la SMF, 110, 147-178](https://doi.org/10.24033/bsmf.1957)
- Fogg (2002): *Substitutions in Dynamics, Arithmetics and Combinatorics*, Springer LNM 1794 — comprehensive reference on substitutive dynamics and Pisot numbers

### Lattice Paths Under Linear Barriers

The Lindström–Gessel–Viennot formula gives the count for lattice paths under y ≤ kx:

a_k(n) = Σ_j (−1)^j Binom(2n−1, n − j(k+1))

The generating function involves λ(z) = (1−√(1−4z))/(2z), and at the dominant singularity z=1/4, the value λ(1/4) = 2 produces the geometric sum Σ_{j=0}^k u^j = 2, connecting directly to the k-nacci equation.

**References:**
- Banderier & Wallner (2016): "Lattice paths below a line of rational slope" — algebraic GF for rational slopes, kernel method. [arXiv:1606.08412](https://arxiv.org/abs/1606.08412)
- Krattenthaler (2015): "Lattice Path Enumeration" — chapter in *Handbook of Enumerative Combinatorics*, surveys lattice paths under linear barriers. [arXiv:1503.05930](https://arxiv.org/abs/1503.05930)
- Humphreys (2010): "A History and a Survey of Lattice Path Enumeration" — historical overview. [arXiv:1003.3869](https://arxiv.org/abs/1003.3869)

## The Equation Hierarchy (New Perspective)

The shift from "C(α) as a number" to "the equation defining C(α)" reveals a hierarchy:

| Slope α | Defining object for C(α) | Type | Complexity |
|---------|--------------------------|------|------------|
| Integer k | Polynomial r_k(u) = Σ u^j − 1 | algebraic equation | degree k |
| Rational p/q | Holonomic ODE for GF | linear ODE | order ~20 for 3/2 |
| Substitutive irrational (φ) | ??? | ??? | ??? |
| Arithmetic CF (Bessel) | ??? | ??? | ??? |
| Generic irrational | ??? | ??? | ??? |

For integer k, the polynomial r_k has the recurrence r_{k+1} = r_k + u^{k+1}. The natural question is: **what is the analog of this recurrence for non-integer α?**

### What Changes at Non-Integer Slopes

For integer k, the Lindström formula reduces the lattice path count to a geometric sum Σ u^j = 2 at the dominant singularity. The simplicity comes from the UNIFORM staircase (all steps are L_k, the same transfer matrix).

For non-integer slopes, the staircase has a Sturmian internal pattern — different step sizes within each period (or aperiodically for irrational slopes). The "geometric sum = 2" equation becomes a more complex characteristic equation of the transfer matrix product over one period. This product encodes the Sturmian word, not just its length.

**The question for non-integer α:** Instead of r_k(u) = Σ u^j − 1 (where all coefficients are 1), the equation for C(α) involves a polynomial (or functional equation) whose COEFFICIENTS encode the Sturmian word structure. What is this equation, and how does it relate to r_k?

### Possible Directions

1. **Transfer matrix characteristic polynomial:** For rational p/q, the transfer matrix T (product over one period of length q) has a characteristic polynomial whose roots include 4^{1/q} (related to the dominant growth) and determine C. This polynomial is the "rational-slope analog" of r_k.

2. **Substitution operator:** For φ (Fibonacci substitution), the two transfer matrices L₁ and L₂ satisfy M_{F_{k+1}} = M_{F_k} · M_{F_{k-1}}. The "equation for C(φ)" might be a functional equation on the spectral data of these matrix products, not a polynomial equation on C itself.

3. **Continuous interpolation:** The equation Σ_{j=1}^k u^j = 1 can be written as (u^{k+1} − u)/(u − 1) = 1. For non-integer k, this becomes u·(u^k − 1)/(u − 1) = 1 with u^k = exp(k ln u). This gives a transcendental equation whose root u(α) is a smooth function of α. However, we PROVED this does not match C(α) for non-integer α (14 rationals tested, all fail). So the naive interpolation is wrong — the Sturmian corrections are essential.

4. **Modified geometric sum:** Perhaps C(α) satisfies a "weighted geometric sum" equation Σ w_j u^j = 1 where the weights w_j encode the Sturmian word of α. For integer k: all w_j = 1 (uniform word). For rational p/q: w_j follow a periodic Sturmian pattern. For irrational α: w_j follow the full Sturmian sequence.

## Convergent Analysis (Numerical Results)

### Fibonacci Convergents → C(φ)

C(φ) ≈ 0.268434 (12 reliable digits from 500-term Richardson extrapolation).

| k | p/q | side | |C(p/q) − C(φ)| | same-side ratio |
|---|-----|------|------------------:|----------------:|
| 3 | 3/2 | below | 1.61 × 10⁻² | — |
| 4 | 5/3 | above | 1.58 × 10⁻² | — |
| 5 | 8/5 | below | 9.2 × 10⁻⁴ | 0.057 |
| 6 | 13/8 | above | 1.8 × 10⁻³ | 0.114 |
| 7 | 21/13 | below | 1.7 × 10⁻⁵ | 0.018 |
| 8 | 34/21 | above | 1.1 × 10⁻⁴ | 0.064 |

Convergence is super-geometric. Left-right asymmetry ≈ 2:1 (above overshoot > below undershoot).

### Bessel Convergents → C(I₀(2)/I₁(2))

C(Bessel) ≈ 0.215918 (9 reliable digits).

| k | p/q | side | |C(p/q) − C(target)| |
|---|-----|------|-------------------:|
| 1 | 3/2 | above | 3.6 × 10⁻² |
| 2 | 10/7 | below | 9.7 × 10⁻⁵ |
| 3 | 43/30 | above | 9.5 × 10⁻⁵ |
| 4 | 225/157 | — | ≈ 0 (indistinguishable) |

Convergence ~50× faster than φ at first step. Nearly symmetric (1:1).

### CF of C(k) for Integer k

- k=2: CF(C(2)) = [0; 2, 1̄] — periodic (C(2) = 1/φ², quadratic irrational)
- k≥3: CF looks generic — no pattern detected in 200 digits
- Second partial quotient ≈ 2^{k-1}/c (doubles with k), reflecting C(k) → 1/2

## Summary: Where We Stand

**What we know:**
- C(k) = 1 − 1/τ_k (multinacci connection) — beautiful, connects to rich literature
- The polynomial r_k(u) = Σ u^j − 1 with recurrence r_{k+1} = r_k + u^{k+1} is the clean object for integer slopes
- For non-integer slopes, the naive interpolation fails — Sturmian corrections are essential
- C(α) as a function is monotone, fractal, with kink hierarchy at rationals

**What we don't know:**
- What equation/object defines C(α) for non-integer α?
- Is C(φ) D-finite? (Probably not — the GF for Fibonacci staircase paths is likely not D-finite)
- How do the Sturmian corrections modify the geometric sum equation?
- Is there a "weighted r_k" that captures C(α) for all α?

**The right question going forward:** Not "what number is C(φ)?", but "what is the EQUATION that generalizes r_k(u) = Σ u^j − 1 to non-integer slopes?"

## Scripts (this continuation)

- `cf_algebraic_Ck.wl` — CFs of algebraic C(k) for k=2..10 (exact, 200 digits)
- `convergent_C_phi_bessel.wl` — C at convergents of φ and Bessel ratio
- `highprec_C_phi_bessel.wl` — 500-term Richardson extrapolation for C(φ) and C(Bessel)
- `highprec_C_phi_v2.wl` — 1500-term computation via rational convergent 233/144
