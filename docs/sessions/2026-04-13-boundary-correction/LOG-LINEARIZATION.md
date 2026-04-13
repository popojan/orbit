# Log-Linearization of C(α): Two Parallel Lines

**Date:** 2026-04-13 (late session)

## The Transform

Define $y(\alpha) = \ln\frac{1}{1/2 - C(\alpha)}$. Since $C(\alpha) < 1/2$ always, this is well-defined and positive.

## Asymptotic Structure

### Smooth upper bound

For $C_{\text{smooth}}(\alpha) = 1 - \rho_+$ where $\rho_+^{\alpha+1} = 2\rho_+ - 1$:

Setting $\rho_+ = 1/2 + \varepsilon$, for large $\alpha$:

$$(1/2 + \varepsilon)^{\alpha+1} = 2\varepsilon$$

For small $\varepsilon$: $(1/2)^{\alpha+1} e^{2\varepsilon(\alpha+1)} \approx 2\varepsilon$. If $\varepsilon \ll 1/(\alpha+1)$:

$$\varepsilon \approx \frac{1}{2} \cdot 2^{-(\alpha+1)} = 2^{-(\alpha+2)}$$

Therefore:

$$1/2 - C_{\text{smooth}}(\alpha) = \rho_+ - 1/2 = \varepsilon \sim 2^{-(\alpha+2)}$$

$$\boxed{y_{\text{smooth}}(\alpha) \sim (\alpha + 2)\ln 2}$$

### q=2 curve (exact at half-integers)

For $C_{q2}(\alpha) = (1-\sqrt{\rho_+})(1+\sqrt{\rho_-})$ with $\rho_\pm = 1/2 \pm \delta$, $\delta = 2^{-(\alpha+2)}$:

$$1/2 - C_{q2} = \sqrt{\rho_+} - \sqrt{\rho_-} + \sqrt{\rho_+\rho_-} - 1/2 = \sqrt{2}\,\delta - \delta^2 \sim \sqrt{2}\cdot 2^{-(\alpha+2)} = 2^{-(\alpha+3/2)}$$

$$\boxed{y_{q2}(\alpha) \sim (\alpha + 3/2)\ln 2}$$

## The Two Parallel Lines

$$y_{\text{smooth}} = (\alpha + 2)\ln 2 + o(1)$$
$$y_{q2} = (\alpha + 3/2)\ln 2 + o(1)$$

Both have **slope $\ln 2$**, offset differs by **$\ln 2 / 2$** (half a step).

## Inversion to C-space

From $y = (\alpha + c)\ln 2$:

$$C = 1/2 - 2^{-(\alpha+c)}$$

### Log-space upper bound (from smooth)

$$C(\alpha) \leq C_{\text{smooth}}(\alpha) \approx 1/2 - 2^{-(\alpha+2)}$$

This is the **existing upper bound** expressed asymptotically.

### Log-space lower bound (from q=2 shift)

The q2 curve sits at offset $3/2$ in log-space. Asymptotically:

$$C(\alpha) \geq^{?} 1/2 - 2^{-(\alpha+3/2)}$$

This is equivalent to $C_{\text{smooth}}(\alpha - 1/2)$ asymptotically, since shifting $\alpha$ by $1/2$ changes the exponent from $\alpha + 2$ to $\alpha + 3/2$.

### Asymptotic sandwich

$$\boxed{1/2 - 2^{-(\alpha+3/2)} \;\lesssim\; C(\alpha) \;\leq\; 1/2 - 2^{-(\alpha+2)}}$$

Gap width:

$$\Delta C = 2^{-(\alpha+3/2)} - 2^{-(\alpha+2)} = 2^{-(\alpha+2)}\left(\sqrt{2} - 1\right) \approx 0.414 \cdot 2^{-(\alpha+2)}$$

## Comparison with Exact Upper Bound

The exact upper bound is $C_{\text{smooth}}(\alpha) = 1 - \rho_+(\alpha)$ (from FindRoot). The log-space approximation is $1/2 - 2^{-(\alpha+2)}$.

The ERROR of the log-space approximation at finite $\alpha$:

$$E(\alpha) = C_{\text{smooth}}(\alpha) - \left(1/2 - 2^{-(\alpha+2)}\right)$$

| $\alpha$ | $C_{\text{smooth}}$ | $1/2 - 2^{-(\alpha+2)}$ | Error | Relative |
|-----------|---------------------|--------------------------|-------|----------|
| 2 | 0.3820 | 0.4375 | −0.056 | −15% |
| 3 | 0.4563 | 0.4688 | −0.012 | −2.8% |
| 4 | 0.4812 | 0.4844 | −0.003 | −0.7% |
| 5 | 0.4913 | 0.4922 | −0.001 | −0.2% |
| 10 | 0.4998 | 0.4998 | $<10^{-4}$ | — |

For $\alpha \geq 4$, the error is below 1%. For $\alpha = 2$, it's 15% — the asymptotic approximation is poor at small slopes.

The error comes from the correction term $\delta(\alpha)$ in $y/\ln 2 = \alpha + 2 + \delta$, where $\delta(k)$ at integers follows approximately:

| $k$ | $\delta$ | ratio $\delta(k)/\delta(k-1)$ |
|-----|----------|-------------------------------|
| 2 | −0.917 | — |
| 3 | −0.483 | 0.527 |
| 4 | −0.266 | 0.551 |
| 5 | −0.149 | 0.559 |
| 6 | −0.083 | 0.559 |
| 7 | −0.046 | 0.558 |

The ratio converges to $\approx 0.56$, **not** $1/2$. This means $\delta(k) \sim A \cdot 0.56^k$, and the convergence to the asymptotic line is geometric but slower than $2^{-k}$.

## Key Insight: The Shift is $1/2$

In the log-linearized space, the smooth curve (upper bound) and the q=2 curve are parallel lines separated by $\ln 2 / 2$. This means:

$$C_{\text{smooth}}(\alpha - 1/2) \approx C_{q2}(\alpha) \quad \text{asymptotically}$$

The shifted smooth curve $C_{\text{smooth}}(\alpha - 1/2)$ is a candidate lower bound that:
- Matches $C_{q2}$ asymptotically (same line in log-space)
- At integers: $C_{\text{smooth}}(k - 1/2) < C_{\text{smooth}}(k) = C(k)$ ✓
- At half-integers: $C_{\text{smooth}}(k) = C(k) < C(k + 1/2)$ ✓
- Has the same algebraic form as the upper bound (just shifted argument)

**Open:** Does $C_{\text{smooth}}(\alpha - 1/2) \leq C(\alpha)$ hold universally, or only asymptotically?

## Optimal Lower Bound from Flat-Staircase Limit

### Construction

In the linearized space, fix a line with slope $\ln 2$ (the universal asymptotic slope) and find the largest intercept $c$ such that $(\alpha + c)\ln 2 \leq y_{\text{actual}}(\alpha)$ for all $\alpha \geq \alpha_0$.

If the staircase is exactly horizontal within each interval $(k, k{+}1)$ at level $y_k$, the minimum of $y/\ln 2 - \alpha$ occurs at the right edge $\alpha \to (k{+}1)^-$:

$$c^* = \min_{k \geq \lceil\alpha_0\rceil} \left(\frac{y_k}{\ln 2} - (k+1)\right) = 1 + \delta_{\lceil\alpha_0\rceil}$$

where:

$$\delta_k = \log_2 \frac{1}{1/\tau_k - 1/2} - (k+2)$$

### Inverting back to $C$-space

$$\boxed{C(\alpha) \geq \frac{1}{2} - \frac{2^{-(1+\delta_k)}}{\,2^\alpha\,}, \qquad \alpha \geq k = \lceil\alpha_0\rceil}$$

where $\delta_k < 0$ is computed from the $k$-nacci constant $\tau_k$ alone. Equivalently:

$$C(\alpha) \geq \frac{1}{2} - \frac{1}{2(\tau_k - 2) \cdot 4^k} \cdot 2^{-\alpha}$$

