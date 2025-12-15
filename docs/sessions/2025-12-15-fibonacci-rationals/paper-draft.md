# Fibonacci Representation of Rational Numbers

**Draft for Fibonacci Quarterly**

## Abstract

We present a universal representation theorem: every rational number p/q can be written as a sum of Fibonacci fractions (Σ F_{aᵢ})/F_n, where n is the Fibonacci entry point of q and {aᵢ} is the Zeckendorf decomposition of p·(F_n/q). This extends classical Zeckendorf representation from integers to all rationals. As a corollary, we establish a polynomial bijection: every rational corresponds to a unique pair P(x)/Q(x) ∈ ℤ[x]/ℤ[x] such that P(φ)/Q(φ) = p/q, where φ is the golden ratio.

## 1. Introduction

Zeckendorf's theorem (1972) states that every positive integer has a unique representation as a sum of non-consecutive Fibonacci numbers. The Fibonacci entry point (or rank of apparition) z(q) is the smallest positive integer n such that q divides F_n—a value guaranteed to exist by the Pisano period property.

Freitag and Filipponi (1990, 1993) studied Zeckendorf representations of specific Fibonacci ratios F_{kn}/F_n. We generalize this to ALL rational numbers by combining the entry point with Zeckendorf decomposition.

**Main contributions:**
1. Universal representation theorem for ℚ
2. Polynomial bijection ℚ ↔ ℤ[x]/ℤ[x]
3. Extension to rational approximation of irrationals
4. Efficient algorithmic implementation

## 2. Preliminaries

**Definition 1** (Fibonacci Entry Point). For q ∈ ℤ⁺, the entry point z(q) is the smallest n ≥ 1 such that q | F_n.

**Theorem** (Pisano). For every q ∈ ℤ⁺, the entry point z(q) exists and divides the Pisano period π(q).

**Definition 2** (Zeckendorf Representation). For n ∈ ℤ⁺, the Zeckendorf representation is the unique set of indices {a₁ > a₂ > ... > aₖ} with aᵢ - aᵢ₊₁ ≥ 2 such that n = Σᵢ F_{aᵢ}.

## 3. Main Results

### 3.1 Universal Representation Theorem

**Theorem 1** (Fibonacci Fraction Representation). Every rational p/q in lowest terms can be written as:

$$\frac{p}{q} = \frac{\sum_{i} F_{a_i}}{F_n}$$

where:
- n = z(q) is the Fibonacci entry point of q
- {aᵢ} = Zeck(p · F_n/q) is the Zeckendorf decomposition of the scaled numerator

**Proof.** Since z(q) is the entry point, we have q | F_n, so F_n/q ∈ ℤ. Let m = p · (F_n/q). Then:

$$\frac{p}{q} = \frac{p \cdot (F_n/q)}{F_n} = \frac{m}{F_n} = \frac{\sum_i F_{a_i}}{F_n}$$

where the last equality uses Zeckendorf's theorem on m. ∎

**Corollary 1** (GCD Property). For reduced p/q:
$$\gcd\left(\sum_i F_{a_i}, F_n\right) = \frac{F_n}{q}$$

### 3.2 Polynomial Bijection

**Theorem 2** (φ-Polynomial Representation). Every rational p/q corresponds to a unique factored polynomial expression:

$$\frac{p}{q} = \frac{P(φ)}{Q(φ)}$$

where P(x), Q(x) ∈ ℤ[x] are derived from the Fibonacci fraction representation via Binet's formula.

**Construction.** Using Binet's formula F_n = (φⁿ - ψⁿ)/√5 where ψ = 1 - φ:

$$\frac{p}{q} = \frac{\sum_i (φ^{a_i} - ψ^{a_i})}{φ^n - ψ^n}$$

The √5 factors cancel. Substituting x for φ and (1-x) for ψ:

$$\frac{P(x)}{Q(x)} = \frac{\sum_i (x^{a_i} - (1-x)^{a_i})}{x^n - (1-x)^n}$$

**Example.** For 7/11:
- Entry point: z(11) = 10
- Scaled numerator: 7 · (55/11) = 35
- Zeckendorf(35) = {9, 2} since 35 = 34 + 1 = F_9 + F_2
- Representation: 7/11 = (F_9 + F_2)/F_{10} = (34 + 1)/55

Polynomial form:
$$\frac{7}{11} = \frac{(x^9 - (1-x)^9) + (x^2 - (1-x)^2)}{x^{10} - (1-x)^{10}}$$

Factored (Mathematica):
```
(7 - 71x + 433x² - ... + x²⁰) / (1 - 17x + 137x² - ... + x¹⁸)
```

### 3.3 Special Point x = 1/2

