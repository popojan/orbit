# Fermionová algebra — detailní analýza

## 1. Komutace kreačních operátorů

### Tvrzení

$$[a_p^\dagger, a_q^\dagger] = 0 \quad \text{pro } p \neq q$$

### Ověření

Pro $n = 2$, $p = 3$, $q = 5$:

**Cesta 1:** $V_2^- \xrightarrow{a_3^\dagger} V_6^- \xrightarrow{a_5^\dagger} V_{30}^-$

$$\{1,2\} \xrightarrow{a_3^\dagger} \{\{1,6\}, \{2,3\}\} \xrightarrow{a_5^\dagger} \{\{1,30\}, \{5,6\}, \{2,15\}, \{3,10\}\}$$

**Cesta 2:** $V_2^- \xrightarrow{a_5^\dagger} V_{10}^- \xrightarrow{a_3^\dagger} V_{30}^-$

$$\{1,2\} \xrightarrow{a_5^\dagger} \{\{1,10\}, \{2,5\}\} \xrightarrow{a_3^\dagger} \{\{1,30\}, \{3,10\}, \{2,15\}, \{5,6\}\}$$

**Výsledek:** Obě cesty dávají stejnou množinu párů! ✓

### Obecný test

| $n$ | $p$ | $q$ | $[a_p^\dagger, a_q^\dagger] = 0$? |
|-----|-----|-----|-----------------------------------|
| 2 | 3 | 5 | ✓ |
| 2 | 3 | 7 | ✓ |
| 3 | 2 | 5 | ✓ |
| 6 | 5 | 7 | ✓ |
| 4 | 3 | 5 | ✓ |

---

## 2. Produkt $a_p a_p^\dagger$

### Výsledek

$$\boxed{a_p a_p^\dagger = 2 \cdot I \quad \text{na } V_n^- \text{ pro } p \nmid n}$$

### Důkaz

Každý pár $\{d, n/d\} \in V_n^-$ se mapuje na **dva** páry v $V_{np}^-$:
- $\{d, np/d\}$
- $\{dp, n/d\}$

Anihilace $a_p$ pak každý z těchto párů mapuje zpět na původní pár.

Tedy každý bázový vektor přispívá s koeficientem 2.

### Matice pro $n = 6$, $p = 5$

Báze $V_6^-$: $\{e_{1,6}, e_{2,3}\}$
Báze $V_{30}^-$: $\{e_{1,30}, e_{2,15}, e_{3,10}, e_{5,6}\}$

$$a_5^\dagger = \begin{pmatrix} 1 & 0 \\ 0 & 1 \\ 0 & 1 \\ 1 & 0 \end{pmatrix}, \qquad
a_5 = \begin{pmatrix} 1 & 0 & 0 & 1 \\ 0 & 1 & 1 & 0 \end{pmatrix}$$

$$a_5 a_5^\dagger = \begin{pmatrix} 2 & 0 \\ 0 & 2 \end{pmatrix} = 2I$$

---

## 3. Normalizované operátory

### Definice

$$\tilde{a}_p = \frac{a_p}{\sqrt{2}}, \qquad \tilde{a}_p^\dagger = \frac{a_p^\dagger}{\sqrt{2}}$$

### Vlastnost

$$\tilde{a}_p \tilde{a}_p^\dagger = I \quad \text{na } V_n^- \text{ pro } p \nmid n$$

---

## 4. Produkt $a_p^\dagger a_p$ (pro $p | n$)

### Problém

Pro $p | n$, anihilační operátor $a_p: V_n^- \to V_{n/p}^-$ je **netriviální**.

### Příklad: $n = 6$, $p = 2$

Báze $V_6^-$: $\{e_{1,6}, e_{2,3}\}$
Báze $V_3^-$: $\{e_{1,3}\}$

**Mapování párů:**

| Pár v $V_6^-$ | Podmínka | Obraz v $V_3^-$ |
|---------------|----------|-----------------|
| $\{1, 6\}$ | $2 \nmid 1$, $2 | 6$ | $\{1, 3\}$ |
| $\{2, 3\}$ | $2 | 2$, $2 \nmid 3$ | $\{1, 3\}$ |

**Oba páry se mapují na stejný pár!**

### Matice

$$a_2: V_6^- \to V_3^-$$

$$a_2 = \begin{pmatrix} 1 & 1 \end{pmatrix}$$

