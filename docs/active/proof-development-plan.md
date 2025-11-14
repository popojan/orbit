# Primorial Cancellation Proof: Machine-Readable Development Plan

**Goal:** Prove that the alternating factorial sum systematically produces primorials with only first powers of primes.

**Status:** Open problem requiring rigorous proof
**Computational verification:** Complete up to m = 100,000 (69% toward 1,000,000)

---

## Core Conjecture (Main Target)

**Conjecture (P-adic Valuation Structure):**

For all integers k ≥ 1 and all primes p with 3 ≤ p ≤ 2k+1:

```
ν_p(den(S_k)) = 1
ν_p(num(S_k)) = 0
```

where `S_k = (1/2) * Σ(i=1 to k) [(-1)^i * i! / (2i+1)]`

---

## Proof Strategy: Decomposition into Verifiable Lemmas

The proof breaks into **5 major components**, each with computational verification tasks.

---

## COMPONENT 1: Base Cases and Initial Structure

### Lemma 1.1: Base Case (k=1)
**Statement:**
```
S_1 = (1/2) * (-1! / 3) = -1/6
den(S_1) = 6 = 2 × 3
ν_2(6) = 1, ν_3(6) = 1 ✓
```

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_1_1.wl *)
S1 = 1/2 * (-1!/3);
{Numerator[S1], Denominator[S1]} == {-1, 6}
```

**Status:** Trivial ✓

---

### Lemma 1.2: First Prime Entry (2k+1 = p prime)
**Statement:**
When 2k+1 = p is prime and k = (p-1)/2, the term introduces prime p with multiplicity 1.

**Proof sketch:**
- ν_p(k!) = floor(k/p) = floor((p-1)/2 / p) = 0 (since p ≥ 3)
- ν_p(2k+1) = 1
- Therefore ν_p(den(T_k)) = 1 before combining with S_{k-1}

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_1_2.wl *)
(* Test for first 1000 primes *)
VerifyFirstPrimeEntry[pmax_] := Module[{primes, results},
  primes = Select[Range[3, pmax], PrimeQ];
  results = Table[
    Module[{k, vp},
      k = (p - 1)/2;
      vp = Sum[Floor[k/p^i], {i, 1, Infinity}];
      {p, k, vp == 0}  (* ν_p(k!) should be 0 *)
    ],
    {p, primes}
  ];
  AllTrue[results, Last]  (* Should return True *)
]

(* Test *)
VerifyFirstPrimeEntry[10000]
```

**Expected output:** `True`
**Status:** Provable via Legendre's formula

---

## COMPONENT 2: Prime Power Cancellation (The Core Mystery)

### Lemma 2.1: First Occurrence of p^2
**Statement:**
When 2k+1 = p^2 is the FIRST occurrence of p^2, the accumulated numerator contains exactly one factor of p that cancels the excess power.

