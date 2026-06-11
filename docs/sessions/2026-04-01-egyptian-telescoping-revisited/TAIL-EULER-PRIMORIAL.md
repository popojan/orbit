# Tail Power Sums a Hurwitzova Zeta

**Date:** 2026-04-01
**Status:** ✅ PROVEN — `euler[{u,v}, s, ∞] = ζ(s, 1+u/v)` (algebraický důkaz)
**Context:** Offshoot from telescoping sum analysis. Tail power sums connect Egyptian fractions to Hurwitz zeta function.

---

## Definice

### Základní Setup

Telescoping sum pro faktorizaci $n = uv$:
$$\sum_{k=1}^{\infty} \frac{1}{(u+vk)(u+v(k-1))} = \frac{1}{uv}$$

**Split v bodě m** — truncated sum + tail:
$$\frac{1}{uv} = \underbrace{\frac{m}{u(u+vm)}}_{\text{truncated}} + \underbrace{\frac{1}{v(u+vm)}}_{\text{tail}_m}$$

### Tail Function

$$\text{tail}_m = \frac{1}{v(u+vm)} = \frac{1}{n + v^2 m}$$

### Euler Function (tail power sum)

```wolfram
tailf[{u_, v_}, m_] := 1/(u v + m v^2)
euler[{u_, v_}, s_, m_] := v^(2 s) Sum[tailf[{u, v}, k]^s, {k, 1, m}]
```

---

## Hlavní Věta

### ✅ euler[{u, v}, s, ∞] = ζ(s, 1 + u/v)

**Tvrzení:** Pro $\text{Re}(s) > 1$:

$$\text{euler}[\{u,v\}, s, \infty] = \zeta(s, 1+u/v)$$

kde $\zeta(s, a) = \sum_{n=0}^{\infty} \frac{1}{(n+a)^s}$ je Hurwitzova zeta funkce.

**Důkaz:** Tři řádky algebry.

$$\text{euler}[\{u,v\}, s, \infty] = v^{2s} \sum_{k=1}^{\infty} \frac{1}{(uv + v^2 k)^s}$$

Vytkneme $v^2$ ze závorky:

$$= v^{2s} \sum_{k=1}^{\infty} \frac{1}{v^{2s}(u/v + k)^s} = \sum_{k=1}^{\infty} \frac{1}{(u/v + k)^s}$$

Substituce $n = k-1$ (tj. $k = n+1$):

$$= \sum_{n=0}^{\infty} \frac{1}{(1 + u/v + n)^s} = \zeta(s, 1+u/v) \qquad \square$$

### Důsledek: Polygamma spojení

Pro celočíselné $s \geq 2$ je Hurwitzova zeta ekvivalentní polygamma funkci:

$$\zeta(s, a) = \frac{(-1)^s}{(s-1)!} \psi^{(s-1)}(a)$$

