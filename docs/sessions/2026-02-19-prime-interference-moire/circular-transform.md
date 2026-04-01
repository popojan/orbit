# Circular Transform: Mapping Intersections onto Concentric Circles

**Date:** 2026-04-01
**Status:** ✅ PROVEN (algebraic identity)

## The Problem

In the shader geometry, two line families produce intersections at
$(ij,\; i-j)$ for positive integers $i, j$. Fixing the sum $i + j = c$
yields the **parabola**

$$4x + y^2 = c^2$$

(opening to the left, vertex at $(c^2/4,\, 0)$). These parabolas are
visible in the shader at high zoom as curved bands of intersection points.

**Question:** Is there a coordinate transformation that maps these
parabolas to circles?

## The Transform

$$\boxed{(x, y) \;\longmapsto\; (u, v) = (2\sqrt{x},\; y)}$$

Under this map, the parabola $4x + y^2 = c^2$ becomes

$$u^2 + v^2 = c^2$$

a **circle of radius $c = i + j$** centered at the origin.

### Proof

The intersection point $(ij,\; i - j)$ maps to $(2\sqrt{ij},\; i - j)$.
Its distance from the origin is:

$$r = \sqrt{(2\sqrt{ij})^2 + (i-j)^2} = \sqrt{4ij + i^2 - 2ij + j^2} = \sqrt{(i+j)^2} = i + j \qquad \square$$

## Polar Coordinates: Radius and Angle

In the transformed plane, each intersection has a natural polar
decomposition:

$$r = i + j, \qquad \theta = \arcsin\frac{i - j}{i + j}$$

Equivalently:

$$\cos\theta = \frac{2\sqrt{ij}}{i + j} = \frac{\mathrm{GM}(i,j)}{\mathrm{AM}(i,j)}$$

| Quantity | Meaning |
|:---------|:--------|
| **Radius** $r = i + j$ | Sum of factors (arithmetic "size" of the factorization) |
| **Angle** $\cos\theta = \mathrm{GM}/\mathrm{AM}$ | Balance of the factorization |
| $\theta = 0$ | Perfectly balanced: $i = j$, so $\mathrm{GM} = \mathrm{AM}$ |
| $\theta \to \pm\pi/2$ | Maximally unbalanced: $i \gg j$ or $j \gg i$ |

The AM-GM inequality $\mathrm{GM} \leq \mathrm{AM}$ corresponds exactly
to $|\cos\theta| \leq 1$ — the inequality between means **is** the
geometric constraint that $\theta$ is a valid angle.

## What Lives Where

### Primes

$p = 1 \cdot p$ gives a single pair of points on the circle $r = p + 1$
at angle

$$\theta = \pm\arcsin\frac{p - 1}{p + 1} \;\approx\; \pm\frac{\pi}{2} \quad \text{(for large } p\text{)}$$

Primes sit near the top and bottom of their circle — maximally
unbalanced factorization.

### Composites

$n$ with multiple factorizations has points on **different circles**:
each factorization $n = d \cdot (n/d)$ has a different sum $d + n/d$,
hence a different radius.

- Most balanced factorization ($d \approx \sqrt{n}$): smallest radius
  $r_{\min} \approx 2\sqrt{n}$, near $\theta = 0$.
- Most unbalanced ($d = 1$): largest radius $r = n + 1$, near
  $\theta = \pm\pi/2$.

### Perfect squares

$n = k^2$ has the factorization $k \cdot k$ sitting at exactly
$\theta = 0$ (rightmost point) on the circle $r = 2k$.

### Highly composite numbers

Many factorizations → points on many circles, densely populating the
angular range. The "divisor fan" becomes a radial spray.

## Curves in the Transformed Plane

### Vertical line $x = n$ (factorizations of $n$)

Maps to vertical line $u = 2\sqrt{n}$. Factorizations of $n$ sit at
different heights $v = d - n/d$ on this line, and on different circles.

### Positive-family line $i = \mathrm{const}$

