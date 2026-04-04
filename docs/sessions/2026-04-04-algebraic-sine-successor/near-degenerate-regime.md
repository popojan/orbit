# Near-Degenerate Regime: Almost Counting

**Date:** 2026-04-04
**Status:** ✅ PROVEN (Taylor expansion, turnaround ratio)

## Setup

The degenerate point $\alpha = 2$ ($\theta = 0$) gives the naturals: $f_k = k + 1$.

Moving slightly away: $\alpha = 2\cos\theta$ with small $\theta > 0$.
The orbit is $f_k = U_k(\cos\theta) = \sin((k+1)\theta)/\sin\theta$.

## Taylor Expansion Around $\theta = 0$

$$f_k = \frac{\sin((k+1)\theta)}{\sin\theta} = (k+1) - \binom{k+2}{3}\theta^2 + a_2(k)\,\theta^4 - \cdots$$

The leading correction to the naturals:

$$\boxed{f_k \approx (k+1) - \frac{k(k+1)(k+2)}{6}\,\theta^2}$$

The orbit **undercounts**: $f_k < k + 1$ for all $k \geq 1$ (first term is exact at $k = 0$).

### Fractional deviation

$$\frac{f_k - (k+1)}{k+1} \approx -\frac{k^2 + 2k}{6}\,\theta^2$$

Grows quadratically in $k$. The orbit tracks the naturals as long as
$k \ll \sqrt{6}/\theta \approx 2.45/\theta$.

## The Orbit "Counts Then Curves"

For quasi-period $T = 2\pi/\theta$ (or exact period $2q$ with $\theta = \pi/q$):

| Phase | Steps | Behavior |
|---|---|---|
| Count up | $0 \leq k < q/2$ | $f_k \approx k + 1$ (tracks naturals) |
| Curve & peak | $k \approx q/2$ | Maximum, then starts decreasing |
| Count down | $q/2 < k < q$ | Descends toward zero |
| Zero crossing | $k = q - 1$ | $f_k = 0$ exactly |
| Negative mirror | $q \leq k < 2q$ | $f_k < 0$ (mirror image) |
| Return | $k = 2q$ | Back to $f_0$ (period complete) |

The orbit is a **truncated number line**: it counts up to approximately $q/\pi$,
then curves back. The naturals are the limit where the number line never curves back
($q \to \infty$).

## The Universal $2/\pi$ Ratio

At the peak ($k \approx q/2 - 1$), the orbit reaches:

$$f_{\max} = \frac{1}{\sin\theta}$$

The naturals would give $k + 1 \approx \pi/(2\theta)$. The ratio:

$$\boxed{\frac{f_{\max}}{k_{\max} + 1} = \frac{2\theta}{\pi\sin\theta} \;\xrightarrow{\theta \to 0}\; \frac{2}{\pi} \approx 0.6366}$$

The orbit reaches **at most $2/\pi$ of the natural count** before turning around.
This ratio is universal — independent of $\theta$.

The factor $2/\pi$ is the average value of $|\sin x|$ over a full period,
and appears in the Buffon needle problem.

## What This Means

The natural numbers are the **infinite-period limit** of a family of "counting then
curving" orbits. Each finite-period orbit:

1. Starts by faithfully counting: $f_0 = 1, f_1 \approx 2, f_2 \approx 3, \ldots$
2. Gradually falls behind: $f_k \approx (k+1)(1 - k^2\theta^2/6)$
3. Peaks at $2/\pi$ of the linear prediction
4. Curves back to zero and enters the negative half-cycle

The correction $-\binom{k+2}{3}\theta^2$ has a combinatorial interpretation:
$\binom{k+2}{3}$ counts the number of 3-element subsets of $\{0, 1, \ldots, k+1\}$.
The "accumulated debt" from not-quite-counting grows as the number of triples.

### The $\theta \to 0$ limit

As $\theta \to 0$:
- Period $\to \infty$: the orbit never turns back
- Peak $\to \infty$: no maximum
- Correction $\to 0$: orbit matches naturals exactly
- $2/\pi$ ratio: approaches but never equals 1 at finite $\theta$

The naturals are the **unique** orbit with no turnaround.
