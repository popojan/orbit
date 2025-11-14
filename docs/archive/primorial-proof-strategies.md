# Proof Strategies for the Primorial Conjecture

**Goal:** Prove the core conjecture from the primorial paper:

> Let $S_m = \frac{1}{2} \sum_{k=1}^{\lfloor(m-1)/2\rfloor} \frac{(-1)^k \cdot k!}{2k+1}$, and write $S_m = n/d$ (not necessarily in lowest terms). Then for all primes $p$ with $2 \leq p \leq m$:
>
> $$\nu_p(d) - \nu_p(n) = 1$$

where $\nu_p(n)$ denotes the $p$-adic valuation (exponent of $p$ in the prime factorization of $n$).

**Status:** Verified computationally for all $m$ up to 1,000,000.

---

## Overview of Approaches

This document outlines several potential proof strategies, ranging from constructive (tracking the computation) to abstract (closed-form analysis). Each approach has different strengths and technical requirements.

---

## Approach 1: Dynamic Cancellation Tracking

### Main Idea

Track how $\nu_p(\text{numerator})$ and $\nu_p(\text{denominator})$ evolve as we progressively add each term $\frac{(-1)^k \cdot k!}{2k+1}$ to build the partial sum.

### Key Observations

Let $S_k^{\text{partial}} = \frac{1}{2} \sum_{j=1}^{k} \frac{(-1)^j \cdot j!}{2j+1} = \frac{N_k}{D_k}$ be the partial sum after $k$ terms.

1. **Denominator evolution**: When adding term $k$, the new denominator must incorporate $2k+1$ via LCM:
   $$D_{k} = \text{LCM}(D_{k-1}, 2k+1)$$

2. **Prime power contribution**: If $2k+1 = p^j q$ where $p \nmid q$, then:
   $$\nu_p(D_k) = \max(\nu_p(D_{k-1}), j)$$

3. **Numerator response**: To maintain $\nu_p(D_k) - \nu_p(N_k) = 1$, when $\nu_p(D_k)$ increases by $\Delta$, the numerator must gain exactly $\Delta$ factors of $p$ through the sum structure.

### Sub-strategies

#### 1.1 Induction on Terms

**Inductive hypothesis**: After adding term $k$, the invariant $\nu_p(D_k) - \nu_p(N_k) = 1$ holds.

**Base case**: $k=1$ gives $S_1 = \frac{1}{2} \cdot \frac{-1!}{3} = \frac{-1}{6}$
- For $p=2$: $\nu_2(6) - \nu_2(1) = 1 - 0 = 1$ ✓
- For $p=3$: $\nu_3(6) - \nu_3(1) = 1 - 0 = 1$ ✓

**Inductive step**: Assume true for $S_{k-1} = \frac{N_{k-1}}{D_{k-1}}$. Show that adding $\frac{(-1)^k \cdot k!}{2k+1}$ preserves the property.

**Key technical challenge**: When we compute
$$S_k = S_{k-1} + \frac{(-1)^k \cdot k!}{2k+1} = \frac{N_{k-1} \cdot (2k+1) + (-1)^k \cdot k! \cdot D_{k-1}}{D_{k-1} \cdot (2k+1)}$$

before GCD reduction, we need to understand $\nu_p$ of the combined numerator.

#### 1.2 Legendre's Formula for Factorials

Use **Legendre's formula** to track factorial contributions:
$$\nu_p(k!) = \sum_{i=1}^{\infty} \left\lfloor \frac{k}{p^i} \right\rfloor$$

**Example**: For $p=3$, $k=10$:
$$\nu_3(10!) = \left\lfloor \frac{10}{3} \right\rfloor + \left\lfloor \frac{10}{9} \right\rfloor + \left\lfloor \frac{10}{27} \right\rfloor + \cdots = 3 + 1 + 0 + \cdots = 4$$

This gives precise control over how many factors of $p$ each factorial contributes.

#### 1.3 Kummer's Theorem Connection

**Kummer's theorem**: $\nu_p\binom{m+n}{m}$ equals the number of carries when adding $m$ and $n$ in base $p$.

While our sum doesn't directly involve binomial coefficients, the alternating factorial structure may relate to Kummer-type carrying arguments.

### Advantages

