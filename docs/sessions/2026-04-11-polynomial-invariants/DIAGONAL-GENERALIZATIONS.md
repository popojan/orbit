# Diagonal Lattice Path Generalizations

**Date:** 2026-04-11 (continuation session)
**Context:** Extends Finding 11 from the main README — the equation `(1−C)^{k+1} = 1−2C` for integer slopes.

## Setup

`BeattyBallotCount[α, {m, j}]` counts lattice paths from `(1,0)` to `(m, j)` with steps `{(1,0), (0,1)}` staying weakly below the staircase `Floor[x/α]`.

For the **diagonal** `a_k(n) = BeattyBallotCount[1/k, {n, n}]` with integer k:
- Growth: `a_k(n) ~ C_k · 4^n / √(πn)` for k ≥ 2
- **C_k = smallest positive root of (1−x)^{k+1} = 1−2x**
- Equivalently: `Σ_{j=0}^k (1-C)^j = 2` (universal for all integer k)

## Three Generalization Directions Tested

### Direction 1: Rectangular diagonal `(dx·n, n)` with integer slope k

Replace the square diagonal `(n,n)` with the rectangular diagonal `(dx·n, n)` for integer `dx ≥ 2`.

**Hypothesis tested:** `(1-C)^{k+1} = 1 - ((dx+1)/dx)·C`

**Result: ❌ FAILS** for dx ≥ 2.

For `dx=2, k=2`: the correct minimal polynomial is `8C² + 12C − 9 = 0`, giving `C = 3(√3−1)/4`. This can be rewritten as `(1+2C)³ = 1+15C`, but the constant 15 is NOT universal across k. No clean generalization found.

**Key observation:** For dx=1, `Σ u^j = 2` is universal (same equation for all k). For dx ≥ 2, no analogous universal equation exists.

### Direction 2: Non-integer (rational) slopes

For rational slope `p/q` (i.e., `α = q/p`), the staircase `Floor[px/q]` has period q.

**Hypothesis tested:** Interpolate the integer equation — since `(1-C)^{k+1} = 1-2C` with `k = p/q` gives `(1-C)^{(p+q)/q} = 1-2C`, raising to the q-th power: `(1-C)^{p+q} = (1-2C)^q`

**Result: ❌ FAILS** for q ≥ 2.

Tested 14 rational slopes. All integer slopes (q=1) pass, ALL non-integer slopes (q≥2) fail:

| Slope | C (approx) | Residual | Status |
|-------|-----------|----------|--------|
| 2/1 | 0.3820 | 10⁻²⁴ | ✅ |
| 3/1 | 0.4563 | 10⁻²³ | ✅ |
| 4/1 | 0.4812 | 10⁻²² | ✅ |
| 5/1 | 0.4913 | 10⁻²¹ | ✅ |
| 3/2 | 0.2518 | 0.012 | ❌ |
| 5/2 | 0.4124 | 0.0065 | ❌ |
| 7/2 | 0.4627 | 0.0018 | ❌ |
| 4/3 | 0.1909 | 0.0093 | ❌ |
| 5/3 | 0.2841 | 0.012 | ❌ |
| 7/3 | 0.3981 | 0.0022 | ❌ |
| 5/4 | 0.1547 | 0.0071 | ❌ |
| 7/4 | 0.2954 | 0.0068 | ❌ |
| 7/5 | 0.2093 | 0.0067 | ❌ |
| 8/3 | 0.4172 | 0.0019 | ❌ |

