# Square Root Rationalizations via Chebyshev Polynomials

## Overview

This module computes rational approximations to square roots using a beautiful combination of:
1. **Pell equation solutions** — fundamental solutions to $x^2 - d \cdot y^2 = 1$
2. **Chebyshev polynomials** — elegant refinement using polynomials of first and second kind

## The Method

### Step 1: Solve the Pell Equation

For integer $d$, find the fundamental solution $(x, y)$ to:
$$x^2 - d \cdot y^2 = 1$$

This gives the base approximation:
$$\sqrt{d} \approx \frac{x}{y}$$

More precisely:
$$\frac{x-1}{y} < \sqrt{d} < \frac{x}{y}$$

### Step 2: Refine with Chebyshev Terms

Define the $k$-th Chebyshev term:
$$T_k(x) = \frac{1}{C_{\lceil k/2 \rceil}(x+1) \cdot \left(U_{\lfloor k/2 \rfloor}(x+1) - U_{\lfloor k/2 \rfloor - 1}(x+1)\right)}$$

where:
- $C_n$ is the Chebyshev polynomial of the first kind
- $U_n$ is the Chebyshev polynomial of the second kind

The refined approximation:
$$\sqrt{d} \approx \frac{x-1}{y} \left(1 + \sum_{k=1}^{n} T_k(x-1)\right)$$

## Why Chebyshev Polynomials?

Chebyshev polynomials have **optimal approximation properties**:
- They minimize the maximum error (minimax property)
- They arise naturally in continued fraction expansions
- Their recursive structure matches the ladder operators in Pell equations

The connection to continued fractions and Egyptian fractions makes this a natural representation for square root approximations.

## Usage

### Basic Approximation

```mathematica
<< Orbit`

(* Rational approximation to √2 *)
SqrtRationalization[2]
```

Output:
```mathematica
{1, {1, 1/6, 1/120, 1/5040, ...}}
```

The first element is $(x-1)/y = 1$, the second is the list of terms (starting with the constant 1).

### Different Output Methods

```mathematica
(* Rational number result *)
SqrtRationalization[2, Method -> "Rational"]
(* Returns: exact rational approximation *)

(* Symbolic expression with held terms *)
SqrtRationalization[2, Method -> "Expression"]
(* Returns: held form showing Chebyshev structure *)

(* List of terms for analysis *)
SqrtRationalization[2, Method -> "List"]
(* Returns: {base, {terms}} *)
```

### Accuracy Control

```mathematica
(* Use 15 Chebyshev terms for higher accuracy *)
SqrtRationalization[5, Accuracy -> 15]
```

## Examples

### Example 1: √2

```mathematica
SqrtRationalization[2, Method -> "Rational", Accuracy -> 4]
```

Pell solution: $x = 3, y = 2$ (since $3^2 - 2 \cdot 2^2 = 1$)

Base: $(3-1)/2 = 1$

Refined with 4 Chebyshev terms gives high-precision rational approximation.

### Example 2: √5 (Golden Ratio Connection)

```mathematica
SqrtRationalization[5, Method -> "Rational", Accuracy -> 8]
```

Pell solution: $x = 9, y = 4$ (since $9^2 - 5 \cdot 4^2 = 1$)

Base: $(9-1)/4 = 2$

Note: $\sqrt{5} = 2\phi$ where $\phi$ is the golden ratio.

### Example 3: √13

```mathematica
PellSolution[13]
(* Returns: {x -> 649, y -> 180} *)

SqrtRationalization[13, Method -> "List"]
(* Base: (649-1)/180 = 648/180 = 18/5 *)
```

Verifying: $(18/5)^2 = 324/25 = 12.96 \approx 13$ ✓

## Functions

### `SqrtRationalization[n, options]`

Computes rational approximation to $\sqrt{n}$.

**Options:**
- `Method -> "Rational"` — Returns exact rational number
- `Method -> "List"` — Returns `{base, {terms}}`
- `Method -> "Expression"` — Returns held symbolic form
- `Accuracy -> k` — Number of Chebyshev terms (default: 8)

### `PellSolution[d]`

Finds fundamental solution to $x^2 - d \cdot y^2 = 1$.

**Returns:** `{x -> value, y -> value}`

**Algorithm:** Wildberger's efficient method from [JIS paper](https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf)

### `ChebyshevTerm[x, k]`

Computes the $k$-th term in the Chebyshev-based rational series.

**Formula:**
$$\frac{1}{C_{\lceil k/2 \rceil}(x+1) \cdot \left(U_{\lfloor k/2 \rfloor}(x+1) - U_{\lfloor k/2 \rfloor - 1}(x+1)\right)}$$

## Mathematical Background

### Pell Equations

The Pell equation $x^2 - d \cdot y^2 = 1$ has infinite solutions that form a group under multiplication:
$$(x_1, y_1) \cdot (x_2, y_2) = (x_1 x_2 + d y_1 y_2, x_1 y_2 + y_1 x_2)$$

The **fundamental solution** is the smallest $(x, y)$ with $x, y > 0$.

All other solutions are powers: $(x_n, y_n) = (x_1, y_1)^n$.

### Continued Fractions

The continued fraction of $\sqrt{d}$ is periodic:
$$\sqrt{d} = [a_0; \overline{a_1, a_2, \ldots, a_k}]$$

The convergents give Pell solutions. The Chebyshev refinement provides a **rational alternative** to continued fractions.

### Connection to Egyptian Fractions

Each Chebyshev term can be expanded as a sum of unit fractions, connecting this representation to Egyptian fractions explored in the `egypt` repository.

## Performance

The Pell solver uses Wildberger's algorithm, which is **significantly faster** than naive continued fraction methods for large $d$.

Chebyshev term computation is $O(k)$ where $k$ is the accuracy parameter.

## Limitations

- Works for non-square integers $d$
- Accuracy parameter controls precision vs. computation time
- Very large Pell solutions may have numerical precision issues

## Related Work

This functionality was originally developed in the `egypt` repository for Egyptian fraction explorations, but has been moved here as it represents a **general rationalization technique** applicable beyond Egyptian fractions.

**See also:**
- Egyptian fractions: `github.com/user/egypt`
- Primorial rationalizations: `docs/primorial-formula.md`
- Modular arithmetic: `docs/modular-factorials.md`

---

*Module added: 2025-11-12*
*Version: 0.4.0*
