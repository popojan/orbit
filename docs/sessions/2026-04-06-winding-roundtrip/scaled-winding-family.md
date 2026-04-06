# Scaled Winding Matrix Family: W(n, k)

**Date:** 2026-04-06
**Status:** 🔬 NEW OBJECT — singularity structure depends non-trivially on k

## Definition

$$W^{(k)}_{np} = \left\lfloor \frac{k\,\gamma_n \ln p}{2\pi} \right\rfloor$$

For $k = 1$: standard winding matrix (period $2\pi$).
For general $k$: period $2\pi/k$, finer ($k > 1$) or coarser ($k < 1$) resolution.

## Key discovery: k=1 is the WORST scaling

Singularity rate (det = 0) for $n \times n$ matrices, $n = 3, \ldots, 25$:

| $k$ | Singular count | Rate | Notes |
|-----|---------------|------|-------|
| 1 | 17/23 | **74%** | Standard winding — worst! |
| 6 | 9/23 | 39% | $2 \cdot 3$ — factor-3 anomaly |
| 4 | 7/23 | 30% | $2^2$ |
| 7 | 4/23 | 17% | prime |
| 16 | 4/23 | 17% | $2^4$ |
| 2 | 3/23 | 13% | prime — much better than $k=1$ |
| 19 | 3/23 | 13% | prime |
| 3, 12, 15 | 2/23 | 9% | |
| 5, 11, 13, 17 | 1/23 | **4%** | Most robust |

**Doubling resolution ($k = 2$) reduces singularity from 74% to 13%.**

The most robust scalings are $k = 5, 11, 13, 17$ (primes, 1 singularity each).

## Theoretical implication

The standard winding matrix ($k = 1$) has the singular region $n = 6$–$18$
identified in the Smith decomposition analysis. This is not fundamental —
it is an artifact of the specific scaling $2\pi$. Different scalings have
different (and generally smaller) singular regions.

The ALS roundtrip works DESPITE $k = 1$ singularity because:
1. ALS uses $\Theta = W + 0.5$ (real-valued, always full rank as real matrix)
2. The roundtrip sieve corrects per-column errors
3. For $n \geq 19$ ($k = 1$) the matrix becomes full rank anyway

## The W₁ · W₂⁻¹ operator

For sizes where both $W^{(1)}$ and $W^{(2)}$ are non-singular:

$$T = W^{(1)} \cdot (W^{(2)})^{-1}$$

is an integer matrix (when both det = ±1) with small entries (max ≤ 3)
and eigenvalues $O(1)$. It maps the $k = 2$ representation to $k = 1$.

For 7×7: $W^{(1)}$ is singular (rank 6) but $W^{(2)}$ is unimodular (det = 1).
So $T = W^{(1)} \cdot (W^{(2)})^{-1}$ has one zero eigenvalue — it projects
onto the 6D subspace spanned by $W^{(1)}$.

## Singularity patterns by n

| $n$ | Singular $k$ values | Pattern |
|-----|--------------------|---------| 
| 3 | {1} | only standard |
| 4–5 | {6} | factor-3 only |
| 6–9 | {1, 6} | standard + factor-3 |
| 10–13 | {1, 2, 4, 6, 7, ...} | proliferation |
| 14–18 | {1, 3, 4, ...} | k=6 disappears, k=4 persists |
| 19+ | {4} or {} | singularities rare |

The "singularity proliferation" at $n \approx 10$–$13$ then cleanup at
$n \geq 19$ mirrors the Smith form transition from the earlier analysis.

## Never-singular scalings

Full survey over rational $k = p/q$ ($q \leq 20$) and special irrationals,
testing $n = 3, \ldots, 35$:

**Only two values are NEVER singular:**

| $k$ | Value | Sing count | Identity |
|-----|-------|-----------|----------|
| **11/4** | 2.75 | **0/33** | 4th convergent of $e$ |
| **$2\pi$** | 6.283... | **0/33** | $\lfloor\gamma_n\ln p\rfloor$ (no division) |

