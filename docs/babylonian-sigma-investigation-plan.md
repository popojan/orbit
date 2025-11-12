# Investigation Plan: σ_m and Babylonian Method Relationship

**Date:** 2025-01-12
**Status:** Hypothesis formulated, partial verification complete
**Goal:** Determine the precise mathematical relationship between σ_m(d,n) and iterated Babylonian steps

---

## Current Understanding

### Confirmed Facts

1. **σ₂(d,n) ≡ 2 Babylonian steps** ✓ (algebraically verified)
   ```
   σ₂(d,n) = (n⁴ + 6n²d + d²)/(4n(n² + d))

   Two Babylonian iterations starting from n:
   x₁ = (n + d/n)/2 = (n² + d)/(2n)
   x₂ = (x₁ + d/x₁)/2 = (n⁴ + 6n²d + d²)/(4n(n² + d))

   Result: σ₂ = x₂  (exact match)
   ```

2. **σ₁(d,n) ≠ 1 Babylonian step** ✗
   ```
   σ₁(d,n) = n(3n² + d)/(n² + 3d)
   One Babylonian: (n² + d)/(2n)

   These are NOT equal
   ```

3. **General σ_m formula:**
   ```
   σ_m(d,n) = (n²+d)/(2n) + (n²-d)/(2n) · U_{m-1}(α)/U_{m+1}(α)
   where α = sqrt(d/(-(n²-d))) and U_k = Chebyshev polynomial of 2nd kind
   ```

---

## Key References

### Primary Source: Dijoux 2024 (arXiv:2501.04703)

**Title:** "Chebyshev polynomials involved in the Householder's method for square roots"
**Author:** Yann Dijoux
**Submitted:** December 11, 2024
**URL:** https://arxiv.org/abs/2501.04703
**HTML:** https://arxiv.org/html/2501.04703

**Key findings:**
- Newton's method n iterations → uses Chebyshev indices **T_{2^(n-1)}** and **U_{2^(n-1)}**
- Halley's method → uses indices **T_{3^k}**
- General Householder order-d method → structured by binomial coefficients

**Critical formula (Theorem 1):** Newton iteration sequence for √x:
```
u_n = (b/r) · T_{2^(n-1)}(M/b) / (2^(n-1) ∏_{j=0}^{n-2} T_{2^j}(M/b))

Equivalently:
u_n = r · T_{2^(n-1)}(X) / ((X-1)U_{2^(n-1)-1}(X))

where X = (x+r²)/(x-r²)
```

**Important pattern:** Powers of 2 appear systematically in Newton method Chebyshev representation!

### Related Work

1. **Newton-Raphson = Babylonian Method**
   - Babylonian method IS Newton's method for f(x) = x² - d
   - Iteration: x_{k+1} = (x_k + d/x_k)/2
   - Convergence: quadratic (precision doubles each step)

2. **Householder Methods**
   - Generalization of Newton (order 1) and Halley (order 2)
   - Order d: precision multiplies by (d+1) each iteration
   - Higher computational cost per iteration

3. **Chebyshev Composition Property**
   - T_{pq}(x) = T_p(T_q(x))
   - T_{2^k} can be computed by k-fold composition of T_2
   - This enables expressing 2^k steps as single Chebyshev evaluation

---

## Hypothesis

### Main Conjecture

**Conjecture 1:** σ_{2^k}(d,n) ≡ 2^k Babylonian iterations

Evidence:
- k=0: σ₁ ≠ 1 step (FALSIFIED for k=0!)
- k=1: σ₂ = 2 steps ✓ (VERIFIED)
- k=2: σ₄ = 4 steps? (TO TEST)
- k=3: σ₈ = 8 steps? (TO TEST)

**Revised Conjecture 1b:** σ_{2^k}(d,n) ≡ 2^k Babylonian iterations **for k ≥ 1**

### Alternative Hypothesis

