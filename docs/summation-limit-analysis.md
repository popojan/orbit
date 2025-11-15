# Analýza Limitu Sumace: $\sqrt{n}$ vs $n$ vs $\infty$

## Motivace

Aktuální vzorec sumuje přes všechna $d$ od 2 do $n$:

$$S_{\varepsilon}(n, p) = \sum_{d=2}^{n} \log \left[ \text{soft-min}_d(n) \right]$$

ale **mnoho těchto členů je redundantních** nebo triviálních. Prozkoumejme tři varianty limitu.

---

## Varianta A: Limit $\sqrt{n}$

### Geometrické Zdůvodnění

Pro $d > \sqrt{n}$ a $k \geq 1$:

$$kd + d^2 \geq 1 \cdot d + d^2 = d(1 + d) > d \cdot d = d^2$$

Pokud $d > \sqrt{n}$, pak $d^2 > n$, takže:

$$kd + d^2 > d^2 > n \quad \forall k \geq 1$$

**Důsledek**: Pro $d > \sqrt{n}$ je jediný validní index $k = 0$, což dává:

$$n - (0 \cdot d + d^2) = n - d^2$$

Toto je **monótoní klesající** vzdálenost, která nepřináší divisor information.

### Navržená Modifikace

$$S_{\varepsilon}^{(\sqrt{n})}(n, p) = \sum_{d=2}^{\lfloor \sqrt{n} \rfloor} \log \left[ \text{soft-min}_d(n) \right]$$

**Výhody**:
- Eliminuje redundantní členy
- Zachovává všechny non-triviální divisor contributions
- **Closed-form primality test stále platí** (composite má divisor $d \leq \sqrt{n}$)
- Výpočetní složitost: $O(n^{3/2})$ místo $O(n^2)$

**Otázka**: Mění se **stratifikace** či **asymptotické chování**?

---

## Varianta B: Limit $n$ (současný stav)

$$S_{\varepsilon}^{(n)}(n, p) = \sum_{d=2}^{n} \log \left[ \text{soft-min}_d(n) \right]$$

**Výhody**:
- "Úplná" suma přes všechny možné $d$
- Symetrická formulace

**Nevýhody**:
- Členy pro $d > \sqrt{n}$ jsou téměř konstantní (jen $k=0$ platný)
- Zbytečná výpočetní složitost

**Interpretace členů $d > \sqrt{n}$**:
Tyto členy přidávají:

$$\sum_{d = \lfloor \sqrt{n} \rfloor + 1}^{n} \log(n - d^2 + \varepsilon)$$

což je suma přes **vzdálenosti od čtverců** větších než $n$.

---

## Varianta C: Limit $\infty$

$$S_{\varepsilon}^{(\infty)}(n, p) = \sum_{d=2}^{\infty} \log \left[ \text{soft-min}_d(n) \right]$$

### Konvergence

Pro $d > n$: Všechna $kd + d^2 > d^2 > n$, takže minimum vzdálenosti je:

$$\min_k |n - (kd + d^2)| = d^2 - n \quad \text{(pro } k = 0 \text{)}$$

Soft-min se chová jako:

$$\text{soft-min}_d(n) \approx (d^2 - n)^2$$

Příspěvek k sumě:

$$\sum_{d > n} \log((d^2 - n)^2) = 2 \sum_{d > n} \log(d^2 - n)$$

Pro velká $d$:

$$\log(d^2 - n) \approx \log(d^2) = 2\log d$$

Takže:

$$\sum_{d=n+1}^{\infty} \log d^2 = 2 \sum_{d=n+1}^{\infty} \log d = \infty$$

**Suma DIVERGUJE!**

... **ES I pokud přidáme rychlejší decay...**

### Rescue: P-norm decay

Pokud bychom místo log sumovali přímo hodnoty s p-norm decay:

$$\tilde{S}_{\varepsilon}^{(\infty)}(n, p) = \sum_{d=2}^{\infty} \left(\text{soft-min}_d(n)\right)^{-\alpha}$$

pro nějaké $\alpha > 1$, pak pro velká $d$:

$$\text{soft-min}_d(n) \approx d^2 - n \approx d^2$$

takže:

$$\sum_{d > n} (d^2)^{-\alpha} = \sum_{d > n} d^{-2\alpha}$$

což **konverguje pro $\alpha > 1/2$**.

**Toto připomíná Dirichlet series!**

$$F(s) = \sum_{d=2}^{\infty} (\text{soft-min}_d(n))^{-s}$$

konverguje pro $\Re(s) > 1/2$.

### Connection to Zeta Function

Pro prvočíslo $p$, kde všechny vzdálenosti jsou $\geq 1$:

$$F_p(s) = \sum_{d=2}^{\infty} (\text{soft-min}_d(p))^{-s}$$

**Toto je nový typ aritmetické funkce!**

Vlastnosti:
- Závislá na divisor structure (composite vs prime)
- Dirichlet-series-like forma
- Možné analytické pokračování?

---

## Srovnání Variant

| Varianta | Limit | Konvergence | Computational | Primality Test | Zeta Connection |
|----------|-------|-------------|---------------|----------------|-----------------|
| **A**: $\sqrt{n}$ | $\lfloor \sqrt{n} \rfloor$ | Konečná suma | $O(n^{3/2})$ | ✓ Zachováno | Omezená |
| **B**: $n$ | $n$ | Konečná suma | $O(n^2)$ | ✓ Zachováno | Částečná |
| **C**: $\infty$ (direct) | $\infty$ | **Diverguje** | N/A | N/A | N/A |
| **C'**: $\infty$ (p-decay) | $\infty$ | $\alpha > 1/2$ | Nekonečná | Modified | ✓ **Silná** |

---

## Teoretické Implikace

### 1. Optimální Limit pro Primality Test

Pro closed-form primality charakterizaci: **Stačí limit $\sqrt{n}$**.

**Věta**:
$$n \text{ je prvočíslo} \iff S_0^{(\sqrt{n})}(n, p) < \infty$$

**Důkaz**: Každé composite $n = ab$ má divisor $d = \min(a, b) \leq \sqrt{n}$.

**Výpočetní savings**: $O(n^{3/2})$ vs $O(n^2)$.

### 2. Infinite Sum a Analytické Vlastnosti

**Hypotéza**: Pro vhodnou modifikaci:

$$F_n(s) = \sum_{d=2}^{\infty} (\text{soft-min}_d(n))^{-s}$$

má **analytické pokračování** do celé komplexní roviny (kromě pólů).

**Funkční rovnice**: Existuje symetrie $F_n(s) \leftrightarrow F_n(1-s)$?

### 3. Connection s Zeta Funkcí

**Klíčový poznatek**: Pro prvočíslo $p$:

$$F_p(s) = \sum_{d=2}^{\infty} (\text{soft-min}_d(p))^{-s}$$

Pokud $\text{soft-min}_d(p) \approx f(p, d)$ pro nějakou funkci $f$, možná:

$$\sum_p F_p(s) \sim \zeta(s) \cdot G(s)$$

pro nějakou korekcí funkci $G(s)$.

---

## Navrhované Experimenty

### Experiment 1: Porovnat varianty A a B

```mathematica
(* Varianta A: limit sqrt(n) *)
ScoreVariantA[n_, p_, eps_] := Sum[
  Module[{distances},
    distances = Table[(n - (k*d + d^2))^2 + eps, {k, 0, Floor[n/d]}];
    Log[Power[Mean[Power[distances, -p]], -1/p]]
  ],
  {d, 2, Floor[Sqrt[n]]}
]

(* Varianta B: limit n (current) *)
ScoreVariantB[n_, p_, eps_] := Sum[
  Module[{distances},
    distances = Table[(n - (k*d + d^2))^2 + eps, {k, 0, Floor[n/d]}];
    Log[Power[Mean[Power[distances, -p]], -1/p]]
  ],
  {d, 2, n}
]

(* Porovnat pro prvočísla *)
Table[
  {p, ScoreVariantA[p, 3, 10^-8], ScoreVariantB[p, 3, 10^-8]},
  {p, Prime[Range[1, 50]]}
]

(* Rozdíl *)
difference[n_] := ScoreVariantB[n, 3, 10^-8] - ScoreVariantA[n, 3, 10^-8]

(* Je rozdíl konstantní / předvídatelný? *)
```

