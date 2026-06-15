# Hyperbolic / Periodic Duality and the Critical Line

**Date:** 2026-06-15
**Status:** 🤔 SYNTHESIS + 🤔 HYPOTHESES (documented before testing, per Hypothesis-First protocol)
**Lineage:** late-night synthesis joining three prior threads —
- the Cayley–Klein triptych of the successor orbit
  ([`2026-04-04-algebraic-sine-successor`](../2026-04-04-algebraic-sine-successor/),
  esp. [`degenerate-case-additive-group.md`](../2026-04-04-algebraic-sine-successor/degenerate-case-additive-group.md),
  [`zeta-orbit-mapping.md`](../2026-04-04-algebraic-sine-successor/zeta-orbit-mapping.md),
  [`parabolic-limit.md`](../2026-04-04-algebraic-sine-successor/parabolic-limit.md),
  [`dual-orbit-zero-counting.md`](../2026-04-04-algebraic-sine-successor/dual-orbit-zero-counting.md));
- the `zzz` self-paving `--loop` and its band-saturation / spectral-shadow law
  (`zzz/doc/notes/band-saturation.md`, `zzz/doc/notes/spectral-shadow.md`);
- the three "suspects" of `zzz`'s `intuition.txt` capstone — integrality as
  quantization, criticality as universality, self-duality as positivity.

> **One-line thesis.** The critical line `σ = 1/2` is the periodic⇄hyperbolic
> divide — but of the *functional-equation pair* `{ρ, 1−ρ}`, not of a single
> zero; "counting on the boundary" is the parabolic point at the center of that
> divide; and the thing that makes the divide *be* `σ = 1/2` is **positivity**,
> realized concretely as the sign of the discriminant `1 − ĉ²` of the orbit's
> conserved Cassini form.

This document records the analogy *and* the two exact points where its naive
version breaks, then converts the surviving content into falsifiable
experiments. The breaks are kept deliberately — they are what make the
experiments worth running rather than tautological.

---

## 1. The dictionary

A zeta zero `ρ = σ + iγ` has transfer-matrix eigenvalue `e^{ρ} = e^{σ}·e^{iγ}`.
That product *is* the hyperbolic × periodic split:

| zero datum | orbit datum | regime axis |
|---|---|---|
| modulus `e^{σ}` (growth) | `√det M` | **hyperbolic** / `G_m` / radial |
| phase `e^{iγ}` (rotation) | `c = cos γ` | **periodic** / `SO(2)` / angular |
| pole at `s=1` (`γ=0 ⟹ c=1`) | degenerate `c=1` (naturals, `U_k(1)=k+1`) | **parabolic boundary** = counting |

The Cayley–Klein triptych (from `degenerate-case-additive-group.md`):

| regime | `c` | eigenvalues of `M` | group / `F_p` | curvature |
|---|---|---|---|---|
| oscillatory | `\|c\|<1` | `e^{±iθ}` (circle) | non-split torus, `p+1` | elliptic `κ>0` |
| **degenerate** | `c=1` | `1,1` (Jordan) | `G_a` additive, `p` | **Euclidean `κ=0`** |
| hyperbolic | `c>1` | `λ, 1/λ` real | split torus `G_m`, `p−1` | hyperbolic `κ<0` |

The two regimes are literally **one function on two axes of ℂ**:
`cos θ` (real axis, `|c|≤1`, periodic) and `cos(iφ)=cosh φ` (imaginary axis,
`c≥1`, hyperbolic), meeting at the origin `θ=0 ⟺ c=1`, the parabolic boundary.
This is the rotation/boost Wick rotation `θ ↔ iφ`.

## 2. Where the functional equation lives

A single genuine zero has real `γ`; after `÷√x` normalization its eigenvalue is
pure phase `e^{±iγ}` — *always* on the circle, *always* periodic. The hyperbolic
regime therefore never appears in **one** zero. It appears in the **pair the
functional equation forces**, `{ρ, 1−ρ}`, in its growth (modulus) coordinate:

- eigenvalues `e^{±(σ−1/2)}`, real, with `ĉ := cosh(σ − 1/2) ≥ 1`;
- `σ ≠ 1/2` ⟹ `ĉ > 1` ⟹ **hyperbolic** (distinct real `λ, 1/λ`);
- `σ = 1/2` ⟹ `ĉ = 1` ⟹ **parabolic boundary** (eigenvalues collide on the divide).

So the FE reflection `σ ↔ 1−σ` *is* the orbit eigenvalue inversion `λ ↔ 1/λ`
(`det`-1 normalized), and

> **RH ⟺ the FE-pair is never strictly hyperbolic — it sits forever on the
> parabolic divide.**

