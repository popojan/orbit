# Orbit: Mathematical Explorations

This repository contains computational explorations in number theory and related mathematics, implemented as a Wolfram Language paclet. The work is ongoing, unpublished, and has not been peer-reviewed.

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
- [Papers](docs/papers/) - LaTeX papers and longer-form documents

Run `make preview` to generate HTML previews of all documentation.

## Recent Results

**Latest work** (November 2025):
- Chebyshev integral identity (rigorously proven)
- Triple identity connecting factorials, Chebyshev polynomials, and hyperbolic functions (numerically verified)
- Comprehensive literature comparison with Mason & Handscomb (2003)

See [Scientific Review 2025-11-23](docs/reviews/scientific-review-2025-11-23.md) for detailed assessment.

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