$$a_2^\dagger = \begin{pmatrix} 1 \\ 1 \end{pmatrix}$$

### Produkty

$$a_2 a_2^\dagger = (2) \quad \text{na } V_3^-$$

$$a_2^\dagger a_2 = \begin{pmatrix} 1 & 1 \\ 1 & 1 \end{pmatrix} \quad \text{na } V_6^-$$

Vlastní hodnoty $a_2^\dagger a_2$: $\{0, 2\}$

**To NENÍ identita!**

---

## 5. Antikomutátor na Fockově prostoru

### Definice

$$\mathcal{F}^- = \bigoplus_{n=1}^{\infty} V_n^-$$

### Antikomutátor $\{\tilde{a}_p, \tilde{a}_p^\dagger\}$

Na podprostoru $V_n^-$:

**Případ $p \nmid n$:**
$$\tilde{a}_p \tilde{a}_p^\dagger |_{V_n^-} = I$$
$$\tilde{a}_p^\dagger \tilde{a}_p |_{V_n^-} = 0 \quad \text{(není definováno, } V_{n/p}^- \text{ neexistuje)}$$

$$\{\tilde{a}_p, \tilde{a}_p^\dagger\}|_{V_n^-} = I \quad \checkmark$$

**Případ $p | n$:**
$$\tilde{a}_p \tilde{a}_p^\dagger |_{V_n^-} = I$$
$$\tilde{a}_p^\dagger \tilde{a}_p |_{V_n^-} = \frac{1}{2} a_p^\dagger a_p \neq I$$

$$\{\tilde{a}_p, \tilde{a}_p^\dagger\}|_{V_n^-} = I + \frac{1}{2} a_p^\dagger a_p \neq I$$

---

## 6. Proč to NENÍ čistá fermionová algebra

### Standardní fermionová algebra

$$\{a_i, a_j^\dagger\} = \delta_{ij}, \qquad \{a_i, a_j\} = \{a_i^\dagger, a_j^\dagger\} = 0$$

### Naše situace

1. **Komutace kreačních:** $[a_p^\dagger, a_q^\dagger] = 0$ ✓ (ale mělo by být antikomutátor = 0)

2. **Antikomutátor:** $\{a_p, a_p^\dagger\} \neq \text{const} \cdot I$ (závisí na $n$)

3. **Problém anihilace:** Více párů se může mapovat na stejný pár

### Diagnóza

Struktura je **"skoro fermionová"** ale s komplikacemi:
- Operátory působí mezi **různými** prostory $V_n^-$
- Anihilace má **netriviální jádro** (některé páry kolabují)
- Antikomutátor závisí na **aritmetické struktuře** $n$

---

## 7. Alternativní formulace

### Operátor čísla částic

Definujme pro každé prvočíslo $p$:

$$N_p = \tilde{a}_p^\dagger \tilde{a}_p$$

Na $V_n^-$:
- $N_p = 0$ pokud $p \nmid n$
- $N_p \neq 0, I$ pokud $p | n$

### Celkové číslo částic

$$N = \sum_p N_p$$

Toto by mělo souviset s $\Omega(n)$ = počet prvočíselných faktorů.

### Hamiltonián

Kandidát:
$$H = \sum_p (\log p) \, N_p$$

Formálně:
$$e^{-\beta H} |n\rangle \sim n^{-\beta} |n\rangle$$

---

## 8. Shrnutí

| Vlastnost | Fermionová algebra | Naše algebra |
|-----------|--------------------|--------------|
| $[a_p^\dagger, a_q^\dagger] = 0$ | ✓ (antikomutátor) | ✓ (komutátor) |
| $\{a_p, a_p^\dagger\} = I$ | ✓ | ✗ (závisí na $n$) |
| $a_p a_p^\dagger = ?$ | $I - N_p$ | $2I$ (pro $p \nmid n$) |
| Jádro $a_p$ | $\{0\}$ | netriviální |

---

## 9. Otevřené otázky

1. **Jaká je správná algebraická struktura?**
   - Deformovaná fermionová algebra?
   - Heckeova algebra?
   - Něco nového?

2. **Lze opravit definici $a_p$ aby antikomutátor fungoval?**

3. **Jaká je fyzikální interpretace kolabujících párů?**

4. **Existuje souvislost s Heckeovými operátory na modulárních formách?**