The parabolic center of the line, `s = 1/2` real (`γ=0 ⟹ c=1`), is the
**counting point**: `U_k(1)=k+1`, the main term, where rotation and boost both
contract to `+1`. Counting sits on the boundary in *both* worlds, and at one
shared point. (The `s=1` pole is the *other* `γ=0/c=1` point — same parabolic
character, different `σ`. The two "counting" images are the main-term pole and
the FE-symmetry center.)

## 3. The central join — positivity = the sign of one discriminant

The successor recurrence `f_{k+1} = 2c·f_k − f_{k-1}` conserves the **Cassini
form**

```
Q(u,v) = u² − 2c·u·v + v²,   matrix [[1, −c], [−c, 1]],   det Q = 1 − c².
```

(Verified conserved by one step: `Q(2c f_k − f_{k-1}, f_k) = Q(f_k, f_{k-1})`.)
Its **signature is the triptych**:

| regime | `det Q = 1 − ĉ²` | `Q` | RH meaning |
|---|---|---|---|
| periodic | `> 0` | **positive definite** (invariant ellipse) | on the line |
| parabolic | `= 0` | **positive semidefinite** (the divide) | the line / counting |
| hyperbolic | `< 0` | **indefinite** (1,1) (invariant hyperbola) | off the line |

For the FE-pair, `det Q = 1 − cosh²(σ−1/2) = −sinh²(σ − 1/2)`: zero exactly on
the line, negative off it.

> **This is Weil positivity wearing a body.** RH ⟺ the explicit-formula
> quadratic form never goes indefinite ⟺ the Cassini discriminant `1 − ĉ²`
> never changes sign. The "two sides of one coin" are the two signs of one
> discriminant; the coin's edge (positive *semi*definite) is the line, where
> counting lives. This is precisely suspect (3) of `intuition.txt`
> ("find the thing that is its own shadow"), now concrete.

## 4. The two exact breaks (kept on purpose)

**Break A — "zeros densify / primes thin" is a *different* duality.** ⚠️
There are two dualities, and conflating them is the trap:
- **Duality I (Cayley–Klein):** *inside one zero*, `σ`(hyperbolic) × `γ`(periodic).
  Boundary = `σ=1/2`. This is §1–§3 above.
- **Duality II (explicit formula):** *between the two populations*, zeros ⇄ primes,
  a Fourier/Poisson pairing of the `γ`-line and the `log p`-line. "Densify/thin"
  is the Fourier reciprocity of **Duality II**.

You cannot set "zeros = periodic side, primes = hyperbolic side." In
`dual-orbit-zero-counting.md` *both* primes and zeros get the *same* periodic
parametrization (`c_p = cos(log p / N')`, `c_n = cos γ_n`) — they are symmetric,
both on the circle. Duality II does **not** "meet on the line"; it is a transform
between two real axes. `σ=1/2` enters Duality II only as the value that makes the
transform **self-dual / positive**. So the honest join is: *`σ=1/2` (the
Duality-I boundary) is the value at which the prime↔zero pairing (Duality II)
becomes positive.* The two coins touch **through positivity**, not by
primes-being-hyperbolic.

**Break B — one-body kinematics vs many-body dynamics.** ⚠️ The orbit triptych
is rank-1: one eigenvalue pair, one circle per zero. It captures the *kinematics*
(where a zero may sit: on the divide) but is blind to the *dynamics* — level
**repulsion**, which is the actual fingerprint of self-adjointness. That is
exactly where the `zzz` work bites: the **κ=π crystalline→GUE crossover**
(`spectral-shadow.md`) is a *many-body* statement about how the phases `γ_n`
repel. A single Cassini circle says nothing about it. To make the orbit picture
see κ=π you must put the orbits *in interaction* — i.e. build the operator whose
eigenvalues are the `γ_n`. That is Hilbert–Pólya, unsolved.

**Symmetry verdict.** Symmetry *supports* the kinematic claim: the pinning
symmetry is `λ = 1/λ̄ ⟺ |λ|=1 ⟺ unitarity`. It *discourages* over-reading: the
`÷√x` normalization that makes `σ=1/2` the boundary is **inherited from the FE**
(`ξ` symmetric about `1/2`), not derived by the orbit. The orbit geometrizes
"FE-self-dual = positive = on the divide"; it does not independently produce the
`1/2`. **Lens, not lever** — the same verdict `zeta-orbit-mapping.md`'s honesty
table and `intuition.txt` both reach.

## 5. Synthesis — one object, three suspects

If we refuse to let the breaks paralyze us, the daring picture is a single
**self-dual periodic orbit family** in which `intuition.txt`'s three suspects are
three facets:

1. **positivity** of its Cassini form `1 − ĉ²` forces the FE-pair onto the divide → `σ=1/2` (RH);
2. **integrality** picks the resonances on the circle → the actual `γ_n`
   (the parabolic-limit resonances: `e^{iπ/t}` a root of unity only at integer
   `t`, by Niven — "primes are integers" as a quantization, `parabolic-limit.md`);
