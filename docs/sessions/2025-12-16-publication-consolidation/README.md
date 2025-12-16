# Publication Consolidation Plan

**Date:** December 16, 2025
**Purpose:** Consolidate papers for submission based on external review feedback

## Current Release Status

| Paper | GitHub Release | Status |
|-------|---------------|--------|
| Primorial Formula | `v0.1.0-primorial` | Ready for submission |
| Chebyshev Integral Identity | `v0.1.0-chebyshev-integral` | Minor revisions needed |
| Egyptian Fractions Telescoping | `v0.1.0-egyptian-fractions` | Reframe novelty |
| Giza Convergents | `v0.1.0-giza-convergents` | Part of Egypt/sqrt story |
| Fibonacci Fractions | (not tagged) | Development stage |
| Involution Decomposition | (not tagged) | Expository, arXiv candidate |

## Priority Actions

### Tier 1: Submit Now

#### 1. Primorial Formula (`primorial-formula.tex`)
- **Verdict:** Most publishable, clean self-contained result
- **Target:** American Mathematical Monthly (Notes), Integers, or Fibonacci Quarterly
- **Action:** Final proofread, check OEIS references, submit
- **Effort:** Low (paper is ready)

#### 2. Chebyshev Integral Identity (`chebyshev-integral-identity.tex`)
- **Verdict:** Publishable with minor revisions
- **Target:** Mathematics Magazine, SIAM Review, or JIS
- **Action needed:**
  - [ ] Check Gradshteyn-Ryzhik / Prudnikov for prior art
  - [ ] Strengthen U_{k-1} connection via (1-x²)
- **Effort:** Low-Medium

### Tier 2: Reframe and Submit

#### 3. Egyptian Fractions Telescoping (`egyptian-fractions-telescoping.tex`)
- **Verdict:** Publishable, but clarify novelty vs Gyimesi & Nyul (2013)
- **Target:** Fibonacci Quarterly, Integers
- **Key reframe:** NOT "new bijection" but "O(log b) symbolic compression of O(a) unit fractions"
- **Action needed:**
  - [ ] Sharpen novelty claim in abstract/intro
  - [ ] Add explicit comparison with Gyimesi-Nyul
  - [ ] Emphasize computational/storage advantage
- **Effort:** Medium

### Tier 3: Develop Further

#### 4. Unified Chebyshev-Egypt-Sqrt Paper (NEW)
- **Core insight:** T_k → Egypt tuples → √n approximation forms coherent story
- **Components:**
  - Giza convergents discovery
  - sqrt.pdf Egyptian fraction √n formula
  - Chebyshev polynomial connection in term function
  - Convergence rate analysis (missing!)
- **Action needed:**
  - [ ] Consolidate scattered session notes
  - [ ] Add rigorous convergence rate bounds
  - [ ] Single unified narrative
- **Effort:** High (but high potential impact)

#### 5. Fibonacci Fractions (`fibonacci-fractions.tex`)
- **Verdict:** Worth developing, natural fit for Fibonacci Quarterly
- **Action needed:**
  - [ ] Tighten "polynomial bijection" claim (what is target set?)
  - [ ] More computational examples
- **Effort:** Medium

### Tier 4: Expository / arXiv

#### 6. Involution Decomposition (`involution-decomposition.tex`)
- **Verdict:** Interesting expository work
- **Target:** arXiv note, College Mathematics Journal
- **Related files:**
  - `dht-sigma-eigenspace.pdf` (DHT/σ eigenspace)
  - `silver-involution-harmonic-analysis.pdf`
  - `sign-cosine-identity.pdf`
- **Action:** Could bundle as "Calkin-Wilf Geometry" arXiv collection
- **Effort:** Low (if kept as expository)

### Drop / Archive

- **Prime DAG Gap Theorem** - Tautological, no non-trivial theorem
- **Prvoles** - Pedagogical only, Czech educational venue if any

## Recommended Submission Order

1. **Primorial** → submit immediately (cleanest)
2. **Chebyshev integral** → submit after G-R check
3. **Egyptian fractions** → reframe, then submit
4. **Fibonacci fractions** → Fibonacci Quarterly
5. **Unified sqrt paper** → develop as main contribution
6. **Involution bundle** → arXiv when ready

## Open Questions

- Should involution decomposition + DHT + harmonic analysis be one paper or separate arXiv notes?
- Is unified sqrt paper better as single opus or series of related notes?
- Which Chebyshev connections (integral identity vs sqrt iteration vs Egypt) belong together?

## Session Notes

External review received Dec 16, 2025 identified primorial as most submission-ready and sqrt formula as core original contribution needing dedicated treatment. Consensus: consolidation over expansion.
