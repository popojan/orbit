# The snap-to-ℤ atom — where the arithmetic lives

*A reflection growing out of the primorial / closed-form thread. Not a result; a synthesis of
one idea seen from five sides — closed-form prime detectors, the explicit formula, numerical
precision, the Eudoxus reals, and the zzz `--loop`. The claim is that all five share a single
irreducible primitive: a snap-to-ℤ (an integrality test), and that this atom is exactly where
primality / exactness / discreteness is forced to live, while everything continuous around it
carries structure but no arithmetic.*

## 1. The atom: every closed-form prime detector needs one integrality test

The Wilson-style closed forms detect primality through one operation:
`FractionalPart[(n-1)!/n]` (= `Mod[(n-1)!,n]/n`), which is `(n-1)/n` if `n` is prime and `0` if
composite. The von Mangoldt function has the same shape — one such atom per term:
$$\Lambda(n) = \Big\lfloor \tfrac{1}{C(n)}\Big\rfloor\sum_{d=2}^{n} W(d)\,\delta_d(n)\log d,\quad
W(d)=\Big\lfloor\tfrac{(d-1)!\bmod d}{d-1}\Big\rfloor,\ \ \delta_d(n)=\big\lfloor\tfrac nd\big\rfloor-\big\lfloor\tfrac{n-1}d\big\rfloor,$$
with `C(n)=Σ W(d)δ_d(n) = ω(n)`. (Verified: gives `log p` at prime powers, `0` else.) This is the
Willans (1964) tradition — Wilson + floor — already cited in the primorial paper.

**The atom cannot be eliminated, only relocated.** The prime indicator is *not an algebraic
function of `n`*: a rational (or algebraic) function equal to `1` at every prime would have
`R−1` vanishing at infinitely many points, hence `R≡1` — contradiction. So at least one
**non-field primitive** is mandatory, and `Floor`, `FractionalPart`, `Mod`, `sin(πx)`,
`e^{2πix}`, `GCD` are exactly the menu of such primitives. A hierarchy:

| primitive | weight |
|---|---|
| `Floor` ≡ `FractionalPart` ≡ `Mod` ≡ `Round` | the **atom** — a single "snap to integers" |
| `sin(πx)`, `e^{2πix}` | the same atom, dressed analytically (periodicity = mod) |
| `GCD` | strictly heavier — Euclidean iteration |

`FractionalPart` is the minimal representative; you cannot purify below it.

## 2. Closed form ≠ shortcut

The closed-formness is genuine and is the property one wants — but it is a closed *form*, not a
closed-form *shortcut*. The factorial `(n-1)! mod n` is the *slowest* primality test (`O(n)`
naïve, `Õ(√n)` Strassen), and computing factorials mod `n` is itself believed hard — a polylog
algorithm would break factoring (Strassen 1976 factors via `⌊√n⌋! mod n` + gcd). Hardness
conserved: the elegance moves the work into the factorial, it does not remove it.

## 3. The Fourier question: summing detectors collapses — but only into the zeros

The detector is *already* Fourier: `{x} = ½ − (1/π)Σ_k sin(2πkx)/k` (sawtooth), and divisibility
is a root-of-unity sum `𝟙[q∣m] = (1/q)Σ_j e^{2πijm/q}`. So swapping `FractionalPart` for a
periodic function unfolds the atom; it does not escape it.

Does the *sum* of detectors simplify Fourier-like? Yes — profoundly. Summing the `Λ` closed form
gives `ψ(x)`, whose collapse is the **explicit formula**
$$\psi(x)=\sum_{n\le x}\Lambda(n)=x-\sum_\rho\frac{x^\rho}{\rho}-\log2\pi-\tfrac12\log(1-x^{-2}),$$
a Fourier sum in `log x` whose frequencies are the imaginary parts `γ` of the `ζ`-zeros. **The
spectrum of the primes *is* the zeros.** But this is a duality between the two hard objects
(primes ⟷ zeros), not an elementary simplification: the only nontrivial collapse leads to the
(hard) zeros; elementary Ramanujan-sum reorganizations exist but cheapen nothing.

## 4. Where the *room* is — high bits vs low bits

The snap always needs **half-a-bin** precision. What differs across settings is *where in the
magnitude the bin-information sits*:

- **`FractionalPart[(n-1)!/n]`** needs `(n-1)! mod n` — the **lowest** bits of a huge number.
  Half-a-bin absolute precision = full relative precision = the exact integer. A floating
  factorial gives garbage (verified: snap fails at `i≳21` in double precision, where `(i-1)!`
  crosses ~62 bits). **No room** — unless you change representation and work `mod n` (the
  modular Wilson route, `⌈log₂ n⌉` bits, but exact integer arithmetic).
- **The zzz `--loop`** snaps a zero/prime estimate whose target integer sits at the **top** of
  the magnitude (the value `≈` its nearest integer). Half-a-bin is *moderate relative* precision
  → **there is room** (the SNR / reach story; gap-scale noise rounds away).

Same gate, opposite cost — because in the factorial the arithmetic lives in the *low* bits
(exact or nothing) and in the loop it lives in the *high* bits (cheap to reach).

## 5. "Floor with room" is the explicit formula, not an operator swap

