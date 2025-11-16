# Rigorous Foundation Review - Co OPRAVDU máme dokázáno

**Datum:** 17. listopadu 2025, ráno
**Účel:** Pečlivá rekapitulace před dalším rigorózním dokazováním

---

## ✅ TIER 1: RIGOROUSLY PROVEN (forward proofs)

### 1. M(n) Definition
```
M(n) = ⌊(τ(n) - 1) / 2⌋ = count of divisors d where 2 ≤ d ≤ √n
```
**Proof:** Elementary from definition of τ(n).
**Status:** ✅ TRIVIAL

### 2. L_M(s) Convergence
```
L_M(s) = Σ_{n=1}^∞ M(n)/n^s converges absolutely for Re(s) > 1
```
**Proof:** M(n) ≤ τ(n), so |M(n)/n^s| ≤ τ(n)/n^σ. Since Σ τ(n)/n^σ converges for σ > 1 (comparison with ζ²), so does L_M(s).
**Status:** ✅ PROVEN

### 3. Non-multiplicativity
```
M(mn) ≠ M(m)M(n) in general
```
**Proof:** Counterexample: M(4·9) = M(36) = 3, but M(4)·M(9) = 1·2 = 2.
**Status:** ✅ PROVEN

### 4. Integral Representation (from Hurwitz)
```
L_M(s) = 1/Γ(s) ∫₀^∞ t^{s-1} [Li_s(e^{-t}) - e^{-t}] / (1-e^{-t}) dt
```
**Derivation:**
- Start: L_M(s) = Σ_{d=2}^∞ d^{-s} ζ(s,d) (proven by rearranging double sum)
- Use Hurwitz integral: ζ(s,a) = 1/Γ(s) ∫₀^∞ t^{s-1} e^{-at}/(1-e^{-t}) dt
- Interchange sum and integral (justified for Re(s) > 1)
- Inner sum: Σ_{d=2}^∞ d^{-s} e^{-dt} = Li_s(e^{-t}) - e^{-t}

**Status:** ✅ PROVEN (assuming Hurwitz formula, which is standard)
**Reference:** Tahák řádek 42-56, `docs/LM-integral-representation.md`

---

## 🔬 TIER 2: NUMERICALLY VERIFIED (high confidence, not proven)

### 1. Closed Form
```
L_M(s) = ζ(s)[ζ(s) - 1] - C(s)
where C(s) = Σ_{j=2}^∞ H_{j-1}(s)/j^s, H_j(s) = Σ_{k=1}^j k^{-s}
```
**Evidence:**
- Verified to 10+ digits for 100+ test points (Re(s) > 1)
- Independent derivation via two methods
- Written "proof" in `docs/papers/dirichlet-series-closed-form.tex`

**Status:** 🔬 NUMERICALLY VERIFIED
**Caveat:** ⚠️ Not peer-reviewed. Treat as conjecture until formally proven.
**What's needed:** Rigorous proof that the algebraic manipulations are valid.

### 2. Schwarz Reflection Symmetry
```
L_M(conj(s)) = conj(L_M(s))
```
**Evidence:**
- Tested at 6 points on critical line: error < 10^{-15}
- Algebraically true at every finite truncation of closed form

**Status:** 🔬 NUMERICALLY OBSERVED
**What's missing:** Rigorous proof from integral representation!

**VČEREJŠÍ CHYBA:** Řekl jsem "Schwarz symmetry PROVEN from integral form", ale explicitní důkaz není sepsán!

**Proof sketch (needs to be written rigorously):**
- For integral with real limits, real integration variable, if integrand satisfies f(t,conj(s)) = conj(f(t,s)), then integral is Schwarz-symmetric
- Need to verify: Γ(conj(s)) = conj(Γ(s)), t^{conj(s)} = conj(t^s) for real t > 0, Li_s real-valued...
- **TODO:** Write this out properly!

---

## 🤔 TIER 3: THEORETICALLY DERIVED (worked backwards, not forward proof)

### 1. Functional Equation Existence
```
γ(s) L_M(s) = γ(1-s) L_M(1-s)
```
**Derivation method:** Constraint analysis (assumed FR holds, solved for γ(s))
**Status:** ✅ DERIVED (if FR holds, then γ must have this form)
**Caveat:** ⚠️ This is NOT a proof that FR exists! It's a necessary condition.

### 2. Explicit γ(s) Formula
```
γ(s) = π^{-s/2} Γ(s/2) √[L_M(1-s) / L_M(s)]
```
**Derivation:** Worked backwards from FR requirement
**Status:** ✅ SELF-CONSISTENT
**Caveat:** ⚠️ Self-referential (requires knowing L_M to compute γ)
**What's missing:** Independent formula for γ(s) not involving L_M

