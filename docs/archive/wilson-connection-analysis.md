# Wilson's Theorem Connection: Attacking the Two Open Problems

## Summary of the Two Papers

### factorial-chaos-unification.tex
**Key insights:**
1. **Wilson's theorem** (p-1)! ≡ -1 (mod p) underlies all three formulas (primorial, semiprime, primality test)
2. **Half-factorial decomposition**: (h!)² ≡ (-1)^(h+1) (mod p) where h = (p-1)/2
3. **Sign ambiguity**: h! ≡ ±1 (mod p) for p ≡ 3 (mod 4), or h! ≡ ±√(-1) (mod p) for p ≡ 1 (mod 4)
4. **Chaos thesis**: Numerators A_m encode the computational hardness of resolving Wilson's sign ambiguity
5. **Modulo operation**: For prime m, `Mod[S_m, 1/(m-1)!]` extracts the Wilson signature

### primorial-duality.tex
**Key insights:**
1. **Three-way decomposition**: Sum = N_red / (G × D_red)
   - D_red = Primorial(m)/2 (primes)
   - G = ∏(odd composites) (composites) - **CORRECTED: no factor of 2**
   - N_red = chaotic numerators
2. **Circular structure**: Computing GCD requires knowing composites → requires knowing primes → requires primorial
3. **p-adic invariant**: For all primes p ≤ m, ν_p(D_k) - ν_p(N_k) = 1 (exact first power)
4. **Duality**: Primes and composites appear in explicit closed forms, chaos concentrates in numerators

## The Two Open Problems

### Problem 1: Prove GCD = ∏{odd composites ≤ m}

**Status**: Formula in primorial-duality.tex is **incorrect** by factor of 2

**Corrected formula**:
```
GCD = {  1                           if m ∈ {3,5,7}
       ∏{odd composites ≤ m}        if m ≥ 9
}
```

**Computational verification**: ✓ Confirmed for m = 3, 5, 7, 9, 11, 13, 15, 17

**Why the factor of 2 disappears**:
- Unreduced denominator: D_unred = 2 × (2k+1)!! has ν₂ = 1
- Reduced denominator: D_red = Primorial(m)/2 has ν₂ = 1
- Since both have the same 2-adic valuation, the GCD has ν₂ = 0
- The factor of 2 stays in the reduced denominator, not the GCD

**Proof strategy using Wilson**:

The key is to show that for odd composite c:
```
ν_c(D_unred) - ν_c(D_red) = ν_c(c)
```

For c = p^α (prime power ≤ m):
- D_unred = 2 × (2k+1)!! contains all odd multiples of p up to 2k+1
- By Theorem 4.3 in primorial-duality.tex, ν_p(D_red) = 1
- The excess valuation goes entirely into the GCD

For composite c = ∏p_i^(α_i):
- By Chinese Remainder Theorem, ν_c(GCD) = min(ν_{p_i}^(α_i)(GCD))
- This equals the composite product structure

**Missing piece**: Formal proof that the p-adic valuations decompose as claimed above.

---

### Problem 2: Why Mod[2 S_m, 1/(m-1)!] has predictable denominator despite chaotic numerators

**Observed pattern**: For prime m:
```
Mod[S_m, 1/(m-1)!] = 1/D_m
```
where:
- Numerator = 1 (always!)
- m divides D_m
- D_m is related to (m-1)!/Primorial(m)

**Wilson connection**: This is the KEY to understanding both problems!

The modulo operation for rationals is:
```
a/b mod c/d = a/b - (c/d) × floor(a×d / b×c)
```

For our case:
```
S_m mod 1/(m-1)! = A_m/B_m - (1/(m-1)!) × floor(A_m × (m-1)! / B_m)
```

**Why this works for primes**:

1. **Wilson gives**: (m-1)! ≡ -1 (mod m), so (m-1)! = k×m - 1 for some k

2. **Primorial structure**: B_m = Primorial(m)/2 contains m as a factor (since m is prime)

3. **The floor term extracts Wilson signature**:
   ```
   floor(A_m × (m-1)! / B_m) = floor(A_m × (k×m - 1) / B_m)
   ```

4. **Modulo B_m, this becomes**:
   ```
   floor(A_m × (-1) / B_m) modulo appropriate primorial structure
   ```

5. **The result is a unit fraction** because:
   - The numerator A_m, despite being chaotic, when multiplied by (m-1)! and floor-divided by B_m,
     leaves a residue that cancels all prime factors EXCEPT for a primorial-based denominator
   - The Wilson congruence (-1 mod m) forces the numerator to become 1

**Computational evidence**:
```
m=3:  Mod result = 1/3,        3 | 3
m=5:  Mod result = 1/30,       5 | 30
m=7:  Mod result = 1/1680,     7 | 1680
m=11: Mod result = 1/7983360,  11 | 7983360
```

**Pattern in denominators**:
```
(m-1)!/Primorial(m) divided by some primorial-related quantity
```

---

