# Möbius Involution Theory

**Date:** 2025-12-13
**Origin:** CF compression study (Dec 10, 2025)
**Status:** Pure mathematics, standardní teorie + naše aplikace

---

## Historická poznámka

| Naše jméno | Správná atribuce | Poznámka |
|------------|------------------|----------|
| **silver** = (1-x)/(1+x) | **Cayley transform** (1846) | Klasika komplexní analýzy |
| **copper** = 1-x | Triviální reflexe | — |
| Diskový model | **Riemann** (1854) / **Beltrami** (1868) | NE "Poincaré" (1882) |
| x² - Dy² = ±1 | **Brahmagupta-Bhāskara** | NE "Pell" (Eulerův omyl) |

**Co je naše:** Aplikace Cayleyho transformu na strukturu Q ∩ (0,1), orbitový invariant I = odd(p(q-p)), spojení s egyptskými zlomky a pyramidami.

**Viz také:**
- [Riemannovo historické review](../../reviews/historical/riemann-historical-review.md) — anachronistické myšlenkové cvičení
- [PF 2024](../../../personal/PF-2024.pdf) — novoročenka s teleskopickou identitou (prehistorie této práce)

---

## Počet involucí: 3, 4, nebo 7?

### Odpověď: Záleží na kontextu

| Systém | Počet | Involuce |
|--------|-------|----------|
| **Metalická triáda** | 3 | γ_silver, γ_golden, γ_4 |
| **+ copper** | 4 | + copper (pevný bod 1/2) |
| **+ copper konjugáty** | 7 | + c·γ_s·c, c·γ_g·c, c·γ_4·c |

**Přirozený uzavřený systém = 3 metalické involuce.**

---

## 4-Inversion Law (Proč právě {1, 2, 4})

### Věta (dokázáno Dec 10, 2025)

$$\boxed{\gamma_{\text{silver}}([0; n^{\infty}]) = [0; (4/n)^{\infty}]}$$

### Důkaz

Nechť $x = [0; n^{\infty}]$, tedy $x^2 + nx - 1 = 0$.

Položme $y = \gamma_{\text{silver}}(x) = \frac{1-x}{1+x}$.

Dosazením $x = \frac{1-y}{1+y}$ do $x^2 + nx = 1$:

$$\frac{(1-y)^2}{(1+y)^2} + n\frac{1-y}{1+y} = 1$$

Po úpravě: $y^2 + \frac{4}{n}y - 1 = 0$

Tedy $y = [0; (4/n)^{\infty}]$. ∎

### Důsledek: Uzavřenost {1, 2, 4}

| n | 4/n | Uzavřené? |
|---|-----|-----------|
| 1 | 4 | ✓ (1,4 ∈ {1,2,4}) |
| 2 | 2 | ✓ (pevný bod) |
| 4 | 1 | ✓ (1,4 ∈ {1,2,4}) |
| 3 | 4/3 | ✗ (není celé) |

**{1, 2, 4} = dělitelé 4 = jediná uzavřená množina.**

---

## Tři úrovně involucí

### Úroveň 1: Metalická triáda (3 involuce)

| Involuce | Vzorec | Pevný bod | CF |
|----------|--------|-----------|-----|
| γ_silver | (1-x)/(1+x) | √2-1 | [0; 2^∞] |
| γ_golden | (2-x)/(2x+1) | φ⁻¹ ≈ 0.618 | [0; 1^∞] |
| γ_4 | (1-2x)/(2+x) | √5-2 | [0; 4^∞] |

**Konjugace:** γ_silver · γ_golden · γ_silver = γ_4

### Úroveň 2: + Copper (4 involuce)

| Involuce | Vzorec | Pevný bod |
|----------|--------|-----------|
| copper | 1-x | 1/2 |

**copper NENÍ metalická** (pevný bod 1/2 = [0; 2], ne [0; n^∞]).

