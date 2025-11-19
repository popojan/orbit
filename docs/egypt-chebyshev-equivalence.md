# Egypt-Chebyshev Equivalence Conjecture

**Status**: NUMERICALLY VERIFIED, NOT PROVEN
**Date**: November 19, 2025
**Priority**: HIGH - Potential breakthrough for sqrt rationalization paper

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

**To be computed and verified**

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

## Implications if Proven

### For Theory:
✅ **Unifies two frameworks**: Egypt (factorial) ↔ Orbit (Chebyshev)
✅ **Deep Chebyshev identity**: Connects factorials to orthogonal polynomials
✅ **Novel mathematical result**: Likely unpublished equivalence
✅ **Characterizes Pell solutions**: Rationality via polynomial identity

### For Sqrt Paper:
✅ **Publishable novelty**: Not just "another sixth-order method"
✅ **Theoretical depth**: Algebraic insight, not just computation
✅ **Unified story**: Egyptian fractions ↔ Chebyshev ↔ Pell
✅ **Tier-1/Tier-2 potential**: SIAM or Numerical Algorithms

### For Egyptian Fractions:
✅ **Efficient computation**: Use Chebyshev instead of factorial sums
✅ **Connection to classical methods**: Egypt framework via known polynomials
✅ **Theoretical foundation**: Why does Egypt algorithm work?

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