3. **criticality** is the κ=π edge where its statistics flip crystalline→GUE →
   the `zzz` universal crossover.

Positivity puts the spectrum *on the circle*; integrality picks *which points*;
criticality is *how rigidly* they sit. The leap that would close it is the one
neither human nor model yet has: **interaction**, i.e. the operator.

---

## 6. Can we falsify any of this? (the point of the session)

The danger, named bluntly (per the `tautology-check` and `relaxed-rigor`
disciplines): `det Q = −sinh²(σ−1/2)` is a monotone function of `σ`, so any test
that *starts from known zero positions* is tautological — it "detects" `σ≠1/2`
only because we fed it `σ`. **A test has content only if the signature is
computed from the prime / band side (Weil functionals), never from the zero
locations.** Every experiment below obeys this guard, and each is designed so a
**negative** result is informative — so we never discard the lens merely because
the dynamics-unification is hard.

### Experiment 0 — the necessary-condition gate (cheap, decisive if it fails)

✅ **RUN 2026-06-15 — mechanism gate PASSED** ([`exp0-results.md`](exp0-results.md))
**and emergent gate PASSED** ([`dh-results.md`](dh-results.md)).

*Mechanism (planted):* the Weil form built from the **geometric side** (primes +
Γ + pole, validated to 24 digits against the true zeros, zeros never consulted)
is **PSD for genuine ζ**; a planted FE-symmetric off-line quartet flips it
**indefinite** at a finite threshold `δ*≈0.035`, deficit `∝ δ²` to leading order
(consistent with `−sinh²(σ−1/2)`; leading order is generic, not a unique
confirmation).

*Emergent (Davenport–Heilbronn):* the DH function (FE, **no** Euler product) is
set up self-validated (`κ` from the Gauss sum = closed form to 20 digits; FE to
`10⁻²³`); its off-line zeros are found directly (`0.8085+85.699i`, δ=0.31; the FE
pair `0.651/0.349+114.163i`, δ=0.15, to 28-digit `|f|`); its arithmetic-side Weil
form (`Λ_f` from `−f'/f` + Γ, validated to 25 digits, **zeros never consulted**)
goes strongly indefinite **exactly at those off-line heights**, as δ-ordered
negative spikes 100–600× above the on-line baseline. Crucially, detection is
**resolution-gated** — coarse bands see PSD, fine bands see the violation — i.e.
**band-saturation in the positivity channel**, the direct empirical hook for H1.

🤔 **Hypothesis H0 (original, partially settled).** The orbit–Cassini positivity
signature, built from the explicit formula (prime side only), is positive
(semi)definite for genuine `ζ` and **indefinite** for the Davenport–Heilbronn
function `f(s)` — the canonical object with a functional equation but zeros off
the critical line (and no Euler product, which is *why* it can break RH).

- **Compute:** the Weil/explicit-formula quadratic form `W[g,g]` on a small space
  of band-limited test functions `g` (prime side cut at `p^m ≤ X`), for `ζ` and
  for `f`. Take its smallest eigenvalue `λ_min`.
- **Confirms:** `λ_min(ζ) ≥ 0` (definite/on-divide) while `λ_min(f) < 0`
  (indefinite/hyperbolic — the off-line zeros register as a hyperbolic FE-pair).
- **Falsifies the lens entirely:** if the signature does **not** distinguish `f`
  from `ζ`, the orbit reformulation carries no RH information → discard as
  decorative. This is a *necessary* condition; passing it is not yet a discovery,
  failing it is fatal.
- **Feasibility:** Wolfram, hours. `DH = (1/2)(ζ(s,a) + ζ(s,1−a))`-style
  combinations; zeros and FE standard. The Weil-form assembly reuses
  `zzz/doc/ghy/e4-weil-identity.wls` (exact `sinc^{2q}`/B-spline pairs, 34-digit
  identity already validated).

### Experiment H1 — the prize: is the LINE more rigid than the ZEROS?

This is the falsifiable core, and it operationalizes the "positivity?" channel
directly against the `zzz` κ=π wall.

🤔 **Hypothesis H1.** Let the Weil-fit (`zzz --weil`, `e4-fit.wls`) optimize zero
configurations against band-limited prime data, but with the real part `σ`
**freed** (a 2-D fit `σ + iγ`, not constrained to the line). Started from an
off-line configuration (`σ ≠ 1/2`), measure whether the fit restores `σ → 1/2`,
as a function of the band parameter `κ = gap·log X`. Equivalently: compute the
Weil-form Hessian eigenvalue *in the σ-direction* at the true configuration vs `κ`.

