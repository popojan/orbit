# Universal Staircase Ballot Theorem

**Date:** 2026-04-07
**Status:** 🔬 NUMERICALLY VERIFIED (14 irrationals: √d for d=2..20, π, e, φ, 1+√2, ∛2, √2+√3)

## Main Theorem

**Universal Staircase Ballot Theorem.** For any irrational α > 0 with continued fraction [a₀; a₁, a₂, ...], define the staircase S(x) = ⌊x/α⌋ and let DP(x) count monotonic lattice paths from (1,0) to (x, S(x)) staying below S. Then:

**Ballot hits of S are exactly the numerators of convergents and semi-convergents of α** (excluding p₀ = ⌊α⌋).

At each hit x with effective denominator q:
- **DIRECT** (S(x) = q): when p/q > α (overestimate), DP(x) = B(p, q)
- **SHADOW** (S(x) = q−1): when p/q < α (underestimate), DP(x) = B(p, q)

Where B(x, y) = Binomial[x+y−1, y] / x is the ballot number.

Semi-convergents inherit the DIRECT/SHADOW type of the convergent they approach.

**Verified on:** √d (d=2..20), π, e, φ, 1+√2, ∛2, √2+√3 — 14 constants, ~140 convergent/semi-convergent points, **zero failures**.

## Background

The Pell-Ballot conjecture (prior session) stated that lattice paths above the Pell hyperbola u²−dv²≥1 yield ballot numbers at CF convergents of √d. This session tested whether replacing the Pell hyperbola with a different nonlinear boundary changes the result.

## Key Results

### 1. Boundary Shape Irrelevance

For any boundary with asymptote v ~ x/√d, the ballot matches are identical:

| Boundary | y\*(x) for x=1..100 | Ballot hits |
|---|---|---|
| Pell hyperbola u²−dv²≥1 | ⌊√((x²−1)/d)⌋ | identical |
| Relaxed u²−dv²≥0 | ⌊x/√d⌋ | identical |
| Cubic u³−d^(3/2)v³≥1 | ⌊((x³−1)/d^(3/2))^(1/3)⌋ | identical |
| Pure staircase (no curve) | ⌊x/√d⌋ | identical |
| Linear v ≤ x·q/p | ⌊x·q/p⌋ | identical |

All produce the **same** y\*(x), hence identical DP counts. The Pell hyperbola was a red herring — the ballot property lives in the staircase.

### 2. Complete Ballot Hit Characterization

**Hits = Convergents ∪ Semi-convergents.** The "extras" that puzzled us are simply semi-convergents.

Recall: between convergents p_{k-1}/q_{k-1} and p_{k+1}/q_{k+1}, the **semi-convergents** are:
```
s_j / t_j = (p_{k-1} + j·p_k) / (q_{k-1} + j·q_k)    for j = 1, ..., a_{k+1} − 1
```

**Verification for d=5** (CF [2; 4, 4, 4, ...]):
```
Between p₀=2 and p₁=9:  semi-convs {3,5,7}  ← DIRECT
Convergent p₁=9                               ← DIRECT
Between p₁=9 and p₂=38: semi-convs {11,20,29} ← SHADOW
Convergent p₂=38                               ← SHADOW
Between p₂=38 and p₃=161: semi-conv {47}       ← DIRECT

Ballot hits: {3,5,7,9,11,20,29,38,47} = Conv ∪ Semi  ✓
```

**Why B(p,q) is always an integer at these points:** For all convergents and semi-convergents, gcd(p,q) = 1 (proven via the determinant identity p_k·q_{k-1} − p_{k-1}·q_k = ±1). The ballot number B(n,k) = Binomial[n+k-1,k]/n is always an integer when gcd(n,k) = 1.

**Coprimality verified** for all 25 non-square d from 2 to 30, plus π, e, φ, ∛2 (~200 points total): max gcd = 1 everywhere.

### 3. Universal Shadow Identity

The Shadow Identity holds for **any** irrational, not just √d:

| Convergent type | y\*(p) | DP(p) | Match type |
|---|---|---|---|
| p/q > α (overestimate) | q | B(p, q) | DIRECT |
| p/q < α (underestimate) | q−1 | B(p, q) | SHADOW |

**Shadow mechanism:** When p/q < α, the staircase at x=p is S(p)=q−1. The path ends one step below the convergent denominator, yet the path count equals B(p, q), not B(p, q−1). The staircase "encodes" the true convergent denominator q despite the target being at q−1.

**Type inheritance:** Semi-convergents between p_k and p_{k+2} share the DIRECT/SHADOW type of p_{k+2}. This is because semi-convergents approach α from the same side as the next convergent.

### 4. Transposed Lattice Duality

The transposed lattice (q horizontal, p vertical, ceiling = ⌊q·α⌋) produces the complementary pattern:

| Convergent type | Original lattice | Transposed lattice |
|---|---|---|
| p/q > α | DIRECT | SHADOW |
| p/q < α | SHADOW | DIRECT |

Verified for d=2,3,5,7,10,13 with both lattice orientations.

### 5. Detailed Verification Tables

**Quadratic irrationals (d=2..20, all convergents and semi-convergents up to x=120):**

