# Theoretical Analysis: Why norm = +2 at position τ/2 - 1?

**Date**: 2025-11-18
**Status**: 🔬 THEORETICAL EXPLORATION
**Empirical basis**: 308/308 primes p ≡ 7 (mod 8) < 10000

---

## Empirical Observation

**Pattern** (100% verified):
```
For p ≡ 7 (mod 8) with CF period τ:
  Convergent C_{τ/2-1} has norm p_{k}² - p·q_{k}² = +2
```

**Precision**: Position is τ/2 - 1, which is **one step before** the midpoint of the period.

---

## Known Theoretical Results

### 1. Period Parity (PROVEN via Legendre symbols)

From `pell-prime-patterns-literature-refs.md`:

```
p ≡ 7 (mod 8) ⟹ period τ ≡ 0 (mod 4)
```

**Proof sketch**:
- Uses halfway equation: x² - py² = 2·(-1)^m at midpoint
- For p ≡ 7 (mod 8): (-2/p) = -1 (Legendre symbol)
- This forces m even ⟹ period ≡ 0 (mod 4)

**Status**: 95% rigorous (needs classical CF reference for halfway equation)

### 2. Palindrome Structure (CLASSICAL)

```
CF(√p) = [a₀; a₁, a₂, ..., a_{τ-1}, 2a₀]
```

The partial quotients form a palindrome (Lagrange, 1770).

**Consequence**: CF convergents have symmetric behavior around midpoint.

### 3. Splitting of 2 (CLASSICAL)

For p ≡ 7 (mod 8):
```
(2/p) = +1  (Legendre symbol)
```

**Meaning**: Prime 2 splits in Q(√p), i.e., there exists α ∈ ℤ[√p] with N(α) = ±2.

---

## Theoretical Conjecture

### Conjecture: Palindrome + Halfway Equation → norm = +2 position

**Hypothesis**: The combination of:
1. Palindrome symmetry of CF(√p)
2. Halfway equation giving norm ≈ ±2 near midpoint
3. (2/p) = +1 forcing exactly +2 (not other small norms)

...determines that norm = +2 appears at position τ/2 - 1.

### Why τ/2 - 1 specifically (not τ/2)?

**Observation from data**:
- Convergent at k = τ/2 - 1: norm = +2
- Convergent at k = τ/2: norm varies (often larger)

**Possible explanation**:

The halfway equation states:
```
x² - py² = 2·(-1)^m  at position τ/2
```

For p ≡ 7 (mod 8), we have m even (from period ≡ 0 mod 4), so:
```
x_{τ/2}² - p·y_{τ/2}² = +2·(-1)^0 = +2  (if m = 0 mod 2)
```

**BUT**: Empirically, norm = +2 appears at τ/2 - 1, not τ/2.

**Possible resolution**:
- The "halfway" in "halfway equation" might refer to the **middle of the periodic part**, not the convergent index
- CF indexing ambiguity: does period start at index 0 or 1?
- Palindrome symmetry might place the minimal norm one step **before** the exact center

---

## Classical CF Theory Needed

### Question 1: What is the "halfway equation"?

**Source**: Mentioned in `pell-prime-patterns-literature-refs.md` as empirically verified but not found in classical texts.

**Needed**: Reference to Perron, Khinchin, or other classical CF texts.

**Question**: At what exact position k does the halfway equation hold?

### Question 2: Palindrome and norm distribution

**Known**: CF(√p) is palindromic.

**Question**: Does palindrome structure force a specific norm pattern around the midpoint?

**Classical result?**: "Center convergent minimizes |norm|" (mentioned in `cf-center-norm-pattern.md`)

### Question 3: Connection to (2/p) Legendre symbol

**Known**: For p ≡ 7 (mod 8), (2/p) = +1.

**Question**: Does this **force** a convergent with norm exactly ±2?

**Algebraic NT perspective**:
- (2/p) = +1 means 2 splits: (2) = 𝔭₁·𝔭₂ in ℤ[√p]
- There exists α with N(α) = ±2
- **Is the half-period convergent this α?**

---

## Matrix Approach (Advanced)

### CF as Matrix Products

Convergent (p_k, q_k) can be represented via matrix product:

```
[p_k   p_{k-1}]   [a₀  1]   [a₁  1]       [a_k  1]
[q_k   q_{k-1}] = [1   0] · [1   0] · ... [1   0]
```

Norm relation:
```
p_k² - p·q_k² = det(some matrix involving a₀, ..., a_k)
```

