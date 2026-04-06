# Honest Assessment: What We Have and What We Don't

**Date:** 2026-04-06
**Context:** End-of-session reflection after building the full roundtrip pipeline

## What is a proven fact

1. **The winding matrix exists.** $W_{np} = \lfloor\gamma_n\ln p/(2\pi)\rfloor$
   is a well-defined integer matrix, approximately rank 1 by construction.
   Does not depend on RH — only requires that zeros on the critical line
   exist (Hardy 1914: infinitely many).

2. **ALS converges in 1 iteration** to the best rank-1 approximation of
   $\Theta = W + \frac{1}{2}$. This is linear algebra (Eckart–Young theorem),
   not a conjecture.

3. **γ recovery precision scales as $O(1/\sqrt{n})$** with matrix size.
   More columns (primes) improve each zero estimate. Verified numerically,
   consistent with averaging of i.i.d. floor noise.

## What is a new conjecture

> **Winding Roundtrip Conjecture:** For all sufficiently large $n$,
> the ALS algorithm applied to $\Theta = W_{n\times n} + \frac{1}{2}$,
> with lattice snap (OddQ for $j > 1$, scale fixed by $\ell_1 = \ln 2$),
> recovers all $n$ primes correctly.

This is stated in the language of **integers and linear algebra** — no
complex analysis, no $\zeta$ function, no contour integrals.

Verified numerically up to $n = 100$ (100/100 primes correct).

### Relationship to RH

The conjecture does **not** assume RH and does **not** imply RH.

- If RH holds: all $\gamma_n$ are real, $W$ is "complete."
- If RH fails: some zeros are off the critical line and absent from $W$.
  The roundtrip still works on the submatrix of critical-line zeros.

The conjecture is **weaker than RH** in that it doesn't assert where zeros
lie. But there is a subtler connection:

### What happens if RH fails? (CORRECTED)

For a zero $\rho = \sigma + i\gamma$ off the critical line: the winding
number $\lfloor\gamma\ln p/(2\pi)\rfloor$ depends only on $\gamma$,
not on $\sigma$. And from the functional equation, zeros come in pairs
$(\sigma + i\gamma, (1-\sigma) + i\gamma)$ with the **same imaginary part**.
Both give the **same row** in $W$.

Consequences:

1. **No missing rows.** $N(T)$ counts ALL zeros (on or off line).
   The matrix always has the correct number of rows.

2. **$\sigma$ is invisible.** The winding matrix encodes phases
   ($\gamma\ln p \bmod 2\pi$) but not amplitudes ($p^{-\sigma}$).
   Two zeros with the same $\gamma$ but different $\sigma$ produce
   identical rows.

3. **The winding matrix is RH-agnostic.** It works identically whether
   RH holds or not. It cannot prove or disprove RH because $\sigma$
   does not appear in the Floor formula.

The roundtrip conjecture is independent of RH in a **strong sense**:
not merely "does not assume RH" but "cannot even see whether RH holds."
The matrix is a projection of the zero-prime duality onto the phase
space, with the amplitude ($\sigma$) dimension discarded.

## What is genuinely new vs. reformulation

### The duality is NOT new

Primes ↔ zeros is the explicit formula (Riemann 1859, von Mangoldt 1895).
The Euler product encodes primes; the Hadamard product encodes zeros.
The winding matrix is a DISCRETIZATION of this known duality.

### What IS new

1. **The discrete perspective.** The explicit formula is analytic
   (sums, integrals, meromorphic continuation). The winding matrix is
   integer (Floor, rank-1, Smith normal form). These are different
   mathematical worlds with different tools.

2. **OddQ is minimal.** The only "primality" information needed for
   the roundtrip is $\mathrm{Mod}(n, 2)$. This is a statement about
   the integer structure of $\lfloor a_n\ell_j\rfloor$, invisible
   to the analytic formulation. The analytic theory never says
   "2-adic information suffices" — that's a Floor artifact.

3. **Smith form structure.** The winding matrix has trivial invariant
   factors (all 1 except possibly the last). This says: the integer
   rows of $W$ are "as independent as possible" — the minors generate
   $\mathbb{Z}$. This is a number-theoretic statement about
   $\lfloor\gamma_n\ln p/(2\pi)\rfloor$ that has no analytic counterpart.

4. **Constraint-reconstruction.** The possibility of determining $W$
   from purely arithmetic constraints (rank-1 + integer + monotone + π)
   is a new question. If a finite set of constraints uniquely determines
   $W$, both primes and zeros EMERGE from integer optimization — neither
   is input. This is not a reformulation of anything classical.

## What is circular / not original

1. **The "from π" pipeline** is Eratosthenes + $\theta(T)$ in matrix
   notation. The bootstrap discovers primes the same way a sieve does.
   The matrix formalism adds no computational advantage here.

2. **The roundtrip itself** can be viewed as: "if you encode two sequences
   as $\lfloor a_n b_j\rfloor$, you can decode them." This is a general
   statement about multi-base floor representations, not specific to
   number theory. The NUMBER-THEORETIC content is in WHY $W$ has the
   structure it has (near rank-1, trivial Smith factors, etc.), not in
   the decoding algorithm.