### Úroveň 3: + Copper konjugáty (7 involucí)

| Konjugát | Pevný bod | = 1 - (metalický) |
|----------|-----------|-------------------|
| c·γ_s·c | 2-√2 ≈ 0.586 | 1 - (√2-1) |
| c·γ_g·c | (3-√5)/2 ≈ 0.382 | 1 - φ⁻¹ |
| c·γ_4·c | 3-√5 ≈ 0.764 | 1 - (√5-2) |

**Tyto NEJSOU metalické** — jejich pevné body nesplňují x² + nx - 1 = 0 pro celé n.

---

## Symetrie kolem 1/2

```
γ_4 (0.236)      ←copper→    c·γ_4·c (0.764)     sum = 1
c·γ_g·c (0.382)  ←copper→    γ_golden (0.618)    sum = 1
γ_silver (0.414) ←copper→    c·γ_s·c (0.586)     sum = 1
copper (0.500)   ←copper→    copper (0.500)      sum = 1
```

**Toto je důsledek copper(x) = 1-x, NE vlastnost metalických čísel.**

---

## Vyřazeno: gold = x/(1-x)

**gold NENÍ involuce:** gold²(x) = x/(1-2x) ≠ x

---

## Key Structural Results

### 1. Conjugation in Metallic Triad

```
γ_silver · γ_golden · γ_silver = γ_4
γ_silver · γ_4 · γ_silver = γ_golden
```

**γ_silver is central** — it conjugates γ_golden ↔ γ_4.

### 2. Fixed Point Exchange

γ_silver exchanges the fixed points of the other two:

```
γ_silver(φ⁻¹) = √5 - 2
γ_silver(√5 - 2) = φ⁻¹
```

### 3. Orbit Structure under {silver, copper}

Compositions:
- SC = silver ∘ copper: p/q → p/(2q-p) — **preserves numerator**
- CS = copper ∘ silver: p/q → 2p/(p+q) — **doubles numerator**

SC and CS are **inverse**: SC ∘ CS = CS ∘ SC = id

---

## Orbit Invariant Theorem (NEW: Dec 13, 2025)

### Věta

Pro zlomek p/q v základním tvaru definujme:

$$I(p/q) = \text{odd}(p(q-p))$$

kde odd(n) = n / 2^v₂(n) je lichá část.

**Tvrzení:** I(p/q) je orbitový invariant pro ⟨silver, copper⟩.

### Důkaz

1. **copper zachovává:** copper(p/q) = (q-p)/q
   - p'(q'-p') = (q-p)(q-(q-p)) = (q-p)·p = p(q-p) ✓

2. **silver zdvojnásobuje:** silver(p/q) = (q-p)/(q+p)
   - p'(q'-p') = (q-p)((q+p)-(q-p)) = (q-p)·2p = 2·p(q-p)

Tedy odd(p(q-p)) je invariant. ∎

### Důsledky

1. **Každé liché číslo n má orbitu** s reprezentantem 1/(n+1)
2. **Orbity jsou nekonečné** (silver opakovaně zdvojnásobuje)
3. **Racionální čísla v (0,1) se rozpadají na nekonečně mnoho orbit**

### Příklady

| Reprezentant | p(q-p) | I = odd part |
|--------------|--------|--------------|
| 1/2 | 1·1 = 1 | 1 |
| 1/4 | 1·3 = 3 | 3 |
| 1/6 | 1·5 = 5 | 5 |
| 3/8 | 3·5 = 15 | 15 |
| 7/11 | 7·4 = 28 | 7 |

### Pyramidové zlomky

(Viz [Egypt Pyramid Index](../egypt-pyramid-index.md) pro kompletní kontext.)

