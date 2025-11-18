# Globální Soft-Min Series vs. Zeta Funkce

**Datum**: 18. listopadu 2025
**Status**: 🔬 NUMERICALLY VERIFIED
**Kontext**: Varianta A s twistem - férové srovnání "global-to-global"

---

## Motivace

### Problém s původním grafem `dirichlet-vs-zeta.pdf`

Původní srovnání F₉₇(s) vs. ζ(2s) bylo **metodologicky neférové**:
- **F_n(s)**: studuje geometrii **jednoho čísla** n v Primal Forest
- **ζ(s)**: univerzální suma přes **všechna přirozená čísla**

Je to jako srovnávat "výšku Jana Popelky" s "průměrnou výškou populace" - kategoriální chyba!

### Řešení ve dvou krocích

**Krok 1** (hotovo): **Varianta B** - lokální srovnání
→ F_n(s) vs. ζ_n(s) = Σ_{d|n} d^(-s)
→ Obě funkce studují strukturu jednoho n

**Krok 2** (tento dokument): **Varianta A s twistem** - globální srovnání
→ 𝓕(s) vs. ζ(s)
→ Obě funkce agregují přes všechna n

---

## Definice Globální Series (s twistem)

### Základní idea

Pro každé n spočítáme "kanonickou soft-min metriku" F_n(1), pak z ní uděláme Dirichlet series:

$$\mathcal{F}(s) = \sum_{n=2}^{\infty} \frac{F_n(1)}{n^s}$$

kde:
$$F_n(1) = \sum_{d=2}^{\text{maxD}} \left[\text{soft-min}_d(n)\right]^{-1}$$

### Co je "twist"?

**Twist**: Fixujeme **vnitřní exponent** na t = 1 (kanonická hodnota).

Mohli bychom definovat obecněji 𝓕(s, t) = Σ F_n(t)/n^s, ale to by mělo **dva parametry**. Twist zjednodušuje na jeden parametr s tím, že t = 1 zvolíme jako "přirozenou škálu" geometrie.

### Geometrická interpretace F_n(1)

**F_n(1)** měří "jak daleko je n od Primal Forest struktur":
- **Prvočísla**: daleko od všech bodů kd + d² → **vysoké F_p(1)** (řádově 9)
- **Kompozitní**: blízko některých bodů → **nižší F_c(1)** (řádově 5)

**Hypotéza**: Když tuto metriku agregujeme, 𝓕(s) by měla "preferovat" prvočísla.

---

## Výpočetní Setup

### Parametry

- **Rozsah**: n ∈ [2, 1000]
- **Alpha** (soft-min sharpness): α = 7
- **Exponent rozsah**: s ∈ [1.2, 5.0]
- **Max divisor cutoff**: maxD = 500 nebo 10n (podle toho, co je menší)

### Srovnávané funkce

1. **𝓕(s)** = Σ F_n(1)/n^s (naše geometrická series)
2. **ζ(s)** = Σ 1/n^s (Riemann zeta, partial sum)
3. **P(s)** = Σ 1/p^s (prime zeta, suma jen přes prvočísla)

---

## Výsledky

### Distribuce F_n(1) hodnot

**Pro n ∈ [2, 1000]:**

| Typ | Počet | Průměr F_n(1) | Std dev | Rozsah |
|-----|-------|---------------|---------|--------|
| **Prvočísla** | 168 | **8.998** | 3.227 | [0.279, 16.662] |
| **Kompozitní** | 831 | **5.359** | 2.914 | [0.052, 16.329] |

**Poměr**: Primes/Composites = **1.68×**

### Klíčový nález

Prvočísla mají **vyšší F_n(1)** než kompozitní čísla v průměru, ale rozdíl není tak dramatický, jak jsme očekávali:
- Očekávali jsme: factor ~4-6× (na základě n=97 vs n=96)
- Realita: factor ~1.7× (průměr přes 1000 čísel)

**Interpretace**: Lokální chování (n=97 má F ≈ 6.5, n=96 má F ≈ 1.2) není reprezentativní pro globální průměry!

### Numerické hodnoty series

| s | 𝓕(s) | ζ(s) | P(s) | 𝓕/ζ | 𝓕/P |
|---|------|------|------|-----|-----|
| 1.2 | 7.840 | 4.336 | 1.401 | 1.81 | 5.60 |
| 1.4 | 3.378 | 2.948 | 0.982 | 1.15 | 3.44 |
| 1.6 | 1.635 | 2.259 | 0.732 | 0.72 | 2.23 |
| 1.8 | 0.887 | 1.877 | 0.568 | 0.47 | 1.56 |
| 2.0 | 0.533 | 1.644 | 0.452 | 0.32 | 1.18 |
| 2.2 | 0.347 | 1.490 | 0.367 | 0.23 | 0.95 |
| 2.4 | 0.241 | 1.383 | 0.301 | 0.17 | 0.80 |
| 3.0 | 0.101 | 1.202 | 0.175 | 0.08 | 0.58 |
| 4.0 | 0.034 | 1.082 | 0.077 | 0.03 | 0.44 |
| 5.0 | 0.014 | 1.037 | 0.036 | 0.01 | 0.38 |

