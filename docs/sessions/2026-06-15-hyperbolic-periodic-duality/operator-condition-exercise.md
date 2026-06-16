# The operator condition, squeezed from the Cassini trichotomy alone

**Date:** 2026-06-15
**Status:** 🧪 EXERCISE / speculative — deliberately self-contained. No
Hilbert–Pólya, Selberg, Connes, Weil/Frobenius, or F₁ machinery is used; the goal
is to see how far **our own** successor-orbit trichotomy can be pushed toward a
condition on "the operator." Honest verdict at the end.

The one ground rule: every object below is from the orbit sessions —
the recurrence $f_{k+1}=2c\,f_k - f_{k-1}$, its conserved Cassini form, the
elliptic/parabolic/hyperbolic trichotomy, and the naturals as the degenerate
boundary. Nothing imported.

---

## 1. The two-in-one boundary, exactly

Non-degenerate orbit solutions at parameter $c$, near the boundary:

$$\text{periodic }(c=\cos\theta):\quad U_{k-1}=\frac{\sin k\theta}{\sin\theta}=k-\frac{k^3-k}{6}\theta^2+\cdots$$

$$\text{hyperbolic }(c=\cosh\varphi):\quad U_{k-1}=\frac{\sinh k\varphi}{\sinh\varphi}=k+\frac{k^3-k}{6}\varphi^2+\cdots$$

Both collapse to the **naturals** $k$ at the boundary. Setting the two
*non-degenerate* expressions equal (not just their limits) forces, at first
non-trivial order,

$$-\theta^2=\varphi^2\quad\Longleftrightarrow\quad \theta=i\varphi.$$

So the periodic and hyperbolic worlds are **one analytic object on two real
slices** of a complex angle, meeting only at $\theta=\varphi=0$. To pass from one
to the other you must spend the imaginary unit $i$. This is the precise content
of "the boundary is two-in-one": it is the single real point where the real axis
(rotation) and the imaginary axis (growth) of the angle cross.

## 2. The trichotomy is a trace law (elementary, ours)

$M(c)=\begin{pmatrix}2c&-1\\1&0\end{pmatrix}$, $\det=1$, $\operatorname{tr}=2c$.
A **real, determinant-1** $2\times2$ map is classified entirely by its trace,
through the conserved Cassini form $Q=\left(\begin{smallmatrix}1&-c\\-c&1\end{smallmatrix}\right)$, $\det Q=1-c^2$:

| $\lvert\operatorname{tr}\rvert=\lvert 2c\rvert$ | eigenvalues | $\det Q=1-c^2$ | regime |
|---|---|---|---|
| $<2$ | $e^{\pm i\theta}$ (circle) | **positive definite** | periodic |
| $=2$ | $1,1$ (or $-1,-1$) | **positive semidefinite, rank 1** | **boundary = naturals $I+N$** |
| $>2$ | $\mu,\,1/\mu$ real | **indefinite** (signature $1,1$) | hyperbolic |

Two facts we will only need:
(i) reality $+\ \det=1$ **forces** the operator to be (a power/conjugate of)
$M(c)$; the trichotomy is then not a choice but the trace law.
(ii) the boundary $\operatorname{tr}=2$ is exactly the **successor operator**
$I+N$, $N^2=0$, the thing that produces $1,2,3,\dots$ — the orbit project's
starting point.

## 3. Two blocks per zero: rotation vs growth

Give a zero $\rho=\sigma+i\gamma$ its normalized per-step eigenvalue (divide by
$\sqrt{x}$ each log-step): $e^{(\sigma-1/2)+i\gamma}$. It factors into two
**real $\det$-1** $2\times2$ cells:

- **rotation cell** (from the conjugate pair $\pm\gamma$): eigenvalues
  $e^{\pm i\gamma}$, trace $2\cos\gamma\in[-2,2]$ — **elliptic for every real
  $\gamma$**. This is the periodic axis; it is *always* on the circle and carries
  the height $\gamma$.
- **growth cell** (from the functional-equation pair $\sigma\leftrightarrow1-\sigma$):
  eigenvalues $e^{\pm(\sigma-1/2)}$, **real**, trace
  $2\cosh(\sigma-1/2)\ge2$. This is the hyperbolic axis; it carries the real part
  $\sigma$.

So the hyperbolic/periodic split of §1 is not "primes vs zeros" — it is the
**two coordinates of one zero**: $\sigma$ rides the growth (hyperbolic) cell,
$\gamma$ rides the rotation (periodic) cell.

## 4. The condition

The rotation cell is harmless (always elliptic). Everything rides on the
**growth cell**. By §2 a real $\det$-1 cell is elliptic / parabolic / hyperbolic
by trace, and the growth cell has **real** eigenvalues $e^{\pm(\sigma-1/2)}$ — so
it can **never be elliptic** (no imaginary part is available in a pure-growth,
real direction). It is confined to exactly two options:

$$\text{growth cell}=\begin{cases}\textbf{unipotent}\ (I+N,\ \mu=1) & \sigma=\tfrac12\\[4pt]\textbf{hyperbolic}\ (\mu\neq1) & \sigma\neq\tfrac12.\end{cases}$$

> **Condition (Cassini form of RH).** The Riemann Hypothesis is the statement
> that **the functional-equation growth cell is unipotent** — equal to the
> successor/counting operator $I+N$ — rather than hyperbolic. Equivalently: the
> conserved Cassini form of the growth cell is **positive semidefinite on its
> boundary (rank-deficient)**, never indefinite.

