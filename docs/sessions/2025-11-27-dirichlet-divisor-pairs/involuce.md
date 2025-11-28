# Párování dělitelů jako involuce

## Definice

Pro každé $n \in \mathbb{N}$ definujeme involuce na množině dělitelů:

$$\sigma_n: \text{Div}(n) \to \text{Div}(n), \qquad d \mapsto n/d$$

**Základní vlastnost:** $\sigma_n^2 = \text{id}$

---

## 1. Spektrální vlastnosti

Pokud $\sigma^2 = I$, pak pro vlastní hodnotu $\lambda$:

$$\sigma v = \lambda v \quad \Rightarrow \quad v = \sigma^2 v = \lambda^2 v \quad \Rightarrow \quad \lambda^2 = 1$$

**Vlastní hodnoty jsou pouze $\pm 1$.**

Minimální polynom dělí $x^2 - 1 = (x-1)(x+1)$.

---

## 2. Kanonický rozklad prostoru

$$V_n = V_n^+ \oplus V_n^-$$

kde:
- $V_n^+ = \ker(\sigma_n - I) = \{f : \sigma_n f = f\}$ — eigenspace +1 (symetrické funkce)
- $V_n^- = \ker(\sigma_n + I) = \{f : \sigma_n f = -f\}$ — eigenspace -1 (antisymetrické funkce)

### Explicitní projektory

$$P^+ = \frac{I + \sigma}{2}, \qquad P^- = \frac{I - \sigma}{2}$$

Ověření:
- $(P^+)^2 = \frac{1}{4}(I + 2\sigma + \sigma^2) = \frac{1}{4}(2I + 2\sigma) = P^+$
- $P^+ + P^- = I$
- $P^+ P^- = 0$

### Rozklad libovolné funkce

$$f = \underbrace{\frac{f + \sigma f}{2}}_{f^+ \in V^+} + \underbrace{\frac{f - \sigma f}{2}}_{f^- \in V^-}$$

---

## 3. Dimenze a P(n)

### Pevné body

Bod $d$ je pevný $\Leftrightarrow$ $\sigma_n(d) = d$ $\Leftrightarrow$ $d = n/d$ $\Leftrightarrow$ $d = \sqrt{n}$

Pevný bod existuje právě když $n$ je čtverec.

### Dimenze podprostorů

$$\dim V_n^+ = \frac{\tau(n) + \chi_\square(n)}{2}$$

$$\dim V_n^- = \frac{\tau(n) - \chi_\square(n)}{2}$$

kde $\chi_\square(n) = 1$ pokud $n$ je čtverec, jinak $0$.

### Klíčový výsledek

$$\boxed{P(n) = \dim V_n^-}$$

| $n$ | $\tau(n)$ | čtverec? | $\dim V^+$ | $\dim V^-$ | $P(n)$ |
|-----|-----------|----------|------------|------------|--------|
| 6 | 4 | ne | 2 | 2 | 2 |
| 9 | 3 | ano | 2 | 1 | 1 |
| 12 | 6 | ne | 3 | 3 | 3 |
| 16 | 5 | ano | 3 | 2 | 2 |
| 36 | 9 | ano | 5 | 4 | 4 |

---

## 4. Stopa a determinant

$$\text{Tr}(\sigma_n) = \dim V_n^+ - \dim V_n^- = \chi_\square(n)$$

$$\det(\sigma_n) = (+1)^{\dim V^+} \cdot (-1)^{\dim V^-} = (-1)^{P(n)}$$

| $n$ | $\text{Tr}(\sigma_n)$ | $\det(\sigma_n)$ |
|-----|----------------------|------------------|
| 6 | 0 | $+1$ |
| 9 | 1 | $-1$ |
| 12 | 0 | $-1$ |
| 16 | 1 | $+1$ |

---

## 5. Grupová struktura

$$G_n = \{I, \sigma_n\} \cong \mathbb{Z}/2\mathbb{Z}$$

Reprezentace $\mathbb{Z}/2\mathbb{Z}$ na $V_n$:
- **Triviální reprezentace:** $\sigma_n \mapsto +1$ na $V_n^+$
- **Znaménková reprezentace:** $\sigma_n \mapsto -1$ na $V_n^-$

---

## 6. Maticové vlastnosti

Matice $M_n$ involuce $\sigma_n$ v bázi dělitelů $(d_1, \ldots, d_{\tau(n)})$:

$$(M_n)_{ij} = \begin{cases} 1 & \text{pokud } d_j = n/d_i \\ 0 & \text{jinak} \end{cases}$$

### Vlastnosti matice $M_n$

| Vlastnost | Vzorec |
|-----------|--------|
| Symetrie | $M_n = M_n^T$ |
| Involuce | $M_n^2 = I$ |
| Ortogonalita | $M_n^T M_n = I$ |
| Vlastní inverze | $M_n = M_n^{-1}$ |

**$M_n$ je současně symetrická i ortogonální:** $M_n \in O(\tau(n)) \cap \text{Sym}(\tau(n))$

### Příklad: $n = 12$

