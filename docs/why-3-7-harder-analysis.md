# Proč p ≡ 3,7 (mod 8) těžší než p ≡ 1,5? Strukturální analýza

**Date**: November 17, 2025
**Question**: Proč je důkaz pro p ≡ 3,7 (mod 8) těžší než pro p ≡ 1,5?
**Insight**: Odpověď může naznačit cestu k řešení!

---

## Rozdíl mezi "snadnými" a "těžkými" případy

### ✅ Snadné: p ≡ 1,5 (mod 8)  [tj. p ≡ 1 (mod 4)]

**Strukturální vlastnost**:
- Negative Pell x² - py² = -1 **MÁ** řešení (x₁, y₁)
- Fundamental unit je **KVADRÁT** jednodušší jednotky:
  ```
  ε₀ = x₀ + y₀√p = (x₁ + y₁√p)²
  ```

**Důkaz x₀ ≡ -1 (mod p):**
```
x₁² - py₁² = -1
⟹ x₁² ≡ -1 (mod p)

x₀ = x₁² + py₁²  (z kvadrování)
⟹ x₀ ≡ x₁² ≡ -1 (mod p)  ✓
```

**Klíč**: Máme **MEZIKROK** s normou -1, který se dá snadno zkombinovat mod p.

### ❌ Těžké: p ≡ 3,7 (mod 8)  [tj. p ≡ 3 (mod 4)]

**Strukturální vlastnost**:
- Negative Pell x² - py² = -1 **NEMÁ** řešení
- Fundamental unit je **PRIMITIVNÍ** (není kvadrát):
  ```
  ε₀ = x₀ + y₀√p  (přímý výsledek z CF)
  ```

**Důkazový problém**:
- Není mezikrok s normou -1
- Musíme analyzovat x₀ **přímo** z CF struktury
- ❌ Parity argument nefunguje (jak ukázáno)
- ❌ Přímá genus theory zatím také ne

**Klíč**: Chybí nám **jednoduchý mezikrok** jako u p ≡ 1 (mod 4).

---

## Co tato struktura naznačuje?

### Hypotéza 1: Použijme "half-unit" místo negative Pell

Pro p ≡ 3 (mod 8):
- Center convergent (x_m, y_m) má **norm = -2** (empiricky 100%)
- Analogie: -2 hraje roli -1 pro p ≡ 1 (mod 4)?
- Vztah x_m → x₀?

Pro p ≡ 7 (mod 8):
- Center convergent (x_m, y_m) má **norm = +2** (empiricky 100%)
- Vztah x_m → x₀?

**Otázka**: Jak přesně se x₀ konstruuje z x_m pro sudou periodu?

### Hypotéza 2: Fundamentální rozdíl v "generaci" jednotky

**p ≡ 1 (mod 4)**: ε₀ generována **quadrováním** (ε₁²)
- Kvadrování zachovává mod p vlastnosti jednoduše
- Proto snadný důkaz

**p ≡ 3 (mod 4)**: ε₀ generována **CF rekurzí** (primitivně)
- Rekurze je složitější na analýzu mod p
- Proto těžší důkaz

**Důsledek**: Potřebujeme porozumět **CF rekurzním formulím** hlouběji!

---

## Nová strategie: Analýza "půl-cesty"

### Pro p ≡ 3 (mod 8)

**Známo**:
1. Period = 2m, m liché
2. Center (x_m, y_m): x_m² - py_m² = -2
3. x₀ na pozici 2m-1 (konec periody)

**CF recurrence** (Perron):
Pro palindromickou CF [a₀; a₁, ..., a_m, ..., a₁, 2a₀]:

```
h_{2m} = (nějaká formule z h_m)
```

**Konkrétně potřebujeme**: Jak se h_{2m-1} (x₀) vyjádří přes h_m (x_m)?

### Pro p ≡ 7 (mod 8)

**Známo**:
1. Period = 2m, m sudé (protože period ≡ 0 mod 4)
2. Center (x_m, y_m): x_m² - py_m² = +2
3. x₀ na pozici 2m-1

**Stejná potřeba**: Formule x₀ z x_m.

---

## Možný přístup: Matrix formule pro CF

CF convergenty lze vyjádřit jako:

```
[h_n]   = M_n · M_{n-1} · ... · M_1 · [1]
[k_n]                              [0]
```

kde M_i = [a_i  1]
          [1    0]

Pro palindromickou CF s periodou 2m:

```
M_{2m} = M_1 · M_2 · ... · M_m · M_m · ... · M_2 · M_1
       = (M_1 · ... · M_m)²  [ne přesně, ale podobně]
```

**Důsledek pro mod p**:
Pokud dokážeme vyjádřit M_{2m} přes M_m, můžeme analyzovat x₀ mod p pomocí x_m mod p!

---

## Konkrétní test case: p = 3

**Nejjednodušší příklad pro p ≡ 3 (mod 8)!**

```
√3 = [1; 1, 2]  (period = 2)
```

CF convergenty:
- h₀/k₀ = 1/1
- h₁/k₁ = 2/1  (první partial quotient a₁ = 1)
- h₂/k₂ = 5/3  (konec periody, a₂ = 2)

Tedy:
- m = 1 (polovina periody)
- x_m = h₁ = 2, y_m = k₁ = 1
- x₀ = h₂ = 5 (ale tohle není fundamentální solution!)

Počkat, zkontrolujme:
- 2² - 3·1² = 4 - 3 = 1  ← Tohle už JE fundamentální solution!

Ne, pro p = 3 je period = 1, ne 2. Spletl jsem se.

Zkusme p = 11:

```
√11 = [3; 3, 6]  (period = 2)
```

- h₀/k₀ = 3/1
- h₁/k₁ = 10/3  (a₁ = 3)
- h₂/k₂ = 63/19 (a₂ = 6)

Check:
- 10² - 11·3² = 100 - 99 = 1  ✓ (fundamental solution!)
- x₀ = 10, y₀ = 3
- x₀ mod 11 = 10 ≡ -1 (mod 11)  ✓

**Center convergent**:
- m = 1, takže x_m = h₁ = 10, y_m = k₁ = 3
- Check: 10² - 11·3² = 100 - 99 = 1

Hm, pro period = 2, center convergent = fundamental solution!

**Potřebuji příklad s delší periodou!**

---

## Příklad: p = 19 (period > 2)

```
p = 19 ≡ 3 (mod 8)
```

Spočítám CF a convergenty:

[Tohle vyžaduje výpočet...]

---

## Klíčová otázka k zodpovězení

**Pro p ≡ 3 (mod 8) s periodou 2m (m liché, m > 1):**

Pokud x_m² - py_m² = -2 (center convergent), jak z toho plyne x₀ mod p?

**Možná cesta**:
1. Dokázat x_m² ≡ -2 (mod p) rigorózně (z CF struktury)
2. Nalézt explicitní formuli: x₀ = f(x_m, y_m, p)
3. Odvodit x₀ mod p z x_m mod p

**Analogie s p ≡ 1 (mod 4)**:
- Tam: x₁² ≡ -1 (mod p) → x₀ = x₁² + py₁² ≡ -1 (mod p)
- Tady: x_m² ≡ -2 (mod p) → x₀ = ??? ≡ -1 (mod p)

Potřebuji najít ???

---

## Závěr: Směr dalšího výzkumu

1. **Matematický**: Nalézt explicitní recurrence formuli pro CF convergenty
   - Perron: "Die Lehre von den Kettenbrüchen"
   - Nebo odvodit přímo z matrixové reprezentace

2. **Computační**: Testovat vzorec x₀ mod p vs x_m mod p
   - Pro mnoho příkladů p ≡ 3,7 (mod 8) s různými periodami
   - Hledat pattern

3. **Teoretický**: Použít genus theory jinak
   - Místo přímého důkazu x₀ mod p
   - Dokázat vlastnosti center convergent
   - Pak odvodnit x₀ mod p jako důsledek

**Klíčový insight**:
> Difference between p ≡ 1,5 and p ≡ 3,7 is that the former has "intermediate unit with norm -1" (negative Pell), while the latter doesn't.
>
> **Solution**: Find the equivalent "intermediate object" for p ≡ 3,7 — likely the **center convergent with norm ±2**!

---

**Status**: Směr výzkumu identifikován
**Next step**: Explicitní CF recurrence formule + computational pattern search

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