### 3. Expanded γ(s) Formula
```
γ(s) = π^{(1-3s)/2} [Γ²(s/2) / Γ((1-s)/2)] √{[R(s)²ζ(s)² - R(s)ζ(s) - C(1-s)] / [ζ(s)² - ζ(s) - C(s)]}
```
**Derivation:** Substituted closed form into self-referential formula
**Status:** ✅ ALGEBRAICALLY CONSISTENT
**Caveat:** ⚠️ Still self-referential (requires C(s) which is part of L_M definition)

---

## ❌ TIER 4: FALSIFIED

### 1. Classical Gamma Factor
```
γ(s) = π^{-s/2} Γ(s/2) does NOT work off critical line
```
**Evidence:** Tested, error ~ 10^{-6}
**Status:** ❌ FALSIFIED

### 2. L_M Zeros at Riemann Zeros
```
L_M(ρ) ≠ 0 where ζ(ρ) = 0
```
**Evidence:** Tested first 20 Riemann zeros, |L_M(ρ)| ranges 0.17 to 1.32
**Status:** ❌ FALSIFIED

### 3. Closed Form Numerical Convergence for Re(s) ≤ 1
```
C(s) = Σ H_{j-1}(s)/j^s does NOT converge numerically in critical strip
```
**Evidence:** Oscillates wildly (factor 3x swings) for jmax = 100 to 500
**Status:** ❌ FALSIFIED (for numerical use; algebraic properties may still hold)

---

## 📋 SUMMARY: Co nám OPRAVDU chybí

### Priority 1: Rigorous Proofs Needed

1. **Schwarz Symmetry from Integral Form**
   - Máme integrální formu (PROVEN)
   - Tvrdíme Schwarz (NUMERICAL)
   - **CHYBÍ:** Explicitní důkaz že integral má Schwarz property
   - **Effort:** 2-3 hodiny, straightforward

2. **Closed Form Algebraic Validity**
   - Máme odvození (NUMERICAL match)
   - **CHYBÍ:** Rigorous proof že algebraické manipulace jsou platné
   - **Effort:** 4-6 hodin, non-trivial interchange of sums

3. **Residue at s=1**
   - Tvrdíme Res[L_M, s=1] = 2γ-1 (včera NUMERICAL)
   - **CHYBÍ:** Rigorous computation z Laurent expansion
   - **Effort:** 3-4 hodiny, careful asymptotic analysis

### Priority 2: What Would Be Nice to Have

4. **Non-self-referential γ(s)**
   - Současný γ(s) vyžaduje znát L_M(s)
   - **GOAL:** Formula pro γ(s) nezávislá na L_M
   - **Difficulty:** Hard, možná neexistuje

5. **Analytic Continuation Method**
   - Integrální forma funguje i pro Re(s) < 1?
   - **TODO:** Verify convergence properties of integral
   - **Effort:** Unknown, potentially research-level

---

## 🎯 Recommended Focus for Today

### Morning Session: Prove Schwarz Symmetry Rigorously

**Goal:** Write clean proof that integral representation implies Schwarz symmetry

**Steps:**
1. State lemma clearly
2. Verify each component (Γ, t^s, Li_s, etc.) has conjugation property
3. Combine to show ∫ f(t,conj(s)) dt = conj(∫ f(t,s) dt)
4. Write in LaTeX for permanence

**Deliverable:** `docs/schwarz-symmetry-proof.md` or `.tex`

**Impact:** Upgrade STATUS from NUMERICAL → PROVEN

---

### Afternoon Session: Rigorous Residue Computation

**Goal:** Prove Res[L_M, s=1] = 2γ-1 analytically

**Approach:**
- Laurent expansion of ζ(s)[ζ(s)-1] around s=1
- Prove C(s) is regular at s=1 (no pole)
- Extract residue coefficient

**Deliverable:** `docs/residue-proof-rigorous.tex`

**Impact:** Upgrade yesterday's NUMERICAL claim to PROVEN

---

## 🔑 Key Principle Going Forward

**DISTINGUISH:**
- ✅ PROVEN = Forward proof from axioms/definitions
- 🔬 NUMERICAL = High confidence numerical evidence
- 🤔 DERIVED = Worked backwards (necessary but not sufficient)
- ❌ FALSIFIED = Tested and found false

**DON'T MIX THEM UP!**

Yesterday we got excited and started claiming things were proven when they were only numerical or derived. Today: calm, methodical, rigorous.

---

## Tahák Status Notes

Tahák (integral-formula-cheatsheet.tex) říká na konci (řádek 174):
> "Všechny výsledky jsou author-verified only. Treat as conjectures!"

To je správný postoj. Dnes začneme upgrading claims na PROVEN status.
