# OEIS Graph Structure: Lattice Paths ↔ Multinacci Constants

**Date:** 2026-04-12
**Context:** The connection C(k) = 1 − 1/τ_k reveals a bridge between two independently studied families in OEIS.

## Two Independent Chains

### Chain 1 — Lattice path sequences (combinatorial)

Paths from (1,0) to (n,n) under y ≤ kx, parametrized by integer slope k:

| k | Sequence | OEIS | First terms | Growth |
|---|----------|------|-------------|--------|
| 1 | Catalan numbers | A000108 | 1, 2, 5, 14, 42, 132, ... | 4^n / (n^{3/2} √π) |
| 2 | Ballot paths, slope 2 | A127927 | 1, 3, 9, 31, 108, 391, ... | C(2) · 4^n / √(πn) |
| 3 | Ballot paths, slope 3 | **not in OEIS** | 1, 3, 10, 34, 121, 441, ... | C(3) · 4^n / √(πn) |
| 4 | Ballot paths, slope 4 | **not in OEIS** | 1, 3, 10, 35, 125, 456, ... | C(4) · 4^n / √(πn) |
| 5 | Ballot paths, slope 5 | **not in OEIS** | 1, 3, 10, 35, 126, 461, ... | C(5) · 4^n / √(πn) |
| ∞ | Unconstrained | A001700 | 1, 3, 10, 35, 126, 462, ... | 4^n / (2√(πn)) |

Note: the sequences converge termwise to the unconstrained case — the first k terms always agree.

### Chain 2 — Multinacci constants (algebraic)

Growth rate τ_k of the k-step generalized Fibonacci recurrence (a_n = a_{n-1} + a_{n-2} + ... + a_{n-k}):

| k | Name | τ_k | OEIS (constant) | Defining equation |
|---|------|-----|-----------------|-------------------|
| 2 | Golden ratio | φ ≈ 1.6180 | A001622 | v² = v + 1 |
| 3 | Tribonacci constant | ≈ 1.8393 | A058265 | v³ = v² + v + 1 |
| 4 | Tetranacci constant | ≈ 1.9275 | A086088 | v⁴ = v³ + v² + v + 1 |
| 5 | Pentanacci constant | ≈ 1.9659 | A103814 | v⁵ = v⁴ + ... + v + 1 |
| ∞ | — | 2 | — | v^k = v^{k-1} + ... + 1 |

All τ_k are Pisot–Vijayaraghavan numbers (algebraic integers > 1 with all conjugates inside the unit circle).

## The Bridge

A single formula connects the two chains:

$$C(k) = 1 - \frac{1}{\tau_k}$$

```
CHAIN 1 (sequences)              CHAIN 2 (constants)

A000108 (Catalan)  ←—— C = 0 (degenerate) ——→  τ₁ = 1 (degenerate)
                            │
A127927            ←—— C = 1/φ² ≈ 0.382 ——→  A001622 (φ ≈ 1.618)
                            │
new (k=3)          ←—— C ≈ 0.456 ————————→  A058265 (τ₃ ≈ 1.839)
                            │
new (k=4)          ←—— C ≈ 0.481 ————————→  A086088 (τ₄ ≈ 1.928)
                            │
new (k=5)          ←—— C ≈ 0.491 ————————→  A103814 (τ₅ ≈ 1.966)
                            │
                           ⋮
                            │
A001700 (uncon.)   ←—— C = 1/2 ——————————→  τ_∞ = 2
```

Each horizontal arrow is the theorem C(k) = 1 − 1/τ_k. The vertical chains were studied independently — by the lattice path community (left) and the algebraic number theory / substitution dynamics community (right).

## Triangle of Domains

The proof passes through three mathematical domains:

```
            COMBINATORICS
           (lattice paths)
           a_k(n) = paths
          from (1,0) to (n,n)
           under y ≤ kx
              /         \
             /           \
     bijection         singularity
    s = kx − y          analysis
           /               \
          /                 \
   PROBABILITY          ALGEBRA
  (ruin theory)       (k-nacci eqn)
  1D walk on          r_k(u) = 0
  {+k, −1}           u = 1/τ_k
  ρ = q + pρ^{k+1}   Pisot numbers
          \               /
           \             /
        symmetric     substitution
          limit       v = 1/u
             \         /
              \       /
            ρ^{k+1} − 2ρ + 1 = 0
```

