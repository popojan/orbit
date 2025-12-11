# Claude Shannon and Information Theory

## Life and Work

**Claude Elwood Shannon** (April 30, 1916, Petoskey, Michigan – February 24, 2001, Medford, Massachusetts) was an American mathematician, electrical engineer, and cryptographer known as the **"father of information theory"**.

### Education

- **University of Michigan** (1932–1936): B.S. in Electrical Engineering and Mathematics
- **MIT** (1936–1940): S.M. in Electrical Engineering (1937), Ph.D. in Mathematics (1940)
- Worked under Vannevar Bush on the differential analyzer (early analog computer)

### Career

- **Bell Laboratories** (1941–1972): Research mathematician
- **MIT** (1956–1978): Donner Professor of Science, then Professor Emeritus
- During WWII: Cryptography work on secure communications

### Family

- Married **Mary Elizabeth Moore (Betty)** in 1949
- Betty was a numerical analyst at Bell Labs, collaborated on many inventions
- Three children: Robert J. (computer engineer), Andrew M. (musician), Margarita C. (geologist)
- Distant relative of Thomas Edison

---

## Key Contributions

### 1. Boolean Algebra for Circuits (1937)

**"A Symbolic Analysis of Relay and Switching Circuits"** — Master's thesis, MIT

- Demonstrated that Boolean algebra could design electrical switching circuits
- Proved relay arrangements could solve Boolean algebra problems
- Transformed digital circuit design from art to science
- Called "the most important master's thesis of the 20th century" (Herman Goldstine)

**Impact**: This is the theoretical foundation of ALL digital computers.

### 2. Information Theory (1948)

**"A Mathematical Theory of Communication"** — Bell System Technical Journal

- Introduced **entropy** as measure of information content
- Defined the **bit** as unit of information (credited John Tukey for the name)
- Proved fundamental limits on data compression (source coding theorem)
- Proved fundamental limits on reliable transmission (channel capacity theorem)

Called "Magna Carta of the Information Age" by Scientific American.

---

## The Shannon Entropy Formula

For a discrete random variable X with probabilities p₁, p₂, ..., pₙ:

```
H(X) = -Σ pᵢ log₂(pᵢ)
```

**Key properties**:
- H(X) ≥ 0 (entropy is non-negative)
- H(X) = 0 iff X is deterministic (no uncertainty)
- H(X) is maximized when all outcomes equally likely
- Units: bits (when using log₂)

**Example**: Fair coin flip
```
H = -[0.5·log₂(0.5) + 0.5·log₂(0.5)] = -[-0.5 - 0.5] = 1 bit
```

---

## Shannon vs. Kolmogorov Complexity

| Aspect | Shannon Entropy | Kolmogorov Complexity |
|--------|-----------------|----------------------|
| **Measures** | Average information from known source | Shortest program producing specific string |
| **Requires** | Known probability distribution | Universal Turing machine |
| **Computable** | Yes | No (undecidable in general) |
| **Domain** | Random variables, ensembles | Individual strings |
| **Application** | Communication channel design | Algorithmic randomness |

**Connection**: For random strings, Kolmogorov complexity ≈ Shannon entropy.

For structured data (like Fibonacci rationals), Kolmogorov complexity << Shannon entropy.

---

## Source Coding Theorem

**Shannon's First Theorem** (Noiseless Coding Theorem):

> The expected length of any uniquely decodable code for a source X is at least H(X) bits per symbol.

**Implication**: You cannot compress below entropy on average, but you can get arbitrarily close.

**Example**: English text has ~1.0-1.5 bits/character of entropy (due to redundancy), even though ASCII uses 8 bits/character. This is why text compresses well.

---

## Channel Capacity Theorem

**Shannon's Second Theorem** (Noisy Channel Coding Theorem):

> For any channel with capacity C, it is possible to transmit information at any rate R < C with arbitrarily small error probability.

**The Shannon Limit**: For a channel with bandwidth W and signal-to-noise ratio S/N:

```
C = W · log₂(1 + S/N)  bits/second
```

**Implication**: There exists a theoretical maximum rate for error-free communication. Modern codes (LDPC, Turbo codes) approach this limit.

---

## Awards and Recognition

- **Alfred Noble Prize** (1939) — for master's thesis
- **National Medal of Science** (1966)
- **IEEE Medal of Honor** (1966)
- **Harvey Prize** (1972)
- **Kyoto Prize** (1985) — "Japan's equivalent of the Nobel"

---

## Personal Character

Shannon was known as a playful tinkerer:

- **Unicycled through Bell Labs hallways while juggling**
- Built chess-playing machines, maze-solving robots
- Created "Theseus" — a learning machine (mouse that solved mazes), with Betty
- Studied stock market mathematics with Betty
- Maintained childlike curiosity throughout life

> "I just wondered how things were put together."
> — Claude Shannon

---

## Historical Context

### Precursors
- **Harry Nyquist** (1920s): Sampling theorem foundations
- **Ralph Hartley** (1928): Logarithmic measure of information
- **Alan Turing** (1936): Computability theory

### Timeline
- **1937**: Boolean algebra thesis (age 21)
- **1939**: Letter to Bush outlining information theory ideas
- **1943-1945**: Secret cryptography work (met Turing at Bell Labs)
- **1948**: "A Mathematical Theory of Communication" published
- **1949**: Paper republished as book with Warren Weaver's introduction

### Later Developments
- **1965**: Kolmogorov formalizes algorithmic complexity
- **1969**: Chaitin independently develops algorithmic information theory
- Modern coding theory approaches Shannon limits

---

## Legacy

Shannon's work enables:
- Digital computers (Boolean circuits)
- Data compression (ZIP, MP3, JPEG)
- Error correction (CDs, DVDs, QR codes, 5G)
- Cryptography (quantifying security)
- Machine learning (cross-entropy loss)

Historian James Gleick rated Shannon's 1948 paper as more important than the transistor — "even more profound and more fundamental."

---

## Sources

- [Wikipedia: Claude Shannon](https://en.wikipedia.org/wiki/Claude_Shannon)
- [MIT News: MIT Professor Claude Shannon dies](https://news.mit.edu/2001/shannon)
- [IEEE Spectrum: Claude Shannon biography](https://spectrum.ieee.org/claude-shannon-tinkerer-prankster-and-father-of-information-theory)
- [Britannica: Claude Shannon](https://www.britannica.com/biography/Claude-Shannon)
- [Kyoto Prize: Claude Elwood Shannon](https://www.kyotoprize.org/en/laureates/claude_elwood_shannon/)
- [Wikipedia: A Mathematical Theory of Communication](https://en.wikipedia.org/wiki/A_Mathematical_Theory_of_Communication)
- [Wikipedia: A Symbolic Analysis of Relay and Switching Circuits](https://en.wikipedia.org/wiki/A_Symbolic_Analysis_of_Relay_and_Switching_Circuits)
