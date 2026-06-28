# Tight-set residues and cyclotomic splitting: the AP-kernel residue across `q`

**Date:** 2026-06-28
**Context:** Direct follow-up to `docs/papers/primorial-formula.tex` (Thm "Modular closed
form" — the numerator residue `r`) and `docs/sessions/2026-06-24-prime-interval-detector/`
(§5/§10: `N = qB + r`, the predictable Wilson/tight-set residue `r`, equidistribution, the
two-knob AP-selective kernels `(qn+a)(qn+a+q)`). This session resolves the open direction
**"is the tight-set residue a Gross–Koblitz / class-number datum, or genuinely new?"** by
sweeping the AP modulus `q = 2, 3, 4`.

**One-line result.** The quadratic family (`q=2`, the original) **collapses** to a coarse
classical datum; for **`q ≥ 3` it does NOT collapse** — the band-prime residue is the
Gross–Koblitz `Γ_p(1/q)` shadow and carries the full **splitting of `p` in the cyclotomic
ring** (`4p = L²+27M²` for `q=3`; `p = a²+b²` for `q=4`). The "numerator carries no usable
signal" finding of the 2026-06-24 session (§10) is a **`q=2` artifact**.

---

## 0. The object and the question

Strip the dressing from the tight-set residue. For an AP-selective kernel with denominators
`≡ a (mod q)` and factorial weight, a band prime `p ≡ a (mod q)` enters at index
`j ≈ (p−a)/q`, so the leading `p`-adic coefficient of the rational is the **truncated
("`1/q`-th") factorial**
$$f_{1} \;=\; \Big(\tfrac{p-1}{q}\Big)!\ \bmod p \;=\; \text{the } \Gamma_p(1/q)\text{ shadow.}$$
**Question (gate candidate B, from the open-directions discussion):** is `f₁` *elementary*
(depends only on `p` mod small numbers — *collapses*), or does it carry genuine arithmetic
(*stays new*)? The discriminator is the corresponding **Gauss/Jacobi sum**.

---

## 1. `q = 2` — COLLAPSE (coarse / classical) — `scripts/01`

Original kernels: primorial `1/(2j+1)` and the interval detector `2/((2n+1)(n+1))`. Residue
`f₁ = ((p−1)/2)! = Γ_p(1/2)` shadow. Four checks, all verified:

| check | result | reading |
|---|---|---|
| Wilson `w² = (-1)^((p+1)/2)` | OK to `p=400` | `w=((p-1)/2)!` is the quadratic-Gauss shadow |
| **Mordell** `w = (-1)^((h+1)/2)`, `p≡3(4)` | **39/39** | `w∈{±1}` reads only `h(-p) mod 4` — **1 bit** |
| ground truth `N_k mod p` (real rational) `= ε·w/2` | **20/20** | the prime-entry residue *is* the half-factorial |
| interval detector multi-element residue `=` elementary staircase `(4ε,−2,−4ε/3)` | **1092/1092**, `0` carry `w` | heavy weight `2ᵐm!` **cancels** the lone half-factorial |
| `J(χ₂,χ₂) = −χ₂(−1)` | **14/14** | even the quadratic Jacobi sum is elementary |

So the deep part (`w`) is a **single bit** (`h mod 4`) for `p≡3`, a chosen `√−1` for `p≡1`;
and the multi-element residue dilutes to the elementary `χ₋₄`-staircase. **Collapses.** This
independently corroborates the 2026-06-24 §10 equidistribution / no-QR-bias result (the
residues carry only `χ₋₄`).

---

## 2. `q = 3` — NON-COLLAPSE (carries `4p = L²+27M²`) — `scripts/02`

Cubic AP kernel `S(k) = Σ_{j=1}^k (-1)^j j!/(3j+1)` (denominators `≡ 1 mod 3`). For a band
prime `p ≡ 1 (mod 3)` with a simple pole, `p·S ≡ ±f₁ = ±((p-1)/3)! (mod p)` — verified
**92/92**. With `4p = L²+27M²`, `L ≡ 1 (mod 3)`:

- **classical cubic binomial** `C(2k,k) ≡ −L (mod p)`, `k=(p-1)/3` — **50/50**;
- **the identity** (derived below) `f₁³ ≡ L⁻¹ (mod p)` — **271/271**;
- **full `(L,M)` recovered from the residue `f₁` alone** — **271/271**.

**Derivation (self-contained: Wilson + the binomial congruence).** With `k=(p-1)/3`:
$$(p-1)! \equiv (2k)!\prod_{i=1}^{k}(p-i)\equiv (2k)!\,(-1)^k k! \equiv -1,
\qquad \binom{2k}{k}=\frac{(2k)!}{(k!)^2}\equiv -L.$$
Eliminate `(2k)!`: `−L(k!)² ≡ (-1)^{k+1}(k!)^{-1}`, so `f₁³ = (k!)³ ≡ (-1)^k L^{-1}`. Since
`p` is odd, `3k = p−1` is even ⟹ `k` even ⟹
$$\boxed{\;\Big(\tfrac{p-1}{3}\Big)!^{\,3} \equiv L^{-1} \pmod p\;}$$
and `M` follows from `27M² = 4p − L²`. **The cube of the third-factorial inverts to the cubic
datum** — non-elementary, two-parameter, = the splitting of `p` in `Z[ω]`.

---

## 3. `q = 4` — NON-COLLAPSE (carries `p = a²+b²`) — `scripts/03`

Residue `((p-1)/4)! = Γ_p(1/4)` shadow. Classical (Gauss): for `p ≡ 1 (mod 4)`, `p = a²+b²`
(`a` odd), the quartic binomial `C((p-1)/2,(p-1)/4) ≡ ±2a (mod p)` — **51/51**. So the quartic
residue carries the splitting of `p` in `Z[i]`. Non-elementary, two-parameter.

---

## 4. Mechanism — why exactly `q = 2` is the coarse one

The residue is always the Gross–Koblitz `Γ_p(1/q)` shadow; whether it collapses is dictated by
the **Gauss sum's parameter count**:

- `q=2`: the quadratic Gauss sum is **classical-to-a-single-sign** (`g² = ±p`, Gauss's `±`),
  so its mod-`p` shadow is essentially **one bit**. Quadratic Jacobi sums are elementary
  (`J(χ₂,χ₂)=−χ₂(−1)`). → the whole quadratic world is coarse.
- `q≥3`: the cubic/quartic Gauss–Jacobi sums are **2-parameter**
  (`J(χ₃,χ₃) ↔ (L,M)`; `J(χ₄,·) ↔ (a,b)`), so their shadows encode the cyclotomic
  factorization of `p`. → non-elementary.

The collapse in §1 is therefore not an artifact of the heavy weight; it is structural to
`q=2`. The weight cancels the half-factorial only because the half-factorial was already a
single bit.

---

## 5. Verdict (gate-disciplined)

- **For the construction family: the door is OPEN at `q ≥ 3`.** Candidate B's continuation
  (= candidate E, the AP-selective kernels) produces band-prime residues that are
  **non-elementary and arithmetic-bearing**: they recover the splitting of `p`, not just `p`.
  This **refines** the 2026-06-24 §10 claim "the numerator carries no usable signal" — that was
  a **`q=2` artifact**. For `q=3` the numerator residue recovers `4p = L²+27M²`, strictly more
  than `p`.
- **For ANT: no new theorem.** `C(2k,k)≡−L`, `C((p-1)/2,(p-1)/4)≡±2a`, and `Γ_p(1/3)³↔L` are
  **classical** (Gauss / Jacobi / Cauchy; Ireland–Rosen, cubic & biquadratic reciprocity). The
  genuinely novel piece is only the **packaging**: a single *elementary alternating-factorial*
  object whose **denominator detects** the primes `≡ a (mod q)` *and* whose **numerator residue
  recovers their cyclotomic splitting** — the same "one construction, two channels" spirit as
  the primorial paper, now reaching the cyclotomic world.
- **Hardness conserved (no edge).** Recovering `L` via `((p-1)/3)!` costs `O(p)` mults;
  Cornacchia (`√−27 mod p` + Euclid, `O(polylog)`) gets the same `(L,M)` far faster. Structural
  / expository, **no speedup** — the program's signature.

---

## 6. Proof status (audit)

The underlying congruences are **classical theorems (proven)**; our `X/Y` counts **numerically
confirm** that the constructed objects instantiate them; one bridge — `f₁³≡L⁻¹` — and its
quartic twin were **proven this session** (Wilson + the classical binomial congruence).

| claim | status | source |
|---|---|---|
| Wilson `w²≡(-1)^{(p+1)/2}`; primorial residue `=εw/2` | **proven** | classical / primorial-formula.tex |
| Mordell `w=(-1)^{(h+1)/2}` (`p≡3`) | **proven** | Mordell 1961 / Dirichlet class number |
| interval residue = elementary staircase | **proven** | 2026-06-24 §3 band-law lemma |
| `J(χ₂,χ₂)=−χ₂(−1)`; `C(2k,k)≡−L`; `C(·,·)≡±2a` | **proven** | classical (Jacobi; Gauss — Ireland–Rosen) |
| **`f₁³≡L⁻¹`; `4a²((p-1)/4)!⁴≡−1`; `(L,M)`/`(a,b)` recovery** | **proven this session** | Wilson + the binomial congruences |
| every `X/Y` count | **numerically verified** | confirmation of the above, not the proof |

So nothing rests *only* on numerics over uncertain ground; the `X/Y` are confirmations of cited
theorems applied to our objects.

## 7. Directions 1 & 2 — resolved — `scripts/04`

**Direction 1 — quartic identity (PROVEN).** From `C((p-1)/2,(p-1)/4)=((p-1)/2)!/((p-1)/4)!²=w/g₁²≡±2a`
and `w²≡−1`, square to kill the sign:
$$\boxed{\;4a^2\,\Big(\tfrac{p-1}{4}\Big)!^{\,4}\equiv-1\pmod p\;}$$
verified **211/211**; `(a²,b²)` recovered from the residue alone **211/211**. Fully analogous to
`f₁³≡L⁻¹`: the residue is `Γ_p(1/4)` and its 4th power inverts the splitting coordinate `(2a)²`.

**Direction 2 — general `(q,a)`: the picture, with the earlier enthusiasm corrected.** The residue
is always the Gross–Koblitz `Γ_p(a/q)` shadow, but a **clean single-integer congruence
`f^q ≡ c/X` exists only for `q=3,4`** — exactly where `Q(ζ_q)` is imaginary quadratic and a classical
binomial congruence applies. Three sharp tests:

- **split vs inert (`q=3`).** Split class `a=1` (`p≡1 mod3`): `f³≡L⁻¹`, **115/115**. Inert class
  `a=2` (`p≡2 mod3`, no splitting in `Z[ω]`): only **36/122** match any small `c/X`, decaying like the
  `~24/√p` chance rate — i.e. **spurious; nothing to carry.** Non-collapse requires `p` to *split*.
- **`q=6` — same field, different character.** `Q(ζ_6)=Q(ζ_3)`, yet `((p-1)/6)!⁶=c·Lʲ` holds only
  **44/148**: the order-6 character is `χ₃·χ₂`, so its Gauss sum **entangles cubic × quadratic**
  (Hasse–Davenport). The **character order `q`, not just the field, selects the datum.**
- **`q=5` — richer field.** `Q(ζ_5)` has degree 4; the quintic Jacobi sum is a **vector** in `Z[ζ_5]`,
  not a single integer. No single-integer congruence survives (small-`X` hits **30/73**, decaying =
  spurious). Genuinely richer.

So the honest corrected verdict: the **clean, recoverable single-integer splitting** is special to
`q=3,4`; `q=6` entangles, `q≥5` is a vector, inert classes carry nothing.

## 8. What a proof reveals — Stickelberger

A *uniform* proof routes through **Gross–Koblitz** (the factorial residue `((p-1)/q)!` is the mod-`p`
shadow of the Gauss sum `g(χ)`, `χ` of order `q`) and **Stickelberger** (the prime-ideal factorization
of `g(χ)` in `Q(ζ_{pq})`, with valuations the fractional parts `{a/q}`). This *explains* rather than
verifies the whole table:

- `q=2` coarse ⟺ the quadratic Gauss sum is determined by its square up to Gauss's single sign (one bit);
- `q=3,4` single-integer ⟺ `J(χ,χ)` lies in an imaginary-quadratic field (one coordinate + norm);
- `q=6` entangled ⟺ Hasse–Davenport factors `g(χ₆)` through `g(χ₂)g(χ₃)`;
- `q≥5` vector ⟺ the Jacobi sum generates a higher-degree subfield.

The further light, conjectural but concrete: the primorial paper's **tight set** and **freezing**
combinatorics (which prime powers appear in the `ν_p` bookkeeping) look like the **elementary mod-`p`
shadow of the Stickelberger relation** — the fractional-part data `{a/q}` reappearing as the tight-set
index condition. Making that precise (tight set ⟷ Stickelberger element) is the natural next proof
and would tie the whole construction family to a single classical theorem.

**Update — attempted (`scripts/06`).** The loop *closes and verifies* (80/80): the construction residue
`((p-1)/3)!` computes the **trace of the genuine Jacobi sum** `J(χ,χ)=A+Bω ∈ Z[ω]`
(`L=1/f³≡±(2A−B) mod p`), and `N(J)=p` confirms Stickelberger's degree-1 factorization
`(e_1,e_2)=2⟨c/3⟩−⟨2c/3⟩=(0,1)`. But the bridge is a **recognition, not a new theorem**: the
construction sits at the *Gross–Koblitz* end (it computes the sum's value mod `p`), Stickelberger governs
the *same* sum's factorization, and the shared engine is **Legendre's digit sum** `ν_p(j!)=(j−s_p(j))/(p−1)`
— the Kummer machinery that already *proves* Gross–Koblitz. Crucially, for the clean single-factor kernel
the surviving index `j=(p−1)/3 < p` is a *single base-`p` digit*, so `s_p(j)=j` and the Stickelberger
fractional-part structure is **dormant** (`ν_p(j!)=0` trivially). It is exercised only in the
prime-power / multi-element **freezing** regime (indices `≥ p`). So the genuinely-open question is
*narrower* than "tight set ⟷ Stickelberger": does the **freezing combinatorics** (where digit sums are
non-trivial) reproduce the Stickelberger fractional parts by an elementary, character-free computation?
The clean identities sidestep exactly that regime.

## 9. What each ingredient does, and the numerator congruence — `scripts/05`

Disassembling the construction `S^{(q)}_k=\sum_{j}(-1)^j j!/(qj+1)=N_k/D_k` shows the arithmetic and
the prime-detection are carried by **different ingredients**.

**The numerator congruence.** For a simple-pole band prime `p≡1 (mod q)` (verified 48/48, `q=3`):
$$N_k \;\equiv\; \underbrace{\frac{D_k}{p}}_{\text{prime-product dressing (inert)}}\;\cdot\;\underbrace{(-1)^{(p-1)/q}\Big(\tfrac{p-1}{q}\Big)!}_{\text{cyclotomic splitting (deep)}}\pmod p.$$
The clean factorial is `p\cdot S\bmod p`, i.e. the numerator with the denominator-dressing `D_k/p`
divided out. This is the **same shape** as the primorial paper's modular theorem
(`N_k≡(m\#/p)·[(-1)^{(p-1)/2}((p-1)/2)!/2]`): *numerator ≡ (denominator-dressing) × (arithmetic
factorial)*. All deep content sits in the factorial; the dressing is an inert product of primes.

**The three ingredients (each verified):**

| ingredient | role | evidence |
|---|---|---|
| **weight `j!`** | carries the arithmetic; **sign-blind** | `q=3` residue identity holds with *and* without `(-1)^j` (92/92 both) |
| **sign `(-1)^j`** | bookkeeping for the **denominator**'s prime-square cancellations | drop it ⟹ `q=4,k=6` loses the prime `5` (`25=5²`), the paper's `q=2` `9=3²` analogue |
| **addition** | collapses to **one term** mod `p` | `p\cdot S≡((p-1)/3)!` exactly (92/92); higher-multiple terms vanish (index `≥p` ⟹ factorial `∋p`) |

So there is **no additive miracle**: mod `p` the sum *is* a single factorial, because every other term
vanishes. Forcing genuine 2-term addition (two-factor kernel `1/((3n+1)(3n+4))`, both indices `<p`)
keeps the content — the residue becomes an *elementary multiple* `-\tfrac{p+2}{3}((p-1)/3)!` of the
same factorial and still determines `L` (47/47). The only thing that *destroys* the content is a **heavy
weight** that cancels the factorial (the `q=2` interval detector's `2ᵐm!`), never the addition itself.

**Is the rewrite a lever to simplify?** (gate-checked) It cleanly **separates** the construction into a
*denominator* (prime-detection) × *per-prime residue* (explicit factorial). Consequences:

- **Residue / arithmetic channel — modest cheapening (= known).** The rewrite gives a direct per-prime
  formula for `r=N_k\bmod D_k` (= the CRT of `(D_k/p)·factorial`), letting you **skip the
  factorial-growth quotient** `q` entirely if you only want `r`. This is the 2026-06-24 §5/§10 result,
  now with the residue written explicitly as a factorial; still sieve-bound, no new edge.
- **Denominator channel — no lever.** Every split prime's residue is a *nonzero* factorial, so survival
  is automatic; but computing `D_k` is still the existing `O(k)` recurrence / `p`-adic clip, and the
  denominator is the primorial `=e^{θ}` with **no elementary closed form** (= the prime-distribution
  hardness). The rewrite explains survival; it does not beat the sieve.
- **Beautiful closed form — blocked by the wall.** Denominator `↔ θ` (Chebyshev), residue `↔ Γ_p(1/q)`
  (Gauss sum); neither is elementary. The construction is already minimal *modulo* that hardness.

Verdict: a **clarifying** lever (clean weight/sign/addition split + explicit residue), and a genuine but
**modest** cheapening of the residue channel — **not** a cracking lever. Hardness conserved.

## Scripts

| file | content | verified |
|---|---|---|
| `scripts/01_quadratic_collapse.gp` | half-factorial = `h mod 4` (Mordell); ground truth; interval multi-element residue collapses to elementary staircase; quadratic Jacobi elementary | Wilson→400, 39/39, 20/20, 1092/1092, 14/14 |
| `scripts/02_cubic_noncollapse.gp` | `C(2k,k)=−L`; residue = `±((p-1)/3)!`; `f₁³≡L⁻¹`; full `(L,M)` from residue | 50/50, 92/92, 271/271, 271/271 |
| `scripts/03_quartic.gp` | `C((p-1)/2,(p-1)/4)=±2a`, carries `p=a²+b²` | 51/51 |
| `scripts/04_directions.gp` | Dir.1 quartic identity `4a²g₁⁴≡−1` + recovery; Dir.2 split/inert, `q=6` entanglement, `q=5` richness | 211/211, 115/115 vs 36/122, 44/148, 30/73 |
| `scripts/05_mechanism.gp` | weight/sign/addition roles; single-term collapse; forced 2-term still carries `L`; numerator congruence `N_k≡(D_k/p)·factorial` | 92/92, 92/92, 47/47, 48/48 |
| `scripts/06_stickelberger.gp` | residue = trace of Jacobi sum `J=A+Bω`; `N(J)=p` (Stickelberger deg-1); digit-sum engine dormant for clean kernel | 80/80, 80/80 |
| `scripts/07_freezing_kummer.gp` | freezing-regime test: Gauss-sum/digit-sum **anti-correlation** (signal dormant; contamination character-free); Stickelberger = Kummer carry | dormant, 95/95, 6400/6400 |
| `scripts/08_pointcount.gp` | **capstone**: `L = N_aff(x³+y³=1)−(p−2)` (Gauss) `= −a_p(y²=x³−432)` (j=0 Frobenius) | 21/21, 21/21 |

Run: `gp -q scripts/0X_*.gp`.

## 10. Capstone — the family's most concrete image

> **An alternating factorial sum whose *denominator* is the primorial has a *numerator* that
> counts the points of `x³+y³=1` mod each prime.**

Precisely (`scripts/08`, 21/21): the construction's `L = 1/((p-1)/3)! ³ (mod p)` equals
`N_aff − (p−2)` where `N_aff = #{(x,y)∈𝔽_p² : x³+y³=1}` (Gauss), and `= −a_p` of the `j=0`
elliptic curve `y²=x³−432` (trace of Frobenius). Classical (Gauss / CM theory) — the fifth
recognition, and the single sentence that best advertises the whole session: the denominator
detects the primes, the numerator counts points on a Fermat curve over each of them.

---

## Status / adversarial

- ✅ **`f₁³ ≡ L⁻¹ (mod p)` proven** (Wilson + the classical binomial congruence) and verified
  271/271 to `p < 4000`; `(L,M)` recovered from the residue alone 271/271.
- ✅ Quadratic collapse hardened over **all** band primes (`m ≤ 60`, 1092 residues), not just a
  sample; `0` carry the half-factorial.
- ⚠️ **The arithmetic is classical, not new.** The contribution is the *unified construction*
  (one elementary object: prime-detector denominator + cyclotomic-splitting numerator) and the
  *structural fact* that `q=2` is uniquely coarse. No new theorem of number theory.
- ⚠️ **No algorithmic edge** (sibling caveat): Cornacchia beats the factorial residue for
  `(L,M)`; hardness conserved.
- ✅ Direction 1 closed (§7): direct quartic identity `4a²((p-1)/4)!⁴≡−1` proven (Wilson + quartic
  binomial) and verified 211/211; `(a²,b²)` recovered from the residue alone 211/211.
- ⚠️ Earlier framing corrected (§7): the clean single-integer splitting is special to `q=3,4`. `q=6`
  entangles cubic × quadratic (Hasse–Davenport), `q≥5` is a vector datum, inert classes carry nothing.
  The `q=5`/inert "richness" is argued via the `~24/√p` spurious-match rate (numerical + multiple-testing
  caveat, in the spirit of the prior session's `C(2k,k)` mirage), not proven.

---

## Open directions (gate-checked)

- ✅ **RESOLVED — `q=2` vs `q≥3` dichotomy** (§1–4): collapse is structural to the quadratic Gauss
  sum's single-bit content; `q=3,4` carry a single-integer splitting coordinate.
- ✅ **RESOLVED — Direction 1, quartic power identity** (§7, `scripts/04`): `4a²((p-1)/4)!⁴≡−1`,
  proven, `(a²,b²)` recovered 211/211. The `q=2,3,4` table is symmetric.
- ✅ **RESOLVED (with nuance) — Direction 2, general `(q,a)`** (§7): residue = `Γ_p(a/q)` shadow;
  single-integer congruence only `q=3,4`; `q=6` entangled; `q≥5` vector; inert class carries no datum.
- ❌ *Rejected — "the residue is a NEW mod-`p` object":* non-elementary for `q≥3` but **classical**
  (Gross–Koblitz / Gauss–Jacobi). Channel-match holds, but check-3 (literature): textbook congruences.
  Novelty is packaging, not mathematics.
- ❌ *Rejected — algorithmic use of the cyclotomic-splitting numerator:* `O(p)` vs Cornacchia
  `O(polylog)`. Hardness conserved (check-2 / no-edge).
- ⚠️ *Attempted — tight set ⟷ Stickelberger* (§8, `scripts/06`): the loop verifies (80/80) but is a
  **recognition** (Gross–Koblitz + Stickelberger on the same Jacobi sum), engine = Legendre digit sum;
  **no new theorem**, and the digit-sum structure is *dormant* in the clean kernel. Downgraded from
  "deepest thread" to "classical recognition."
- ✅ **RESOLVED — Stickelberger in the freezing regime** (`scripts/07`): **closed, Kummer-classical**, by
  a clean **anti-correlation**: a Gauss sum is attached *only* at signal primes, where the index
  `(p−1)/q < p` is a single digit (digit sum dormant; `ν_7` stays 1 and the residue is unchanged even
  when `49=7²` enters, 95/95); non-trivial digit sums occur *only* at contamination primes, which carry
  **no character/Gauss sum** in the construction. The two never coincide, so the construction is
  *structurally incapable* of producing non-trivial Stickelberger content from elementary data. Where the
  digit-sum machinery appears at all, it is **Kummer's carry count** `= ν_p\binom{a+b}{a}` (6400/6400) —
  Legendre 1808 / Kummer 1852; Gross–Koblitz 1979 is the bridge to Gauss sums. No new elementary route.
- ✅ **RESOLVED (capstone) — the numerator point-counts the Fermat cubic** (§10, `scripts/08`): `L =
  N_aff(x³+y³=1)−(p−2) = −a_p(y²=x³−432)`, 21/21. Classical (Gauss/CM) — a fifth recognition, kept for
  its expository value (the family's most concrete image). *(Earlier "most likely to surprise" billing
  retracted — it is a recognition like the rest.)*
- ❌ *Rejected — `q=6` disentanglement:* would work (Hasse–Davenport `g(χ₆)=g(χ₂)g(χ₃)`) but is pure
  table-completeness — another textbook composite-character recognition, low expository payoff. Not worth
  it; the `q=2,3,4` pattern is already established and explained.
