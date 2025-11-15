# Log-Sum-Exp Trick: Numerická Stabilizace

## Problém: Numerický Overflow/Underflow

Při výpočtu logaritmu sumy exponenciál:

$$\log \sum_{i=1}^{n} \exp(x_i)$$

mohou nastat problémy:
- **Overflow**: Pokud některé $x_i \gg 0$, pak $\exp(x_i)$ přeteče
- **Underflow**: Pokud všechna $x_i \ll 0$, pak $\exp(x_i) \approx 0$ a ztratíme přesnost

## Řešení: Log-Sum-Exp Trick

**Klíčový postřeh:** Využijeme identity:

$$\log \sum_{i=1}^{n} \exp(x_i) = M + \log \sum_{i=1}^{n} \exp(x_i - M)$$

kde $M = \max_i(x_i)$.

**Proč to funguje:**
- Největší člen je $\exp(M - M) = \exp(0) = 1$
- Všechny ostatní členy $\exp(x_i - M) \leq 1$ (žádný overflow)
- Suma je $\geq 1$ (minimálně jeden člen je 1), takže log je definován

**Odvození:**
$$\log \sum_{i=1}^{n} \exp(x_i) = \log \left(\exp(M) \sum_{i=1}^{n} \exp(x_i - M)\right) = M + \log \sum_{i=1}^{n} \exp(x_i - M)$$

## Speciální Případ: Log(1 + exp(x))

Funkce $f(x) = \log(1 + \exp(x))$ (známá jako "softplus") má problémy:
- Pro $x \gg 0$: $\exp(x)$ overflow
- Pro $x \ll 0$: $\exp(x) \approx 0 \Rightarrow \log(1) = 0$ (ztráta přesnosti)

**Stabilní formulace:**

$$\log(1 + \exp(x)) = \max(0, x) + \log(1 + \exp(-|x|))$$

**Nebo po částech:**
```
softplus(x) = {
    x                  if x > 20        (exp(x) dominuje)
    log(1 + exp(x))    if -20 ≤ x ≤ 20  (bezpečný rozsah)
    exp(x)             if x < -20       (1 dominuje)
}
```

## Aplikace: Soft-Minimum v Primal Forest

### Původní (nestabilní) vzorec

Vzdálenost od stromů na hloubce $p$:

$$d_p^{\text{soft}}(x) = -\beta \log \sum_{k=0}^{\lfloor x/p \rfloor} \exp\left(-\frac{|x - (kp + p^2)|^2}{\beta}\right)$$

**Problém:** Pro velké vzdálenosti $|x - (kp + p^2)|$, člen $\exp(-d^2/\beta)$ underflowuje.

### Stabilizovaný vzorec

**Krok 1:** Najdi maximum mezi exponenty:

$$M_p(x) = \max_{k=0,\ldots,\lfloor x/p \rfloor} \left(-\frac{|x - (kp + p^2)|^2}{\beta}\right) = -\frac{\min_{k} |x - (kp + p^2)|^2}{\beta}$$

**Krok 2:** Aplikuj log-sum-exp:

$$d_p^{\text{soft}}(x) = -\beta \left(M_p(x) + \log \sum_{k=0}^{\lfloor x/p \rfloor} \exp\left(-\frac{|x - (kp + p^2)|^2}{\beta} - M_p(x)\right)\right)$$

**Simplifikace:**

$$d_p^{\text{soft}}(x) = \min_k |x - (kp + p^2)|^2 - \beta \log \sum_{k=0}^{\lfloor x/p \rfloor} \exp\left(-\frac{|x - (kp + p^2)|^2 - \min_j |x - (jp + p^2)|^2}{\beta}\right)$$

**Výhoda:**
- V exponenciále jsou jen rozdíly vzdáleností, největší je 0
- Všechny exponenty jsou $\leq 1$
- Žádný overflow ani underflow

## Implementace v Wolfram Language

### Nestabilní verze (pouze pro malá x a symbolické výpočty):

```mathematica
DistanceProductSoftSquared[x_, β_: 1] :=
  Product[
    -β * Log @ Sum[
      Exp[-(x - (k*p + p^2))^2/β],
      {k, 0, Floor[x/p]}
    ],
    {p, 2, x}
  ]
```

### Stabilní verze s log-sum-exp:

```mathematica
(* Pomocná funkce: log-sum-exp pro seznam *)
LogSumExp[list_, β_] := Module[{M, shifted},
  M = Max[list];
  shifted = (list - M)/β;
  M + β * Log[Total[Exp[shifted]]]
]

(* Stabilní soft-minimum pro jeden p *)
SoftMinDistanceSquared[x_, p_, β_] := Module[{distances, negDistSq, M},
  (* Vzdálenosti na čtverec pro všechna k *)
  distances = Table[(x - (k*p + p^2))^2, {k, 0, Floor[x/p]}];

  (* Negativní vzdálenosti^2 / β (argumenty exp) *)
  negDistSq = -distances/β;

  (* Maximum (nejmenší penalizace) *)
  M = Max[negDistSq];

  (* Stabilní výpočet *)
  -β * (M + Log[Total[Exp[negDistSq - M]]])
]

(* Celkové skóre *)
DistanceProductSoftSquaredStable[x_, β_: 1] :=
  Product[SoftMinDistanceSquared[x, p, β], {p, 2, x}]
```

### Optimalizovaná verze (s ořezáním):

Pro ještě větší stabilitu můžeme ignorovat vzdálené body, které stejně nepřispívají:

```mathematica
SoftMinDistanceSquaredOptimized[x_, p_, β_, cutoff_: 5] := Module[
  {distances, negDistSq, M, threshold, validIndices},

  (* Všechny vzdálenosti *)
  distances = Table[(x - (k*p + p^2))^2, {k, 0, Floor[x/p]}];
  negDistSq = -distances/β;
  M = Max[negDistSq];

  (* Ořízni členy kde exp(negDistSq - M) < exp(-cutoff) *)
  threshold = M - cutoff;
  validIndices = Select[Range[Length[negDistSq]], negDistSq[[#]] > threshold &];

  (* Sečti jen validní členy *)
  -β * (M + Log[Total[Exp[negDistSq[[validIndices]] - M]]])
]
```

## Reference

- Wikipedia: [LogSumExp](https://en.wikipedia.org/wiki/LogSumExp)
- Murphy, K. P. (2012). Machine Learning: A Probabilistic Perspective. MIT Press.
- Blanchard, P., Higham, D. J., & Higham, N. J. (2021). Accurately computing the log-sum-exp and softmax functions. *IMA Journal of Numerical Analysis*.
