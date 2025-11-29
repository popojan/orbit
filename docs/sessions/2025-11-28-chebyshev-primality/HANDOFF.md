# Chebyshev Sign Sum - Session Handoff

## Cíl výzkumu

Najít **closed-form formuli** pro Chebyshev sign sum `ss(k) = Σsigns(k)` pro squarefree k s ω prvočíselnými faktory.

**Explicitní direktiva uživatele:** "We must break the complexity, not confirm and resign"

## Co je ověřeno

### ω = 2 (semiprimes p·q)
```
ss(pq) = 1 - 4·ε   kde ε = (p⁻¹ mod q) mod 2
```
Ekvivalentně: `ss(pq) ∈ {1, -3}` podle parity modulárního inverzu.

### ω = 3 (triple p₁·p₂·p₃)
```
ss(p₁p₂p₃) = 2 - ss(p₁p₂) - ss(p₁p₃) - ss(p₂p₃) - 4·sumBtriple
```
kde `sumBtriple = b₁ + b₂ + b₃` a `bᵢ = ((∏ⱼ≠ᵢ pⱼ)⁻¹ mod pᵢ) mod 2`

**VERIFIED** na 969+ triplech (prvočísla 3-113).

## Aktuální stav: ω = 4

### Co víme
1. **22-komponentní hierarchický pattern UNIQUELY DETERMINES ss** (0 konfliktů)
   - Level 2: 6 pairwise inverse parities
   - Level 3: 4×3 = 12 triple b-vector components
   - Level 4: 4 quadruple b-vector components

2. **Lineární formula `f = sumL2 - sumL3 + sumL4` má 4-hodnotový residuál** {-1, 0, 1, 2}
   - Rozložení: přibližně rovnoměrné
   - Residuál závisí na kombinaci (Legendres, mod8) - ale 129 konfliktů zůstává

### Co NEFUNGUJE
- Přímá recurrence pouze z triple subsolutions
- XOR patterns (xorL2, xorL4, sumXorTriples)
- Mod 4, mod 8 inverzy
- Lineární kombinace sumů úrovní
- 2-bitové produktové formule

### Naposledy testovaná hypotéza: "Flattened Recursion"
```
ss(p₁p₂p₃p₄) = c + a·Σss(pairs) + b·Σss(triples) + d·sumBquad
```
Test běžel na 495 případech (primes 3-41), hledal parametry c,a,b,d. **Nedokončeno** - test přerušen.

## Klíčové soubory

```
docs/sessions/2025-11-28-chebyshev-primality/
├── test-flattened-recursion.wl    # hlavní testovací skript
├── generate-omega4-data.wl        # generuje omega4-data.mx
├── explore-residual-structure.wl  # analýza 4-valued residuálu
├── analyze-conflicts.wl           # analýza 129 konfliktních případů
└── omega4-data.mx                 # precomputed data (pokud existuje)
```

## Doporučené další kroky

1. **Dokončit flattened recursion test** - spustit `test-flattened-recursion.wl` a podívat se na výsledky
2. **Pokud flattened recursion selže** - zkusit:
   - Legendre symboly jako dodatečný diskriminátor
   - Mod 8 třídy v kombinaci s Legendres
   - Nelineární kombinace (produkty bitů)
3. **Alternativní přístup**: Analyzovat strukturu residuálu pro `f = sumL2 - sumL3 + sumL4`

## Matematický kontext

- `ss(k) ≡ 1 (mod 4)` vždy platí
- `f = (ss - 1)/4` je klíčová veličina
- CRT parity: n mod 2 = Σ aᵢ·bᵢ (mod 2) kde bᵢ jsou CRT koeficienty
- Inverse parity bias koreluje s kvadratickým charakterem (mod 8 unifikace)

## Komunikace

Uživatel preferuje **češtinu** pro komunikaci.

---
*Handoff vytvořen 2025-11-29*