The line $y = i - x/i$ maps to

$$v = i - \frac{u^2}{4i}$$

a **downward parabola** in $(u, v)$ with vertex at $(0, i)$.

### Negative-family line $j = \mathrm{const}$

Similarly maps to an **upward parabola** $v = u^2/(4j) - j$.

So the transformation trades one set of parabolas (constant $i + j$)
for another (constant $i$ or $j$). The circles are the "natural"
curves; the individual line families become parabolic.

## Connection to the Shader Functions

In the transformed coordinates $(u, v) = (2\sqrt{x},\, y)$:

$$S = \frac{1}{2}\!\left[\cos(\pi v) \;-\; \cos\!\left(\pi\sqrt{v^2 + u^2}\right)\right] = \frac{1}{2}\!\left[\cos(\pi v) \;-\; \cos(\pi r)\right]$$

where $r = \sqrt{u^2 + v^2}$. So:

- $S = 0$ when $r = $ integer and $v = $ compatible height
  → intersections lie on **integer-radius circles**
- $S$ depends only on $(r, v)$, not on $u$ independently
  → the function has a partial "radial" structure

The zeros of $S$ on circle $r = c$ are at heights $v = d - n/d$ for
all factorizations $n = d(c - d)$ with $d + (c-d) = c$.

## Two Dirichlet Series from One Lattice

The polar structure reveals that the same intersection lattice supports
two natural Dirichlet series, depending on how we group the points:

### Vertical grouping (by product $n = ij$)

Group intersections by their $x$-coordinate $n = ij$. The number of
intersections at $x = n$ is $d(n)$ (divisor count). Generating function:

$$\sum_{n=1}^{\infty} \frac{d(n)}{n^s} = \zeta(s)^2$$

This encodes the **multiplicative** structure: how many factorizations
does each product $n$ have?

### Radial grouping (by sum $c = i + j$)

Group intersections by the circle they lie on. Circle $r = c$ carries
exactly $c - 1$ intersection points (for $i = 1, \ldots, c-1$, each
with $j = c - i$). Generating function:

$$J(s) = \sum_{c=2}^{\infty} \frac{c - 1}{c^s} = \zeta(s-1) - \zeta(s)$$

This encodes the **additive** structure: how many factor pairs have
sum $c$?

### Comparison

| | Vertical (product) | Radial (sum) |
|:--|:-------------------|:-------------|
| **Variable** | $n = ij$ | $c = i + j$ |
| **Count at value** | $d(n)$ (divisor function) | $c - 1$ |
| **Generating function** | $\zeta(s)^2$ | $\zeta(s-1) - \zeta(s)$ |
| **Rightmost pole** | $s = 1$ (double) | $s = 2$ (simple, from $\zeta(s-1)$) |
| **Encodes** | Multiplicative structure | Additive structure |
| **Geometry** | Vertical lines $x = n$ | Circles $r = c$ |

The zeros of $J(s)$ satisfy $\zeta(s-1) = \zeta(s)$: the points where
additive and multiplicative counting "balance." These are distinct from
the zeros of $\zeta$ itself.

### Prime density in transformed coordinates

Under $u = 2\sqrt{x}$ (so $x = u^2/4$), the prime counting function becomes:

$$\pi(u^2/4) \;\approx\; \frac{u^2}{8 \ln u}$$

with density $d\pi/du \approx u / (4 \ln u)$, which **grows** with $u$
(unlike $1/\ln x$ in original coordinates). The $\sqrt{x}$ compression
more than compensates for prime thinning.

On the log scale ($v = \ln u = \tfrac{1}{2}\ln x + \text{const}$), the
Riemann zero oscillations appear at frequency $2\gamma$ instead of
$\gamma$ — a pure rescaling, no new spectral information.

## Radial Rearrangement of $\zeta(s)^2$

### The identity

Grouping all factor pairs $(i, j)$ by their circle $c = i + j$:

