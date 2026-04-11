---
name: ore-algebra
description: Guidelines for using ore_algebra with passagemath (modular SageMath) for holonomic recurrence analysis, operator factorization, and singularity analysis. Auto-activate when writing Python scripts using ore_algebra, passagemath, or when working on holonomic/D-finite analysis.
paths: "**/*.py"
---

# ore_algebra with passagemath

## Environment

**Venv location:** `venv_ore_algebra/` (project root)
**Python:** 3.14, passagemath 10.8.3, ore_algebra 0.5

### Activation (Bash)

```bash
source /home/jan/github/orbit/venv_ore_algebra/bin/activate
```

### Running scripts

```bash
source /home/jan/github/orbit/venv_ore_algebra/bin/activate && python3 script.py
```

## CRITICAL: Import Order

**passagemath_flint MUST be imported BEFORE ore_algebra.** The passagemath modular distribution does not have `sage.all` — instead, use explicit imports from `passagemath_flint`. This bootstraps the sage internal module graph and prevents circular import errors.

```python
# ✅ CORRECT — always this order
from passagemath_flint import QQ, ZZ, PolynomialRing, Matrix, vector
from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

# ❌ WRONG — circular import crash
from ore_algebra import OreAlgebra  # fails without passagemath_flint first
```

### Available imports from passagemath_flint

```python
from passagemath_flint import (
    QQ, ZZ, QQbar, RBF, CBF, RealBallField, ComplexBallField,
    PolynomialRing, LaurentPolynomialRing, PowerSeriesRing,
    Matrix, vector, identity_matrix,
    Integer, Rational,
    NumberField, CyclotomicField,
    GF,  # finite fields
)
```

## Core Patterns

### 1. Guess recurrence from sequence

```python
from passagemath_flint import QQ, ZZ, PolynomialRing
from ore_algebra import OreAlgebra
from ore_algebra.guessing import guess

# Setup shift operator algebra over QQ[n]
Rn = PolynomialRing(QQ, 'n')
n = Rn.gen()
An = OreAlgebra(Rn, 'Sn')
Sn = An.gen()

# Sequence as Python list of integers
seq = [1, 1, 2, 5, 14, 42, 132, 429, ...]

rec = guess(seq, An)
# Returns: (-n - 2)*Sn + 4*n + 2  (Catalan recurrence)
```

### 2. Guess ODE from power series coefficients

```python
# Setup differential operator algebra over QQ[x]
Rx = PolynomialRing(QQ, 'x')
x = Rx.gen()
Ax = OreAlgebra(Rx, 'Dx')
Dx = Ax.gen()

# Coefficients of F(x) = sum a_n x^n
coeffs = [...]
ode = guess(coeffs, Ax)
# Returns differential operator annihilating F(x)
```

### 3. Convert between shift and differential

```python
# Shift operator Sn on QQ[n]
rec = guess(seq, An)  # in terms of Sn

# Convert to differential operator
# (ore_algebra handles this via to_D and to_S methods on operators)
```

### 4. Operator factorization

```python
from ore_algebra.analytic.factorization import factor
# factor(operator) attempts to decompose into irreducible factors
```

### 5. Analytic continuation and monodromy

```python
from ore_algebra.analytic import analytic_continuation, local_solutions, monodromy

# Local solutions at a point
# local_solutions.log_series(operator, point, order)

# Monodromy matrices
# monodromy.monodromy_matrices(operator)

# Analytic continuation along a path
# analytic_continuation.analytic_continuation(operator, path, ini)
```

### 6. Singularity analysis

```python
from ore_algebra.analytic import singularity_analysis
# Extract singular points, indicial equations, local exponents
```

## Available ore_algebra Submodules

| Module | Purpose |
|--------|---------|
| `ore_algebra.guessing` | Guess operators from sequences/series |
| `ore_algebra.analytic.local_solutions` | Local series expansions at singular points |
| `ore_algebra.analytic.monodromy` | Monodromy matrices |
| `ore_algebra.analytic.analytic_continuation` | Numerical analytic continuation |
| `ore_algebra.analytic.factorization` | Factor differential/recurrence operators |
| `ore_algebra.analytic.singularity_analysis` | Singularity classification |
| `ore_algebra.dfinite_function` | D-finite function objects |
| `ore_algebra.nullspace` | Nullspace computation |

## Project Context

This is used for the **diagonal lattice path** project:
- **Integer slopes k**: Recurrences are low-order (e.g., order 3 for k=2). Known: `(1-C)^{k+1} = 1-2C`.
- **Rational slopes p/q (q>1)**: Recurrences are high-order (order 15 for slope 3/2). The asymptotic constant C is likely transcendental.
- **Kernel equations**: For slope p/q, the GF satisfies an algebraic kernel equation (e.g., `u² = z(1+u⁵)` for slope 3/2).
- **Goal**: Factor the high-order operators to understand the transcendence of C.

## Gotchas

1. **No `sage.all`** — passagemath is modular, use `passagemath_flint` for most things
2. **Exact arithmetic only** — use `QQ`, `ZZ`, never Python floats for symbolic work
3. **Large sequences needed** — for high-order recurrences (order 15+), provide 400+ terms
4. **Ball arithmetic** — for numerical work, use `RBF`/`CBF` (real/complex ball fields), not floats
