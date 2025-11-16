# External Sources

This directory contains copies of important external code/docs for quick context loading.

## Egypt Repository Materials

**Source**: https://github.com/popojan/egypt

### Files:

1. **Egypt.wl** - Wolfram Language library for:
   - Egyptian fraction decomposition
   - √n rationalization via Chebyshev polynomials
   - Pell equation solutions

2. **sqrt.pdf** - Formulas for √ rationalization

### Key Formulas (from Egypt.wl):

#### Factorial-based term:
```mathematica
term0[x_, j_] := 1 / (1 + Sum[2^(i-1) * x^i * (j+i)! / (j-i)! / (2i)!, {i, 1, j}])
```

#### Chebyshev-based term (EQUIVALENT!):
```mathematica
term[x_, k_] := 1 / (
    ChebyshevT[Ceiling[k/2], x+1] *
    (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1])
)
```

**Verification**: term0[x, j] = term[x, j] for all x, j (numerically verified Nov 16, 2025)

#### Pell solution (Wildberger algorithm):
```mathematica
pellsol[d_] := (* Stern-Brocot integer-only algorithm *)
```

#### √n approximation:
```mathematica
EgyptianSqrtApproximate[n_, Accuracy -> k] :=
    (x-1)/y * (1 + Sum[term[x-1, j], {j, 1, k}])

where (x, y) = Pell solution to x² - n*y² = 1
```

### Important Note on sqrt.pdf Modular Property

**WARNING**: The modular congruence claim in sqrt.pdf:

```
(x-1)/y * f(x-1, k) ≡ 0 (mod n)
```

**Does NOT hold for all k!**

According to Jan Popelka (Nov 16, 2025):
> "v té modularitě sqrt.pdf je chyba, neplatí to pro každé k (limit sumace)
> ale jen pro sudá nebo lichá, už si přesně nepamatuju"
>
> Translation: "There's an error in the modularity of sqrt.pdf, it doesn't hold
> for every k (summation limit) but only for even or odd, I don't remember exactly"

**Status**: UNRESOLVED - needs investigation
- Does it hold for even k only?
- Or odd k only?
- Or some other pattern?

**Action item**: Verify modular property systematically for various k values.

---

## Relationship to Orbit Paclet

Egypt.wl is the **origin** of the Chebyshev-Pell framework now implemented in:
- `Orbit/Kernel/SquareRootRationalizations.wl`
- `docs/modules/chebyshev-pell-sqrt-framework.md`

The Orbit implementation extends Egypt.wl with:
1. **Nested iteration** (super-quadratic convergence)
2. **Optimized closed forms** for m=1, m=2
3. **Performance benchmarks** (62M digit achievement)
4. **Theoretical analysis** (fixed-point characterization)

See `docs/archive/chebyshev-pell-sqrt-paper-summary.md` for full details.

---

## Copy Date

**Copied**: November 16, 2025
**Egypt commit**: Latest as of copy date
**Purpose**: Quick context for AI sessions (avoid re-cloning neighbor repo)

---

## Usage

When starting new session exploring Chebyshev/Pell/√ rationalization:

1. Read `Egypt.wl` for original implementation
2. Read `sqrt.pdf` for compact formula reference (but note modularity error!)
3. Reference `docs/modules/chebyshev-pell-sqrt-framework.md` for extended theory
4. Check `scripts/verify_egypt_term_equivalence.py` for numerical verification

This creates full context without needing to clone egypt repository.
