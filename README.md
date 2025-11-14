# Orbit: Computational Mathematical Explorations

A Wolfram Language paclet for recreational and research mathematical explorations, featuring computational number theory modules and educational visualizations.

**Highlights:**
- 🌲 **Primal Forest** — Educational paper revealing primes through geometric visualization, with unexpected continuous primality score
- 🔢 **Primorial Formula** — Computing primorials via alternating factorial sums (open research problem)
- 🎯 **Four Computational Modules** — Semiprime factorization, modular factorials, square root rationalization, primorials

## Contents

### Educational Paper: The Primal Forest

**`docs/papers/primal-forest-paper.tex`** — A complete educational paper transforming the Sieve of Eratosthenes into an intuitive geometric visualization.

**The Core Idea:** Map composite numbers $n = p(p+k)$ to 2D coordinates $(kp+p^2, kp+1)$. Primes appear as **gaps in the forest** — positions with no dots above them.

**The Unexpected Revelation (Appendix):** By computing soft-distance products from integers to the factorization lattice, we discover that:
- **Primes form a smooth upper envelope**
- **Composites stratify by factorization complexity** — prime powers near the top, highly composite numbers at the bottom
- **Factorization structure becomes continuous** — a "primality score" that measures how close any integer is to being prime

This continuous primality spectrum emerges naturally from the geometric view, revealing structure invisible in the classical 1D sieve.

**Visualizations:** See `visualizations/` for primal forest plots and soft-distance envelope diagrams.

**Educational Value:**
- Makes prime gaps visually intuitive
- Connects factorization to geometry
- Reveals the "regularity paradox" — simple patterns creating irreducible complexity

---

## Computational Modules (Version 0.5.0)

### 1. Primorial Computation ⭐ (Most Recent)

**Computes primorials via alternating rational sums** — a surprising formula with deep unexplained structure:

$$\text{Primorial}(m) = \text{Denominator}\left[\frac{1}{2} \sum_{k=1}^{\lfloor(m-1)/2\rfloor} \frac{(-1)^k \cdot k!}{2k+1}\right]$$

**Example:** For $m = 13$:
$$\text{Primorial}(13) = 2 \times 3 \times 5 \times 7 \times 11 \times 13 = 30030$$

The denominator systematically accumulates **only first powers** of primes, despite the sum containing terms with denominators $3, 5, 7, 9, 11, 13, 15, \ldots$ (including prime powers like $9 = 3^2$).

**The Mystery:** Why do numerators cancel all higher prime powers through GCD reduction? This is an **open problem** with connections to p-adic valuations, Legendre's formula, and primorial structure.

**See:** `docs/primorial-formula.md` and `docs/primorial-mystery-findings.md`

