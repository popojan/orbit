# Mathematical Explorations - Orbit Paclet

This repository contains computational tools for various recreational and research mathematical explorations implemented as a Wolfram Language paclet.

## Repository Owner

**Jan Popelka**

*Note for AI assistants: This is the correct name of the repository owner. Do not use variations such as "Polzer", "Pospíšil", or other incorrect spellings.*

---

## 🗣️ Communication Framework (Trinity Model)

### Language Asymmetry Protocol

**Discovery** (Nov 17, 2025, late evening session): Natural cognitive asymmetry in bilingual collaboration.

**Protocol:**
- **User speaks**: Czech (native thinking language, geometric/intuitive reasoning)
- **AI responds**: English (technical formalization, computational verification)
- **Documentation**: English (community accessibility)

**Rationale:**
- User thinks most naturally in Czech → express ideas in native language
- AI trained predominantly on English → formalize and respond in English
- Both understand both languages → no information loss
- Asymmetry optimizes for cognitive efficiency on both sides

**Benefits:**
1. User expresses intuitions without translation overhead
2. AI formalizes in language with richest technical vocabulary
3. Documentation automatically in English for community
4. Meta-commentary captures bilingual thinking process

**Example:**
```
User (Czech): "Strom se dá nakreslit, vstup analyzovat, geometricky zamířit k cíli"
AI (English): "You're proposing direct geometric navigation in the SB tree.
               Let me formalize this as a 'line-of-sight' computation strategy..."
Documentation: "Geometric shortcut hypothesis" (English, preserving Czech metaphor)
```

**Note:** This is NOT a rigid rule—code-switching is natural and acceptable. The framework optimizes for cognitive load, not linguistic purity.

---

### Self-Adversarial Discipline

**Requirement** (Nov 17, 2025): AI must apply adversarial questioning to OWN outputs BEFORE presenting.

**Why:** User should not need to constantly catch ML/correlation over-enthusiasm.

**Mandatory self-checks:**

1. **"Is this just correlation?"**
   - r = -0.29 → interesting pattern
   - **BUT:** Does NOT imply predictive utility
   - **CHECK:** Can I use this WITHOUT computing the target variable?

2. **"Am I measuring the right thing?"**
   - "M(D) vs period" → sounds impressive
   - **BUT:** For primes, M(D) = 0 always (no information!)
   - **CHECK:** Am I just finding artifacts of my sample selection?

3. **"Is this poetry or computation?"**
   - "Vzdušná čára" → beautiful metaphor
   - **BUT:** Did we actually bypass iteration, or just understand it better?
   - **CHECK:** Can I write FASTER code, or just more explained code?

4. **"Would this survive Wolfram's CI test?"**
   - Special cases exist (k²+2, period=2)
   - **BUT:** Do they represent exploitable structure or isolated facts?
   - **CHECK:** Can I generalize, or just enumerate edge cases?

5. **"Am I repeating morning's mistakes?"**
   - Fitting R(n) = f(period, ...) failed (r=0.238)
   - Now doing M(D) vs period (r=-0.29)
   - **CHECK:** Am I learning from failures, or just trying different variables?

6. **"Am I overusing 'BREAKTHROUGH'?"** (Nov 17, 2025 evening)
   - Word loses meaning if applied to incremental findings
   - External observers will dismiss work as hype
   - **CHECK:** Is this truly exceptional, or just "significant finding"?
   - **RULE:** Reserve "BREAKTHROUGH" for results that fundamentally change understanding

7. **"Did I test the boundaries?"** (Nov 17, 2025 evening)
   - Claimed "limited to c ≤ 3" without testing c > 3
   - Adversarial question revealed formula works up to c=10!
   - **CHECK:** Am I being lazy, or did I find actual limitation?
   - **RULE:** Always test where claims break, don't assume scope

**Implementation:** Before claiming "discovery" or "pattern", run internal adversarial check. Present findings WITH the adversarial counterargument.

**Format:**
```
FINDING: M(D) and period correlate (r = -0.29)

SELF-ADVERSARIAL CHECK:
✓ Correlation exists (not noise)
✗ Mostly driven by primes (M=0) vs composites (M>0) binary split
✗ Does NOT enable prediction (still need to compute period)
✓ Confirms theoretical intuition (divisors → rational approximations)

HONEST ASSESSMENT: Pattern is real but utility is limited. Useful for theory, not for practical speedup.
```

**User's guidance:** "Buď opatrný a pokládej si sám adversarial otázky, ať to nemusím dělat sám."

