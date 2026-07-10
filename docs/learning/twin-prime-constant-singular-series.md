# The Twin Prime Constant and the Hardy–Littlewood Singular Series

**Result:** the density correction for a prime pair `(p, p+h)` relative to the "independent coin flips" baseline is one residue-counting argument per small prime, and it evaluates in closed form:

$$\mathfrak{S}(h) \;=\; 2\,C_2 \prod_{r \mid h,\ r>2} \frac{r-1}{r-2}\ \ (h \text{ even}), \qquad \mathfrak{S}(h)=0\ (h \text{ odd}),$$

where `C₂` is the **twin prime constant** — the product running over **primes** `r` only:

$$C_2 \;=\; \prod_{\substack{r \text{ prime} \\ r > 2}}\Big(1 - \frac{1}{(r-1)^2}\Big) \;=\; 0.66016\,18158\,46869\,5739\ldots$$

In Wolfram Language, the whole singular series is a one-liner:

```mathematica
c2 = 0.6601618158468695739;
sHL[h_] := 2 c2 Times @@ (((# - 1)/(# - 2)) & /@
     Select[FactorInteger[h][[All, 1]], # > 2 &]);
```

(`FactorInteger[h][[All,1]]` = distinct prime factors; `Select[..., #>2&]` keeps the odd ones; each
contributes `(r−1)/(r−2)`; `Times @@ {} = 1` correctly handles `h` a power of two.)

## The derivation: one prime at a time

Model primality as "avoiding the class `0 mod r` for every small prime `r`". A single integer near `x`
survives prime `r` with probability `1 − 1/r`. For the *pair* `(p, p+h)` the constraint is: `p` must
avoid **both** `0 mod r` and `−h mod r`. Naive independence would predict survival `(1−1/r)²`. The truth
splits by whether `r` divides `h`:

| case | forbidden classes for `p` | survival | correction vs. independence |
|---|---|---|---|
| `r ∤ h` | two **distinct** classes | `1 − 2/r` | `\dfrac{1-2/r}{(1-1/r)^2} = 1 - \dfrac{1}{(r-1)^2}` |
| `r \mid h` | the two classes **coincide** | `1 − 1/r` | `\dfrac{1-1/r}{(1-1/r)^2} = \dfrac{r}{r-1}` |

Multiply the generic (`r ∤ h`) corrections over all odd primes: that infinite product **is** `C₂` — and
it converges because the terms are `1 − 1/(r−1)²` (compare: the coprimality constant `6/π²` from
`∏(1−1/r²)` — same mechanism, shifted by one).

For each odd `r` that *does* divide `h`, swap its generic factor for the coincident one; the swap ratio is

$$\frac{r/(r-1)}{1 - 1/(r-1)^2} \;=\; \frac{r-1}{r-2},$$

which is exactly the per-factor boost in the code. The leading `2` is the `r = 2` term: `h` even makes
the two forbidden classes coincide mod 2, contributing `(1−1/2)/(1−1/2)² = 2`; `h` odd leaves two
distinct classes mod 2, `(1 − 2/2) = 0` — the pair is impossible (beyond `(2,3)`), hence `𝔖(odd) = 0`
and the theorem "prime gaps are even" is just the `r = 2` row.

Two intuitions worth keeping:

- `C₂ < 1`: a *generic* pair is slightly **rarer** than independence suggests, because two forbidden
  classes are harder to dodge than one class twice.
- every shared factor between `h` and the small primes **merges** two constraints into one and claws
  probability back — divisible gaps are favored.

## Values, and what they explain

| `h` | odd prime factors | `𝔖(h)` | reading |
|---|---|---|---|
| 2, 4, 8, 16… | — | `2C₂ ≈ 1.3203` | twin primes: `π₂(x) ~ 2C₂·x/\log^2 x` (Hardy–Littlewood 1923) |
| 6, 12, 24… | 3 | `≈ 2.6406` | gaps divisible by 3 are **twice** as common — the doubled teeth in any gap histogram |
| 30, 60… | 3, 5 | `≈ 3.5208` | the extra mod-30 boost |
| 210… | 3, 5, 7 | `≈ 4.2250` | why primorials 6 → 30 → 210 become **jumping champions** as height grows |