| Pyramida | Zlomek | p(q-p) | Orbita I | Faraon |
|----------|--------|--------|----------|--------|
| Khufu | 7/11 | 28 | **7** | Khufu |
| Red Pyramid | 7/15 | 56 | **7** | Sneferu |
| Bent upper | 7/15 | 56 | **7** | Sneferu |
| Bent lower | 7/10 | 21 | 21 | Sneferu |
| Khafre | 2/3 | 2 | 1 | Khafre |
| Menkaure | 5/8 | 15 | 15 | Menkaure |

**Klíčové zjištění:** Khufu (7/11) a Red Pyramid (7/15) jsou **v téže orbitě**!
- Cesta: 7/11 →copper→ 4/11 →silver→ 7/15
- Sneferu (otec Khufu) postavil Red Pyramid jako první úspěšnou pyramidu
- Matematické spojení přes silver∘copper: otec → syn

---

### Orbit Count

| q ≤ N | Počet zlomků | Počet orbit |
|-------|--------------|-------------|
| 5 | 9 | 2 |
| 10 | 31 | 7 |
| 15 | 71 | 12 |
| 20 | 127 | 22 |

---

## Group Structure

### Metallic Triad Group

Generated by three involutions with relation:
```
⟨γ_s, γ_g, γ_4 | γ_s² = γ_g² = γ_4² = 1, γ_s·γ_g·γ_s = γ_4⟩
```

This is isomorphic to the **infinite dihedral group** D_∞.

### Simple Triad Group

{silver, copper} generates an infinite group.
Adding gold (non-involution) connects previously disjoint orbits.

---

## Origin

These involutions emerged from studying **continued fraction compression**:

1. γ_silver compresses CF coefficients: [0; 1^∞] ↔ [0; 4^∞]
2. Seeking other Möbius involutions with metallic fixed points led to γ_golden, γ_4
3. The conjugation structure was discovered Dec 13, 2025

**Full derivation:** [gamma-egypt-simplification.md](../2025-12-10-cf-egypt-equivalence/gamma-egypt-simplification.md)

---

## Volba domény: (0,1) vs Q⁺ vs Q

### Proč NE Q⁻?

Egyptské zlomky vyžadují **kladné** jednotkové zlomky. Rozšíření na Q⁻ by:
1. Rozbilo monotonicitu teleskopických sum
2. Porušilo Egypt interpretaci
3. Ztratilo spojení s CF konvergenty (vždy kladné)

### Rozšíření na Q⁺

| Oblast | Operace | Zachovává I? |
|--------|---------|--------------|
| (0,1) | silver, copper | ANO |
| (1,∞) | silver' = R∘S∘R, copper' = R∘C∘R | ANO |
| Přechod | reciprocal = 1/x | ANO |

**Klíčové:** Reciprocal JE involuce (1/(1/x) = x) a zachovává invariant I.

Proto {silver, copper, reciprocal} na Q⁺ má stále **∞ orbit**.

---

## Transitivity Results (SOLVED: Dec 13, 2025)

### RIGORÓZNÍ DŮKAZ

**VĚTA:** ⟨silver, copper, inv⟩ působí tranzitivně na Q⁺.

**DŮKAZ:**

1. **Maticová reprezentace** (Möbius ↔ PSL₂):
   - silver: [[-1,1],[1,1]]
   - copper: [[-1,1],[0,1]]
   - inv: [[0,1],[1,0]]

2. **Calkin-Wilf generátory:**
   - L(x) = x/(1+x) ↔ [[1,0],[1,1]]
   - R(x) = x+1 ↔ [[1,1],[0,1]]

3. **Klíčový výpočet** (projektivně, až na skalár):
   ```
   L = copper ∘ inv ∘ copper ∘ silver ∘ inv ∘ silver
   R = copper ∘ silver ∘ inv ∘ silver ∘ inv ∘ inv
   ```

4. **Calkin-Wilf věta (2000):** ⟨L, R⟩ je tranzitivní na Q⁺.

5. **Závěr:** ⟨L, R⟩ ⊆ ⟨silver, copper, inv⟩ ⟹ tranzitivita. ∎