Konkrétně:
- $s=2$: $\text{euler} = \psi'(1+u/v)$ (trigamma)
- $s=3$: $\text{euler} = -\tfrac{1}{2}\psi''(1+u/v)$ (tetragamma)
- $s=4$: $\text{euler} = \tfrac{1}{6}\psi'''(1+u/v)$

### Speciální případ: Riemannova zeta

Pro $u=0, v=1$: $\text{tailf} = 1/k$, tedy

$$\text{euler}[\{0,1\}, s, \infty] = \zeta(s, 1) = \zeta(s)$$

---

## Co Closed Form Říká o Reprezentaci

### Pozorování 1: Closed form závisí JEN na poměru u/v

Výsledek $\zeta(s, 1+u/v)$ neobsahuje $u$ ani $v$ zvlášť — jen jejich poměr.

To znamená: různé faktorizace se stejným poměrem dávají stejný euler:

| {u, v} | n = uv | u/v | euler |
|--------|--------|-----|-------|
| {2, 3} | 6 | 2/3 | ζ(s, 5/3) |
| {4, 6} | 24 | 2/3 | ζ(s, 5/3) |
| {6, 9} | 54 | 2/3 | ζ(s, 5/3) |

**Prefaktor $v^{2s}$ vyruší škálování v jmenovateli** — tail power sum vidí jen "úhel" faktorizace, ne její "velikost".

### Pozorování 2: Různé faktorizace téhož n JSOU rozlišitelné

Pro $n = 6$:

| {u, v} | u/v | Hurwitz parametr |
|--------|-----|-----------------|
| {1, 6} | 1/6 | ζ(s, 7/6) |
| {2, 3} | 2/3 | ζ(s, 5/3) |
| {3, 2} | 3/2 | ζ(s, 5/2) |
| {6, 1} | 6 | ζ(s, 7) |

Hurwitzova zeta parametrizovaná poměrem u/v **diskriminuje** mezi faktorizacemi.

### ❌ Pozorování 3: Hurwitzovo Spektrum NENÍ invariant

**Definice:** *Hurwitzovo spektrum* racionálního čísla $q$ je:

$$\text{Spec}_H(q) = \{1 + u_k/v_k\}_{k=1}^{N}$$

**Testováno** na 199 zlomcích s $q \leq 25$: **100 unikátních spekter**, 22 skupin sdílí spektrum.

**Příklady sdílení:**

| Spektrum | Zlomky | Vzorec |
|----------|--------|--------|
| $\{2\}$ | 1/2, 2/3, 3/4, 4/5, ... | $n/(n+1)$ |
| $\{3/2\}$ | 1/3, 2/5, 3/7, 4/9, ... | $k/(2k+1)$ |
| $\{2, 5/3\}$ | 3/5, 5/8, 7/11, 9/14, 11/17, ... | $(2k+1)/(3k+2)$ |
| $\{2, 7/4\}$ | 5/7, 8/11, 11/15, ... | $(3k+2)/(4k+3)$ |

**Důvod:** Spektrum kóduje pouze **CF prefix** — pozici ve Stern-Brocotově stromu. Poslední CF kvocient (hloubka podél větve) se ztrácí.

### ✅ Pozorování 4: Plné tuply {u,v,i,j} JSOU unikátní invariant (PROVEN)

Na rozdíl od spektra, plná sada tuplů z `EgyptianFractions[q, Method->"Raw"]` je unikátní: **0 kolizí** mezi 199 testovanými zlomky. Indexy $i, j$ nesou chybějící informaci o posledním CF kvocientu.

**Upgrade (2026-06-11): empirie → věta.** Bijection Inverse corollary v
`docs/papers/egyptian-fractions-telescoping.tex` rekonstruuje všechny CF
koeficienty z tuplů ($a_1 = v_1/u_1$, $a_{2k} = j_k$,
$a_{2k+1} = (v_{k+1} - v_k)/u_{k+1}$), takže dva různé racionály nemohou
sdílet sadu tuplů — kolize jsou vyloučeny dokazatelně, ne jen empiricky.
Pozn.: unikátnost platí pro *kanonickou* sadu tuplů z algoritmu; jako volný
formát je reprezentace silně neunikátní (1/6 má šest single-tuple realizací,
viz `verify-tv-identity.wl`).

### Pozorování 5: Spektrální rodiny jsou akce $\text{SL}_2(\mathbb{Z})$

Každá skupina zlomků sdílejících spektrum tvoří aritmetickou posloupnost $(ak+b)/(ck+d)$ s:

$$\det \begin{pmatrix} a & b \\ c & d \end{pmatrix} = 1$$

| Spektrum | Matice | det |
|----------|--------|-----|
| $\{2\}$ | $\begin{pmatrix}1&0\\1&1\end{pmatrix}$ | 1 |
| $\{3/2\}$ | $\begin{pmatrix}1&0\\2&1\end{pmatrix}$ | 1 |
| $\{2, 5/3\}$ | $\begin{pmatrix}2&1\\3&2\end{pmatrix}$ | 1 |
| $\{2, 7/4\}$ | $\begin{pmatrix}3&2\\4&3\end{pmatrix}$ | 1 |
| $\{2, 7/5\}$ | $\begin{pmatrix}3&1\\5&2\end{pmatrix}$ | 1 |
| $\{3/2, 8/5\}$ | $\begin{pmatrix}2&1\\5&3\end{pmatrix}$ | 1 |

Všechny matice leží v $\text{SL}_2(\mathbb{Z})$ — modulární grupě. To odpovídá navigaci ve Stern-Brocotově stromu, kde každá hrana odpovídá akci $T = \begin{pmatrix}1&1\\0&1\end{pmatrix}$ nebo $S = \begin{pmatrix}1&0\\1&1\end{pmatrix}$.

### Pozorování 6: Ztráta a zachování informace

Přechod od tuples k tail power sum **ztrácí**:
- Absolutní velikost $n = uv$ (zachován jen poměr u/v)
- Index splitu $m$ (sčítáme přes všechna m)
- Poslední CF kvocient (proto spektrum není invariant)

Přechod **zachovává**:
- Poměr u/v (zakódován v Hurwitzově parametru)
- CF prefix (pozice ve Stern-Brocotově stromu)
- $\text{SL}_2(\mathbb{Z})$ matici rodiny

---

## Dualita: Tail → Polygamma, Truncated → Digamma

### Setup

Identita $\text{trunc}_m + \text{tail}_m = 1/(uv)$ pro každé $m$ implikuje dualitu na úrovni řad:

$$\sum_m \frac{\text{trunc}_m}{m^s} + \sum_m \frac{\text{tail}_m}{m^s} = \frac{\zeta(s)}{uv}$$

### ✅ Tail power sum (dokázáno výše)

$$\sum_{m=1}^{\infty} \text{tail}_m^s = \frac{\zeta(s, 1+u/v)}{v^{2s}} = \frac{(-1)^s}{(s-1)!} \cdot \frac{\psi^{(s-1)}(1+u/v)}{v^{2s}}$$

Speciální funkce: **polygamma** (derivace $\psi$).

### ✅ Truncated Dirichlet sum (s=2)

$$\sum_{m=1}^{\infty} \frac{\text{trunc}_m}{m^2} = \frac{\psi(1+u/v) + \gamma}{u^2}$$

kde $\gamma \approx 0.5772$ je Euler-Mascheroniho konstanta.

**Důkaz:** Partial fractions dávají

$$\frac{\text{trunc}_m}{m^2} = \frac{1}{u^2}\left(\frac{1}{m} - \frac{1}{u/v+m}\right)$$

a $\sum_{m=1}^{\infty}(1/m - 1/(u/v+m)) = \psi(1+u/v) + \gamma$ z definice digamma. $\square$

Speciální funkce: **digamma** ($\psi$ sama) + Euler $\gamma$.

### Dualita

| | Tail | Truncated |
|---|---|---|
| Suma | $\sum \text{tail}_m^s$ | $\sum \text{trunc}_m / m^s$ |
| s=2 | $\psi'(1+u/v) / v^4$ | $[\psi(1+u/v)+\gamma] / u^2$ |
| Speciální fce | $\psi', \psi'', \psi'''$ | $\psi + \gamma$ |
| Spojení | $D_\text{trunc} + D_\text{tail} = \zeta(s)/n$ | |

Konstanta $\gamma$ se objevuje přirozeně jako regularizační člen párující divergentní harmonickou řadu s divergentním tail součtem.

Numericky ověřeno pro $(u,v) \in \{(2,3), (3,5), (7,11), (1,6), (5,7)\}$.

---

## Primoriální Struktura

### Fenomén

Jmenovatele $(n + v^2 m)^s$ mají konzistentně ~80-85% prvočíselných faktorů z $p_5\# = \{2,3,5,7,11\}$.

### Invariance pod s

Primoriální pokrytí je **přesně invariantní** pod změnou s:
$(n+v^2 m)^s$ má tytéž prvočíselné faktory jako $(n+v^2 m)$ — exponent s jen násobí exponenty.