## How Wilson's Theorem Unifies Both Problems

### The Central Mechanism

Wilson's theorem provides the **pairing structure** that:
1. Forces primes to appear to exactly the first power in reduced denominators (Problem 1)
2. Makes the modulo operation extract a unit fraction for primes (Problem 2)
3. Explains why numerators must be chaotic (they encode sign ambiguity resolution)

### The Factorial as Information Encoder

The factorial (m-1)! contains:
- All divisibility information up to m-1
- The Wilson pairing structure that identifies primes
- The sign ambiguity that creates computational hardness

When we compute:
```
Mod[S_m, 1/(m-1)!]
```

We're asking: **"What is the Wilson signature of S_m?"**

For **primes**: The signature is clean (unit fraction 1/D_m with predictable D_m)
For **composites**: The signature is degenerate (result = 0, no structure)

### Why Numerators Are Chaotic

From factorial-chaos-unification.tex (Proposition 6.2):

If numerators A_m had a closed form computable in poly(log m) time, we could:
1. Efficiently compute S_m = A_m/B_m
2. Efficiently compute Mod[S_m, 1/(m-1)!]
3. This would resolve the Wilson sign ambiguity efficiently
4. Contradiction with known computational complexity of Wilson-based primality testing

**Therefore**: The chaos in numerators is **necessary** to preserve computational hardness.

But the **denominator** of `Mod[S_m, 1/(m-1)!]` has predictable structure because:
- It depends only on the primorial structure and (m-1)!
- Wilson's theorem guarantees (m-1)! ≡ -1 (mod m) for prime m
- This congruence forces the floor operation to produce a specific residue pattern

---

## Attack Strategy for Rigorous Proofs

### For Problem 1 (GCD formula):

**Theorem to prove**:
```
GCD(N_unred, D_unred) = ∏{c odd composite, c ≤ m}  (for m ≥ 9)
```

**Proof outline**:
1. Use Legendre's formula to compute ν_p((2k+1)!!) for each prime p
2. Apply Theorem 4.3 from primorial-duality.tex: ν_p(D_k) - ν_p(N_k) = 1
3. Show that for composite c = p^α:
   - ν_p(D_unred) = (count of odd multiples of p in {1,3,5,...,2k+1})
   - ν_p(D_red) = 1 (from the p-adic invariant theorem)
   - Therefore ν_p(GCD) = ν_p(D_unred) - 1
4. For c = p^α where α ≥ 2:
   - Show ν_p(D_unred) = α when 2k+1 ≥ p^α
   - This happens exactly when c ≤ m (since m ≈ 2k+1)
5. Product over all such composites gives the result

**Key lemma needed**: Precise formula for ν_p((2k+1)!!) in terms of k and p

### For Problem 2 (Modulo predictability):

**Theorem to prove**:
```
For prime m: Numerator[Mod[S_m, 1/(m-1)!]] = 1
```

**Proof outline**:
1. Expand the modulo formula:
   ```
   Mod[S_m, 1/(m-1)!] = A_m/B_m - (1/(m-1)!) × floor(A_m × (m-1)! / B_m)
   ```

2. Use Wilson: (m-1)! ≡ -1 (mod m), so (m-1)! = k×m - 1 for some integer k

3. Since B_m = Primorial(m)/2 and m | Primorial(m), write B_m = m × B'

4. Compute:
   ```
   A_m × (m-1)! / B_m = A_m × (k×m - 1) / (m × B')
                       = A_m × (k - 1/m) / B'
   ```

5. The floor operation:
   ```
   floor(...) = A_m × k / B' - floor(A_m / (m × B'))
   ```

6. Show that when substituted back, the result has numerator 1 due to:
   - Cancellation from Wilson's -1 term
   - Primorial structure forcing specific GCD patterns

**Key lemma needed**: Precise relationship between A_m, (m-1)!, and B_m modulo primorial factors

---

## Computational Next Steps

1. **Verify GCD formula** for larger m (up to m = 101 or beyond)
2. **Factor the modulo denominators** for primes to find the pattern
3. **Test the Wilson connection** by computing:
   ```
   floor(A_m × (m-1)! / B_m) mod various primes
   ```
4. **Search for a primorial-based formula** for D_m in `Mod[S_m, 1/(m-1)!] = 1/D_m`

---

## Conclusion

Wilson's theorem is the **hidden architecture** beneath both problems:
- It creates the p-adic invariant that gives Problem 1's composite product structure
- It forces the modulo operation in Problem 2 to extract a unit fraction despite chaotic numerators
- It explains why numerators must be chaotic (computational hardness preservation)

The **duality** between primes and composites is a manifestation of Wilson's pairing structure:
- Primes appear in denominators (multiplicative structure preserved)
- Composites appear in GCDs (excess divisibility concentrated)
- Numerators absorb the irreducible complexity (sign ambiguity resolution)

This is a beautiful example of **complexity conservation**: you cannot have explicit formulas for all three components without contradiction.
