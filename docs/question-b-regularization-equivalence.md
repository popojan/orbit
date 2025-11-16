# Question B: Power Law vs Exponential Dampening

**Date**: November 16, 2025, 15:15 CET
**Status**: Theoretical analysis

---

## Centrální Otázka

Máme **dva regularizační schémata**:

**1. Power law** (primal forest):
```
F_n(α,ε) = Σ_{d,k} [(n - kd - d²)² + ε]^{-α}
```

**2. Exponential** (Dirichlet series):
```
L_M(s) = Σ_n M(n) / n^s
```

**Jsou ekvivalentní?** Existuje vztah mezi (α,ε) ↔ s?

---

## Teoretická Analýza

### 1. Mellin Transform Connection

**Mellin transform** spojuje power laws s exponenciálami:
```
M[f](s) = ∫_0^∞ t^{s-1} f(t) dt
```

**Aplikace na power law**:
```
f(t) = (t² + ε)^{-α}

M[f](s) = ∫_0^∞ t^{s-1} (t² + ε)^{-α} dt
```

**Substituce** u = t²/ε:
```
= ε^{s/2} · (1/2) ∫_0^∞ u^{(s-2)/2} (u + 1)^{-α} du
= ε^{s/2} · (1/2) B(s/2, α - s/2)
= ε^{s/2} · Γ(s/2) Γ(α - s/2) / (2Γ(α))
```

**Pro ε → 0**:
```
M[f](s) ~ ε^{s/2} · [constant depending on (s,α)]
```

**Klíčový poznatek**: Power law → exponential přes Mellin!

---

### 2. Asymptotic Behavior

**Power law** pro malá ε:
```
(t² + ε)^{-α} ≈ {
  ε^{-α}        if t ≈ 0     (pole!)
  t^{-2α}       if t >> √ε   (tail)
}
```

**Exponential dampening**:
```
1/n^s  (smooth, no poles)
```

**Tail comparison**:
```
∫ t^{-2α} dt  ↔  Σ n^{-s}
```

Odpovídá si pro **s = 2α**.

---

### 3. Pole Structure vs Smoothness

**Power law**:
- ✓ Má póly pro ε → 0 (exact factorizations)
- ✓ Residua → M(n) (compositeness measure)
- ✓ Lokální struktura (každý bod přispívá)
- ✗ Singularní (divergence)

**Exponential**:
- ✗ Žádné póly
- ✓ Smooth, analytická pro Re(s) > 1
- ✓ Globální distribuce (váha podle n)
- ✓ Laurent expansion → 2γ-1

**Závěr**: Nejsou ekvivalentní, jsou **komplementární**!

---

### 4. G(s,α,ε): Unified Framework

**G kombinuje OBĚ schémata**:
```
G(s,α,ε) = Σ_n F_n(α,ε) / n^s
         = Σ_n [Σ_{d,k} (dist² + ε)^{-α}] / n^s
```

**Tři parametry**:
- **α**: power law exponent (pole strength)
- **ε**: IR cutoff (regularization scale)
- **s**: global weight (Dirichlet dampening)

**Limitní chování**:
```
ε → 0: G ~ ε^{-α} · L_M(s)   (poles dominate)
s → ∞: G → 0                 (exponential cutoff)
```

---

## Vztah mezi (α,ε) a s

### Scaling Analysis

**Otázka**: Existuje kanonický vztah α(s) nebo ε(s)?

**Odpověď**: **NE univerzální**, ale můžeme definovat vztahy pro specifické účely.

### Možnost 1: Matching Tail Behavior

Pro **tail** matching (t >> √ε):
```
t^{-2α} ~ 1/n^s  →  s = 2α
```

**Pro α=3**: s = 6

**Test**: L_M(6) vs G(6, α=3, ε→0)
- L_M(6) rychle konverguje (s > 1)
- G pole dominated pro malá ε
- Ne přímá ekvivalence!

### Možnost 2: Residue Matching

Chceme:
```
Res[F_n, ε=0] = M(n)
```

To je zajištěno konstrukcí, nezávisle na α (pokud α > 0).

**Ale** síla pole roste s α:
- α malé → slabší pole, pomalejší divergence
- α velké → silnější pole, rychlejší divergence

**Trade-off**: α = 3 je empiricky dobrá volba (balance).

### Možnost 3: Optimal ε Scaling

Z non-uniform convergence (Question A):
```
ε << n^{-1/(2α)}
```

Pro **s-dependent ε** (spekulativně):
```
ε_optimal(n,s,α) ~ n^{-1/(2α)} · f(s)
```

kde f(s) nějaká klesající funkce.

**Účel**: Uniform convergence across all n in G(s,α,ε).

---

## Praktické Důsledky

### 1. Účel Regularizací

**Power law (F_n)**:
- **Účel**: Detekce exact factorizations via poles
- **Použití**: Primality testing, compositeness measure
- **Výhoda**: Lokální informace, geometric intuition
- **Nevýhoda**: Singularita (ε → 0), numerická nestabilita