Dělitelé: $(1, 2, 3, 4, 6, 12)$

$$M_{12} = \begin{pmatrix}
0 & 0 & 0 & 0 & 0 & 1 \\
0 & 0 & 0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1 & 0 & 0 \\
0 & 0 & 1 & 0 & 0 & 0 \\
0 & 1 & 0 & 0 & 0 & 0 \\
1 & 0 & 0 & 0 & 0 & 0
\end{pmatrix}$$

Vlastní hodnoty: $\{+1, +1, +1, -1, -1, -1\}$

---

## 7. Charakteristický polynom

$$\det(M_n - \lambda I) = (\lambda - 1)^{\dim V^+} (\lambda + 1)^{\dim V^-}$$

$$= (\lambda^2 - 1)^{P(n)} \cdot (\lambda - 1)^{\chi_\square(n)}$$

---

## 8. Báze podprostorů

### Antisymetrická báze $V_n^-$

Pro každý pár $\{d, n/d\}$ s $d < n/d$:

$$e_{d} = \delta_d - \delta_{n/d}$$

**Příklad pro $n = 12$:**

$$e_1 = \delta_1 - \delta_{12}, \quad e_2 = \delta_2 - \delta_6, \quad e_3 = \delta_3 - \delta_4$$

### Symetrická báze $V_n^+$

Pro každý pár $\{d, n/d\}$ s $d < n/d$:

$$f_{d} = \delta_d + \delta_{n/d}$$

Plus $\delta_{\sqrt{n}}$ pokud $n$ je čtverec.

---

## 9. Tensorový produkt

Pro $\gcd(m, n) = 1$:

$$\text{Div}(mn) \cong \text{Div}(m) \times \text{Div}(n)$$

$$\sigma_{mn} \cong \sigma_m \otimes \sigma_n$$

### Rozklad

$$V_{mn}^+ \cong (V_m^+ \otimes V_n^+) \oplus (V_m^- \otimes V_n^-)$$

$$V_{mn}^- \cong (V_m^+ \otimes V_n^-) \oplus (V_m^- \otimes V_n^+)$$

### Důsledek pro P

$$P(mn) = \dim V_m^+ \cdot \dim V_n^- + \dim V_m^- \cdot \dim V_n^+$$

Po dosazení:

$$P(mn) = \frac{\tau(m) + \chi_\square(m)}{2} \cdot \frac{\tau(n) - \chi_\square(n)}{2} + \frac{\tau(m) - \chi_\square(m)}{2} \cdot \frac{\tau(n) + \chi_\square(n)}{2}$$

$$= \frac{\tau(m)\tau(n) - \chi_\square(m)\chi_\square(n)}{2} = \frac{\tau(mn) - \chi_\square(mn)}{2} = P(mn) \quad \checkmark$$

### Speciální případy

**Oba nečtverce:** $\chi_\square(m) = \chi_\square(n) = 0$

$$P(mn) = 2 \cdot P(m) \cdot P(n)$$

Ověření: $P(6) = P(2 \cdot 3) = 2 \cdot 1 \cdot 1 = 2$ ✓

**Jeden čtverec:** např. $m = 4$, $n = 3$

$$P(12) = \dim V_4^+ \cdot P(3) + P(4) \cdot \dim V_3^+ = 2 \cdot 1 + 1 \cdot 1 = 3$$ ✓

---

## 10. Souvislost s Möbiovou funkcí

### Möbiova inverze

$$(f * 1)(n) = g(n) \quad \Leftrightarrow \quad f(n) = (g * \mu)(n)$$

### Naše involuce

$$(\sigma_n f)(d) = f(n/d)$$

### Otázka

Existuje vztah mezi $\sigma_n$ a Möbiovou inverzí?

Obě jsou "inverze" v nějakém smyslu:
- Möbius: inverze vzhledem ke konvoluci
- $\sigma_n$: inverze vzhledem ke skládání

---

## 11. Shrnutí

| Vlastnost involuce | Důsledek pro $\sigma_n$ |
|--------------------|------------------------|
| $\sigma^2 = I$ | Vlastní hodnoty $\pm 1$ |
| Spektrální rozklad | $V_n = V_n^+ \oplus V_n^-$ |
| Projektory | $P^\pm = (I \pm \sigma)/2$ |
| Stopa | $\text{Tr}(\sigma_n) = \chi_\square(n)$ |
| Determinant | $\det(\sigma_n) = (-1)^{P(n)}$ |
| Grupa | $\langle \sigma_n \rangle \cong \mathbb{Z}/2$ |
| Matice | $M_n = M_n^T = M_n^{-1}$ |
| **Klíčový výsledek** | **$P(n) = \dim V_n^-$** |

---

## 12. Otevřené otázky

1. Jak souvisí $\sigma_n$ s Möbiovou inverzí?
2. Existuje "globální" operátor $\Sigma = \bigoplus_n \sigma_n$ s užitečnými vlastnostmi?
3. Lze tensorový produkt $\sigma_m \otimes \sigma_n$ využít k pochopení multiplikativity?
4. Má involuce spektrální interpretaci ve smyslu RMT?