| s | Status | Pokrytí |
|---|--------|---------|
| 1 | diverguje | 79.1% |
| 2 | ✅ konverguje | 79.1% |
| 3 | ✅ konverguje | 79.1% |

### Multiplicita vs. m (n=77, u=7, v=11)

Prvočísla z jádra {2,3,5,7,11} rostou lineárně s m:

| p | Rate/m | Debut |
|---|--------|-------|
| 2 | +2.0 | m=1 |
| 3 | +0.9 | m=1 |
| 5 | +0.5 | m=1 |
| 7 | +0.35 | m=1 |
| 11 | +1.1 | m=1 |
| p>11 | ~0.1 | m~10+ |

### Pokrytí napříč n

| n | Pokrytí p₅# |
|---|-------------|
| 6 | 88.0% |
| 30 | 84.1% |
| 77 | 84.6% |
| 210 | 81.9% |

Konzistentně ~85% bez ohledu na n.

---

## Částečné Součty (Partial Tail Sums)

Pro split v bodě N:

$$T_N(s) = \sum_{m=N+1}^{\infty} (\text{tail}_m)^s = \frac{1}{v^{2s}} \left[\zeta(s, 1+u/v) - \sum_{k=1}^{N} \frac{1}{(u/v+k)^s}\right]$$

Toto kombinuje closed form (Zeta) s konečnou korekcí. Ověřeno numericky pro s=2,3,4,5 (chyba < $10^{-10}$ pro s≥3).

Praktický důsledek: **analytický výpočet zbytku** po libovolném truncation bez nekonečné sumace.

---

## Rekurzivní Split a Splitf

### splitf: Základní operace

Pro $n = uv$:

$$\text{splitf}[\{u,v\}, m]: \quad \frac{1}{uv} = \underbrace{\frac{m}{u(u+mv)}}_{\text{head}} + \underbrace{\frac{1}{v(u+mv)}}_{\text{tail}}$$

Head je truncated telescoping sum ($m$ termů), tail je unit fraction. Tedy **splitf s parametrem $m$ rozloží $1/(uv)$ na přesně $m+1$ unit fractions**.

Pro $m = 1$:

$$\frac{1}{uv} = \frac{1}{u(u+v)} + \frac{1}{v(u+v)} = \frac{1}{u+v}\left(\frac{1}{u} + \frac{1}{v}\right)$$

### Rekurzivní split (m=1 na každé úrovni)

Opakované splitf s $m=1$ generuje chain:
- Level $k$: parametry $\{u, v_k\}$ kde $v_k = uk + v$ (lineární)
- Tail na level $k$: denom $= v_k \cdot v_{k+1}$ (rostoucí $\Rightarrow$ unikátní)
- Head na poslední úrovni: denom $= u \cdot v_d$

**Unikátnost jmenovatelů:** Garantována pokud $u \nmid v$ (typický případ z CF). Pokud $u \mid v$, kolize na hloubce $d = (k + v/u)^2 + k$.

### Splitf pro racionální $p/q$ (p > 1)

Pro $p/q$ s $\gcd(p,q) = 1$, splitf$[\{1/p, q\}, m]$:
- head $= mp^2/(1 + mpq)$
- tail $= p/(q(1 + mpq))$

**Tail má čitatel $p$ vždy** (protože $1 + mpq \equiv 1 \pmod{p}$). Splitf sám tedy nestačí pro Egyptian fraction rozklad rationals s $p > 1$ — tail vyžaduje další zpracování.

### Ekvivalence split ↔ faktorizace

Každý dvousložkový rozklad $1/n = 1/x + 1/y$ splňuje:

$$(x - n)(y - n) = n^2$$

Netriviální split vyžaduje netriviální faktorizaci $n^2$, tedy faktorizaci $n$. Faktorizace je **nezbytný vstup** do splitf.

---

## ζ jako Optimalizační Kritérium

### Otázka

Pro danou unit fraction $1/n$: která faktorizace $n = uv$ dá "nejlepší" rozklad?

### ζ perfektně řadí faktorizace

Pro semiprimes $n \leq 500$: **Spearman rank korelace** mezi $\zeta(2, 1+u/v)$ a $\text{max\_denom}/n$ je **přesně 1.0**.

Obě metriky závisí monotónně na poměru $v/u$:

$$\text{max\_denom}/n = 1 + v/u \qquad \text{(lineární)}$$
$$\zeta(2, 1+u/v) \approx (v/u)^2 + \text{const} \qquad \text{(kvadratická, citlivější)}$$

Optimum: **balanced faktorizace** $u \approx v \approx \sqrt{n}$, kde $\zeta(2, 2) = \pi^2/6 - 1 \approx 0.645$.

### Greedy-head ζ-guided rekurze

Algoritmus: na každé úrovni vyber **nejbalancovanější faktorizaci** (minimální ζ), split $m=1$, rekurze na head.

Výsledky pro $1/n$ (depth=3, 4 termy):

| $n$ | max\_denom | triviální max | zlepšení |
|-----|-----------|---------------|----------|
| 77 | 736 | 6006 | 8× |
| 210 | 2451 | 44310 | 18× |
| 2310 | 25159 | 5338410 | 212× |

### Degradace ζ podél rekurze

Head denom $u(u+v)$ má omezenou faktorizovatelnost — $u$ je vždy malý faktor. Důsledek: **ζ se zhoršuje** s hloubkou:

```
1/2310: 2310 = 42×55  ζ=0.76 (balanced)
        4074 = 42×97  ζ=0.99 (horší)
        5838 = 42×139 ζ=1.13 (ještě horší)
```

Toto je **inherentní omezení**, ne chyba algoritmu.

### Greedy-head vs BFS

BFS strategie (vždy split největší frakci) dává **horší** výsledky:

| $n$ | Greedy max | BFS-4 max |
|-----|-----------|-----------|
| 77 | **736** | 1363 |
| 210 | **2451** | 3212 |
| 2310 | **25159** | 37848 |