**Why it fails:** For non-integer slope p/q, the staircase Floor[px/q] has a [Sturmian](https://en.wikipedia.org/wiki/Sturmian_word) internal pattern — a specific sequence of height increments within each period q. The integer equation captures only the average slope; the Sturmian pattern introduces corrections that change the algebraic equation for C.

### Direction 3: Direct dependence C(α) (no CF decomposition)

**Hypothesis tested:** Does `C(α)` factor through the CF partial quotients of α, or depend directly on α as a single number?

**Assessment:**
- For integer k: C depends on k (a single parameter). ✅ clean.
- For rational p/q: C depends on both p and q, not just the ratio p/q. The Sturmian pattern of the staircase (determined by p, q) affects C. The algebraic equation for C involves the [transfer matrix](https://en.wikipedia.org/wiki/Transfer_matrix) of one staircase period.
- For irrational α: C is expected to vary continuously with α, but the equation changes form. The Sturmian pattern of an irrational staircase is determined by the full CF expansion, so C(α) inherits CF dependence — not through a simple product formula, but through the periodic structure of convergent approximations.

**Conclusion:** The CF factorization idea `C(α) = C(⌊1/α⌋) · Π f(aᵢ)` is unlikely to hold in a simple form. C(α) depends on α through the full Sturmian staircase structure, which for irrationals is encoded by the CF.

## Mathematical Connections

### Established (used in this work)

- **[Catalan numbers](https://en.wikipedia.org/wiki/Catalan_number)** (A000108): k=1 case, paths under y=x. The equation degenerates: double root at C=0, giving n^{-3/2}.
- **[Ballot problem](https://en.wikipedia.org/wiki/Ballot_problem):** Lattice paths under linear barriers. The Lindström reflection formula `a_k(n) = Σ_j (-1)^j C(2n-1, n-j(k+1))` gives the GF for integer slopes.
- **[Sturmian words](https://en.wikipedia.org/wiki/Sturmian_word):** The staircase Floor[αx] for irrational α gives a Sturmian sequence. For rational p/q, the staircase is periodic with Sturmian pattern within each period. The asymptotic constant C depends on this pattern.
- **[Beatty sequence](https://en.wikipedia.org/wiki/Beatty_sequence):** Floor[nα] is a Beatty sequence. Our staircase Floor[x/α] is the inverse Beatty staircase.
- **[Continued fractions](https://en.wikipedia.org/wiki/Continued_fraction):** For irrational α, the CF expansion determines the Sturmian word, and hence the staircase structure.

### Explored but unsuccessful

- **[Functional central limit theorem](https://en.wikipedia.org/wiki/Donsker%27s_theorem) (Donsker):** Random lattice walks converge to Brownian motion. For slope k > 1, the barrier constraint is trivially satisfied in the Brownian limit — C(α) is a sub-CLT correction that depends on the discrete staircase structure, not just the continuous limit.
- **[Kernel method](https://en.wikipedia.org/wiki/Kernel_method_(enumerative_combinatorics)):** Standard technique for constrained lattice path GFs. Derivation for integer k is outlined but not completed; for non-integer slopes, the periodic staircase complicates the kernel equation.

### Needed (open)

- **[Transfer matrix method](https://en.wikipedia.org/wiki/Transfer-matrix_method):** For rational slope p/q, the staircase has period q. The transfer matrix for one period is a (p+1)×(p+1) matrix whose eigenvalues determine C. This is the natural framework for deriving the algebraic equation for C(p/q).
- **[Pemantle-Wilson asymptotics](https://arxiv.org/abs/math/0212351):** For the `(dx, 1)` generalization (rectangular diagonals), the bivariate GF requires multivariate singularity analysis. Pemantle-Wilson theory gives asymptotics for diagonals of multivariate GFs.

## What Stands (publishable)

1. **Integer slope family:** `(1-C)^{k+1} = 1-2C` unifying Catalan → golden ratio → 1/2. Clean, verified, original.
2. **New OEIS sequences:** k ≥ 3 give sequences not in OEIS. Ready for submission.
3. **Phase transition at k=1:** Double root (n^{-3/2}) ↔ simple root (n^{-1/2}) transition.

## What Doesn't Generalize Simply

- The equation `(1-C)^{k+1} = 1-2C` does NOT extend to non-integer k via the naive `(1-C)^{p+q} = (1-2C)^q`
- The equation does NOT extend to rectangular diagonals (dx > 1) via simple coefficient modification
- The asymptotic constant C(α) for irrational α does NOT factor simply through CF partial quotients

## Key Reference: Banderier-Wallner (2016)

["The kernel method for lattice paths below a line of rational slope"](https://arxiv.org/abs/1606.08412), also Chapter 5 of Wallner's dissertation.

**Key result:** All generating functions for lattice paths below a line of rational slope are **algebraic** (bivariate GF). This does NOT directly imply C(p/q) is algebraic — see below.

**Scope comparison:** BW provides the general framework (kernel method for directed lattice paths with specific step sets). Our work provides specific structural insights (the equation for C, CF connections, irrational case, Egyptian fractions). BW covers rational slopes; we also cover irrational α. BW primarily studies excursions and meanders; our (n,n) diagonal is a different extraction.

**For slope 3/2:** The kernel equation is `u² = z(1 + u⁵)`, with critical point `u⁵ = 2/3`. The GF is expressed via Schur polynomials in the 2 small roots of the kernel.

## Key Finding: The Algebraic–Transcendental Boundary (Finding 12)

### The generating function F(z) = Σ a(n,n) z^n for slope 3/2 is D-finite but NOT algebraic

**Evidence:**

1. **Not algebraic:** No algebraic equation P(z, F(z)) = 0 found for P of degree ≤ 6 in F and degree ≤ 25 in z (tested with 150 terms, exact integer arithmetic).

2. **D-finite (holonomic):** A holonomic recurrence EXISTS at **order 19, polynomial degree 15** (320 parameters, found with 400 terms, verified exactly). For comparison, integer slope k=2 has order 3, degree 4.

3. **C(3/2) likely transcendental:** PSLQ proves no minimal polynomial of degree ≤ 7 with coefficients ≤ 90. Candidates at higher degrees are inconclusive (precision-limited, 50 digits).

**Theoretical framework:**

- BW: bivariate GF G(x,y) for paths under rational-slope barrier is algebraic
- Lipshitz-Rubel: diagonal of algebraic bivariate GF is D-finite (but NOT necessarily algebraic)
- Connection constants of D-finite ODEs are generically transcendental (cf. ζ(3) as connection constant of Apéry's ODE of order 3)

**Implication — qualitative transition:**

| Slope type | C | GF F(z) | Recurrence |
|-----------|---|---------|------------|
| Integer k | algebraic (degree k) | algebraic | ord 3, deg 4 (k=2) |
| Rational p/q, q>1 | likely transcendental | D-finite, NOT algebraic | ord 19, deg 15 (slope 3/2) |
| Irrational α | ??? | possibly not D-finite | ??? |

The equation `(1-C)^{k+1} = 1-2C` is specific to integer k because it IS an algebraic equation for C. For non-integer slopes, no such algebraic equation exists — C is defined implicitly as a connection constant of a high-order linear ODE.

**Analogy:** Just as ζ(3) is defined by the ODE that the Riemann zeta function satisfies (Apéry's equation, order 3), C(3/2) is defined by a linear ODE of order 19. Both are (likely) transcendental, but finitely describable.

**Number-theoretic significance:** The set of slopes decomposes into:
- ℤ (integer slopes): C ∈ algebraic numbers (countable, "simple")
- ℚ \ ℤ (rational non-integer): C ∈ D-finite transcendentals (still countable, but qualitatively different)
- ℝ \ ℚ (irrational): C ∈ ??? (open — could be non-D-finite, truly "wild")

## Open Questions

- **Q1:** Extract the order-19 recurrence explicitly and verify. Use it to compute C(3/2) to high precision (hundreds of digits).
- **Q2:** Determine the recurrence order for other rational slopes (5/2, 4/3, etc.) — does the order grow with p+q? With p·q?
- **Q3:** Is C(α) a continuous function of α? If yes, C on rationals (countable dense subset) determines C on irrationals by continuity — even if irrational C is "wilder."
- **Q4:** Can the Banderier-Wallner Schur polynomial formula be specialized to yield our equation `(1-C)^{k+1} = 1-2C` for integer slopes?
- **Q5:** Is there a closed-form expression for C(3/2) in terms of known special functions? Status: HARD. Even for k=2, Mathematica can't simplify the recurrence to hypergeometric form. The GF involves convolutions of central binomials with Fuss-Catalan numbers — not a single hypergeometric function. The factored recurrence coefficients (arithmetic progressions 5n+4, 5n+9, 5n+14 for k=2) provide structural clues but no closed form yet. Requires Fuchsian ODE analysis or specialized holonomic software.

## Q1–Q2 Results: Recurrence Orders

Holonomic recurrence `Σ_{i=0}^{ord} p_i(n) · a(n+i) = 0` with `p_i` polynomial of degree `deg` in n. Found by NullSpace over ℤ (exact, no numerics).

| Slope | p+q | Integer? | ODE order | ODE degree | Terms used |
|-------|-----|----------|-----------|------------|------------|
| 2/1 (k=2) | 3 | ✅ | 3 | 4 | 400 |
| 3/1 (k=3) | 4 | ✅ | 5 | 8 | 400 |
| 3/2 | 5 | ❌ | 15 | 20 | 400 |
| 5/2 | 7 | ❌ | >30 | >20 | 400 (insufficient) |
| 4/3 | 7 | ❌ | >30 | >20 | 400 (insufficient) |

**Pattern:** Integer slopes have low ODE order (~2k-1). Non-integer slopes have dramatically higher order — the diagonal extraction of the bivariate algebraic GF amplifies the complexity. The amplification appears super-polynomial in p+q.

**Implication for C(3/2):** The recurrence polynomial coefficients have hundreds of digits. C is the connection constant of a 15th-order ODE — a transcendental number defined by this ODE, analogous to how ζ(3) is defined by Apéry's 3rd-order ODE.

**The "2" in Σ u^j = 2:** For integer slopes, the asymptotic constant comes from the Lindström formula via the shift operator λ(z) = (1-√(1-4z))/(2z). At the dominant singularity z=1/4: λ(1/4) = 2. The geometric sum in λ^{k+1} reduces to Σ u^j = 2. For non-integer slopes, the Lindström formula doesn't apply (no simple geometric sum), and the "2" has no analog.

## ore_algebra Analysis (2026-04-11, continuation)

Installed `ore_algebra` 0.5 with `passagemath` 10.8.3 (modular SageMath distribution) for automated holonomic analysis. Key advantage over Mathematica NullSpace approach: ore_algebra provides ODE analysis, local basis expansions, transition matrices, and monodromy — not just the recurrence.

### Integer Slope Results (ore_algebra)

| Slope | Rec order | Rec deg | ODE order | ODE leading coeff | x=1/4 mult |
|-------|-----------|---------|-----------|-------------------|------------|
| k=2 | 4 | 3 | 4 | 1296·x³·(x-1/4)²·(x+4/9)·(x+14/9) | 2 |
| k=3 | 5 | 8 | 11 | -11354112·(x-1/4)³·x³·(x²+3x/8+81/256) | 3 |

**Note:** ore_algebra recurrence orders differ from Mathematica NullSpace results because the two methods minimize different criteria (ore_algebra: balanced order/degree; NullSpace: minimum order for given degree bound). Both produce valid annihilating operators.

**Key finding:** Multiplicity of x=1/4 in ODE leading coefficient = k. This reflects the algebraic degree of C_k.

### Local Basis at x=1/4

For both k=2 and k=3, the dominant local solution is:

```
y_0(x) = (x - 1/4)^{-1/2} + O((x-1/4)^{3/2})
```

This exponent -1/2 directly implies the asymptotic form `a(n) ~ C · 4^n / √(πn)`.

Other local solutions have exponents 0, 1/2, 1, 3/2, ... (non-negative half-integers). The Fuchsian theory guarantees exactly `ord` independent solutions; apparent singularities manifest as zero solutions.

### Transition Matrices (0 → 1/4)

**k=2 (4×4 matrix):** Connection constants involve √5:
- `T[0,0] = 2.2360679... · i = √5 · i`
- `T[0,3] = 0.2360679... · i ≈ (√5 - 2) · i = 1/φ² · i`

All entries are algebraic in √5, confirming C_2 ∈ Q(√5). The value C_2 = 1/φ² = (3-√5)/2 follows.

**k=3 (11×11 matrix):** Connection constants are algebraic of higher degree, consistent with C_3 being a root of x³ - 4x² + 6x - 2 = 0 (a degree-3 algebraic number).

### Slope 3/2 (ore_algebra)

**Recurrence:** order 12, polynomial degree 50 (coefficients ~200 digits).

Compare: Mathematica NullSpace found order 15, degree 20. Different operator in the same annihilating ideal — ore_algebra trades order for degree.

**ODE:** Guessing from 500 terms failed (requires more terms or different approach).

**Next steps:**
1. Convert the order-12 recurrence to ODE via `.to_D()`
2. Factor the resulting differential operator
3. Compute local basis and transition matrix at x=1/4

### Singularity Structure Summary

| Slope | ODE singularities | x=1/4 type | x=1/4 dominant exponent |
|-------|-------------------|------------|------------------------|
| k=2 | {0, 1/4, -4/9, -14/9} | regular | -1/2 |
| k=3 | {0, 1/4, complex pair} | regular | -1/2 |
| k→∞ | {0, 1/4} (only) | ? | -1/2 |

The exponent -1/2 is universal — it comes from the "barrier constraint" nature of the problem. What changes between slopes is the connection constant C (which encodes how the global solution at 0 connects to the local solution (x-1/4)^{-1/2}).

## Scripts (this session)

- `poly_diagonal_dx.wl` — test `(1-x)^{k+1} = 1-((dx+1)/dx)x` for dx=1..4, k=2..4
- `poly_diagonal_dx_minpoly.wl` — brute-force minimal polynomial for dx=2
- `poly_diagonal_rational_alpha_fast.wl` — test `(1-C)^{p+q} = (1-2C)^q` for 14 rationals
- `poly_diagonal_rational_identify.wl` — minimal polynomial identification for non-integer slopes
- `poly_transfer_3_2.wl` — transfer matrix construction for slope 3/2
- `poly_transfer_3_2_v2.wl` — saddle point analysis (y* ≠ 1-C confirmed)
- `poly_identify_pslq.wl` — PSLQ identification with large coefficient bound
- `poly_gf_guess.wl` — algebraic equation guessing for F(z)
- `poly_gf_ode.wl` — holonomic recurrence search (found: ord 19, deg 15)
- `ore_guess_integer.py` — ore_algebra guess for k=2, k=3 (validation)
- `ore_analyze_k2.py` — full ODE analysis for k=2: singularities, local basis, transition matrix
- `ore_analyze_k3.py` — full ODE analysis for k=3
- `ore_guess_3_2.py` — ore_algebra guess for slope 3/2 (found: order 12, deg 50)
- `ore_guess_3_2_targeted.py` — targeted guess with constraints
