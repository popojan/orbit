# RH in Orbit Language: Working Notes

**Status:** Working intuition, not a proof attempt

## From Counting to Corrections

### Step 1: Perfect counting

The successor recurrence with $o = 1$ gives the naturals:

$$f_k = k + 1 \qquad (1, 2, 3, 4, 5, \ldots)$$

This is the **degenerate case** ($c = 1$, $\theta = 0$). In the zeta world,
it corresponds to the **pole at $s = 1$**, which gives the main term:

$$\psi(x) \approx x$$

"Ideal world" where primes are perfectly uniformly distributed.

### Step 2: Reality deviates

Primes are NOT uniformly distributed. The actual prime counting function
$\psi(x) = \sum_{n \leq x} \Lambda(n)$ deviates from $x$:

| $x$ | $\psi(x)$ | $x$ | Deviation |
|-----|-----------|-----|-----------|
| 10 | 7.83 | 10 | $-2.17$ |
| 100 | 94.05 | 100 | $-5.95$ |
| 1000 | 996.68 | 1000 | $-3.32$ |

The deviation $\psi(x) - x$ oscillates — sometimes positive, sometimes negative.

### Step 3: Decomposition into orbits

The explicit formula decomposes the deviation into a sum of sinusoidal waves,
one for each nontrivial zero $\rho_n = \frac{1}{2} + i\gamma_n$ of $\zeta(s)$:

$$\psi(x) = \underbrace{x}_{\substack{\text{main term} \\ \text{(degenerate orbit, } c=1\text{)}}}
\;-\; \sum_n \underbrace{\frac{2\sqrt{x}}{|\rho_n|} \cos(\gamma_n \ln x + \phi_n)}_{\substack{\text{correction from zero } \rho_n \\ \text{(oscillatory orbit, } c_n = \cos\gamma_n\text{)}}}
\;-\; \ln(2\pi) - \ldots$$

Each correction IS an orbit:

| Component | Orbit parameter | Role |
|-----------|-----------------|------|
| Main term $x$ | $c = 1$ (degenerate) | Pure counting |
| Correction from $\rho_n$ | $c_n = \cos\gamma_n < 1$ (oscillatory) | Ripple on top of counting |

### Step 4: Normalize by $\sqrt{x}$

Divide everything by $\sqrt{x}$:

$$\frac{\psi(x) - x}{\sqrt{x}} = -\sum_n \frac{2}{|\rho_n|} \cos(\gamma_n \ln x + \phi_n) - \frac{\ln(2\pi)}{\sqrt{x}} - \ldots$$

**If RH is true** ($\sigma = 1/2$ for all zeros):
the right side is a sum of bounded oscillations with fixed amplitudes $2/|\rho_n|$.
The whole expression stays **bounded** for all $x$.

**If RH fails** (some zero with $\sigma > 1/2$):
that zero's contribution, after dividing by $\sqrt{x}$, still grows as $x^{\sigma - 1/2} \to \infty$.
One correction **escapes** — it overwhelms all others.

### Step 5: The circle picture

Each correction, after normalization, traces a circle:

$$\cos^2(\gamma_n \ln x + \phi_n) + \sin^2(\gamma_n \ln x + \phi_n) = 1$$

with radius $A_n = 2/|\rho_n|$ (fixed, decaying as $1/\gamma_n$).

**RH says:** one normalization ($\div \sqrt{x}$) works for ALL corrections simultaneously.
All corrections live on bounded circles. No correction escapes.

**RH violation:** one correction needs a stronger normalization ($\div x^{\sigma}$ with $\sigma > 1/2$).
After the weaker normalization ($\div \sqrt{x}$), this correction grows unboundedly —
it leaves its circle and spirals outward.

## The Orbit Triptych and RH

| | Degenerate ($c = 1$) | Oscillatory ($|c| < 1$) | Hypothetical violation |
|---|---|---|---|
| **What** | Pole at $s = 1$ | Zeros on critical line | Zero off critical line |
| **Contribution** | $x$ (counting) | $\sqrt{x} \cdot \text{oscillation}$ | $x^{\sigma} \cdot \text{oscillation}$ |
| **After $\div \sqrt{x}$** | $\sqrt{x} \to \infty$ (removed as main term) | **Bounded** | $x^{\sigma - 1/2} \to \infty$ |
| **Circle** | — | Radius $2/|\rho_n|$ (fixed) | Radius **growing** |
| **Orbit regime** | Additive group $\mathbb{G}_a$ | Norm-1 torus (algebraic circle) | **Spiral** (escaping circle) |

## What This Framework Provides

### Good intuition for WHY RH should hold

1. **Self-regulation:** coherence × amplitude $\to 0$ for each zero (no single zero dominates)
2. **One circle:** all corrections normalized by the same $\sqrt{x}$ stay bounded
3. **Symmetry:** functional equation forces off-line zeros into pairs
   ($\sigma$ and $1-\sigma$), creating asymmetric amplitudes — the louder one dominates

### What it does NOT provide

- No new inequality constraining $\sigma$
- The "one circle" statement IS RH, not independent of it
- The orbit language reformulates but does not resolve the problem

### What would be needed for a proof

An argument that the orbit structure FORCES all corrections onto the same circle.
Possible angles (all speculative):

1. **Algebraic constraint:** the Pythagorean identity $T_k^2 + (1-c^2)U_{k-1}^2 = 1$
   holds for all orbits. Could a multi-orbit version constrain the radii?

