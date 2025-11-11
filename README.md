# Orbit: Prime DAG Computational Explorer

Computational tools for exploring the prime index DAG structure via greedy additive decomposition.

**Gap Theorem:** The gap after prime $p$ equals the number of primes with $p$ as immediate predecessor when recursively applying unique greedy decomposition to prime indices $\pi(q)$.

## The Gap Theorem

### Definitions

**1. Greedy Prime Decomposition (Sparse Representation)**

For any natural number $n \geq 2$, define $\text{Sparse}(n)$ as the sequence obtained by the greedy algorithm:

```
r ← n, result ← []
while r ≥ 2:
    p ← largest prime ≤ r
    append p to result
    r ← r - p
append r to result  (where r ∈ {0, 1})
```

**Properties:**

- **Unique:** The greedy choice is deterministic, yielding a unique decomposition for each $n$
- **Well-defined:** Always terminates with remainder $r \in \{0, 1\}$

**Example:** $\text{Sparse}(100) = [97, 3, 0]$

**2. Prime Index Function**

Let $\pi : \mathbb{P} \to \mathbb{N}$ denote the prime index function:

$$\pi(2) = 1, \quad \pi(3) = 2, \quad \pi(5) = 3, \quad \pi(7) = 4, \quad \ldots$$

Conversely, let $\text{Prime}(i)$ denote the $i$-th prime.

**3. Immediate Predecessor**

Prime $p$ is the **immediate predecessor** of prime $q$ if $p$ is the largest prime not exceeding $\pi(q)$:

$$p = \max\{r \in \mathbb{P} : r \leq \pi(q)\}$$

Equivalently, $p$ is the first prime in $\text{Sparse}(\pi(q))$.

**Example:** For prime $q = 11$:

- $\pi(11) = 5$
- Largest prime $\leq 5$ is $5$
- Therefore, the immediate predecessor of $11$ is $5$

**4. Prime Orbit (for DAG exploration)**

For any natural number $n$, define $\text{Orbit}(n)$ as the set of all primes encountered when recursively applying:

1. Compute $\text{Sparse}(n)$
2. For each prime $p$ in $\text{Sparse}(n)$, recursively compute $\text{Orbit}(\pi(p))$

Formally, $\text{Orbit}(n)$ is the smallest set satisfying:

- For each prime $p \in \text{Sparse}(n)$: $p \in \text{Orbit}(n)$
- For each prime $p \in \text{Sparse}(n)$: $\text{Orbit}(\pi(p)) \subseteq \text{Orbit}(n)$

**Example:** For prime $q = 11$:

- $\pi(11) = 5$
- $\text{Sparse}(5) = [5, 0]$, so $5 \in \text{Orbit}(11)$
- $\pi(5) = 3$
- $\text{Sparse}(3) = [3, 0]$, so $3 \in \text{Orbit}(11)$
- $\pi(3) = 2$
- $\text{Sparse}(2) = [2, 0]$, so $2 \in \text{Orbit}(11)$
- Therefore: $\text{Orbit}(11) = \{2, 3, 5, 11\}$ (sorted)

The immediate predecessor of $11$ is $5$ (the second-to-last element).

**Note:** Orbits are not unique — different numbers may have the same orbit. Only sparse representations are unique.

### Gap Theorem Statement

**Theorem:** Let $p$ be a prime and let $g = \text{NextPrime}(p) - p$ be the gap after $p$.

Define:

$$S_p = \{ q \in \mathbb{P} : p \text{ is the immediate predecessor of } q \}$$

Then:

$$|S_p| = g$$

**In words:** Exactly $g$ primes have $p$ as their immediate predecessor.

### Proof Sketch

Prime $q$ has $p$ as immediate predecessor if and only if $p$ is the largest prime $\leq \pi(q)$.

This occurs if and only if:

$$p \leq \pi(q) < \text{NextPrime}(p) = p + g$$

The primes $q$ satisfying $\pi(q) \in [p, p+g)$ are:

$$\{\text{Prime}(p), \text{Prime}(p+1), \ldots, \text{Prime}(p+g-1)\}$$

which is a set of exactly $g$ primes. □

See [docs/prime-dag-gap-theorem.md](docs/prime-dag-gap-theorem.md) for the complete proof.

### Computational Verification

The theorem has been verified for all 78,498 primes up to 1,000,000 with zero violations.

The verification checks that for each prime $p$:

```wolfram
gap = NextPrime[p] - p
orbits = PrimeOrbit /@ Prime[Range[p, p + gap]]
count = Length @ Select[orbits, Length[#] >= 2 && #[[Length[#]-1]] == p &]
gap == count  (* Always True *)
```

### Implications

**Prime gaps encode structural centrality:**

- Large gap after $p$ → many primes have $p$ as immediate predecessor → structural hub
- Small gap → minimal influence → local density in prime sequence

**Notable hub primes:**