**Reference:** Calkin & Wilf, "Recounting the Rationals", AMM 2000.

### Klíčové důsledky

- **{silver, copper, inv}** stačí pro tranzitivitu (golden není potřeba!)
- **Proč BFS ukazoval 8 orbit?** L je 6-krokové slovo → dlouhé cesty
- Třetí involuce (inv) je **nutná** - {silver, copper} má ∞ orbit

### Systémy a jejich tranzitivita

1. **{silver, copper, gold, inv}** - gold NENÍ involuce
2. **{silver, copper, golden, inv}** - golden JE involuce (fix 1/φ)
3. **{silver, copper, inv}** - MINIMÁLNÍ tranzitivní systém involucí

```
gold(x) = x/(1-x)         — NENÍ involuce! (gold² ≠ id)
golden(x) = (2-x)/(2x+1)  — JE involuce (fix 1/φ ≈ 0.618)
inv(x) = 1/x              — JE involuce na Q⁺
```

### Důkaz tranzitivity (experimentální)

BFS s maxPQ=500 potvrdilo:
- 1/2 → 5/19 (v 15 krocích)
- 1/2 → 31/16 (v 15 krocích)
- Všechny testované zlomky jsou v jedné orbitě

### Pozor na "trap" - BFS artefakty!

Původně jsme viděli "2 orbity" s malým limitem (maxDenom=30):
- Orbit 1: velká (obsahuje 1/2, 1/3, ...)
- Orbit 2: "12 prvků" (5/19, 7/17, 5/12, ...)

**Toto byla ILUZE!** S větším limitem jsou všechny ve stejné orbitě.

Příčina: BFS s malým limitem ořezává cesty procházející přes zlomky s velkými jmenovateli.

### Srovnání orbit

| Generátory | Doména | Počet orbit | Invariant |
|------------|--------|-------------|-----------|
| {silver, copper} | (0,1) | ∞ | I = odd(p(q-p)) |
| {silver, copper, inv} | Q⁺ | ≥ 8 | ? |
| **{silver, copper, gold, inv}** | **Q⁺ \ {1}** | **1** | **žádný** |
| **{silver, copper, golden, inv}** | **Q⁺** | **1** | **žádný** |

### Proč NE vylučovat 1 s golden?

```
golden(1) = 1/3   ← platný zlomek!
1/3 ←golden→ 1    (golden je involuce)
silver(1/3) = 1/2 ← 1/3 je v orbitě z 1/2
```

Cesta: `1/2 ←silver→ 1/3 ←golden→ 1`

**S golden je 1 SOUČÁSTÍ orbity!** Vyloučení 1 platí jen pro {silver, copper, gold, inv} (kde gold(1) = ∞).

### Důsledek

**Tranzitivní akce = žádný netriviální invariant.**

Překvapivě: čistě involuční systém {silver, copper, golden, inv} je tranzitivní na CELÉM Q⁺!

### Zachování čitatele 7

V některých řetězcích se čitatel 7 zachovává: 7/27 → 7/47 → 7/87 → 7/167...

(Souvisí s orbitou pyramidy Khufu = 7/11, která má I = 7.)

**Skript:** `scripts/transitivity-gold-test.wl`

---

## Dokumentace pokusů o nalezení invariantu (Dec 13, 2025)

### Kontext

Původní BFS s malým limitem (maxDenom=30) ukázal "2 orbity":
- Orbit 1: velká (obsahuje 1/2, 1/3, 2/3, ...)
- Orbit 2: "12 prvků" (5/19, 7/17, 5/12, 7/12, 10/17, 14/19, 19/14, 17/10, 12/7, 12/5, 17/7, 19/5)

### Pokusy o nalezení invariantu oddělujícího orbity