**Critical cases to verify:**
- k=4: 2k+1 = 9 = 3^2
- k=12: 2k+1 = 25 = 5^2
- k=27: 2k+1 = 49 = 7^2
- k=60: 2k+1 = 121 = 11^2

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_2_1.wl *)
VerifyPrimeSquareCancellation[kmax_] := Module[{results},
  results = Table[
    Module[{val, p, vpNum, vpDen},
      val = 2*k + 1;
      If[PrimePowerQ[val] && FactorInteger[val][[1, 2]] == 2,
        p = FactorInteger[val][[1, 1]];
        (* Compute S_k *)
        Sk = 1/2 * Sum[(-1)^i * i!/(2*i + 1), {i, 1, k}];
        vpNum = If[Numerator[Sk] == 0, Infinity,
                   IntegerExponent[Abs[Numerator[Sk]], p]];
        vpDen = IntegerExponent[Denominator[Sk], p];
        {k, val, p, vpNum, vpDen, vpDen == 1},
        Nothing
      ]
    ],
    {k, 1, kmax}
  ];
  {results, AllTrue[results, #[[6]] &]}
]

(* Test up to k=1000 *)
VerifyPrimeSquareCancellation[1000]
```

**Expected output:** All `vpDen == 1` entries should be `True`
**Status:** Computationally verified; theoretical proof needed

---

### Lemma 2.2: Numerator Divisibility Pattern
**Statement:**
For the partial sum S_k, when 2k+1 contains p^j (j ≥ 2):

```
ν_p(num(S_k)) ≥ ν_p(num(S_{k-1}))
```

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_2_2.wl *)
TrackNumeratorValuations[p_, kmax_] := Module[{results},
  results = Table[
    Module[{Sk, vpNum},
      Sk = 1/2 * Sum[(-1)^i * i!/(2*i + 1), {i, 1, k}];
      vpNum = If[Numerator[Sk] == 0, Infinity,
                 IntegerExponent[Abs[Numerator[Sk]], p]];
      {k, 2*k + 1, vpNum}
    ],
    {k, 1, kmax}
  ];

  (* Check monotonicity *)
  monotonic = AllTrue[
    Partition[results[[All, 3]], 2, 1],
    #[[1]] <= #[[2]] &
  ];

  {results, monotonic}
]

(* Track for p=3 up to k=100 *)
TrackNumeratorValuations[3, 100]
```

**Expected output:** Monotonicity should hold
**Status:** Hypothesis to verify

---

### Lemma 2.3: The Alternating Sign Necessity
**Statement:**
Without the alternating sign (-1)^k, the formula fails at k=4.

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_2_3.wl *)
TestAlternatingSignNecessity[] := Module[{Swith, Swithout},
  (* With alternating sign *)
  Swith = 1/2 * Sum[(-1)^i * i!/(2*i + 1), {i, 1, 4}];

  (* Without alternating sign *)
  Swithout = 1/2 * Sum[i!/(2*i + 1), {i, 1, 4}];

  {
    "With alternation" -> {Numerator[Swith], Denominator[Swith]},
    "Without alternation" -> {Numerator[Swithout], Denominator[Swithout]},
    "Denominator ratio" -> Denominator[Swith] / Denominator[Swithout],
    "Missing factor" -> FactorInteger[Denominator[Swith] / Denominator[Swithout]]
  }
]

TestAlternatingSignNecessity[]
```

**Expected output:** Should show denominator without alternation is missing factor of 3
**Status:** Computationally verified; need theoretical explanation

---

## COMPONENT 3: Legendre Formula Connections

### Lemma 3.1: Integer Term Criterion
**Statement:**
For sufficiently large k, if 2k+1 = p^j, then ν_p(k!) ≥ j, making the term an integer.

**Legendre's formula:**
```
ν_p(k!) = Σ(i=1 to ∞) floor(k / p^i)
```

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_3_1.wl *)
VerifyIntegerTermCriterion[pmax_] := Module[{results},
  results = Table[
    Module[{k, j, vpFact},
      If[PrimePowerQ[2*k + 1],
        p = FactorInteger[2*k + 1][[1, 1]];
        j = FactorInteger[2*k + 1][[1, 2]];
        vpFact = Sum[Floor[k/p^i], {i, 1, Floor[Log[p, k]] + 1}];
        {k, 2*k + 1, p, j, vpFact, vpFact >= j},
        Nothing
      ]
    ],
    {k, 1, pmax}
  ];

  (* Partition by criterion satisfaction *)
  {
    "Integer terms (ν_p(k!) ≥ j)" -> Select[results, #[[6]] &],
    "Non-integer terms (ν_p(k!) < j)" -> Select[results, !#[[6]] &]
  }
]

VerifyIntegerTermCriterion[10000]
```

**Expected output:** Clear division between integer and non-integer terms
**Status:** Computable, pattern to identify

---

### Lemma 3.2: Critical Transition Point
**Statement:**
For each prime p, there exists k_critical such that for all k > k_critical:
If p^j | (2k+1), then ν_p(k!) ≥ j (term becomes integer)

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_3_2.wl *)
FindCriticalTransition[p_, jmax_] := Module[{results},
  results = Table[
    Module[{kcrit},
      (* Find smallest k where 2k+1 = p^j and ν_p(k!) ≥ j *)
      kcrit = SelectFirst[
        Range[1, 10000],
        Module[{vpFact},
          vpFact = Sum[Floor[#/p^i], {i, 1, Floor[Log[p, #]] + 1}];
          2*# + 1 == p^j && vpFact >= j
        ] &,
        None
      ];
      {p, j, kcrit}
    ],
    {j, 2, jmax}
  ];
  results
]

(* Find critical transitions for p=3 *)
FindCriticalTransition[3, 5]
```

**Expected output:** Sequence of critical k values for each j
**Status:** Pattern discovery task

---

## COMPONENT 4: Inductive Proof Structure

### Lemma 4.1: Induction Hypothesis
**Statement:**
Assume ν_p(den(S_{k-1})) = 1 for all primes p ≤ 2(k-1)+1.
Prove: ν_p(den(S_k)) = 1 for all primes p ≤ 2k+1.

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_4_1.wl *)
VerifyInductiveStep[kstart_, kend_] := Module[{results},
  results = Table[
    Module[{Sk, Skprev, primes, checks},
      Sk = 1/2 * Sum[(-1)^i * i!/(2*i + 1), {i, 1, k}];
      Skprev = 1/2 * Sum[(-1)^i * i!/(2*i + 1), {i, 1, k - 1}];

      primes = Select[Range[3, 2*k + 1], PrimeQ];

      checks = Table[
        {p,
         IntegerExponent[Denominator[Skprev], p],
         IntegerExponent[Denominator[Sk], p]},
        {p, primes}
      ];

      {k, AllTrue[checks, #[[2]] == 1 && #[[3]] == 1 &]}
    ],
    {k, kstart, kend}
  ];

  {results, AllTrue[results, Last]}
]

(* Verify inductive steps from k=10 to k=100 *)
VerifyInductiveStep[10, 100]
```

**Expected output:** All steps should satisfy the hypothesis
**Status:** Computational verification of pattern

---

### Lemma 4.2: Case Analysis by 2k+1 Type
**Statement:**
The inductive step divides into cases:
1. 2k+1 is prime p (new prime enters)
2. 2k+1 = p^j, j ≥ 2 (prime power, first occurrence)
3. 2k+1 = p^j, j ≥ 2 (prime power, recurring)
4. 2k+1 is composite with multiple prime factors

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_4_2.wl *)
ClassifyInductiveCases[kmax_] := Module[{cases},
  cases = Table[
    Module[{val, factors, type},
      val = 2*k + 1;
      factors = FactorInteger[val];

      type = Which[
        PrimeQ[val], "New Prime",
        Length[factors] == 1 && factors[[1, 2]] >= 2, "Prime Power",
        Length[factors] > 1, "Composite (Multiple Factors)"
      ];

      {k, val, factors, type}
    ],
    {k, 1, kmax}
  ];

  GroupBy[cases, #[[4]] &]
]

(* Classify first 100 cases *)
ClassifyInductiveCases[100]
```

**Expected output:** Distribution across the 4 case types
**Status:** Pattern classification

---

## COMPONENT 5: Wilson's Theorem and Half-Factorial Structure

### Lemma 5.1: Half-Factorial Modular Structure
**Statement:**
When 2k+1 = p is prime, k = (p-1)/2, and:

```
k! = ((p-1)/2)! ≡ ±1 (mod p)  if p ≡ 3 (mod 4)
k! = ((p-1)/2)! ≡ ±i (mod p)  if p ≡ 1 (mod 4)
```

where i^2 ≡ -1 (mod p).

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_5_1.wl *)
VerifyHalfFactorialStructure[pmax_] := Module[{primes, results},
  primes = Select[Range[3, pmax], PrimeQ];

  results = Table[
    Module[{k, hf, expected},
      k = (p - 1)/2;
      hf = Mod[k!, p];

      expected = Which[
        Mod[p, 4] == 3, {1, p - 1},  (* ±1 mod p *)
        Mod[p, 4] == 1, Module[{sqrtm1},
          sqrtm1 = PowerMod[-1, 1/2, p];
          {sqrtm1, p - sqrtm1}  (* ±i mod p *)
        ]
      ];

      {p, Mod[p, 4], k, hf, MemberQ[expected, hf]}
    ],
    {p, primes}
  ];

  {results, AllTrue[results, Last]}
]

(* Verify for primes up to 1000 *)
VerifyHalfFactorialStructure[1000]
```

**Expected output:** All primes should satisfy the modular structure
**Status:** Connected to existing ModularFactorials module

---

### Lemma 5.2: Connection to Gauss Sums
**Statement:**
The half-factorial structure is related to quadratic Gauss sums:

```
G(a, p) = Σ(t=0 to p-1) exp(2πi a t^2 / p)
```

**Verification Task:**
```mathematica
(* File: scripts/verify_proof_lemma_5_2.wl *)
(* This is more theoretical - symbolic verification *)
VerifyGaussSumConnection[p_] := Module[{k, hf, gauss},
  k = (p - 1)/2;
  hf = Mod[k!, p];

  (* Gauss sum for a=1 *)
  gauss = Sum[
    Exp[2*Pi*I*t^2/p],
    {t, 0, p - 1}
  ];

  {
    "Prime" -> p,
    "Half-factorial mod p" -> hf,
    "Gauss sum" -> N[gauss],
    "Connection" -> N[Abs[gauss]^2] == p
  }
]

(* Test for p=13 *)
VerifyGaussSumConnection[13]
```

**Expected output:** Connection via quadratic residues
**Status:** Theoretical bridge to existing literature

---

## COMPUTATIONAL MILESTONES

### Milestone 1: Small Range Complete Verification (k ≤ 100)
- **Task:** Run all verification scripts for k = 1 to 100
- **Files:** All `verify_proof_lemma_*.wl` scripts
- **Expected time:** ~1 minute
- **Deliverable:** `reports/proof_verification_k100.txt`

### Milestone 2: Medium Range Pattern Discovery (k ≤ 10,000)
- **Task:** Identify patterns, critical transitions, case distributions
- **Files:** Lemmas 3.2, 4.2 scripts
- **Expected time:** ~10 minutes
- **Deliverable:** `reports/proof_patterns_k10000.json`

### Milestone 3: Large Range Validation (k ≤ 100,000)
- **Task:** Statistical validation of all lemmas at scale
- **Files:** Extended versions with progress tracking
- **Expected time:** ~1-2 hours
- **Deliverable:** `reports/proof_validation_k100000.csv`

### Milestone 4: Theoretical Writeup
- **Task:** Document findings, formalize proofs based on computational evidence
- **Files:** LaTeX document with theorems and proofs
- **Expected time:** Manual work post-computation
- **Deliverable:** `docs/primorial-rigorous-proof.tex`

---

## PROOF COMPLETION CHECKLIST

- [ ] **Lemma 1.1:** Base case verified
- [ ] **Lemma 1.2:** Prime entry mechanism proven
- [ ] **Lemma 2.1:** Prime square cancellation verified (k ≤ 100,000)
- [ ] **Lemma 2.2:** Numerator divisibility pattern confirmed
- [ ] **Lemma 2.3:** Alternating sign necessity explained theoretically
- [ ] **Lemma 3.1:** Integer term criterion established with Legendre formula
- [ ] **Lemma 3.2:** Critical transition points identified for all primes p ≤ 1000
- [ ] **Lemma 4.1:** Inductive step verified computationally
- [ ] **Lemma 4.2:** Case analysis complete with distribution data
- [ ] **Lemma 5.1:** Half-factorial structure connected to Wilson's theorem
- [ ] **Lemma 5.2:** Gauss sum connection formalized
- [ ] **Final proof:** All lemmas combined into rigorous mathematical proof

---

## EXECUTION PLAN (WolframScript Session)

```bash
# Step 1: Create all verification scripts
cd /path/to/orbit/scripts

# Step 2: Run Milestone 1 (quick verification)
wolframscript verify_proof_lemma_1_1.wl
wolframscript verify_proof_lemma_1_2.wl
# ... (all lemmas)

# Step 3: Batch execution for Milestone 2
wolframscript run_all_proof_verifications.wl 10000

# Step 4: Generate reports
wolframscript generate_proof_report.wl

# Step 5: Review outputs and identify theoretical gaps
cat reports/proof_verification_summary.txt
```

---

## THEORETICAL GAPS REQUIRING HUMAN INSIGHT

Even with complete computational verification, these questions need theoretical resolution:

1. **Why does alternating sign create the exact cancellation pattern?**
   - Modular arithmetic argument needed
   - Connection to alternating group structures?

2. **Can we prove the numerator structure explicitly?**
   - Closed form for num(S_k) in terms of k?
   - Recurrence relation for numerators?

3. **Is there a generating function interpretation?**
   - Does this connect to L-functions or zeta functions?
   - Primorial generating function known?

4. **Can the proof be made fully constructive?**
   - Explicit formula for ν_p(num(S_k))?
   - Algorithmic approach without case-by-case analysis?

---

## REFERENCES FOR THEORETICAL DEVELOPMENT

- **Legendre (1830):** Théorie des nombres — Factorial prime factorization
- **Wilson's Theorem:** Connection to half-factorials
- **Wolstenholme's Theorem:** Binomial coefficient denominators
- **Gauss Sums:** Quadratic residues and character sums
- **P-adic Analysis:** Valuation theory and systematic cancellations

---

## STATUS SUMMARY

**Computational evidence:** STRONG (verified to 100,000)
**Theoretical proof:** INCOMPLETE
**Next critical step:** Prove Lemma 2.1 (prime square cancellation) rigorously
**Estimated difficulty:** PhD-level problem in analytic/algebraic number theory

**This plan is ready for systematic computational attack with WolframScript.**
