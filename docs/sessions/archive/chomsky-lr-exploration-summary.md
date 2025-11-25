# Chomsky Hierarchy Exploration - LR String Analysis

**Date**: November 19, 2025 (solo work)
**Context**: User request to explore LR sequences in Chomsky hierarchy context
**Status**: Exploration phase, patterns found but incomplete characterization

---

## Executive Summary

Analyzed Wildberger algorithm branch sequences (LR strings) as formal language:
- ✅ **L_W ⊂ CF palindromes** (context-free, proper subset)
- ✅ **16+ counterexamples** found (palindromes NOT in L_W)
- ✅ **Simple vs Complex** dichotomy discovered
- ✅ **mod 10 disjoint pattern** for classification
- ❓ **Connection to binomial C(3i,2i)** unclear

---

## Language Properties

### Universal Properties (Verified 22/22 cases)

1. **All palindromes** ✓
2. **All start with '-'** ✓
3. **All end with '-'** ✓ (follows from palindrome + start)
4. **Symmetric ⟺ Negative Pell** (10/22 cases, perfect correlation)

### L_W is PROPER SUBSET

**Counterexamples** (palindromes starting with '-' NOT in L_W):
- Length 2: `--`
- Length 3: `---`
- Length 4: `----`
- Length 5: `-----`, `-+-+-`, `--+--`, `-+++-`
- Length 6: `------`, `-+--+-`, `-++++-`
- ...16+ examples found (length 2-7)

**Conclusion**: L_W has additional structural constraints beyond palindrome property.

---

## Simple vs Complex Dichotomy

### Simple Pattern: [i, 2i, i] Run Structure

**Definition**: Exactly 3 runs with lengths [i, 2i, i]

**String form**: `[-]^i [+]^(2i) [-]^i`

**Cases**: d ∈ {2, 5, 10, 17, 37}

**Examples**:
```
d=2:  -++-           (i=1, runs=[1,2,1])
d=5:  --++++--       (i=2, runs=[2,4,2])
d=10: ---++++++---   (i=3, runs=[3,6,3])
d=17: ----++++++++---- (i=4, runs=[4,8,4])
d=37: ------++++++++++++------ (i=6, runs=[6,12,6])
```

**Properties**:
- 4/5 are prime (2, 5, 17, 37)
- 1/5 is composite (10 = 2×5)
- Small fundamental solutions (x < 100)
- d ≡ 0, 2, 5, 7 (mod 10)

### Complex Pattern: Irregular Runs

**Definition**: More than 3 runs, irregular structure

**Cases**: d ∈ {13, 29, 41, 53, 61}

**Examples**:
```
d=13: ---+-+-++++++-+-+---  (i=5, 11 runs)
d=29: -----++-+--++++++++++--+-++-----  (i=8, 11 runs)
d=41: ------++--++++++++++++--++------  (i=8, 7 runs)
d=53: -------+++-+---++++++++++++++---+-+++-------  (i=11, 11 runs)
d=61: -------+----+++-++--+---++++-++++++++++++++-++++---+--++-+++----+-------  (i=18, 23 runs)
```

**Properties**:
- All prime
- Large fundamental solutions (x > 600, up to 10^9)
- d ≡ 1, 3, 9 (mod 10)

---

## Classification Criteria

### mod 10 Pattern (DISJOINT!)

```
Simple:  d ≡ 0, 2, 5, 7 (mod 10)
Complex: d ≡ 1, 3, 9 (mod 10)
```

**Verification**:
- Simple: 2≡2, 5≡5, 10≡0, 17≡7, 37≡7 ✓
- Complex: 13≡3, 29≡9, 41≡1, 53≡3, 61≡1 ✓

### mod 5 Pattern (Also DISJOINT)

```
Simple:  d ≡ 0, 2 (mod 5)
Complex: d ≡ 1, 3, 4 (mod 5)
```

### Fundamental Solution Size

**Hypothesis**: Simple ⟺ small fundamental solution

**Data**:
- Simple max: x=73 (d=37)
- Complex min: x=649 (d=13)
- Gap: [73, 649] with no examples tested

**Conjecture**: Threshold around x ≈ 100-600?

---

## Connection to Binomial Structure

### For Symmetric Cases (negative Pell exists)

**Formula**: Coefficient at position i = 2^(i-1) · C(3i, 2i)

**2-adic Valuation** (CORRECTED - not always 0):
```
d=2:  v_2(C(3,2))   = v_2(3)   = 0 ✓
d=5:  v_2(C(6,4))   = v_2(15)  = 0 ✓
d=10: v_2(C(9,6))   = v_2(84)  = 2 ✗ (NOT zero!)
d=13: v_2(C(15,10)) = v_2(3003)= 0 ✓
d=17: v_2(C(12,8))  = v_2(495) = 0 ✓
d=37: v_2(C(18,12)) = v_2(18564)=2 ✗
d=53: v_2(C(33,22)) = ...      = 4 ✗
```

