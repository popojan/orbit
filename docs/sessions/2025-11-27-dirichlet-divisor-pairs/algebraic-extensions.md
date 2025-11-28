# Algebraická rozšíření — cesta k fermionové algebře?

**Datum:** 2025-11-27
**Status:** ❌ FALSIFIED — rozšíření okruhu samo o sobě problém neřeší

---

## Shrnutí výsledků

**Testováno:** $\mathbb{Z}[i]$ pro $n = 5 = (2+i)(2-i)$

**Výsledek:** Degenerace **PŘETRVÁVÁ** i v $\mathbb{Z}[i]$

```
V_5^- má bázi: e1 = {1, 5}, e2 = {2+i, 2-i}
V_{2-i}^- má bázi: f1 = {1, 2-i}

Anihilace a_{2+i}: V_5 → V_{2-i}
  e1 = {1, 5}     → f1  (protože 5/(2+i) = 2-i)
  e2 = {2+i, 2-i} → f1  (protože (2+i)/(2+i) = 1)

Matice a_{2+i} = (1, 1)
Vlastní hodnoty a†a = {0, 2} ≠ {1, 1}
```

**Příčina:** Pár $\{2+i, 2-i\}$ **sdílí faktor** $(2+i)$ s prvkem $5 = (2+i)(2-i)$.

**Závěr:** Problém je **strukturální** — není v tom které prvočíslo se štěpí, ale v samotné definici párů.

---

## Motivace (původní)

Fermionová antikomutace $\{a_p, a_p^\dagger\} = I$ selhává v $\mathbb{Z}$ kvůli **degeneraci anihilace**:

```
V Z, pro n=6, p=2:
  a_2: {1, 6} → {1, 3}
  a_2: {2, 3} → {1, 3}   ← KOLIZE (oba páry na stejný)
```

Matice $a_2^\dagger a_2$ má vlastní hodnoty $\{0, 2\}$ místo $\{1, 1\}$.

**Hypotéza:** Rozšíření na algebraická celá čísla by mohlo degeneraci odstranit.

---

## Cesta A: Gaussova celá čísla $\mathbb{Z}[i]$

### Štěpení prvočísel

V $\mathbb{Z}[i]$:
- $2 = (1+i)(1-i)$ — štěpí se
- $3$ — inertní (zůstává prvočíslem)
- $5 = (2+i)(2-i)$ — štěpí se
- Obecně: $p \equiv 1 \pmod 4$ se štěpí, $p \equiv 3 \pmod 4$ je inertní

### Zjemnění struktury dělitelů

Pro $n = 6$ v $\mathbb{Z}[i]$:

| V $\mathbb{Z}$ | V $\mathbb{Z}[i]$ |
|----------------|-------------------|
| 4 dělitelé: 1, 2, 3, 6 | 8 dělitelů: 1, 1±i, 2, 3, 3±3i, 6 |
| 2 páry: {1,6}, {2,3} | 4 páry |

### Klíčové pozorování

Anihilace se **rozštěpí** na dva operátory:

```
V Z:    a_2: {2, 3} → {1, 3}

V Z[i]: a_{1+i}: {2, 3} → {1-i, 3}
        a_{1-i}: {2, 3} → {1+i, 3}
```

**Kolize zmizela!** Páry jdou různými cestami.

### Co ověřit

1. [ ] Definovat $V_\alpha^-$ pro Gaussova celá čísla $\alpha$
2. [ ] Spočítat explicitně $a_\pi a_\pi^\dagger$ pro prvoideál $\pi$
3. [ ] Ověřit antikomutační relace $\{a_\pi, a_\pi^\dagger\} = ?$
4. [ ] Problém: pouze polovina prvočísel se štěpí (ta $\equiv 1 \pmod 4$)

### Omezení

- Prvočísla $p \equiv 3 \pmod 4$ zůstávají inertní
- Pro ně degenerace může přetrvávat
- Možná potřebujeme větší rozšíření

---

## Cesta B: Primoriální rozšíření $\mathbb{Z}[\sqrt{-p\#}]$

