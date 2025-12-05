# Character Sums over Finite Fields

**Date:** December 5, 2025
**Purpose:** Introduction to multiplicative character sums and their applications

---

## 1. Definitions

### Multiplicative Characters

Let $\mathbb{F}_q$ be a finite field with $q = p^n$ elements. A **multiplicative character** is a group homomorphism:

$$\chi: \mathbb{F}_q^* \to \mathbb{C}^*$$

Extended to all of $\mathbb{F}_q$ by setting $\chi(0) = 0$.

**Properties:**
- The multiplicative group $\mathbb{F}_q^*$ is cyclic of order $q-1$
- There are exactly $q-1$ distinct characters
- The **principal character** $\chi_0$ satisfies $\chi_0(a) = 1$ for all $a \neq 0$
- Characters form a group under pointwise multiplication

**Reference:** Ireland & Rosen, *A Classical Introduction to Modern Number Theory*, Chapter 8, §1 ([Springer](https://link.springer.com/book/10.1007/978-1-4757-2103-4))

### The Legendre Symbol

The simplest non-trivial character is the **quadratic character** (Legendre symbol):

$$\chi(a) = \left(\frac{a}{p}\right) = \begin{cases} 1 & \text{if } a \text{ is a quadratic residue mod } p \\ -1 & \text{if } a \text{ is a quadratic non-residue mod } p \\ 0 & \text{if } a \equiv 0 \end{cases}$$

**Key property (Euler's criterion):**
$$\left(\frac{a}{p}\right) \equiv a^{(p-1)/2} \pmod{p}$$

---

## 2. Gauss Sums

### Definition

For a multiplicative character $\chi$ and an additive character $\psi(x) = e^{2\pi i x/p}$, the **Gauss sum** is:

$$\tau(\chi) = \sum_{a \in \mathbb{F}_p^*} \chi(a) \psi(a) = \sum_{a=1}^{p-1} \chi(a) e^{2\pi i a/p}$$

### Fundamental Property

For non-trivial $\chi$:
$$|\tau(\chi)|^2 = p$$

Therefore $|\tau(\chi)| = \sqrt{p}$.

**Reference:** Ireland & Rosen, Chapter 8, §2

### Quadratic Gauss Sum

For the Legendre symbol:
$$\tau = \sum_{a=1}^{p-1} \left(\frac{a}{p}\right) e^{2\pi i a/p}$$

**Explicit evaluation:**
$$\tau^2 = \left(\frac{-1}{p}\right) p = \begin{cases} p & \text{if } p \equiv 1 \pmod{4} \\ -p & \text{if } p \equiv 3 \pmod{4} \end{cases}$$

This gives $\tau = \pm\sqrt{p}$ or $\tau = \pm i\sqrt{p}$ depending on $p \mod 4$.

**Reference:** [Matt Baker's Math Blog: The Sign of the Quadratic Gauss Sum](https://mattbaker.blog/2015/04/30/the-sign-of-the-quadratic-gauss-sum-and-quadratic-reciprocity/)

---

## 3. Applications

### 3.1 Quadratic Reciprocity

Gauss sums provide one of the most elegant proofs of quadratic reciprocity.

**Theorem (Quadratic Reciprocity):** For distinct odd primes $p, q$:
$$\left(\frac{p}{q}\right)\left(\frac{q}{p}\right) = (-1)^{\frac{p-1}{2}\frac{q-1}{2}}$$

**Proof sketch using Gauss sums:**
1. Define $\tau = \sum_{a=1}^{p-1} \left(\frac{a}{p}\right) \zeta_p^a$ where $\zeta_p = e^{2\pi i/p}$
2. Compute $\tau^q$ two ways:
   - Using $\tau^2 = \left(\frac{-1}{p}\right)p$
   - Using the binomial theorem and $\zeta_p^q$
3. Compare results modulo $q$

**Reference:** [Williams College notes](https://web.williams.edu/Mathematics/lg5/QRviaGaussSums.pdf), [Wikipedia: Proofs of quadratic reciprocity](https://en.wikipedia.org/wiki/Proofs_of_quadratic_reciprocity)

### 3.2 Counting Points on Curves

For a curve $C: y^2 = f(x)$ over $\mathbb{F}_p$:

$$\#C(\mathbb{F}_p) = p + \sum_{x \in \mathbb{F}_p} \left(\frac{f(x)}{p}\right)$$

The character sum directly gives the deviation from the "expected" count of $p$.

**Example (Elliptic curves):** For $E: y^2 = x^3 + ax + b$:
$$\#E(\mathbb{F}_p) = p + 1 - \sum_{x=0}^{p-1} \left(\frac{x^3+ax+b}{p}\right)$$

**Reference:** [Stanford Crypto notes on elliptic curves](https://crypto.stanford.edu/pbc/notes/elliptic/count.html)

### 3.3 Hasse-Weil Bound

**Theorem (Hasse, 1933):** For an elliptic curve $E$ over $\mathbb{F}_q$:
$$|q + 1 - \#E(\mathbb{F}_q)| \leq 2\sqrt{q}$$

**Equivalently:** The character sum $\sum_x \chi(f(x))$ satisfies $|\sum| \leq 2\sqrt{q}$.

**Historical note:** This is equivalent to the Riemann Hypothesis for the function field of $E$. Weil generalized this to arbitrary curves in 1948.

**Reference:** [MIT 18.783 Lecture Notes](https://math.mit.edu/classes/18.783/2017/LectureNotes8.pdf), [Wikipedia: Hasse's theorem](https://en.wikipedia.org/wiki/Hasse's_theorem_on_elliptic_curves)

### 3.4 Weil Bound (General)

**Theorem (Weil, 1948):** For a polynomial $f(x)$ of degree $d$ with $\gcd(d, p) = 1$:
$$\left|\sum_{x \in \mathbb{F}_p} \chi(f(x))\right| \leq (d-1)\sqrt{p}$$

This follows from Weil's proof of the Riemann Hypothesis for curves over finite fields.

**Reference:** A. Weil, "On some exponential sums", Proc. Nat. Acad. Sci. U.S.A. 34 (1948), 204-207. [Semantic Scholar](https://www.semanticscholar.org/paper/On-Some-Exponential-Sums.-Weil/e901626b9e8776f0f2ed435b875566a9a5ea75fc)

---

## 4. Kloosterman Sums

### Definition

$$K(a, b; p) = \sum_{x \in \mathbb{F}_p^*} e^{2\pi i (ax + bx^{-1})/p}$$

### Weil Bound for Kloosterman Sums

$$|K(a, b; p)| \leq 2\sqrt{p}$$

### Applications

1. **Cryptography:** Construction of Boolean functions with good cryptographic properties (bent functions, semi-bent functions)
2. **Coding Theory:** Weight distribution in dual Melas codes
3. **Automorphic Forms:** Fourier coefficients of modular forms

**Reference:** [Springer: On classical Kloosterman sums](https://link.springer.com/article/10.1007/s12095-019-00357-7), [IEEE: Binary Kloosterman Sums](https://ieeexplore.ieee.org/document/6126036/)

---

## 5. Jacobi Sums

### Definition

For characters $\chi, \psi$ modulo $p$:
$$J(\chi, \psi) = \sum_{a \in \mathbb{F}_p} \chi(a)\psi(1-a)$$

### Relation to Gauss Sums

For non-trivial $\chi, \psi$ with $\chi\psi$ also non-trivial:
$$J(\chi, \psi) = \frac{\tau(\chi)\tau(\psi)}{\tau(\chi\psi)}$$

### Application: Counting Solutions

The number of solutions to $x^n + y^n = 1$ in $\mathbb{F}_p$ can be expressed using Jacobi sums.

**Reference:** Ireland & Rosen, Chapter 8, §3-4

---

## 6. Pólya-Vinogradov Inequality

### Statement

For any non-principal character $\chi$ modulo $q$ and any $M, N$:
$$\left|\sum_{n=M+1}^{M+N} \chi(n)\right| < \sqrt{q} \log q$$

### Significance

- Gives bounds for **incomplete** character sums (not over full period)
- Proof is elementary (no algebraic geometry required)
- Later improved by Burgess (1957) for short intervals

**Reference:** Ireland & Rosen, Chapter 11

---

## 7. Summary: Why Character Sums Matter

| Application | Key Sum | Bound Used |
|-------------|---------|------------|
| Quadratic reciprocity | Gauss sum $\tau(\chi)$ | Exact: $|\tau|^2 = p$ |
| Point counting on curves | $\sum \chi(f(x))$ | Weil: $(d-1)\sqrt{p}$ |
| Elliptic curve crypto | $\sum \chi(x^3+ax+b)$ | Hasse: $2\sqrt{p}$ |
| Primes in progressions | Incomplete sums | Pólya-Vinogradov |
| Boolean functions | Kloosterman sums | Weil: $2\sqrt{p}$ |

---

## 8. Standard References

### Textbooks

1. **Ireland, K. & Rosen, M.** *A Classical Introduction to Modern Number Theory*, 2nd ed., Springer GTM 84, 1990.
   - Chapters 7-8: Finite fields, Gauss sums, Jacobi sums
   - [Springer Link](https://link.springer.com/book/10.1007/978-1-4757-2103-4)

2. **Lidl, R. & Niederreiter, H.** *Finite Fields*, 2nd ed., Cambridge University Press, 1997.
   - Comprehensive treatment of character sums
   - Standard reference for finite field theory

3. **Iwaniec, H. & Kowalski, E.** *Analytic Number Theory*, AMS Colloquium Publications, 2004.
   - Modern treatment of exponential sums
   - Chapters 11-12 on character sums

### Online Resources

- [Stanford Crypto: Elliptic Curve Point Counting](https://crypto.stanford.edu/pbc/notes/elliptic/count.html)
- [MIT 18.783: Elliptic Curves (Lecture Notes)](https://math.mit.edu/classes/18.783/2017/LectureNotes8.pdf)
- [University of Chicago REU: Counting Points on Elliptic Curves](http://math.uchicago.edu/~may/REU2018/REUPapers/Tang.pdf)
- [Matt Baker's Blog: Gauss Sums and Quadratic Reciprocity](https://mattbaker.blog/2015/04/30/the-sign-of-the-quadratic-gauss-sum-and-quadratic-reciprocity/)

---

## 9. Historical Timeline

| Year | Mathematician | Contribution |
|------|---------------|--------------|
| 1801 | Gauss | Quadratic reciprocity, Gauss sums |
| 1837 | Dirichlet | L-functions, primes in arithmetic progressions |
| 1896 | Aladov | Exact formulas for consecutive QR patterns |
| 1906 | Jacobsthal | Extended Aladov's results |
| 1918 | Pólya, Vinogradov | Elementary bound $O(\sqrt{q}\log q)$ |
| 1926 | Kloosterman | Kloosterman sums introduced |
| 1933 | Hasse | Bound for elliptic curves |
| 1948 | Weil | Optimal bound via Riemann hypothesis for curves |
| 1957 | Burgess | Improved bounds for short intervals |
