# Drafts Directory

Working drafts of mathematical papers. For publication-ready papers, see `docs/papers/`.

## Current Drafts

| File | Topic | Status |
|------|-------|--------|
| `divisor-count-dirichlet-series.tex` | Dirichlet series for ordered divisor pairs: $L_P(s) = \frac{\zeta(s)^2 - \zeta(2s)}{2}$ | Draft |
| `palindromic-conjecture.tex` | Palindromic structure in hypergeometric functions | Draft |
| `semiprime-formula-complete-proof.tex` | Semiprime factorization via Pochhammer/Wilson (scope: $q < 9p$) | Revised |
| `half-factorial-numerator-theorem.tex` | Half-factorial numerator structure theorem | Draft |
| `gcd-formula-proof.tex` | GCD formula rigorous proof | Draft |
| `formula-reference.tex` | Compact formula reference sheet for Orbit paclet | Reference |

## Compilation

```bash
pdflatex -interaction=nonstopmode paper.tex
pdflatex -interaction=nonstopmode paper.tex  # Run twice for cross-references
```
