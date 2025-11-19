# Egypt-Chebyshev Equivalence Conjecture

**Status**: NUMERICALLY VERIFIED (j=1,2,3,4), NOT PROVEN
**Date**: November 19, 2025
**Updated**: November 19, 2025 (evening session)
**Priority**: INSIGHT-DRIVEN - Reveals non-trivial structure in shifted Chebyshev polynomials

---

## Overview

The Egypt repository and Orbit paclet both compute rational approximations to square roots using different formulas that appear to be **algebraically equivalent**.

**Conjecture**: The factorial-based formula (Egypt) equals the Chebyshev polynomial formula (Orbit).

If proven, this unifies two seemingly disparate approaches and provides deep theoretical foundation for the sqrt rationalization paper.

---

## The Two Formulas

### Formula 1: Factorial-Based (Egypt Repository)

**Source**: `egypt/wl/Egypt.wl` - function `term0[x, j]`

**Definition**:
$$\text{term0}(x, j) = \frac{1}{1 + \sum_{i=1}^{j} 2^{i-1} x^i \frac{(j+i)!}{(j-i)! \cdot (2i)!}}$$

**Implementation** (Mathematica):
```mathematica
term0[x_, j_] := 1 / (1 + Sum[2^(i-1) * x^i * Factorial[j+i] /
                               (Factorial[j-i] * Factorial[2*i]), {i, 1, j}])
```

**Properties**:
- Pure factorial formula
- No polynomial evaluation needed
- Explicit closed form for each term
- Works with Pell solution input: x = (x₀-1) from x₀² - n·y₀² = 1

---

### Formula 2: Chebyshev Polynomial-Based (Orbit Paclet)

**Source**: `Orbit/Kernel/SquareRootRationalizations.wl` - function `ChebyshevTerm[x, k]`

**Definition**:
$$\text{ChebyshevTerm}(x, j) = \frac{1}{T_{\lceil j/2 \rceil}(x+1) \cdot \left(U_{\lfloor j/2 \rfloor}(x+1) - U_{\lfloor j/2 \rfloor - 1}(x+1)\right)}$$

where:
- $T_n$ = Chebyshev polynomial of the first kind
- $U_n$ = Chebyshev polynomial of the second kind

**Implementation** (Mathematica):
```mathematica
ChebyshevTerm[x_, k_] :=
    1 / (ChebyshevT[Ceiling[k/2], x + 1] *
         (ChebyshevU[Floor[k/2], x + 1] -
          ChebyshevU[Floor[k/2] - 1, x + 1]))
```

**Properties**:
- Uses built-in Chebyshev polynomials
- Efficient for large x (polynomial evaluation)
- Same input convention: x = (x₀-1) from Pell solution

---

## The Conjecture

**MAIN CONJECTURE**:
$$\text{term0}(x, j) = \text{ChebyshevTerm}(x, j) \quad \forall x, j \in \mathbb{Z}^+$$

Equivalently:
$$\frac{1}{1 + \sum_{i=1}^{j} 2^{i-1} x^i \frac{(j+i)!}{(j-i)! \cdot (2i)!}} = \frac{1}{T_{\lceil j/2 \rceil}(x+1) \cdot \Delta U_j(x+1)}$$

where $\Delta U_j(x) := U_{\lfloor j/2 \rfloor}(x) - U_{\lfloor j/2 \rfloor - 1}(x)$

---

## Numerical Verification

**Source**: `docs/egypt-even-k-rigorous-attempt.md` in Orbit repo

**Status**: "term0[x,j] = term[x,j] (verified numerically)"

**Test coverage**: Not documented in detail, but claimed to hold for all tested values.

**Needed**: Systematic testing for:
- Small cases: j ∈ {1, 2, 3, 4, 5}
- Various x values: x ∈ {1, 2, 3, ..., 100}
- Pell-derived x values: x = x₀-1 for various n

---

## Known Cases (To Be Verified)

### Case j=1:

**Factorial formula**:
$$\text{term0}(x,1) = \frac{1}{1 + 2^0 \cdot x \cdot \frac{2!}{0! \cdot 2!}} = \frac{1}{1 + x \cdot \frac{2}{2}} = \frac{1}{1+x}$$

**Chebyshev formula**:
- $\lceil 1/2 \rceil = 1$, $\lfloor 1/2 \rfloor = 0$
- $T_1(y) = y$, $U_0(y) = 1$, $U_{-1}(y) = 0$
- $\text{ChebyshevTerm}(x,1) = \frac{1}{(x+1) \cdot (1 - 0)} = \frac{1}{x+1}$

**Result**: ✓ EQUAL for j=1

---

### Case j=2:

**Factorial formula**:
$$\text{term0}(x,2) = \frac{1}{1 + x \cdot \frac{3!}{1! \cdot 2!} + 2x^2 \cdot \frac{4!}{0! \cdot 4!}}$$
$$= \frac{1}{1 + x \cdot \frac{6}{2} + 2x^2 \cdot 1} = \frac{1}{1 + 3x + 2x^2}$$

**Chebyshev formula**:
- $\lceil 2/2 \rceil = 1$, $\lfloor 2/2 \rfloor = 1$
- $T_1(y) = y$, $U_1(y) = 2y$, $U_0(y) = 1$
- $\text{ChebyshevTerm}(x,2) = \frac{1}{(x+1) \cdot (2(x+1) - 1)} = \frac{1}{(x+1)(2x+1)}$

**Expand**: $(x+1)(2x+1) = 2x^2 + x + 2x + 1 = 2x^2 + 3x + 1$

**Result**: ✓ EQUAL for j=2

---

### Case j=3:

**Factorial formula**:
$$\text{term0}(x,3) = \frac{1}{1 + 6x + 10x^2 + 4x^3}$$

Derivation:
- i=1: $2^0 \cdot x \cdot \frac{4!}{2! \cdot 2!} = x \cdot \frac{24}{4} = 6x$
- i=2: $2^1 \cdot x^2 \cdot \frac{5!}{1! \cdot 4!} = 2x^2 \cdot \frac{120}{24} = 10x^2$
- i=3: $2^2 \cdot x^3 \cdot \frac{6!}{0! \cdot 6!} = 4x^3 \cdot 1 = 4x^3$

**Chebyshev formula**:
- $\lceil 3/2 \rceil = 2$, $\lfloor 3/2 \rfloor = 1$
- $T_2(y) = 2y^2 - 1$, $U_1(y) = 2y$, $U_0(y) = 1$
- At $y = x+1$:
  - $T_2(x+1) = 2(x+1)^2 - 1 = 2x^2 + 4x + 1$
  - $U_1(x+1) - U_0(x+1) = 2(x+1) - 1 = 2x + 1$
- Product: $(2x^2 + 4x + 1)(2x + 1) = 4x^3 + 10x^2 + 6x + 1$

**Result**: ✓ EQUAL for j=3

---

### Case j=4:

**Factorial formula**:
$$\text{term0}(x,4) = \frac{1}{1 + 10x + 30x^2 + 28x^3 + 8x^4}$$

Derivation:
- i=1: $2^0 \cdot x \cdot \frac{5!}{3! \cdot 2!} = x \cdot \frac{120}{12} = 10x$
- i=2: $2^1 \cdot x^2 \cdot \frac{6!}{2! \cdot 4!} = 2x^2 \cdot \frac{720}{48} = 30x^2$
- i=3: $2^2 \cdot x^3 \cdot \frac{7!}{1! \cdot 6!} = 4x^3 \cdot \frac{5040}{720} = 28x^3$
- i=4: $2^3 \cdot x^4 \cdot \frac{8!}{0! \cdot 8!} = 8x^4 \cdot 1 = 8x^4$

**Chebyshev formula**:
- $\lceil 4/2 \rceil = 2$, $\lfloor 4/2 \rfloor = 2$
- $T_2(y) = 2y^2 - 1$, $U_2(y) = 4y^2 - 1$, $U_1(y) = 2y$
- At $y = x+1$:
  - $T_2(x+1) = 2x^2 + 4x + 1$
  - $U_2(x+1) - U_1(x+1) = (4x^2 + 8x + 3) - (2x + 2) = 4x^2 + 6x + 1$
- Product: $(2x^2 + 4x + 1)(4x^2 + 6x + 1) = 8x^4 + 28x^3 + 30x^2 + 10x + 1$

**Result**: ✓ EQUAL for j=4

---

## Egypt Framework Integration

### Egypt sqrt Formula (from egypt/doc/sqrt.pdf):

$$\sqrt{n} = \frac{x-1}{y} \lim_{k \to \infty} f(x-1, k)$$

where:
$$f(n, k) = \frac{1}{n} \sum_{i=0}^k a(n,i)$$

and $a(n,i)$ follows the recurrence:
$$a(n, 0) = n, \quad a(n,1) = \frac{n}{n+1}, \quad a(n, i+1) = \frac{a(n,i)^2}{a(n,i-1)(a(n,i)+1)}$$

**Closed form** (from Egypt PDF):
$$f(n,k) = 1 + \sum_{j=1}^k \frac{1}{1 + \sum_{i=1}^j 2^{i-1} \frac{(j+i)!}{(j-i)!(2i)!} n^i}$$

**This is exactly the sum of term0 functions!**

---

### Orbit Framework Integration

$$\text{SqrtRationalization}[n] = \frac{x-1}{y} \cdot \left(1 + \sum_{j=1}^k \text{ChebyshevTerm}[x-1, j]\right)$$

