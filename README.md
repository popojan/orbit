# Orbit: Mathematical Explorations

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.17802020.svg)](https://doi.org/10.5281/zenodo.17802020)

This repository contains computational explorations in number theory and related mathematics, implemented as a Wolfram Language paclet. The work is ongoing, unpublished, and has not been peer-reviewed.

## Featured: Rational Circle Algebra

<p align="center">
<img src="docs/sessions/2025-12-07-circ-hartley-exploration/figures/gauss17-golden.png" width="300" alt="Gauss 17-star">
</p>

**42 characters.** The golden 17-pointed star from Gauss's monument in Braunschweig:

```mathematica
Graphics@{Hue@π,Polygon@κ@ρ[17,7Range@17]}
```

This uses our **Rational Circle Algebra** where multiplication becomes addition:
- `t₁ ⊗ t₂ = t₁ + t₂ + 5/4` (stays rational!)
- `ρ[n,k] = 2k/n - 5/4` (n-th root of unity, always rational)
- `κ[t]` converts to coordinates only when needed

All circle operations stay in ℚ until the final `κ` bridge. See [CircFunctions.wl](Orbit/Kernel/CircFunctions.wl).

---

## What's Here

The repository includes:

- **Orbit Paclet**: Wolfram Language implementations of various mathematical explorations
  - Prime structure analysis
  - Primorial computation methods
  - Square root approximation techniques
  - Modular arithmetic utilities

- **Documentation**: Mathematical context and reference materials in `docs/`

- **Scripts**: Computational experiments and analysis tools in `scripts/`

## Modules

**PrimeOrbits**: Geometric visualization approaches to prime number structure

**Primorials**: Methods for computing primorials using rational sums

**SemiprimeFactorization**: Explorations in factorization formulas

**ModularFactorials**: Efficient computation of factorials modulo p

**SquareRootRationalizations**: High-precision square root approximations using Chebyshev polynomials, Pell equations, and related methods

**CircFunctions**: Rational circle algebra where multiplication is addition. Includes operators `⊗` (multiply), `⊙` (power), and Greek-named bridges `κ` (coordinates), `φ` (complex), `ρ` (roots of unity)

See `CLAUDE.md` for technical details and module documentation.

## Using the Code

All scripts require Wolfram Language (Mathematica or free Wolfram Engine):

```bash
# Load the paclet
wolframscript -code "<< Orbit\`"

# Or run individual scripts
wolframscript -file scripts/[script-name].wl
```

## Documentation

**Quick navigation:**
- [Documentation Index](docs/README.md) - Complete organized index of all documentation
- [Reference Documentation](docs/reference/) - Mathematical foundations and design rationale
- [Session Narratives](docs/sessions/) - Discovery narratives by date
- [Papers](docs/drafts/) - LaTeX papers and longer-form documents

Run `make preview` to generate HTML previews of all documentation.

## Recent Results

**Latest work** (December 2025):
- ✅ **Rational Circle Algebra**: Circle multiplication as `t₁ + t₂ + 5/4` — stays in ℚ until coordinate conversion. Gauss 17-star in 42 chars!
- ✅ **Multiplicative Decomposition Theorem**: For composite n = md, lobe areas of n-gon Chebyshev polygon function satisfy Σ A(n, k≡r mod m) = 1/m (proven via roots of unity cancellation)
- Connection between Chebyshev composition Tₘ(Tₙ(x)) = Tₘₙ(x) and geometric lobe area structure
- Unified Chebyshev framework σ_m for square root iteration with arbitrary integer convergence order ≥ 3

See [STATUS.md](docs/STATUS.md) for current status and [lobe-area-kernel.tex](docs/drafts/lobe-area-kernel.tex) for the mathematical details.

### A Historical Note

During literature review, we traced the history of quadratic residue pattern counting back to **N. S. Aladov (1896)** — a mathematician virtually unknown in anglophone literature. This attribution comes from Keith Conrad's [expository notes](https://kconrad.math.uconn.edu/blurbs/ugradnumthy/QuadraticResiduePatterns.pdf); Russian mathematicians (Kiritchenko, Tsfasman, Vlăduț) have maintained awareness of Aladov independently.

Aladov's identity remains a minor historical mystery — see [our investigation](docs/sessions/2025-12-04-beta-functions-analysis/aladov-mystery.md).

## Status

This work represents personal mathematical explorations and computational experiments. **Nothing here has been peer-reviewed.** All results should be considered provisional and subject to revision.

Individual results have different epistemic statuses (✅ PROVEN, 🔬 NUMERICALLY VERIFIED, 🤔 HYPOTHESIS) - check specific documents for details.

## Feedback Welcome

If you find something interesting, puzzling, or incorrect, please open a GitHub issue. Questions, corrections, and independent verification are appreciated.

## License

MIT License (code) / CC-BY 4.0 (documentation)

## Technical Notes

- Run `make generate-index` to regenerate documentation index
- Use `wolframscript -file` for script execution
- See `CLAUDE.md` for development protocols and conventions