Each edge is a non-trivial step:

1. **Combinatorics → Probability:** The constraint y ≤ kx transforms to a 1D walk s = kx − y with steps {+k, −1} staying non-negative. Pure bijection.

2. **Probability → Algebra:** The ruin probability ρ of the symmetric walk satisfies ρ = 1/2 + (1/2)ρ^{k+1}, giving the polynomial ρ^{k+1} − 2ρ + 1 = 0.

3. **Algebra → Combinatorics:** The substitution v = 1/ρ yields the k-nacci equation v^k = v^{k-1} + ... + 1, and C(k) = 1 − ρ = 1 − 1/v gives the asymptotic constant.

## Value of the Connection

### 1. Two communities, one equation

The lattice path community (Banderier, Wallner, Krattenthaler, Flajolet) and the Pisot number / substitution dynamics community (Rauzy, Siegel, Akiyama) study the same algebraic object from opposite sides. The bridge C(k) = 1 − 1/τ_k appears to be new.

### 2. Bidirectional prediction

- **From τ_k to a_k(n):** Given any k-nacci constant (extensively tabulated), the asymptotic constant of the lattice path sequence is immediate.
- **From a_k(n) to τ_k:** Computing a lattice path sequence gives a numerical route to the k-nacci constant — a combinatorial construction of a Pisot number.

### 3. Context for new OEIS entries

The k ≥ 3 lattice path sequences are not in OEIS. With the multinacci connection, each new entry arrives with:
- An algebraic characterization (root of a specific polynomial)
- A place in a parametric family
- Connections to substitution dynamics, Pisot theory, and ruin probabilities
- Explicit asymptotic formula via the k-nacci constant

### 4. Phase transition at k = 1

The Catalan case (k=1) is the degenerate endpoint: τ₁ = 1 (not a Pisot number), ρ = 1 (ruin certain), C = 0 (the 4^n/√n growth is suppressed to 4^n/n^{3/2}). The transition from k = 1 to k = 2 is a **phase transition** from certain ruin to survival — from n^{−3/2} to n^{−1/2} asymptotics.

### 5. Framework for non-integer slopes

For non-integer slope α, the equation r_k(u) = Σu^j − 1 = 0 does NOT hold (verified for 14 rational slopes). The question becomes: **what replaces the k-nacci equation for non-integer α?**

The multinacci framework tells us precisely what to look for — not a numerical value of C(α), but the equation/operator that defines it:

| Slope | Defining object | Type |
|-------|----------------|------|
| Integer k | r_k(u) = u^k + ... + u − 1 | polynomial, degree k |
| Rational p/q | Characteristic polynomial of transfer matrix | polynomial, degree ~p |
| Irrational α | ??? | ??? |

## References

### Lattice paths
- Banderier, C. and Flajolet, P. (2002). "Basic Analytic Combinatorics of Directed Lattice Paths." *Theor. Comput. Sci.* 281, 37-80.
- Banderier, C. and Wallner, M. (2016). "Lattice paths below a line of rational slope." arXiv:1606.08412.
- Krattenthaler, C. (2015). "Lattice Path Enumeration." In *Handbook of Enumerative Combinatorics*. arXiv:1503.05930.
- Flajolet, P. and Sedgewick, R. (2009). *Analytic Combinatorics*. Cambridge University Press.

### Multinacci / Pisot numbers
- Miles, E.P. (1960). "Generalized Fibonacci Numbers and Associated Matrices." *Amer. Math. Monthly* 67(8), 745-752.
- Dresden, G.P.B. and Du, Z. (2014). "A Simplified Binet Formula for k-Generalized Fibonacci Numbers." *J. Integer Seq.* 17, Article 14.4.7.
- Rauzy, G. (1982). "Nombres algébriques et substitutions." *Bull. Soc. Math. France* 110, 147-178.
- Fogg, N.P. (2002). *Substitutions in Dynamics, Arithmetics and Combinatorics*. Springer LNM 1794.

### Ruin theory / ballot problems
- Takács, L. (1967). *Combinatorial Methods in the Theory of Stochastic Processes*. Wiley.
- Feller, W. (1968). *An Introduction to Probability Theory and Its Applications*, Vol. I, 3rd ed. Wiley. Chapter XIV (random walks and ruin problems).
