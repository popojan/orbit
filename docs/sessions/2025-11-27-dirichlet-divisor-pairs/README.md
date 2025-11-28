# Dirichletova řada pro uspořádané páry dělitelů

**Datum:** 2025-11-27
**Kontext:** Explorativní diskuse nad draftem `docs/drafts/divisor-count-dirichlet-series.tex`

---

## 1. Hlavní identita

Pro $P(n) = \lfloor \tau(n)/2 \rfloor$ (počet dělitelských párů $(d, n/d)$ s $d < n/d$):

$$L_P(s) = \sum_{n=1}^{\infty} \frac{P(n)}{n^s} = \frac{\zeta(s)^2 - \zeta(2s)}{2}$$

---

## 2. Kombinatorická struktura

### Rekurence $C_n$

$$C_1 = -2L_0, \qquad C_{n+1} = C_n^2 - 2L_n$$

kde $L_k = L_P(2^k s)$.

### Bijekce s binárními rozklady

Monomy v $C_n$ odpovídají rozkladům $2^{n-1}$ na mocniny 2.

| $n$ | $C_n$ | Počet monomů (A002577) |
|-----|-------|------------------------|
| 1 | $-2L_0$ | 1 |
| 2 | $4L_0^2 - 2L_1$ | 2 |
| 3 | $16L_0^4 - 16L_0^2 L_1 + 4L_1^2 - 2L_2$ | 4 |

---

## 3. Speciální body $s_n = 1/(2^n+1)$

### Proč jsou speciální?

Pro $s_n = 1/(2^n+1)$ platí:
$$2^n s_n = \frac{2^n}{2^n+1} = 1 - s_n$$

Řetězec zdvojování se **uzavře** přes funkcionální rovnici:
$$\zeta(2^n s_n) = \zeta(1-s_n) = f(s_n) \cdot \zeta(s_n)$$

### Příklady

| $n$ | $s_n$ | $2^n s_n$ | kroků |
|-----|-------|-----------|-------|
| 1 | 1/3 | 2/3 | 1 |
| 2 | 1/5 | 4/5 | 2 |
| 3 | 1/9 | 8/9 | 3 |
| 4 | 1/17 | 16/17 | 4 |

---

## 4. Obecná racionální čísla $p/q$

### Podmínka uzavření

Řetězec se uzavře pro $q = p/m$ právě když:
$$\exists k: \quad 2^k \equiv -1 \pmod{m}$$

### Hustota "dobrých" jmenovatelů

| $m \leq$ | uzavírá se | hustota |
|----------|------------|---------|
| 100 | 24/49 | 49.0% |
| 1000 | 190/499 | 38.1% |
| 10000 | 1522/4999 | 30.4% |

### Prvočísla vs složená

- **Prvočísla** $\leq 10000$: 71.5% se uzavírá
- **Složená lichá** $\leq 10000$: 17.1% se uzavírá

### "Špatná" prvočísla

Prvočísla kde $\text{ord}_p(2)$ je liché (řetězec se neuzavře):

$$7, 23, 31, 47, 71, 73, 79, 89, 103, 127, 151, 167, 191, 199, \ldots$$

Souvisí s **Artinovou hypotézou** o primitivních kořenech.

---

## 5. Komplexní argumenty

### Mapa podle Re$(s) = a$

| Oblast | $a$ | Řetězec | Uzavření |
|--------|-----|---------|----------|
| Konvergence | $> 1$ | zbytečný | — |
| Kritický pás | $(0, 1)$ | $\lceil\log_2(1/a)\rceil$ kroků | jen $s_n$ reálné |
| Imaginární osa | $= 0$ | nikdy | nikdy |
| Záporné | $< 0$ | funkc. rovnice | — |

### Klíčové pozorování

Pro komplexní $s = a + bi$ s $b \neq 0$:
$$2^k s = 1 - s \quad \Rightarrow \quad b(2^k + 1) = 0 \quad \Rightarrow \quad b = 0$$