### The $e$ connection

$e = [2; 1, 2, 1, 1, 4, 1, 1, \ldots]$, convergents: $2, 3, 8/3, \mathbf{11/4}, 19/7, 87/32, \ldots$

| Convergent | Value | Singularities |
|-----------|-------|--------------|
| 2 | 2.000 | 3/33 |
| 8/3 | 2.667 | 4/33 |
| **11/4** | **2.750** | **0/33** ★ |
| 19/7 | 2.714 | 4/33 |
| 87/32 | 2.719 | 1/33 |
| 193/71 | 2.718 | 3/33 |
| $e$ exact | 2.718... | 3/33 |

**11/4 is BETTER than $e$ itself.** Higher convergents (closer to $e$)
are WORSE. The optimum is not at $e$ but at its 4th convergent.

### Why $e$?

The zero-counting function is $N(T) \approx \frac{T}{2\pi}\ln\frac{T}{2\pi\mathbf{e}}$.
The constant $e$ appears as the normalizing factor for the logarithmic
density of zeros. The scaling $k \approx e$ makes the winding matrix
entries "align" with the zero-counting — each row increment corresponds
to roughly one zero, minimizing rank deficiency.

Why 11/4 specifically (not $e$ exactly): unknown. May relate to the
continued fraction structure of $e$ interacting with the floor function
at the specific sizes $n = 3, \ldots, 35$.

### Convergents of $2\pi$ inherit the property

$2\pi = [6; 3, 1, 1, 7, 2, 146, \ldots]$, convergents: $6, 19/3, 25/4, 44/7, 333/53, 710/113, \ldots$

| Convergent | Value | Sing (n=3..50) |
|-----------|-------|---------------|
| 6 | 6.000 | 9/48 |
| 19/3 | 6.333 | 1/48 |
| **25/4** | **6.250** | **0/48** ★ |
| 44/7 | 6.286 | 1/48 |
| **333/53** | **6.283** | **0/48** ★ |
| **710/113 and all higher** | **→ 2π** | **0/48** ★ |

From the 3rd convergent (25/4) onward, ALL convergents of $2\pi$ are
never-singular. The property "belongs to" $2\pi$ and its good rational
approximations inherit it.

### Why $2\pi$?

$W^{(2\pi)}_{np} = \lfloor\gamma_n\ln p\rfloor$: the "raw" product
without any division. This matrix has the largest entries (max entry
grows as $\gamma_n \ln p_n$), giving maximum resolution. Full rank is
expected for large enough entries (floor noise becomes relatively small).

Note: $k = 2\pi$ and $k = 11/4$ are verified never-singular up to
$n = 100$ (98 consecutive non-singular matrices).

## Open questions

1. **Is $k = 11/4$ never-singular for ALL $n$?** Verified to $n = 40$,
   but no proof. Could fail for large $n$.

2. **Why 11/4 specifically?** It is the 4th convergent of both $e$ and
   $1 + \sqrt{3}$, but NEITHER $e$ nor $1 + \sqrt{3}$ is never-singular
   ($e$: 3/48, $1+\sqrt{3}$: 6/48). The rationality of 11/4 seems
   essential. Also: 36/13 ≈ 2.769 is never-singular but is NOT a
   convergent of any tested combination of $e$, $\pi$, or algebraic numbers.
   Chebyshev-related values $1 + 2\cos(\pi/m)$ are never optimal.
   **Why 11/4 remains unexplained.**

3. **Connection to Chebyshev:** The scaling $k$ multiplies the argument
   of Floor. In the orbit framework, $T_k(\cos\theta) = \cos(k\theta)$ —
   Chebyshev polynomial of order $k$. Is $W^{(k)}$ related to $T_k$ applied
   to the winding matrix?

4. **ALS with optimal $k$:** Does ALS roundtrip work better with
   $k = 11/4$ or $k = 2\pi$ than with $k = 1$? (Expected yes, since
   non-singular matrices should give better rank-1 recovery.)