| Kandidát | Orbit 1 (1/2) | Orbit 2 (5/19) | Odlišné? |
|----------|---------------|----------------|----------|
| I = odd(p(q-p)) | 1 | 35 | ANO, ale I není zachováno pod golden |
| (p+q) mod 3 | 0 | 0 | NE |
| (p+q) mod 5 | 3 | 4 | zdánlivě ano |
| (p+q) mod 7 | 3 | 3 | NE |
| gcd(p+q, p*q) | různé | různé | žádný vzor |
| p in Fibonacci | ANO | ANO (5) | částečně |

### Klíčový objev: "2 orbity" byly ARTEFAKT

S větším limitem (maxPQ=500):
- 5/19 JE dosažitelné z 1/2 (v ~15 krocích)
- 31/16 JE dosažitelné z 1/2 (v ~15 krocích)
- Všechny testované zlomky jsou v JEDNÉ orbitě

**Příčina:** BFS s malým limitem ořezává cesty procházející přes zlomky s velkými čitateli/jmenovateli. Některé cesty vyžadují "objížďku" přes velká čísla.

### Poučení

1. **Vždy testovat s dostatečně velkým limitem** před tvrzením o počtu orbit
2. **BFS artefakty** mohou vypadat jako strukturální vlastnosti
3. **Invariant neexistuje** → tranzitivita (a naopak)

---

## Möbius vs Egypt: Orthogonal Views (Dec 13, 2025)

Möbius involuce a Egypt (raw tuple) reprezentace jsou **ortogonální** pohledy na racionální čísla:

| Zlomek | Raw tuples | Počet tupplů |
|--------|------------|--------------|
| 7/11 | `{{1,1,1,1}, {2,3,1,3}}` | 2 |
| σ(7/11) = 2/9 | `{{1,4,1,2}}` | 1 |
| κ(7/11) = 4/11 | `{{1,2,1,1}, {3,8,1,1}}` | 2 |

**Pozorování:** σ (silver) transformuje Egypt reprezentaci netriviálně — mění počet teleskopických sum i jejich parametry. Neexistuje jednoduchá korespondence mezi Möbius akcí a Egypt strukturou.

**Důsledek:** Tyto dva pohledy jsou komplementární, ne ekvivalentní. Möbius involuce operují na hodnotě zlomku, Egypt tuply kódují jeho vnitřní strukturu (CF konvergenty).

### Kompozice σκ a κσ

```
σκ(x) = σ(1-x) = x/(2-x)     — zachovává čitatel
κσ(x) = 1 - (1-x)/(1+x) = 2x/(1+x)  — zdvojnásobuje čitatel
```

Tyto kompozice jsou inverze: σκ ∘ κσ = κσ ∘ σκ = id.

---

## Powers of 2 in Calkin-Wilf Tree (Dec 13, 2025)

### Binary Encoding

Pozice n v CW stromu (level-order) odpovídá binární cestě:
- Zahoď leading 1 z binárního zápisu n
- 0 = L (levé dítě), 1 = R (pravé dítě)

| n | Binárně | Cesta | Zlomek |
|---|---------|-------|--------|
| 1 | 1 | (kořen) | 1 |
| 2 | 10 | L | 1/2 |
| 3 | 11 | R | 2 |
| 4 | 100 | LL | 1/3 |
| 5 | 101 | LR | 3/2 |
| 6 | 110 | RL | 2/3 |
| 7 | 111 | RR | 3 |
| 8 | 1000 | LLL | 1/4 |

### Mocniny dvojky = Levá páteř

**Pozice 2^k** má binární tvar `10...0` (k nul) → cesta L^k → **zlomek 1/(k+1)**

```
2^0 = 1  →  (kořen)   →  1
2^1 = 2  →  L         →  1/2
2^2 = 4  →  LL        →  1/3
2^3 = 8  →  LLL       →  1/4
2^4 = 16 →  LLLL      →  1/5
2^5 = 32 →  LLLLL     →  1/6
```

**V involuční dekompozici:** L^k = (κικσισ)^k (6k atomických involucí)