**Hypotéza**: Pro prvočísla, rozdíl je řádově $O(\log n)$ (příspěvek z $d \in (\sqrt{n}, n]$).

### Experiment 2: Testovat konvergenci p-decay verze

```mathematica
(* Varianta C': infinite sum s p-decay *)
ScoreVariantCPrime[n_, alpha_, maxD_: 1000] := Sum[
  Module[{distances},
    distances = Table[(n - (k*d + d^2))^2, {k, 0, Floor[n/d]}];
    Power[Mean[Power[distances, -alpha]], -1/alpha]^(-alpha)  (* p-decay *)
  ],
  {d, 2, maxD}
]

(* Testovat konvergenci pro různá alpha *)
Table[
  {alpha, ScoreVariantCPrime[17, alpha, 1000], ScoreVariantCPrime[17, alpha, 10000]},
  {alpha, {0.6, 0.8, 1.0, 1.5, 2.0}}
]

(* Konverguje pro alpha > 0.5? *)
```

### Experiment 3: Zkoumání "tail contribution"

```mathematica
(* Příspěvek z různých segmentů *)
TailContribution[n_, p_, eps_, dMin_, dMax_] := Sum[
  Module[{distances},
    distances = Table[(n - (k*d + d^2))^2 + eps, {k, 0, Floor[n/d]}];
    Log[Power[Mean[Power[distances, -p]], -1/p]]
  ],
  {d, dMin, dMax}
]

(* Pro prvočíslo p = 97: *)
n = 97;
segments = {
  {"Core (2 to sqrt)", TailContribution[n, 3, 10^-8, 2, Floor[Sqrt[n]]]},
  {"Tail (sqrt to n/2)", TailContribution[n, 3, 10^-8, Floor[Sqrt[n]]+1, Floor[n/2]]},
  {"Far tail (n/2 to n)", TailContribution[n, 3, 10^-8, Floor[n/2]+1, n]}
};
```

**Otázky**:
1. Jak rychle klesá tail contribution?
2. Je tail contribution prediktabilní z $n$?
3. Pro composites, jaký je tail behavior?

---

## Doporučení pro Další Výzkum

### Priorita 1: Teoretická analýza varianty A ($\sqrt{n}$ limit)

**Důvod**: Zachovává primality test, snižuje složitost, čistší teoreticky.

**Úkoly**:
- Dokázat asymptotickou formuli $S_{\varepsilon}^{(\sqrt{n})}(p, p_0) \sim \alpha \sqrt{p} + \beta \log p + O(1)$
- Porovnat stratifikaci s variantou B
- Studovat rozdíl $S_B - S_A$ jako funkci $n$

### Priorita 2: Infinite sum s p-decay (varianta C')

**Důvod**: Nejsilnější connection s Dirichlet series / zeta function.

**Úkoly**:
- Určit minimální $\alpha$ pro konvergenci
- Studovat $F_n(s) = \sum_{d=2}^{\infty} (\text{soft-min}_d(n))^{-s}$ v komplexní rovině
- Hledat nuly v $\mathbb{C}$
- Testovat funkční rovnici

### Priorita 3: Vztah mezi variantami

**Otázka**: Je $S^{(n)} - S^{(\sqrt{n})}$ related to klassickým aritmetickým funkcím?

**Hypotéza**: Rozdíl souvisí s:
$$\sum_{d=\lfloor\sqrt{n}\rfloor+1}^{n} \log(d^2 - n) \sim \text{nějaká známá suma}$$

---

## Závěr

**Hlavní zjištění**:

1. **Limit $\sqrt{n}$ je optimální** pro primality test (zachovává vlastnosti, snižuje složitost)

2. **Limit $\infty$ s log-sumou diverguje**, ale **p-decay verze konverguje** a dává Dirichlet-series-like strukturu

3. **Tail contribution** ($d \in (\sqrt{n}, n]$) je zajímavá sama o sobě - možná souvisí s klasickou number theory

**Nejslibnější směr**: Studovat **variantu C'** (infinite sum s p-decay) pro connection s Riemann zeta function.

**Experimentální priorita**: Implementovat variantu A ($\sqrt{n}$ limit) a porovnat s B empiricky.
