# Stern-Brocot, Calkin-Wilf a Brahmagupta-Bhaskara rovnice

**Date:** 2025-12-13
**Context:** Odkaz z hlavního dokumentu o Möbiových involucích

---

## Brahmagupta-Bhaskara rovnice

Hledáme celočíselná řešení:

$$x^2 - Dy^2 = \pm 1$$

**Historická poznámka:** Rovnice byla studována indickými matematiky:
- **Brahmagupta** (628 CE): chakravala metoda
- **Bhaskara II** (1150 CE): kompletní algoritmus
- Euler ji mylně připsal Pellovi (1759)

---

## Stern-Brocot strom

### Konstrukce (mediant)

```
Sentinely: 0/1 a 1/0

        1/1
       /   \
     1/2   2/1
     / \   / \
   1/3 2/3 3/2 3/1
```

**Pravidlo:** Mediant a/b a c/d je (a+c)/(b+d)

### Klíčová vlastnost

**Cesta k iracionálnímu √D kóduje jeho řetězový zlomek!**

```
√2 = [1; 2, 2, 2, ...]

SB cesta: R, LL, RR, LL, RR, ...
          ↑   ↑↑   ↑↑
         a₀  a₁   a₂  (koeficienty CF)
```

### Wildbergerův algoritmus

1. Spočítej CF pro √D
2. Zakóduj jako LR cestu v SB stromu
3. Konvergenty = uzly na cestě = řešení Brahmagupta-Bhaskara

**Příklad √2:**

| Konvergent | SB cesta | x² - 2y² |
|------------|----------|----------|
| 1/1 | (kořen) | 1 - 2 = -1 |
| 3/2 | R L | 9 - 8 = +1 ✓ |
| 7/5 | R LL R | 49 - 50 = -1 |
| 17/12 | R LL RR L | 289 - 288 = +1 ✓ |

---

## Calkin-Wilf strom

### Konstrukce (algebraická)

```
Kořen: 1/1
L(i/j) = i/(i+j)
R(i/j) = (i+j)/j

        1/1
       /   \
     1/2   2/1
     / \   / \
   1/3 3/2 2/3 3/1
```

### Jiné uspořádání!

SB a CW obsahují stejné zlomky, ale v **jiném pořadí**:

| Zlomek | Pozice v SB | Pozice v CW |
|--------|-------------|-------------|
| 2/3 | pod 1/2 | pod 2/1 |
| 3/5 | pod 2/3 | pod 3/2 |

### Hyperbinární interpretace

b(n) = počet způsobů jak napsat n jako součet mocnin 2 (každá max 2×)

n-tý racionál = b(n)/b(n+1)

---

## Palindromická symetrie a její zachování

### Původ symetrie: Periodický CF

Pro √2 = [1; 2̄] (perioda 1) má SB cesta strukturu:
```
R, LL, RR, LL, RR, ...
```

Tato **periodická struktura SB cesty** pochází přímo z periodicity CF.

### Klíčové pozorování (Dec 13, 2025)

**Symetrie se ZACHOVÁ pod bijekcí SB → CW!**

Bijekce mezi stromy existuje (oba obsahují všechny Q⁺ právě jednou),
ale mají jiné uspořádání. Přesto palindromická struktura přežívá:

| Konvergent | CW cesta | Palindrom? |
|------------|----------|------------|
| 1 | (prázdná) | ✓ |
| 3/2 | LR | ✗ |
| 7/5 | **RLLR** | ✓ |
| 17/12 | LRRLLR | ✗ |
| 41/29 | **RLLRRLLR** | ✓ |
| 99/70 | LRRLLRRLLR | ✗ |
| 239/169 | **RLLRRLLRRLLR** | ✓ |

**Vzor:** Liché indexy (1, 3, 5, 7, ...) dávají palindromy!

### Srovnání pro různá D

| √D | CF perioda | CW palindromy na indexech |
|----|------------|---------------------------|
| √2 | [1; 2̄] | {1, 3, 5, 7, 9, ...} = liché |
| √3 | [1; 1,2̄] | {1, 2, 3, 5, 7, 9, ...} |
| √5 | [2; 4̄] | {1} pouze |

### Pozorování

Pro √2 = [1; 2̄]:
- CW palindromy pouze pro **liché indexy** (3, 5, 7, ...)
- SB cesty mají blokovou strukturu odpovídající CF koeficientům
- Symetrie NENÍ triviálně zachována bijekcí - je to vlastnost konkrétních čísel

### Otevřená otázka

Proč liché konvergenty √2 mají palindromické CW cesty?
- Hypotéza: souvisí s rekurentní strukturou konvergentů
- p_{n+1} = 2p_n + p_{n-1} pro √2
- Tato rekurence může vytvářet symetrickou strukturu v obou kódováních

---

## Proč SB pro Pell, CW pro enumeraci

| Vlastnost | Stern-Brocot | Calkin-Wilf |
|-----------|--------------|-------------|
| Uspořádaný (left < root < right) | ✓ | ✗ |
| Best rational approximations | ✓ | ✗ |
| CF kódování v cestě | ✓ | ✗ |
| Brahmagupta-Bhaskara | ✓ | ✗ |
| Explicitní b(n)/b(n+1) | ✗ | ✓ |
| Hyperbinární počítání | ✗ | ✓ |

---

## Souvislost s Möbiovými involucemi

### SB generátory

Stern-Brocot operace L, R **nejsou** Möbiovy transformace v obvyklém smyslu - jsou definovány kontextuálně (závisí na sousedech).

### CW generátory

```
L(x) = x/(1+x)    — NE involuce (L² ≠ id)
R(x) = (1+x)/x    — NE involuce (R² ≠ id)
```

Ale: L a R jsou **vzájemně inverzní** vůči 1:
- L(R(x)) = R(L(x)) = x (pro vhodné x)

### Klíčový závěr

**Tranzitivní akce na Q⁺ vyžaduje ne-involuční generátory.**

Involuce (jako silver, copper) zachovávají příliš mnoho struktury (invariant I = odd(p(q-p))) a nemohou být tranzitivní.

---

## Reference

- Calkin, N. & Wilf, H.S. (2000). "Recounting the Rationals." *American Mathematical Monthly* 107(4), 360-363.
- Wildberger, N.J. YouTube: "Solving Pell's equation" series
- Graham, Knuth, Patashnik. *Concrete Mathematics* - kapitola o SB stromech
- Stern, M.A. (1858). "Über eine zahlentheoretische Funktion." *J. reine angew. Math.* 55, 193-220.

---

## Otevřené otázky

1. Je palindromická struktura CW cest pro √2 náhoda, nebo má hlubší význam?
2. Existuje přímá transformace SB cesta → CW cesta?
3. Jak se chovají CW cesty pro algebraická čísla vyššího stupně?