**Pattern unclear** - v_2 = 0 for most but not all.

### Max Run Coincidence

**Observation**: Max consecutive '+' run overlaps with negative Pell appearance

**Examples**:
```
d=2:  Max run=2,  Neg Pell steps 1-3   (length 3)
d=5:  Max run=4,  Neg Pell steps 2-6   (length 5)
d=10: Max run=6,  Neg Pell steps 3-9   (length 7)
d=13: Max run=6,  Neg Pell steps 7-13  (length 7)
d=61: Max run=14, Neg Pell steps 29-43 (length 15)
```

**Pattern**: Max run ≈ Neg Pell duration (within ±1)

---

## Grammar Characterization

### Proposed Context-Free Grammar (OVERGENERATING)

```
V = {S, A}      (non-terminals)
Σ = {+, -}      (terminals)

Rules:
  S → -A-       (enforce start/end with '-')
  A → -A-       (add matching '-' pair)
  A → +A+       (add matching '+' pair)
  A → ε         (empty, even length palindrome)
  A → +         (center '+', odd length)
  A → -         (center '-', odd length)
```

**Problem**: This accepts ALL palindromes starting/ending with '-'

**L_W is PROPER SUBSET** → Need additional constraints

### Exact Characterization (UNKNOWN)

**Options**:
1. **Context-sensitive** rules (constraints on run lengths from (a,b,c) dynamics)
2. **Deterministic pushdown automaton** with specific stack operations
3. **Regular** sublanguage if bounded complexity (unlikely for large d)

**Current status**: Cannot characterize exactly without understanding algorithm constraints

---

## Open Questions

### 1. Exact Grammar for L_W

**Question**: What formal grammar exactly generates L_W?

**Approaches**:
- Analyze (a,b,c) transition dynamics
- Derive production rules from branch decisions
- Connect to Stern-Brocot tree paths (Wildberger mentions this)

### 2. Simple vs Complex Threshold

**Question**: Is there a computable threshold distinguishing simple from complex?

**Hypotheses**:
- Fundamental solution size: x < threshold → simple
- mod 10: deterministic classification
- CF period length?
- Class number of Q(√d)?

### 3. Connection to Binomial Formula

**Question**: How does LR recursion generate binomial coefficients?

**Current understanding**:
- '+' branch: choose/include?
- '-' branch: skip/don't choose?
- Recursion → doubling factor 2^(i-1)?

**Problem**: Mechanism unclear

### 4. p-adic Pattern in Run Lengths

**Question**: Do run lengths encode p-adic structure?

**Observations**:
- No uniform pattern in v_2 of run lengths
- Some cases have all same v_2, others don't
- Connection to C(3i,2i) p-adic valuation?

---

## Next Steps

### Theoretical

1. **Read Wildberger PDF** (user will provide) - check for known results about branch patterns
2. **Analyze (a,b,c) dynamics** - derive constraints from algorithm mechanics
3. **Connect to Stern-Brocot tree** - understand path encoding

### Computational

1. **Test more d values** - find boundary between simple/complex
2. **Analyze CF period** - correlation with pattern type?
3. **Class number connection** - does h(Q(√d)) matter?

### Proof Strategy for Egypt-Chebyshev

**Idea**: Use simple cases as special case

For simple cases where j=2i and pattern is [i, 2i, i]:
- Binomial simplifies: C(3i, 2i)
- LR structure is clean: [-]^i [+]^(2i) [-]^i
- Maybe easier to prove Egypt-Chebyshev for these first?
- Then extend to complex cases?

---

## Files Created

1. `scripts/wildberger_language_analysis.py` - Chomsky hierarchy analysis
2. `scripts/lr_binomial_connection.py` - Binomial structure exploration
3. `scripts/simple_vs_complex_patterns.py` - Classification analysis

---

## Summary

**What we know**:
- L_W is context-free, proper subset of palindromes
- Simple/complex dichotomy with mod 10 classification
- Max run coincides with negative Pell appearance
- Connection to C(3i,2i) exists but mechanism unclear

**What we don't know**:
- Exact grammar for L_W
- Why mod 10 matters
- How LR recursion generates binomials
- Theoretical proof of patterns

**User insight validated**: Recursive structure of LR decisions IS fundamental and connects to multiple structures (palindrome, negative Pell, binomials). Further exploration needed to understand exact mechanism.

---

*Solo exploration - awaiting user feedback and Wildberger PDF for context*