**Quick start:**
```mathematica
<< Orbit`
Primorial0[13]  (* Returns: 30030 = 2×3×5×7×11×13 *)
```

### 2. Semiprime Factorization

**Closed-form factorization of semiprimes** using fractional parts of Pochhammer sums:

$$p = \left\lfloor \frac{1}{\text{FractionalPart}\left[\sum_{k=1}^{n-1} \frac{1}{k}\right]} \right\rfloor + 1$$

where $n$ is the semiprime. Works for all semiprimes $n = p \times q$ where $p \geq 3$ is the smaller factor.

**Example:**
```mathematica
FactorizeSemiprime[77]  (* Returns: {7, 11} *)
ForFactiMod[77]         (* Returns: 6/7, revealing factor (7-1)/7 *)
```

**See:** `docs/semiprime-factorization.md`

### 3. Modular Factorials

**Efficient factorial mod p computation** using the predictable structure of half-factorials:

$$\left(\frac{p-1}{2}\right)! \equiv \begin{cases}
\pm 1 \pmod{p} & \text{if } p \equiv 3 \pmod{4} \\
\pm i \pmod{p} & \text{if } p \equiv 1 \pmod{4}
\end{cases}$$

Connected to Gauss sums and the Stickelberger relation.

**Example:**
```mathematica
FactorialMod[10, 13]   (* Returns: 6 *)
SqrtMod[13]            (* Returns: {True, {5, 8}} — sqrt(-1) mod 13 *)
HalfFactorialMod[13]   (* Returns: 5 (which is 6! mod 13) *)
```

**See:** `docs/modular-factorials.md`

### 4. Square Root Rationalization ⭐ (Performance Breakthrough)

**High-precision rational approximations to square roots** via Chebyshev polynomials and Pell equations:

$$\text{sqrttrf}(d, n, m) = \frac{n^2 + d}{2n} + \frac{n^2 - d}{2n} \cdot \frac{U_{m-1}\left(\sqrt{\frac{d}{-(n^2-d)}}\right)}{U_{m+1}\left(\sqrt{\frac{d}{-(n^2-d)}}\right)}$$

**Performance:** Beats Mathematica's Rationalize by **1548x** at 31,000 digits, **>1400x** at 311,000 digits.

**Key properties:**
- Super-quadratic convergence: ~10x precision per iteration
- Guaranteed lower bound (monotone increasing from below)
- Pell solution characterization: Chebyshev terms always rational, but dividing by y (from unit norm) requires Pell solution for rational result

**Example:**
```mathematica
(* High-precision √13 to 3000+ digits in 3 iterations *)
{x, y} = PellSolution[13];
nestqrt[13, (x-1)/y, {3, 3}]  (* 3111 decimal places in 0.011s *)
```

**See:** `docs/chebyshev-pell-sqrt-framework.md`


## Visualizations

### 1. Primal Forest: Geometric Prime Sieve

**Educational visualization** showing composites as dots in 2D space, primes as gaps.

**Key files:**
- `visualizations/primal-forest-31.pdf` — The forest view (composites form regular patterns)
- `visualizations/soft-distance-envelope-127.pdf` — Continuous primality spectrum
- `visualizations/soft-distance-composite-types.pdf` — Stratification by factorization structure
- `visualizations/prime-grid-demo.wl` — Code to generate the visualization

**See:** `docs/papers/primal-forest-paper.tex` for complete educational exposition

### 2. Chebyshev Curves: "Infinite Interference"

**Beautiful family of curves** inscribed in the unit circle, each touching at regular polygon vertices:

$$f_k(x) = T_{k+1}(x) - x \cdot T_k(x)$$

- Contact points at angles: $\theta_i = -\frac{\pi}{2k} + \frac{2\pi}{k+1} \cdot i$
- Unit integral norm: $\int |f_k(\cos\theta)| d\theta = 1$ for all $k$
- Creates n-star patterns with deep polynomial structure

**Key files:**
- `visualizations/regular-235.png` — Static visualization showing k=2,3,5
- `visualizations/infinite_interference.glsl` — Shadertoy GLSL implementation
- **Live demo:** https://www.shadertoy.com/view/MXc3Rj

**See:** `docs/archive/chebyshev-visualization.md` for mathematical details

## Documentation

### Papers (`docs/papers/`)

- **[primal-forest-paper.tex](docs/papers/primal-forest-paper.tex)** — Geometric visualization of the Sieve of Eratosthenes with continuous primality score revelation
- **[primorial-proof-clean.tex](docs/papers/primorial-proof-clean.tex)** — Rigorous proof of primorial formula via alternating factorial sums
- **[primorial-arxiv-draft.tex](docs/papers/primorial-arxiv-draft.tex)** / **[-cs.tex](docs/papers/primorial-arxiv-draft-cs.tex)** — ArXiv submission drafts (English/Czech)
- **[chebyshev-pell-sqrt-paper.tex](docs/papers/chebyshev-pell-sqrt-paper.tex)** — Square root rationalization via Chebyshev polynomials and Pell equations
- **[semiprime-formula-complete-proof.tex](docs/papers/semiprime-formula-complete-proof.tex)** — Closed-form semiprime factorization formula
- **[half-factorial-numerator-theorem.tex](docs/papers/half-factorial-numerator-theorem.tex)** — Structure of half-factorial numerators mod p
- **[factorial-chaos-unification.tex](docs/papers/factorial-chaos-unification.tex)** — Unifying factorial and fractional part approaches
- **[gcd-formula-proof.tex](docs/papers/gcd-formula-proof.tex)** — GCD formula for factorial-based expressions

### Module Documentation (`docs/modules/`)
- **[primorial-formula.md](docs/modules/primorial-formula.md)** — Primorial computation details
- **[chebyshev-pell-sqrt-framework.md](docs/modules/chebyshev-pell-sqrt-framework.md)** — Square root rationalization
- **[semiprime-factorization.md](docs/modules/semiprime-factorization.md)** — Semiprime factorization
- **[modular-factorials.md](docs/modules/modular-factorials.md)** — Modular factorial computation

### Active Research (`docs/active/`)
- **[phd-roadmap.md](docs/active/phd-roadmap.md)** — Publication and PhD application plan
- **[proof-development-plan.md](docs/active/proof-development-plan.md)** — Current proof development strategy
- **[primorial-duality.tex](docs/active/primorial-duality.tex)** — Work-in-progress primorial duality analysis

### For AI Assistants
- **[CLAUDE.md](CLAUDE.md)** — Computational exploration guide, technical notes, and project instructions

### Archive
- **[docs/archive/](docs/archive/)** — Historical session notes, investigation summaries, and deprecated analyses

## Repository Structure

```
orbit/
├── Orbit/                          # Paclet (version 0.5.0)
│   ├── PacletInfo.wl               # Paclet metadata
│   └── Kernel/
│       ├── Orbit.wl                # Main loader (imports all submodules)
│       ├── PrimeOrbits.wl          # Prime DAG and orbit analysis
│       ├── Primorials.wl           # Primorial computation via rational sums
│       ├── SemiprimeFactorization.wl  # Closed-form semiprime factorization
│       ├── ModularFactorials.wl    # Efficient factorial mod p computation
│       └── SquareRootRationalizations.wl  # High-precision sqrt via Chebyshev-Pell
│
├── docs/                           # Documentation and papers
│   ├── papers/                     # LaTeX papers (educational + research)
│   │   ├── primal-forest-paper.tex # Geometric sieve visualization ⭐
│   │   ├── primorial-*.tex         # Primorial formula proofs & drafts
│   │   ├── chebyshev-pell-sqrt-paper.tex
│   │   ├── semiprime-*.tex
│   │   └── *.tex                   # Additional proofs
│   ├── modules/                    # Module documentation (markdown)
│   │   ├── primorial-formula.md
│   │   ├── chebyshev-pell-sqrt-framework.md
│   │   ├── semiprime-factorization.md
│   │   ├── modular-factorials.md
│   │   └── prime-dag-gap-theorem.md
│   ├── active/                     # Active research documents
│   │   ├── phd-roadmap.md
│   │   ├── proof-development-plan.md
│   │   └── primorial-duality.tex
│   └── archive/                    # Historical notes and explorations
│
├── scripts/                        # Computational exploration scripts
│   ├── verify_*.wl                 # Verification scripts
│   ├── test_*.wl                   # Module tests
│   ├── analyze_*.wl                # Analysis tools
│   └── compare_*.wl                # Comparison benchmarks
│
├── visualizations/                 # Visual outputs and generation code
│   ├── primal-forest-*.pdf/png     # Prime sieve visualizations
│   ├── soft-distance-*.pdf/png     # Continuous primality spectrum
│   ├── regular-235.png             # Chebyshev curves
│   ├── infinite_interference.glsl  # Shadertoy GLSL
│   └── *.wl                        # Visualization generators
│
├── reports/                        # Generated analysis reports
├── CLAUDE.md                       # AI assistant instructions
├── README.md                       # This file
└── Makefile                        # Build targets for papers
```

## Prerequisites

**WolframScript** 1.13.0+ (or any Wolfram Language environment)

```bash
wolframscript --version
```

## Quick Start

### Load the Paclet

```mathematica
<< Orbit`
```