Swapping `FractionalPart`→`Floor` mechanically is cosmetic: `Floor[(n-1)!/n]` returns the
quotient and discards the residue where primality lives. Room is not a property of the operator;
it requires the prime information in robustly-computable **high** bits — and the only known lift
there is the zeros. The smooth main term misses by far more than ½: `|π(x)−li(x)|` runs
`17, 38, 130, 339, 754` at `x=10^{4..8}` (verified) — `~√x/\log x`, the explicit-formula
fluctuation. Only adding the zeros pulls it below ½ → then a `Floor`/`round` snaps `π(x)`
exactly. Elementary high-bit "Floor formulas" (Mills-type constants) are cheats: no compression,
you need the constant to as many digits as the output.

## 6. The Eudoxus lens — room = bounded defect; primes are the unbounded case

The cleanest statement of "Floor with room" is the **Eudoxus reals** (S. Schanuel; R. D. Arthan,
*The Eudoxus Real Numbers*, arXiv:math/0405454; earlier, N. G. de Bruijn 1976):

> A real number is an **almost-homomorphism** `f:ℤ→ℤ` with `f(m+n)−f(m)−f(n)` **bounded**,
> modulo bounded functions. The canonical representative of `α` is the Beatty sequence
> `f(n)=⌊αn⌋` — pure `Floor`.

Here **the room *is* the bounded defect**: `⌊αn⌋` is robust because the defect stays `O(1)`. So
"is there a Floor primorial formula with room?" becomes: **is the primorial a bounded-defect
object?** Test it, no zeros invoked. The primorial's log is `θ(m)=Σ_{p≤m}\log p`, slope 1, and
$$\theta(m+n)-\theta(m)-\theta(n)=\big[\theta(x)-x\ \text{fluctuation}\big],\qquad
\theta(x)-x=\Omega_\pm\!\big(\sqrt x\,\log\log\log x\big)\ \text{(Littlewood)}.$$
The defect is **provably unbounded, of size `√x`.** Equivalently: the primes are not a Beatty
sequence (Beatty sequences have bounded gaps; primes do not). So the primorial has Eudoxus
defect `√x`, not `O(1)` — and `√x ≫ ½` kills any rounding room for the *exact* answer. The gap
from `√x` to `O(1)` is the zeros — but **the obstruction is visible inside the integers-only
world** as the unbounded defect; Littlewood's `Ω(√x)` is rigorous and elementary to state.

## 7. The zzz `--loop`: the same atom closes the strange loop

The loop (primes from zeros, no sieve) closes the *strange loop* zeros→ψ→primes→zero→… only
because the backward step is a **ℤ-quantizer** — snap-to-integers — injecting the discreteness
the continuous prime⟷zero duality can only approximate (forward null-space = backward
don't-care; *exactness lives in ℤ as an error-correcting code*; no `√T` precision wall, only an
SNR reach bound). Its wall is **feasibility** (`X=√(T/2π)`, the `√T` cost ≈ Riemann–Siegel) —
*not* a factorial. So fast-factorial (= factoring) is orthogonal to the loop: different
mountains. The loop has room precisely because it works in the high-bit (zero) domain.

## Synthesis

Across all five faces, the same atom does the same job:

| face | the atom | the room |
|---|---|---|
| closed-form detector | `FractionalPart` / snap-to-ℤ | none (low-bit; exact or nothing) |
| explicit formula | ζ-zeros as Fourier frequencies | the zeros *are* the high-bit lift |
| precision of `(n-1)!/n` | the snap on the residue | none unless modular |
| Eudoxus reals | Beatty `⌊αn⌋` | bounded defect (primes: `√x`, unbounded) |
| zzz `--loop` | the ℤ-quantizer | SNR / gap-scale (high-bit) |

- **Continuous machinery** — factorials, the reciprocal trick, Fourier sums, the zeros, the
  slope `θ` — carries *structure but no exactness*.
- **Snap-to-ℤ is the irreducible gate** where primality / exactness / discreteness is forced to
  live. It is both the floor of closed-form purity (can't be removed — primality isn't
  algebraic) and the mechanism that breaks the strange loop's circularity (adds genuine discrete
  information each turn).
- **Room ⟺ bounded Eudoxus defect ⟺ linear/Beatty.** Primes are the *non-linear*
  (unbounded-defect, `√x`) case; the gap from `√x` to `O(1)` is the zeros.
- The atom can be **relocated** (`FractionalPart ↔ Mod ↔ sin ↔ quantizer`) but never removed,
  and the operator is *not* the lever — *where the information sits* (low bits vs high bits) is.

---

### Claims used (all standard / verified this session)

- Primality not algebraic in `n` (elementary). `FractionalPart=Mod=Floor` (definitional).
- von Mangoldt Willans-style closed form — verified `n≤50`, 0 mismatches.
- Explicit formula `ψ(x)=x−Σ_ρ x^ρ/ρ−…` (von Mangoldt / Riemann).
- `n! mod n` fast ⟹ factoring (Strassen 1976).
- Float-factorial snap fails at `i≳21` (double) — verified.
- `|π(x)−li(x)|` = `17…754` for `x=10^{4..8}` — verified.
- Eudoxus reals: Schanuel / Arthan (arXiv:math/0405454) / de Bruijn (1976).
- `θ(x)−x = Ω_±(√x·logloglog x)` — Littlewood.
