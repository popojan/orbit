# Fermionový Primon Gas — Implementace a propojení s L_P

**Datum:** 2025-11-27
**Status:** ✅ PROVEN — numericky ověřeno, odpovídá literatuře

---

## Shrnutí

Fermionový primon gas je **existující konstrukce** v literatuře která řeší problém degenerace operátorů. Klíčová antikomutační relace $\{a_p, a_p^\dagger\} = I$ **funguje**.

---

## 1. Fockův prostor

### Stavy

Fermionové stavy = **squarefree čísla** (bez čtvercových faktorů):

$$\mathcal{F} = \{|n\rangle : n \text{ je squarefree}\} = \{|1\rangle, |2\rangle, |3\rangle, |5\rangle, |6\rangle, |7\rangle, |10\rangle, \ldots\}$$

### Reprezentace stavu

Pro $n = p_1 \cdot p_2 \cdots p_k$ (squarefree):

$$|n\rangle \sim |n_1, n_2, n_3, \ldots\rangle$$

kde $n_i \in \{0, 1\}$ je obsazení $i$-tého prvočísla.

**Příklady:**

| $n$ | Vektor $(n_2, n_3, n_5, n_7)$ |
|-----|-------------------------------|
| 1 | $(0, 0, 0, 0)$ |
| 2 | $(1, 0, 0, 0)$ |
| 6 | $(1, 1, 0, 0)$ |
| 30 | $(1, 1, 1, 0)$ |

---

## 2. Operátory

### Kreační operátor $a_p^\dagger$

$$a_p^\dagger |n\rangle = \begin{cases} |np\rangle & \text{pokud } p \nmid n \\ 0 & \text{pokud } p | n \end{cases}$$

"Přidej fermion do módu $p$" — funguje jen pokud mód není obsazený (Pauliho princip).

### Anihilační operátor $a_p$

$$a_p |n\rangle = \begin{cases} |n/p\rangle & \text{pokud } p | n \\ 0 & \text{pokud } p \nmid n \end{cases}$$

"Odeber fermion z módu $p$" — funguje jen pokud mód je obsazený.

---

## 3. Antikomutační relace

### Hlavní výsledek

$$\boxed{\{a_p, a_p^\dagger\} = a_p a_p^\dagger + a_p^\dagger a_p = I}$$

**Důkaz:** Pro libovolný stav $|n\rangle$:
- Pokud $p \nmid n$: $a_p a_p^\dagger |n\rangle = a_p |np\rangle = |n\rangle$, $a_p^\dagger a_p |n\rangle = 0$
- Pokud $p | n$: $a_p a_p^\dagger |n\rangle = 0$, $a_p^\dagger a_p |n\rangle = a_p^\dagger |n/p\rangle = |n\rangle$

V obou případech: suma = $|n\rangle$.

### Numerické ověření

```
{a_2, a_2†}:
  |1>:  a*a† = 1,  a†*a = 0,  suma = 1  ✓
  |2>:  a*a† = 0,  a†*a = 2,  suma = 2  ✓
  |6>:  a*a† = 0,  a†*a = 6,  suma = 6  ✓
  |15>: a*a† = 15, a†*a = 0,  suma = 15 ✓
```

### Komutace pro různá prvočísla

$$[a_p, a_q^\dagger] = 0 \quad \text{pro } p \neq q$$

Operátory pro různá prvočísla **komutují** (ne antikomutují). Toto je "hard-core boson" algebra.

Pro plnou fermionovou antikomutaci $\{a_p, a_q\} = 0$ by se použila **Jordan-Wigner transformace**.

---

## 4. Partiční funkce

### Fermionová partiční funkce

$$Z_F(s) = \sum_{n \text{ squarefree}} \frac{1}{n^s} = \prod_p (1 + p^{-s}) = \frac{\zeta(s)}{\zeta(2s)}$$

### Numerické ověření

| $s$ | Přímá suma | $\zeta(s)/\zeta(2s)$ | Shoda |
|-----|------------|----------------------|-------|
| 2 | 1.5198 | 1.5198 | ✓ |
| 3 | 1.1816 | 1.1816 | ✓ |
| 4 | 1.0779 | 1.0779 | ✓ |

---

## 5. Propojení s $L_P(s)$

### Definice