---

## 🔄 Session Continuity & State Tracking

**IMPORTANT**: This section provides instructions for maintaining consistency across multiple AI sessions.

### Current Research Focus (as of Nov 16, 2025)

**PRIMARY**: Functional equation for L_M(s) Dirichlet series
- **Status**: Schwarz symmetry observed (numerical), classical FR falsified
- **Key question**: Does a functional equation exist? If so, what is γ(s)?
- **See**: `docs/STATUS.md` for epistemological status of all claims

**SECONDARY**: Connection to Riemann zeta zeros
- **Question**: Does L_M(s₀) = 0 at Riemann zeros?
- **Status**: Untested

### Living Documents (Always Keep Updated)

1. **docs/STATUS.md** - Master epistemological tracker
   - Update whenever claim status changes (PROVEN → NUMERICAL, HYPOTHESIS → FALSIFIED, etc.)
   - Add new discoveries with proper status tags
   - Update confidence levels and peer review status
   - **CRITICAL**: Distinguish PROVEN vs NUMERICAL vs HYPOTHESIS

2. **docs/index.md** - Auto-generated document index
   - Regenerate when adding major new documents
   - Keep sorted by date

3. **README.md** - Repository overview
   - Update "Current Status" section with latest discoveries
   - Keep confidence levels synchronized with STATUS.md
   - Update timeline when major events occur

4. **docs/functional-equation-discovery.md** - FR exploration
   - Add new test results (positive or negative!)
   - Document failed approaches to avoid repetition
   - Update open questions list

### Documentation Standards

**IMPORTANT: Avoid Documentation Bloat**
- **DON'T create multiple overlapping documents** - this makes navigation harder
- **DON'T repeat information** across multiple files
- **DO update existing documents** rather than creating new ones
- **DO check for duplicates** before creating new docs
- **Principle**: One topic = One primary document (+ STATUS.md update)