## The real question going forward

Does the integer structure of $W$ (Smith form, constraint-reconstruction,
scaling behavior) reveal anything about primes or zeros that the analytic
theory CANNOT see?

Preliminary evidence:
- **3×3 enumeration** (running): how many rank-1 floor matrices with
  $W_{11} = 1$ exist? If very few, the structure is highly constrained
  and might determine $W$ with minimal external input.
- **Scaling of constraints**: larger matrices are more overdetermined
  ($(n-1)^2$ excess constraints). If small cases ($n = 3, 4$) pin down
  the structure, everything follows — a potential 290-theorem analogy.

If the answer is yes: the winding matrix is a genuinely new object
in number theory, connecting integer optimization to the prime-zero duality.

If the answer is no: we have a clean reformulation with nice notation
but no new theorems. Still publishable, but not deep.

**Current assessment: promising but unresolved.** The 3×3 enumeration
and constraint-reconstruction scaling will determine which way it goes.

## On the role of RH and ζ in our program

### What we owe to Riemann

The prime-zero duality does not exist without ζ. Without Riemann's
1859 paper, we would not know that primes have a "dual" description
through zeros of an analytic function. The explicit formula — the
identity that connects Λ(n) to a sum over zeros — is what makes the
winding matrix meaningful. Without it, W would just be a table of
integers with no interpretation.

The ζ function is the DISCOVERY TOOL. It revealed that primes are
not random but are controlled by oscillatory components indexed by
zeros. This is one of the deepest insights in mathematics.

### What the winding matrix does with that insight

The winding matrix translates the analytic duality into discrete,
integer language:

$$\underbrace{\gamma_n \ln p}_{\text{analytic (continuous)}}
= \underbrace{2\pi\, W_{np}}_{\text{integer (discrete)}}
+ \underbrace{2\pi\, R_{np}}_{\text{residual (continuous)}}$$

The Floor function discretizes. The ALS recovers. The roundtrip closes.

This translation is NOT a replacement for ζ. It is a CONSEQUENCE of ζ,
reformulated so that different mathematical tools apply (integer
programming, lattice theory, Smith normal form) instead of complex
analysis.

### RH in this perspective

The Riemann Hypothesis says: all non-trivial zeros satisfy Re(ρ) = 1/2.

The winding matrix is σ-agnostic: $W_{np} = \lfloor\gamma_n\ln p/(2\pi)\rfloor$
depends only on the imaginary part γ, not on the real part σ.
Two zeros at σ + iγ and (1−σ) + iγ produce identical rows.

This means:
- **RH is about amplitudes** (how strongly each oscillatory component
  contributes to the explicit formula: weight ∝ x^σ).
- **The winding matrix is about phases** (where the oscillations are:
  the discrete pattern of Floor values).

For the DISCRETE question "which integers are prime," only phases
matter — and the winding matrix captures these completely. For the
CONTINUOUS question "how fast does π(x) converge to Li(x)," amplitudes
matter — and the winding matrix is blind to them.

Our program studies the discrete skeleton of the duality. RH lives in
the continuous flesh. These are complementary perspectives, not
competing ones.

### The path that led here

The winding matrix emerged from a chain of explorations:

1. **Pell regulator chaos**: studying the apparent randomness of
   Pell equation regulators led to investigating what controls
   number-theoretic "randomness."

2. **Successor orbit recurrence**: the +1 operation on Chebyshev
   seeds ($T_k(\cos\theta) = \cos(k\theta)$) produced a discrete
   dynamical system on $[-1, 1]$. The orbit of a seed under
   $x \mapsto T_k(x)$ wraps the circle $k$ times — a winding.

3. **ψ orbit identity**: connecting Chebyshev orbits to ζ's explicit
   formula revealed that $\psi(e^k)$ decomposes into orbit
   contributions $T_k(\cos(\gamma_n \ln p))$.

4. **Interaction matrix**: $M_{np} = \cos(\gamma_n \ln p)$ as the
   meeting point of primes and zeros. Row sums detect primes,
   column sums detect zeros — the duality made visible.

5. **Linearization**: $\gamma_n \ln p = 2\pi W_{np} + \theta_{np}$
   — the integer winding numbers as the "barrier" to inverting the
   cosine map. But the barrier turned out to be the solution.

6. **Roundtrip**: ALS + lattice snap recovers both primes and zeros
   from the integer matrix alone. The discrete skeleton suffices.

The ζ function was the guide at every step — without it, there is no
duality to discretize. But the end result is a framework that stands
on integers, Floor, and linear algebra. The transcendental origin
(ζ, Γ, π) has been distilled into a single constant (π, through
the factor 2π in the Floor) and a structural principle (rank-1
integer matrix with lattice-constrained columns).

Whether this discrete perspective leads to genuinely new results
remains open. But the perspective itself — the explicit, computable,
integer encoding of the prime-zero duality — seems worth preserving
regardless of what the experiments show.