### 2^k - 1 = Pravá páteř

**Pozice 2^k - 1** má binární tvar `11...1` (k jedniček) → cesta R^(k-1) → **zlomek k**

```
2^1 - 1 = 1  →  (kořen) →  1
2^2 - 1 = 3  →  R       →  2
2^3 - 1 = 7  →  RR      →  3
2^4 - 1 = 15 →  RRR     →  4
2^5 - 1 = 31 →  RRRR    →  5
```

**V involuční dekompozici:** R^k = (κσισ)^k (4k atomických involucí)

### Souvislost s Hyperbinary

CW paper definuje hyperbinární reprezentace:
- b(n) = počet způsobů jak zapsat n jako součet mocnin 2, kde každá je použita max 2×
- n-tý zlomek = b(n)/b(n+1)

Pro mocniny dvojky:
- b(2^k) = b(2^k + 1) pro k ≥ 1 → zlomek = 1 (pozice 2^k ve sloupcovém číslování)

Ale v level-order číslování:
- Pozice 2^k dává L^k(1) = 1/(k+1)

**Klíčové:** Existují DVĚ číslování CW stromu (sloupcové vs level-order) které se liší!

---

## Open Questions

### Vyřešené

1. ~~What is the orbit structure of ⟨silver, copper⟩?~~ **SOLVED:** Orbits indexed by odd(p(q-p))
2. ~~Does adding golden merge orbits?~~ **YES:** golden breaks I = odd(p(q-p))
5. ~~**Can ANY finite set of Möbius involutions give transitive action on Q ∩ (0,1)?**~~
   - **ANSWER:** {silver, copper, golden, inv} JSOU tranzitivní na Q⁺
6. ~~**Existuje 4. involuce na Q⁺, která rozbije I a dá tranzitivitu?**~~
   - **ANSWER:** golden + inv dá tranzitivitu (čistě involuční systém!)

### Otevřené (Dec 13, 2025)

7. **Existuje analytický vzorec pro nejkratší cestu mezi zlomky?**
   - BFS dává optimální cestu, ale je to brute-force
   - **ČÁSTEČNÁ ODPOVĚĎ:** Pro členy se STEJNÝM invariantem I: dist/|CF| < 1
   - Pro členy s RŮZNÝM I: potřeba objížďka přes Q⁺ \ (0,1)
   - Existuje explicitní konstrukce?

8. **Jaká je průměrná délka cesty pro zlomky s max(p,q) ≤ N?**
   - Roste jako O(log N)? O(√N)? O(N)?
   - Závisí silně na rozložení I hodnot

9. **Souvisí struktura cest s CF reprezentací?** → **ČÁSTEČNĚ VYŘEŠENO**
   - Pro členy se stejným I: involuce dávají zkratky (ratio < 1)
   - Příklad: 1/3 z 1/2 má dist=1, |CF|=3, ratio=0.33
   - L = cicsis (6 kroků), R = csisii (6 kroků) → max ratio ≈ 6
   - **Skript:** `scripts/cf-path-analysis.wl`

10. **GCD-like algoritmus?** → **ČÁSTEČNĚ VYŘEŠENO (Dec 13, 2025)**
    - Euklidův algoritmus: iterace mod operace
    - Naše involuce: kompozice Möbiových transformací
    - **Klíčový insight:** gold = L⁻¹ (Calkin-Wilf inverze!)
    - **Viz sekce:** "Calkin-Wilf Connection" níže

11. How do these involutions act on Egyptian fraction (raw tuple) representations?

12. Is there a geometric interpretation of the conjugation γ_s·γ_g·γ_s = γ_4?

---

## Invariant Preservation Analysis (NEW)

### Which involutions preserve I = odd(p(q-p))?

| Involuce | Zachovává I? |
|----------|--------------|
| silver | ANO |
| copper | ANO |
| golden | **NE** |
| γ_4 | **NE** |