**Question**: Can we derive norm = +2 at k = τ/2 - 1 from matrix structure?

**Approach**:
- Use palindrome: a_k = a_{τ-k}
- Compute determinant at midpoint
- Show why it equals +2 for p ≡ 7 (mod 8)

**Status**: Not attempted (requires advanced CF theory)

---

## Stern-Brocot Tree Perspective

From `pell-half-period-speedup.md` (Wildberger's framework):

**Idea**: CF convergents = path in Stern-Brocot tree.

**Palindrome** = path reverses direction at midpoint.

**Norm ±2** = specific tree-level structure.

**Question**: Does SB tree geometry explain why norm = +2 appears one step before reversal point?

**Status**: Speculative (not developed)

---

## Empirical Patterns (from data)

### Pattern 1: d_k sequence

From auxiliary sequence (m, d, a):
```
d[τ/2] = 2  (universal for p ≡ 7 mod 8)
```

**Question**: Is this connected to convergent norm?

**Classical formula?**: norm_k = (-1)^k · d_k or similar?

**Status**: No exact formula found (empirically tested, doesn't match simple (-1)^k · d_k)

### Pattern 2: Symmetry around τ/2

From data (e.g., p = 31):
```
d sequence: [6, 5, 3, 2, 3, 5, 6, 1]
            └─first half─┘└second half┘
```

**Observation**: d sequence is **almost** palindromic (except last term).

**Center**: d[τ/2] = 2 always.

**Question**: Does this force convergent norm at τ/2 - 1 to equal +2?

---

## What Would Constitute a PROOF?

### Option A: Classical CF Reference

**If** we can cite:
- Perron (1929) or similar classical text
- Showing: "For p ≡ 7 (mod 8), convergent at τ/2 - 1 has norm +2"

**Then**: Pattern is known (though our mod 8 classification might be new).

### Option B: Derive from Halfway Equation

**If** halfway equation is proven:
```
C_{τ/2} has norm = 2·(-1)^m
```

**And** we can show:
```
For p ≡ 7 (mod 8): m even AND C_{τ/2-1} inherits norm +2
```

**Then**: Rigorous proof (modulo halfway equation).

### Option C: Algebraic Number Theory

**If** we can show:
- (2/p) = +1 for p ≡ 7 (mod 8)
- ⟹ ∃ α = x + y√p with N(α) = x² - py² = 2
- ⟹ α corresponds to convergent at τ/2 - 1

**Then**: Deep algebraic proof (requires genus theory or similar).

### Option D: Matrix Determinant

**If** we can compute:
- det(M_{τ/2-1}) where M = product of CF matrices
- Show it equals +2 using palindrome structure

**Then**: Computational/algebraic proof.

---

## Recommended Next Steps

### Immediate (Literature)

1. **Check classical CF texts** for halfway equation
   - Perron: "Die Lehre von den Kettenbrüchen" (1929)
   - Khinchin: "Continued Fractions" (1964)
   - Rockett-Szüsz: "Continued Fractions" (1992)

2. **MathOverflow query**: "Why does convergent at τ/2 - 1 have norm +2 for p ≡ 7 (mod 8)?"

### Theoretical (Explore)

3. **Matrix approach**: Compute det(M_k) symbolically for small k
4. **Algebraic NT**: Connect (2/p) splitting to convergent structure
5. **Stern-Brocot geometry**: Formalize tree-level interpretation

### Computational (Verify)

6. **Test d_k formula**: Is there exact relation norm_k = f(d_k)?
7. **Auxiliary sequence pattern**: Why d[τ/2] = 2 always?

---

## Status Summary

| Claim | Status | Confidence |
|-------|--------|-----------|
| norm = +2 at τ/2 - 1 (empirical) | ✅ VERIFIED | 100% (308/308) |
| Period τ ≡ 0 (mod 4) | ✅ NEAR-PROVEN | 95% (Legendre) |
| Halfway equation | ⏳ UNVERIFIED | Needs reference |
| Theoretical explanation | ❌ MISSING | 0% (open problem) |

**Overall**: Strong empirical pattern, theoretical mechanism unknown.

**Priority**: Find classical reference or derive from first principles.

---

**Files**:
- Empirical data: See test scripts
- Related theory: `pell-prime-patterns-literature-refs.md`, `pell-half-period-speedup.md`
- Proof attempt: `pell-x0-mod-p-proof.md` (conditional on norm = +2)