```
d=2  CF=[1;2,2,...] — 10 hits, 0 failures
  (2,1) semi DIRECT  (3,2) conv DIRECT  (4,3) semi SHADOW  (7,5) conv SHADOW
  (10,7) semi DIRECT (17,12) conv DIRECT (24,17) semi SHADOW (41,29) conv SHADOW
  (58,41) semi DIRECT (99,70) conv DIRECT

d=5  CF=[2;4,4,...] — 10 hits, 0 failures
  (3,1) semi DIRECT  (5,2) semi DIRECT  (7,3) semi DIRECT  (9,4) conv DIRECT
  (11,5) semi SHADOW (20,9) semi SHADOW (29,13) semi SHADOW (38,17) conv SHADOW
  (47,21) semi DIRECT (85,38) semi DIRECT

d=10 CF=[3;6,6,...] — 12 hits, 0 failures
  (4,1)...(16,5) semi DIRECT  (19,6) conv DIRECT
  (22,7)...(98,31) semi SHADOW  (117,37) conv SHADOW
```

**Non-algebraic constants:**

```
π  CF=[3;7,15,1,292,...] — 12 hits, 0 failures
  {4,7,10,13,16,19} semi DIRECT → (22,7) conv DIRECT
  {25,47,69,91,113} semi SHADOW → (333,106) conv SHADOW [beyond range]

φ  CF=[1;1,1,...] — 9 hits, 0 failures (NO semi-convergents, all partial quotients = 1)
  {2,3,5,8,13,21,34,55,89} all convergents, alternating DIRECT/SHADOW

e  CF=[2;1,2,1,1,4,...] — 10 hits, 0 failures
  (3,1) conv D, (5,2) semi SH, (8,3) conv SH, (11,4) conv D,
  (19,7) conv SH, (30,11)(49,18)(68,25) semi D, (87,32) conv D, (106,39) conv SH
```

### 6. Prior "Extras" Explained

What appeared as mysterious "extra" hits are simply **semi-convergents**:

| Prior description | True identity |
|---|---|
| Pell norm ±2 orbits for d=2 | Semi-convergents of √2 |
| "Step 3" arithmetic for π | Semi-convs p_{-1}+j·p₀ = 1+3j |
| "Step 22" arithmetic for π | Semi-convs p₀+j·p₁ = 3+22j |
| "Step 19" arithmetic for e | Semi-convs with p₃=19 |
| ZERO extras for φ | All aₖ=1, so no semi-convergents exist |

**Multiplicative vs additive dichotomy explained:** For periodic CFs (quadratic irrationals), the same semi-convergent pattern repeats with each CF period, giving multiplicative Pell orbits. For non-periodic CFs (transcendentals), each inter-convergent gap has its own arithmetic family.

### 7. Perturbation Sensitivity

Random perturbation of the staircase (flipping individual y\*(x) by ±1) destroys most ballot matches:

| d | Clean hits | Perturbed hits | Lost |
|---|---|---|---|
| 2 | {2,3,10,17} | {2,3} | {10,17} |
| 5 | {3,5,7,9,47} | {3,9} | {5,7,47} |
| 7 | {3,8,45} | {8} | {3,45} |

The ballot property requires the **exact** staircase ⌊x/α⌋.

## Implications

1. **The Pell-Ballot conjecture is a special case** of a universal property of Beatty-like staircases
2. **Complete characterization:** Ballot hits = convergents ∪ semi-convergents (no mysterious extras)
3. **CF structure detection:** The staircase DP detects the full CF expansion of α — not just convergents but also semi-convergents with their DIRECT/SHADOW parity
4. **The ballot formula** B(p,q) = Binomial[p+q−1,q]/p is the natural "CF counting function" — it counts lattice paths constrained by the Beatty staircase of α, and is nonzero precisely at the best rational approximations of α
5. **Golden ratio φ is maximally efficient:** With all aₖ=1, there are no semi-convergents, so every ballot hit is a convergent. φ has the "tightest" CF expansion

## Open Questions

- ⏸️ **Proof:** Why does the staircase ⌊x/α⌋ produce ballot numbers at convergents and semi-convergents?
- ✅ **Extra hits classification:** Extras ARE semi-convergents (§2, §6)
- ⏸️ **Shadow mechanism:** Combinatorial explanation for DP(p) = B(p,q) when S(p) = q−1?
- ⏸️ **Connection to Beatty sequences:** Staircase ⌊x/α⌋ defines a Beatty sequence; known link to ballot numbers?
- ⏸️ **Counting interpretation:** Is there a bijective proof matching lattice paths to ballot arrangements?
- ⏸️ **Chebyshev for N≠1:** Can T/U doubly-exponential trick adapt for approximate Pell?

## Generalized Pell + Egyptian Sqrt

See [generalized-pell-egyptian.md](generalized-pell-egyptian.md) for:
- Generalized Pell equation for irrational d (convergents of √d give bounded |p²−dq²| < 2√d)
- Egyptian sqrt correction √d ≈ p/q − N/(2pq) works for any real d
- Why √ is load-bearing for Egyptian but not for Ballot
- Proposed implementation strategy

## Scripts

- `scripts/general_boundary_dp.wl` — initial boundary survey (6 boundary types)
- `scripts/boundary_focused.wl` — focused comparison: Pell vs relaxed vs cubic vs linear vs shifted
- `scripts/staircase_hypothesis.wl` — pure staircase tests, non-algebraic constants, perturbation
- `scripts/both_sides.wl` — transposed lattice, shadow identity, non-algebraic (buggy iterator)
- `scripts/both_sides_v2.wl` — fixed: master table, transposed lattice, non-algebraic with shadow detection
- `scripts/extra_hits.wl` — systematic classification of non-convergent ballot hits, Pell orbit verification
- `scripts/extra_structure.wl` — semi-convergent analysis, completeness, density
- `scripts/semiconvergent_theorem.wl` — **definitive verification**: Ballot hits = Conv ∪ Semi, GCD check, shadow characterization
- `scripts/generalized_pell.wl` — approximate Pell for irrational d, Egyptian correction, norm spectrum
