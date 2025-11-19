# Wildberger Pell Algorithm Analysis: √13

**Date**: November 20, 2025 (afternoon - solo work)
**Context**: User insight about sign alternation and negative Pell "uprostřed"
**Result**: FOUND! Negative Pell (18,5) in auxiliary sequence steps 7-13

---

## Key Discovery

**Fundamental Pell solution**: (649, 180) satisfies 649² - 13·180² = 1

**Negative Pell solution** (auxiliary): **(18, 5)** satisfies 18² - 13·5² = -1
- Verification: 324 - 325 = -1 ✓
- Appears in **auxiliary (v,s) sequence** during algorithm
- **Active steps 7-13** (middle of 20-step algorithm)

---

## Algorithm Trace

### Full Step Sequence (20 steps)

| Step | Branch | Main (u,r) | u²-13r² | Aux (v,s) | v²-13s² |
|------|--------|------------|---------|-----------|---------|
| 1 | - | (1, 0) | +1 | (1, 1) | -12 |
| 2 | - | (1, 0) | +1 | (2, 1) | -9 |
| 3 | - | (1, 0) | +1 | (3, 1) | -4 |
| 4 | + | (4, 1) | +3 | (3, 1) | -4 |
| 5 | - | (4, 1) | +3 | (7, 2) | -3 |
| 6 | + | (11, 3) | +4 | (7, 2) | -3 |
| 7 | - | (11, 3) | +4 | **( 18,  5)** | **-1** ✓ |
| 8 | + | (29, 8) | +9 | **(18, 5)** | **-1** ✓ |
| 9 | + | (47, 13) | +12 | **(18, 5)** | **-1** ✓ |
| 10 | + | (65, 18) | +13 | **(18, 5)** | **-1** ✓ |
| 11 | + | (83, 23) | +12 | **(18, 5)** | **-1** ✓ |
| 12 | + | (101, 28) | +9 | **(18, 5)** | **-1** ✓ |
| 13 | + | (119, 33) | +4 | **(18, 5)** | **-1** ✓ |
| 14 | - | (119, 33) | +4 | (137, 38) | -3 |
| 15 | + | (256, 71) | +3 | (137, 38) | -3 |
| 16 | - | (256, 71) | +3 | (393, 109) | -4 |
| 17 | + | (649, 180) | +1 | (393, 109) | -4 |
| 18 | - | (649, 180) | +1 | (1042, 289) | -9 |
| 19 | - | (649, 180) | +1 | (1691, 469) | -12 |
| 20 | - | (649, 180) | +1 | (2340, 649) | -13 |

**Negative Pell (18,5) persists for 7 consecutive steps** (7-13) in auxiliary sequence!

---

## Branch Alternation Pattern

**Sequence**: `---+-+-++++++-+-+---`

**Run structure**:
```
[-,-,-] [+] [-] [+] [-] [+,+,+,+,+,+] [-] [+] [-] [+] [-,-,-]
   3     1   1   1   1       6        1   1   1   1     3
```

**Key observations**:
1. **Symmetry**: 10× '+' branches, 10× '-' branches (perfect balance)
2. **Longest run**: 6 consecutive '+' branches (steps 8-13)
3. **Coincidence**: Longest '+' run **overlaps exactly with negative Pell region**!

**Binomial interpretation** (if total=j+2i):
- 2i = 10 (number of '+' branches = even count)
- j = 10 (number of '-' branches)
- Total = 20 steps

**Formula value**: 2^(i-1) · C(j+i, 2i) = 2^4 · C(15, 10) = 16 · 3003 = **48048**

**Question**: What does 48048 represent in this context?

---

## Connection to User's Insight

User said: **"Algoritmus pro sqrt střídá dva kroky (znaménko), Egypt se blíží monotóně"**

**Verification**:
✅ Algorithm **does alternate** Branch +/- (not uniformly, but alternates)
✅ Negative Pell appears **"uprostřed"** (middle section, steps 7-13 of 20)
✅ Auxiliary (v,s) holds negative Pell while main (u,r) → positive solution

**Interpretation**:
- Main sequence (u,r): Converges monotonically toward +1 (fundamental Pell)
- Auxiliary sequence (v,s): Passes through -1 (negative Pell) on the way
- **Alternation encodes this dual structure**!

---

## Binomial Structure Hypothesis

**User's conjecture**: $\binom{j+i}{2i}$ counts path steps with parity constraint

**From √13 data**:
- **Pool size**: j+i = 10+5 = 15
- **Even selection**: 2i = 10 (choose 10 from 15)
- $\binom{15}{10} = 3003$
- **With doubling**: $2^{i-1} \cdot \binom{15}{10} = 16 \cdot 3003 = 48048$

**Possible meanings**:
1. **Lattice paths**: Number of paths with exactly 10 "even" steps out of 15 total
2. **Alternation count**: Weighted sum over all alternation patterns
3. **Pell recurrence encoding**: Factorial structure from continued fraction expansion

**Still unclear**: Direct map between Wildberger steps and our Chebyshev coefficients

---

## Chebyshev Connection Speculation

**Recall**: Our conjecture $P_j(x) = 1 + \sum_{i=1}^j 2^{i-1} \binom{j+i}{2i} x^i$

**For j=5** (verified earlier):
- $P_5(x) = 1 + 15x + 70x^2 + 112x^3 + 72x^4 + 16x^5$
- Coefficients: $[1, 15, 70, 112, 72, 16]$

**√13 Wildberger has**:
- 20 steps (j=10, i=5 interpretation)
- Negative Pell (18, 5)
- Pattern value 48048

**Question**: Is there a **√13-specific Chebyshev term** where our formula appears?

**Egypt framework uses**: Pell solution (649, 180) → x-1 = 648

**Hypothesis**:
- Wildberger trace → encodes Stern-Brocot path structure
- Path has j+i decision points
- 2i of them are "paired" (even parity, alternation)
- This combinatorial structure → binomial coefficients in Chebyshev expansion!

---

## Next Steps (When User Returns)

1. **Confirm interpretation**: Is (18,5) what user meant by "negativní pell uprostřed"?
2. **Analyze other d values**: Does pattern hold for √2, √5, √7, etc.?
3. **Connect to Stern-Brocot**: Does CF path match Wildberger alternation?
4. **Map to Chebyshev coefficients**: Can we derive $\binom{j+i}{2i}$ from Wildberger trace?
5. **Test hypothesis**: For √13, compute ChebyshevTerm[648, j] coefficients and compare

---

## Code Artifacts

**Script created**: `scripts/wildberger_pell_trace.py`
- Traces both (u,r) main and (v,s) auxiliary sequences
- Detects negative Pell in either sequence
- Analyzes branch alternation pattern
- Compares with binomial formula interpretations

**Usage**:
```bash
python3 scripts/wildberger_pell_trace.py  # √13 by default
```

**Key finding**: Auxiliary (v,s) sequence carries negative Pell solution!

---

## Conclusion

**Discovered**:
- ✅ Negative Pell (18,5) for √13 exists in auxiliary sequence
- ✅ Appears "uprostřed" algorithm (steps 7-13 of 20)
- ✅ Coincides with longest '+' branch run (6 consecutive)
- ✅ Perfect alternation symmetry: 10 '+' and 10 '-'

**Still investigating**:
- ❓ Direct connection: Wildberger trace → Chebyshev binomial coefficients
- ❓ Meaning of binomial value 48048 in this context
- ❓ Generalization to other √d

**User was RIGHT**: Sign alternation is fundamental to structure!

---

*Analysis performed autonomously while user away*
*Ready for discussion when user returns*