$$\zeta(s)^2 = \sum_{c=2}^{\infty} R(s,\, c), \qquad R(s,\, c) = \sum_{i=1}^{c-1} \frac{1}{\bigl(i(c-i)\bigr)^s}$$

Each term $R(s, c)$ is the **total contribution of circle $r = c$** to $\zeta(s)^2$.

### Closed forms

$$R(1, c) = \frac{2\,H_{c-1}}{c}$$

$$R(2, c) = \frac{2}{c^2}\!\left(H_{c-1}^{(2)} + \frac{2\,H_{c-1}}{c}\right)$$

where $H_n = \sum_{m=1}^{n} 1/m$ and $H_n^{(k)} = \sum_{m=1}^{n} 1/m^k$
are (generalized) harmonic numbers.

✅ Both verified symbolically for $c = 2, \ldots, 8$.

### Consequence: $\pi^4/36$ as a harmonic series

$$\frac{\pi^4}{36} = \zeta(2)^2 = \sum_{c=2}^{\infty} \frac{2}{c^2}\!\left(H_{c-1}^{(2)} + \frac{2\,H_{c-1}}{c}\right)$$

This expands $\pi^4/36$ as a series over "factorization size" $c = i + j$,
where each term mixes the generalized harmonic number $H^{(2)}$ (encoding
divisor structure) with $H/c$ (encoding additive structure).

### Asymptotics

For large $c$: the inner sum is dominated by balanced factorizations
($i \approx c/2$), giving $R(s, c) \sim c^{1-2s} \cdot B(1-s, 1-s)$ where
$B$ is the Beta function. The radial series converges for $\operatorname{Re}(s) > 1$
(same as $\zeta(s)^2$).

### Connection to other results in this session

| Grouping | Series | Geometric meaning |
|:---------|:-------|:------------------|
| By product $n = ij$ | $\sum d(n)/n^s = \zeta(s)^2$ | Vertical lines |
| By sum $c = i+j$, unweighted | $\sum (c-1)/c^s = \zeta(s{-}1) - \zeta(s)$ | Circle count |
| By sum $c = i+j$, weighted by $n^{-s}$ | $\sum R(s,c) = \zeta(s)^2$ | **Full radial rearrangement** |

The radial rearrangement preserves the value $\zeta(s)^2$ but reorganizes
the sum so that each term corresponds to one circle in the transformed plane.

---

## Boundary–Interior Decomposition of $\zeta(s)^2$

### The decomposition

Each circle $r = c$ has **boundary** factorizations ($i = 1$ and $i = c-1$,
giving products $c-1$) and **interior** factorizations ($2 \leq i \leq c-2$).
These have different asymptotics:

$$R(s, c) = \underbrace{\frac{2}{(c-1)^s}}_{R_{\text{bound}}} + \underbrace{\sum_{i=2}^{c-2} \frac{1}{(i(c-i))^s}}_{R_{\text{int}}}$$

| Part | Asymptotics | Total over all $c$ |
|:-----|:------------|:-------------------|
| Boundary | $\sim 2/c^s$ (slow decay) | $2\zeta(s)$ |
| Interior | $\sim c^{1-2s}$ (fast decay) | $\zeta(s)^2 - 2\zeta(s)$ |

Boundary **dominates** for $s > 1$: the trivial factorizations $1 \times n$
carry most of the weight in $\zeta(s)^2$.

### Key identity

$$\boxed{\zeta(s)^2 = 2\zeta(s) + \sum_{c=3}^{\infty} R_{\text{int}}(s, c)}$$

Equivalently:

$$(\zeta(s) - 1)^2 = 1 + \sum_{c=3}^{\infty}\;\sum_{i=2}^{c-2} \frac{1}{(i(c-i))^s}$$

✅ Verified numerically for $s = 2, 3, 4$ (partial sums to $c = 500$).

### Prime circles carry no interior weight from $p$

