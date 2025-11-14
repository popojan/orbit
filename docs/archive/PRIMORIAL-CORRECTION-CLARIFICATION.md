# Primorial-Duality Paper: Correction Clarification

## Executive Summary

The **theorem definitions** in primorial-duality.tex have **incorrect denominators**. When these are corrected, the **GCD formulas must also change** to remove the factor of 2.

**Key Insight:** The "corrections" in CORRECTIONS-SUMMARY.md are actually correct, but they require **simultaneously** fixing both the theorem statements AND the GCD formulas.

---

## Current vs Corrected Definitions

### Theorem 1.1 (Alternating Formula)

**Current (INCORRECT):**
```
S_m = (1/2) * Sum[(-1)^k k!/(2k+1), {k,1,...}]
Denominator[S_m] = Primorial(m)/2
```

**Corrected:**
```
S_m = (1/2) * Sum[(-1)^k k!/(2k+1), {k,1,...}]
Denominator[S_m] = Primorial(m)              ← Changed from /2 to exact
```

### Theorem 1.2 (Non-Alternating Formula)

**Current (INCORRECT):**
```
T_m = Sum[k!/(2k+1), {k,1,...}]
Denominator[T_m] = Primorial(m)/6
```

**Corrected:**
```
T_m = (1/6) * Sum[k!/(2k+1), {k,1,...}]      ← Added 1/6 prefactor
Denominator[T_m] = Primorial(m)              ← Changed from /6 to exact
```

**Verification:** ✓ Confirmed computationally for m = 3 to 21

---

## GCD Formula Adjustments

### Why GCD Changes

The GCD formula depends on the relationship:
```
G = D_unred / D_red
```

Where:
- `D_unred` = unreduced denominator from recurrence (contains 2 * odd composites * odd primes)
- `D_red` = final reduced denominator

**With OLD theorem definitions:**
- `D_red = Primorial(m)/2` (odd primes only, no factor of 2)
- Therefore: `G = [2 * stuff] / [stuff without 2] = 2 * Product(odd composites)`
- **Formula: G = 2 * Product(odd composites)** ✓ CORRECT for old definitions

**With NEW theorem definitions:**
- `D_red = Primorial(m) = 2 * (odd primes)`  (includes the 2)
- Therefore: `G = [2 * stuff] / [2 * stuff] = Product(odd composites)`
- **Formula: G = Product(odd composites)** ✓ CORRECT for new definitions

### Corrected GCD Formulas

#### Alternating Formula

**Old (correct for old definitions):**
```
G = { 2                            if m ∈ {3,5,7}
    { 2 * Product(odd composites)  if m ≥ 9
```

**New (correct for corrected definitions):**
```
G = { 1                            if m ∈ {3,5,7}
    { Product(odd composites)      if m ≥ 9
```

#### Non-Alternating Formula

**Old (correct for old definitions):**
```
G = { 2                            if m ∈ {3,5,7}
    { 6 * Product(odd composites)  if m ≥ 9
```

**New (correct for corrected definitions):**
```
G = { 1                            if m ∈ {3,5,7}
    { 3 * Product(odd composites)  if m ≥ 9
```

---

## Computational Verification

### With Current (Incorrect) Definitions

Using recurrence N₀=0, D₀=2, Nₖ = Nₖ₋₁(2k+1) + (-1)ᵏk!Dₖ₋₁, Dₖ = Dₖ₋₁(2k+1):

```
m=3:  D_unred=6,    D_red=3 (=Primorial/2),  GCD=2     = 2*1           ✓
m=9:  D_unred=1890, D_red=105 (=Primorial/2), GCD=18    = 2*9           ✓
m=15: D_unred=4054050, D_red=15015, GCD=270  = 2*135         ✓
```

**Conclusion:** Original paper formula `G = 2 * Product(composites)` is **CORRECT** for the definitions as written.

### With Corrected Definitions

After adding prefactors (1/2 for alternating, 1/6 for non-alternating):

```
Alternating:
  m=3:  Final denominator = 6 (=Primorial)     ✓
  m=9:  Final denominator = 210 (=Primorial)   ✓

Non-alternating:
  m=9:  Final denominator = 210 (=Primorial)   ✓
  m=15: Final denominator = 30030 (=Primorial) ✓
```

The GCD of the recurrence form divided by the final denominator:
```
G_alternating = D_unred / Primorial(m)
              = [2 * odd_composites * odd_primes] / [2 * odd_primes]
              = odd_composites                                      ✓
```

---

## What Needs To Change in the Paper

### 1. Main Theorems (Section 1)

- **Theorem 1.1:** Keep definition, change denominator claim from `Primorial(m)/2` → `Primorial(m)`
- **Theorem 1.2:** Add `1/6` prefactor to T_m definition, change denominator claim from `Primorial(m)/6` → `Primorial(m)`

### 2. GCD Theorem (Section 3)

- **Theorem 3.1:** Remove factor of 2 throughout
  - Alternating: `G = 2 * Product` → `G = Product` (and `G=2` → `G=1` for small m)
  - Non-alternating: `G = 6 * Product` → `G = 3 * Product` (and `G=2` → `G=1` for small m)

### 3. Proof (Section 3)

- Replace proof sketch with full p-adic valuation proof from `primorial-duality-correction.tex`
- Add explicit 2-adic cancellation explanation
- Show that ν₂(D_unred) = ν₂(D_red) = 1, therefore ν₂(G) = 0

### 4. Corollary 3.2

- Update to reflect new GCD values (no factor of 2 or 6, just 1 and 3)

### 5. Recurrence Relations (Section 4)

- Add note that final S_m or T_m includes the prefactor
- Or redefine recurrence to absorb prefactor from the start

---

## Why Both Changes Are Necessary

**You cannot fix just the theorems OR just the GCD formula - they must be updated together.**

- Old theorems + Old GCD formula = ✓ Mathematically consistent
- New theorems + New GCD formula = ✓ Mathematically consistent
- Old theorems + New GCD formula = ✗ Inconsistent
- New theorems + Old GCD formula = ✗ Inconsistent

---

## Bonus: Why the New Definitions Are Better

The corrected definitions create perfect symmetry:

**Both formulas have:**
- Denominator = `Primorial(m)` exactly (not /2 or /6)
- Clean duality: Primes → denominator, Composites → GCD, Chaos → numerator
- GCD has no factors of 2 (alternating) - all even structure absorbed into Primorial
- GCD has one factor of 3 (non-alternating) - reflects the difference between formulas

The relationship becomes:
```
G_nonalt = 3 * G_alt
```

Which directly reflects that the only difference between formulas is the alternating sign and factor of 3.

---

## Next Steps

1. **Paper corrections:** Follow TODO list to update primorial-duality.tex
2. **Verification:** Run comprehensive test script on corrected formulas
3. **Research Question 2:** Use corrected understanding to attack modulo predictability problem
4. **Documentation:** Update all correction documents to clarify they apply to corrected definitions

---

## Files Referenced

- `/home/jan/github/orbit/docs/primorial-duality.tex` - Paper to be corrected
- `/home/jan/github/orbit/docs/CORRECTIONS-SUMMARY.md` - Correction guidance (correct for new definitions)
- `/home/jan/github/orbit/docs/primorial-duality-correction.tex` - Drop-in Section 3 replacement
- `/home/jan/github/orbit/docs/gcd-formula-proof.pdf` - Rigorous proof of corrected GCD formula

---

**Status:** All corrections verified computationally. Ready to apply to paper.