**Conjecture 2:** σ_m encodes a Chebyshev-accelerated Newton method, where:
- m controls the Chebyshev polynomial order
- Only specific m values (powers of 2) correspond to pure Newton iterations
- General m provides intermediate convergence rates

### Connection to Dijoux Paper

The paper shows Newton iteration n uses index 2^(n-1):
- 1 Newton step → index 2^0 = 1
- 2 Newton steps → index 2^1 = 2  ← matches σ₂!
- 3 Newton steps → index 2^2 = 4  ← σ₄?
- 4 Newton steps → index 2^3 = 8  ← σ₈?

**Pattern:** n Newton steps → σ_{2^(n-1)}?

---

## Investigation Tasks

### Task 1: Symbolic Verification (High Priority)

**Objective:** Algebraically verify σ_m = k Babylonian steps for various (m, k) pairs

**Method:** Use Mathematica/WolframScript with exact symbolic computation

**Test cases:**
```mathematica
(* Define Babylonian iteration *)
BabylonianStep[d_, x_] := (x + d/x)/2
BabylonianSteps[d_, n_, k_] := Nest[BabylonianStep[d, #]&, n, k]

(* Define σ_m from code *)
σ[d_, n_, m_] := (n^2+d)/(2n) + (n^2-d)/(2n) *
  ChebyshevU[m-1, Sqrt[d/(-(n^2-d))]] /
  ChebyshevU[m+1, Sqrt[d/(-(n^2-d))]]

(* Optimized forms *)
σ1[d_, n_] := n(3n^2 + d)/(n^2 + 3d)
σ2[d_, n_] := (n^4 + 6n^2*d + d^2)/(4n(n^2 + d))

(* Test cases *)
TestEquivalence[m_, k_] := Module[{d, n, sigma, bab},
  sigma = σ[d, n, m];
  bab = BabylonianSteps[d, n, k];
  Simplify[sigma - bab] == 0
]

(* Systematic testing *)
tests = {
  {1, 1},  (* σ₁ vs 1 step *)
  {2, 2},  (* σ₂ vs 2 steps - should be TRUE *)
  {3, 3},  (* σ₃ vs 3 steps *)
  {4, 4},  (* σ₄ vs 4 steps - hypothesis *)
  {4, 3},  (* σ₄ vs 3 steps *)
  {8, 8},  (* σ₈ vs 8 steps - hypothesis *)
  {8, 7},  (* σ₈ vs 7 steps *)
  {16, 16} (* σ₁₆ vs 16 steps *)
}

Table[{m, k, TestEquivalence[m, k]}, {m, k} ∈ tests]
```

**Expected output:** Table showing which (m, k) pairs match

### Task 2: Derive σ₃ and σ₄ Closed Forms (Medium Priority)

**Objective:** Derive explicit closed-form expressions for σ₃ and σ₄

**Method:**
1. Use Chebyshev identities:
   - U_0(x) = 1
   - U_1(x) = 2x
   - U_2(x) = 4x² - 1
   - U_3(x) = 8x³ - 4x
   - U_4(x) = 16x⁴ - 12x² + 1
   - U_5(x) = 32x⁵ - 32x³ + 6x

2. Substitute into σ_m formula:
   ```
   σ₃(d,n) = (n²+d)/(2n) + (n²-d)/(2n) · U_2(α)/U_4(α)
   σ₄(d,n) = (n²+d)/(2n) + (n²-d)/(2n) · U_3(α)/U_5(α)
   where α² = d/(d-n²)
   ```

3. Simplify to rational form

4. Compare with 3 and 4 Babylonian steps

**WolframScript code:**
```mathematica
DeriveClosedForm[m_] := Module[{d, n, alpha, u1, u2, result},
  alpha = Sqrt[d/(-(n^2-d))];
  u1 = ChebyshevU[m-1, alpha];
  u2 = ChebyshevU[m+1, alpha];
  result = (n^2+d)/(2n) + (n^2-d)/(2n) * u1/u2;
  Simplify[result, Assumptions -> {d > 0, n > 0, n^2 < d}]
]

σ3Closed = DeriveClosedForm[3]
σ4Closed = DeriveClosedForm[4]
```