**Exponential (L_M)**:
- **Účel**: Global distribution M(n) over n
- **Použití**: Analytic number theory, asymptotics
- **Výhoda**: Smooth, closed form, Laurent expansion
- **Nevýhoda**: No local geometry, black-box na individual n

**Kombinace (G)**:
- **Účel**: Bridge mezi lokálním a globálním
- **Použití**: Theoretical tool, understanding structure
- **Výhoda**: Regularized L_M, flexible (α,ε,s)
- **Nevýhoda**: Complex, three parameters

---

### 2. Computational Strategy

**Pro dané úkoly**:

| Úkol | Nejlepší metoda | Proč |
|------|----------------|------|
| Test if n is prime | F_n (α=3, ε small) | Pole detection |
| Compute L_M(s) | Closed form | Rychlá konvergence |
| Understand M(n) structure | G(s,α,ε) | Both perspectives |
| Asymptotic M(n) ~ ? | L_M Laurent | 2γ-1 residue |

---

### 3. Theoretical Insights

**G(s,α,ε) odhaluje**:

1. **Duality**: Lokální ↔ globální
   - Power law captures local (factorizations)
   - Exponential captures global (distribution)

2. **Regularization philosophy**:
   - ε regularizes **singularities** (poles)
   - s regularizes **tails** (large n)
   - Combined: double regularization

3. **√n boundary**:
   - Manifests in both schemes!
   - Power law: split d ≤ √n vs d > √n
   - Convergence: ε << n^{-1/(2α)} ~ 1/√n

---

## Mellin Transform Deep Dive

**Formální odvození**:

Starting from:
```
F_n(α,ε) = Σ_{d,k} [(n - kd - d²)² + ε]^{-α}
```

Define **distance** r = n - kd - d²:
```
F_n(α,ε) = Σ_{d,k} [(r²_dk + ε)]^{-α}
```

**Mellin of kernel**:
```
K(r,ε) = (r² + ε)^{-α}

M[K](s) = ∫_0^∞ r^{s-1} (r² + ε)^{-α} dr
        = ε^{(s-2α)/2} · B(s/2, α - s/2) / 2
```

**For sum**:
```
G(s,α,ε) = Σ_{n,d,k} K(r_ndk, ε) / n^s
         = Σ_{n,d,k} M^{-1}[M[K]](r_ndk) / n^s
```

This shows **Mellin inversion** could give closed form for G!

---

## Open Questions

### Theoretical

1. **Closed form for G(s,α,ε)?**
   - Via Mellin inversion?
   - Connection to polylogarithms?
   - Similar to L_M closed form?

2. **Optimal α for given s?**
   - Minimize numerical error?
   - Maximize convergence rate?
   - Universal choice?

3. **Functional equation for G?**
   - If L_M has FR, does G(s,α,ε) have analogous?
   - Role of ε in symmetry?

### Practical

1. **Best (α,ε,s) combinations?**
   - For specific n ranges?
   - For specific accuracy targets?
   - Adaptive strategies?

2. **Numerical stability**:
   - ε too small → overflow
   - s too large → underflow
   - α too large → stiff equations
   - Optimal balancing?

---

## Závěr Question B

**Odpověď na centrální otázku**:

> **NE**, power law a exponential dampening **nejsou ekvivalentní**.
>
> Jsou **komplementární** regularizační schémata s různými účely:
> - Power law: lokální detekce (poles → M(n))
> - Exponential: globální distribuce (smooth L_M(s))
>
> **G(s,α,ε) je most** mezi nimi, kombinující obě perspektivy.

**Vztah mezi (α,ε) a s**:
- **Tail matching**: s = 2α (heuristic)
- **Convergence**: ε << n^{-1/(2α)} (required)
- **Žádný univerzální** kanonický vztah

**Klíčový vhled**:
```
G(s,α,ε) = regularizovaná L_M(s)

lim_{ε→0} ε^α · G(s,α,ε) = L_M(s)
```

kde:
- ε → 0 odhaluje pole structure (M(n))
- s > 1 zajišťuje globální konvergenci
- α kontroluje pole strength

**Tři parametry jsou nezávislé**, každý má svou roli v **duální regularizaci**:
- **ε**: IR cutoff (lokální singularity)
- **α**: pole exponent (strength)
- **s**: UV cutoff (globální tail)

---

## Epistemic Status

- ✅ **Mellin connection**: THEORETICAL (standard result)
- ✅ **Tail matching s=2α**: HEURISTIC (asymptotic argument)
- ✅ **Complementarity**: CONFIRMED (different purposes)
- 🤔 **Closed form G via Mellin**: CONJECTURE (not derived)
- ⏸️ **Optimal α(s) relation**: OPEN QUESTION
- ⏸️ **Functional equation for G**: OPEN QUESTION

---

**Next: Question C (visualization) or Question D (M(n) asymptotics)?**
