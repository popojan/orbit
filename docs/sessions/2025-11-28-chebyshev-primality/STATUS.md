# Chebyshev Sign Sum - Aktuální stav výzkumu

## Cíl

Najít **closed-form formuli** pro Chebyshev sign sum `ss(k) = Σsigns(k)` pro squarefree k s ω prvočíselnými faktory.

**Explicitní direktiva:** "We must break the complexity, not confirm and resign"

---

## ✅ Ověřené formule

### ω = 2 (semiprimes p·q)
```
ss(pq) = 1 - 4·ε   kde ε = (p⁻¹ mod q) mod 2
```
- Hodnoty: `ss(pq) ∈ {1, -3}`
- Závisí pouze na paritě modulárního inverzu

### ω = 3 (triples p₁·p₂·p₃)
```
ss(p₁p₂p₃) = 2 - ss(p₁p₂) - ss(p₁p₃) - ss(p₂p₃) - 4·sumBtriple
```
kde `sumBtriple = b₁ + b₂ + b₃` a `bᵢ = ((∏ⱼ≠ᵢ pⱼ)⁻¹ mod pᵢ) mod 2`

**Verifikováno:** 969+ triples (prvočísla 3-113), 0 chyb

**Klíčový poznatek:** Rekurzní formule vyžaduje:
1. Subsolutions z nižších úrovní (ss pro páry)
2. NOVOU informaci (sumBtriple) - nelze ji odvodit jen z subsolutions

---

## 🔬 ω = 4 - Současný stav

### Co víme s jistotou (1365 případů, prvočísla 3-53)

#### 1. Hierarchický pattern UNIQUELY DETERMINES ss
- **22 binárních komponent** (mod 2 CRT koeficienty):
  - Level 2: 6 pairwise inverse parities
  - Level 3: 12 triple b-vector components (4 triples × 3)
  - Level 4: 4 quadruple b-vector components
- **0 konfliktů** - každý pattern odpovídá právě jedné hodnotě ss
- Problém: Nevíme, jak zapsat mapping jako uzavřenou formuli

#### 2. Flattened recursion s 4-hodnotovým residuálem

**Formula:**
```
ss(p₁p₂p₃p₄) = -10 + Σss(pairs) + Σss(triples) + 4·sumBquad + (5 + 4·r)
```

kde:
- `Σss(pairs)` = součet ss pro všech 6 párů prvočísel
- `Σss(triples)` = součet ss pro všechny 4 trojice
- `sumBquad = Σᵢ₌₁⁴ bᵢ` kde `bᵢ = (∏ⱼ≠ᵢ pⱼ)⁻¹ mod pᵢ (mod 2)`
- **r ∈ {0, 1, 2, 3}** - 2-bitová korekce

**Rozložení r na 1365 případech:**
- r=0: 172 případů (12.6%)
- r=1: 518 případů (37.9%)
- r=2: 509 případů (37.3%)
- r=3: 166 případů (12.2%)

**Rozklad:** r = lowBit + 2·highBit kde lowBit, highBit ∈ {0,1}
- lowBit: {0: 681, 1: 684} - téměř rovnoměrné
- highBit: {0: 690, 1: 675} - téměř rovnoměrné

---

## ❌ Co jsme zkoušeli a NEFUNGUJE

### Všechny testy provedeny na datasetu 1365 případů (primes 3-53)

#### 1. Přímá rekurze z subsolutions
- **Test:** `ss = c + a·Σss(pairs) + b·Σss(triples) + d·sumBquad`
- **Výsledek:** Žádné parametry c,a,b,d nedávají perfektní fit
- **Nejlepší:** Residuály {5, 9, 13, 17} (4 hodnoty)

#### 2. XOR patterns z hierarchických bitů
Testováno:
- `xorL2` = XOR všech 6 level-2 bitů
- `xorL4` = XOR všech 4 level-4 bitů
- `sumXorTriples` = sum XORů ze 4 triples
- Všechny kombinace těchto pro lowBit/highBit

**Výsledek:** Žádná XOR kombinace neposkytuje exact match

#### 3. Produktové formule
Testováno:
- Produkty `xorTriple[i] · xorTriple[j]` pro všechny páry
- Kombinace `xorL2`, `xorL4`, produkty XORů
- 2^12 kombinací různých členů

