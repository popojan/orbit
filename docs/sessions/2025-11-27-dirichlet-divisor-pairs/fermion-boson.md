# Fermion/Boson interpretace

## Motivace

V kvantové teorii pole:
- **Bosony** — symetrické vlnové funkce, celočíselný spin
- **Fermiony** — antisymetrické vlnové funkce, poločíselný spin

Naše involuce $\sigma_n: d \mapsto n/d$ generuje rozklad:
- $V_n^+$ — symetrické funkce: $f(d) = f(n/d)$
- $V_n^-$ — antisymetrické funkce: $f(d) = -f(n/d)$

**Otázka:** Lze $V_n^-$ interpretovat jako fermionový prostor?

---

## 1. Fockův prostor — rekapitulace

### Jednočásticový prostor

Nechť $\mathcal{H}_1$ je jednočásticový Hilbertův prostor s bází $\{|k\rangle\}_{k=1}^{K}$.

### Bosonový Fockův prostor

$$\mathcal{F}_B = \bigoplus_{n=0}^{\infty} \text{Sym}^n(\mathcal{H}_1)$$

kde $\text{Sym}^n$ je symetrický tensorový produkt.

### Fermionový Fockův prostor

$$\mathcal{F}_F = \bigoplus_{n=0}^{\infty} \wedge^n(\mathcal{H}_1)$$

kde $\wedge^n$ je antisymetrický (vnější) produkt.

### Kreační a anihilační operátory

- $a_k^\dagger$ — vytvoří částici v módu $k$
- $a_k$ — zničí částici v módu $k$

**Bosony:** $[a_j, a_k^\dagger] = \delta_{jk}$

**Fermiony:** $\{a_j, a_k^\dagger\} = \delta_{jk}$, $\{a_j, a_k\} = 0$

---

## 2. Naše situace

### Prostor pro $n$

$$V_n = \{f: \text{Div}(n) \to \mathbb{C}\}$$

s bází $\{\delta_d\}_{d|n}$ kde $\delta_d(e) = \delta_{d,e}$.

### Involuce

$$(\sigma_n f)(d) = f(n/d)$$

### Rozklad

$$V_n = V_n^+ \oplus V_n^-$$

### Dimenze

$$\dim V_n^+ = \frac{\tau(n) + \chi_\square(n)}{2}, \qquad \dim V_n^- = P(n)$$

---

## 3. Analogie s fermiony

### Páry jako "módy"

Pro $n$ nečtverec: dělitelé se párují jako $\{d, n/d\}$ s $d < n/d$.

Označme páry: $\pi_1, \pi_2, \ldots, \pi_{P(n)}$.

Např. pro $n = 12$: $\pi_1 = \{1, 12\}$, $\pi_2 = \{2, 6\}$, $\pi_3 = \{3, 4\}$.

### Antisymetrická báze

Pro každý pár $\pi_i = \{d_i, n/d_i\}$:

$$e_i = \delta_{d_i} - \delta_{n/d_i}$$

Tyto $e_1, \ldots, e_{P(n)}$ tvoří bázi $V_n^-$.

### Fermionová interpretace

Funkce $f \in V_n^-$ lze zapsat jako:

$$f = \sum_{i=1}^{P(n)} c_i \, e_i$$

Antisymetrie $e_i$ připomíná fermionové stavy:
- $e_i(d_i) = +1$
- $e_i(n/d_i) = -1$
- Záměna $d_i \leftrightarrow n/d_i$ změní znaménko

### "Obsazení páru"

Můžeme interpretovat:
- $c_i \neq 0$ — pár $\pi_i$ je "obsazen"
- $c_i = 0$ — pár $\pi_i$ je "prázdný"

---

## 4. Kreační/anihilační operátory?

### Návrh

Pro pár $\pi = \{d, n/d\}$ definujme:

$$a_\pi^\dagger: V_n \to V_n, \qquad a_\pi^\dagger = |e_\pi\rangle\langle \mathbf{1}|$$

kde $e_\pi = \delta_d - \delta_{n/d}$ a $\mathbf{1}$ je nějaký referenční stav.

### Problém

Toto nedává standardní fermionovou algebru, protože:
1. Nepřecházíme mezi různými $n$
2. Chybí dynamika (Hamiltonián)

### Alternativa: Operátory mezi různými $n$

Definujme pro prvočíslo $p$:

$$a_p^\dagger: V_n \to V_{np}$$

Toto by "přidalo" faktor $p$ k $n$.

Ale struktura dělitelů se mění netriviálně...

---

## 5. Globální Fockův prostor?

### Návrh 1: Přímá suma

$$\mathcal{F} = \bigoplus_{n=1}^{\infty} V_n^-$$

Problém: Různá $n$ mají různé dimenze, není jasná struktura.

### Návrh 2: Graduace podle $\Omega(n)$

$\Omega(n)$ = počet prvočíselných faktorů s násobností.

$$\mathcal{F} = \bigoplus_{k=0}^{\infty} \mathcal{F}_k, \qquad \mathcal{F}_k = \bigoplus_{\Omega(n)=k} V_n^-$$

$k$ by hrál roli "počtu částic".

### Návrh 3: Prostor na prvočíslech

Jednočásticový prostor:
$$\mathcal{H}_1 = \ell^2(\text{primes}) = \text{span}\{|p\rangle : p \text{ prime}\}$$

