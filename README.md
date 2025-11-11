# Orbit: Prime DAG Computational Explorer

Computational tools for exploring the prime index DAG structure via greedy additive decomposition.

## Overview

This repository explores a novel recursive structure on natural numbers constructed from:
1. **Greedy prime decomposition**: Representing n as a sum of primes (largest first)
2. **Prime index recursion**: Applying the prime index function π recursively
3. **Prime DAG**: Directed acyclic graph showing relationships between primes

Key discovery: **The Gap Theorem** - the number of primes with p in their orbit exactly equals the gap after p.

See [docs/prime-dag-gap-theorem.md](docs/prime-dag-gap-theorem.md) for the mathematical framework.

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
├── docs/                  # Mathematical documentation
└── CLAUDE.md              # Guide for computational assistants
```

## Prerequisites

- **WolframScript** 1.13.0+ (or any Wolfram Language environment)
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

#### `verify_gap_theorem.wl`
Verifies the Gap Theorem for primes up to a specified limit.

**Configuration:**
```wolfram
pmax = 1000;  (* Adjust this value *)
```

**Output:** `reports/gap_theorem_verification.md`

#### `analyze_hubs.wl`
Identifies primes with high in-degree (hubs) and analyzes their properties.

**Configuration:**
```wolfram
pmax = 5000;
minDegree = 10;
```

**Output:** `reports/hub_analysis.md`

#### `explore_gap.wl`
Deep dive into a specific prime's gap structure with visualizations.

**Configuration:**
```wolfram
targetPrime = 113;  (* Change to any prime *)
```

**Output:**
- `reports/gap_113.md`
- `reports/gap_113_plot.png`

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

When a function proves valuable:

1. Add it to `Orbit/Kernel/Orbit.wl`:
   ```wolfram
   (* Add to usage messages section *)
   MyNewFunction::usage = "MyNewFunction[x] does something useful.";

   (* Add to Begin["`Private`"] section *)
   MyNewFunction[x_] := Module[{...},
     (* implementation *)
   ];
   ```

2. Increment version in `Orbit/PacletInfo.wl`:
   ```wolfram
   "Version" -> "0.2.0",
   ```

3. Use in future scripts:
   ```wolfram
   Needs["Orbit`"];
   result = MyNewFunction[42];
   ```

## Core Functions (Orbit Paclet)

### Basic Functions

- **`PrimeRepSparse[n]`** - Greedy prime decomposition of n
- **`PrimeOrbit[n]`** - All primes in recursive decomposition of n
- **`DirectPrimeDag[pmax]`** - Build prime DAG for primes up to pmax

### Analysis Functions

- **`VerifyGapTheorem[pmax]`** - Verify Gap Theorem for all primes up to pmax
- **`AnalyzeGapOrbits[p]`** - Analyze orbit lengths for gap-children after prime p
- **`PosetStatistics[p]`** - Partial order statistics for gap-children
- **`AnalyzeJumps[p]`** - Identify and analyze jump points in orbit lengths

### Graph Functions

- **`ComputeInDegrees[pmax]`** - Compute in-degrees for all primes in DAG
- **`FindHubs[pmax, minDegree]`** - Find primes with in-degree ≥ minDegree

### Visualization

- **`PlotOrbitLengths[p]`** - Plot orbit lengths for gap after prime p

## System-Wide Installation (Optional)

To install the Orbit paclet system-wide:

```bash
cd orbit/
wolframscript -code 'PacletInstall["Orbit", "Local" -> True]'
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

## Examples

### Quick Verification

```wolfram
Needs["Orbit`"];

(* Verify gap theorem for small primes *)
VerifyGapTheorem[100]
(* => {} (no violations) *)

(* Analyze prime 89 *)
AnalyzeGapOrbits[89]
(* => <|Gap -> 8, Min length -> 5, Max length -> 6, ...|> *)
```

### Hub Discovery

```wolfram
(* Find major hubs up to prime 10000 *)
hubs = FindHubs[10000, 15];
(* => {{113, 14}, {523, 18}, {1327, 34}, ...} *)

(* Visualize hub structure *)
PlotOrbitLengths[113]
```

### Custom Exploration

```wolfram
(* Compare orbit sizes for consecutive primes *)
primes = Prime[Range[10, 20]];
orbitSizes = Length[PrimeOrbit[#]] & /@ primes;
Thread[primes -> orbitSizes]
```

## Research Questions

See [CLAUDE.md](CLAUDE.md) for a comprehensive guide to computational explorations, including:

- Gap Theorem verification at scale
- Hub identification and correlation analysis
- Partial order characterization
- Jump point analysis
- Distance distributions in the DAG
- Community structure detection

## Related Work

This project is part of a series exploring alternative number representations:
- **Ratio**: Egyptian fractions and rationalization techniques
- **Orbit**: Prime orbits and the prime index DAG

## Status

**Version:** 0.1.0
**Status:** Active exploration, Gap Theorem proven
**Connections:** Prime gaps, graph theory, recursive dynamics, additive number theory

## Documentation

- [Prime DAG and Gap Theorem](docs/prime-dag-gap-theorem.md) - Mathematical framework
- [CLAUDE.md](CLAUDE.md) - Computational exploration guide

## License

Research exploration project. Code provided as-is for computational number theory experiments.