**Výsledek:** Žádná produktová formula nedává exact match

#### 4. Dvojice bitů s interakcemi
Testováno všechny páry (i,j) z 22 bitů:
- Formula: `r = c + a·bit[i] + b·bit[j] + d·bit[i]·bit[j]`
- Prohledáno: 22×21/2 = 231 párů, každý s různými koeficienty

**Výsledek:** Žádný pár bitů není dostatečný

#### 5. Modulární třídy
- `(sumL2 mod 4, sumL3 mod 4, sumL4 mod 4)` → 63 jedinečných, 62 konfliktů
- `(sumL2 mod 2, sumL3 mod 2, sumL4 mod 2)` = XOR patterns → 8 patterns, všechny konflikty
- `(sumL2 mod 4, sumL4)` → 20 unique pairs, 18 konfliktů

**Výsledek:** Jednoduché modulární třídy sum nestačí

#### 6. Legendre symboly
- Součet Legendre symbolů `(pᵢ/pⱼ)` pro všechny páry
- XOR Legendre symbolů
- Kombinace s inverse parities

**Výsledek:** Neposkytuje dodatečnou diskriminaci

#### 7. Mod 8 classes, rekurzivní redukce
- Inverse parity mod 8 místo mod 2
- Řetězová redukce: x mod pₙ mod pₙ₋₁ ... mod 2

**Výsledek:** Všechny varianty mají konflikty

---

## 🎯 Co to znamená

### Pozitivní zjištění

1. **Existuje deterministický pattern** - 22 bitů → ss je funkce (0 konfliktů)
2. **Lineární aproximace s malým residuem** - flattened recursion + 4-valued correction
3. **Struktura je hierarchická** - každý level přidává informaci

### Negativní zjištění

1. **Boolovská funkce pro r je složitá**
   - Není to jednoduchý XOR/AND kombinace
   - Není to kvadratická funkce dvou bitů
   - Pravděpodobně vyžaduje vyšší stupeň nebo více vstupů

2. **Subsolutions nejsou dostatečné**
   - Podobně jako u ω=3, kde potřebujeme sumBtriple
   - Pro ω=4 potřebujeme něco navíc nad rámec ss(pairs) + ss(triples)

3. **Jednoduchá lineární algebra nestačí**
   - LinearModelFit dává non-integer koeficienty
   - Residuály nejsou lineárně závislé na sumách

---

## 💡 Hypotézy k dalšímu testování

### 1. Vyšší stupeň boolovské funkce
- Trojice nebo čtveřice bitů s interakcemi
- Degree-3 nebo degree-4 polynomy nad GF(2)

### 2. Nelineární kombinace subsolutions
- Něco jako `r = f(ss(pairs), ss(triples), sumBquad)` kde f není lineární
- Možná zahrnující součiny ss hodnot

### 3. Dodatečná algebraická struktura
- Galois rozšíření
- Kvadratická rezidua v jiné formě
- Jacobi symboly vyššího řádu

### 4. Kombinatorická interpretace
- r by mohlo záviset na počtu určitých konfigurací
- Counting formule nad modulárními inverzemi

---

## 📊 Dostupná data

### Precomputed datasets
- `omega4-data.mx`: 1365 entries (15 primes: 3-53)
  - Obsahuje: primes, k, ss, f=(ss-1)/4, full hierarchical pattern
  - Format: Mathematica MX (binary)

### Scripts
- `generate-omega4-data.wl`: generátor dat
- `analyze-modular-classes.wl`: analýza modulárních tříd
- `test-flattened-recursion.wl`: test rekurzní formule

---

## 🔍 Další kroky (doporučení)

1. **Machine learning klasifikátor** - Natrénovat neural net/decision tree na 22→r mapping
2. **Exhaustive search degree-3** - Systematické hledání kubických formulí
3. **Teoretický přístup** - Algebraická analýza CRT parity struktur
4. **Větší dataset** - Rozšířit na 20+ primes pro lepší pattern detection

---

*Poslední update: 2025-11-29*
*Dataset: 1365 cases (primes 3-53)*
