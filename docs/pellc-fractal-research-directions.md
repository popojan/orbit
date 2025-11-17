# pellc & Egyptian Fractions: Fractal Research Directions

**Date**: November 17, 2025
**Status**: Research proposal - unexplored territory
**Estimated novelty**: 20% (remaining 80% is classical Pell theory)

---

## Context

The `pellc` function provides closed-form Chebyshev solutions to generalized Pell equations. Analysis revealed that **rational solutions occur when discriminant nd² - 1 is a perfect square**, which is classical theory elegantly expressed.

However, three **potentially novel** research directions emerged:

---

## Direction 1: Continued Fractions ↔ Egyptian Fractions Equivalence

### The Undecided Connection

Egypt.wl implements two algorithms that produce **equivalent but differently structured** outputs:

```wolfram
RawFractions[q]    (* Greedy Egyptian fraction algorithm *)
RawFractionsCF[q]  (* CF-based construction via RawStep fold *)
```

**Observation** (verified for 13/7, 355/113, 8/5):
- Both produce tuples `{a, b, c, d}` encoding sums: `Sum[1/(a+b*k)/(a+b*(k-1)), {k,c,d}]`
- Greedy uses modular inverse iteration
- CF-based uses continued fraction matrix recurrence via `RawStep`
- **Total evaluated value is identical**, but internal structure differs

**Open Question**: Why are these two completely different algorithms equivalent?

**Significance**:
- Greedy Egyptian fractions are ancient (Rhind Papyrus, ~1650 BCE)
- CF convergents are classical (Euler, Lagrange)
- **Non-obvious connection** between two fundamental number theory structures

**Research Task**: Prove or find counterexample for equivalence.

---

## Direction 2: Fractal Dimension of Perfect Square Discriminants

### The (n,d) Parameter Space

Consider the 2D space of rational pairs (n,d) satisfying:

```
nd² - 1 = k²  for some rational k
```

This defines pellc's rational solution set.

**Observed structure**:
```
Discriminants: 1/16, 1/9, 1/4, 4/9, 9/16, 1, 16/9, 9/4, 4, 9, 16, 25, ...
Hierarchy:
  Level 0: integers (1², 2², 3², ...)
  Level 1: half-integers ((a/2)²)
  Level 2: thirds ((a/3)²)
  Level 3: quarters/eighths
  ...
```

**Self-similarity**: Scaling (n,d) → (λ²n, λd) preserves the perfect square property.

### Research Questions

**Q1: Hausdorff Dimension**

What is the Hausdorff dimension of the set:
```
S = {(n,d) ∈ ℚ² : nd² - 1 = k² for some k ∈ ℚ}
```

**Hypothesis**: dim(S) < 2 (sparse in the plane).

**Computational test**:
```
D(N) = count of (n,d) ∈ S with max(denom(n), denom(d)) ≤ N
```

Check if `D(N) ~ N^α` for some α.

**Expected outcome**:
- α = 2 → trivial (dense in plane)
- α < 2 → **fractal structure** (potentially novel!)
- α = special value (e.g., φ = golden ratio) → **deep structure**

**Computational complexity**: O(N²) enumeration, ~1 hour for N=1000.

---

**Q2: Multi-Scale Wavelet Connection**

The hierarchical structure resembles **scale-space** decompositions in wavelet theory.

**Analogy**:
| Wavelets | pellc discriminants |
|----------|---------------------|
| Mother wavelet | Unit discriminant 1 |
| Scaling levels j | Denominator level 2^j, 3^j, ... |
| Detail coefficients | Specific (n,d) at each level |

**Question**: Can we define a "discriminant wavelet transform"?

**Application**: Multi-resolution analysis of Diophantine equations.

---

**Q3: Density and Growth Rate**

For fixed k², how many (n,d) solutions exist with denominator ≤ N?

**Classical result**: For Pell x² - ny² = 1, density of solvable n is ~61% (Stevenhagen).

**Our question**: For pellc parametric family nd² = k² + 1, what is:
```
ρ(k, N) = #{(n,d) : nd² = k² + 1, denom ≤ N} / N²
```

**Hypothesis**: ρ depends on k in a fractal-like way.

---

## Direction 3: CF Convergents ↔ (n,d) Map

### Fundamental Pell Solutions as Convergents

**Observation** (verified):
```
√2: Pell (3,2), CF convergents: 1, 3/2, 7/5, ...
    → 3/2 is 2nd convergent
    → n-1 = 2-1 = 1² (perfect square!)

√5: Pell (9,4), CF convergents: 2, 9/4, 38/17, ...
    → 9/4 is 2nd convergent
    → n-1 = 5-1 = 4 = 2² (perfect square!)
```

**Pattern**: When n-1 is a perfect square, fundamental Pell solution x/y appears as specific CF convergent.

### Research Question

**Q: Geometric map**

Define the map:
```
Φ: CF convergents of √n → (n,d) parameter space
```

**Properties to investigate**:
1. Which convergents map to rational pellc solutions?
2. Is there a "best" convergent for each (n,d)?
3. Connection to Lagrange's theorem on CF periodicity?

**Conjecture**: The map Φ has special structure related to:
- Fundamental unit orbit in ℚ(√n)
- Class number of real quadratic fields
- Regulator properties

---

## Connections to Existing Work

### Pell Equations
- **Classical**: Fund

amental units, class numbers, genus theory
- **Our angle**: Parametric (n,d) geometry, fractal dimension