Three equivalent faces, all internal to the trichotomy:

1. **Generator form.** Write the per-zero generator $A=A_{\rm rot}+A_{\rm gr}$
   (rotation + growth, the elliptic + hyperbolic generators). RH $\Longleftrightarrow$
   $A_{\rm gr}$ is **nilpotent** ($A_{\rm gr}^2=0$, the parabolic generator $N$),
   not a boost. *Reality of the spectrum = nilpotency of the growth generator.*
2. **Growth law.** Unipotent $\Rightarrow$ the orbit grows **polynomially**
   ($I+kN$); hyperbolic $\Rightarrow$ **exponentially** ($e^{k\varphi}$). RH
   $\Longleftrightarrow$ the post-$\sqrt{x}$ fluctuation is polynomial, never
   exponential. (This is the classical $\psi(x)-x=O(\sqrt{x}\cdot\mathrm{polylog})$
   — recovered, not imported.)
3. **Collapse of the boundary.** The boundary is the additive group $G_a$ of
   translations $I+tN$, a *one-parameter line*. RH demands the growth cell sit at
   the **single** parabolic point $\mu=1$ — the line $G_a$ collapses to one
   point. That point is $s=1/2$ (the FE-fixed centre, $\gamma=0$, $c=1$). The
   user's hint — *"the naturals line must become the point $1/2$"* — is exactly
   this collapse.

## 5. "No free imaginary dimension" as the forcing clause

What would *force* the growth cell to be unipotent rather than hyperbolic? The
growth axis is **real** — there is no imaginary direction for a rotation to live
in. So the cell cannot be elliptic, and to avoid the hyperbolic (exponential)
branch it must sit on the **parabolic seam** between them. Stated as a demand on
the operator $T$:

> **No-free-imaginary-dimension clause.** $T$ is real and its growth generator is
> traceless with $A_{\rm gr}^2=0$. Then $T$'s spectrum cannot leave the rotation
> circle: with the imaginary direction closed off, the only real, bounded,
> determinant-preserving motion is rotation $\times$ translation — exactly
> elliptic-cell $\times$ unipotent-cell. RH is the assertion that $T$ is of this
> form.

Equivalently: **$T$ preserves a positive-semidefinite Cassini metric**
$Q_T=\bigoplus Q(c_n)$, with the rank-deficiency concentrated on the counting
boundary. A real $T$ that is an isometry of a genuine ($\succeq0$) inner product
has spectrum on the circle — it is forbidden the exponential escape.

## 6. The maximal squeeze (what is genuinely ours)

Collecting only what the trichotomy *gives*, not what it merely restates:

- **The form of the operator is forced**, not chosen: real $+\ \det=1\ +$ minimal
  2-term $\Rightarrow$ the successor operator $M(c)$. There is no other rank-1
  candidate.
- **RH = "the growth dynamics is pure counting."** The single sharpest sentence
  this analogy produces: *the functional-equation growth cell must equal the
  natural-number successor $I+N$.* The object the orbit project began with — the
  successor without $+1$ — **is** the critical-line locus. The fixed point of the
  whole construction is the naturals.
- **The failure mode is named geometrically:** off the line, the growth cell is a
  genuine boost, $Q_T$ goes indefinite, the orbit grows exponentially. We saw
  this concretely: the Davenport–Heilbronn off-line zeros are exactly growth
  cells with eigenvalues $e^{\pm\delta}\neq1$ (their $\delta=0.31,\,0.15$ are real
  boosts), and the Cassini/Weil form went indefinite on them.

## 7. Honest verdict

The trichotomy **derives the form** of the condition — *RH $\Longleftrightarrow$
the FE growth cell is unipotent (the successor $I+N$); off-line
$\Longleftrightarrow$ it is a boost* — and re-derives, without importing anything,
the classical statement (polynomial vs exponential fluctuation). What it does
**not** do is *force* the unipotency: nothing in the trichotomy alone closes the
imaginary dimension. "No free imaginary dimension" is a clause we can **state**
(real, isometric, nilpotent-growth) but not yet **impose** from within — imposing
it is precisely RH.

So the squeeze bottoms out at a clean, self-contained slogan and a precise gap:

> **The critical line is the locus where the operator's growth is the successor
> function itself — pure counting, $I+N$. RH says the operator never boosts. The
> trichotomy hands us this sentence and the failure mode; it does not hand us the
> reason the boost is forbidden.**

That last reason — why a real operator carrying the zeros must be isometric
rather than boosting — is the one thing the analogy cannot manufacture, and it
is the same wall every honest route reaches. But the sentence is ours, and it is
sharp: **counting is the critical line.**

**Postscript — the one falsifiable claim, tested (2026-06-15).** The operator
this exercise points at is a real **Jacobi matrix** (the three-term recurrence),
whose existence test is moment-positivity on $[-2,2]$. Its one genuinely
falsifiable, non-tautological question — does the hyperbolic growth-cell give an
*algorithmic edge* (cheap detection of an off-line zero) — was tested in
[`h2-results.md`](h2-results.md) and came out **null**: the detection order
scales as $K_{\rm detect}\sim(2\text{–}4)/\delta$, diverging as $\delta\to0$, i.e.
the route reduces exactly to the classical growth criterion. So the exercise is
**faithful scaffolding plus a design heuristic** (look for the operator as a real
Jacobi matrix whose off-diagonal is the counting/successor shift), with **no
algorithmic or proof advantage** — exactly as the change-of-variables no-go
predicts.