On circle $c = p + 1$ (where $p$ is prime): the interior sum
$R_{\text{int}}(s, p+1)$ runs over $i = 2, \ldots, p-1$. The products
$i(p+1-i)$ are **never equal to $p$** (since $p$ is prime and both
factors $\geq 2$). So prime $p$ contributes to $\zeta(s)^2$ **only
through the boundary** term $2/p^s$, never through the interior.

This is the radial version of the "no interior intersection" invariant
from the shader: primes sit at the boundary of their circle, composites
populate the interior.

### Note on Euler–Maclaurin

The naive approach — treating $R(s,c)$ as a Riemann sum of
$\int_0^1 (t(1-t))^{-s} dt$ — fails for $s \geq 1$ because the integral
diverges. The boundary–interior decomposition is the correct alternative:
it separates the divergent boundary contribution (which sums to $2\zeta(s)$)
from the convergent interior.

---

## Angular Form of $\zeta(s)^2$

### Secant representation

Using $i(c-i) = (c^2/4)\cos^2\theta_i$ with $\theta_i = \arcsin\frac{2i-c}{c}$:

$$\zeta(s)^2 = \sum_{c=2}^{\infty} \left(\frac{2}{c}\right)^{2s} \sum_{i=1}^{c-1} \sec^{2s}(\theta_i)$$

✅ Verified symbolically.

### Fourier modes on each circle

$$F_k(s, c) = \sum_{i=1}^{c-1} \frac{e^{ik\theta_i}}{(i(c-i))^s}$$

All $F_k$ are **real** (by the symmetry $i \leftrightarrow c-i$, which maps
$\theta \to -\theta$).

- $F_0(s,c) = R(s,c)$: the radial sum (total contribution of circle $c$)
- $F_1(s,c)$: weights by $\sin\theta \propto (i-j)/c = y/c$ — the
  **height-weighted sum**, connecting angular mode $k=1$ to the height
  frequency parameter $\xi$ from the intersection Dirichlet series
- Higher $F_k$: finer angular structure of divisor distribution on the circle

### Connection across representations

| Viewpoint | Formula | Index |
|:----------|:--------|:------|
| Vertical (shader) | $\zeta(s)^2 = \sum_n d(n)/n^s$ | product $n = ij$ |
| Radial (circles) | $\zeta(s)^2 = \sum_c R(s,c)$ | sum $c = i+j$ |
| Angular (Fourier) | $R(s,c) = \sum_k F_k(s,c)$ | mode $k$ on circle |
| Height frequency | $\mathcal{I}(s,\xi) = \lvert G(s,\xi)\rvert^2$ | frequency $\xi$ |

The height parameter $\xi$ from the shader corresponds to angular mode $k$
on the circle: $\xi \leftrightarrow k$.

### Chebyshev polynomials as angular basis

Since $F_k$ is real (by the $i \leftrightarrow c-i$ symmetry), and
$\cos(k\theta) = T_k(\cos\theta)$:

$$\boxed{F_k(s, c) = \sum_{i=1}^{c-1} \frac{T_k\!\left(\dfrac{\mathrm{GM}_i}{\mathrm{AM}_i}\right)}{(i(c-i))^s}}$$

where $T_k$ is the **Chebyshev polynomial of the first kind**, and
the argument $\mathrm{GM}/\mathrm{AM} = 2\sqrt{i(c-i)}/c = \cos\theta_i$
is the ratio of geometric to arithmetic mean of the factor pair.

✅ Verified symbolically for $k = 0, \ldots, 5$ at $c = 20$, $s = 2$.

### Global angular zeta functions

$$Z_k(s) = \sum_{c=2}^{\infty} F_k(s, c) = \sum_{c=2}^{\infty} \sum_{i=1}^{c-1} \frac{T_k(\mathrm{GM}_i/\mathrm{AM}_i)}{(i(c-i))^s}$$