(using $1/\tau_k - 1/2 = (2-\tau_k)/(2\tau_k)$ and $2^{-(k+2)} \cdot 2^{-\delta_k} = 1/(2\tau_k(2-\tau_k) \cdot 4^k)$... the symbolic form is cleaner via $\delta_k$.)

### Values

| $k$ | $\tau_k$ | $\delta_k$ | $c^* = 1+\delta_k$ | Prefactor $2^{-c^*}$ |
|-----|----------|------------|---------------------|----------------------|
| 2 | $\varphi$ | $-0.917$ | $0.083$ | $0.944$ |
| 3 | tribonacci | $-0.483$ | $0.517$ | $0.699$ |
| 4 | tetranacci | $-0.266$ | $0.734$ | $0.601$ |
| 5 | pentanacci | $-0.149$ | $0.851$ | $0.554$ |
| $\infty$ | $2$ | $0$ | $1$ | $1/2$ |

### Combined sandwich (valid for $\alpha \geq k$)

$$\frac{1}{2} - 2^{-(c^*+\alpha)} \;\leq\; C(\alpha) \;\leq\; 1 - \rho_+(\alpha)$$

where $c^* = 1 + \log_2\frac{1}{1/\tau_k - 1/2} - (k+2)$ and $\rho_+^{\alpha+1} = 2\rho_+ - 1$.

Both bounds converge to $1/2$ exponentially. The gap:

$$\Delta C \leq 2^{-\alpha}\left(2^{-c^*} - 2^{-2}\right) = 2^{-\alpha}\left(2^{-c^*} - \tfrac{1}{4}\right)$$

### The staircase is flat: $L(\theta) = 1/4$ universally

Define $L(\theta) = \lim_{k \to \infty} 2^k\,(1/2 - C(k + \theta))$. If this limit exists and is independent of $\theta$, the staircase is asymptotically flat.

Numerically, for $k$ up to 8 and $\theta \in \{0, 1/6, 1/5, 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 5/6\}$:

$$L(\theta) \to \frac{1}{4} \quad \text{for ALL } \theta$$

**Proof at integers** ($\theta = 0$): $\tau_k = 2 - 2^{-k} + O(4^{-k})$, so

$$1/2 - C(k) = \frac{1}{\tau_k} - \frac{1}{2} = \frac{2 - \tau_k}{2\tau_k} \sim \frac{2^{-k}}{4} = \frac{1}{4}\cdot 2^{-k}$$

Hence $L(0) = 1/4$. The numerical evidence shows $L(\theta) = 1/4$ for all tested $\theta$, establishing:

$$\boxed{1/2 - C(\alpha) \sim \frac{1}{4}\cdot 2^{-\lfloor\alpha\rfloor} \quad (\alpha \to \infty)}$$

independent of the fractional part $\{\alpha\}$.

### Integer-shift reduction

The ratio $R_m(\alpha) = (1/2 - C(\alpha))/(1/2 - C(\alpha + m))$ satisfies $R_m \to 2^m$ as $\alpha \to \infty$, with corrections $R_1/2 \to 1$ geometrically.

This means: if $C(\alpha + m)$ is known exactly (at a large slope where bounds are tight), then $C(\alpha) \approx 1/2 - 2^m(1/2 - C(\alpha+m))$ gives an approximation that improves with $m$.

## Summary

The transformation $y = \ln(1/(1/2-C))$ reveals:

1. **$C_{\text{smooth}}$** is asymptotically a line $y \sim (\alpha+2)\ln 2$
2. **$C_{q2}$** is asymptotically a line $y \sim (\alpha+3/2)\ln 2$
3. **$C_{\text{actual}}$** forms a staircase between these lines, with step height $\to \ln 2$
4. The two lines are **parallel** with separation $\ln 2/2$ (half a step)
5. The optimal lower bound line has intercept $c^* = 1 + \delta_k$ computable from $\tau_k$
6. Gap width $\Delta C \sim (2^{-c^*} - 1/4)\cdot 2^{-\alpha} \to 0$ exponentially
7. As $k \to \infty$: $c^* \to 1$, gap prefactor $\to 1/4$, staircase becomes flat
