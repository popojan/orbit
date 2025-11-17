# TODO: Next Session Continuation Tasks

**Date**: 2025-11-17
**Context**: After CF period divisibility & center norm discovery session

---

## 🎯 Priority 1: Theoretical Understanding

### 1.1 Literature Check - Is CF Center Norm ±2 Known?

**Question**: Is the exact norm ±2 at period/2 documented in literature?

**Action**:
- Check Barbeau "Pell's Equation" (2003), Chapter 3 (CF properties)
- Check Mordell "Diophantine Equations" (1969), Chapter 8 (Pell solutions)
- Check Perron "Die Lehre von den Kettenbrüchen" (1929)
- If not found → MathOverflow query with precise formulation

**Why important**: Determines if we have a novel computational observation or rediscovery.

**Status**: ⚠️ UNKNOWN novelty

---

### 1.2 Theoretical Proof Attempt - Period Divisibility

**Goal**: Prove rigorously that p mod 8 determines period mod 4.

**Approaches to try**:

1. **Genus Theory Path**:
   - Use Rédei symbols to characterize 2-rank of class group
   - Connect to period divisibility via unit structure
   - Reference: Cox "Primes of the form x²+ny²"

2. **Quadratic Reciprocity Path**:
   - (2/p) Legendre symbol determines p mod 8
   - Palindrome symmetry forces convergent at center to have minimal |norm|
   - Why exactly ±2? (not ±4, ±3, etc.)

3. **CF Recurrence Path**:
   - Analyze recurrence relations for CF partial quotients
   - Show convergent norms follow predictable pattern
   - Prove center convergent norm formula

**Current status**: 🔬 NUMERICAL (619/619 primes, 0 exceptions)

---

## 🔬 Priority 2: Computational Extensions

### 2.1 Implement Early Period Detection Algorithm

**Idea**: Stop CF expansion when norm ±2 found → period = 2 × index

**Implementation**:
```mathematica
FastCFPeriod[p_] := Module[{...},
  (* Compute convergents until x²-py²=±2 *)
  (* Return: 2 × index *)
]
```

**Test**: Compare speed on primes p > 10⁶ vs. standard CF algorithm

**Expected gain**: 2× faster period detection

---

### 2.2 Recursive Structure Exploration

**Question**: Do quarter/eighth-period convergents have patterns?

**Current state**:
- Half-period: norm ±2 ✓ (universal)
- Quarter-period: no universal pattern (tested, see `analyze_quarter_period.wl`)

**Next**:
- Focus on primes with period divisible by 8
- Test eighth-period convergents
- Look for conditional patterns (e.g., only for certain p mod values)

---

### 2.3 Determine p mod 8 from CF

**Observation**: Sign of first norm ±2 → determines p mod 8

**Algorithm**:
```
Compute CF until norm ±2 found:
  If norm = +2 → p ≡ 7 (mod 8)
  If norm = -2 → p ≡ 3 (mod 8)
```

**Utility**: Can determine mod class from CF alone (no modular arithmetic)

---

## 🧩 Priority 3: Extensions to Composites

### 3.1 Semiprimes (p×q)

**Test**:
- Does period divisibility pattern extend to semiprimes?
- For pq with p,q ≡ 3,7 (mod 8), what is period mod 4?
- Does center convergent still have small norm?

**Start with**: Small semiprimes like 15, 21, 33, 35, 39, 51, 55, 57

---

### 3.2 Twin Primes Correlation

**Question**: For twin primes (p, p+2), is there period correlation?

**Examples**: (3,5), (5,7), (11,13), (17,19), (29,31), (41,43)

**Hypothesis**: Since p and p+2 have same mod 8 class → periods may have related divisibility

---

## ❌ DO NOT REPEAT (Failed Approaches)

### Falsified Hypotheses:
1. **Period magnitude prediction**: r=0.238 (chaotic, no useful pattern)
2. **Distance-based R(n) model**: r=0.197 (failed)
3. **Class number h(p) connection**: All h(p) odd for p≡3,7 (mod 8), no correlation
4. **Quarter-period universal pattern**: Varies, no single rule found

### Lessons Learned:
- **Structure > Correlation**: Focus on exact divisibility rules, not approximate fits
- **Mechanism First**: Don't fit models without understanding underlying mechanism
- **Magnitude vs. Divisibility**: Divisibility patterns are clean; magnitudes are chaotic

---

## ✅ Established Numerical Theorems (>99% confidence)

**Can be assumed in next session:**

1. **Period Divisibility Theorem** [619/619 primes]:
   ```
   p ≡ 3 (mod 8) → period ≡ 2 (mod 4)
   p ≡ 7 (mod 8) → period ≡ 0 (mod 4)
   ```

2. **Mod 8 Theorem** [1228/1228 primes]:
   ```
   p ≡ 7 (mod 8) ⟺ x ≡ +1 (mod p)  (fundamental solution)
   ```

3. **CF Center Norm Pattern** [100/100 random primes + 5 Mersenne primes]:
   ```
   Convergent at period/2 has norm ±2:
   - p ≡ 7 (mod 8) → norm = +2
   - p ≡ 3 (mod 8) → norm = -2
   ```

---

## 🧠 Mechanism (Understood but Not Proven)

**Chain of reasoning**:
```
p mod 8 → (2/p) Legendre → splitting of 2 in Q(√p)
        → Pell ±2 solvability → period divisibility
```

**Key insight**: Palindromic CF structure (classical, Lagrange 1770) forces convergent at center to have special properties. Connection to norm ±2 may be novel or may follow from classical theory (needs literature check).

---

## 📚 References for Next Session

**Scripts to review**:
- `scripts/test_cf_center_robust.wl` - Main validation (100 primes)
- `scripts/analyze_cf_palindrome.wl` - CF structure analysis
- `scripts/analyze_quarter_period.wl` - Recursive patterns

**Documentation**:
- `docs/cf-center-norm-pattern.md` - Pattern description + computational implications
- `docs/pell-plus-minus-2-connection.md` - Mechanism explanation
- `docs/period-divisibility-discovery.md` - Main theorem

**Key files modified**:
- `docs/STATUS.md` - Updated with new numerical theorems

---

## 🎓 Research Philosophy (from this session)

**User's guidance**:
- "exploration mode, not publication mode"
- "struktura, ne korelace" (structure, not correlation)
- "chápání mechanismu" (understanding mechanism)
- "full transparency == nic nemažeme" (full transparency, delete nothing)
- Test adversarially: Mersenne primes + random samples

**Approach**:
- Focus on EXACT patterns (divisibility rules)
- Avoid ML/correlation without mechanism
- Document failures honestly
- One topic = one primary document (avoid bloat)
- Always update STATUS.md with epistemic tags

---

## 🔮 Open Questions for Future

1. Does CF center norm ±2 appear in classical literature?
2. Can we prove period divisibility from genus theory?
3. Does recursive structure exist for eighth/sixteenth-period?
4. Do semiprimes follow similar patterns?
5. Are there computational applications (primality testing, factorization)?
6. Connection to other Diophantine equations (x²-Dy²=N for N>2)?

---

**Last commit**: dbdac78
**Status**: Ready for continuation after context reset
**Next action**: Pick Priority 1.1 or 2.1 based on available resources
