# Publication Consolidation

**Date:** December 16, 2025

## Summary

External review of 7 papers. Cleanup and refinements based on feedback.

## Key Changes

- Deleted tautological modules (ChebyshevZeta, PrimeOrbits)
- Unified bibliography (`references.bib`)
- Reframed Egyptian fractions novelty (computational refinement, not new bijection)
- Added OEIS sequence references (A034386, A001175, A000045)
- Tightened Fibonacci Prop 4.1 (anti-symmetric polynomial class)

## Review Verdict

Top 3 ready for submission: Primorial, Chebyshev integral, Egyptian fractions.

See `docs/STATUS.md` for current paper status.

---

## Research Timeline (recalled Dec 16, 2025)

Original path to discoveries (pre-AI collaboration):

```
Lissajous visualization experiments
    ↓
"which crossing is closest to origin?" → idx[] function
    ↓
answer: k = x⁻¹ mod p (or p - x⁻¹)
    ↓
observation: approximation error is always ±1/(pk) — unit fraction!
    ↓
idea: custom Egyptian fractions algorithm
    ↓
problem: O(n) terms worst case
    ↓
observation: repeated steps return "same" results up to some point
    ↓
idea: execute all identical steps at once → range [i,j]
    ↓
telescoping format {u, v, i, j} → O(log n) tuples
```

Later (with AI collaboration):
```
what's original vs. rediscovered?
    ↓
connections to class numbers via sign function
    ↓
QR clustering, reflection duality L'/L*
```

Key insight: The unit fraction error property follows directly from xk ≡ ±1 (mod p).

---

## Sign-Cosine Paper: Deep Analysis

**Status:** Needs substantial rework. Original framing rejected by reviewer.

### Problem with Original Paper

The paper claims "geometric interpretation" of class numbers via Chebyshev lobes, but:
- W(p) = 4*S(1, p/4) - 2 reduces to classical quarter-interval sum
- "Chebyshev" framing is cosmetic — removing it doesn't change mathematics
- Reviewer: "notational reformulation, not mathematical novelty"

### New Discovery: QR Clustering

Adversarial analysis revealed a genuine geometric phenomenon:

**Observation:** For all p = 1 (mod 4), quadratic residues (QR) cluster at edges of {1,...,p-1}, while QNR cluster in the middle.

| p | avg|QR - p/2| | avg|QNR - p/2| | QR farther? |
|---|---------------|----------------|-------------|
| 5 | 1.5 | 0.5 | Yes |
| 13 | 3.8 | 2.2 | Yes |
| 17 | 4.8 | 3.2 | Yes |
| 29 | 8.1 | 5.9 | Yes |
| 37 | 10.4 | 7.6 | Yes |
| ... | ... | ... | Always Yes |

This is universal for p = 1 (mod 4).

### Why This Matters

1. **Sign function detects QR clustering:**
   - sign(cos((2k-1)pi/p)) = +1 at edges (k near 1 or p-1)
   - sign = -1 in middle (k near p/2)
   - QR preferentially fall where sign = +1

2. **Class number quantifies clustering:**
   - h(-p) = 2 * S(1, p/4) = 2 * (QR excess in first quarter)
   - Measures how unevenly QR distribute across number line

3. **Symmetry alignment is not trivial:**
   - Geometric symmetry (cos even around pi) aligns with
   - Arithmetic symmetry (chi(p-k) = chi(k) when -1 is QR)
   - Both conditions hold exactly when p = 1 (mod 4)

### Potential Paper Reframe

Instead of "Chebyshev lobes" (cosmetic), focus on:
- QR clustering as geometric phenomenon
- Sign function as clustering detector
- Class number as clustering measure
- Why geometric and arithmetic symmetries align

### Open Questions

1. Is QR clustering at edges a known result? (Need literature search)
2. Is there deeper reason why geometric (cos) and arithmetic (chi) symmetries coincide for p = 1 (mod 4)?
3. Can this perspective yield new bounds or algorithms?

### Literature Search Results

**Classical geometric interpretation of h(-p):**
- Lattices in complex plane with complex multiplication
- Ideal classes = homothety classes of lattices
- Connection to binary quadratic forms (Gauss)

