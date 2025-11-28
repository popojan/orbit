# Od Chebyshevovy geometrie k hierarchickým b-vektorům

**Datum:** 2025-11-28
**Účel:** Dokumentace logické cesty od geometrického invariantu k algebraické struktuře

---

## 1. Výchozí bod: Chebyshevův invariant

Vše začíná překvapivým faktem:

$$\int_{-1}^{1} |T_{k+1}(x) - x \cdot T_k(x)| \, dx = 1$$

pro všechna $k \geq 2$, kde $T_k$ je Chebyshevův polynom prvního druhu.

**Klíčové pozorování:** Tento invariant platí pro VŠECHNA přirozená čísla — prvočísla i složená. Celková plocha je vždy 1.

**Přirozená otázka:** Skrývá vnitřní struktura tohoto integrálu informaci o faktorizaci $k$?

---

## 2. Rozklad na laloky (lobes)

Integrál lze přepsat pomocí identity:
$$T_{k+1}(x) - x \cdot T_k(x) = -(1-x^2)U_{k-1}(x) = -\sin(k\theta)\sin(\theta)$$

kde $x = \cos\theta$ a $U_{k-1}$ je Chebyshevův polynom druhého druhu.

### Nuly integrantu

Integrál má nuly v bodech:
$$x_n = \cos\frac{n\pi}{k}, \quad n = 0, 1, \ldots, k$$

Tyto nuly rozdělují interval $[-1, 1]$ na $k$ **laloků** (lobes).

### Klasifikace nul

- **Primitivní nula:** $\gcd(n, k) = 1$
- **Zděděná nula:** $\gcd(n, k) > 1$
- **Univerzální:** $n = 0$ nebo $n = k$ (krajní body $\pm 1$)

### Klasifikace laloků

Lalok $n$ (mezi nulami $x_{n-1}$ a $x_n$) je:
- **Primitivní:** pokud $\gcd(n-1, k) = 1$ AND $\gcd(n, k) = 1$
- **Zděděný:** pokud alespoň jedna hranice sdílí faktor s $k$
- **Univerzální:** krajní laloky ($n = 1$ nebo $n = k$)

---

## 3. Primality test z geometrie

### Věta (Geometrická charakterizace prvočíselnosti)

$$k \text{ je prvočíslo} \iff A_{\text{inh}}(k) = 0$$

kde $A_{\text{inh}}(k)$ je celková plocha zděděných laloků.

### Interpretace

- **Pro prvočísla:** Veškerá vnitřní plocha je v primitivních lalocích
- **Pro složená čísla:** Část plochy "uniká" do zděděných laloků

### Konzervační zákon

$$1 = A_{\text{univ}}(k) + A_{\text{prim}}(k) + A_{\text{inh}}(k)$$

Faktorizace mění DISTRIBUCI plochy, ale ne její CELKOVOU hodnotu.

---

## 4. Znaménka laloků

Každý lalok má přirozené znaménko dané alternující povahou $\sin(k\theta)$:

$$\text{sign}(\text{lalok } n) = (-1)^{n-1}$$

- Liché laloky: $+1$
- Sudé laloky: $-1$

### Definice: Sign sum

$$\Sigma\text{signs}(k) = \#\{\text{liché primitivní laloky}\} - \#\{\text{sudé primitivní laloky}\}$$

### Pozorování

| Typ $k$ | $\Sigma\text{signs}$ |
|---------|----------------------|
| Prvočíselná mocnina $p^e$ | $-1$ |
| Semiprvočíslo $pq$ | $+1$ nebo $-3$ |
| Produkt 3 prvočísel | $\{-13, -9, -5, -1, 3, 7, 11\}$ |

**Otázka:** Co určuje, která hodnota nastane?

---

## 5. Spojení s Fareyovými posloupnostmi

### Bridge formula

Pro liché $k$:
$$J_{\text{prim}}(k) = \frac{\Sigma\text{signs}(k)}{k}$$

kde $J_k = \frac{1}{2}\int_{-1}^{1}(1-x)U_{k-1}(x)\,dx$.

Parciální součty $S_n = \sum_{k=1}^{n} J_k$ jsou Fareyovi sousedé čísla $1/2$.

**Význam:** Geometrická struktura laloků (přes znaménka) je spojena s Fareyovou teorií.

---

## 6. Vstup Čínské věty o zbytcích (CRT)

### Klíčový vhled

Pro $k = p_1 p_2 p_3$ existuje bijekce:

$$\text{Primitivní lalok } n \longleftrightarrow \text{Primitivní signatura } (a_1, a_2, a_3)$$

kde $a_i \in \{2, \ldots, p_i - 1\}$ a $n$ je CRT rekonstrukce:

$$n \equiv a_1 c_1 + a_2 c_2 + a_3 c_3 \pmod{k}$$

### CRT koeficienty

$$c_i = M_i \cdot e_i, \quad M_i = k/p_i, \quad e_i = M_i^{-1} \bmod p_i$$

---

## 7. Od geometrie k algebře: Klíčový přechod

### Geometrický fakt
Znaménko laloku $n$ je $(-1)^{n-1}$, tedy závisí na PARITĚ $n$.

### Algebraický fakt
Parita $n$ závisí na paritě CRT rekonstrukce:

$$n \bmod 2 = (a_1 b_1 + a_2 b_2 + a_3 b_3) \bmod 2$$

kde $b_i = c_i \bmod 2$ jsou **CRT parity**.