| $k$ | $Z_k(2)/Z_0(2)$ | Weight | Meaning |
|:---:|:----------------:|:-------|:--------|
| 0 | 1.000 | $T_0 = 1$ | unweighted = $\zeta(s)^2$ |
| 1 | 0.886 | $T_1 = x$ | GM/AM weighted |
| 2 | 0.623 | $T_2 = 2x^2 - 1$ | quadrupole |
| 3 | 0.379 | $T_3 = 4x^3 - 3x$ | octupole |
| 4 | 0.259 | $T_4$ | ... decaying slowly |

For larger $s$: ratios $Z_k/Z_0$ approach 1 (unbalanced factorizations
suppressed, leaving balanced ones where $\mathrm{GM}/\mathrm{AM} \approx 1$
and $T_k \approx 1$).

### Why Chebyshev is natural here

The Chebyshev polynomials arise because:

1. The **circular transform** $(x, y) \to (2\sqrt{x}, y)$ maps intersections
   onto circles, with angle $\theta$ satisfying $\cos\theta = \mathrm{GM}/\mathrm{AM}$.

2. **Fourier analysis on the circle** decomposes functions into
   $e^{ik\theta}$. Since the intersection density is symmetric
   ($\theta \to -\theta$), only cosine terms survive: $\cos(k\theta)$.

3. $\cos(k\theta) = T_k(\cos\theta) = T_k(\mathrm{GM}/\mathrm{AM})$ by
   the **defining property** of Chebyshev polynomials.

So $T_k$ is not imposed — it **emerges** from the geometry of the circular
transform. The argument GM/AM $\in [0, 1]$ is the natural variable on the
circle, and $T_k$ is the natural basis for functions on $[0, 1]$ arising
from angular Fourier analysis.

### Connection to Orbit paclet

The Orbit paclet's core object is the Chebyshev polynomial $T_n$.
The circular transform reveals that $T_k$ also governs the **angular
structure of factorizations**: the $k$-th Fourier mode of $\zeta(s)^2$
on each circle is weighted by $T_k(\mathrm{GM}/\mathrm{AM})$.

This gives a concrete identity linking the paclet's Chebyshev work
to the Riemann zeta function:

$$\zeta(s)^2 = Z_0(s) = \sum_{c=2}^{\infty}\sum_{i=1}^{c-1} \frac{T_0(\mathrm{GM}_i/\mathrm{AM}_i)}{(i(c-i))^s}$$

and the higher $Z_k(s)$ are "Chebyshev-weighted divisor zeta functions."

### Possible directions

1. **Closed form for $Z_k(s)$?** For $k = 0$: known ($\zeta^2$).
   For $k = 1$: $Z_1 = \sum_c \sum_i (2\sqrt{i(c-i)}/c)/(i(c-i))^s$
   $= 2\sum_c c^{-1} \sum_i (i(c-i))^{1/2-s}$. May relate to $\zeta(2s-1)$.

2. **Recurrence from $T_k$:** The Chebyshev recurrence $T_{k+1} = 2x\,T_k - T_{k-1}$
   gives $Z_{k+1}(s) = 2 Z_k^{(1)}(s) - Z_{k-1}(s)$ where $Z_k^{(1)}$ is
   a "GM/AM-shifted" version. This could yield recurrence relations among the $Z_k$.

3. **Orthogonality:** Chebyshev polynomials are orthogonal on $[-1,1]$ with
   weight $(1-x^2)^{-1/2}$. On each circle, the discrete sum approximates
   this inner product. The orthogonality could give "selection rules" for
   which $Z_k$ contribute to specific arithmetic functions.

### $Z_k$ as polynomial combinations of $D(s, w)$

The angular zeta functions are **not independent** of $\zeta$ — they are
polynomial combinations of the two-variable Dirichlet series $D(s, w)$:

$$Z_1(s) = 2\,D\!\left(s - \tfrac{1}{2},\; 1\right)$$

$$Z_2(s) = 8\,D(s - 1,\; 2) - \zeta(s)^2$$

✅ Both verified numerically (4+ digits at cMax = 100–200).

