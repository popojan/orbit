# Co je standard vs. co jsme přidali

**Datum:** 2025-11-27
**Účel:** Jasně odlišit známé výsledky od našeho příspěvku
**Update:** Adversarial self-check proveden — přehodnoceno

---

## ZNÁMÉ (standard v literatuře)

### 1. Dirichletovy řady pro dělitelské funkce

| Řada | Vzorec | Reference |
|------|--------|-----------|
| $\zeta(s)^2$ | $\sum \tau(n)/n^s$ | Standardní učebnice |
| $\zeta(s)/\zeta(2s)$ | $\sum |\mu(n)|/n^s$ = suma přes squarefree | Standardní |
| $\zeta(s)^2/\zeta(2s)$ | $\sum 2^{\omega(n)}/n^s$ | Standardní |
| $(\zeta(s)^2 + \zeta(2s))/2$ | $\sum \lceil\tau(n)/2\rceil/n^s$ | OEIS A038548 |

### 2. Primon gas (Julia 1990, Spector 1990)

- Bosony indexované prvočísly, $Z_B = \zeta(\beta)$
- Fermiony (squarefree stavy), $Z_F = \zeta(\beta)/\zeta(2\beta)$
- Möbiova funkce jako fermionová statistika
- Souvislost s prvočíselným teorémem

### 3. Bost-Connes systém (1995)

- C*-algebra s operátory, partiční funkce $\zeta(s)$
- Fázový přechod při $\beta = 1$
- Galoisova akce na KMS stavech

---

## NAŠE KONSTRUKCE

### Co jsme definovali

**Involuce na dělitelích:**
$$\sigma_n: \text{Div}(n) \to \text{Div}(n), \quad d \mapsto n/d$$

**Rozklad prostoru funkcí:**
$$V_n = V_n^+ \oplus V_n^-$$
- $V_n^+$ = symetrické funkce ($f(d) = f(n/d)$)
- $V_n^-$ = antisymetrické funkce ($f(d) = -f(n/d)$)

**Klíčový výsledek:**
$$\boxed{P(n) = \dim V_n^- = \lfloor \tau(n)/2 \rfloor}$$

**Generující funkce:**
$$L_P(s) = \sum_{n=1}^{\infty} \frac{P(n)}{n^s} = \frac{\zeta(s)^2 - \zeta(2s)}{2}$$

---

## ANALÝZA: Co je nové?

### Identita $L_P(s) = (\zeta^2 - \zeta(2s))/2$

**Status:** IMPLICITNĚ ZNÁMÉ

- A038548 má $(ζ^2 + ζ(2s))/2$
- Naše $L_P$ je komplementární: $(ζ^2 - ζ(2s))/2$
- Obě plynou z $\tau(n) = \lceil\tau/2\rceil + \lfloor\tau/2\rfloor$
- **Není explicitně v OEIS jako samostatná sekvence** (floor vs ceil)

### Involuce $\sigma_n: d \mapsto n/d$

**Status:** ZNÁMÁ konstrukce, ale...

- Involuce sama je triviální
- Rozklad na $V^\pm$ je standardní lineární algebra
- **Interpretace $P(n) = \dim V_n^-$ možná není explicitně v literatuře**

### Pokus o fermionovou algebru na $V_n^-$

**Status:** NAŠE PRÁCE (a SELHÁNÍ)

- Definovali jsme $a_p^\dagger: V_n^- \to V_{np}^-$
- Zjistili jsme **degeneraci** (více párů kolabuje)
- Antikomutace $\{a_p, a_p^\dagger\} = I$ **NEFUNGUJE** pro páry dělitelů
- Toto je **negativní výsledek**, ale může být užitečný

### Propojení s primon gas

**Status:** NAŠE PERSPEKTIVA

- Ukázali jsme PROČ páry dělitelů nefungují (sdílené faktory)
- Identifikovali primon gas jako "správnou" fermionovou realizaci
- Propojení $L_P \leftrightarrow Z_F$ přes společnou strukturu

---

## CO CHYBÍ: Přímé spojení $L_P$ s fyzikou

**Problém:**

| Objekt | Partiční funkce | Fermionová algebra |
|--------|-----------------|-------------------|
| Primon gas | $Z_F = \zeta/\zeta(2s)$ | ✅ Funguje |
| Naše $L_P$ | $L_P = (\zeta^2 - \zeta(2s))/2$ | ❌ Nefunguje |

$L_P(s)$ **NENÍ partiční funkce** žádného přirozeného fermionového systému!

**Proč?**
- $L_P$ počítá PÁRY dělitelů, ne stavy Fockova prostoru
- Páry nejsou nezávislé módy
- Degenerace znemožňuje fermionovou interpretaci

---

## VZTAHY MEZI FUNKCEMI

```
                    ζ(s)²
                   /     \
                  /       \
    (ζ² + ζ(2s))/2         (ζ² - ζ(2s))/2
         |                       |
      A038548                   L_P
    ceil(τ/2)                floor(τ/2)
    d ≤ √n                   d < √n
         \                     /
          \                   /
           -----> τ(n) <-----
```

```
    ζ(s)                    ζ(s)/ζ(2s)
     |                           |
  Všechna n                 Squarefree n
  (bosony)                  (fermiony)
     |                           |
     v                           v
  Z_B = ζ(β)               Z_F = ζ(β)/ζ(2β)
```

**Chybějící spojení:**
```
    L_P(s) = (ζ² - ζ(2s))/2
         |
         ?
         |
    Fermionová interpretace NEEXISTUJE
    (degenerace párů)
```

---

## ZÁVĚR: Co je skutečně nové? (po adversarial check)

### Určitě nové:
1. **Negativní výsledek:** Fermionová algebra na párech dělitelů NEFUNGUJE
2. **Diagnóza:** Důvod selhání = sdílené prvočíselné faktory mezi páry
3. **Pokus o opravu přes $\mathbb{Z}[i]$** — také nefunguje, degenerace přetrvává

### Možná nové (ale hodnota nejasná):
1. Explicitní interpretace $P(n) = \dim V_n^-$ (antisymetrický prostor involuce)
2. Vnořený radikál $A(s) = L_P(s) + \sqrt{2L_P(2s) + \sqrt{\cdots}}$ — algebraicky triviální, ale možná esteticky zajímavá reprezentace

### Určitě NENÍ nové:
1. Primon gas a jeho partiční funkce $Z_F = \zeta/\zeta(2s)$
2. Identita $\zeta^2 - \zeta(2s)$ (implicitní v A038548)
3. Bost-Connes systém
4. **"Z_F z L_P"** — je to jen algebraická manipulace, neobchází výpočet zeta

---

## OTEVŘENÁ OTÁZKA

> Existuje fyzikální/algebraická interpretace $L_P(s)$?

$L_P$ není partiční funkce primon gas, ale je úzce související. Možné směry:
- Korelační funkce?
- Dvou-částicový sektor?
- Jiná statistika (anyon, parastatistika)?

Toto zůstává **otevřené**.