This automatically loads all five modules. All functions are in the `Orbit`  context.

### Examples

```mathematica
(* Primorial computation *)
Primorial0[13]                    (* 30030 = 2×3×5×7×11×13 *)
PrimorialExplicitSum[13]          (* Shows the alternating sum *)

(* Semiprime factorization *)
FactorizeSemiprime[77]            (* {7, 11} *)

(* Modular factorials *)
FactorialMod[10, 13]              (* 6 *)

(* Square root rationalization *)
{x, y} = PellSolution[13];
nestqrt[13, (x-1)/y, {3, 3}]      (* 3111 decimal places *)

(* Prime orbits *)
PrimeOrbit[11]                    (* {2, 3, 5, 11} *)
DirectPrimeDag[100]               (* Build DAG *)
```

### Run Exploration Scripts

```bash
cd /path/to/orbit
wolframscript scripts/visualize_sieve_process.wl
wolframscript scripts/track_padic_valuations.wl
```

## Installation (Optional)

To install the Orbit paclet system-wide:

```bash
cd orbit/
wolframscript -code 'PacletInstall["Orbit"]'
```

Then use anywhere:

```mathematica
Needs["Orbit`"];
Primorial0[17]
```

To uninstall:

```bash
wolframscript -code 'PacletUninstall["Orbit"]'
```

## Current Research Focus

**Primorial Formula Investigation** — Understanding why the alternating factorial sum produces primorials:

1. **P-adic valuation structure:** Proven computationally that $\nu_p(\text{denominator}) = 1$ always
2. **Two cancellation mechanisms identified:** GCD reduction (small k) and integer terms (large k)
3. **Alternating sign necessity:** Essential to prevent over-cancellation at $k=4$
4. **Legendre's formula connection:** Explains when terms become integers

**Open Problem:** Rigorous proof of why this construction systematically generates primorials.

**Target:** arXiv preprint, PhD application to Charles University (Prague), contact with Prof. Vít Kala.

## Related Projects

- **egypt** — Egyptian fractions and Pell equation exploration (Rust implementation)
- **ratio** — Rationalization techniques and number representations

## Status

**Version:** 0.5.0

**Modules:**
- ✅ Primorials (active research, open problems)
- ✅ Semiprime Factorization (complete)
- ✅ Modular Factorials (complete)
- ✅ Square Root Rationalization (performance breakthrough, 1548x speedup)
- ✅ Prime Orbits & Gap Theorem (proven and verified)

**Visualizations:**
- ✅ Chebyshev "Infinite Interference" curves (Shadertoy + documentation)

**Publication Status:**
- Primorial formula: Under investigation, preparing for arXiv
- Chebyshev-Pell framework: Performance verified, theoretical analysis ongoing
- Gap Theorem: Verified for primes up to 1,000,000

## License

Research exploration project. Code provided as-is for computational number theory experiments.