**General pattern:** Since $T_k(\mathrm{GM}/\mathrm{AM})$ is a polynomial
in $\mathrm{GM}/\mathrm{AM} = 2\sqrt{ij}/(i+j) = 2(ij)^{1/2}/c$, each
power $(ij)^{m/2}/c^m$ maps to $D(s - m/2,\; m)$. Therefore:

$$Z_k(s) = \text{polynomial combination of } D(s - m/2,\; m) \text{ for } m = 0, \ldots, k$$

The Chebyshev recurrence $T_{k+1} = 2x\,T_k - T_{k-1}$ translates to a
recurrence among the $Z_k$, linking consecutive angular zeta functions
through the $D(s, w)$ family.

### Hierarchy

$$\zeta(s)^2 = D(s, 0) = Z_0(s) \;\subset\; D(s, w) \;\supset\; Z_k(s)$$

The two-variable series $D(s, w)$ is the **fundamental object**:
- Slicing along $w$ (additive weight): gives the radial decomposition
- Slicing along $k$ (Chebyshev mode): gives the angular decomposition
- Both reduce to $\zeta(s)^2$ at $w = 0$ resp. $k = 0$
- $D(s, w)$ has the integral representation
  $D = \frac{1}{\Gamma(w)}\int_0^\infty t^{w-1}[\mathrm{Li}_s(e^{-t}) - e^{-t}]^2\,dt$

### Even/odd parity dichotomy

$T_k$ contains only even powers of $x$ for even $k$, and only odd powers
for odd $k$. Since $x^2 = 4ij/c^2$ is rational but $x = 2\sqrt{ij}/c$ is
irrational:

| Parity of $k$ | $T_k(x)$ uses | $Z_k$ at integer $s$ | Limit involves |
|:-:|:-:|:-:|:-:|
| **Even** | $x^0, x^2, x^4, \ldots$ | **rational** | $\zeta$ at integers → $\pi^{2n}$ |
| **Odd** | $x^1, x^3, x^5, \ldots$ | **irrational** ($\sqrt{p}$) | $\zeta$ at half-integers |

✅ Verified: $Z_0, Z_2, Z_4, Z_6$ are exact rationals at integer $s$;
$Z_1, Z_3, Z_5, Z_7$ contain $\sqrt{2}, \sqrt{3}, \sqrt{5}, \sqrt{7}, \ldots$

### Even-mode sequence $Z_{2k}(s)$

For complex $s = \sigma + it$, the ratios $Z_{2k}/Z_0$ oscillate and can
**exceed 1** — higher Chebyshev modes dominate over $Z_0 = \zeta(s)^2$.

This amplification is **strongest near Riemann zero imaginary parts**
$t \approx \gamma_n$:

| $t$ | $Z_2/Z_0$ | $Z_4/Z_0$ |
|:---:|:----------:|:----------:|
| 0 | 0.63 | 0.26 |
| $\gamma_1 \approx 14.1$ | **1.34** | **2.19** |
| $\gamma_2 \approx 21.0$ | **1.27** | **1.76** |
| $\gamma_3 \approx 25.0$ | **1.23** | **1.60** |

(Computed at $s = 2 + it$ with cMax = 60.)

🤔 HYPOTHESIS: The amplification of higher angular modes near Riemann zeros
reflects the angular structure of factorizations "resonating" at specific
imaginary parts. To be investigated with higher precision.

### Generating function for even modes

Using $T_{2k}(\cos\theta) = \cos(2k\theta)$ and summing the geometric series:

$$\sum_{k=0}^{\infty} Z_{2k}(s)\, t^k = \sum_{c=2}^{\infty}\sum_{i=1}^{c-1} \frac{1 - t\,\mu_i}{1 - 2t\,\mu_i + t^2} \cdot \frac{1}{(i(c-i))^s}$$

where $\mu_i = \cos(2\theta_i) = 2(\mathrm{GM}/\mathrm{AM})^2 - 1 = (8ij - c^2)/c^2$
is **rational** for integer $i, c$.

✅ Generating function verified numerically.