Stav $|n\rangle$ pro $n = p_1^{a_1} \cdots p_k^{a_k}$:
$$|n\rangle = |p_1\rangle^{\otimes a_1} \otimes \cdots \otimes |p_k\rangle^{\otimes a_k}$$

Ale toto jsou spíše bosony (symetrické)...

---

## 6. Alternativní pohled: Cliffordova algebra

### Generátory

Pro každý pár $\pi_i$ definujme generátor $\gamma_i$ s:

$$\gamma_i^2 = 1, \qquad \gamma_i \gamma_j = -\gamma_j \gamma_i \text{ pro } i \neq j$$

Toto je Cliffordova algebra $\text{Cl}_{P(n)}$.

### Reprezentace

$V_n^-$ je přirozeně modul nad touto algebrou?

Potřebujeme ověřit...

### Spin reprezentace

Pro Cliffordovu algebru $\text{Cl}_k$ existuje spinorová reprezentace dimenze $2^{\lfloor k/2 \rfloor}$.

Pro $n = 12$: $P(12) = 3$, spinorová dim = $2^1 = 2$.

Ale $\dim V_{12}^- = 3 \neq 2$. Nesedí přímo.

---

## 7. Supersymetrie?

### $\mathbb{Z}_2$ gradace

$$V_n = V_n^+ \oplus V_n^-$$

je přirozeně $\mathbb{Z}_2$-graduovaný prostor.

### Superalgebra

Definujme:
- Sudé prvky: operátory zachovávající $V^\pm$
- Liché prvky: operátory prohazující $V^+ \leftrightarrow V^-$

### Supercharge?

Existuje operátor $Q: V_n^+ \to V_n^-$ takový, že $Q^2 = 0$?

Kandidát:
$$Q = P^- = \frac{I - \sigma_n}{2}$$

Ověření: $Q^2 = \frac{1}{4}(I - 2\sigma_n + \sigma_n^2) = \frac{1}{4}(2I - 2\sigma_n) = \frac{1}{2}(I - \sigma_n) \neq 0$.

Takže $Q^2 \neq 0$, není to nilpotentní.

Ale $(P^-)^2 = P^-$ (projektor), což je jiná vlastnost.

---

## 8. Partiční funkce

### Fermionová partiční funkce

Pro fermiony v módech s energiemi $\epsilon_k$:

$$Z_F = \prod_k (1 + e^{-\beta \epsilon_k})$$

### Bosonová partiční funkce

$$Z_B = \prod_k \frac{1}{1 - e^{-\beta \epsilon_k}}$$

### Naše $L_P$?

$$L_P(s) = \sum_{n=1}^{\infty} \frac{P(n)}{n^s} = \sum_{n=1}^{\infty} \frac{\dim V_n^-}{n^s}$$

Kdyby $n$ byla "energie" a $P(n)$ "degenerace":

$$L_P(s) = \text{Tr}_{V^-}(n^{-s})$$

kde trace je přes všechny antisymetrické módy.

### Srovnání

$$L_P(s) = \frac{\zeta(s)^2 - \zeta(2s)}{2}$$

- $\zeta(s)^2$ ~ bosonová partiční funkce (všechny páry)
- $\zeta(2s)$ ~ korekce za "diagonální" stavy
- Dělení 2 ~ symetrizace

---

## 9. Tabulka analogií

| Kvantová teorie | Naše struktura |
|-----------------|----------------|
| Jednočásticový prostor $\mathcal{H}_1$ | Prostor párů? |
| Bosonový Fock $\mathcal{F}_B$ | $\bigoplus_n V_n^+$? |
| Fermionový Fock $\mathcal{F}_F$ | $\bigoplus_n V_n^-$? |
| Kreační $a^\dagger$ | Násobení prvočíslem? |
| Anihilační $a$ | Dělení prvočíslem? |
| Hamiltonián $H$ | $\log n$? |
| Partiční funkce $Z$ | $L_P(s)$? |

---

## 10. Otevřené otázky

1. **Lze definovat konzistentní kreační/anihilační operátory?**
   - Mezi různými $n$ (násobení/dělení prvočíslem)?
   - Splňují fermionové antikomutační relace?

2. **Existuje přirozený Hamiltonián?**
   - $H = \log$ by dával $e^{-\beta H} = n^{-\beta}$
   - Partiční funkce by byla $\sum \dim(V_n^-) n^{-\beta} = L_P(\beta)$

3. **Jaká je role prvočísel?**
   - Prvočísla jako "fundamentální módy"?
   - Složená čísla jako "vícečásticové stavy"?

4. **Souvislost s RMT?**
   - GUE statistika pro fermiony
   - Nuly $\zeta$ mají GUE statistiku
   - Je tu spojení přes naši fermionovou strukturu?

---

## 11. Závěr

Analogie $V_n^- \sim$ fermiony je **částečná**:

| Vlastnost | Platí? |
|-----------|--------|
| Antisymetrie | ✓ |
| $\mathbb{Z}_2$ gradace | ✓ |
| Dimenze = $P(n)$ | ✓ |
| Kreační/anihilační operátory | ? |
| Fermionová algebra | ? |
| Partiční funkce = $L_P$ | ✓ (formálně) |

Pro plnou fermionovou interpretaci potřebujeme:
- Definovat operátory mezi různými $n$
- Ověřit antikomutační relace
- Najít fyzikální Hamiltonián
