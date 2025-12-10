# γ-Egypt Simplification Phenomenon

**Created:** 2025-12-10
**Status:** 🤔 HYPOTHESIS — Strong numerical evidence, mechanism under investigation

---

## Discovery

The γ involution systematically **reduces the number of Egypt tuples** for certain classes of rationals, particularly those related to pyramid geometry.

### Key Observation

| Original q | Egypt(q) tuples | γ(q) | Egypt(γ(q)) tuples | Δ |
|------------|-----------------|------|-------------------|---|
| 5/7 (Bent pyramid) | 2 | 1/6 | **1** | -1 |
| 7/11 (Cheops) | 2 | 2/9 | **1** | -1 |
| 5/8 (Chephren) | 2 | 3/13 | **1** | -1 |
| 8/13 | 3 | 5/21 | **1** | -2 |
| 11/18 | 3 | 7/29 | **1** | -2 |
| 3/5 | 2 | 1/4 | **1** | -1 |

### The γ Function

$$\gamma(x) = \frac{1-x}{1+x}$$

**Key properties:**
- **Involution:** γ(γ(x)) = x
- **Fixed point:** γ(√2 - 1) = √2 - 1 (silver ratio!)
- **On rationals:** γ(p/q) = (q-p)/(q+p)

---

## Structural Observation

The γ-images of pyramid ratios have a **uniform Egypt structure:**

```
Egypt(γ(5/7))  = Egypt(1/6)  = {(1, 5, 1, 1)}
Egypt(γ(7/11)) = Egypt(2/9)  = {(1, 4, 1, 2)}
Egypt(γ(5/8))  = Egypt(3/13) = {(1, 4, 1, 3)}
Egypt(γ(2/3))  = Egypt(1/5)  = {(1, 4, 1, 1)}
```

All have the form **(1, v, 1, j)** — the first parameter u = 1!

---

## Connection to CF Structure

For single-tuple Egypt {(1, v, 1, j)}:
- CF has exactly 2 coefficients: [0; v, j]
- Value: T(1, v, 1, j) = j/(1·(1 + vj)) = j/(1 + vj)

**Verification:**
- 1/6 = 1/(1+5·1) ✓ with CF [0; 6] = [0; 5, 1]... wait, CF(1/6) = [0; 6]
- Actually CF(1/6) = [0; 6], which has n=1 (odd), so last tuple formula applies

Let me reconsider...

For q = 1/n:
- CF = [0; n]
- n = 1 (odd), so single tuple: (q₀, q₁-q₀, 1) = (1, n-1, 1)
- Value: 1/(1·n) = 1/n ✓

So Egypt(1/6) = {(1, 5, 1, 1)} means T(1,5,1,1) = 1/(1·6) = 1/6 ✓

---

## Pyramid Connection

### Silver Ratio (√2 - 1 ≈ 0.414)

- **Fixed point of γ**
- Connected to Bent Pyramid (√2 geometry)
- Convergent 5/7 of √2/2 maps under γ to 1/6

### Golden Ratio (φ ≈ 1.618)

- Fixed point of x → 1 + 1/x
- Connected to Giza pyramids (√φ/2 geometry)
- Convergent 7/11 of √φ/2 maps under γ to 2/9

---

## Open Questions

### Q1: Characterization
Which rationals q satisfy: #Egypt(γ(q)) < #Egypt(q)?

**Hypothesis:** Rationals with "Fibonacci-like" structure (consecutive Fibonacci or Lucas numbers in numerator/denominator).

### Q2: Mechanism
Why does γ simplify Egypt representation?

**Possible explanation:** γ acts as Möbius transformation with matrix [[-1,1],[1,1]]. This may interact with CF matrices [[a,1],[1,0]] in a way that "compresses" the CF length.

### Q3: Inverse Direction
When does γ **complexify** Egypt representation?

From tests: 7/12 and 9/14 stayed same (2 → 2 tuples).

### Q4: Connection to Hartley
The γ function arose from rational circle parametrization (cas function, Hartley transform). Is there a frequency-domain interpretation of Egypt simplification?

---

## Möbius-Egypt Algebra

γ as matrix action on projective coordinates [p:q]:

$$\gamma: \begin{pmatrix} p \\ q \end{pmatrix} \mapsto \begin{pmatrix} -1 & 1 \\ 1 & 1 \end{pmatrix} \begin{pmatrix} p \\ q \end{pmatrix} = \begin{pmatrix} q-p \\ q+p \end{pmatrix}$$

CF partial quotient a acts as:

$$\text{CF}(a): \begin{pmatrix} a & 1 \\ 1 & 0 \end{pmatrix}$$

Product of two CF matrices (Egypt tuple corresponds to paired CF coefficients):

$$\text{CF}(a) \cdot \text{CF}(b) = \begin{pmatrix} ab+1 & a \\ b & 1 \end{pmatrix}$$

**Question:** Is there a matrix identity relating γ · (CF products) that explains simplification?

---

## Verification Code

```mathematica
gamma[t_] := (1 - t)/(1 + t);

egyptFromCF[q_] := Module[{cf, n, qs, numTuples},
  cf = ContinuedFraction[q];
  n = Length[cf] - 1;
  If[n == 0 || q <= 0 || q >= 1, Return[{}]];
  qs = {1, cf[[2]]};
  Do[AppendTo[qs, cf[[i+1]]*qs[[-1]] + qs[[-2]]], {i, 2, n}];
  numTuples = Ceiling[n/2];
  Table[
    If[k < numTuples || EvenQ[n],
      {qs[[2k-1]], qs[[2k]], 1, cf[[2k+1]]}
    ,
      {qs[[n]], qs[[n+1]] - qs[[n]], 1, 1}
    ]
  , {k, numTuples}]
];

(* Test simplification *)
testSimplification[q_] := Module[{gq, eq, egq},
  gq = gamma[q];
  If[0 < gq < 1,
    eq = egyptFromCF[q];
    egq = egyptFromCF[gq];
    {q, Length[eq], gq, Length[egq], Length[eq] - Length[egq]}
  ,
    {q, Length[egyptFromCF[q]], gq, "N/A", "N/A"}
  ]
];
```

---

## References

- Parent: [CF-Egypt Equivalence](README.md)
- γ framework: [Hartley-Circ session](../2025-12-07-circ-hartley-exploration/)
- Pyramid geometry: [Golden Ratio Pyramid](../2025-12-08-gamma-framework/golden-ratio-pyramid.md)