- **Constructive**: Shows explicitly HOW the cancellation happens
- **Follows computation**: Directly models the observed phenomenon
- **Two regimes**: Can potentially explain the "GCD cancellation vs integer terms" dichotomy
- **Tractable**: Uses well-understood tools (Legendre's formula)

### Challenges

- Alternating signs create complex numerator interactions
- Terms interact non-locally (previous partial sum + new term)
- Must handle both prime and composite values of $2k+1$
- GCD reduction step is non-trivial to track

---

## Approach 2: Closed-Form Analysis

### Main Idea

Express the unreduced numerator $N_m$ and denominator $D_m$ in closed form, then analyze their $p$-adic valuations directly without tracking the sum's evolution.

### Formulas

**Unreduced denominator:**
$$D_m = 2 \cdot \text{LCM}(3, 5, 7, \ldots, 2\lfloor(m-1)/2\rfloor+1)$$

The factor of 2 comes from the explicit $\frac{1}{2}$ in $S_m$.

**Unreduced numerator:**
$$N_m = \sum_{k=1}^{\lfloor(m-1)/2\rfloor} (-1)^k \cdot k! \cdot \frac{D_m/2}{2k+1}$$

Note: $\frac{D_m/2}{2k+1}$ is always an integer since $D_m/2$ contains all odd terms in the LCM.

### Key Observations

For a prime $p \leq m$:

1. **Denominator valuation**:
   $$\nu_p(D_m) = \max\{\nu_p(2k+1) : 1 \leq k \leq \lfloor(m-1)/2\rfloor\}$$

   - If $p=2$: $\nu_2(D_m) = 1$ (from the explicit factor)
   - If $p$ is odd: $\nu_p(D_m) = \lfloor \log_p(m) \rfloor$ (largest power of $p$ that fits as $2k+1 \leq m$)

2. **Numerator structure**: The sum alternates in sign and involves products of factorials with structured integer coefficients $\frac{D_m/2}{2k+1}$.

### Sub-strategies

#### 2.1 Modular Analysis

Work modulo $p^{\nu_p(D_m)}$ and show:
$$N_m \equiv 0 \pmod{p^{\nu_p(D_m)-1}} \quad \text{but} \quad N_m \not\equiv 0 \pmod{p^{\nu_p(D_m)}}$$

This would directly prove $\nu_p(N_m) = \nu_p(D_m) - 1$.

**Technical approach:**
- Identify which terms in the sum contribute to $N_m \bmod p^j$
- Use factorial valuations via Legendre's formula
- Analyze cancellations in the alternating sum

#### 2.2 Generating Functions

Express the alternating factorial sum in terms of a generating function or integral representation:
$$\sum_{k=1}^{\infty} \frac{(-1)^k k!}{2k+1} x^{2k+1}$$

Truncate appropriately and study the $p$-adic properties of the coefficients or special values.

#### 2.3 Connection to Special Functions

Investigate if $S_m$ relates to:
- Exponential integrals $\text{Ei}(x)$
- Error functions $\text{erf}(x)$
- Incomplete gamma functions $\Gamma(a, x)$
- Other special functions with known $p$-adic properties

### Advantages

- **Direct**: If successful, gives complete characterization without tracking dynamics
- **Fundamental**: May reveal deeper structure connecting to other areas of number theory
- **Closed-form**: Provides explicit formulas for both numerator and denominator

### Challenges

- **No simple closed form known**: The alternating factorial sum doesn't have an elementary closed form
- **Subtle interactions**: How $k!$ and $(2k+1)$ divisibility interact is highly non-obvious
- **Technically demanding**: Requires sophisticated algebraic manipulation

---

## Approach 3: Induction on Primes

### Main Idea

Fix a prime $p$ and prove the property $\nu_p(d) - \nu_p(n) = 1$ holds for all $m \geq p$ by induction on $m$.

### Structure

**Base case:** Verify for the smallest $m \geq p$ where $p$ first appears in the LCM.
- For $p=2$: $m=3$ (first term)
- For odd $p$: $m=p$ (when $2k+1=p$ for $k=(p-1)/2$)

**Inductive step:** Show that if the property holds for $S_m$, it also holds for $S_{m+1}$ or $S_{m+2}$ (depending on parity).

### Key Questions

1. **When does $\nu_p(D_m)$ change?**
   - Only when we add a term $\frac{k!}{2k+1}$ where $2k+1$ contains a higher power of $p$ than previously seen
   - This happens at $2k+1 = p^j$ for $j \geq 2$

2. **What happens when $\nu_p(D_m)$ increases?**
   - Need to show the numerator also gains factors of $p$ at exactly the rate to maintain difference = 1
   - This reduces to analyzing the specific term that causes the increase

3. **What happens when $\nu_p(D_m)$ stays constant?**
   - Must show the new term doesn't disrupt the existing balance
   - Likely easier case

### Advantages

- **Prime-by-prime**: Focus on one prime at a time, simplifying the analysis
- **Structured**: Clear induction framework
- **Leverages computation**: 1M verification provides strong base case coverage

### Challenges

- May reduce to Approach 1 in disguise (tracking consecutive partial sums)
- Need to carefully handle the two cases (denominator changes vs stays same)
- Inductive step may still require understanding global cancellation structure

---

## Approach 4: P-adic Function Theory

### Main Idea

View the alternating factorial sum as a $p$-adic function and use techniques from $p$-adic analysis (continuity, convergence, special functions).

### Potential Connections

#### 4.1 P-adic Gamma Function

The **Morita $p$-adic gamma function** $\Gamma_p(x)$ extends the factorial to $p$-adic numbers. It satisfies:
$$\Gamma_p(n) = (-1)^n \prod_{\substack{1 \leq k < n \\ p \nmid k}} k$$

Our sum involves $k!$, which may relate to $\Gamma_p$ evaluations.

#### 4.2 Volkenborn Integral

The **Volkenborn integral** provides a $p$-adic integration theory over $\mathbb{Z}_p$:
$$\int_{\mathbb{Z}_p} f(x) \, d\mu = \lim_{n \to \infty} \frac{1}{p^n} \sum_{a=0}^{p^n-1} f(a)$$

Could the alternating factorial sum be expressed as a Volkenborn integral?

#### 4.3 P-adic L-functions

$P$-adic $L$-functions interpolate special values of classical $L$-functions $p$-adically. The relationship between factorials and Bernoulli numbers suggests a potential connection.

#### 4.4 Mahler Expansion

Every continuous $p$-adic function $f: \mathbb{Z}_p \to \mathbb{Q}_p$ has a **Mahler expansion**:
$$f(x) = \sum_{n=0}^{\infty} a_n \binom{x}{n}$$

Could we express $S_m$ or related quantities in this basis and analyze the coefficients $a_n$?

### Advantages

- **Deep connections**: If successful, may relate primorials to fundamental $p$-adic structures
- **Powerful techniques**: $P$-adic analysis has sophisticated tools unavailable in classical analysis
- **Potential generalization**: May reveal broader patterns beyond this specific sum

### Challenges

- **Highly advanced**: Requires deep knowledge of $p$-adic analysis
- **Connection unclear**: Not obvious that such a connection exists
- **May be overkill**: The problem might have an elementary solution that doesn't require this machinery

---

## Approach 5: Computer-Assisted Proof

### Main Idea

Use computational verification combined with effective bounds to reduce the infinite conjecture to a finite (but large) verification problem.

### Strategy

1. **Prove effective bounds**: Show that if the conjecture holds for all $m \leq M$ (some computable bound), then it holds for all $m$.

2. **Bound derivation**: Find $M$ such that the structure becomes "regular enough" that induction or asymptotic analysis takes over.

3. **Computational verification**: Verify up to $M$ (we already have $M = 10^6$).

### Effective Bound Techniques

- **Asymptotic analysis**: For large $k$, the terms $\frac{k!}{2k+1}$ become integers (since $\nu_p(k!) > \nu_p(2k+1)$ for large $k$)
- **Finite index**: Only finitely many $k$ contribute to $\nu_p(D_m)$ for fixed $p$ and $m$
- **Computational bounds**: May be possible to show that after a certain point, the pattern is forced

### Advantages

- **Practical**: Combines proof techniques with existing computational evidence
- **Rigorous**: Can achieve full mathematical proof if effective bound is proven
- **Incremental**: Can strengthen bounds over time

### Challenges

- **Finding the bound**: Deriving effective $M$ may be as hard as proving the original conjecture
- **Large $M$**: The bound might be computationally infeasible
- **Not explanatory**: Doesn't provide insight into WHY the phenomenon occurs

---

## Recommendation: Start with Approach 1 (Dynamic Tracking)

### Why This Approach?

1. **Computational evidence**: The "two cancellation mechanisms" observed in the paper suggest tracking term-by-term reveals structure

2. **Well-understood tools**: Legendre's formula for $\nu_p(k!)$ is elementary and computable

3. **Matches the phenomenon**: The step function behavior in orbit lengths corresponds to denominator jumps

4. **Tractable**: More accessible than abstract approaches (2, 4) while being more constructive than prime-by-prime induction (3)

### Concrete First Steps

#### Step 1: Small Example (p=3, m=13)

Track $\nu_3$ through the computation:

| $k$ | $2k+1$ | $\nu_3(k!)$ | $\nu_3(2k+1)$ | $\nu_3(D_k)$ | $\nu_3(N_k)$ | Difference |
|-----|--------|-------------|---------------|--------------|--------------|------------|
| 1   | 3      | 0           | 1             | 1            | 0            | 1          |
| 2   | 5      | 0           | 0             | 1            | ?            | 1          |
| 3   | 7      | 1           | 0             | 1            | ?            | 1          |
| 4   | 9      | 1           | 2             | 2            | ?            | 1          |
| 5   | 11     | 2           | 0             | 2            | ?            | 1          |
| 6   | 13     | 2           | 0             | 2            | ?            | 1          |

**Goal**: Fill in $\nu_3(N_k)$ and verify difference remains 1. Understand mechanically WHY at $k=4$ (when $2k+1=9=3^2$) the numerator gains exactly one factor of 3.

#### Step 2: Legendre Formula Analysis

For each critical $k$ where $\nu_p(D_k)$ jumps:
- Compute $\nu_p(k!)$ using Legendre's formula
- Analyze the coefficient $\frac{D_{k-1}}{2k+1}$
- Determine how many factors of $p$ the term $\frac{k! \cdot D_{k-1}}{2k+1}$ contributes to the combined numerator

#### Step 3: General Pattern Recognition

Look for patterns across different primes:
- Is there a uniform formula for when jumps occur?
- Does the alternating sign structure play a special role?
- Are there symmetries or recursions in the $\nu_p$ sequences?

#### Step 4: Formalize the Induction

Once the pattern is clear, formalize as an inductive proof:
- **Invariant**: $\nu_p(D_k) - \nu_p(N_k) = 1$ after term $k$
- **Preservation**: Show adding term $k+1$ maintains the invariant
- **Separate cases**: Jump case ($\nu_p(D_{k+1}) > \nu_p(D_k)$) vs non-jump case

---

## Open Questions for Investigation

1. **Closed form numerator**: Is there a closed-form expression for $N_m$ that makes the $p$-adic structure transparent?

2. **Connection to other sequences**: Does the alternating factorial sum relate to other known integer sequences (OEIS)?

3. **Generalization**: Does the property hold for other alternating sums like $\sum \frac{(-1)^k k!}{ak+b}$?

4. **Prime-specific behavior**: Are there primes where the pattern is simpler or more revealing?

5. **Asymptotic regime**: Can we prove the conjecture holds for all sufficiently large $m$ using asymptotic analysis?

6. **Bernoulli connection**: Alternating factorial sums sometimes relate to Bernoulli numbers - is there a connection here?

---

## References for Further Study

### P-adic Valuations and Factorials
- **Legendre's formula**: $\nu_p(n!) = \sum_{i=1}^{\infty} \lfloor n/p^i \rfloor$
- **Kummer's theorem**: Carries in base-$p$ addition
- **Fine, N.J.** "Binomial coefficients modulo a prime"

### P-adic Analysis
- **Robert, A.M.** *A Course in p-adic Analysis*
- **Koblitz, N.** *P-adic Numbers, p-adic Analysis, and Zeta-Functions*
- **Schikhof, W.H.** *Ultrametric Calculus*

### Alternating Series and Special Functions
- **Graham, Knuth, Patashnik** *Concrete Mathematics* (Chapter 5: Binomial Coefficients)
- **Flajolet, Sedgewick** *Analytic Combinatorics* (generating functions)

### Computational Number Theory
- **Cohen, H.** *A Course in Computational Algebraic Number Theory*
- **Bach, Shallit** *Algorithmic Number Theory*

---

## Computational Tools for Exploration

```mathematica
(* Track p-adic valuation through partial sums *)
TrackValuation[m_, p_] := Module[{terms, partial, vals},
  terms = Table[(-1)^k * k! / (2k+1), {k, 1, Floor[(m-1)/2]}];
  partial = FoldList[Plus, 0, terms];
  vals = Table[
    {k,
     IntegerExponent[Denominator[partial[[k]]], p],
     IntegerExponent[Numerator[partial[[k]]], p],
     IntegerExponent[Denominator[partial[[k]]], p] -
       IntegerExponent[Numerator[partial[[k]]], p]
    },
    {k, 2, Length[partial]}
  ];
  vals
]

(* Example: Track ν_3 for m=13 *)
TrackValuation[13, 3]
```

Expected output format:
```
{{k, ν_p(d), ν_p(n), difference}, ...}
```

This provides empirical data to guide proof development.

---

**Next steps**: Implement the tracking computation for small examples and look for patterns that can be formalized into a proof.
