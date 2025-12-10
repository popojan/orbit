# Andrey Nikolayevich Kolmogorov (1903-1987)

**Life, Work, and the Theory of Algorithmic Complexity**

---

## Biography

### Early Life

**Born:** April 25, 1903 (April 12 O.S.), Tambov, Russia (~500 km SE of Moscow)
**Died:** October 20, 1987, Moscow (age 84)

Kolmogorov's mother died giving birth to him. He was raised by his maternal aunts and took his grandfather's family name. His father, Nikolai Kataev (son of a priest), was an agriculturist who was exiled and played no part in raising him.

Young Andrey grew up on his grandfather's estate in **Tunoshna** (near Yaroslavl). When he was seven, his aunt moved with him to **Moscow**, where he showed early interest in biology and history.

### Education

- **1920:** Enrolled simultaneously at Moscow State University (history & mathematics) and Mendeleev Chemical Engineering Institute (metallurgy)
- **1922:** International recognition for constructing a Fourier series that diverges almost everywhere
- **1929:** Ph.D. from Moscow State University

### Legacy

Considered one of the greatest mathematicians of the 20th century. Major contributions to:
- **Probability theory** (axiomatic foundations, 1933)
- **Turbulence** (Kolmogorov scaling)
- **Topology**
- **Information theory** (algorithmic complexity)
- **Mathematical logic**
- **Number theory**

---

## Kolmogorov Complexity

### The Fundamental Idea (1965)

**Definition:** The Kolmogorov complexity K(x) of an object x is the length of the shortest computer program (in a fixed programming language) that produces x as output.

### Historical Development

| Year | Contributor | Contribution |
|------|-------------|--------------|
| **1960** | Ray Solomonoff | First description at Caltech conference |
| **1964** | Solomonoff | Paper in *Information and Control* |
| **1965** | **Kolmogorov** | "Three approaches to the quantitative definition of information" |
| **1969** | Gregory Chaitin | Independent formulation in *J. ACM* |
| **1974** | Leonid Levin | Self-delimiting program variant |

Kolmogorov acknowledged Solomonoff's priority when he became aware of it. The field is now called **Solomonoff-Kolmogorov-Chaitin complexity** or **algorithmic information theory**.

### Key Insight

Classical probability theory cannot define randomness for individual objects (only for ensembles). Kolmogorov complexity provides an **objective, absolute** measure:

> x is random iff K(x) ≈ |x| (incompressible)

### Shannon vs Kolmogorov

| Aspect | Shannon Entropy | Kolmogorov Complexity |
|--------|-----------------|----------------------|
| **Measures** | Average information in random source | Information in specific object |
| **Requires** | Probability distribution | Universal Turing machine |
| **For n** | log₂(n) bits | Length of shortest program |
| **Structured data** | Same as random | Can be much smaller |

**Example:** The number 10^100 (googol)
- Shannon: log₂(10^100) ≈ 332 bits
- Kolmogorov: ~20 bits (`print(10**100)`)

---

## Application: Egypt Representation Compression

### Standard Egypt Tuples

For Fibonacci ratio F_k/F_{k+1}:
- Raw tuple storage: O(k²) bits
- Grows quadratically with index

### Kolmogorov-Egypt Compression

Store only: `(FIB, k)` = O(log k) bits

Decoder regenerates tuples:
```
(u_i, v_i) = (F_{2i-1}, F_{2i})
j_i = 1 (except last: j = 2 if k odd)
```

**Compression achieved:**

| k | Raw bits | Kolmogorov bits | Compression |
|---|----------|-----------------|-------------|
| 10 | 37 | 7 | 5.3× |
| 20 | 143 | 8 | 17.9× |
| 30 | 318 | 8 | **39.8×** |

---

## Philosophical Implications

### Uncomputability

K(x) is **not computable** - there is no algorithm that takes x and returns K(x). This follows from the halting problem.

However:
- Upper bounds are computable (just find any program that outputs x)
- Approximations useful in practice (compression algorithms)

### Randomness

A string is **Kolmogorov random** if it cannot be compressed:
> K(x) ≥ |x| - c

Most strings are random (by counting argument), but we cannot prove any specific string is random.

### Occam's Razor

Kolmogorov complexity formalizes Occam's razor: prefer simpler explanations.

> The best hypothesis for data x minimizes: K(H) + K(x|H)

(Description length of hypothesis + description of data given hypothesis)

---

## Further Reading

- Kolmogorov, A.N. (1965). "Three approaches to the quantitative definition of information." *Problems of Information and Transmission* 1(1):1-7.
- Li, M. and Vitányi, P. (2008). *An Introduction to Kolmogorov Complexity and Its Applications*. Springer.
- Cover, T. and Thomas, J. (2006). *Elements of Information Theory*. Wiley.

---

## Sources

- [Britannica: Andrey Nikolayevich Kolmogorov](https://www.britannica.com/biography/Andrey-Nikolayevich-Kolmogorov)
- [Wikipedia: Andrey Kolmogorov](https://en.wikipedia.org/wiki/Andrey_Kolmogorov)
- [MacTutor: Kolmogorov Biography](https://mathshistory.st-andrews.ac.uk/Biographies/Kolmogorov/)
- [Wikipedia: Kolmogorov complexity](https://en.wikipedia.org/wiki/Kolmogorov_complexity)
- [Scholarpedia: Algorithmic information theory](http://www.scholarpedia.org/article/Algorithmic_information_theory)
