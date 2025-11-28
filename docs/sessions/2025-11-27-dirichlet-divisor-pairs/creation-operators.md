# Kreační a anihilační operátory

## Cíl

Definovat operátory mezi prostory $V_n$ a $V_{np}$ pro prvočíslo $p$:
- $a_p^\dagger: V_n \to V_{np}$ (kreační)
- $a_p: V_{np} \to V_n$ (anihilační)

---

## 1. Struktura dělitelů při násobení $p$

Pro $p \nmid n$:

$$\text{Div}(np) = \text{Div}(n) \sqcup p \cdot \text{Div}(n)$$

**Příklad:** $n = 6$, $p = 5$
- $\text{Div}(6) = \{1, 2, 3, 6\}$
- $\text{Div}(30) = \{1, 2, 3, 6\} \sqcup \{5, 10, 15, 30\}$

---

## 2. Klíčový vzorec

**Věta:** Pro prvočíslo $p \nmid n$:

$$\boxed{P(np) = \tau(n)}$$

**Důkaz:** Z tensorového rozkladu:
$$P(np) = \dim V_n^+ \cdot \dim V_p^- + \dim V_n^- \cdot \dim V_p^+$$

Pro prvočíslo $p$: $\dim V_p^+ = \dim V_p^- = 1$.

$$P(np) = \dim V_n^+ + \dim V_n^- = \tau(n)$$

**Ověření:**

| $n$ | $p$ | $P(np)$ | $\tau(n)$ |
|-----|-----|---------|-----------|
| 2 | 3 | $P(6) = 2$ | $\tau(2) = 2$ ✓ |
| 6 | 5 | $P(30) = 4$ | $\tau(6) = 4$ ✓ |
| 12 | 5 | $P(60) = 6$ | $\tau(12) = 6$ ✓ |

---

## 3. Antisymetrické báze

### $V_6^-$ (dim = 2)

Páry: $\{1, 6\}$, $\{2, 3\}$

Báze:
- $e_{1,6} = \delta_1 - \delta_6$
- $e_{2,3} = \delta_2 - \delta_3$

### $V_{30}^-$ (dim = 4)

Páry: $\{1, 30\}$, $\{2, 15\}$, $\{3, 10\}$, $\{5, 6\}$

Báze:
- $e_{1,30} = \delta_1 - \delta_{30}$
- $e_{2,15} = \delta_2 - \delta_{15}$
- $e_{3,10} = \delta_3 - \delta_{10}$
- $e_{5,6} = \delta_5 - \delta_6$

---

## 4. Mapování párů

Pár $\{d, n/d\}$ v $V_n^-$ se rozpadne na dva páry v $V_{np}^-$:

$$\{d, n/d\} \xrightarrow{a_p^\dagger} \{d, np/d\} + \{dp, n/d\}$$

**Příklad:** $n = 6$, $p = 5$

| Pár v $V_6^-$ | Páry v $V_{30}^-$ |
|---------------|-------------------|
| $\{1, 6\}$ | $\{1, 30\}$, $\{5, 6\}$ |
| $\{2, 3\}$ | $\{2, 15\}$, $\{3, 10\}$ |

Každý pár se **zdvojí**!

---

## 5. Definice kreačního operátoru

### Návrh

$$a_p^\dagger: V_n^- \to V_{np}^-$$

$$a_p^\dagger(e_{d, n/d}) = e_{d, np/d} + e_{dp, n/d}$$

kde $e_{a,b} = \delta_{\min(a,b)} - \delta_{\max(a,b)}$.

### Explicitně pro $n = 6$, $p = 5$

$$a_5^\dagger(e_{1,6}) = e_{1,30} + e_{5,6}$$
$$a_5^\dagger(e_{2,3}) = e_{2,15} + e_{3,10}$$

### Maticová reprezentace

V bázích $\{e_{1,6}, e_{2,3}\}$ a $\{e_{1,30}, e_{2,15}, e_{3,10}, e_{5,6}\}$:

$$a_5^\dagger = \begin{pmatrix} 1 & 0 \\ 0 & 1 \\ 0 & 1 \\ 1 & 0 \end{pmatrix}$$

---

## 6. Anihilační operátor

### Definice

$$a_p: V_{np}^- \to V_n^-$$

jako adjungovaný operátor (transpozice):

$$a_p = (a_p^\dagger)^T$$

### Maticově

$$a_5 = \begin{pmatrix} 1 & 0 & 0 & 1 \\ 0 & 1 & 1 & 0 \end{pmatrix}$$

