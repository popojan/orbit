# TODO: Next Session Tasks

## ✅ COMPLETED: Nested Chebyshev Integration

**Achievements this session:**
- ✅ Added `NestedChebyshevSqrt` to Orbit paclet (`SquareRootRationalizations.wl`)
- ✅ Updated `CLAUDE.md` documentation with Module #5
- ✅ Created performance table (`reports/nested_chebyshev_performance.txt`)
- ✅ Verified method approaches from ABOVE (overshoots sqrt, unlike Egyptian fractions)

**Key findings:**
- Precision scales: m1=3 gives ~10x per iteration, m1=1 gives ~6x per iteration
- Denominator overhead: ~2x vs optimal CF convergents
- m1=3 is fastest per-iteration
- Pell base slightly better than crude start
- m1=1, m2=9 achieved **15.6 MILLION digits** in 55 seconds!

## Priority 1: Add Performance Table to Documentation

**File**: `docs/chebyshev-pell-sqrt-framework.md`

**Action**: Add the performance table from `reports/nested_chebyshev_performance.txt` at the TOP of the document as "first class citizen"

**Structure**:
```markdown
# Chebyshev-Pell Square Root Framework

## Performance Summary

[INSERT TABLE from nested_chebyshev_performance.txt]

### Key Insights
- Precision growth: exponential in m2 (iteration count)
- Speed: m1=3 fastest per iteration
- Overhead: ~2x denominator size vs optimal CF
- Direction: Approaches from ABOVE (overshoots)
- Sweet spot for speed+precision: m1=3, m2=3 (1555 digits in 0.0015s)

## Mathematical Framework
[... rest of existing content ...]
```

## Priority 2: Update Documentation

**File**: `docs/chebyshev-pell-sqrt-framework.md`

**Action**: Add comparison table at TOP of document as "first class citizen"

Current issue: Table is hidden deep in documentation. User wants it prominent:
> "the table is hidden way low in the doc. should be first class citizen"

**Structure to add**:
```markdown
# Chebyshev-Pell Square Root Framework

## Performance Comparison

[INSERT TABLE HERE from fair_precision_comparison.txt]

### Key Insights
- Which method is fastest at each precision level?
- Time tradeoff vs CF optimality (denominator overhead)
- m1/m2 parameter effects on speed and size
- When does Pell base matter vs crude start?

## Mathematical Framework
[... rest of existing content ...]
```

## Priority 3: Formula Reference Compilation

**File**: `docs/formula-reference.tex`

**Status**: Created, committed, ready to compile

**Action when disk space available**:
```bash
pdflatex docs/formula-reference.tex
# or upload to Overleaf
```

**Purpose**: Vocabulary sheet for publication/arxiv submission (avoids verbose docs)

## Optional: Documentation Reorganization

User mentioned possibly reorganizing docs into subfolders with index, but deferred until after comparison table work is complete.

## Session Summary

Previous session (5 hours) completed:
- ✅ Documented m1=1 optimization (62M digits achievement)
- ✅ Organized prime sieve visualizations (prime-grid-demo as primary)
- ✅ Created formula reference LaTeX vocabulary sheet
- ✅ Fixed fair_precision_comparison.wl syntax error

Ready to run comparison benchmarks and update documentation with results.
