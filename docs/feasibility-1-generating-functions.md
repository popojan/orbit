# Feasibility Check: Generating Functions Approach

**Date:** November 18, 2025
**Goal:** Quick exploration to assess if generating functions can simplify Primal Forest formulation

---

## Proposed Formulation

**Idea:** Encode distance information in generating function over d.

**Option A: Exponential generating function**
$$G_n(z) = \sum_{d=2}^{\infty} z^d \cdot \min_k |n - (kd + d^2)|$$

**Option B: With exponential weighting**
$$G_n(z) = \sum_{d=2}^{\infty} z^d \cdot e^{-\text{dist}(n, d\text{-lattice})}$$

**Option C: Power distance**
$$G_n(z, \alpha) = \sum_{d=2}^{\infty} z^d \cdot [\min_k ((n-kd-d^2)^2 + \varepsilon)]^{-\alpha}$$

---

## Where Could Simplification Happen?

### Special Values of z

**For z = 1:**
$$G_n(1) = \sum_{d=2}^{\infty} f(\text{dist}(n,d))$$
This is just the original sum (no simplification).

**For z on unit circle** (z = e^(iθ)):
$$G_n(e^{i\theta}) = \sum_{d=2}^{\infty} e^{i\theta d} \cdot f(\text{dist}(n,d))$$

Could this telescope? Unlikely - phases don't align with distance structure.

**For |z| < 1:** Series converges better, but no obvious closed form.

### Poles and Zeros

**Analytic continuation:** G_n(z) as meromorphic function.

**If G_n(z) had simple pole/zero structure:**
- Could extract via residue calculus
- But requires G_n to be rational or have known form

**Reality check:**
$$G_n(z) = z^2 \cdot f_2(n) + z^3 \cdot f_3(n) + z^4 \cdot f_4(n) + ...$$

where $f_d(n) = $ distance to d-lattice.

**Each coefficient $f_d(n)$ depends on n differently** (via $(n-kd-d^2)$).

→ No universal factorization → not rational function.

---

## Dirichlet Generating Function

**Alternative:** Use Dirichlet series instead.

$$D_n(s) = \sum_{d=2}^{\infty} \frac{f(\text{dist}(n,d))}{d^s}$$

**This is closer to our current F_n(s)!**

Actually:
$$F_n(s) = \sum_{d=2}^{\infty} [\text{soft-min}_d(n)]^{-s}$$

is already a "Dirichlet-like" series.

**Classical Dirichlet series:**
$$\sum \frac{a_n}{n^s}$$

have nice properties when $a_n$ is multiplicative (Euler product).

**Our case:** $a_d = f(\text{dist}(n,d))$ is **NOT multiplicative** in d.

→ No Euler product → no classical simplification.

---

## Fourier Approach

**Idea:** Take Fourier transform in n.

$$\hat{F}(\omega) = \int_{-\infty}^{\infty} F_n(\alpha) \cdot e^{-i\omega n} dn$$

**For pure double sum:**
$$\hat{F}(\omega) = \int \sum_{d,k} [(n-kd-d^2)^2 + \varepsilon]^{-\alpha} e^{-i\omega n} dn$$

**Change of variables:** Let $u = n - kd - d^2$:
$$\hat{F}(\omega) = \sum_{d,k} e^{-i\omega(kd+d^2)} \int [(u^2+\varepsilon)]^{-\alpha} e^{-i\omega u} du$$

**Inner integral:**
$$I(\omega, \alpha) = \int_{-\infty}^{\infty} (u^2+\varepsilon)^{-\alpha} e^{-i\omega u} du$$

This is **Fourier transform of power function** - has known form!

For α > 1/2:
$$I(\omega, \alpha) \propto |\omega|^{2\alpha-1} K_{2\alpha-1}(|\omega|\sqrt{\varepsilon})$$

where $K_\nu$ is **modified Bessel function**.

**Result:**
$$\hat{F}(\omega) \propto K_\nu(|\omega|\sqrt{\varepsilon}) \sum_{d,k} e^{-i\omega(kd+d^2)}$$

**Phase sum:**
$$S(\omega) = \sum_{d=2}^{\infty} \sum_{k=0}^{\infty} e^{-i\omega(kd+d^2)}$$

$$= \sum_{d=2}^{\infty} e^{-i\omega d^2} \sum_{k=0}^{\infty} e^{-i\omega kd}$$

**Inner sum:** Geometric series (converges for Im(ω) > 0):
$$\sum_{k=0}^{\infty} e^{-i\omega kd} = \frac{1}{1 - e^{-i\omega d}}$$

**Outer sum:**
$$S(\omega) = \sum_{d=2}^{\infty} \frac{e^{-i\omega d^2}}{1 - e^{-i\omega d}}$$

**This is a Gauss-like sum!** Related to theta functions.

---

## Verdict: Generating Functions

### Potential Simplification: ⭐⭐

**What we found:**
- ✅ Fourier transform gives Bessel function × Gauss-like sum
- ✅ Structure $\sum e^{-i\omega d^2}$ appears (theta-like)
- ❌ But final sum over d still present
- ❌ Not obviously simpler than original

**Challenges:**
1. Gauss sum $\sum e^{-i\omega d^2}/(1-e^{-i\omega d})$ not standard
2. Inverse Fourier transform to get back F_n would be complex
3. No direct closed form visible

**Possible next steps:**
- Evaluate $S(\omega)$ numerically for special ω
- Check if it has poles/zeros structure
- Connection to theta functions (see Direction 2)

**Priority revision:** Keep as ⭐⭐ (interesting structure, but not obviously simplifiable)

---

**Status:** FEASIBILITY CHECK
**Outcome:** Reveals theta function structure, but no immediate closed form