### Působení

$$a_5(e_{1,30}) = e_{1,6}$$
$$a_5(e_{2,15}) = e_{2,3}$$
$$a_5(e_{3,10}) = e_{2,3}$$
$$a_5(e_{5,6}) = e_{1,6}$$

---

## 7. Antikomutační relace?

### Test $\{a_p, a_p^\dagger\}$

$$a_p a_p^\dagger: V_n^- \to V_n^-$$

$$a_5 a_5^\dagger = \begin{pmatrix} 1 & 0 & 0 & 1 \\ 0 & 1 & 1 & 0 \end{pmatrix} \begin{pmatrix} 1 & 0 \\ 0 & 1 \\ 0 & 1 \\ 1 & 0 \end{pmatrix} = \begin{pmatrix} 2 & 0 \\ 0 & 2 \end{pmatrix} = 2I$$

$$a_5^\dagger a_5: V_{np}^- \to V_{np}^-$$

$$a_5^\dagger a_5 = \begin{pmatrix} 1 & 0 \\ 0 & 1 \\ 0 & 1 \\ 1 & 0 \end{pmatrix} \begin{pmatrix} 1 & 0 & 0 & 1 \\ 0 & 1 & 1 & 0 \end{pmatrix} = \begin{pmatrix} 1 & 0 & 0 & 1 \\ 0 & 1 & 1 & 0 \\ 0 & 1 & 1 & 0 \\ 1 & 0 & 0 & 1 \end{pmatrix}$$

### Antikomutátor

$$\{a_p, a_p^\dagger\} = a_p a_p^\dagger + a_p^\dagger a_p = ?$$

Problém: Operátory působí na různých prostorech!

Pro konzistentní antikomutátor potřebujeme oba na stejném prostoru, např. $\bigoplus_n V_n^-$.

---

## 8. Globální Fockův prostor

### Definice

$$\mathcal{F}^- = \bigoplus_{n=1}^{\infty} V_n^-$$

### Graduace

Podle $\Omega(n)$ (počet prvočíselných faktorů s násobností):

$$\mathcal{F}^- = \bigoplus_{k=0}^{\infty} \mathcal{F}_k^-, \qquad \mathcal{F}_k^- = \bigoplus_{\Omega(n) = k} V_n^-$$

### Kreační operátor na $\mathcal{F}^-$

$$a_p^\dagger: \mathcal{F}^- \to \mathcal{F}^-$$

zvyšuje $\Omega$ o 1.

---

## 9. Komutační relace pro různá $p, q$

### Otázka

$$[a_p^\dagger, a_q^\dagger] = 0 \quad ?$$

### Test

Pro $n = 2$, $p = 3$, $q = 5$:

$$a_3^\dagger a_5^\dagger: V_2^- \to V_6^- \to V_{30}^-$$
$$a_5^\dagger a_3^\dagger: V_2^- \to V_{10}^- \to V_{30}^-$$

Obě cesty končí v $V_{30}^-$, ale průběžné prostory jsou různé!

Potřebujeme ověřit, zda $a_3^\dagger a_5^\dagger = a_5^\dagger a_3^\dagger$ na $V_2^-$.

---

## 10. Shrnutí

| Vlastnost | Hodnota |
|-----------|---------|
| $a_p^\dagger: V_n^- \to V_{np}^-$ | ✓ definováno |
| Zdvojení dimenze | $P(np) = \tau(n)$ |
| Mapování párů | $\{d, n/d\} \to \{d, np/d\} + \{dp, n/d\}$ |
| Adjungovanost | $a_p = (a_p^\dagger)^T$ |
| $a_p a_p^\dagger = 2I$ | ✓ (na $V_n^-$) |
| Fermionová algebra | ? (potřebuje více práce) |

---

## 11. Otevřené otázky

1. **Normalizace:** Měli bychom definovat $\tilde{a}_p^\dagger = a_p^\dagger / \sqrt{2}$ aby $\tilde{a}_p \tilde{a}_p^\dagger = I$?

2. **Komutace:** Platí $[a_p^\dagger, a_q^\dagger] = 0$ pro různá prvočísla?

3. **Číslo obsazení:** Lze definovat $N_p = a_p^\dagger a_p$ jako "počet faktorů $p$"?

4. **Hamiltonián:** Je $H = \sum_p (\log p) \, a_p^\dagger a_p$ přirozený Hamiltonián?

5. **Vakuum:** Je $V_1^- = \{0\}$ (dim = 0) správné vakuum?