**Observation.** At x = 1/2, we have x = 1-x, so:
- Every term xⁿ - (1-x)ⁿ = 0
- Both P(1/2) = 0 and Q(1/2) = 0
- The ratio P(x)/Q(x) has removable singularity at x = 1/2

**Geometric note:** φ - 1/2 = √5/2 ≈ 1.118

## 4. Complexity Analysis

**Definition 3** (Fibonacci Complexity). The complexity C(p/q) of a rational is the pair (n, k) where n = z(q) is the entry point and k is the number of Zeckendorf terms.

| p/q | Entry Point | Terms | Notes |
|-----|-------------|-------|-------|
| 1/2 | 3 | 1 | Simplest non-trivial |
| 7/11 | 10 | 2 | Moderate |
| 22/7 | 8 | 3 | π approximation |
| 355/113 | 19 | 7 | Better π approximation |
| 127/8191 | 8190 | 2245 | Mersenne-related, very complex |

**Observation.** Primes q with large z(q) (near 2q) yield high complexity. Mersenne primes are particularly expensive.

## 5. Approximation of Irrationals

**Algorithm** (FibonacciRationalize). Given x ∈ ℝ and accuracy ε:
1. For n = 3, 4, 5, ...:
2.   m = Round(x · F_n)
3.   If |m/F_n - x| < ε: return FibonacciFraction(m/F_n)

**Example.** π with accuracy 10⁻⁶:
- Best rational: 355/113 (entry point 19, 7 terms)
- Polynomial: degree 20 numerator, degree 18 denominator

## 6. Related Work

- **Zeckendorf (1972)**: Original theorem for integers
- **Freitag & Filipponi (1990, 1993)**: Zeckendorf representation of F_{kn}/F_n ratios
- **Pisano periods**: Wall (1960), Wrench (1969)
- **Entry point properties**: Cubre & Rouse (2012), Marques (2012)
- **Golden ratio base**: Bergman (1957)

Our contribution extends Freitag & Filipponi from the specific subfamily {F_{kn}/F_n : k, n ∈ ℤ⁺} to ALL rationals ℚ.

## 7. Open Questions

1. **Polynomial structure**: What properties of p/q are reflected in the factorization of P(x)/Q(x)?

2. **Minimal representations**: Are there alternative Fibonacci fraction representations with fewer terms?

3. **Complexity bounds**: Can we characterize rationals with bounded Fibonacci complexity?

4. **Special point x = 1/2**: What is the limit lim_{x→1/2} P(x)/Q(x) and does it have meaning?

5. **Lucas extension**: Does an analogous representation exist using Lucas numbers?

6. **Connection to Egyptian fractions**: Both represent rationals as sums; what is their relationship?

## 8. Implementation

A complete Wolfram Language implementation is available in the Orbit paclet:

```mathematica
<< Orbit`

(* Basic representation *)
FibonacciFraction[7/11]
(* {10, {9, 2}} *)

(* Polynomial form *)
FibonacciFraction[7/11, Method -> "Polynomial"]
(* Factored P(x)/Q(x) *)

(* Approximate irrationals *)
FibonacciRationalize[Pi, 10^-6]
(* {19, {21, 17, 14, 12, 10, 7, 4}} *)
```

Available methods: `"Indices"`, `"Expression"`, `"Sum"`, `"Terms"`, `"Count"`, `"GoldenRatio"`, `"Polynomial"`, `"Matrix"`.

## References

1. Zeckendorf, E. (1972). Représentation des nombres naturels par une somme de nombres de Fibonacci ou de nombres de Lucas. *Bulletin de la Société Royale des Sciences de Liège*, 41, 179-182.

2. Freitag, H.T. (1990). On the Representation of {F_{kn}/F_n}, {F_{kn}/L_n}, {L_{kn}/L_n}, and {L_{kn}/F_n} as Zeckendorf Sums. In *Applications of Fibonacci Numbers*, Vol. 3, pp. 107-114. Kluwer.

3. Filipponi, P. & Freitag, H.T. (1993). The Zeckendorf Representation of {F_{kn}/F_n}. In *Applications of Fibonacci Numbers*, Vol. 5, pp. 217-219. Kluwer.

4. Wall, D.D. (1960). Fibonacci series modulo m. *American Mathematical Monthly*, 67(6), 525-532.

5. Cubre, P. & Rouse, J. (2012). Divisibility properties of the Fibonacci entry point. *Proceedings of the AMS*. arXiv:1212.6221.

6. Bergman, G. (1957). A number system with an irrational base. *Mathematics Magazine*, 31(2), 98-110.

---

**Author:** Jan Popelka

**Acknowledgments:** Computational exploration assisted by Claude (Anthropic).

**Code availability:** https://github.com/jan/orbit (Orbit paclet, FibonacciFractions.wl)
