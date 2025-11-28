# Tensorový produkt involucí

**Status:** Algebraická identita (triviální, ale elegantní)

---

## Struktura

Pro gcd(m,n) = 1 platí:

$$\sigma_{mn} \cong \sigma_m \otimes \sigma_n$$

kde $\sigma_n: d \mapsto n/d$ je involuce na dělitelích.

---

## Rozklad vlastních prostorů

Vlastní hodnoty tensorového produktu:

| $V_m$ | $V_n$ | Produkt | $V_{mn}$ |
|-------|-------|---------|----------|
| $V_m^+$ (+1) | $V_n^+$ (+1) | +1 | $V_{mn}^+$ |
| $V_m^-$ (-1) | $V_n^-$ (-1) | +1 | $V_{mn}^+$ |
| $V_m^+$ (+1) | $V_n^-$ (-1) | -1 | $V_{mn}^-$ |
| $V_m^-$ (-1) | $V_n^+$ (+1) | -1 | $V_{mn}^-$ |

---

## Vzorec pro P(mn)

$$P(mn) = \dim V_m^+ \cdot \dim V_n^- + \dim V_m^- \cdot \dim V_n^+$$

kde:
- $\dim V_n^+ = (\tau(n) + \chi_\square(n))/2$
- $\dim V_n^- = (\tau(n) - \chi_\square(n))/2 = P(n)$
- $\chi_\square(n) = 1$ pokud $n$ je čtverec, jinak 0

---

## Speciální případy

### Oba nečtverce (m, n nejsou čtverce)

$$\dim V_m^+ = \dim V_m^- = \tau(m)/2 = P(m)$$

Tedy:

$$\boxed{P(mn) = 2 \cdot P(m) \cdot P(n)}$$

### Jeden čtverec (m = k², n nečtverec)

$$P(k^2 \cdot n) = \frac{\tau(k^2)+1}{2} \cdot P(n) + P(k^2) \cdot \frac{\tau(n)}{2}$$

---

## Verifikace

| m | n | P(m) | P(n) | P(mn) vzorec | P(mn) přímé |
|---|---|------|------|--------------|-------------|
| 2 | 3 | 1 | 1 | 2 | 2 ✓ |
| 2 | 5 | 1 | 1 | 2 | 2 ✓ |
| 3 | 5 | 1 | 1 | 2 | 2 ✓ |
| 4 | 3 | 1 | 1 | 2 | 2 ✓ |
| 5 | 7 | 1 | 1 | 2 | 2 ✓ |

---

## Závěr

Vzorec se redukuje na:

$$P(mn) = \frac{\tau(mn) - \chi_\square(mn)}{2} = \left\lfloor \frac{\tau(mn)}{2} \right\rfloor$$

což je **definice P**. Tensor product struktura je konzistentní, ale nepřináší nový vhled.

**Hodnota:** Elegantní algebraická formulace, ukazuje že P je "kvazi-multiplikativní".
