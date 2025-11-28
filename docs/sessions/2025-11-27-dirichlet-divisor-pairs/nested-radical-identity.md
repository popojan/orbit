# Vnořený radikál: Algebraická identita pro L_P a Z_F

**Datum:** 2025-11-27
**Status:** ✅ NUMERICKY OVĚŘENO (algebraicky triviální)

---

## ⚠️ Disclaimer

**Toto NENÍ výpočetní zkratka.** Vnořený radikál je algebraická reprezentace — přepisuje zeta-hodnoty na jiné zeta-hodnoty, nic neobchází.

Skutečná hodnota této session je jinde:
- **Negativní výsledek:** Fermionová algebra na párech dělitelů NEFUNGUJE
- **Diagnóza:** Důvod selhání = sdílené prvočíselné faktory mezi páry

---

## Definice

$$L_P(s) = \sum_{n=1}^{\infty} \frac{P(n)}{n^s} = \frac{\zeta(s)^2 - \zeta(2s)}{2}$$

kde $P(n) = \lfloor \tau(n)/2 \rfloor$ = počet párů dělitelů $\{d, n/d\}$ s $d < n/d$.

$$A(s) = \frac{\zeta(s)^2 + \zeta(2s)}{2}$$

(OEIS A038548 — počet dělitelů $d | n$ kde $d \leq \sqrt{n}$.)

$$Z_F(s) = \frac{\zeta(s)}{\zeta(2s)}$$

= fermionová partiční funkce (primon gas).

---

## Základní identity (triviální)

$$A(s) + L_P(s) = \zeta(s)^2$$

$$A(s) - L_P(s) = \zeta(2s)$$

Tyto identity plynou přímo z definic — není v nich nic hlubokého.

---

## Rekurence

Z $\zeta(2s)^2 = \zeta(4s) \cdot \zeta(4s)/\zeta(4s)$... ne, jednodušeji:

$$\zeta(2s)^2 = A(2s) + L_P(2s)$$

(dosazení $2s$ za $s$ do první identity)

Tedy:

$$(A(s) - L_P(s))^2 = A(2s) + L_P(2s)$$

Ekvivalentně:

$$A(s) = L_P(s) + \sqrt{A(2s) + L_P(2s)}$$

---

## Vnořený radikál

Iterací rekurence:

$$A(s) = L_P(s) + \sqrt{2L_P(2s) + \sqrt{2L_P(4s) + \sqrt{2L_P(8s) + \cdots}}}$$

### Konvergence

Pro $s \to \infty$: $L_P(s) \to 0$, $A(s) \to 1$

Radikál konverguje díky této okrajové podmínce.

---

## Vztah k Z_F

$$Z_F(s) = \frac{\sqrt{A(s) + L_P(s)}}{\sqrt{A(2s) + L_P(2s)}} = \frac{\sqrt{A(s) + L_P(s)}}{A(s) - L_P(s)}$$

Kde $A(s)$ je dáno vnořeným radikálem výše.

---

## Numerické ověření

Bootstrap od $s = 16$ (kde $A \approx 1$):

```
A(8)  approx = 1.0040857    exact = 1.0040933
A(4)  approx = 1.0877467    exact = 1.0877505
A(2)  approx = 1.8940639    exact = 1.8940657

Z_F(2) z radikálu = 1.5198197
Z_F(2) exact      = 1.5198178
Chyba: ~10^{-6}
```

Chyba pochází pouze z konečného oříznutí radikálu.

---

## Co tohle NENÍ

1. **NENÍ to objev** — je to algebraická manipulace známých identit
2. **NENÍ to výpočetní zkratka** — k L_P potřebujeme ζ², k Z_F potřebujeme ζ
3. **NENÍ to "fundamentální"** — L_P a A jsou jen lineární kombinace ζ² a ζ(2s)

## Co tohle JE

1. **Zajímavá reprezentace** — vnořené radikály mají estetickou hodnotu
2. **Škálovací struktura** — mapování $s \mapsto 2s \mapsto 4s$ je elegantní
3. **Možná inspirace** — podobné struktury existují v RG flow, ale analogie je spekulativní

---

## Otevřené otázky (spekulativní)

1. Má vnořený radikál uzavřený tvar pro speciální $s$?
2. Existuje analogie pro Dirichletovy L-funkce $L(s, \chi)$?
3. Je škálování $s \mapsto 2s$ nějak významné? (Pravděpodobně ne víc než $n \mapsto n^2$)

---

## Reference

- OEIS A038548: $(\zeta^2 + \zeta(2s))/2$
- Primon gas: Julia (1990), Spector (1990)