The mean of `𝔖(h)` over even `h` is 2 (over all `h`, 1): the comb redistributes probability among the
teeth without changing the total prime density `1/\log x` — the corrections are *shape*, not *rate*.

## Using it: the next-gap hazard model

Conditioned on `p` prime, the candidate `p+h` is prime with "probability" `𝔖(h)/\log p`, giving the
discrete next-gap distribution as a hazard chain:

$$P(g = h) \;=\; \frac{\mathfrak{S}(h)}{\log p} \prod_{\substack{h' < h \\ h' \text{ even}}} \Big(1 - \frac{\mathfrak{S}(h')}{\log p}\Big).$$

Empirically (height `10⁹`, n = 6000, sampled via `NextPrime`) this matches gap frequencies
tooth-by-tooth where the parity-only geometric model misses by up to ×2, and a randomized probability
integral transform through its CDF flattens the gap histogram to `χ²/dof ≈ 2.8` (vs 98.6 for the
continuous exponential, 18.2 for parity-only). Two refinements close the story:

- **Conditioning on the known `p` makes teeth deterministic**: e.g. `p ≡ 1 (mod 3)` forbids gaps
  `≡ 2 (mod 6)` outright (exact zeros in thousands of samples) — the aggregate ×2 boost at `6|h` is the
  average over the residue classes of `p`. The `𝔖`-comb is what remains of sieving *after* forgetting
  `p`'s residues.
- The continuous exponential envelope (Cramér/Gallagher) stays correct **from the median up**; the comb
  dominates the lower quantiles (the α = 0.25 quantile of gaps at height `10⁹` falls below the third
  tooth, and the first two teeth are the *underweighted* ones, `𝔖 = 2C₂ < 2`).

Worked session with scripts and measurements:
[2026-07-10 riseX / local calibration, §16](../sessions/2026-07-10-risex-local-calibration-primes/README.md).

## Computing `C₂` — and a trap

⚠️ **The product must run over primes.** Written over all integers it looks almost identical and
Mathematica happily evaluates it *exactly* — to the wrong constant:

```mathematica
Product[1 - 1/(r - 1)^2, {r, 3, Infinity}]   (* == 1/2  exactly! *)
```

because with `k = r−1` the terms `(1−1/k²) = (k−1)(k+1)/k²` **telescope**: every numerator cancels
against neighboring denominators, leaving `1/2`. (Same telescoping that gives `∏_{k≥2}(1−1/k²) = 1/2`
in the Basel-problem warm-up.) The prime-restricted product does not telescope — primes have no
neighbors — and lands at `0.6601…`.

The truncated prime product converges slowly (error `~ 1/(p_n \log p_n)`; 🔬 a million odd primes give
only 9 correct digits: `0.660161818…`). The standard fast route expands the logarithm into prime zeta
values (`P(k) = Σ_p p^{-k}`, built into WL as `PrimeZetaP`): from
`1 − 1/(r−1)² = (1−2/r)/(1−1/r)²`,

$$\ln C_2 \;=\; \sum_{r>2} \big[\ln(1-\tfrac2r) - 2\ln(1-\tfrac1r)\big]
\;=\; -\sum_{k\ge2} \frac{2^k-2}{k}\,\big(P(k) - 2^{-k}\big),$$

(the `k=1` term vanishes — that cancellation is *why* the constant is finite), geometrically convergent
(`~(2/3)^k`):

```mathematica
c2 = Exp[-Sum[(2^k - 2)/k (PrimeZetaP[k] - 2^-k), {k, 2, 220}]];
N[c2, 40]  (* 0.6601618158468695739278121100145557784326... *)
```

🔬 verified against the truncated prime product and the 19-digit value hardcoded in `sHL`.

## References

- Hardy & Littlewood, *Some problems of 'Partitio Numerorum' III*, Acta Math. 44 (1923) — conjecture B
  (prime pairs) and the singular series.
- Odlyzko, Rubinstein & Wolf, *Jumping champions*, Exp. Math. 8 (1999) — the `𝔖(h)·e^{-h/\log p}`
  trade-off and the primorial ladder.
- Gallagher, *On the distribution of primes in short intervals*, Mathematika 23 (1976) — uniform
  Hardy–Littlewood ⇒ Poisson spacings (the continuous envelope).