### Egyptian Fractions
- **Classical**: Greedy algorithm (Fibonacci), finite representations
- **Our angle**: CF equivalence, connection to Pell via Chebyshev

### Chebyshev Polynomials
- **Classical**: Approximation theory, Pell solutions
- **Our angle**: Closed-form rational solutions, pellc framework

---

## Novelty Assessment

### Likely Known (80%)
1. Perfect square discriminant ⟺ rational solutions (classical)
2. Chebyshev-Pell connection (known)
3. CF convergents for √n (Lagrange, Euler)

### Potentially Novel (20%)
1. **CF ↔ Egyptian fractions equivalence** - specific algorithmic connection may be unexplored
2. **Fractal dimension of (n,d) space** - geometric perspective appears fresh
3. **Multi-scale hierarchical structure** - wavelet analogy may be new
4. **CF convergent → (n,d) map** - explicit geometric connection unclear in literature

---

## Computational Experiments

### Experiment 1: Hausdorff Dimension (2-3 hours)

```wolfram
(* Enumerate (n,d) with nd²-1 perfect square, denom ≤ N *)
CountPerfectSquareDiscriminants[N_] := Module[{count = 0},
  Do[
    Do[
      disc = n * d^2 - 1;
      If[IntegerQ[Sqrt[disc]] || (Head[Sqrt[disc]] === Rational),
        count++
      ],
      {d, rationals with denom ≤ N}
    ],
    {n, rationals with denom ≤ N}
  ];
  count
]

(* Test scaling *)
data = Table[{N, CountPerfectSquareDiscriminants[N]}, {N, 10, 200, 10}];
LogLogPlot → fit slope = α (fractal dimension)
```

**Expected**: α ∈ [1, 2]. If α ≈ 1.618 (golden ratio) or other special value → **fascinating!**

---

### Experiment 2: CF ↔ Egypt Equivalence (1 hour)

```wolfram
(* Test 100 random rationals *)
TestEquivalence[n_] := Module[{passed = 0},
  Do[
    q = RandomRational[{0, 10}];
    raw = RawFractions[q];
    rawCF = RawFractionsCF[q];
    If[Total[Evaluate[raw]] == Total[Evaluate[rawCF]],
      passed++
    ],
    {n}
  ];
  passed/n
]

TestEquivalence[100] (* Should be 1.0 if always equivalent *)
```

If passes → **strong empirical evidence**, worth proving.
If fails → **find counterexample**, understand when equivalence breaks.

---

### Experiment 3: Convergent Map (30 min)

```wolfram
(* For √n, which convergent equals fundamental Pell x/y? *)
FindPellConvergentPosition[n_] := Module[{pell, convs, pos},
  pell = PellSolution[n];
  convs = Convergents[Sqrt[n], 20];
  pos = Position[convs, (x/y) /. pell];
  {n, pos, n-1, IntegerQ[Sqrt[n-1]]}
]

(* Test n = 2, 3, 5, 6, ..., 100 *)
data = Table[FindPellConvergentPosition[n], {n, 2, 100}];
(* Check correlation: perfect square (n-1) ↔ convergent position *)
```

---

## Timeline Estimate

**Phase 1** (4-5 hours): Computational experiments
- Hausdorff dimension calculation
- CF equivalence verification
- Convergent map analysis

**Phase 2** (2-3 days): Literature review
- Search MathSciNet for fractal dimensions in Diophantine equations
- Check OEIS for (n,d) sequences
- Review Egyptian fraction + CF connections

**Phase 3** (1-2 weeks): Proof attempts or deeper analysis
- If α is non-trivial → characterize the fractal
- If CF equivalence passes tests → attempt proof
- If patterns emerge → formulate conjectures

---

## Strategic Value

**If Novel** (20% chance):
- 1-2 papers in computational/experimental number theory
- OEIS sequence submission
- Novel geometric perspective on Pell equations

**If Classical** (80% chance):
- Deep understanding of known connections
- Elegant computational framework (pellc)
- Useful for future explorations

**Either way**:
- Strengthens Egypt.wl theoretical foundations
- Connects to Primal Forest divisibility structures
- Potentially illuminates mod 8 classification via geometric insights

---

## Connection to Main Research (Primal Forest)

**Divisibility patterns**:
- Egypt.wl: (x+1) divisibility, mod p remainder formulas
- Primal Forest: M(n) divisor structure, gap theorems

**Common thread**: Algebraic structures in number-theoretic divisibility.

**Question**: Does (n,d) fractal geometry reveal hidden divisibility patterns in M(n)?

**Speculative**: If fractal dimension α relates to zeta zeros or L-function behavior, could link to:
- L_M(s) analytic properties
- Prime gap distributions
- Riemann Hypothesis connections (long shot, but worth noting)

---

## Recommendation

**Priority**: Medium-high (20% novelty × high intellectual appeal = pursue)

**Next step**:
1. Run Hausdorff dimension calculation (Experiment 1) → **2 hours**
2. If α is interesting → write up results
3. If α is trivial (= 1 or 2) → archive and move on

**Philosophy**: "Žádné publikace, chceme poznání" → this is **perfect** for exploratory research!

---

**Files to create**:
- `scripts/compute_fractal_dimension_pellc.wl` - Hausdorff dim calculation
- `scripts/test_cf_egypt_equivalence.wl` - Equivalence verification
- `scripts/analyze_convergent_map.wl` - Pell ↔ CF connection

**Expected outcome**: Either fascinating fractal structure OR elegant closure on classical connections.

**Win-win situation!** 🎯