- Prime 113 (next prime: 127)
  - Gap: 14
  - Fourteen primes have 113 as immediate predecessor

- Prime 523 (next prime: 541)
  - Gap: 18
  - Eighteen primes have 523 as immediate predecessor

- Prime 1327 (next prime: 1361)
  - Gap: 34
  - Thirty-four primes have 1327 as immediate predecessor

**Connection to classical theory:**

The Gap Theorem provides a graph-theoretic interpretation of prime gaps. See [docs/connections-to-classical-theory.md](docs/connections-to-classical-theory.md) for connections to:

- Cramér's conjecture on maximal gaps
- Average gap ~ $\ln(p)$ from the Prime Number Theorem
- Twin primes and bounded gaps

## Documentation

- **[docs/prime-dag-gap-theorem.md](docs/prime-dag-gap-theorem.md)** — Complete mathematical framework with detailed proof
- **[docs/connections-to-classical-theory.md](docs/connections-to-classical-theory.md)** — Relationship to classical prime gap theory
- **[CLAUDE.md](CLAUDE.md)** — Computational exploration guide for AI assistants

## Repository Structure

```
orbit/
├── Orbit/                 # Local paclet with core functions
│   ├── PacletInfo.wl      # Paclet metadata
│   └── Kernel/
│       └── Orbit.wl       # Core functions (PrimeOrbit, DirectPrimeDag, etc.)
├── scripts/               # Exploration scripts (.wl files)
│   ├── verify_gap_theorem.wl
│   ├── analyze_hubs.wl
│   └── explore_gap.wl
├── reports/               # Generated markdown reports (gitignored)
└── docs/                  # Mathematical documentation
```

## Prerequisites

**WolframScript** 1.13.0+ (or any Wolfram Language environment)

```bash
wolframscript --version
```

## Usage Workflow

### 1. Explore with Scripts

Run exploration scripts from the repository root:

```bash
cd /path/to/orbit
wolframscript scripts/verify_gap_theorem.wl
```

Scripts automatically:

- Load the local `Orbit` paclet
- Run computational analyses
- Export markdown reports to `reports/`
- Generate visualizations (PNG/PDF)

### 2. Available Scripts

**`verify_gap_theorem.wl`** — Verify the Gap Theorem for primes up to a specified limit

**`analyze_hubs.wl`** — Identify primes with high in-degree (hubs) and analyze their properties

**`explore_gap.wl`** — Deep dive into a specific prime's gap structure with visualizations

### 3. Create Custom Scripts

Create new `.wl` scripts in `scripts/` that import the Orbit paclet:

```wolfram
#!/usr/bin/env wolframscript

(* Load local Orbit paclet *)
SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

(* Your exploration code *)
primes = Select[Range[2, 100], PrimeQ];
orbits = PrimeOrbit /@ primes;

(* Export results *)
Export["reports/my_analysis.md", "# My Analysis\n\n...", "Text"];
```

### 4. Promote Functions to Paclet

When a function proves valuable, add it to `Orbit/Kernel/Orbit.wl` and increment the version in `Orbit/PacletInfo.wl`.

## Core Functions (Orbit Paclet)

### Basic Functions

- **`PrimeRepSparse[n]`** — Greedy prime decomposition of $n$
- **`PrimeOrbit[n]`** — All primes in recursive decomposition of $n$
- **`DirectPrimeDag[pmax]`** — Build prime DAG for primes up to $p_{\text{max}}$

### Analysis Functions

- **`VerifyGapTheorem[pmax]`** — Verify Gap Theorem for all primes up to $p_{\text{max}}$
- **`AnalyzeGapOrbits[p]`** — Analyze orbit lengths for gap-children after prime $p$
- **`PosetStatistics[p]`** — Partial order statistics for gap-children
- **`AnalyzeJumps[p]`** — Identify and analyze jump points in orbit lengths

### Graph Functions

- **`ComputeInDegrees[pmax]`** — Compute in-degrees for all primes in DAG
- **`FindHubs[pmax, minDegree]`** — Find primes with in-degree $\geq$ minDegree

### Visualization

- **`PlotOrbitLengths[p]`** — Plot orbit lengths for gap after prime $p$

## System-Wide Installation (Optional)

To install the Orbit paclet system-wide:

```bash
cd orbit/
wolframscript -code 'PacletInstall["Orbit"]'
```

Then use in any notebook or script:

```wolfram
Needs["Orbit`"];
PrimeOrbit[100]
```

To uninstall:

```bash
wolframscript -code 'PacletUninstall["Orbit"]'
```

## Related Work

This project is part of a series exploring alternative number representations:

- **Ratio** — Egyptian fractions and rationalization techniques
- **Orbit** — Prime orbits and the prime index DAG

## Status

**Version:** 0.1.0

**Gap Theorem:** Proven and computationally verified for all primes up to 1,000,000

## License

Research exploration project. Code provided as-is for computational number theory experiments.