| Funkce | Definice | Koeficienty |
|--------|----------|-------------|
| $\zeta(s)^2$ | $\sum \tau(n)/n^s$ | $\tau(n)$ = počet dělitelů |
| $\zeta(2s)$ | $\sum 1/n^{2s}$ | čtverce |
| $L_P(s)$ | $(\zeta^2 - \zeta(2s))/2$ | $P(n)$ = počet párů |
| $Z_F(s)$ | $\zeta/\zeta(2s)$ | $|\mu(n)|$ = squarefree indikátor |
| $\zeta^2/\zeta(2s)$ | $\sum 2^{\omega(n)}/n^s$ | $2^{\omega(n)}$ = squarefree dělitelé |

### Klíčové identity

$$L_P(s) = \frac{\zeta(s)^2 - \zeta(2s)}{2}$$

$$Z_F(s) = \frac{\zeta(s)}{\zeta(2s)}$$

$$\frac{\zeta(s)^2}{\zeta(2s)} = \sum_{n=1}^\infty \frac{2^{\omega(n)}}{n^s}$$

kde $\omega(n)$ = počet **různých** prvočíselných faktorů.

### Interpretace

- **$Z_F(s)$**: Partiční funkce fermionových primonů = suma přes squarefree stavy
- **$L_P(s)$**: Generující funkce počtu párů dělitelů
- **$2^{\omega(n)}$**: Počet squarefree dělitelů $n$

**Pro squarefree $n$:** $\tau(n) = 2^{\omega(n)}$, tedy $P(n) = 2^{\omega(n)-1}$.

---

## 6. Proč to funguje (vs. původní konstrukce)

### Původní problém

V prostoru párů $V_n^-$ operátory měly **degeneraci** — více párů kolabovalo na stejný výstup.

### Proč primon gas nemá degeneraci

| Aspekt | Páry dělitelů | Primon gas |
|--------|---------------|------------|
| Báze | Páry $\{d, n/d\}$ | Obsazení módů $(n_2, n_3, \ldots)$ |
| Závislost | Páry sdílejí faktory | Módy **nezávislé** |
| Operátor $a_p$ | Ovlivňuje všechny páry s $p$ | Ovlivňuje **pouze** mód $p$ |
| Degenerace | ANO | NE |

**Klíč:** Primon gas pracuje s **exponenty** v prvočíselném rozkladu, ne s děliteli.

---

## 7. Möbiova funkce jako statistika

Möbiova funkce $\mu(n)$ dává fermionovou statistiku:

$$\mu(n) = \begin{cases}
0 & n \text{ není squarefree (zakázaný stav)} \\
(-1)^k & n = p_1 \cdots p_k \text{ (parita fermionů)}
\end{cases}$$

**Pozoruhodný výsledek:**

$$\sum_{n=1}^\infty \frac{\mu(n)}{n} = 0$$

je **ekvivalentní prvočíselnému teorému**!

---

## 8. Hamiltonián

Přirozený Hamiltonián:

$$H = \sum_p (\log p) \, N_p = \sum_p (\log p) \, a_p^\dagger a_p$$

Energie stavu $|n\rangle$:

$$E_n = \log n$$

Partiční funkce:

$$Z(\beta) = \text{Tr}(e^{-\beta H}) = \sum_n e^{-\beta \log n} = \sum_n n^{-\beta} = \zeta(\beta)$$

(pro bosony; pro fermiony $Z_F(\beta) = \zeta(\beta)/\zeta(2\beta)$)

---

## Reference

1. [Arithmetic Gas | Mathematical Garden](https://mathematicalgarden.wordpress.com/2014/08/27/arithmetic-gas/)
2. [Primon gas and supersymmetry](https://rantonels.github.io/the-riemann-zeta-function-the-primon-gas-and-supersymmetry/)
3. [Bost–Connes system - Wikipedia](https://en.wikipedia.org/wiki/Bost%E2%80%93Connes_system)
4. Spector (1990): "Supersymmetry and the Möbius inversion function"
5. Julia (1990): "Statistical mechanics and number theory"

---

## Závěr

Fermionový primon gas je **korektní realizace** fermionové algebry pro teorii čísel:

- ✅ Antikomutace $\{a_p, a_p^\dagger\} = I$ funguje
- ✅ Partiční funkce = $\zeta(s)/\zeta(2s)$
- ✅ Souvislost s $L_P(s)$ přes identitu $L_P = (\zeta^2 - \zeta(2s))/2$
- ✅ Möbiova funkce = fermionová statistika
- ✅ Prvočíselný teorém = kvantová vlastnost systému

**Toto je existující, dobře prostudovaná konstrukce v literatuře.**