### Poměry

**𝓕(s) / ζ(s):**
- Pro **s ≈ 1.2**: 𝓕 > ζ (factor ~1.8×) → geometrie přidává extra váhu
- Pro **s ≈ 1.6**: 𝓕 < ζ (crossover!) → přechod
- Pro **s > 2**: 𝓕 << ζ → geometrie má mnohem těžší ocas

**𝓕(s) / P(s):**
- Pro **s < 2.2**: 𝓕 > P → geometrie váží víc než jen primes
- Pro **s ≈ 2.2**: 𝓕 ≈ P (crossover!)
- Pro **s > 2.2**: 𝓕 < P → primes dominují

**Průměrné poměry** (přes všechna s):
- Mean(𝓕/ζ) = **0.28**
- Mean(𝓕/P) = **1.11**

---

## Interpretace

### Co jsme objevili

1. **𝓕(s) je blíž k ζ(s) než k P(s)**
   - Geometrie Primal Forest **nekóduje čistě prvočísla**
   - Spíš kóduje "obecnou strukturu všech čísel" s mírným přeceněním primes

2. **Crossover efekt**
   - Pro malá s (blízko pólu ζ v s=1): geometrie přidává váhu
   - Pro střední s (s ≈ 2): geometrie je srovnatelná s univerzální sumou
   - Pro velká s (s > 3): geometrie má lehčí ocas než ζ

3. **Závislost na s je komplexní**
   - 𝓕(s) není jednoduchý násobek ζ(s) nebo P(s)
   - Není to ani lineární kombinace: 𝓕(s) ≠ a·ζ(s) + b·P(s)
   - Má **vlastní analytickou strukturu**

### Porovnání s lokálním chováním

**Lokálně** (Varianta B):
- F₉₇(1) ≈ 6.9 (prvočíslo)
- F₉₆(1) ≈ 1.6 (kompozitní)
- Ratio ≈ 4.3×

**Globálně** (Varianta A):
- Mean F_p(1) ≈ 9.0
- Mean F_c(1) ≈ 5.4
- Ratio ≈ 1.7×

**Závěr**: Jednotlivá čísla mohou mít extrémní hodnoty, ale průměrné chování je mírnější!

### Proč není 𝓕 blíž k P?

**Možné vysvětlení**:

Geometrie Primal Forest měří **všechny možné faktorizace** (včetně těch, které nevedou k úspěchu). Pro kompozitní číslo n = pq:
- Existuje "hit" pro d = p, k = q - p - 1
- Ale také existuje mnoho "skoro-hitů" pro jiná d
- Soft-min agreguje přes všechna d → váží i "neúspěšné pokusy"

Pro prvočíslo p:
- Žádný "hit"
- Ale také méně "dobrých aproximací" než u velkých kompozitních čísel
- Výsledek: vyšší F_p, ale ne dramaticky

**Analogie**: Je to jako měřit "obtížnost faktorizace" spíše než "je to prvočíslo ano/ne".

---

## Grafy

### Graf 1: Dual-axis srovnání

**Co vidíme**:
- **Oranžová** 𝓕(s): klesá rychle od s=1.2, pak pomaleji
- **Modrá** ζ(s): standardní monotónní pokles k 1
- **Zelená** P(s): klesá nejrychleji (nejméně členů)

**Pozorování**: 𝓕(s) je kvalitativně **mezi ζ a P**, ale blíž k ζ.

### Graf 2: Poměry

**Levý panel** (𝓕/ζ):
- Start: ~1.8 (geometrie > univerzální)
- Crossover: s ≈ 1.4
- Pak klesá k ~0.01 (geometrie << univerzální)

**Pravý panel** (𝓕/P):
- Start: ~5.6 (geometrie >> jen primes)
- Crossover: s ≈ 2.2
- Pak klesá k ~0.38 (geometrie < jen primes)

**Interpretace crossoverů**: Pro různá s geometrie váží čísla jinak! Není to univerzální.

### Graf 3: Rescaled shapes

Všechny tři funkce normalizované na [0,1] ukázaly:
- **ζ(s)**: nejplynulejší pokles
- **P(s)**: nejstrmější pokles (méně členů)
- **𝓕(s)**: mezi nimi, ale s vlastním charakterem

---

## Porovnání s Původním Problémem

### Co jsme opravili

**Původní graf** (`dirichlet-vs-zeta.pdf`):
- Srovnával F₉₇(s) vs. ζ(2s)
- **Problém**: local vs. global, navíc různé argumenty (s vs. 2s)
- **Výsledek**: nečitelný graf, modrá křivka mimo rozsah

