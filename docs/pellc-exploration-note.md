# pellc: Closed Form Exploration (Archived)

**Date**: November 17, 2025
**Status**: Explored, archived as non-novel
**Conclusion**: Closed form for special Pell equations via Chebyshev ratios, but solutions are trivial

---

## Summary

User explored closed-form Chebyshev solutions for generalized Pell equations:

$$n x^2 - (nd^2 - 1) y^2 = k$$

using Chebyshev ratio:

$$z = \frac{T_{2m-1}(\sqrt{d^2 n})}{U_{2m-2}(\sqrt{d^2 n})}$$

with candidate solutions derived from z.

## Special Case: nx² - (n-1)y² = 1 (c=0 only)

For d=1, **c=0**, this gives standard Pell-type equation:

$$n x^2 - (n-1) y^2 = 1$$

**Closed form solution** (via pellc, m=2):
- x = 4n - 3
- y = 4n - 1

**Verification**: Works for all tested n ∈ {2, 3, 5, 7, 11, 13, 17}

**Why trivial**: Direct substitution shows:
$$n(4n-3)^2 - (n-1)(4n-1)^2 = 1$$

expands algebraically to identity.

---

**Important**: For **c≠0**, right-hand side is NOT 1:
- c=1, n=13: 13x² - 12y² = **100** (not a Pell equation!)
- RHS = (1 + 2xc + c²)/gcd, depends on x and c

So pellc is really solving **generalized Diophantine equations**, not standard Pell x² - Dy² = 1.

## Connection to Egypt.wl (x+1) Factor?

The pellc function includes parameter `c` which introduces `(x+c)²` into GCD calculation:

```mathematica
GCD[(x + c)^2, y^2, 1 + (x + c)^2 - x^2]
```

For c=1, this is `(x+1)²` - the same factor appearing in Egypt.wl TOTAL-EVEN divisibility pattern.

**However**: Connection unclear. Egypt.wl uses:
- Chebyshev evaluated at (x-1) where x is from fundamental Pell x² - ny² = 1
- Iterative partial sums

pellc uses:
- Chebyshev evaluated at √(d²n) directly
- Different Pell equation (nx² - (n-1)y² = 1, not x² - ny² = 1)

**Conclusion**: Interesting parallel, but no direct connection established.

## User's Assessment

> "řešení n x^2 - (n-1)^y^2 == 1 sama o sobě jsou naprosto triviální"

User has closed forms for higher k as well, but spent significant time without finding deeper structure connecting to Egypt.wl pattern.

---

## Files

- `scripts/test_pellc_simple.wl` - Verification of closed form solutions
- `scripts/test_pellc_closed_form.wl` - Extended analysis (incomplete due to syntax issues)

## Recommendation

Archive this exploration. The (x+1) divisibility in Egypt.wl comes from **Chebyshev polynomial identity** T_m(x) + T_{m+1}(x) = (x+1)·P_m(x), not from this generalized Pell connection.

---

**Status**: Explored, documented, moving on.