### Idea

Použít $\mathbb{Z}[\sqrt{-p\#}]$ kde $p\# = 2 \cdot 3 \cdot 5 \cdots p$ je primoriál.

### Štěpení v $\mathbb{Z}[\sqrt{-n}]$

Pro prvočíslo $q$ v $\mathbb{Z}[\sqrt{-n}]$:
- **Ramifikuje** pokud $q | n$ → $(q) = \mathfrak{q}^2$
- **Štěpí se** pokud $\left(\frac{-n}{q}\right) = 1$
- **Inertní** pokud $\left(\frac{-n}{q}\right) = -1$

### Pro $n = p\#$

Všechna prvočísla $q \leq p$ **dělí** $p\#$, takže **ramifikují**:

```
Z[√(-2#)] = Z[√(-2)]:     2 ramifikuje
Z[√(-3#)] = Z[√(-6)]:     2, 3 ramifikují
Z[√(-5#)] = Z[√(-30)]:    2, 3, 5 ramifikují
Z[√(-7#)] = Z[√(-210)]:   2, 3, 5, 7 ramifikují
```

### Limita $p \to \infty$

**VŠECHNA prvočísla by ramifikovala!**

Ramifikace $(q) = \mathfrak{q}^2$ znamená:
- Každé $q$ má **unikátní** prvoideál $\mathfrak{q}$
- Struktura dělitelů se **zdvojuje** (exponenty 0, 1, 2 místo 0, 1)

### Příklad: Ideálové dělitele (6) v $\mathbb{Z}[\sqrt{-6}]$

V $\mathbb{Z}$: dělitelé $(6) = (2)(3)$ jsou $\{1, 2, 3, 6\}$ — 4 kusy

V $\mathbb{Z}[\sqrt{-6}]$: $(6) = \mathfrak{p}_2^2 \mathfrak{p}_3^2$

Ideálové dělitele: $\{1, \mathfrak{p}_2, \mathfrak{p}_2^2, \mathfrak{p}_3, \mathfrak{p}_3^2, \mathfrak{p}_2\mathfrak{p}_3, \mathfrak{p}_2^2\mathfrak{p}_3, \mathfrak{p}_2\mathfrak{p}_3^2, \mathfrak{p}_2^2\mathfrak{p}_3^2\}$ — **9 kusů!**

### Formální limita

$$\mathcal{O}_\infty = \varprojlim_{p \to \infty} \mathcal{O}_{\mathbb{Q}(\sqrt{-p\#})}$$

nebo ultraprodukt:

$$\prod_{p} \mathbb{Z}[\sqrt{-p\#}] / \mathcal{U}$$

### Co ověřit

1. [ ] Jak přesně definovat projektivní limitu okruhů?
2. [ ] Existuje dobře definovaná involuce na ideálech?
3. [ ] Zmizí ALL degenerace, nebo jen některé?
4. [ ] Souvislost s adelickou konstrukcí

---

## Souvislost: Bost-Connes systém

Existující matematická struktura s podobnými vlastnostmi:

**Bost-Connes (1995):** C*-algebra s:
- Kreační operátory $\mu_n$ pro každé $n \in \mathbb{N}$
- Relace $\mu_n \mu_m = \mu_{nm}$
- Partiční funkce = $\zeta(s)$
- **Symetrie:** $\text{Gal}(\mathbb{Q}^{ab}/\mathbb{Q})$ — absolutní Galoisova grupa

### Cyklotomická věž

$$\mathbb{Q}^{ab} = \bigcup_n \mathbb{Q}(\zeta_n)$$

V této věži **všechna** prvočísla eventuálně ramifikují.

### Možná formulace našeho problému

$$\mathcal{F}_\infty = \varprojlim_{p} \bigoplus_{\mathfrak{a} \subset \mathcal{O}_p} V_\mathfrak{a}^-$$

kde Fockův prostor je limitou přes primoriální rozšíření.

---

## Srovnání cest

| Aspekt | Cesta A: $\mathbb{Z}[i]$ | Cesta B: $\mathbb{Z}[\sqrt{-p\#}]$ |
|--------|--------------------------|-----------------------------------|
| Složitost | nízká | vysoká |
| Explicitní výpočty | snadné | obtížné |
| Štěpení prvočísel | 50% (ty $\equiv 1 \pmod 4$) | 100% (v limitě) |
| Řeší degeneraci? | částečně | možná úplně |
| Souvislost s literaturou | kvadratická tělesa | Bost-Connes, adely |

---

## Doporučený postup

### Fáze 1: Proof of concept v $\mathbb{Z}[i]$

1. Implementovat $V_\alpha^-$ pro Gaussova $\alpha$
2. Spočítat $a_\pi a_\pi^\dagger$ pro malé příklady
3. Ověřit, zda degenerace skutečně mizí pro štěpící se prvočísla
4. Identifikovat zbývající problémy (inertní prvočísla)

### Fáze 2: Rozšíření na větší tělesa

1. Zkusit $\mathbb{Z}[\sqrt{-5}]$, $\mathbb{Z}[\sqrt{-6}]$, ...
2. Sledovat jak ramifikace ovlivňuje strukturu
3. Formulovat obecnou hypotézu

### Fáze 3: Limitní konstrukce

1. Studovat Bost-Connes systém podrobněji
2. Hledat přesnou formulaci projektivní limity
3. Ověřit, zda fermionová algebra v limitě funguje

---

## Reference k prostudování

1. Bost, Connes (1995): "Hecke algebras, type III factors and phase transitions..."
2. Connes, Marcolli: "Noncommutative Geometry, Quantum Fields and Motives"
3. Neukirch: "Algebraic Number Theory" (štěpení prvočísel)

---

## Otevřené otázky

1. **Je degenerace jediná překážka fermionové algebry?**
   - Nebo existují další problémy (např. nekonečná dimenze)?

2. **Jaká je "správná" limitní struktura?**
   - Projektivní limita? Ultraprodukt? Adelický prostor?

3. **Co by konzistentní fermionová algebra implikovala?**
   - Nový pohled na zeta funkci?
   - Operátorová formulace teorie čísel?
   - Spojení s Hilbert-Pólya programem?

4. **Existuje souvislost s modulárními formami?**
   - Heckeovy operátory na modulárních formách
   - Naše $a_p^\dagger$ připomínají Heckeovy operátory $T_p$

---

## Možné strukturální opravy

Problém je v **definici párů a operátorů**, ne v okruhu. Možné přístupy:

### Oprava 1: Váhované báze

Místo $e_{d,n/d} = \delta_d - \delta_{n/d}$ použít váhy:

$$e_{d,n/d}^{(w)} = w(d) \delta_d - w(n/d) \delta_{n/d}$$

kde $w(d)$ závisí na prvočíselném rozkladu $d$.

**Cíl:** Váhy kompenzují degeneraci tak, že kolabující páry dávají různé výsledky.

**Problém:** Jak zvolit $w(d)$ konzistentně?

### Oprava 2: Antisymetrizace přes cesty

Inspirace z fermionů: $a_i a_j = -a_j a_i$

Když dva páry kolabují na stejný výsledek, přiřadit jim **opačná znaménka**:

```
e1 = {1, 5}     → +f1
e2 = {2+i, 2-i} → -f1   (antisymetrizace!)
```

Matice by pak byla $a = (1, -1)$ místo $(1, 1)$.

**Výhoda:** $a^\dagger a = \begin{pmatrix}1 & -1\\-1 & 1\end{pmatrix}$ má vlastní hodnoty $\{0, 2\}$ — stále ne $\{1,1\}$, ale struktura je "čistší".

**Problém:** Jak definovat znaménka konzistentně pro všechna $n$?

### Oprava 3: Cliffordova algebra

Přiřadit každému prvoideálu $\mathfrak{p}$ generátor $\gamma_\mathfrak{p}$ Cliffordovy algebry:

$$\gamma_\mathfrak{p}^2 = 1, \qquad \gamma_\mathfrak{p} \gamma_\mathfrak{q} = -\gamma_\mathfrak{q} \gamma_\mathfrak{p}$$

Stav $|n\rangle$ pro $n = \mathfrak{p}_1 \cdots \mathfrak{p}_k$ odpovídá:

$$|n\rangle \sim \gamma_{\mathfrak{p}_1} \cdots \gamma_{\mathfrak{p}_k} |0\rangle$$

**Výhoda:** Automatická antisymetrie, fermionová struktura zabudovaná.

**Problém:** Jak napojit na prostor párů $V_n^-$?

### Oprava 4: Projekce na "čisté" páry

Definovat $\tilde{V}_n^- \subset V_n^-$ jako podprostor párů **bez společných faktorů**:

Pár $\{d, n/d\}$ je "čistý" pokud $\gcd(d, n/d) = 1$.

Pro $n = 5$: pár $\{1, 5\}$ je čistý, pár $\{2+i, 2-i\}$ má $\gcd = 1$ (coprime), ale sdílí faktor s $n$ samotným.

**Problém:** Definice "čistý" musí být jemnější.

### Oprava 5: Duální páry (nejslibnější?)

Místo párů dělitelů $\{d, n/d\}$ použít **duální konstrukci**:

Pro $n = p_1^{a_1} \cdots p_k^{a_k}$ definujme:
- "Pozice" $(b_1, \ldots, b_k)$ kde $0 \leq b_i \leq a_i$
- Pár pozic: $(\mathbf{b}, \mathbf{a} - \mathbf{b})$

Toto je isomorfní k párům dělitelů, ale operátory definujeme **na pozicích**:

$$a_{p_i}^\dagger: (b_1, \ldots, b_i, \ldots, b_k) \mapsto (b_1, \ldots, b_i + 1, \ldots, b_k)$$

**Klíčový rozdíl:** Operátor $a_{p_i}$ působí **nezávisle** na $i$-té souřadnici.

Antikomutace by mohla fungovat, protože:
- $a_{p_i}$ a $a_{p_j}$ působí na **různé souřadnice**
- Komutují (nebo antikomutují) přirozeně

**Toto je v podstatě standardní fermionový Fockův prostor** s módy indexovanými prvočísly!

---

## Diagnóza: Proč původní konstrukce selhává

Původní definice:
- Prostor $V_n$ = funkce na dělitelích $n$
- Involuce $\sigma: d \mapsto n/d$
- Páry = orbity $\sigma$

Problém: **Dělitelé nejsou nezávislí.** Dělitel $d$ a dělitel $d'$ mohou sdílet prvočísla, což vytváří **korelace** které vedou k degeneraci.

**Fermionový Fockův prostor** je postaven na **nezávislých módech**:
- Mód $i$ je buď obsazen (1) nebo prázdný (0)
- Stavy jsou $|n_1, n_2, \ldots\rangle$ kde $n_i \in \{0, 1\}$
- Operátory $a_i$, $a_i^\dagger$ působí **pouze** na $i$-tý mód

**Naše konstrukce** mísí módy:
- Pár $\{d, n/d\}$ zahrnuje **více** prvočísel najednou
- Operátor $a_p$ ovlivňuje **všechny** páry obsahující $p$

---

## Závěr a další kroky

### Co NEFUNGUJE:
- Rozšíření okruhu ($\mathbb{Z}[i]$, $\mathbb{Z}[\sqrt{-p\#}]$) samo o sobě

### Co by MOHLO fungovat:
1. **Oprava 5 (Duální páry):** Přeformulovat na standardní Fockův prostor
2. **Oprava 3 (Clifford):** Použít Cliffordovu algebru místo párů
3. **Bost-Connes přístup:** Studovat existující konstrukci podrobněji

### Doporučení:
Prozkoumat **Oprava 5** — přeformulovat problém tak, aby operátory působily na **nezávislé souřadnice** (exponenty v prvočíselném rozkladu), ne na páry dělitelů.