2. **Finite field shadow:** over $\mathbb{F}_p$, the orbit period divides $p \pm 1$
   (Cartan subgroup structure). Could the PRODUCT over all primes constrain $\sigma$?
   This is essentially the Euler product approach.

3. **Norm constraint:** $\text{Nm}(o_p) = (\lambda+1)/(\lambda^p+1)$ for prime period.
   The norm "knows about" the period. Could a global norm constraint
   (over all periods simultaneously) force $\sigma = 1/2$?

None of these is currently a viable path. They are directions for further thought.

## Practical Picture

Plot $(\psi(x) - x) / \sqrt{x}$ vs $\ln x$:

- **If RH true:** bounded, noisy oscillation (superposition of incommensurate frequencies)
- **If RH false:** slow drift upward or downward (escaping correction)

The graph should look like "noise" — not growing, not decaying, just fluctuating.
Any systematic trend would indicate an off-line zero.

This is the practical meaning of "all corrections on one circle":
the normalized deviation is a stationary signal, not a drifting one.

## The Symmetry Argument: Why "Up or Down" Has No Answer

### Two exact symmetries

The zeta function has two independent reflection symmetries:

1. **Schwarz reflection** ($\zeta(\bar{s}) = \overline{\zeta(s)}$):
   mirror **up/down** — $\gamma \leftrightarrow -\gamma$

2. **Functional equation** ($\xi(s) = \xi(1-s)$):
   mirror **left/right** — $\sigma \leftrightarrow 1-\sigma$

The critical line $\sigma = 1/2$ is the **fixed line** of the left/right symmetry.

### The zero quadruplet

If a zero exists at $\rho = \sigma + i\gamma$ with $\sigma \neq 1/2$,
the two symmetries force three companions:

```
Im(s) ↑
      |
  γ ──●─────────────×─────────────●──
      |  (½-δ)+iγ     ½+iγ      (½+δ)+iγ
      |             (on line)
      |                │
      |          critical line
      |                │
 -γ ──●─────────────×─────────────●──
      |  (½-δ)-iγ     ½-iγ      (½+δ)-iγ
      |
      └────────────────┼────────────────→ Re(s)
      0              1/2               1
```

If RH holds (×): two zeros $1/2 \pm i\gamma$, vertically paired.

If RH fails (●): four zeros forming a rectangle, straddling the critical line.

### How a zero "leaves" the critical line

A zero at $1/2 + i\gamma$ is simple (multiplicity 1). To create an off-line pair,
the process must be:

$$\text{simple zero} \;\xrightarrow{\text{collision}}\; \text{double zero}
\;\xrightarrow{\text{splitting}}\; \text{symmetric pair } (1/2 \pm \delta) + i\gamma$$

The splitting is **horizontal** — the pair moves left and right from the critical
line at the same height $\gamma$. Both partners are created simultaneously
from the same point. There is no "first" direction.

### The symmetry constraint

The key observation: **there is no mechanism to choose left vs. right.**

- The functional equation treats $\sigma$ and $1-\sigma$ identically
- The splitting must be symmetric (both directions, same $\delta$)
- If the normalized deviation $(\psi(x) - x)/\sqrt{x}$ were to drift,
  there would need to be a preferred direction — but the symmetry forbids this

The violation wouldn't be a monotone drift but **growing oscillations**
(amplitude $x^{\delta}$ with alternating sign). The symmetry is preserved
at every step — both "up" and "down" are equally represented.

### Connection to de Bruijn–Newman

This intuition has a precise formalization. De Bruijn (1950) defined a heat flow
on the zeros: a family $H_t(z)$ where:

- $H_0 = \xi$ (the zeta function on the critical line)
- Increasing $t$: zeros "attracted" toward the real line (stabilizing)
- Decreasing $t$: zeros repelled (destabilizing → splitting off the line)

The **Newman constant** $\Lambda$: smallest $t$ where all zeros of $H_t$ are real.

- $\Lambda \leq 0 \iff$ RH
- **Rodgers–Tao (2020): $\Lambda \geq 0$**

Combined: $\Lambda = 0$ if RH is true. The zeros are at the **exact tipping point** —
maximally balanced. Any infinitesimal perturbation "downward" ($t < 0$) would
cause a collision and splitting.

### What prevents the splitting?

For a zero to leave the critical line, two zeros must first **collide**
(form a double zero at the same point). This requires:

1. Two zeros approach each other on the critical line ($\gamma_n \to \gamma_m$)
2. They meet and form a double zero
3. They split horizontally off the line

The GUE **level repulsion** (Montgomery pair correlation) says: the probability
of two zeros being within distance $\delta$ is $\sim \delta^2$ (quadratically small).
Zeros **repel** each other — they resist collision.

The chain of intuition:

> **Repulsion prevents collision → collision is needed for splitting →
> splitting is needed to leave the line → zeros stay on the line**

This is the strongest heuristic argument for RH. It connects:
- The symmetry argument (no preferred direction for splitting)
- The GUE statistics (repulsion prevents the collision prerequisite)
- The de Bruijn–Newman framework ($\Lambda = 0$ = exact tipping point)
- The orbit picture (all corrections on one circle after normalization)

### Honest status

This argument is **believed by most number theorists** but remains **unproven**.
The gap: "repulsion makes collision unlikely" $\neq$ "collision is impossible."
GUE statistics describe the **typical** behavior of zeros, not the worst case.
A proof would need to show that collision is not just unlikely but strictly
forbidden — and that is the open problem.