**QR distribution — known results:**
- Quadratic excess E(p) = QR in (0,p/2) minus QR in (p/2,p) — Davenport 1930s
- For p ≡ 3 (mod 4): E(p) > 0 (QR cluster at beginning)
- For p ≡ 1 (mod 4): E(p) = 0 (symmetric)
- Quarter-interval sums S(1, p/4) = h(-p)/2 — Dirichlet, classical

**Our reformulation (potentially novel):**
- "QR are on average farther from center than QNR" for p ≡ 1 (mod 4)
- Equivalent to S(1, p/4) > 0 but different presentation
- Sign function as "edge detector" — not found in literature

**Conclusion:**
The underlying mathematics is classical (Dirichlet's quarter-interval formula).
The geometric presentation as "QR edge-clustering" may be novel framing.
Worth developing if it provides new intuition or pedagogical value.

### Sources

- [John D. Cook: Distribution of Quadratic Residues](https://www.johndcook.com/blog/2019/07/12/distribution-of-quadratic-residues/)
- [Keith Conrad: Quadratic Residue Patterns](https://kconrad.math.uconn.edu/blurbs/) (local: papers/QuadraticResiduePatterns.pdf)
- [Wikipedia: Class number problem](https://en.wikipedia.org/wiki/Class_number_problem)

---

## Implementation: SignCosineIdentities.wl

Added `Orbit/Kernel/SignCosineIdentities.wl` module with:

### Functions

- `SignCosineA[p]` — Unweighted sum: A(p) = Σ sign(cos((2k-1)π/p))
- `SignCosineW[p]` — Character-weighted sum: W(p) = Σ χ(k)·sign(cos((2k-1)π/p))
- `SignCosinePartition[p]` — Partition counts: QR+, QR-, NQR+, NQR-
- `SignCosineVerifyIdentities[p]` — Verify all identities
- `SignCosineTable[pmax]` — Generate table for primes up to pmax

### Key Identities (Verified)

1. **Closed forms:**
   - p ≡ 1 (mod 4): A(p) = -2, W(p) = 2h(-p) - 2
   - p ≡ 3 (mod 4): A(p) = 0, W(p) = 2

2. **Unified identity:** W(p) = 2 - A(p)·(h(-p) - 2)

3. **Partition identities:**
   - (A + W)/2 = QR+ - QR-
   - (A - W)/2 = NQR+ - NQR-

### Verification

All 14 primes from 3 to 47 pass identity verification.

---

## Lissajous Connection to Class Numbers

### Discovery

The sign-cosine identity connects to Lissajous curve geometry via modular inverses.

### Lissajous Curves

For frequency ratio ω = x/y (coprime), the parametric curve:
```
(Sin[π·(x/y)·t], Sin[π·t])
```
crosses the x-axis at integer t = 0, 1, ..., 2y. At crossing t = k, the x-coordinate is:
```
x_k = Sin[π·x·k/y]
```

### Key Observation

**The crossing closest to origin (but not at origin)** occurs at:
```
k = y - x⁻¹ mod y
```
where x⁻¹ is the modular inverse. This gives x·k ≡ -1 (mod y), so:
```
x_k = Sin[π(y-1)/y] = Sin[π - π/y] ≈ π/y  (small)
```

### Connection to Class Numbers

**Theorem:** For prime p,
```
Σ_{x=1}^{p-1} χ(x) · sign(cos((2k-1)π/p))  where k = p - x⁻¹
```
equals **χ(-1) · W(p)**.

**Proof:** The map x → k = p - x⁻¹ is a bijection on {1, ..., p-1}.
- From k = p - x⁻¹, we get x⁻¹ = p - k, so x = (p-k)⁻¹ ≡ (-k)⁻¹ (mod p)
- Therefore χ(x) = χ((-k)⁻¹) = χ(-k)⁻¹ = χ(-1)·χ(k)⁻¹ = χ(-1)·χ(k)
- Summing: Σ_x χ(x)·sign(k) = χ(-1) · Σ_k χ(k)·sign(k) = χ(-1)·W(p)

**Corollary:**
- p ≡ 1 (mod 4): Lissajous sum = W(p) = 2h(-p) - 2
- p ≡ 3 (mod 4): Lissajous sum = -W(p) = -2

### Unified Picture

Three domains connected by the modular inverse:

| Domain | Role of x⁻¹ mod y |
|--------|-------------------|
| **Lissajous geometry** | Determines crossing closest to origin |
| **Egyptian fractions** | Constructs telescoping tuples |
| **Class numbers** | Bijection preserving character sum structure |

The modular inverse / XGCD algorithm is the common computational thread.

---

## Lissajous Paper Development (Continued)

### Reflection Duality Discovery

Key insight: There are **two** crossings closest to the origin, forming a symmetric pair:

- **k' = x⁻¹ mod p** — the "left" crossing (equivalently: first crossing with x·k ≡ 1)
- **k* = p - x⁻¹ mod p** — the "right" crossing (equivalently: first crossing with x·k ≡ -1)

These satisfy the reflection relation: **k' + k* = p**

### Duality Formulas

Define weighted sums over all x ∈ {1, ..., p-1}:

```
L' = Σ χ(x) · sign(sin(πx·k'/p))   where k' = x⁻¹
L* = Σ χ(x) · sign(sin(πx·k*/p))   where k* = p - x⁻¹
```

**Results:**
- L' = W(p)
- L* = χ(-1) · W(p)
- L' + L* = (1 + χ(-1)) · W(p)
- L' - L* = (1 - χ(-1)) · W(p)
- **L' · L* = χ(-1) · W²** ← sign detects p mod 4!

### Case Analysis

| Condition | L' | L* | L' + L* | L' · L* |
|-----------|----|----|---------|---------|
| p ≡ 1 (mod 4) | W | W | 2W | +W² |
| p ≡ 3 (mod 4) | 2 | -2 | 0 | -4 |

### Symmetric Class Number Formula

For p ≡ 1 (mod 4):
```
h(-p) = 1 + (L' + L*)/4
```

This uses **both** closest crossings symmetrically.

### Paper Updates Made

1. **Added Reflection Duality section** (Theorem 6, Definition, Corollaries 7-8)
2. **Expanded Proposition 6** to include NQR identity: (A-W)/2 = NQR+ - NQR-
3. **Restructured introduction** — moved Chebyshev formula from intro to Section 3.2
4. **Fixed bibliography** — unified with references.bib, proper citation keys
5. **Removed Computational Verification section** (redundant if no proof gaps)
6. **Created Lissajous figure script** — scripts/lissajous-figure.wl

### Computational Complexity Analysis

**Question:** Do our identities speed up class number computation?

**Answer:** No algorithmic speedup.
- Computing L' or L* requires modular inverse for each x: O(p · log p) operations
- Direct computation of h(-p) via Dirichlet also O(p · log p)
- Jacobi symbol evaluation: O(log² p) bit operations per evaluation
- Modular inverse via XGCD: O(log p) divisions, O(log² p) bit operations

**Conclusion:** Same asymptotic complexity. Value is conceptual, not computational.

### Research Directions Identified

The "conceptual insight" from the Lissajous perspective enables:

1. **New questions:**
   - Other curves with frequency ratio x/p?
   - 3D Lissajous analogs with analogous arithmetic structure?
   - What happens for composite moduli?

2. **Cross-domain connections:**
   - Physics applications (harmonic oscillators)?
   - Signal processing (frequency analysis)?

3. **Generalizations:**
   - Higher-order characters beyond Legendre?
   - Non-prime moduli?

4. **Modular inverse meta-pattern:**
   - Same structure appears in Egyptian fractions, XGCD, and now Lissajous
   - Is there a unifying framework?

5. **Reflection duality analogs:**
   - Do similar dualities exist in other character sum contexts?
   - Connection to functional equations?

6. **QR clustering applications:**
   - Visual tools for number theory education?
   - New perspectives on classical problems?

### Files Created/Modified

- `docs/papers/lissajous-class-numbers.tex` — main paper, extensively updated
- `scripts/lissajous-figure.wl` — figure generation script
- `docs/learning/lissajous-history.md` — historical background
- `docs/papers/references.bib` — added Popelka2025sign, Popelka2025egypt entries

### Literature Check

Confirmed: The Lissajous → class numbers perspective appears novel. The underlying mathematics (Dirichlet quarter-sum) is classical, but the geometric framing via Lissajous curves and the reflection duality formulation are new.

Recommended venues from external review:
- American Mathematical Monthly (appreciates "new perspectives on classics")
- Journal of Number Theory

### Future Directions Added to Paper

Three concrete open questions formulated:

1. **Geometric interpretation for composite discriminants:** ⚠️ REFRAMED after literature check.
   - The algebraic formula h(d) ~ √|d| · L(1, χ_d) / π with Kronecker symbol is CLASSICAL
   - What's OPEN: Does our *geometric* interpretation (Lissajous crossings) extend?
   - Complications: modular inverses only exist when gcd(x,n)=1; bijection structure changes
   - New framing: "Does 'closest crossing' perspective yield insight for discriminants beyond -p?"

2. **Higher-order characters:** ✅ Confirmed open after literature check.
   - Cubic reciprocity, Gauss sums for higher characters are known
   - BUT: Our specific identity χ(x) = χ(k*(x)) for higher characters is NOT in literature
   - Requires χ(-1) = 1 in character group — severely constrains which work

3. **Modular inverse as unifying structure:** ✅ Confirmed open after literature check.
   - No categorical framework found linking the three contexts
   - x⁻¹ mod n appears in: Lissajous crossings, Egyptian fractions, XGCD
   - Genuinely unexplored meta-question

---

## Partial Unification: p ≡ 1 vs p ≡ 3 (mod 4)

**Date:** December 17, 2025 (morning session)

### Discovery

The Lissajous k* map works for **both** congruence classes, but with different weight functions:

| p mod 4 | Formula | Weight | Status |
|---------|---------|--------|--------|
| **1** | h(-p) = (1/2) Σ χ(x)·σ(k*(x)) | sign (binary ±1) | ✅ in paper |
| **3** | h(-p) = (1/p) Σ χ(x)·k*(x) | position (linear) | 🆕 NEW |

where k*(x) = p − x⁻¹ mod p is the Lissajous closest-crossing map.

### Verification

```
p ≡ 3 (mod 4):
p=7:  Σχ(x)k*(x) = 7  = 7·1  = p·h(-p) ✓
p=23: Σχ(x)k*(x) = 69 = 23·3 = p·h(-p) ✓
p=47: Σχ(x)k*(x) = 235 = 47·5 = p·h(-p) ✓
p=71: Σχ(x)k*(x) = 497 = 71·7 = p·h(-p) ✓
```

For p ≡ 1 (mod 4): Σχ(x)k*(x) = 0 always (position contributions cancel).

### Interpretation

- **k* map** (Lissajous geometry) is **universal** — same for both classes
- **Weight function** differs:
  - p ≡ 1: σ(k) = sign of lobe (which half of period)
  - p ≡ 3: k itself = position along curve

This reflects the fundamental even/odd character dichotomy:
- χ(-1) = +1 (even): sign information suffices
- χ(-1) = −1 (odd): need full positional information

### Open Question

Is there a **fully unified** formula with a single natural weight function that works for both cases? Attempts so far:
- Combined weight k·σ: doesn't give h(-p)
- Signed position (k − p/2): reduces to existing formulas
- Complex exponential (Gauss sum): |G| = √p always, no h(-p) info

The dichotomy appears fundamental, not an artifact of our approach.

### Geometric Intuition

For p ≡ 3 (mod 4), the sign contributions cancel:
- χ(k*(x)) = −χ(x), so pairs contribute χ(x)·(σ(x) − σ(k*)) = 0 when aligned

But position-weighted sum doesn't cancel:
- Σ χ(x)·k*(x) accumulates because k* values don't have symmetric cancellation

The **position** encodes information that **sign** loses for odd characters.

### Update: Unified Formula Found

**Discovery:** Součet obou členů dává jednotný vzorec pro všechna p ≥ 5:

$$h(-p) = 1 + \frac{1}{2}\sum_{x=1}^{p-1} \chi(x)\cdot\sigma(k^*(x)) + \frac{1}{p}\sum_{x=1}^{p-1} \chi(x)\cdot k^*(x)$$

**Ověření:**
- Pro p ≡ 1 (mod 4): k-sum = 0, σ-sum = 2h−2 → h = 1 + (h−1) + 0 = h ✓
- Pro p ≡ 3 (mod 4): σ-sum = −2, k-sum = p·h → h = 1 + (−1) + h = h ✓

**Ale:** Toto NENÍ čistě korelační vzorec. Ověřeno:
```
Σχσ = Pearson(χ,σ) · std(χ) · std(σ) · (p-2)
```
Takže unified formula kombinuje dva různě scalované členy, ne dvě korelace.

**Stav:** Algebraická unifikace existuje, ale geometrická interpretace zůstává otevřená.

### Open: Hledání geometričtější formulace

Zkoušené přístupy (neúspěšné):
- x-souřadnice sin(πxk*/p): vždy ±sin(π/p), žádná informace
- Signed distance σ·|k−p/2|: nedává h
- Kombinace k'·k*, |k'−k*|, min(k',k*): pro p ≡ 3 dává 0
- Fourierova váha cos(2πk/p): pro p ≡ 3 dává 0

**Problém:** Pro p ≡ 3 (mod 4) se všechny "symetrické" funkce k* vynulují kvůli χ(k*) = −χ(x).

**Otevřená otázka:** Existuje jediná geometrická veličina (ne součet dvou členů), která dává h(-p) pro obě třídy?

### Deeper Insight: k* jako reflexe ∘ inverze

**Rozklad mapy k*:**

$$k^*(x) = p - x^{-1} = (\text{reflexe}) \circ (\text{inverze})$$

| Operace | Definice | Efekt na Σχ·(pozice) |
|---------|----------|---------------------|
| Inverze | x → x⁻¹ mod p | **zachovává** (Σχ·x⁻¹ = Σχ·x) |
| Reflexe | x → p−x | **neguje** pro p ≡ 3 (mod 4) |

**Klíčové vztahy pro p ≡ 3 (mod 4):**

```
Σχ(x)·x     = −p·h   (klasický Dirichlet)
Σχ(x)·x⁻¹  = −p·h   (inverze zachovává)
Σχ(x)·(p−x) = +p·h   (reflexe neguje)
Σχ(x)·k*(x) = +p·h   (k* = reflexe ∘ inverze)
```

**Proč reflexe neguje (pro p ≡ 3 mod 4):**

χ(p−x) = χ(−x) = χ(−1)·χ(x) = −χ(x)

Substituce y = p−x:
```
Σ χ(x)·(p−x) = Σ χ(p−y)·y = Σ [−χ(y)]·y = −Σ χ(y)·y
```

**Pro p ≡ 1 (mod 4):**
- χ(−1) = +1, takže reflexe NEZACHOVÁVÁ znaménko χ ve stejném smyslu
- Ale oba součty Σχ·x = Σχ·k* = 0 (symetrie)
- Proto potřebujeme σ-váhu místo poziční váhy

**Geometrická interpretace:**

Mapa k* kombinuje:
1. **Inverzi** — multiplikativní operace v (Z/pZ)*, zachovává strukturu
2. **Reflexi** — geometrické zrcadlení kolem p/2

Pro liché charaktery (p ≡ 3 mod 4) reflexe "obrací" aritmetický součet.
Pro sudé charaktery (p ≡ 1 mod 4) reflexe nemá tento efekt (součty jsou 0).

**POZNÁMKA:** Toto NENÍ o "směru parametrizace" Lissajous křivky. Negace pochází z algebraické vlastnosti reflexe v kombinaci s paritou charakteru.

### Unified Formula (Final Form)

Pro všechna prvočísla p ≥ 5:

$$h(-p) = 1 + \frac{1}{2}\sum_{x=1}^{p-1} \chi(x)\cdot\sigma(k^*(x)) + \frac{1}{p}\sum_{x=1}^{p-1} \chi(x)\cdot k^*(x)$$

Ekvivalentní formulace:

$$h(-p) = \frac{\sum\chi\sigma + 2}{2} + \frac{\sum\chi(k^* - x)}{2p}$$

kde Σχ(k* − x) = 2·Σχk* pro p ≡ 3 (mod 4) a = 0 pro p ≡ 1 (mod 4).

**Shrnutí:**
- Algebraická unifikace: ANO (jeden vzorec pro obě třídy)
- Geometrická unifikace: ČÁSTEČNÁ (k* je geometrická, ale váhy σ vs k jsou diktovány paritou charakteru)
- Hlubší insight: k* = reflexe ∘ inverze, a reflexe neguje pro liché charaktery

### Symmetric Formulas (All Four Sums)

**Motivation:** The unified formula uses k* only. For greater symmetry, we explored formulas using both k' = x⁻¹ and k* = p − x⁻¹ (the two closest crossings).

**Four fundamental sums:**

| Sum | Definition | Meaning |
|-----|------------|---------|
| **sp** | Σ χ(x)·σ(k'(x)) | sign-weighted sum for k' |
| **ss** | Σ χ(x)·σ(k*(x)) | sign-weighted sum for k* |
| **kp** | Σ χ(x)·k'(x) | position-weighted sum for k' |
| **ks** | Σ χ(x)·k*(x) | position-weighted sum for k* |

where σ(k) = sign(cos((2k−1)π/p)) is the lobe sign function.

**Key relationships:**

| Congruence | sp vs ss | kp vs ks |
|------------|----------|----------|
| p ≡ 1 (mod 4) | sp = ss = 2h−2 | kp = ks = 0 |
| p ≡ 3 (mod 4) | sp = −ss = 2 | kp = −ks, \|kp\| = \|ks\| = ph |

**Symmetric Formula 1:** (simpler)

$$h(-p) = 1 + \frac{ss}{2} + \frac{ks - kp}{2p}$$

Uses (k* − k') symmetrically in position term.

**Symmetric Formula 2:** (fully symmetric with absolute values)

$$h(-p) = 1 + \frac{sp + ss}{4} + \frac{|ks - kp|}{2p} - \frac{|sp - ss|}{4}$$

**Verification:**

Both formulas verified for all primes p ∈ {5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47}:

For **Formula 1** (h = 1 + ss/2 + (ks−kp)/(2p)):
- p ≡ 1 (mod 4): ss = 2h−2, ks−kp = 0 → h = 1 + (h−1) + 0 = h ✓
- p ≡ 3 (mod 4): ss = −2, ks−kp = 2ph → h = 1 + (−1) + h = h ✓

For **Formula 2** (h = 1 + (sp+ss)/4 + |ks−kp|/(2p) − |sp−ss|/4):
- p ≡ 1 (mod 4): sp+ss = 4h−4, |sp−ss| = 0 → h = 1 + (h−1) + 0 − 0 = h ✓
- p ≡ 3 (mod 4): sp+ss = 0, |sp−ss| = 4, |ks−kp| = 2ph → h = 1 + 0 + h − 1 = h ✓

**Insight:**

The term (ks − kp)/(2p) captures the "positional difference" between the two closest crossings:
- For p ≡ 1 (mod 4): ks = kp = 0, so contribution is 0
- For p ≡ 3 (mod 4): ks − kp = 2·ks = 2ph, giving contribution h

The symmetry reflects the geometric duality of k' and k* as paired closest crossings on opposite sides of the origin.

---

## Smooth Loop Unification (Dec 17, 2025)

### Key Discovery: Cusp vs Smooth Loop Dichotomy

Lissajous curves with frequency ratio x/p have two types of motion:

| x parity | Curve type | Motion |
|----------|------------|--------|
| **x odd** | Cusp | Stops and reverses direction |
| **x even** | Smooth loop | Continuous circulation |

**Why?** Cusps occur when dx/dt = dy/dt = 0 simultaneously. This requires x and p to have the same parity. Since p is always odd (prime > 2), cusps occur iff x is odd.

### Main Result: Smooth Loops Encode Class Number

**Theorem:** The class number h(-p) can be computed using ONLY smooth loop Lissajous curves (even x):

$$h(-p) = \frac{(1+\chi_{-1}) \cdot S_\sigma + (1-\chi_{-1}) \cdot \chi_2 \cdot S_k / p}{2}$$

where:
- $S_\sigma = \sum_{\text{x even}} \chi(x) \cdot \sigma(k^*(x))$ — sign-weighted sum
- $S_k = \sum_{\text{x even}} \chi(x) \cdot k^*(x)$ — position-weighted sum
- $\chi_{-1} = \chi(-1) = $ Legendre symbol of -1
- $\chi_2 = \chi(2) = $ Legendre symbol of 2
- $\sigma(k) = \text{sign}(\cos((2k-1)\pi/p))$ — lobe sign function

### Explicit Formulas by Congruence Class

| p mod 8 | χ(-1) | χ(2) | Formula for h |
|---------|-------|------|---------------|
| **1** | +1 | +1 | $h = S_\sigma$ |
| **5** | +1 | −1 | $h = S_\sigma$ |
| **3** | −1 | −1 | $h = -S_k/p$ |
| **7** | −1 | +1 | $h = +S_k/p$ |

Equivalently:
- **p ≡ 1 (mod 4):** $h = \sum_{\text{x even}} \chi(x) \cdot \sigma(k^*)$
- **p ≡ 3 (mod 4):** $h = \frac{\chi(2)}{p} \sum_{\text{x even}} \chi(x) \cdot k^*$

### Verification

Verified for all primes p ∈ {5, 7, 11, 13, ..., 97}:

```
p=5  (mod8=5): h=2, S_σ=2 ✓
p=7  (mod8=7): h=1, χ(2)·S_k/p = 1·7/7 = 1 ✓
p=11 (mod8=3): h=1, χ(2)·S_k/p = (-1)·(-11)/11 = 1 ✓
p=17 (mod8=1): h=4, S_σ=4 ✓
p=23 (mod8=7): h=3, χ(2)·S_k/p = 1·69/23 = 3 ✓
...
```

### Geometric Interpretation

1. **Smooth loop curves** (even x) carry ALL information about class number
2. **Cusp curves** (odd x) contribute "correction terms" but are not needed independently
3. The **type of weighting** (sign σ vs position k) is determined by:
   - χ(-1): whether -1 is a quadratic residue (p mod 4)
   - χ(2): sign correction when using position weighting (p mod 8)

### Why This Matters

Previous unified formula required BOTH σ and k terms with one "turning off":
$$h = 1 + \frac{\sum\chi\sigma(k^*)}{2} + \frac{\sum\chi \cdot k^*}{p}$$

New formula uses ONLY smooth loops, with arithmetic (χ(-1), χ(2)) selecting the interpretation:
$$h = \frac{(1+\chi_{-1}) \cdot S_\sigma + (1-\chi_{-1}) \cdot \chi_2 \cdot S_k / p}{2}$$

**Key insight:** The geometric distinction (cusp vs smooth) aligns with arithmetic needs:
- Smooth loops have even x, so x = 2m for some m
- The factor χ(2) appears naturally in the formula
- This connects curve dynamics to quadratic reciprocity

---

## Trig-Free Symmetric Formula (Dec 17, 2025)

### Eliminating Trigonometric Functions

The lobe sign function σ(k) = sign(cos((2k-1)π/p)) can be expressed **purely arithmetically**:

$$\sigma(k, p) = \text{sign}\left(|2k - (p+1)| - \frac{p}{2}\right)$$

**Verification:** This formula matches the trig definition for all primes p ∈ [3, 101].

**Geometric meaning:** σ = +1 when k is in the "outer quarters" (k < (p+2)/4 or k > (3p+2)/4),
σ = -1 when k is in the "middle half" ((p+2)/4 < k < (3p+2)/4).

### Fully Symmetric Unified Formula

Using the arithmetic σ, we obtain a formula where **p appears in both terms**:

$$h(-p) = \sum_{\text{x even}} \chi(x) \cdot \omega(k^*, p)$$

where the unified weight function is:

$$\omega(k, p) = \alpha \cdot \text{sign}\left(|2k - (p+1)| - \frac{p}{2}\right) + \beta \cdot \frac{k}{p}$$

with switches:
- $\alpha = \frac{1 + \chi(-1)}{2}$ — equals 1 if p ≡ 1 (mod 4), 0 otherwise
- $\beta = \chi(2) \cdot \frac{1 - \chi(-1)}{2}$ — equals χ(2) if p ≡ 3 (mod 4), 0 otherwise

### Symmetry Properties

| Property | First term (σ-like) | Second term (position) |
|----------|--------------------|-----------------------|
| **p in numerator** | |2k - (p+1)| | — |
| **p in denominator** | p/2 | k/p |
| **Coefficient** | α = (1+χ(-1))/2 | β = χ(2)·(1-χ(-1))/2 |

Both terms:
1. Use the same input k* = p - x⁻¹ mod p
2. Involve p explicitly (no hidden trig)
3. Have symmetric "switch" coefficients (α and 1-α base)

### Verification

Formula verified for all primes p ∈ {5, 7, 11, 13, ..., 97}.

### What We Achieved

| Old formula | New formula |
|-------------|-------------|
| Uses sign(cos(...)) | Uses sign(\|...\|) only |
| σ and k/p seem unrelated | Both expressed via k and p |
| p only in position term | p in BOTH terms |
| Trig required | Pure arithmetic |
