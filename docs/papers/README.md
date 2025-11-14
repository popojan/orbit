# Papers Directory Guide

This directory contains LaTeX papers documenting mathematical discoveries and proofs from the Orbit project.

## Canonical Papers (Latest Versions)

### Educational
- **`primal-forest-paper.tex`** — Geometric visualization of the Sieve of Eratosthenes with continuous primality score (MAIN educational paper)

### Primorial Formula
- **`primorial-proof-clean.tex`** ⭐ — **PRIMARY VERSION** - Rigorous proof following publication standards, clean exposition
- **`primorial-arxiv-draft.tex`** — ArXiv submission draft (English)
- **`primorial-arxiv-draft-cs.tex`** — ArXiv submission draft (Czech translation)

### Square Root Rationalization
- **`chebyshev-pell-sqrt-paper.tex`** — Complete research paper on Chebyshev-Pell framework (MAIN version)

### Semiprime Factorization
- **`semiprime-formula-complete-proof.tex`** ⭐ — **PRIMARY VERSION** - Most complete proof
- **`semiprime-padic-proof.tex`** — Alternative approach via p-adic valuations (supplementary)

### Modular Factorials
- **`half-factorial-numerator-theorem.tex`** — Half-factorial structure theorem (MAIN version)

### Unified Theory
- **`factorial-chaos-unification.tex`** — Unifying factorial and fractional part approaches (MAIN version)

### GCD Formulas
- **`gcd-formula-proof.tex`** — GCD formula rigorous proof (MAIN version)

### Quick Reference
- **`formula-reference.tex`** — Compact formula reference sheet for all modules

## Supporting/Alternative Versions

These are earlier versions, alternative approaches, or supplementary material:

### Primorial (alternatives)
- `primorial-proof.tex` — Earlier version of the proof (superseded by `primorial-proof-clean.tex`)
- `primorial-recurrence-proof.tex` — Supplementary material focusing on recurrence relations

### Semiprime (alternatives)
- `semiprime-formula-proof.tex` — Shorter/earlier version (superseded by `semiprime-formula-complete-proof.tex`)

## Deprecated

- `gap-theorem.tex` — Gap theorem paper (dead end, not actively maintained)

## Compilation

From this directory:
```bash
make primal-forest-paper.pdf
make primorial-proof-clean.pdf
make chebyshev-pell-sqrt-paper.pdf
# etc.
```

Or from repository root:
```bash
make -C docs/papers primal-forest-paper.pdf
```

**Note:** Always run pdflatex **twice** to resolve cross-references:
```bash
pdflatex -interaction=nonstopmode paper.tex
pdflatex -interaction=nonstopmode paper.tex
```

## Status Summary

| Paper | Status | Notes |
|-------|--------|-------|
| primal-forest-paper.tex | ✅ Complete | Educational, ready for use |
| primorial-proof-clean.tex | ✅ Complete | Publication-ready proof |
| primorial-arxiv-draft.tex | 🔄 Draft | For ArXiv submission |
| chebyshev-pell-sqrt-paper.tex | ✅ Complete | Research paper ready |
| semiprime-formula-complete-proof.tex | ✅ Complete | Primary proof version |
| half-factorial-numerator-theorem.tex | ✅ Complete | Standalone theorem |
| factorial-chaos-unification.tex | ✅ Complete | Unification paper |
| gcd-formula-proof.tex | ✅ Complete | Rigorous proof |
| formula-reference.tex | ✅ Complete | Quick reference |

## Recommended Reading Order

For newcomers to this research:

1. **Start here:** `primal-forest-paper.tex` — Accessible educational introduction
2. **Main result:** `primorial-proof-clean.tex` — The primorial formula proof
3. **Performance breakthrough:** `chebyshev-pell-sqrt-paper.tex` — Square root rationalization
4. **Factorization:** `semiprime-formula-complete-proof.tex` — Semiprime closed form
5. **Reference:** `formula-reference.tex` — Quick lookup of all formulas
