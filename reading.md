# Reading Notes: Prime Gap Theory

## Ford, Green, Konyagin, and Tao (2016)

**Full citation:** Kevin Ford, Ben Green, Sergei Konyagin, and Terence Tao. "Large gaps between consecutive prime numbers". *Annals of Mathematics*, 183(3), 935–974 (2016).

**DOI:** https://doi.org/10.4007/annals.2016.183.3.3
**arXiv:** https://arxiv.org/abs/1408.4505

### Main Result

They proved that the largest gap $G(X)$ between consecutive primes below $X$ satisfies:

$$G(X) \geq f(X) \cdot \frac{\log X \cdot \log \log X \cdot \log \log \log \log X}{(\log \log \log X)^2}$$

where $f(X)$ is a function tending to infinity with $X$.

### Significance

- Addresses a classical question of Erdős about how large prime gaps can grow
- Shows gaps grow **faster** than previously proven lower bounds
- Provides concrete quantitative bounds approaching (but not reaching) Cramér's conjectured $O((\log p)^2)$ upper bound
- Major improvement over previous Erdős-Rankin constructions

### Method and Techniques

- Combines classical gap construction techniques (Erdős-Rankin method) with modern results
- Uses breakthrough work on **arithmetic progressions of primes** (building on Green-Tao theorem)
- Employs random constructions covering sets of primes by arithmetic progressions
- Leverages recent advances in understanding long arithmetic progressions consisting entirely of primes

### Exponential Distribution Heuristic

The paper discusses the **exponential distribution heuristic** for prime gaps:

- Under probabilistic models (Cramér's random model), normalized prime gaps $(p_{n+1} - p_n) / \log p_n$ behave approximately like an exponential distribution with mean $1$
- This means gaps of size $C \log p_n$ occur for about $e^{-C} \pi(X)$ primes $\leq X$ for any fixed $C > 0$
- Gallagher showed that if the Hardy-Littlewood conjecture holds, then prime gaps would be asymptotically distributed according to an exponential distribution
- Most gaps cluster near the mean $\ln(p)$, but rare large gaps exist

### Connection to Gap Theorem and Prime DAG

- The exponential distribution heuristic predicts most primes have gaps $\sim \ln(p)$
- By the Gap Theorem, this means most primes have in-degree $\sim \ln(p)$ in the DAG
- Rare large gaps (predicted by the exponential tail) correspond to **hub primes** with large in-degrees
- The Ford-Green-Konyagin-Tao result shows these rare hubs can have in-degree approaching $(\log p)^2$
- The distribution of in-degrees in the prime DAG mirrors the distribution of prime gaps

### Historical Context

**Timeline of lower bounds on large gaps:**

1. Erdős-Rankin method (classical): $G(X) \geq c \log X \log \log X$
2. Various improvements with additional log factors
3. Ford-Green-Konyagin-Tao (2016):
   $$G(X) \geq f(X) \cdot \frac{\log X \cdot \log \log X \cdot \log \log \log \log X}{(\log \log \log X)^2}$$

**Upper bounds:**

- Cramér's conjecture (unproven): $G(X) = O((\log X)^2)$
- Granville's correction: $G(X) = O((\log X)^2)$ with constant $2e^{-\gamma} \approx 1.12$
- Best unconditional bound: $g_n \leq p_n^{0.525}$ (Baker-Harman-Pintz, 2001)

### Publication Details

- **Received:** August 30, 2014
- **Revised:** August 3, 2015
- **Accepted:** August 23, 2015
- **Published online:** April 19, 2016
- **Journal:** Annals of Mathematics, Volume 183, Issue 3, pages 935-974

### Related Work

- James Maynard (2016): Complementary work on large gaps, published in same volume of Annals
- Green-Tao theorem on arithmetic progressions in primes (foundational)
- Banks-Ford-Tao: Probabilistic framework for prime gap questions