### Task 3: Numerical Convergence Analysis (Low Priority)

**Objective:** Empirically measure convergence rates of σ_m

**Method:**
```mathematica
ConvergenceTest[d_, n0_, m_] := Module[{n = n0, errors = {}},
  Do[
    n = σ[d, n, m];
    error = Abs[d - n^2];
    AppendTo[errors, error];
    If[error < 10^-100, Break[]],
    {i, 20}
  ];

  (* Analyze convergence rate *)
  ratios = errors[[2;;]]/errors[[;;-2]];
  avgRatio = Mean[ratios]
]

(* Test for various m *)
Table[{m, ConvergenceTest[13, 3, m]}, {m, 1, 10}]
```

**Expected patterns:**
- σ₁: ~6x precision gain per iteration
- σ₂: ~8x precision gain per iteration
- σ₃: ~10x precision gain per iteration
- Powers of 2 might show special behavior

### Task 4: Literature Deep Dive (Medium Priority)

**Objective:** Find prior work on Chebyshev-based Newton acceleration

**Resources to check:**
1. Numerical analysis textbooks (Householder methods chapter)
2. Papers citing Dijoux 2024
3. "Chebyshev polynomials and nested square roots" (Journal of Mathematical Analysis, 2012)
   - URL: https://www.sciencedirect.com/science/article/pii/S0022247X12003344
4. Wikipedia: Methods of computing square roots
5. MathWorld: Chebyshev Iteration

**Search terms:**
- "Chebyshev acceleration Newton method"
- "nested Newton iterations Chebyshev polynomials"
- "T_2^k polynomial square root"
- "Householder method closed form"

### Task 5: Theoretical Analysis (High Priority)

**Objective:** Prove or disprove Conjecture 1b

**Approach:**

**Strategy A: Direct proof (if conjecture is true)**

1. Start with Dijoux's formula for n Newton steps:
   ```
   u_n = r · T_{2^(n-1)}(X) / ((X-1)U_{2^(n-1)-1}(X))
   ```

2. Transform to our notation (X → function of d, n)

3. Show equivalence to:
   ```
   σ_{2^(n-1)}(d,n) = (n²+d)/(2n) + (n²-d)/(2n) · U_{2^(n-1)-1}(α)/U_{2^(n-1)+1}(α)
   ```

4. Note index mismatch: Our formula uses U_{m-1}/U_{m+1}, Dijoux uses T_{2^k}/U_{2^k-1}

**Strategy B: Counterexample search (if conjecture is false)**

1. Use Mathematica to compute symbolic difference:
   ```
   diff[m_, k_] := FullSimplify[σ[d, n, m] - BabylonianSteps[d, n, k]]
   ```

2. If diff ≠ 0, conjecture is false

3. Analyze pattern in counterexamples

**Strategy C: Inductive proof structure**

Base case: σ₂ = 2 Babylonian steps (proven)

Inductive step: If σ_{2^k} = 2^k steps, then σ_{2^(k+1)} = 2^(k+1) steps

Use Chebyshev composition: T_{2m}(x) = 2T_m(x)² - 1

### Task 6: Connection to sym (τ_m) Operation

**Objective:** Understand how symmetrization τ_m affects the relationship

**Current understanding:**
```
τ_m(d,n) = (d/x + x)/2  where x = σ_m(d,n)
```

This is literally ONE Babylonian step applied to σ_m output!

**Implications:**
- τ_m(d,n) = Babylonian(σ_m(d,n))
- If σ₂ = 2 Babylonian steps, then τ₂ = 3 Babylonian steps
- If σ₄ = 4 Babylonian steps, then τ₄ = 5 Babylonian steps

