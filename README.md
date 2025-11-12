# Orbit: Computational Mathematical Explorations

A Wolfram Language paclet for recreational and research mathematical explorations, focusing on prime structure, factorial computations, and alternative number representations.

**Headline Discovery:** A novel formula computing primorials (products of consecutive primes) through alternating factorial sums with mysterious cancellation properties.

## Version 0.5.0 — Five Modules + Visualizations

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

### 5. Prime Orbits & DAG Analysis

**Prime structure via greedy additive decomposition** and directed acyclic graphs.

**Gap Theorem:** The gap after prime $p$ equals the number of primes having $p$ as immediate predecessor under recursive greedy decomposition of prime indices.

Verified for all 78,498 primes up to 1,000,000.

**Example:**
```mathematica
PrimeOrbit[11]        (* Returns: {2, 3, 5, 11} *)
DirectPrimeDag[100]   (* Builds DAG for primes up to 100 *)
```

**See:** `docs/prime-dag-gap-theorem.md` and `CLAUDE.md` for detailed exploration guide

## Visualizations

### Chebyshev Curves: "Infinite Interference"

**Beautiful family of curves** inscribed in the unit circle, each touching at regular polygon vertices:

$$f_k(x) = T_{k+1}(x) - x \cdot T_k(x)$$

- Contact points at angles: $\theta_i = -\frac{\pi}{2k} + \frac{2\pi}{k+1} \cdot i$
- Unit integral norm: $\int |f_k(\cos\theta)| d\theta = 1$ for all $k$
- Creates n-star patterns with deep polynomial structure

**Shadertoy demo:** https://www.shadertoy.com/view/MXc3Rj

**See:** `docs/chebyshev-visualization.md` and `visualizations/` directory

## Documentation

### Primorial Formula (Active Research)
- **[docs/primorial-formula.md](docs/primorial-formula.md)** — Formula derivation and verification
- **[docs/primorial-mystery-findings.md](docs/primorial-mystery-findings.md)** — The open cancellation problem
- **[docs/recursive-formulation-analysis.md](docs/recursive-formulation-analysis.md)** — Recursive sieve formulation
- **[docs/phd-roadmap.md](docs/phd-roadmap.md)** — Publication and PhD application plan

### Square Root Rationalization (Performance Breakthrough)
- **[docs/chebyshev-pell-sqrt-framework.md](docs/chebyshev-pell-sqrt-framework.md)** — Complete mathematical framework
- **[docs/chebyshev-visualization.md](docs/chebyshev-visualization.md)** — "Infinite Interference" visualization theory
- **[visualizations/](visualizations/)** — GLSL source, images, and animation scripts

### Other Modules
- **[docs/semiprime-factorization.md](docs/semiprime-factorization.md)** — Semiprime factorization details
- **[docs/modular-factorials.md](docs/modular-factorials.md)** — Modular factorial computation
- **[docs/prime-dag-gap-theorem.md](docs/prime-dag-gap-theorem.md)** — Gap Theorem proof

### For AI Assistants
- **[CLAUDE.md](CLAUDE.md)** — Computational exploration guide and usage instructions

### Session Notes
- **[docs/session-2025-11-12.md](docs/session-2025-11-12.md)** — Comprehensive summary of Nov 12 discoveries

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
├── scripts/                        # Exploration scripts
│   ├── verify_gap_theorem.wl       # Gap theorem verification
│   ├── track_padic_valuations.wl   # P-adic analysis for primorials
│   ├── fair_benchmark.wl           # Sqrt rationalization benchmark
│   ├── visualize_sieve_process.wl  # Recursive sieve visualization
│   └── test_*.wl                   # Various module tests
├── visualizations/                 # Chebyshev curve visualizations
│   ├── README.md                   # Visualization quick reference
│   ├── infinite_interference.glsl  # Shadertoy GLSL source
│   ├── regular-235.png             # Static visualization (k=2,3,5)
│   └── chebyshev_star_animation.wl # Animation generator
├── reports/                        # Generated analysis reports (gitignored)
└── docs/                           # Mathematical documentation
    ├── primorial-formula.md
    ├── primorial-mystery-findings.md
    ├── chebyshev-pell-sqrt-framework.md
    ├── chebyshev-visualization.md
    └── *.md                        # Other module docs
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