**When making mathematical discoveries:**
1. Create script in `scripts/` with descriptive name
2. **Update existing** `docs/` file if topic exists, OR create ONE new document
3. **Always update** `docs/STATUS.md` with appropriate epistemic tag
4. Add entry to `misc/` for "aha moments" (user's responsibility)
5. Commit with descriptive message mentioning discovery status

**Document hierarchy** (avoid creating files outside this structure):
- `STATUS.md` = master tracker (always update!)
- `functional-equation-discovery.md` = ongoing FR work (append here!)
- New docs only if fundamentally new topic

**Epistemic Tags (from STATUS.md):**
- ✅ PROVEN - Rigorous proof (but note: NOT peer-reviewed)
- 🔬 NUMERICALLY VERIFIED - High computational confidence
- 🤔 HYPOTHESIS - Conjecture needing verification
- ❌ FALSIFIED - Tested and found false
- ⏸️ OPEN QUESTION - Unknown, under investigation

**Commit Message Format:**
```
type: brief description

Details:
- Change 1
- Change 2

Status: [NUMERICAL/PROVEN/HYPOTHESIS/FALSIFIED]
Reference: docs/STATUS.md

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

### Cross-Session Context

**Mathematical Objects:**
- M(n) = count of divisors d where 2 ≤ d ≤ √n
- L_M(s) = Σ M(n)/n^s (non-multiplicative Dirichlet series)
- Closed form: L_M(s) = ζ(s)[ζ(s)-1] - Σ_{j=2}^∞ H_{j-1}(s)/j^s
- H_j(s) = Σ_{k=1}^j k^(-s) (partial zeta sums)

**Key Discoveries:**
1. Nov 15, 2025, 22:49: Closed form for L_M(s) (NUMERICAL, not proven)
2. Nov 16, 2025, 00:35: Schwarz symmetry on critical line (NUMERICAL)
3. Nov 16, 2025, 01:15: Classical FR FALSIFIED (γ(s) = π^(-s/2) Γ(s/2) doesn't work)

**Falsified Approaches (don't retry without new insight):**
- Euler product for L_M(s) (fails due to non-multiplicativity)
- Classical gamma factor γ(s) = π^(-s/2) Γ(s/2)
- Powers of classical gamma: α ∈ {0.5, 1, 1.5, 2, 2.5, 3}

**Open Questions:**
1. Does FR exist with non-classical γ(s)?
2. Does L_M(s₀) = 0 at Riemann zeros?
3. Geometric interpretation via primal forest?

### File Organization Conventions

- `docs/papers/*.tex` - Formal LaTeX papers (publication track)
- `docs/*.md` - Working documents, explorations
- `docs/STATUS.md` - Master status tracker (**ALWAYS UPDATE**)
- `scripts/*.wl` - Wolfram Language exploration scripts
- `misc/*.txt` - Aha moments (user creates, not AI)

### Boundary Reminders

- **DON'T push** unless explicitly asked (user does it)
- **DON'T write** to misc/ for aha moments (user's domain)
- **DO update** STATUS.md when making claims
- **DO mark** numerical results as "NOT proven"
- **DO commit** technical documentation and scripts

---

## Technical Notes

**WolframScript Execution**: Always run WolframScript with the `-file` flag to execute scripts non-interactively:
```bash
wolframscript -file script.wl  # Correct
wolframscript script.wl        # May hang in interactive mode
```

**LaTeX Compilation**: Always run pdflatex **twice** to resolve cross-references:
```bash
pdflatex -interaction=nonstopmode document.tex  # First pass
pdflatex -interaction=nonstopmode document.tex  # Second pass (resolves references)
```

## Repository Structure

### Orbit Paclet (Version 0.3.0)

The paclet is organized into modular subpackages for different mathematical topics:

```
Orbit/
  ├── PacletInfo.wl          # Paclet metadata
  └── Kernel/
      ├── Orbit.wl                       # Main loader (imports all submodules)
      ├── PrimeOrbits.wl                 # Prime DAG and orbit analysis
      ├── Primorials.wl                  # Primorial computation via rational sums
      ├── SemiprimeFactorization.wl      # Closed-form semiprime factorization
      ├── ModularFactorials.wl           # Efficient factorial mod p computation
      └── SquareRootRationalizations.wl  # Ultra-high precision sqrt via Chebyshev/Pell
```

### Loading the Paclet

```mathematica
<< Orbit`
```

This automatically loads all submodules. Functions from all modules are available in the `Orbit`  context.

## Current Modules

### 1. Prime Orbits & DAG Analysis

Tools for exploring prime structure through greedy additive decomposition and directed acyclic graphs.

**See below for detailed documentation on this module.**

### 2. Primorial Computation

Computes primorials (products of consecutive primes) using a surprising rational sum formula.

**See:** `docs/primorial-formula.md` for detailed documentation.

**Quick example:**
```mathematica
(* Primorial of all primes up to 13 *)
Primorial0[13]  (* Returns: 30030 = 2*3*5*7*11*13 *)
```

### 3. Semiprime Factorization

Closed-form factorization of semiprimes (products of two primes) using fractional parts of Pochhammer sums. Works for all semiprimes where the smaller factor p ≥ 3.

**See:** `docs/semiprime-factorization.md` for detailed documentation.

**Quick example:**
```mathematica
(* Factor 77 = 7 × 11 *)
FactorizeSemiprime[77]  (* Returns: {7, 11} *)

(* The formula extracts the smaller factor from fractional parts *)
ForFactiMod[77]  (* Returns: 6/7 = (7-1)/7 *)
```

### 4. Modular Factorials

Efficient computation of n! mod p using the predictable structure of ((p-1)/2)! mod p. The half-factorial equals ±1 for p ≡ 3 (mod 4), or ±√(-1) for p ≡ 1 (mod 4), connected to Gauss sums and the Stickelberger relation.

**See:** `docs/modular-factorials.md` for detailed documentation.

**Quick example:**
```mathematica
(* Compute 10! mod 13 efficiently *)
FactorialMod[10, 13]  (* Returns: 6 *)

(* Find sqrt(-1) mod p for p ≡ 1 (mod 4) *)
SqrtMod[13]  (* Returns: {True, {5, 8}} *)

(* Half-factorial base value *)
HalfFactorialMod[13]  (* Returns: 5 (which is 6! mod 13) *)
```

### 5. Square Root Rationalizations

Ultra-high precision rational approximations to square roots using Chebyshev polynomials and Pell equation solutions. The nested Chebyshev method achieves extreme precision far exceeding continued fractions in speed.

**See:** `docs/chebyshev-pell-sqrt-framework.md` for detailed documentation.

**Quick examples:**
```mathematica
(* Ultra-high precision with nested Chebyshev - THE POWER METHOD *)
NestedChebyshevSqrt[13, {3, 3}]  (* ~3000 digits in 0.01s *)
NestedChebyshevSqrt[13, {1, 10}] (* ~62 MILLION digits! *)

(* Egyptian fraction approach - moderate precision *)
SqrtRationalization[13, Accuracy -> 20]

(* Pell equation solver *)
PellSolution[13]  (* Returns: {x -> 649, y -> 180} *)
```

**Key achievements:**
- **62 million digit** sqrt(13) demonstration (m1=1, m2=10)
- Faster than Wolfram's Rationalize at high precision
- 2x denominator overhead vs optimal CF convergents
- Fully rational - no floating point arithmetic

---

# Prime DAG Computational Exploration Guide

This section provides guidance for exploring the prime index DAG structure systematically.

## Core Implementation

### Essential Functions

```mathematica
(* Greedy prime decomposition *)
PrimeRepSparse[n_Integer] := Module[{r = n, primes = {}, p},
  While[r >= 2,
    p = Prime[PrimePi[r]];
    AppendTo[primes, p];
    r -= p
  ];
  Append[primes, r]
]

(* Prime orbit - all primes in recursive decomposition *)
PrimeOrbit[n_Integer] := Module[{orbit = {}, queue = {n}, current, rep, primes},
  While[queue != {},
    current = First[queue];
    queue = Rest[queue];
    If[current > 1 && !MemberQ[orbit, current],
      rep = PrimeRepSparse[current];
      primes = Select[Most[rep], # > 1 &];
      orbit = Union[orbit, Select[primes, PrimeQ]];
      queue = Join[queue, PrimePi /@ Select[primes, PrimeQ]];
    ];
  ];
  Sort[orbit]
]

(* Build prime DAG with direct edges only *)
DirectPrimeDag[pmax_Integer] := Module[{primes, edges},
  primes = Select[Range[2, pmax], PrimeQ];
  edges = Flatten[Table[
    Select[Most[PrimeRepSparse[PrimePi[p]]], PrimeQ] /. q_ :> (p -> q),
    {p, primes}
  ]];
  Graph[DeleteDuplicates[edges], VertexLabels -> "Name",
    GraphLayout -> "LayeredDigraphEmbedding"]
]
```

## Research Questions for Computational Exploration

### 1. Gap Theorem Verification

**Question:** Does the Gap Theorem hold universally?

```mathematica
(* Verify gap theorem for range of primes *)
VerifyGapTheorem[pmax_Integer] := Module[{primes, results},
  primes = Select[Range[2, pmax], PrimeQ];
  results = Table[
    Module[{p, gap, count},
      p = PrimePi[prime];
      gap = NextPrime[prime] - prime;
      count = Length[Select[Range[p, p + gap - 1], 
        MemberQ[PrimeOrbit[#], prime] &]];
      {prime, gap, count, gap == count}
    ],
    {prime, primes}
  ];
  Select[results, !Last[#] &] (* Return violations if any *)
]

(* Usage: VerifyGapTheorem[10000] should return {} *)
```

### 2. Orbit Length Distributions

**Question:** What is the typical orbit length distribution across gap-children?

```mathematica
(* Analyze orbit lengths for a gap prime *)
AnalyzeGapOrbits[p_Integer] := Module[{gap, lengths, data},
  gap = NextPrime[p] - p;
  lengths = Table[Length[PrimeOrbit[p + k]], {k, 0, gap - 1}];
  data = {
    "Gap" -> gap,
    "Min length" -> Min[lengths],
    "Max length" -> Max[lengths],
    "Mean length" -> N[Mean[lengths]],
    "Std dev" -> N[StandardDeviation[lengths]],
    "Unique lengths" -> Length[DeleteDuplicates[lengths]],
    "Step count" -> Length[DeleteDuplicates[Differences[lengths]]],
    "Distribution" -> Tally[lengths]
  };
  Association[data]
]

(* Batch analysis *)
BatchGapAnalysis[primes_List] := 
  Association[# -> AnalyzeGapOrbits[#] & /@ primes]

(* Usage: BatchGapAnalysis[{89, 113, 523, 1327, 31397}] *)
```

### 3. Partial Order Structure

**Question:** What fraction of gap-children form incomparable pairs?

```mathematica
(* Count incomparable pairs in poset *)
CountIncomparablePairs[p_Integer, gap_Integer] := Module[{orbits, pairs},
  orbits = Table[PrimeOrbit[p + k], {k, 0, gap - 1}];
  pairs = Subsets[Range[gap], {2}];
  Count[pairs, {i_, j_} /; 
    !SubsetQ[orbits[[i]], orbits[[j]]] && 
    !SubsetQ[orbits[[j]], orbits[[i]]]]
]

(* Poset statistics *)
PosetStatistics[p_Integer] := Module[{gap, incomp, total},
  gap = NextPrime[p] - p;
  incomp = CountIncomparablePairs[p, gap];
  total = Binomial[gap, 2];
  {
    "Prime" -> p,
    "Gap" -> gap,
    "Total pairs" -> total,
    "Incomparable" -> incomp,
    "Incomparable %" -> N[100 * incomp / total]
  }
]
```

### 4. Hub Identification

**Question:** Which primes are major hubs (high in-degree)?

```mathematica
(* Compute in-degrees for all primes *)
ComputeInDegrees[pmax_Integer] := Module[{dag, degrees},
  dag = DirectPrimeDag[pmax];
  degrees = Thread[VertexList[dag] -> VertexInDegree[dag]];
  Reverse @ SortBy[degrees, Last]
]

(* Find primes with in-degree > threshold *)
FindHubs[pmax_Integer, minDegree_Integer : 10] := 
  Select[ComputeInDegrees[pmax], Last[#] >= minDegree &]

(* Correlation with gaps *)
HubGapCorrelation[pmax_Integer] := Module[{hubs, data},
  hubs = FindHubs[pmax, 10];
  data = Table[
    {p, Last[#], NextPrime[p] - p} & /@ Select[hubs, First[#] == p &],
    {p, First /@ hubs}
  ];
  ListPlot[Flatten[data, 1][[All, {2, 3}]], 
    AxesLabel -> {"In-degree", "Gap"},
    PlotLabel -> "Hub In-degree vs. Prime Gap"]
]
```

### 5. Jump Point Analysis

**Question:** What arithmetic properties characterize indices where orbit length jumps?

```mathematica
(* Analyze all jumps in a gap *)
AnalyzeJumps[p_Integer] := Module[{g, lengths, jumps, data},
  g = NextPrime[p] - p;
  lengths = Table[Length[PrimeOrbit[p + k]], {k, 0, g - 1}];
  jumps = Position[Differences[lengths], Except[0]] // Flatten;
  
  data = Table[{
    "k" -> k,
    "Index" -> p + k,
    "Factorization" -> FactorInteger[p + k],
    "Omega" -> PrimeOmega[p + k],
    "Omega_0" -> PrimeNu[p + k],
    "Length before" -> lengths[[k]],
    "Length after" -> lengths[[k + 1]],
    "Jump size" -> lengths[[k + 1]] - lengths[[k]],
    "Offset k factorization" -> If[k > 0, FactorInteger[k], {}],
    "Offset k is prime?" -> PrimeQ[k]
  }, {k, jumps}];
  
  Dataset[data]
]

(* Statistical summary across multiple gaps *)
JumpStatistics[primes_List] := Module[{allJumps},
  allJumps = Flatten[AnalyzeJumps /@ primes, 1];
  {
    "Total jumps analyzed" -> Length[allJumps],
    "Jumps where k is prime" -> Count[allJumps, _?(#["Offset k is prime?"] &)],
    "Mean omega" -> N[Mean[#["Omega"] & /@ allJumps]],
    "Mean jump size" -> N[Mean[#["Jump size"] & /@ allJumps]]
  }
]
```

### 6. Visualization Suite

```mathematica
(* Plot orbit lengths for a gap *)
PlotOrbitLengths[p_Integer] := Module[{g, data},
  g = NextPrime[p] - p;
  data = Table[{k, Length[PrimeOrbit[p + k]]}, {k, 0, g - 1}];
  ListPlot[data,
    PlotLabel -> Row[{"Orbit lengths for gap after prime ", p, " (gap = ", g, ")"}],
    AxesLabel -> {"k", "Orbit length"},
    PlotMarkers -> Automatic,
    Joined -> True,
    GridLines -> Automatic
  ]
]

(* Community structure visualization *)
VisualizeCommunities[pmax_Integer] := Module[{dag, communities},
  dag = DirectPrimeDag[pmax];
  communities = FindGraphCommunities[dag];
  HighlightGraph[dag, communities,
    GraphLayout -> "SpringElectricalEmbedding"]
]

(* Distance distribution *)
DistanceDistribution[pmax_Integer] := Module[{dag, primes, distances},
  dag = DirectPrimeDag[pmax];
  primes = Select[Range[2, pmax], PrimeQ];
  distances = Table[
    GraphDistance[dag, p, 2, Method -> "Dijkstra"],
    {p, primes}
  ];
  Histogram[DeleteCases[distances, ∞],
    PlotLabel -> "Distribution of distances to attractor 2",
    AxesLabel -> {"Distance", "Count"}]
]
```

## Systematic Exploration Protocol

### Phase 1: Verification (Primes up to 10,000)
1. Verify Gap Theorem holds for all primes
2. Compute orbit sizes and distributions
3. Build complete DAG and analyze properties

### Phase 2: Pattern Discovery (Primes up to 100,000)
1. Identify all hub primes (in-degree ≥ 10)
2. Analyze jump patterns across 100+ gaps
3. Measure poset incomparability statistics
4. Correlate orbit properties with classical invariants

### Phase 3: Large-Scale Analysis (Primes up to 1,000,000)
1. Distribution of orbit lengths
2. Hub-gap correlation at scale
3. Community structure evolution
4. Statistical properties of jumps

### Phase 4: Hypothesis Testing
Based on patterns from Phases 1-3, formulate and test:
- Predictive models for orbit length
- Jump location heuristics
- Hub characterization criteria
- Connections to classical number theory

## Performance Considerations

For large computations:
- Cache `PrimeOrbit` results (memoization)
- Use parallel processing where applicable
- Store intermediate results
- Focus on specific prime ranges

```mathematica
(* Memoized version *)
PrimeOrbitMemo = Function[n, PrimeOrbit[n], Listable];
PrimeOrbitMemo = Function[Null, 
  If[!ValueQ[cache[#]], cache[#] = PrimeOrbit[#]]; cache[#]
];
```

## Expected Outputs

For each computational session, generate:
1. Data tables (CSV format for further analysis)
2. Visualizations (PNG/PDF for documentation)
3. Summary statistics (markdown or JSON)
4. Anomalies or counterexamples (if any)

## Open Questions for Exploration

1. Is the partial order on gap-children always a lattice? Tree? General poset?
2. What is the growth rate of maximum orbit length as function of p?
3. Can we characterize primes by their "orbit signature"?
4. Does the step function pattern have universal features across all gaps?
5. Are there primes whose gap-children have trivial poset (total order)?
6. What is the distribution of community sizes in the DAG?
7. How does average path length to attractors grow with prime size?

## Integration with Main Research

Results from computational exploration should feed back to:
- Update `prime-dag-gap-theorem.md` with new theorems
- Refine conjectures based on empirical patterns
- Identify edge cases requiring theoretical analysis
- Generate visualizations for intuition building

---

**Target:** Claude Code or similar computational assistant with WolframScript
**Goal:** Systematic exploration of prime DAG structure through computational experiments
**Approach:** Question-driven, with emphasis on pattern discovery and statistical analysis

## LaTeX and Mathematical Writing Style Preferences

When writing LaTeX documents or mathematical papers for this project, follow these guidelines:

### Clean, Rigorous Mathematical Exposition

- **Pure mathematics**: Write proofs as self-contained mathematical arguments
- **No computational exploration details**: Omit references to verification scripts, test cases, data files, or computational discovery process
- **No numerical evidence**: Remove statements like "tested for 1000 cases", "zero counterexamples found", etc.
- **No tool mentions**: Exclude references to Wolfram Language, WolframScript, implementation details
- **No data tables from experiments**: Keep only theoretical results and definitions

### Structure

- **Derive from first principles**: Prove all recurrence relations, update formulas, etc. from the original definitions
- **No circular reasoning**: Don't assume what you're trying to prove; build up from axioms and definitions
- **Clean lemma structure**: State key inequalities and subresults as formal lemmas with complete proofs
- **Proper theorem environments**: Use `\begin{theorem}`, `\begin{lemma}`, `\begin{proof}` consistently

### Example

**Avoid:**
```latex
We verified computationally for 769 jumps across 4 primes...
Table 1 shows that 99.5% of cases follow Pattern 2a...
Using our Wolfram Language script, we found...
```

**Prefer:**
```latex
\begin{lemma}
For all primes $p \geq 3$ and integers $k \geq 1$...
\end{lemma}

\begin{proof}
By Legendre's formula, we have...
\end{proof}
```

### When to Break These Rules

These guidelines apply to **formal mathematical papers** intended for publication or rigorous presentation. For:
- Exploratory markdown documents (e.g., `docs/*-exploration.md`)
- Computational notebooks
- Internal research notes
- README files

...it's appropriate to include computational details, verification results, and implementation references.

### Reference Example

See `docs/primorial-proof-clean.tex` for the preferred style: rigorous, self-contained, no computational baggage.
- always regenrate index.md before commiting using make generate-index