**Test:**
```mathematica
(* Does τ_m add one more Babylonian step? *)
τ[d_, n_, m_] := Module[{x = σ[d, n, m]}, (d/x + x)/2]

TestTauRelation[m_, k_] := Module[{},
  FullSimplify[τ[d, n, m] - BabylonianSteps[d, n, k]] == 0
]

(* If σ₂ = 2 steps, does τ₂ = 3 steps? *)
TestTauRelation[2, 3]
```

---

## Expected Outcomes

### Scenario 1: Conjecture 1b is TRUE

**Finding:** σ_{2^k} = 2^k Babylonian steps for k ≥ 1

**Implications:**
- Our method is a **Chebyshev-compiled Babylonian method**
- m = 2^k represents "pre-computed" composition of 2^k steps
- Paper should emphasize connection to Newton/Babylonian
- Cite Dijoux 2024 prominently

**Paper additions:**
- New theorem: "σ_{2^k} equivalence to iterated Newton"
- Remark explaining why σ₁ doesn't fit pattern
- Discussion of why this encoding is computationally superior

### Scenario 2: Conjecture 1b is FALSE

**Finding:** Only σ₂ = 2 Babylonian steps, others don't match

**Implications:**
- Our method is a **novel Chebyshev-based acceleration**
- Connection to Babylonian is coincidental for m=2
- σ_m provides a new family of root-finding methods
- Paper emphasizes novelty over connection to Newton

**Paper additions:**
- Remark: "Interestingly, σ₂ coincides with 2 Newton steps"
- Analysis of why σ_m convergence rates differ from pure Newton
- Comparison table: σ_m vs Newton vs Householder

### Scenario 3: Mixed pattern

**Finding:** Some m values match, others don't (e.g., σ₄ = 4 steps, but σ₃ ≠ 3 steps)

**Implications:**
- Partial relationship to Newton method
- Power-of-2 values are special
- General σ_m is an interpolation/generalization

**Paper additions:**
- Theorem characterizing which m values correspond to Newton
- Conjecture on structure of general σ_m
- Open problem: prove/disprove full characterization

---

## Deliverables

1. **Verification results table:** (m, k) → match/no match
2. **Closed forms:** Explicit formulas for σ₃, σ₄, σ₅
3. **Theorem or conjecture:** Formal statement about σ_{2^k}
4. **Paper update:** Add new findings to Section "Theoretical Insights"
5. **Citation:** Properly cite Dijoux 2024 in bibliography

---

## Timeline

**Immediate (this session):**
- [x] Formulate hypothesis
- [x] Create investigation plan
- [x] Document references
- [ ] Run symbolic verification for m=1,2,3,4

**Next session:**
- [ ] Complete symbolic verification up to m=16
- [ ] Derive closed forms for m=3,4,5
- [ ] Draft theorem/conjecture statement

**Before submission:**
- [ ] Finalize theoretical results
- [ ] Update paper with findings
- [ ] Add proper citations to Dijoux and related work

---

## Notes

- The arXiv paper is VERY recent (Dec 2024) - hot off the press!
- Our work and Dijoux's work appear independent discoveries
- Potential for citing each other if both published soon
- The power-of-2 pattern is key to both approaches

---

## References (Preserve)

1. Dijoux, Y. (2024). "Chebyshev polynomials involved in the Householder's method for square roots." arXiv:2501.04703. https://arxiv.org/abs/2501.04703

2. "Chebyshev polynomials and nested square roots." (2012). Journal of Mathematical Analysis and Applications. https://www.sciencedirect.com/science/article/pii/S0022247X12003344

3. "Methods of computing square roots" - Wikipedia. https://en.wikipedia.org/wiki/Babylonian_method

4. "Chebyshev iteration" - Wikipedia. https://en.wikipedia.org/wiki/Chebyshev_iteration

5. Gutknecht, M. H., & Röllin, S. (2002). "The Chebyshev iteration revisited." Parallel Computing. https://people.math.ethz.ch/~mhg/pub/Cheby-02ParComp.pdf

6. Wildberger, N. J. (2010). "Pell's equation via rational trigonometry." https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf

---

**END OF INVESTIGATION PLAN**