ζ-score (suma ζ přes jmenovatele): greedy-head ~3.2 vs BFS ~3.7. Greedy-head je lepší protože operuje na jedné větvi a drží taily malé.

### Aplikace na p/q (hybrid CF + ζ)

Hybridní přístup (CF dá Raw tuples → splitf na každý teleskopický člen) **neporáží** CF-based Orbit:

| $q$ | Orbit terms/max | Hybrid d=2 terms/max |
|-----|-----------------|---------------------|
| 4/17 | 4 / 221 | 10 / 1066 |
| 5/13 | 3 / 104 | 7 / 364 |
| 7/19 | 3 / 209 | 7 / 814 |

CF-based rozklad je pro racionály s $p > 1$ efektivnější — další splitování teleskopických členů přidává termy bez snížení max jmenovatele.

### Erdős–Straus

Pro $4/n$: naše metody dávají 4 termy kde CF dává 4. Redukce na 3 termy vyžaduje **slučování** členů (ne štěpení) — závislé na specifických dělitelnostních podmínkách, ne na ζ.

### Shrnutí

| Vlastnost | ζ jako kritérium |
|-----------|-----------------|
| Ranking faktorizací | ✅ perfektní (Spearman=1) |
| Greedy selection | ✅ lepší než BFS |
| Unit fractions 1/n | ✅ 8-212× zlepšení max\_denom |
| Racionály p/q (p>1) | ❌ neporáží CF/Orbit |
| Erdős–Straus | ❌ neredukuje #termů |
| Analytický bound | 🤔 otevřené (ψ' asymptotika) |

**ζ je dobrý heuristický nástroj pro konstrukci rozkladů unit fractions, ale není silver bullet pro otevřené problémy.** Přidaná hodnota je spíš analytická (asymptotické odhady přes ψ') než algoritmická.

---

## Egyptian Fraction Tree (EFT): Rekurzivní Closed Form

### Splitf identita pro p/q

$$\frac{p}{q} = \frac{p^2}{1+pq} + \frac{p}{q(1+pq)}$$

Head má čitatel $p^2$, tail čitatel $p$. Oba nesoudělné s denominátorem ($1+pq \equiv 1 \bmod p$).

### Partial fraction split

Pro $c/n$ s $n = ab$, $\gcd(a,b) = 1$: Bezoutova identita dává $A, B$ s $c = Ab + Ba$, takže:

$$\frac{c}{ab} = \frac{A}{a} + \frac{B}{b}$$

**Problém:** XGCD může dát záporné koeficienty. Pozitivní rozklad je garantován jen za speciálních podmínek.

### Faktorizační certifikát Σ

**Definice:** Pro $c/n$ je *faktorizační certifikát* $\Sigma$ strom:

$$\Sigma = \{n \mapsto (a_n, b_n)\} \cup \Sigma_\text{left}(A, a_n) \cup \Sigma_\text{right}(B, b_n)$$

kde $a_n \cdot b_n = n$, $\gcd(a_n, b_n) = 1$, a $A, B$ jsou XGCD koeficienty.

**EFT algoritmus** (daný $\Sigma$):
1. $c = 1$: výstup $1/n$ (list — unit fraction)
2. $n$ prime: výstup $\text{CF}(c/n)$ (polynomiální, bez faktorizace)
3. Jinak: $\Sigma(n) = (a,b)$, XGCD dá $A, B$, rekurze na $A/a$ a $B/b$

**Vlastnosti:**
- Hloubka: $O(\log n)$ (denominátory klesají na každé úrovni)
- Každý krok: explicitní algebra (XGCD), žádné hledání
- $|\Sigma| = O(\log n)$ uzlů
- Bez $\Sigma$: potřeba faktorizovat $\Rightarrow$ ekvivalentní obtížnost
- **Různá $\Sigma$ dávají různé rozklady** — certifikát je "klíč" vybírající konkrétní dekompozici

### Čistý případ: $a + b = p^2$

Pokud $1 + pq = ab$ s $a + b = p^2$: koeficienty $A = B = 1$ (oba kladné!):

$$\frac{p}{q} = \frac{1}{a} + \frac{1}{b} + \frac{p}{q(1+pq)}$$

Podmínka $a + b = p^2$ s $ab = 1+pq$ $\Leftrightarrow$ diskriminant $p^4 - 4(1+pq)$ je úplný čtverec.

Příklady pro $p = 5$:

| $q$ | $1+5q = ab$ | $a+b$ | Rozklad |
|-----|-------------|-------|---------|
| 9 | 46 = 2·23 | 25 = 5² | $\frac{1}{2} + \frac{1}{23} + \frac{5}{414}$ |
| 13 | 66 = 3·22 | 25 = 5² | $\frac{1}{3} + \frac{1}{22} + \frac{5}{858}$ |
| 27 | 136 = 8·17 | 25 = 5² | $\frac{1}{8} + \frac{1}{17} + \frac{5}{3672}$ |
| 31 | 156 = 12·13 | 25 = 5² | $\frac{1}{12} + \frac{1}{13} + \frac{5}{4836}$ |

Zbývající člen $p/(q \cdot N)$ má menší jmenovatel a **stejný čitatel $p$** — rekurzivně aplikovatelné.

### Srovnání s CF/Orbit

| Vlastnost | CF/Orbit | EFT($\Sigma$) |
|-----------|----------|---------------|
| Vstup | jen $p/q$ | $p/q$ + certifikát $\Sigma$ |
| Složitost | $O(\log^2 n)$ | $O(\log n)$ per level × $O(\log n)$ levels |
| Faktorizace | nepotřebuje | vyžaduje (je v $\Sigma$) |
| Determinismus | jeden výstup | parametrizováno volbou $\Sigma$ |
| Záporné termy | nikdy | možné (v obecném XGCD) |
| Speciální případ $a+b=p^2$ | — | čistý 2-UF + tail |

**⚠️ EFT rekurze na tail neterminuje:** Tail $p/(qN)$ má stále čitatel $p$ a rostoucí jmenovatel. Opakovaná aplikace dává konvergentní nekonečnou řadu, ne konečný rozklad. Pro konečný výsledek je nutný fallback na CF/Orbit.

---

## Induktivní Closed Form (bez faktorizace)

### Princip

Greedy krok na $p/N$: $k = \lceil N/p \rceil$, remainder $r = pk - N < p$.

$$\frac{p}{N} = \frac{1}{k} + \frac{r}{Nk}$$

Remainder $r < p$ → induktivně použij vzorec pro $r/M$. Báze: $r = 0$ (hotovo) nebo $r = 1$ (unit fraction).

**Nevyžaduje faktorizaci.** Max počet termů = $p$.

### p = 2: Closed Form (2 termy)

Pro liché $N$ (= $2m+1$):

$$\frac{2}{2m+1} = \frac{1}{m+1} + \frac{1}{(2m+1)(m+1)}$$

Greedy remainder je **vždy 1** protože $2 \lceil N/2 \rceil - N = 1$ pro liché $N$.

### p = 3: Closed Form (2–3 termy, 4 případy)

**Případ 1** ($3 \mid N$): $\frac{3}{N} = \frac{1}{N/3}$

**Případ 2** ($N \equiv 2 \bmod 3$): remainder 1
$$\frac{3}{N} = \frac{1}{(N+1)/3} + \frac{1}{N(N+1)/3}$$

**Případ 3** ($N \equiv 1 \bmod 3$, $N$ sudé): remainder 2, ale $M$ sudé → $2/M = 1/(M/2)$
$$\frac{3}{N} = \frac{1}{(N+2)/3} + \frac{1}{N(N+2)/6}$$

**Případ 4** ($N \equiv 1 \bmod 3$, $N$ liché, tj. $N = 6m+1$): remainder 2, $M$ liché → aplikuj p=2 vzorec

$$\frac{3}{6m+1} = \frac{1}{2m+1} + \frac{1}{6m^2+4m+1} + \frac{1}{(6m+1)(2m+1)(6m^2+4m+1)}$$

Celočíselnost: $N^2+2N+3 = 6(6m^2+4m+1)$, tedy $B$ je celé. $C = (6m+1)(2m+1)(6m^2+4m+1)$ je součin celých čísel.

Ověřeno pro všechna $N \leq 50$ s $\gcd(3, N) = 1$.

### p = 4: Náčrt (2–4 termy)

Greedy remainder $\in \{0, 1, 2, 3\}$. Remainder 3 → aplikuj p=3 vzorec.

Nejhorší případ závisí na $N \bmod 12$:
- $N \equiv 9 \bmod 12$: $M \equiv 0 \bmod 3$ → $3/M$ je 1 term → celkem **2 termy**
- $N \equiv 1 \bmod 12$, $N$ sudé: $3/M$ je 2 termy → celkem **3 termy**
- $N \equiv 1 \bmod 12$, $N$ liché: $3/M$ je 3 termy → celkem **4 termy**

### Obecný vzorec: max $p$ termů

| $p$ | Max termů | Worst case |
|-----|-----------|------------|
| 1 | 1 | 1/N |
| 2 | 2 | 2/(2m+1) |
| 3 | 3 | 3/(6m+1) |
| 4 | 4 | 4/17 |
| $p$ | $p$ | závisí na $N \bmod \text{lcm}(1,\ldots,p)$ |

### Srovnání s Orbit

Induktivní metoda:
- ✅ Explicitní vzorec (žádné hledání, žádná faktorizace)
- ✅ Stejný nebo menší počet termů v některých případech (4/77: 3 vs 4)
- ❌ Doubly-exponenciální jmenovatele (4/17: max 3 039 345 vs Orbit 221)
- ❌ Case analysis se rozrůstá s $p$ ($N \bmod \text{lcm}$ roste)

### Otevřená otázka: Unifikace

Větvení podle $N \bmod p^2$ (a parity) je algebraicky přirozené ale nepěkné. Existuje **jeden vzorec** (bez case split) zahrnující všechny případy? Kandidáti:
- Floor/ceiling funkce absorbující modular conditions
- Generatingfunctionologie (formální mocninné řady)
- Reprezentace přes $\lfloor \cdot \rfloor$ a Iversonovy závorky

---

## Best-k: Hybrid faktorizace + indukce

### Motivace

Dva extrémy:
- **Induktivní (greedy)**: closed form, žádná faktorizace, ale doubly-exponenciální jmenovatele
- **EFT (s faktorizací)**: malé jmenovatele, ale záporné XGCD koeficienty a neterminující tail

**Best-k** kombinuje obě výhody: volí $k$ v greedy kroku **s ohledem na faktorizaci** $N$.

### Princip

Pro $p/N$ standardní greedy zvolí $k = \lceil N/p \rceil$. Ale $k$ může být **libovolné** $k \geq \lceil N/p \rceil$:

$$\frac{p}{N} = \frac{1}{k} + \frac{pk - N}{Nk}$$

Remainder $r = pk - N$. Po zkrácení: $\frac{r}{\gcd(r, Nk)} \Big/ \frac{Nk}{\gcd(r, Nk)}$.

**Klíč:** Pokud $k$ sdílí faktor $d$ s $N$, pak $\gcd(r, Nk) \geq d$, a remainder se výrazně zjednoduší.

### Strategie: $k$ sdílející faktor s $N$

Pro $N = d \cdot e$ (známá faktorizace):

1. Zvol $k = \lceil N/(pd) \rceil \cdot d$ — nejmenší násobek $d$ splňující $k \geq \lceil N/p \rceil$
2. Remainder $r = pk - N$ je dělitelný $\gcd(pk, N) = d \cdot \gcd(p \lceil N/(pd) \rceil, e)$
3. Fraction $r/(Nk)$ se zkrátí velkým gcd → malý jmenovatel

**Ideální případ:** Když $r \mid Nk$ (remainder je dělitel), dostaneme **unit fraction rovnou**:

$$\frac{p}{N} = \frac{1}{k} + \frac{1}{Nk/r}$$

Dva termy, konec. Closed form se znalostí faktorizace.

### Příklady

| $p/N$ | Best $k$ | Sdílený faktor | Rozklad | vs Greedy | vs Orbit |
|-------|----------|---------------|---------|-----------|----------|
| 4/77 | 22 = 2·**11** | 11 (z 77=7·11) | $\frac{1}{22} + \frac{1}{154}$ | 2t vs 3t | 2t vs 4t |
| 4/49 | 14 = 2·**7** | 7 (z 49=7²) | $\frac{1}{14} + \frac{1}{98}$ | 2t vs 4t | 2t vs 4t |
| 8/77 | 11 | 11 | $\frac{1}{11} + \frac{1}{77}$ | 2t vs 3t | 2t vs 3t |
| 8/49 | 7 | 7 | $\frac{1}{7} + \frac{1}{49}$ | 2t vs 2t | 2t vs 8t |
| 7/23 | 5 | — | $\frac{1}{5} + \frac{1}{10} + \frac{1}{230}$ | 3t vs 4t | 3t vs 4t |
| 5/31 | 8 | — | $\frac{1}{8} + \frac{1}{28} + \frac{1}{1736}$ | 3t vs 5t | 3t vs 5t |

### Detailní příklad: 4/77

$N = 77 = 7 \times 11$. Dělitelé: $\{1, 7, 11, 77\}$.

Kandidáti pro $k$ ($k \geq \lceil 77/4 \rceil = 20$):
- $d = 7$: $k = 21$. $r = 84 - 77 = 7$. $\gcd(7, 77 \cdot 21) = 7$. Remainder: $1/231$.
  → $4/77 = 1/21 + 1/231$ ✓
- $d = 11$: $k = 22$. $r = 88 - 77 = 11$. $\gcd(11, 77 \cdot 22) = 77$. Remainder: $1/154$.
  → $4/77 = 1/22 + 1/154$ ✓ **(nejmenší max denom)**
- $d = 77$: $k = 77$. $r = 231$. Remainder: $3/77$ → potřeba dalšího rozkladu.

Optimum: $k = 22$ (dělitel $d = 11$), max denom = 154.

### Kdy best-k dá 2 termy (unit fraction remainder)?

Podmínka: $r \mid Nk$, kde $r = pk - N$.

Pro $k = \lceil N/(pd) \rceil \cdot d$ s $d \mid N$:
- $r = p \cdot \lceil N/(pd) \rceil \cdot d - N$
- Pokud $\lceil N/(pd) \rceil = N/(pd)$ (tj. $pd \mid N$): $r = 0$, triviální
- Obecně: $r = d \cdot (p \lceil N/(pd) \rceil - N/d)$, a podmínka $r \mid Nk$ závisí na aritmetice

Pro **semiprimes** $N = ab$ s $a < b$: volba $k = \lceil N/(pa) \rceil \cdot a$ často dává $r = a$ nebo malý násobek $a$, a $\gcd(r, Nk) = a \cdot \gcd(\ldots)$.

### Obecný algoritmus (rekurzivní)

```
BestKEgypt[p, N, factorization of N]:
  1. Pro každý dělitel d | N:
     - k_d = ⌈N/(pd)⌉ · d
     - r_d = p·k_d - N
     - simplify r_d/(N·k_d) via gcd
  2. Vyber d minimalizující max denom rekurzivního rozkladu
  3. p/N = 1/k_d + BestKEgypt[simplified remainder]
```

**Terminace:** Remainder $r/M$ má $r < pk$ a $M < Nk$, ale po gcd zkrácení je typicky $r' \ll p$. Pokud $r' < p$: indukce na čitateli (jako greedy). Pokud $r' \geq p$: rekurze s menší frakcí.

V praxi terminuje rychle (2–4 kroky) pro testované případy.

### Srovnání se všemi metodami

| Metoda | Faktorizace? | #termů | Max denom | Closed form? |
|--------|-------------|--------|-----------|--------------|
| Greedy/induktivní | ne | $\leq p$ | doubly-exp | ano (case split) |
| CF/Orbit | ne | variabilní | malé | ano (z CF) |
| EFT (certifikát Σ) | ano | variabilní | malé | ano (ale ± koef.) |
| **Best-k** | **ano** | **≤ p, často 2–3** | **malé** | **ano** |

Best-k je **první metoda** která:
- Má **closed form** (explicitní výběr $k$ z dělitelů $N$)
- Produkuje **malé jmenovatele** (srovnatelné s Orbit nebo lepší)
- Má **málo termů** (často 2–3, poráží Orbit i greedy)
- **Terminuje** (remainder klesá, fallback na indukci)

### Pro prvočíselné N: "odečti 1/N" trik

Pro prime $N$ nemá best-k netriviální dělitele, ale zkouší **tři strategie**:

1. $k = \lceil N/p \rceil$ (greedy): remainder $< p$
2. $k = N$ **(odečti $1/N$)**: $p/N = 1/N + (p{-}1)/N$, pak Orbit na $(p{-}1)/N$
3. $k = 2N$: $p/N = 1/(2N) + (2p{-}1)/(2N)$, pak Orbit

Krok 2 je klíčový: $\text{CF}((p{-}1)/N)$ je **jiný rozklad** než $\text{CF}(p/N)$, a někdy výrazně lepší.

**Příklad:** $4/17$:
- $\text{CF}(4/17) = \{0, 4, 4\}$ → 1 tuple, $j{=}4$ → **4 termy**, max=221
- $1/17 + \text{CF}(3/17)$: $\text{CF}(3/17) = \{0, 5, 1, 2\}$ → 2 tuples → **3 termy**, max=102

CF interpretace: odečtení $1/N$ změní první kvocient z $a_1 = \lfloor N/p \rfloor$ na $a_1' = \lfloor N/(p{-}1) \rfloor \geq a_1$. Zbytek CF se přestrukturuje — jedna dlouhá tuple se může rozpadnout na několik krátkých.

**Statistika** (všechna $p/N$ s prime $N \leq 100$):
- $1/N + \text{Orbit}(p{-}1)$ wins: 444 (45%)
- $\text{Orbit}(p)$ wins: 536 (55%)

Délka CF **nekoreluje** s výhrou hybridu (win rate ~42% pro kratší i delší CF). Rozhoduje jemná struktura kvocientů, ne jen jejich počet.

**Výsledek:** Hybrid $\min(\text{Orbit}(p/N),\; 1/N + \text{Orbit}((p{-}1)/N))$ je striktně $\geq$ Orbit sám.

### Celkové skóre best-k prototypu

| N typ | Best-k wins | Orbit wins | Tie |
|-------|------------|------------|-----|
| Kompozitní ($N \leq 385$) | **88%** | 5% | 7% |
| Prvočíselné ($N \leq 100$) | **50%** | 29% | 21% |

### Bicriterion CRT: Principiální výběr kandidátů

**Problém:** Jak vybrat optimální $k$ bez arbitrary limitů?

**Pozorování:** Nejlepší $k$ maximalizuje **oba** $\gcd(k, N)$ a $\gcd(p{-}k, N)$ současně. Pro $\gcd(p, N) = 1$ a každý prime power $p_i^{a_i} \| N$: přiřadíme ho buď straně $k$ ($k \equiv 0 \bmod{p_i^{a_i}}$) nebo straně $p{-}k$ ($k \equiv p \bmod{p_i^{a_i}}$). Přiřazení jsou **nezávislá** — CRT složí volby do jednoho $k$.

**Algoritmus:**
1. Faktorizuj $N = \prod_{i=1}^{m} p_i^{a_i}$
2. Pro každou podmnožinu $S \subseteq \{p_1^{a_1}, \ldots, p_m^{a_m}\}$:
   - $k \equiv 0 \pmod{\prod_{i \in S} p_i^{a_i}}$ a $k \equiv p \pmod{\prod_{i \notin S} p_i^{a_i}}$
   - Řeš CRT → $k_S$
   - Testuj $p/N = k_S/N + (p{-}k_S)/N$
3. Vyber nejlepší (plus $k=1$ jako baseline)

**Prostor: $2^{\omega(N)}$ kandidátů**, kde $\omega(N)$ = počet distinktních prvočíselných faktorů.

**Klíčová vlastnost:** $\gcd(k_S, N) \cdot \gcd(p{-}k_S, N) = N$ pro každé přiřazení (každý faktor jde přesně na jednu stranu). Symetrie: $k$ a $p{-}k$ dávají prohozené strany → stačí $2^{\omega(N)-1}$ testů.

**Příklad:** $2023/2024$, $N = 2^3 \cdot 11 \cdot 23$, $\omega = 3$ → 6 CRT kandidátů:

| $k$ | $\gcd(k, N)$ | $\gcd(p{-}k, N)$ | Rozklad | #t/max |
|-----|-------------|-----------------|---------|--------|
| 736 | 184 = 2³·23 | 11 | 4/11 + 117/184 | **6t/92** |
| 528 | 88 = 2³·11 | 23 | 6/23 + 65/88 | 11t/5720 |
| 759 | 253 = 11·23 | 8 | 3/8 + 158/253 | 15t/1.2M |

$k = 736$: přiřazení $\{2^3, 23\} \to k$, $\{11\} \to (p{-}k)$. CRT: $k \equiv 0 \pmod{184}$, $k \equiv 2023 \pmod{11}$ → $k = 736$.

### Složitost: Hardy–Ramanujan a Erdős–Kac

$\omega(N) \sim \log \log N$ pro téměř všechna $N$ (Hardy–Ramanujan, 1917).

Erdős–Kac (1940) zpřesňuje: $\frac{\omega(N) - \log \log N}{\sqrt{\log \log N}} \xrightarrow{d} \mathcal{N}(0, 1)$

Počet CRT kandidátů: $2^{\omega(N)} \sim (\log N)^{\ln 2} \approx (\log N)^{0.693}$

| $N$ | $\log \log N$ | typické $\omega$ | $2^\omega$ |
|-----|--------------|-------------------|------------|
| $10^3$ | 1.9 | 2 | 4 |
| $10^6$ | 2.6 | 3 | 8 |
| $10^{20}$ | 3.8 | 4 | 16 |
| $10^{100}$ | 5.4 | 5 | 32 |

**Důsledek:** CRT candidate selection vyžaduje $O((\log N)^{0.7})$ volání CF/Orbit — efektivně konstantní pro jakákoli praktická $N$. Žádné arbitrary limity.

### Celková složitost best-k s CRT

Pro $p/N$ s $\gcd(p, N) = 1$:

$$O\big(2^{\omega(N)} \cdot T_{\text{Orbit}}\big) = O\big((\log N)^{0.7} \cdot \log^2 N\big)$$

kde $T_{\text{Orbit}} = O(\log^2 N)$ je cena jednoho CF rozkladu. Celkem **polynomiální v $\log N$**, nezávislé na $p$.

### Limitace

- Pro **prvočíselné** $N$: $\omega = 1$, CRT dá jen $k \equiv 0 \pmod{N}$ (= Orbit fallback) nebo $k = 1$
- Vyžaduje **faktorizaci** $N$ (ale ne úplnou — stačí znát prime power dekompozici)
- Pro prvočíselné $N$: trik $1/N + \text{Orbit}(p{-}1)$ nevyžaduje nic navíc
- CRT dává **optimální přiřazení faktorů**, ale ne nutně globálně optimální $k$ (existují $k$ mimo CRT prostor)
- **Rekurzivní BestK** (`MaxRecursion -> k`): zlepšuje max\_denom o 4–44× (MR=3 vs MR=1), ale branching $O((2^{\omega})^d)$ saturuje po 2–3 levelech
- **Target-T přístup** (otevřený): místo greedy ptej se "existuje T-termový rozklad?". Pro T=2: dělitelé $N^2$. Pro T=3: CRT kandidáty + T=2 na zbytek. Najde Pareto-lepší výsledky než BestK (4/77: max=77/3t vs 154/2t; 5/13: max=78/3t vs 104/3t)

---

## Otevřené Otázky

**Revize 2026-06-11** (gate-keeping + channel-match lenses dle CLAUDE.md):
Q2 zodpovězena standardní CF teorií, Q4 a Q9 zamítnuty (viz "Considered and
rejected" níže), Q3 zúžena na null-model test, Q5 a Q8 přežívají.

1. ~~**Hurwitzovo spektrum jako invariant?**~~ ❌ ZODPOVĚZENO: Spektrum kóduje jen CF prefix, je příliš hrubé. Plné tuply {u,v,i,j} jsou invariant.
2. ~~**$\text{SL}_2(\mathbb{Z})$ matice:** Jak přesně se matice rodiny odvozuje z CF prefixu? Je to produkt konvergentních matic?~~ ✅ ZODPOVĚZENO (2026-06-11): ano — matice rodiny je produkt konvergentních matic prefixu; její sloupce jsou poslední dva konvergenty sdíleného prefixu a det = ±1 je fundamentální CF identita. Kontrola na tabulce výše: rodina {2, 5/3} má sloupce (2,3), (1,2) = konvergenty 2/3 a 1/2 prefixu [0;1,1,1]. Standardní fakt, žádný otevřený obsah.
3. **Primoriální původ — ZÚŽENO (2026-06-11):** původní "proč ~85%?" postrádá null model. Dva mundánní mechanismy pravděpodobně vysvětlí většinu signálu: (i) náhodné celé číslo velikosti ~10³–10⁴ má ~60–70 % prvočíselných faktorů (s multiplicitou) v {2,3,5,7,11}, protože očekávaná multiplicita prvočísla $p$ je $1/(p-1)$; (ii) pro $p \mid v$ je **každý** člen $n + v^2 m$ dělitelný $p$ — pro n=77, v=11 nese každý jmenovatel vynucený faktor 11, což je přesně zvýšený rate +1.1/m v tabulce výše. 🤔 PRE-REGISTROVANÁ PREDIKCE: null model (náhodná čísla stejné velikosti + vynucené v-faktory) reprodukuje pozorovaných 79–85 %. Pokud ano → artefakt konstrukce vzorku, otázka se zavírá; jen reziduum nad null modelem by ospravedlnilo původní B-smooth hustotní otázku.
4. ~~**Eulerův produkt:** Jak se $\zeta(s) = \prod_p (1-p^{-s})^{-1}$ projevuje v tail power sums pro obecné {u,v}?~~ ❌ ZAMÍTNUTO (2026-06-11): channel mismatch — viz "Considered and rejected" níže.
5. **Analytický bound přes ψ':** Lze odhadnout optimální max\_denom pro $1/n$ jako funkci faktorizovatelnosti (smoothness) $n$? *(Gate-check 2026-06-11: prošlo — kanál sedí, ψ' ranking už má Spearman=1 a asymptotický bound je jeho přirozené pokračování. Nízká priorita.)*
6. ~~**EFT záporné koeficienty.**~~ Obejito best-k přístupem (greedy základ, volba $k$ z dělitelů).
7. ~~**Best-k optimální volba $d$.**~~ ✅ VYŘEŠENO: CRT přes $2^{\omega(N)}$ podmnožin prime powers $N$. Principiální, žádné arbitrary limity.
8. **Implementace v Orbit:** Prototyp `Method -> "BestK"` hotov (Strategy 1 + divisor candidates). CRT selection je čistší — nahradit? *(2026-06-11: payoff pro velké vstupy patří do sesterského Rust balíčku `../egypt`; Orbit zůstává prototypovací plochou.)*
9. ~~**Unifikace case analysis:** Existuje jeden vzorec (bez mod-větvení) pro induktivní closed form?~~ ❌ ZAMÍTNUTO (2026-06-11): kosmetické — viz "Considered and rejected" níže.

### Considered and rejected (2026-06-11)

- **Eulerův produkt v tail power sums** (ex-Q4): channel mismatch by
  construction. Hurwitzova $\zeta(s, a)$ je postavena z aditivních posunů a
  její koeficienty nejsou multiplikativní — Euler produkt pro obecné $a$
  neexistuje. Pro racionální $a = 1 + u/v$ se $\zeta(s, a)$ rozkládá do
  Dirichletových L-funkcí a Euler produkty nesou jen tyto komponenty. Stejný
  verdikt jako L_M(s) cheatsheet review (2026-05-01): non-multiplicative ⟹
  žádná Riemannova mašinerie.
- **Unifikace case analysis** (ex-Q9): dimension-relevance check —
  floor/Iverson zápis by mod-větvení jen překódoval, ne odstranil; kosmetické,
  dokud case-free vzorec neodemkne jinak blokovaný důkaz. Jediný kandidát na
  payoff (max #termů ≤ p) je už dokázán indukcí. Oživitelné, objeví-li se
  konkrétní použití.

---

## Soubory

- `verify-trigamma.wl` — Numerické ověření PolyGamma closed form
- `tail_inversion_formula.wl` — Demo: analytický výpočet partial tail sums přes Zetu

## Reference

- Parent session: [Egyptian Fractions: Telescoping Revisited](./README.md)
- Pell regulator families: [Pell Regulator Session](../2026-03-30-pell-regulator-families/README.md)
- Prime interference moire: [Prime Interference Session](../2026-02-19-prime-interference-moire/algebraic-exploitation.md)
