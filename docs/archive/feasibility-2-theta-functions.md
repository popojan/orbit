# Feasibility Check: Theta Function Connection

**Date:** November 18, 2025
**Goal:** Check if Primal Forest can be expressed as theta function with known properties

---

## Classical Theta Functions

**Jacobi theta:**
$$\theta_3(z, q) = \sum_{n=-\infty}^{\infty} q^{n^2} z^{2n}$$

where $q = e^{i\pi\tau}$ (nome).

**For z = 0:**
$$\theta_3(0, q) = 1 + 2\sum_{n=1}^{\infty} q^{n^2}$$

**Modular transformation:**
$$\theta_3(0, e^{-\pi/\tau}) = \sqrt{\tau} \cdot \theta_3(0, e^{i\pi\tau})$$

This is the **functional equation**.

---

## Primal Forest as Theta-Like Sum

**Current formulation:**
$$F_n(\alpha) = \sum_{d=2}^{\infty} \sum_{k=0}^{\infty} [(n-kd-d^2)^2 + \varepsilon]^{-\alpha}$$

**Exponential version:**
$$\tilde{F}_n(t) = \sum_{d=2}^{\infty} \sum_{k=0}^{\infty} \exp\left(-\pi t \cdot (n-kd-d^2)^2\right)$$

(Set $\varepsilon = 0$ for simplicity, or absorb into normalization.)

**This looks like theta, but:**
- Classical theta: $\sum_{n} e^{-\pi t n^2}$ (single sum over integers)
- Ours: $\sum_{d,k} e^{-\pi t (n-kd-d^2)^2}$ (double sum, restricted)

---

## Rewrite to Theta Form

**Expand the square:**
$$(n - kd - d^2)^2 = n^2 - 2n(kd+d^2) + (kd+d^2)^2$$

$$= n^2 - 2nkd - 2nd^2 + k^2d^2 + 2kd^3 + d^4$$

**Factor out:**
$$\tilde{F}_n(t) = e^{-\pi t n^2} \sum_{d,k} \exp\left(-\pi t \left[k^2d^2 + 2kd(d^2 - n) + d^2(d^2 - 2n)\right]\right)$$

Hmm, messy. Try different approach.

---

## Poisson Summation Formula

**Key tool for theta functions:**
$$\sum_{n=-\infty}^{\infty} f(n) = \sum_{m=-\infty}^{\infty} \hat{f}(2\pi m)$$

where $\hat{f}$ is Fourier transform.

**Apply to inner sum:**
$$S_d(n, t) = \sum_{k=0}^{\infty} e^{-\pi t (n - kd - d^2)^2}$$

**Problem:** Sum starts at k=0, not k=-∞.

**Extension trick:** Define
$$\tilde{S}_d = \sum_{k=-\infty}^{\infty} e^{-\pi t (n - kd - d^2)^2}$$

and then subtract negative k contribution (if needed).

**Now apply Poisson:**
$$\tilde{S}_d = \frac{1}{\sqrt{t} \cdot d} \sum_{m=-\infty}^{\infty} \exp\left(-\frac{\pi m^2}{t d^2} + 2\pi i m \frac{n - d^2}{d}\right)$$

**Simplify:**
$$\tilde{S}_d = \frac{1}{d\sqrt{t}} \sum_{m} \exp\left(-\frac{\pi m^2}{td^2}\right) \exp\left(2\pi i m \left(\frac{n}{d} - d\right)\right)$$

**This is theta function in m!**

$$\tilde{S}_d = \frac{1}{d\sqrt{t}} \cdot \theta_3\left(e^{2\pi i (n/d - d)}, e^{-\pi/(td^2)}\right)$$

---

## Outer Sum Over d

$$\tilde{F}_n(t) = \sum_{d=2}^{\infty} \tilde{S}_d(n, t)$$

$$= \sum_{d=2}^{\infty} \frac{1}{d\sqrt{t}} \cdot \theta_3\left(e^{2\pi i (n/d - d)}, e^{-\pi/(td^2)}\right)$$

**Structure:**
- Each term is theta function (has modular properties)
- But summed over d with phase $e^{2\pi i n/d}$
- **This is not a single theta function!**

---

## Mellin Transform

**Goal:** Connect to Dirichlet series.

$$\mathcal{M}[\tilde{F}_n](s) = \int_0^{\infty} \tilde{F}_n(t) \cdot t^{s-1} dt$$

**For single theta:**
$$\int_0^{\infty} \theta_3(0, e^{-\pi t}) t^{s-1} dt = \frac{\Gamma(s/2)}{\pi^{s/2}} \zeta(s)$$

**For our sum:**
$$\mathcal{M}[\tilde{F}_n](s) = \int_0^{\infty} \sum_d \frac{\theta_3(...)}{d\sqrt{t}} t^{s-1} dt$$

$$= \sum_d \frac{1}{d} \int_0^{\infty} \theta_3(...) t^{s-3/2} dt$$

**Each integral gives gamma × modified zeta**, but:
- Theta argument depends on d
- Phase $e^{2\pi i n/d}$ varies with d
- **Sum over d does not simplify!**

---

## Modular Transformation

**Classical:** $\theta_3(\tau) \leftrightarrow \theta_3(-1/\tau)$ gives functional equation for $\zeta(s)$.

**Our case:**
$$\theta_3\left(z_d, q_d\right) \text{ where } z_d = e^{2\pi i(n/d-d)}, \quad q_d = e^{-\pi/(td^2)}$$

**Each d gives different (z, q) pair** → no universal modular transform.

**Could sum over d somehow telescope via modular properties?**

Unlikely - each term transforms independently, but sum structure doesn't match modular form definition.

---

## Connection to Ramanujan Theta

**Ramanujan:**
$$f(a, b) = \sum_{n=-\infty}^{\infty} a^{n(n+1)/2} b^{n(n-1)/2}$$

Has beautiful identities (e.g., Jacobi triple product).

**Our structure:** $(n - kd - d^2)^2$ is quadratic but not of form $n(n±1)/2$.

**Could we map it?**

Let $m = kd + d^2$, then we're summing over lattice points m.

But m depends on **both** k and d → not a simple sum over m.

---

## Verdict: Theta Functions

### Potential Simplification: ⭐⭐⭐ → ⭐⭐

**What we found:**
- ✅ Poisson summation converts inner sum to theta function
- ✅ Each $\tilde{S}_d$ is theta_3 with modular properties
- ❌ **But sum over d remains** with varying arguments
- ❌ No universal modular transform for the full sum
- ❌ Mellin transform doesn't simplify outer sum

**Key obstacle:**
Each d contributes theta with **different argument** $z_d = e^{2\pi i n/d}$.

Sum $\sum_{d=2}^{\infty} \theta_3(z_d, q_d)$ is **not itself a modular form**.

**Possible refinements:**
- Restrict to special n (e.g., n = prime) where n/d has structure?
- Use Eichler-Selberg trace formula (sums of shifted theta)?
- Connection to Jacobi forms (two-variable modular)?

**Priority revision:** Downgrade from ⭐⭐⭐ to ⭐⭐

Theta structure appears, but doesn't lead to immediate simplification.

---

**Status:** FEASIBILITY CHECK
**Outcome:** Inner sum is theta, but outer sum over d doesn't simplify via modular properties