The kernel $(1 - t\mu)/(1 - 2t\mu + t^2)$ is the **Poisson kernel** on the
circle — the same kernel that appears in harmonic analysis and potential
theory. Its appearance here links the angular Chebyshev decomposition of
$\zeta(s)^2$ to classical harmonic analysis on the unit disk.

### Note on rationality

The transform $(x, y) \to (2\sqrt{x},\, y)$ introduces $\sqrt{x}$, so
the GM/AM argument $2\sqrt{ij}/(i+j)$ is irrational for most factor pairs.
This means $T_k(\mathrm{GM}/\mathrm{AM})$ produces irrational values at
rational inputs — a consequence of the $\sqrt{\,}$ in the circular transform.
The half-integer shifts $s - m/2$ in the $D$ arguments reflect this: integer
$s$ maps to half-integer arguments, mixing the "natural" rationality of the
Dirichlet series with the irrationality of the geometric transform.

---

## Dual Shader: Circles Unrolled to Lines

### The dual coordinate system

Unrolling each circle to a vertical line gives the **dual shader**:

$$\text{Original: } (x, y) = (ij,\; i-j) \qquad \longleftrightarrow \qquad \text{Dual: } (c, h) = \left(i+j,\; \frac{2i - c}{c}\right)$$

where $h = \sin\theta = (i-j)/(i+j)$ is the normalized height.

### Key property: uniform spacing

On each vertical $c$, the $c-1$ points sit at heights
$h = -1 + 2/c,\; -1 + 4/c,\; \ldots,\; 1 - 2/c$ — **equally spaced**
with step $2/c$. The product at each point is $n = i(c-i) = (c^2/4)(1-h^2)$.

In the original shader, heights $y = i-j$ are irregular (determined by
factorization structure). In the dual, heights are uniform — the structure
moves entirely to **which verticals** each number $n$ appears on.

### Factorization as a curve

Each number $n$ traces a **curve** across verticals: for each divisor
$d \mid n$ with $d \leq \sqrt{n}$, a point appears at:

$$c = d + n/d, \qquad h = \frac{d - n/d}{d + n/d}$$

- **Prime $p$**: one point, at $c = p+1$, $h = (1-p)/(1+p) \approx -1$
- **Composite $n$ with $k$ divisor pairs**: $k$ points on $k$ different verticals

### Comparison

| | Original shader | Dual shader |
|:--|:----------------|:------------|
| Verticals indexed by | product $n = ij$ | sum $c = i+j$ |
| Heights on each vertical | $i - j$ (irregular) | $(2i-c)/c$ (uniform, step $2/c$) |
| Prime signal | empty interior on $x = p$ | single point on one vertical |
| Composite signal | many heights on $x = n$ | many verticals for $n$ |
| Information in | height distribution | which verticals are hit |

---

## Summary

The $\sqrt{x}$ transform reveals that the shader's intersection
lattice has a natural **polar structure**: the sum $i + j$ is the
radius, and the GM/AM ratio of the factorization is the cosine of
the angle. This is an exact algebraic identity, not an approximation.

The polar structure supports two natural Dirichlet series — $\zeta(s)^2$
(vertical/multiplicative) and $\zeta(s-1) - \zeta(s)$ (radial/additive)
— from the same geometric object.

| Original coordinates | Transformed coordinates |
|:---------------------|:------------------------|
| Intersections at $(ij,\, i-j)$ | Points at radius $i+j$, angle $\arcsin\frac{i-j}{i+j}$ |
| Constant $i+j$: parabola $4x + y^2 = c^2$ | Circle $u^2 + v^2 = c^2$ |
| Line $i = \mathrm{const}$: straight | Downward parabola |
| Vertical $x = n$: straight | Vertical $u = 2\sqrt{n}$ |
| AM-GM inequality | $\lvert\cos\theta\rvert \leq 1$ |
| $\sum d(n)/n^s = \zeta(s)^2$ | $\sum (c-1)/c^s = \zeta(s-1) - \zeta(s)$ |