### Důsledek
**Geometrické znaménko = Algebraická parita CRT koeficientů**

Toto je most mezi geometrií a algebrou!

---

## 8. Vzorec pro $\omega = 3$

### Inversion indicator

$$\varepsilon_{ij} = \begin{cases} 1 & \text{pokud } p_i^{-1} \bmod p_j \text{ je sudé} \\ 0 & \text{pokud } p_i^{-1} \bmod p_j \text{ je liché} \end{cases}$$

### Closed form

$$\boxed{\Sigma\text{signs}(p_1 p_2 p_3) = 11 - 4 \times (\#\varepsilon + \#b)}$$

kde:
- $\#\varepsilon = \varepsilon_{12} + \varepsilon_{13} + \varepsilon_{23}$ (počet "inverzí")
- $\#b = b_1 + b_2 + b_3$ (počet lichých CRT koeficientů)

### Ověřeno
759 případů, 0 chyb.

---

## 9. Komplementarita: $\varepsilon = 1 - b_2$

### Objev

Pro pár $(p, q)$ platí:
$$\varepsilon_{pq} + b_2 \equiv 1 \pmod{2}$$

### Důkaz

- $\varepsilon_{pq} = 1$ iff $p^{-1} \bmod q$ je sudé
- $b_2 = (p \cdot (p^{-1} \bmod q)) \bmod 2 = (p^{-1} \bmod q) \bmod 2$ (protože $p$ je liché)
- Tedy: $\varepsilon = 1 \iff b_2 = 0$

### Důsledek

$\varepsilon$ a $b$ jsou **komplementární** pohledy na tutéž strukturu!

---

## 10. Sjednocená notace: Hierarchické b-vektory

### Definice

Pro množinu prvočísel $S = \{p_1, \ldots, p_\omega\}$ a podmnožinu $T \subseteq S$ s $|T| \geq 2$:

$$b_T = (b_i)_{p_i \in T}$$

kde $b_i$ je CRT parita pro prvočíslo $p_i$ v rámci produktu $\prod_{p \in T} p$.

### Hierarchická kolekce

$$\mathcal{B}(k) = \bigcup_{\ell=2}^{\omega} \{ b_T : T \subseteq S, |T| = \ell \}$$

### Věta o určení

$\Sigma\text{signs}(k)$ je **jednoznačně určen** kolekcí $\mathcal{B}(k)$.

### Ověřeno

| $\omega$ | Případy | Konstantní vzory |
|----------|---------|------------------|
| 3 | 759 | closed form existuje |
| 4 | 275 | 274/274 |
| 5 | 56 | 56/56 |

---

## 11. Složitost: Exponenciální růst

### Počet bitů v $\mathcal{B}(k)$

$$\sum_{\ell=2}^{\omega} \ell \binom{\omega}{\ell} = \omega \cdot 2^{\omega-1}$$

| $\omega$ | Bitů |
|----------|------|
| 2 | 2 |
| 3 | 12 |
| 4 | 32 |
| 5 | 80 |
| 6 | 192 |

**Každý nový prvočíselný faktor zdvojnásobí potřebnou informaci!**

---

## 12. Srovnání s permutacemi

| Aspekt | Permutace | Naše struktura |
|--------|-----------|----------------|
| Objekt | $\sigma \in S_n$ | $k = p_1 \cdots p_\omega$ |
| Znaménko | $(-1)^{\#\text{inverzí}}$ | $\Sigma\text{signs}(k)$ |
| Struktura | Jedna úroveň (páry) | Hierarchická (úrovně 2 až $\omega$) |
| Složitost | $O(n^2)$ | $O(\omega \cdot 2^\omega)$ |

### Proč je naše struktura bohatší?

CRT rekonstrukce zavádí **přenosy** (carries). Pro $\omega \geq 4$ přenosy na různých úrovních **interagují**, což vyžaduje plnou hierarchii.

---

## 13. Čistě algebraická formulace

Celá teorie JDE formulovat bez Chebysheva:

```
PrimitivePairs(k) = {n ∈ {2,...,k-1} : gcd(n-1,k) = gcd(n,k) = 1}

Σsigns(k) = Σ_{n ∈ PrimitivePairs(k)} (-1)^{n-1}
```

### Role geometrie

| Geometrie poskytla | Algebraický ekvivalent |
|--------------------|------------------------|
| Motivaci | "Proč studovat tuto veličinu?" |
| Vizualizaci | Laloky vs abstraktní páry |
| Pojmenování | "Primitivní lalok" vs "coprime pár" |
| Spojení s Fareym | Bonus aplikace |

**Geometrie byla "lešením" pro konstrukci. Budova (algebraická teorie) stojí sama.**

---

## Závěr

### Cesta

```
Chebyshevův invariant = 1
         ↓
Rozklad na laloky
         ↓
Primitivní vs zděděné
         ↓
Primality test (A_inh = 0)
         ↓
Znaménka laloků
         ↓
Σsigns(k)
         ↓
CRT bijekce
         ↓
Parita CRT koeficientů
         ↓
b-vektory
         ↓
Komplementarita ε + b = 1
         ↓
Hierarchická struktura B(k)
         ↓
Exponenciální složitost O(ω · 2^ω)
```

### Hlavní výsledky

1. **Pro $\omega \leq 3$:** Existuje jednoduchý closed form
2. **Pro $\omega \geq 4$:** Plná hierarchie je nutná
3. **Struktura je bohatší než permutace** kvůli CRT přenosům
