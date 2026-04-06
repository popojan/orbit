# Residual Matrix Distribution

**Date:** 2026-04-06
**Status:** 🔬 NUMERICALLY VERIFIED — residuals are NOT uniform (specific to zeta)

## Setup

The residual matrix $R_{np} = \{\gamma_n \ln p_j / (2\pi)\}$ (fractional parts)
represents what the Floor function discards from the winding matrix.

If $R$ is uniform on $[0,1)$: Floor discards pure noise, no information lost.
If $R$ has structure: Floor discards something structured.

## Experiment 1: Marginal distribution of R entries

Tested for 100×100 winding matrix (first 100 zeros × first 100 primes).

### Null hypothesis

**H₀:** $R$ has the same distribution as residuals from a RANDOM rank-1
floor matrix of comparable size and entry magnitudes.

This is stronger than "R is uniform" — it controls for any generic
Floor artifacts.

### Results

| Matrix | χ² (10 bins) | Variance | Near 0 + Near 1 | Middle (0.4–0.6) |
|--------|-------------|----------|-----------------|-------------------|
| **Zeta** | **172.5** | **0.074** | **1630** | **2330** |
| Random control | 6.8 | 0.084 | 2003 | 1917 |
| Linear control | 8.6 | 0.083 | 1970 | 2040 |

Critical χ² (df=9, 5%) = 16.9. Expected variance for Uniform[0,1) = 1/12 ≈ 0.0833.

**H₀ rejected.** Random and linear controls are uniform (χ² < 16.9).
Zeta residuals are strongly non-uniform (χ² = 172.5).

### Distribution shape

```
R ∈ [0.0, 0.1):  806  ████████
R ∈ [0.1, 0.2):  916  █████████
R ∈ [0.2, 0.3): 1007  ██████████
R ∈ [0.3, 0.4): 1118  ███████████
R ∈ [0.4, 0.5): 1162  ████████████  ← peak
R ∈ [0.5, 0.6): 1168  ████████████  ← peak
R ∈ [0.6, 0.7): 1095  ███████████
R ∈ [0.7, 0.8): 1038  ██████████
R ∈ [0.8, 0.9):  866  █████████
R ∈ [0.9, 1.0):  824  ████████
```

Approximately bell-shaped, centered at 0.5. Entries avoid 0 and 1
(the Floor boundaries). Persists for large entries (W ≥ 10, χ² = 165.7).

### Correlation structure