### Důsledky

1. {silver, copper} → I je invariant → ∞ orbit
2. {silver, copper, golden} → I není invariant → orbit count klesá
3. Ale stále existuje JINÝ invariant (orbit count roste s q)

### Comparison with Calkin-Wilf

Calkin-Wilf generators: L(x) = x/(1+x), R(x) = (1+x)/x

| Property | L, R | silver, copper |
|----------|------|----------------|
| Involutions | NO | YES |
| Transitive on Q∩(0,1) | YES | NO |
| Preserve I | NO | YES |

**OPRAVA (adversarial check):** Involuce MOHOU generovat tranzitivní akci!

{silver, copper, golden, inv} jsou VŠECHNY involuce a JSOU tranzitivní na Q⁺.

Klíč: inv rozšiřuje doménu na Q⁺ a umožňuje obejít bariéry v (0,1).

---

## Orbity pro prvních 10 lichých invariantů

Každé liché číslo I definuje unikátní orbitu. Kanonický reprezentant je 1/(I+1).

### Struktura orbit

1. **Všechny orbity jsou disjunktní** — I je invariant
2. **Každá orbita je nekonečná** — silver zdvojnásobuje p(q-p)
3. **Q ∩ (0,1) se rozpadá na nekonečně mnoho orbit** — indexováno lichými čísly

### Kanonické reprezentanty a Raw reprezentace

| I | Kanonický rep | Raw tuple | Další členy orbity |
|---|---------------|-----------|---------------------|
| 1 | 1/2 | `{{1,1,1,1}}` | 1/3, 2/3, 1/5, 2/5, 3/5, ... |
| 3 | 1/4 | `{{1,3,1,1}}` | 3/4, 2/5, 1/7, 3/7, ... |
| 5 | 1/6 | `{{1,5,1,1}}` | 5/6, 2/7, 5/7, 1/11, ... |
| 7 | 1/8 | `{{1,7,1,1}}` | 7/8, 2/9, 7/9, **7/11**, **7/15**, ... |
| 9 | 1/10 | `{{1,9,1,1}}` | 9/10, 2/11, 9/11, ... |
| 11 | 1/12 | `{{1,11,1,1}}` | 11/12, 2/13, 11/13, ... |
| 13 | 1/14 | `{{1,13,1,1}}` | 13/14, 2/15, 13/15, ... |
| 15 | 1/16 | `{{1,15,1,1}}` | 3/8, 5/8, 5/11, 6/11, ... |
| 17 | 1/18 | `{{1,17,1,1}}` | 17/18, 2/19, 17/19, ... |
| 19 | 1/20 | `{{1,19,1,1}}` | 19/20, 2/21, 19/21, ... |

**Vzor Raw reprezentace:** Kanonický reprezentant 1/(I+1) má vždy `{{1, I, 1, 1}}`.

**Poznámka:** I = 15 má alternativní reprezentanty: 3/8 má `{{1,2,1,3}}`, 5/8 má `{{1,1,1,1},{2,3,1,2}}`.

---

## Calkin-Wilf Connection (NEW: Dec 13, 2025)

### Klíčový insight: gold = L⁻¹

Calkin-Wilf generátory:
- L(x) = x/(1+x)
- R(x) = x+1

**Objev:** gold(x) = x/(1-x) = L⁻¹(x)!

To znamená, že gold není jen "neinvoluce" - je to přesně **inverze CW generátoru L**.

### CW cesta k libovolnému zlomku

Pro nalezení cesty z 1/2 k p/q:
1. Najdi CW cestu z 1 k p/q (pomocí inverzního procházení stromu)
2. Přidej L⁻¹ pro přechod 1/2 → 1

**Algoritmus:**
```
findCWPath[r] :=
  x = r
  path = {}
  While x ≠ 1:
    If x < 1: path = "L" ⊕ path; x = L⁻¹(x)
    Else:     path = "R" ⊕ path; x = R⁻¹(x)
  Return path
```