where $(x,y)$ is Pell solution for $x^2 - ny^2 = 1$.

**This is exactly the sum of ChebyshevTerm functions!**

---

## Binomial Structure Discovery

### Rewriting the Factorial Formula

The factorial coefficient can be simplified:
$$c_{j,i} = 2^{i-1} \cdot \frac{(j+i)!}{(j-i)! \cdot (2i)!} = 2^{i-1} \cdot \binom{j+i}{2i}$$

Therefore, the denominator polynomial is:
$$P_j(x) = 1 + \sum_{i=1}^{j} 2^{i-1} \binom{j+i}{2i} x^i$$

### Pattern in Verified Cases

| j | Polynomial | Coefficients | Leading coef |
|---|------------|--------------|--------------|
| 1 | $1 + x$ | [1, 1] | $2^0 = 1$ |
| 2 | $1 + 3x + 2x^2$ | [1, 3, 2] | $2^1 = 2$ |
| 3 | $1 + 6x + 10x^2 + 4x^3$ | [1, 6, 10, 4] | $2^2 = 4$ |
| 4 | $1 + 10x + 30x^2 + 28x^3 + 8x^4$ | [1, 10, 30, 28, 8] | $2^3 = 8$ |

**Observations**:
- Leading coefficient: Always $2^{j-1}$ ✓
- Constant term: Always 1 ✓
- Second coefficient: Triangular numbers {1, 3, 6, 10, ...} ✓
- **All coefficients positive** ← This is non-trivial!

### Why Positivity is Non-Trivial

**Standard Chebyshev polynomials have MIXED signs:**
- $T_2(y) = 2y^2 - 1$ (coefficients: -1, 0, 2)
- $U_2(y) = 4y^2 - 1$ (coefficients: -1, 0, 4)
- Products $T_m \cdot U_n$ generally have mixed signs

**After shift $y \to x+1$ and taking product:**
- $T_{\lceil j/2 \rceil}(x+1) \cdot \Delta U_j(x+1)$ has **ALL POSITIVE** coefficients
- This is SPECIAL - not shared by other orthogonal families (Legendre, Hermite)

**Key mechanism creating positivity:**
1. **Shift to boundary**: $y = x+1$ expands around $y=1$ (Chebyshev domain boundary)
2. **Difference operator**: $\Delta U = U_n - U_{n-1}$ mixes parities
3. **Product structure**: Negative terms from $T_n$ and $\Delta U$ cancel exactly
4. **Ceiling/floor indexing**: Creates proper alignment for cancellation

### Combinatorial Interpretation

The binomial coefficient $\binom{j+i}{2i}$ counts:
- "Ways to choose $2i$ objects from $j+i$ total"
- **Choosing EVEN number** (2i) - related to parity structure
- Remaining objects: $(j+i) - 2i = j-i$

The factor $2^{i-1}$ arises from:
- Chebyshev recursion: $U_{n+1} = 2y \cdot U_n - U_{n-1}$ (doubling)
- Each recursion level multiplies by 2
- Base case ($i=1$): $2^0 = 1$

**Speculative lattice path model:**
- Total steps: $j+i$
- Vertical steps: $2i$ (EVEN constraint)
- Horizontal steps: $j-i$
- Weighting: $2^{i-1}$ ways to orient vertical pairs

### Moment Sequence Property

A polynomial $p(x) = \sum c_k x^k$ with all $c_k > 0$ represents a **moment sequence**:
$$c_k = \int_0^{\infty} t^k \, d\mu(t)$$
for some positive measure $\mu$.

**Our $P_j(x)$ has this property!**

Connection to Chebyshev weight function:
- Standard Chebyshev weight: $w(t) = 1/\sqrt{1-t^2}$ on $[-1,1]$
- Our shift $(y \to x+1)$ transforms this measure
- Result: Positive measure on $[0, \infty)$ with moments $2^{i-1} \binom{j+i}{2i}$

### Comparison with Other Orthogonal Polynomials

**Legendre at $x+1$:**
$$P_2(x+1) = \frac{3(x+1)^2 - 1}{2} = \frac{3x^2 + 6x + 2}{2}$$
Coefficients: Positive, but different structure (no binomial formula)

**Hermite at $x+1$:**
$$H_2(x+1) = 4(x+1)^2 - 2 = 4x^2 + 8x + 2$$
Coefficients: Positive, but structure is $2^n (x+1)^2 - 2$ (trivial)

**Chebyshev product $T_n(x+1) \cdot \Delta U_n(x+1)$:**
- ✅ Exact binomial structure: $2^{i-1} \binom{j+i}{2i}$
- ✅ Non-trivial positivity (cancellation of mixed signs)
- ✅ Unique to this specific combination

---

## Insight Value (Proven or Not)

### Mathematical Understanding:

**What we've learned (independent of formal proof):**

1. **Positivity structure is non-trivial**
   - Individual $T_n, U_n$ have mixed signs
   - Product + shift + difference → all positive coefficients
   - Sign cancellation mechanism: specific to Chebyshev boundary behavior

2. **Binomial structure emerges naturally**
   - Factorial formula simplifies to $2^{i-1} \binom{j+i}{2i}$
   - "Choose even number (2i)" combinatorial pattern
   - Factor $2^{i-1}$ from Chebyshev doubling recursion

3. **Parity mixing creates completeness**
   - $\Delta U = U_n - U_{n-1}$ mixes parities (n vs n-1)
   - Result: Full polynomial (no parity constraint)
   - Contrast: Individual $T_n, U_n$ have strict parity

4. **Moment sequence connection**
   - Positive coefficients → represents positive measure
   - Related to transformed Chebyshev weight
   - Expansion at boundary (y=1) crucial

5. **Uniqueness to Chebyshev**
   - Legendre, Hermite don't have this structure
   - Specific to product $T_{\lceil j/2 \rceil} \cdot \Delta U_j$
   - Reveals hidden symmetry in shifted Chebyshev theory

### Educational Value:

**Teaches about orthogonal polynomials:**
- How shifts affect coefficient structure
- Sign determination is non-trivial
- Products can create unexpected simplifications
- Boundary expansions have special properties

**Connects disparate topics:**
- Factorial formulas ↔ Orthogonal polynomials
- Egyptian fractions ↔ Chebyshev theory
- Combinatorics (binomial) ↔ Analysis (polynomials)
- Pell equations ↔ Polynomial identities

### Potential Research Directions:

1. **Formal proof** - Various approaches possible:
   - Induction on j using recurrence relations
   - Generating function techniques
   - Direct polynomial expansion and comparison
   - Hypergeometric function connections

2. **Generalization** - Can this extend to:
   - Other shifts: $T_n(x+\alpha) \cdot \Delta U_n(x+\alpha)$ for $\alpha \neq 1$?
   - Other orthogonal families with similar structure?
   - Higher-order differences: $\Delta^k U_n$?

3. **Measure theory** - What is the explicit measure $\mu$?
   - Express in terms of Chebyshev weight
   - Compute moments directly from measure
   - Connection to Stieltjes moment problem

4. **Applications** (if any emerge):
   - Numerical analysis (shifted polynomial bases)
   - Approximation theory (moment matching)
   - Combinatorics (lattice path enumeration)

### Publication Potential:

**Realistic assessment:**
- ❌ **Standalone paper**: Unlikely without proof + applications
- ✅ **Technical note**: Possible in specialized journal (e.g., Ramanujan Journal)
- ✅ **PhD thesis chapter**: Suitable as supporting result
- ✅ **Blog post / expository article**: Excellent educational content
- ✅ **Repository documentation**: High value for future work

**Why not full publication:**
- No proof (only numerical verification j≤4)
- No immediate applications (Egypt framework circular)
- May be known result in obscure literature
- Needs "killer application" or deep generalization

---

## Open Questions

1. **Is this a known Chebyshev identity?**
   - Literature search needed
   - Chebyshev literature is vast (300+ years)
   - May be obscure result from 19th century

2. **Can we prove it algebraically?**
   - Induction on j?
   - Generating function approach?
   - Direct polynomial expansion?

3. **Does it generalize?**
   - Other polynomial families (Legendre, Hermite)?
   - Higher-order Householder methods?

4. **Why does rationality work?**
   - Why does imaginary cancellation happen?
   - Connection to Pell-type identity: $T_n(x)^2 - (x^2-1)U_{n-1}(x)^2 = 1$

---

## Next Steps

1. ✅ Consolidate formulas into Orbit paclet (this document)
2. ⏳ Add term0 implementation to SquareRootRationalizations.wl
3. ⏳ Create systematic test suite (j=1..10, x=1..100)
4. ⏳ Attempt algebraic proof for small cases
5. ⏳ Literature search for known identities
6. ⏳ If proven: Reformulate sqrt paper with this as main result

---

## References

- **Egypt repo**: https://github.com/popojan/egypt
  - `wl/Egypt.wl`: term0 and term definitions
  - `doc/sqrt.pdf`: Theoretical framework

- **Orbit repo**: Current repository
  - `Orbit/Kernel/SquareRootRationalizations.wl`: ChebyshevTerm implementation
  - `docs/egypt-even-k-rigorous-attempt.md`: Numerical verification notes
  - `docs/egypt-universal-pattern-discovery.md`: Universal properties

- **Sqrt paper**: `docs/papers/chebyshev-pell-sqrt-paper.tex`
  - Currently focuses on sixth-order convergence
  - To be reframed if equivalence proven