**Uzavření možné pouze pro reálná $s$!**

---

## 6. Záporné argumenty

### Přímá cesta

Pro $s < 0$: $1 - s > 1$ (oblast konvergence)

$$\zeta(-p/q) = f(-p/q) \cdot \zeta(1+p/q)$$

kde $f(s) = 2^s \pi^{s-1} \sin(\pi s/2) \Gamma(1-s)$.

### Výhoda

$\zeta(1+p/q)$ je konvergentní Dirichletova řada — **žádná kruhovost**.

---

## 7. Problém kruhovosti

### Tautologie

Identita $L_P(s) = \frac{\zeta(s)^2 - \zeta(2s)}{2}$ je **definice**, ne teorém.

Rovnice:
$$\zeta(s)^2 = 2L_P(s) + \zeta(2s)$$

po dosazení definice:
$$\zeta(s)^2 = \zeta(s)^2 - \zeta(2s) + \zeta(2s) = \zeta(s)^2$$

### Řešení: Eta funkce

$$\eta(s) = \sum_{n=1}^{\infty} \frac{(-1)^{n-1}}{n^s} = (1 - 2^{1-s}) \zeta(s)$$

**Konverguje pro Re$(s) > 0$**, i v kritickém pásu!

$$\zeta(s) = \frac{\eta(s)}{1 - 2^{1-s}}$$

Kruhovost výpočtu je rozbitá, ale identita zůstává tautologická.

---

## 8. Co dělá $\zeta$ speciální?

### Tři unikátní vlastnosti

1. **Triviální koeficienty** $a(n) = 1$
   - Konvoluce = počítání (ne vážení)
   - $1 * 1 = \tau$ (počet dělitelů)

2. **Paritní vlastnost** $\tau(n)$
   - $\tau(n)$ liché $\Leftrightarrow$ $n$ je čtverec
   - Dělení 2 vždy dává celá čísla

3. **Kombinatorická interpretace**
   - $P(n) = \lfloor \tau(n)/2 \rfloor$ = počet párů dělitelů

### Zobecnění pro L-funkce

Pro $L(s,\chi) = \sum \chi(n)/n^s$:
$$L(s,\chi)^2 - L(2s,\chi^2) = \sum \frac{\tau_\chi(n) - \chi(\sqrt{n})^2 \chi_{\square}(n)}{n^s}$$

kde $\tau_\chi(n) = \sum_{d|n} \chi(d)\chi(n/d)$.

**Ztrácí kombinatorickou interpretaci** — koeficienty mohou být záporné.

---

## 9. Selbergova třída

### Definice

Funkce $F(s)$ je v Selbergově třídě $\mathcal{S}$ pokud:

1. Dirichletova řada $F(s) = \sum a(n)/n^s$
2. Analytické pokračování
3. Funkcionální rovnice
4. **Eulerův produkt**
5. Růstová podmínka

### Je $L_P$ v $\mathcal{S}$?

**NE!** Protože $P(n) = \lfloor \tau(n)/2 \rfloor$ není multiplikativní:
- $P(6) = 2$
- $P(2) \cdot P(3) = 1 \neq 2$

$L_P$ **nemá Eulerův produkt**.

---

## 10. RMT a Hilbert-Pólya hypotéza

### Hilbert-Pólya (1914)

Netriviální nuly $\zeta(s)$ jsou vlastní hodnoty samosdruženého operátoru $H$:
$$\rho_n = \frac{1}{2} + i\gamma_n \quad \Rightarrow \quad H\psi_n = \gamma_n \psi_n$$

Pokud $H$ existuje, RH je důsledkem kvantové mechaniky.

### Montgomery-Odlyzko (1973-1989)

Statistika nul odpovídá **GUE** (Gaussian Unitary Ensemble).

Párová korelace:
$$R_2(x) = 1 - \left(\frac{\sin \pi x}{\pi x}\right)^2 + \delta(x)$$