### Příklad: 1/2 → 3/7

```
CW cesta 1 → 3/7: RRLL (4 kroky)
CW cesta 1 → 1/2: L (1 krok)

Kombinovaná cesta: L⁻¹ (= gold), R, R, L, L
Celkem: 5 CW kroků

Verifikace:
  1/2 →L⁻¹→ 1 →R→ 2 →R→ 3 →L→ 3/4 →L→ 3/7 ✓
```

### Uzavřený vzorec pro speciální případy

**Věta:** Pro k ≥ 1:
$$\text{dist}(1/2 \to 1/(2^k+1)) = 2k - 1$$

Cesta: s·(cs)^{k-1}, kde s = silver, c = copper.

| k | 2^k+1 | Target | Path | Dist | |CF| | Ratio |
|---|-------|--------|------|------|-----|-------|
| 1 | 3 | 1/3 | s | 1 | 3 | 0.33 |
| 2 | 5 | 1/5 | scs | 3 | 5 | 0.60 |
| 3 | 9 | 1/9 | scscs | 5 | 9 | 0.56 |
| 4 | 17 | 1/17 | scscscs | 7 | 17 | 0.41 |
| 5 | 33 | 1/33 | scscscscs | 9 | 33 | 0.27 |

**Pozorování:** Involuční cesta roste **logaritmicky** (2k-1), zatímco CF délka roste **exponenciálně** (2^k+1).

### Transformace sc a cs

```
sc(p/q) = silver(copper(p/q)) = silver((q-p)/q) = p/(2q-p)
cs(p/q) = copper(silver(p/q)) = copper((q-p)/(p+q)) = 2p/(p+q)
```

**sc zachovává čitatel p**, cs ho zdvojnásobuje.

Iterace: sc^n(1/2) = 1/(2^n + 1)

### Inverze L a R přes involuce

```
L = cicsis    (6 invol. kroků)
R = csisii    (6 invol. kroků)

kde: c = copper, i = inv, s = silver
```

**Fun fact:** R = cs**isis**ii obsahuje "isis" (egyptská bohyně) uprostřed!

---

## References

- **Calkin-Wilf Tree:**
  - Neil Calkin & Herbert S. Wilf (2000). "Recounting the Rationals." *American Mathematical Monthly* 107(4), 360–363.
  - Available: https://www2.math.upenn.edu/~wilf/website/recounting.pdf
  - Key result: L(x) = x/(1+x), R(x) = 1+x generate ALL positive rationals transitively
  - But L, R are NOT involutions → explains why {silver, copper} cannot be transitive
  - **Viz také:** [Stern-Brocot, Calkin-Wilf a Brahmagupta-Bhaskara](stern-brocot-pell.md) — palindromická symetrie CW cest
- Original CF compression: [gamma-egypt-simplification.md](../2025-12-10-cf-egypt-equivalence/gamma-egypt-simplification.md) lines 636-712
- Matrix representations in original doc (lines 717-728)

---

## Technická poznámka: Pevný bod γ_golden

**Ověření:** γ_golden(x) = (2-x)/(2x+1) má pevný bod:
```
(2-x)/(2x+1) = x
2-x = 2x² + x
2x² + 2x - 2 = 0
x² + x - 1 = 0
x = (-1 ± √5)/2
```

Kladné řešení: x = (√5 - 1)/2 = φ⁻¹ ≈ **0.618**

**Proč NE 4/3?** Hodnota 4/3 > 1 je mimo interval (0,1). Jakákoli Möbiova involuce s pevným bodem mimo (0,1) nezachovává interval (0,1).

**Výběrové kritérium metalických involucí:**
1. Pevný bod musí být v (0,1)
2. Pevný bod musí splňovat x² + nx - 1 = 0 pro celé n ≥ 1
3. Involuce musí mapovat (0,1) → (0,1)