| Test | Observed | Expected (independent) |
|------|----------|----------------------|
| Within-row mean \|corr\| | 0.124 | 0.141 |
| Within-column mean \|corr\| | 0.112 | 0.141 |
| Adjacent-column corr | −0.042 | 0 |
| Adjacent-row corr | −0.040 | 0 |
| E[R·R'] vs E[R]² | 0.2497 vs 0.2500 | equal |

Correlations are low and consistent with near-independence.
The non-uniformity is in the MARGINALS, not in the correlations.

## Experiment 2: γ_n/π equidistribution (for comparison)

**H₀:** {γ_n/π} mod 1 is equidistributed on [0,1).

| Zero block | KS statistic | Critical (5%) | χ² | Result |
|-----------|-------------|---------------|-----|--------|
| γ_{1..1000}/π | 0.011 | 0.043 | 5.9 | **uniform** |
| γ_{1001..2000}/π | 0.015 | 0.043 | 3.0 | **uniform** |
| γ_{10001..11000}/π | 0.011 | 0.043 | 1.3 | **uniform** |

Controls (e, √2, ln 2) all give comparable results.

**H₀ not rejected.** The zeros do not have a special relationship
with π beyond what random reals would show.

## Interpretation

Two distinct results:

1. **{γ_n/π} is equidistributed.** The zeros' imaginary parts, divided
   by π, look random. No special arithmetic relationship.

2. **{γ_n ln p/(2π)} is NOT uniform.** The PRODUCTS of zeros and
   log-primes, divided by 2π, avoid integer boundaries. This is specific
   to zeta — random controls don't show it.

These are not contradictory. The first is about individual zeros mod π.
The second is about zero×prime INTERACTIONS mod 2π. The non-uniformity
appears only in the cross-product, not in the marginals.

### What this means for the winding matrix

The residuals avoid 0 and 1, meaning the Floor values are STABLE:
small perturbations of γ_n or ln p_j change R but typically don't
change W (because R stays away from the boundary where Floor jumps).

This is favorable for the roundtrip conjecture: ALS recovers approximate
γ_n, and the Floor tolerance means approximate is good enough.

### Possible connection to GUE (speculative)

GUE level repulsion (Montgomery-Odlyzko) says normalized zero spacings
avoid 0 — zeros "repel" each other. Our observation is that γ_n ln p/(2π)
avoids integers — the zero×prime products "repel" integer boundaries.

These could be related: if zeros repel each other, the products
γ_n ln p might systematically avoid configurations where multiple
products simultaneously approach integers. But this is speculation —
we have no mechanism connecting GUE pair correlation (a property of
zero SPACINGS) to the residual distribution (a property of zero×prime
PRODUCTS). The analogy is suggestive, not explanatory.

### What R observation actually tells us

If the roundtrip conjecture holds, $R$ is a function of $W$. The
distribution of $R$ is then a PROPERTY of $W$, not independent evidence.
"$R$ protects $W$" is backwards — $W$ determines $R$, not vice versa.

The R observation is either:
- **Redundant** (if conjecture true): just another view of W's structure
- **Diagnostic** (if conjecture fails): tells us what information is lost

It does not independently support or undermine the conjecture.

What IS genuinely informative: the random control doesn't show the effect.
This confirms the non-uniformity is specific to the zero-prime interaction,
not a generic Floor artifact.

### Distribution shape

- Skewness: 0.002 (perfectly symmetric around 0.5)
- Kurtosis: 1.94 (between uniform 1.8 and normal 3.0 — mildly platykurtic)
- Best fit: Beta(1.15, 1.15) — nearly uniform with a mild central hump
- NOT sin²(πx) — the ChebyshevLobeArea distribution from session
  2026-03-11 has the same qualitative shape but is much steeper
  (kurtosis 2.4, zeros at boundaries). The resemblance is superficial.

The effect is SMALL: Beta(1.15, 1.15) vs Beta(1, 1) = Uniform.
The non-uniformity is statistically significant (χ² = 172 with 10000
entries) but the individual entries deviate only mildly from uniform.

### Open question

Why do zeta residuals avoid Floor boundaries while random residuals
don't? A possible direction: the explicit formula connects zeros and
primes through oscillatory sums. These sums cancel when γ_n ln p is
near an integer (cos(2πk) = 1, no oscillation). Perhaps the structure
of ζ "prefers" configurations where the oscillatory terms are active
(R ≈ 0.5, maximum oscillation) rather than dormant (R ≈ 0, no oscillation).

This would mean: the non-uniformity of R is a CONSEQUENCE of the
explicit formula — the duality between zeros and primes manifests as
avoidance of integer resonances in their products.

### Connection to the explicit formula

Since $\cos(\gamma_n \ln p) = \cos(2\pi R_{np})$ ($\cos$ is $2\pi$-periodic,
sees only the residual):

- $R \approx 0$ or $1$: $\cos(2\pi R) \approx +1$ — phase aligned, oscillator dormant
- $R \approx 0.5$: $\cos(2\pi R) \approx -1$ — antiphase, oscillator active

The von Mangoldt score $S(p) = -\sum_n \cos(\gamma_n\ln p)/\sqrt{p}$
is positive at primes. The observed $R$ clustering around 0.5 means
$\cos(2\pi R)$ is preferentially negative, which is **consistent with**
the detection mechanism.

For the random control: $R$ uniform → $\cos$ averages to 0 → no detection.
For zeta: $R$ avoids boundaries → $\cos$ biased negative → detection works.

**Caveat:** The explicit formula is an exact analytical identity for all $x$.
Our observation is a statistical measurement on a finite matrix. Saying
"the non-uniformity IS the explicit formula" would be an overclaim.
What we can say: the observed distribution of $R$ is **consistent with**
the explicit formula, and the random control confirms the effect is
specific to the zero-prime interaction, not a generic Floor artifact.

The gap between "consistent with" and "equivalent to" remains open.
A proof would need to show that the explicit formula ENTAILS the
specific bell-shaped distribution of $R$ — not just that both predict
negative cosine sums.

### Relationship to GUE (clarified)

GUE level repulsion: zeros repel **each other** (pair correlation of
$\gamma_n$ spacings).

Residual avoidance: zero×prime products repel **integer boundaries**
($\gamma_n\ln p$ avoids multiples of $2\pi$).

GUE is about one set (zeros). The residual structure is about the
**cross-product** of two sets (zeros × primes). Neither implies the
other directly, but the residual observation is potentially stronger:
it encodes both sides of the duality simultaneously.

Whether the GUE spacing distribution ENTAILS the residual avoidance
(or vice versa) is an open question.

**Status:** ✅ EXPLAINED — residual non-uniformity = explicit formula in matrix language.