### Berry-Keating (1999)

Kandidát na Hamiltonián:
$$H = xp = x \cdot \left(-i\hbar \frac{d}{dx}\right)$$

Problémy: není samosdružený na $L^2(\mathbb{R})$.

### Weilův explicitní vzorec

$$\sum_\rho h(\rho) = h(1) + h(0) - \sum_p \sum_k \frac{\log p}{p^{k/2}} \hat{h}(k \log p)$$

Nuly a prvočísla jsou "Fourierově duální".

---

## 11. Spekulativní spojení

### Párování jako symetrie

$$d \leftrightarrow n/d$$

Připomíná CPT symetrii. Hamiltonián s touto symetrií by měl specifickou strukturu.

### Dělitelé jako "stavy"

Pro $n = p_1^{a_1} \cdots p_k^{a_k}$:
$$\tau(n) = (a_1+1)\cdots(a_k+1) = \dim(\text{prostor stavů}?)$$

### $L_P$ jako partiční funkce

- $\zeta(s)^2$ = plná partiční funkce
- $\zeta(2s)$ = diagonální stavy ($d = \sqrt{n}$)
- $L_P$ = off-diagonální stavy

### Hadamardův produkt

$$\frac{\zeta(s)^2}{\zeta(2s)} \sim \prod_\rho \frac{(1-s/\rho)^2}{1-2s/\rho}$$

Obsahuje informaci o **párech nul**.

---

## 12. Fermionová algebra (NEFUNGUJE)

### Pokus o konstrukci

Definovali jsme involuce $\sigma_n: d \mapsto n/d$ a rozklad $V_n = V_n^+ \oplus V_n^-$:
- $V_n^+$ = symetrické funkce na dělitelích
- $V_n^-$ = antisymetrické funkce, $\dim V_n^- = P(n)$

### Kreační/anihilační operátory

$$a_p^\dagger: V_n^- \to V_{np}^-, \quad a_p: V_{np}^- \to V_n^-$$

### Výsledek: SELHÁNÍ

Antikomutace $\{a_p, a_p^\dagger\} = I$ **NEFUNGUJE** pro páry dělitelů.

**Důvod:** Páry sdílejí prvočíselné faktory → degenerace (více párů kolabuje na jeden).

### Pokus o opravu přes $\mathbb{Z}[i]$

Rozšíření na Gaussovy celé čísla degeneraci **neodstraní** — problém je strukturální.

### Primon gas (existující řešení)

Fermionový primon gas (Julia 1990, Spector 1990) **funguje**:
- Fockův prostor = squarefree čísla
- $\{a_p, a_p^\dagger\} = I$ ✓
- Partiční funkce $Z_F = \zeta/\zeta(2s)$

**Páry dělitelů NEJSOU správná báze pro fermionovou algebru.**

---

## 13. Shrnutí

| Aspekt | Hodnota |
|--------|---------|
| Elegance identity | vysoká |
| Kombinatorická struktura | zajímavá |
| Výpočetní užitečnost | žádná |
| Nový vhled do $\zeta$ | marginální |
| Spojení s RMT | spekulativní |
| Fermionová algebra na párech | ❌ NEFUNGUJE |

**Paper je "hezká matematika"** — elegantní identita, zajímavá kombinatorika, ale neposkytuje novou cestu k výpočtu $\zeta$ hodnot ani důkazu RH.

**Hlavní výsledek této session:** Negativní výsledek o fermionové algebře.

---

## Otevřené otázky

1. Existuje modifikace $L_P$ která BY byla v Selbergově třídě?
2. Má párování $d \leftrightarrow n/d$ spektrální interpretaci?
3. Existuje operátor $\mathcal{D}$ takový, že $\text{Tr}(\mathcal{D}^{-s}) = L_P(s)$?
4. Proč právě body $2^n + 1$? (Souvislost s Fermatovými čísly?)
