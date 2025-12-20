# Pi Exploration: Interval Bounds and Iteration Methods

**Session:** 2025-12-20
**Status:** Open

## Context

Following successful exploration of:
- **√n**: Egypt/Chebyshev methods, Babylonian algorithm
- **e**: Bessel polynomials, CF structure, Stern-Brocot tree, Mediant bounds

Now exploring **π** with similar goals:
1. Rational interval bounds (like EulerEInterval)
2. Monotone convergence formulas
3. Self-referential iterations (like Babylonian for √, Newton for e)
4. Connections to known series/algorithms

---

## Known Approaches for π

### 1. Continued Fraction
$$\pi = 3 + \cfrac{1}{7 + \cfrac{1}{15 + \cfrac{1}{1 + \cfrac{1}{292 + \cdots}}}}$$

CF of π is **irregular** (unlike e which has pattern [2; 1, 2k, 1]).

First terms: [3; 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, ...]

### 2. Machin-type Formulas
$$\frac{\pi}{4} = 4\arctan\frac{1}{5} - \arctan\frac{1}{239}$$

Uses arctangent series: $\arctan(x) = x - x^3/3 + x^5/5 - \cdots$

### 3. Ramanujan/Chudnovsky Series
$$\frac{1}{\pi} = \frac{12}{640320^{3/2}} \sum_{k=0}^{\infty} \frac{(-1)^k (6k)! (545140134k + 13591409)}{(3k)!(k!)^3 640320^{3k}}$$

~14 digits per term (fastest known series).

### 4. BBP Formula (Bailey-Borwein-Plouffe)
$$\pi = \sum_{k=0}^{\infty} \frac{1}{16^k} \left( \frac{4}{8k+1} - \frac{2}{8k+4} - \frac{1}{8k+5} - \frac{1}{8k+6} \right)$$

Allows computing hex digits of π without prior digits.

### 5. Gauss AGM (Arithmetic-Geometric Mean)
$$\pi = \frac{4 \cdot \text{AGM}(1, 1/\sqrt{2})^2}{1 - \sum_{j=1}^{\infty} 2^{j+1}(a_j^2 - b_j^2)}$$

Quadratic convergence (~doubles digits each iteration).

### 6. Wallis Product
$$\frac{\pi}{2} = \prod_{n=1}^{\infty} \frac{4n^2}{4n^2 - 1} = \frac{2}{1} \cdot \frac{2}{3} \cdot \frac{4}{3} \cdot \frac{4}{5} \cdot \frac{6}{5} \cdot \frac{6}{7} \cdots$$

Slow convergence, but elegant.

### 7. Viète's Formula
$$\frac{2}{\pi} = \frac{\sqrt{2}}{2} \cdot \frac{\sqrt{2 + \sqrt{2}}}{2} \cdot \frac{\sqrt{2 + \sqrt{2 + \sqrt{2}}}}{2} \cdots$$

Nested radicals.

---

## Research Questions

1. **Can we find monotone rational bounds for π like EulerEIntervalMediant?**
   - CF convergents alternate around π
   - Mediant approach should work similarly

2. **Is there a "Bessel polynomial" analog for π?**
   - e has y_n(2)/s_n → e
   - What gives π?

3. **Self-referential iteration for π?**
   - For e: x(2 - ln x) → e
   - For π: Newton on sin(x) = 0 gives x - tan(x) → nπ
   - Or: x - (sin x)/cos x = x - tan x

4. **Stern-Brocot path for π?**
   - π = [3; 7, 15, 1, 292, ...] encodes SB path
   - No simple pattern like e's triads

---

## Session Log

*(To be filled as we explore)*