Three distinguishable outcomes — **all informative**:

| outcome | meaning |
|---|---|
| σ-pinning onset at **κ < π** | **positivity beats resolution** — the band-limited primes "know" the zeros are on the line even when they cannot say *where* (γ is in the null space below π, but σ is not). This would be a **genuinely new phenomenon** and the strongest possible support: positivity carries information the counting resolution does not. |
| σ-pinning onset **exactly at κ = π** | **one wall.** The positivity rigidity and the level-repulsion onset and the resolution wall are the *same* critical crossover. Duality-I (the divide) and the `zzz` criticality coincide → the unification is exact. |
| σ-pinning needs **κ > π** | positivity is weaker than resolution → the divide is a derivative label, the lens is decorative on the dynamics. |

- **Prior prediction (stated before testing).** Band-saturation says individual
  `γ` positions are in the null space of the data below κ=π. `σ` is an even finer
  feature, so naively σ-pinning should require κ ≥ π. The *interesting* break
  would be κ < π. I genuinely do not know which; that is what makes it a test.
- **Falsifies the strong claim:** if `σ` is a flat (null) direction at *all*
  feasible κ — i.e. the data never pins the line — then "positivity pins `σ=1/2`"
  is not encoded in finite prime data at all, and the positivity story is
  asymptotic-only (still true as Weil's theorem, but with no finite-`X` shadow).
- **Feasibility:** extend `e4-fit.wls` to a 2-D (σ,γ) parameterization of the
  explicit formula (`x^ρ/ρ` for general `ρ`, not just `1/2+iγ`); sweep `X` with
  the existing `loop-band-rigidity.py` band machinery. Moderate code, all on
  existing infra.

### Experiment H2 — is κ=π a parabolic degeneration? (speculative, needs the operator)

🤔 **Hypothesis H2.** The κ=π crossover *is* the orbit's parabolic boundary
mechanism: the band-limited counting/projection operator undergoes a Jordan-type
eigenvector collision (the √-sensitivity of `parabolic-limit.md`, amplification
`~p³`) precisely at κ=π.

- **Compute:** the condition number / smallest eigenvalue-gap of the
  band-limited transfer (projection) operator that `--loop` iterates, as a
  function of κ. Look for an eigenvector-collision signature
  (`cond ~ 1/√(κ−π)` or similar) at κ=π.
- **Confirms:** a defective-matrix signature at κ=π identifies the spectral
  crossover with the parabolic contraction `SO(2)→(ℝ,+)`.
- **Falsifies:** the operator stays well-conditioned through κ=π → the `zzz`
  criticality is *not* the orbit's parabolic degeneration; the two "criticalities"
  are merely homonyms.
- **Status:** requires identifying the right finite operator (which is close to
  "the operator" HP wants); honest about being the least ready of the three.

### Anti-tautology checklist (applies to all three)

- [ ] Signature/pinning computed from **prime side / band-limited functionals**, never from known `σ`.
- [ ] At least one outcome is a clean **falsification**, not just confirmation.
- [ ] Davenport–Heilbronn (real off-line zeros) used as the live control — not an injected `σ≠1/2` (which would re-detect what we put in).
- [ ] κ-scaling is a prediction *not implied* by the RH⟺Weil-positivity equivalence (that equivalence is silent about finite `X`).

---

## 7. Honest assessment

| claim | status |
|---|---|
| `σ`(hyperbolic)×`γ`(periodic) split of `e^ρ`; FE reflection = `λ↔1/λ` | ✅ exact restatement |
| RH ⟺ FE-pair on the parabolic divide ⟺ Cassini `1−ĉ²` never `<0` | ✅ = Weil positivity, geometrized |
| primes = hyperbolic side, zeros = periodic side | ❌ **false** (Break A — both are periodic in Duality II) |
| orbit picture sees level repulsion / GUE | ❌ **false** (Break B — one-body, no interaction) |
| the lens proves / levers RH | ❌ inherits `1/2` from the FE; lens not lever |
| H0 (ζ vs Davenport–Heilbronn signature) | ✅ PASSED — ζ PSD; DH indefinite at its off-line zeros, from arithmetic alone; detection resolution-gated |
| H1 (σ-rigidity onset vs κ=π) | 🤔 untested — the falsifiable prize |
| H2 (κ=π = parabolic degeneration) | 🤔 untested — speculative, needs the operator |

**Bottom line.** The poetry reduces to one solid mathematical statement (positivity
= the sign of the Cassini discriminant of the FE-pair) and one genuinely
falsifiable empirical question that did not exist before (**is the critical line
more rigid than its individual zeros, and does that rigidity switch on at the same
κ=π as level repulsion?**). The lens survives Breaks A and B as a lens; H1 is the
experiment that could promote it from poetry to physics — or cleanly retire it.