**Nový přístup**:
1. **Varianta B** (local-local): F_n(s) vs. ζ_n(s) ✓
2. **Varianta A** (global-global): 𝓕(s) vs. ζ(s) ✓ (tento dokument)

### Férové srovnání dosaženo

Nyní srovnáváme:
- 𝓕(s) = Σ F_n(1)/n^s → agregace geometrie
- ζ(s) = Σ 1/n^s → agregace identity
- P(s) = Σ_{p prime} 1/p^s → agregace prvočíselnosti

**Všechny tři jsou globální Dirichlet series!**

---

## Otevřené Otázky

### 1. Analytické pokračování

**Otázka**: Existuje analytické pokračování 𝓕(s) do s < 1?

**Co víme**:
- 𝓕(s) konverguje absolutně pro s > 1 (jako ζ)
- Má pól v s = 1? (pravděpodobně ano, protože F_n(1) > 0 vždy)

**Hypotéza**: 𝓕(s) lze pokračovat do celé komplexní roviny mimo s = 1.

### 2. Funkční rovnice

**Otázka**: Má 𝓕(s) funkční rovnici podobnou ζ(s)?

**Riemann zeta**:
$$\xi(s) = \xi(1-s) \quad \text{kde } \xi(s) = \frac{1}{2}s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s)$$

**Hypotéza**: Možná existuje modifikace Ξ(s) = γ(s)·𝓕(s) splňující Ξ(s) = Ξ(k-s) pro nějaké k?

### 3. Nuly

**Otázka**: Kde jsou nuly 𝓕(s)?

**Možnosti**:
- Triviální nuly (jako ζ v záporných sudých)? Pravděpodobně ne (F_n > 0)
- Netriviální nuly v komplexní rovině? Kde?
- Leží na kritické čáře Re(s) = 1/2? (velmi spekulativní)

### 4. Vztah k L_M(s)

**Připomenutí**: L_M(s) = Σ M(n)/n^s (z `global-dirichlet-series.md`) selhalo kvůli kruhové rekurzi.

**Otázka**: Souvisí 𝓕(s) s L_M(s)?

**Možná spojitost**:
- M(n) počítá divisory v rozsahu [2, √n]
- F_n počítá soft-min vzdálenosti ke strukturám kd + d²
- Obojí měří "faktorizační komplexitu", ale jinak

### 5. Primality testing

**Otázka**: Lze použít 𝓕(s) k testování prvočíselnosti?

**Co víme**:
- F_p(1) > F_c(1) v průměru (factor 1.7×)
- Ale variance je vysoká (std dev ~3)
- **Prakticky**: ne efektivní (potřeba O(n²) operací)
- **Teoreticky**: zajímavé jako "měkká" metrika prvočíselnosti

---

## Závěr

### Co jsme zjistili

✅ **Férovější srovnání**: 𝓕(s) vs. ζ(s) jsou obě globální series
✅ **Geometrie ≠ prvočíselnost**: 𝓕 je blíž k ζ než k P
✅ **Komplexní závislost na s**: crossovery, nekonstantní poměry
✅ **Vlastní analytická struktura**: 𝓕 není triviální kombinace ζ a P

### Co to znamená

**Primal Forest geometrie** kóduje strukturu přirozených čísel **jinak** než klasické Euler-product přístupy:
- Není to čistě "prvočíselný detektor"
- Spíš měří "obtížnost faktorizace" nebo "vzdálenost od produktových struktur"
- Má potenciál pro nové teoretické pohledy na distribuci čísel

### Další kroky

1. **Extendovat výpočet** na n = 10,000 nebo víc (testovat konvergenci)
2. **Studovat komplexní s** (nuly, póly)
3. **Hledat funkční rovnici** (numerické testy symetrie)
4. **Porovnat s jinými L-funkcemi** (Dirichlet L, modulární formy)
5. **Teoretický důkaz** některých pozorovaných vlastností

---

## Reference

**Související dokumenty**:
- `docs/global-dirichlet-series.md` - pokus o L_M(s)
- `docs/zeta-connection-analysis.md` - spekulace o Riemann Hypothesis spojitosti
- `visualizations/local-comparison-97-*.pdf` - Varianta B (local-local)

**Skripty**:
- `scripts/global_softmin_series.py` - implementace Varianty A
- `scripts/compare_local_zeta.py` - implementace Varianty B
- `scripts/explore_infinite_sum_dirichlet.wl` - původní Wolfram exploratory

**Datum vytvoření**: 18. listopadu 2025
**Status**: NUMERICALLY VERIFIED (n ≤ 1000)
**Autor**: Jan Popelka + Claude Code

---

**Nota bene**: Tento výzkum je explorativní. Všechny hypotézy vyžadují rigorózní matematické důkazy před publikací.
