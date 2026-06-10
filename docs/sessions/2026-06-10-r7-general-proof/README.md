# R7 General Proof — Self-Similarity Route (P1)

**Date:** 2026-06-10
**Goal:** Prove the block transfer correction formula (R7, Theorem 4.2 in
`docs/papers/ballot-closed-form.tex`) for **all** q₁, removing the
"verified symbolically for q₁ ≤ 9" limitation.

## Background

R7 claims, for a Sturmian block (d₀, w, p₁ = wq₁+1, q₁):

```
Δ[d₀+2+d, s] = Σ_{m=1}^{d+1} v_{d-m+1}(p₁ - wm) · Binomial[d₀-2+m(w+1)-s, mw-1]
```

with v_j(p) = ((p-wj)/p)·Binomial[p+j-1, j] the Irving–Rattan uniform formula.

The phase recursion (from `2026-04-09-ballot-closed-form/scripts/inductive_proof_r7_v2.wl`):
each phase m = 1..q₁ does **pad with 0 → L¹ (rise) → inject T_{mw}[d₀+m-1, s]
into new top row → L^{w-1} (within-stairs; L⁰ for the final phase)**.

## Key structural observation (this session)

The recursion is **linear** and each phase makes exactly one scalar injection

```
tCreate(m) = Binomial[d₀-2+m(w+1)-s, mw-1]
```

into the newly created row. Therefore

```
δ_d = Σ_{m=1}^{d+1} tCreate(m) · K(m → d)
```

where K(m → d) is the propagation kernel of a *unit* injection at row index
m-1 in phase m. Crucially K is **independent of d₀ and s** (they enter only
through tCreate), and the binomial factor in R7 is *exactly* tCreate(m).
So R7 is equivalent to a statement about the kernel alone.

Note: K is NOT the free composition L^{(q₁-m)w} — the per-phase padding
truncates the vector (row d exists only from phase d+1 on). Sanity check
w=1, q₁=4, m=1, d=2: free kernel gives C(4,2)=6, truncated propagation
gives 5 = v_2(4). The truncation is load-bearing.

## 🤔 HYPOTHESIS (documented before testing)

**H1 (kernel = uniform ballot value):**

```
K(m → d) = v_{d-m+1}(p₁ - wm)        for all 1 ≤ m ≤ d+1 ≤ q₁
```

**H2 (mechanism / self-similarity):** the truncated propagation of the
phase-m unit injection is verbatim the state-vector DP of lattice paths
from (1,0) below the **uniform two-term staircase** S(x) = ⌊q_res·x/P⌋
with P = p₁ - wm = (q₁-m)w + 1, q_res = q₁ - m:

- birth tail of phase m = w-1 within-transitions (x = 2..w),
- each later phase = rise (x = rw+1) + w-1 withins,
- final phase = rise at x = P,

since rises of ⌊q_res·x/P⌋ sit exactly at x = rw+1, r = 1..q_res.
Endpoint state vector of that DP is v_j(P) (two-term exactness / cycle
lemma, already proven in the paper), giving H1 with j = d-m+1.

**What would confirm:** exact integer match of K(m→d) against both
v_{d-m+1}(p₁-wm) (H1) and an independent direct staircase DP (H2),
for w ∈ {1..5}, q₁ ∈ {2..8}, all m, d.

**What would falsify:** any mismatch. In particular H2 could fail from an
off-by-one in the pattern bookkeeping even if H1 holds.

**If confirmed:** R7 is proven for all q₁ by linearity + self-similarity;
the only inherited ingredients are the phase recursion (derived from the
DP definition) and the uniform formula (cycle lemma). No Zeilberger
certificate needed. This resolves Open Problem 1 of the paper.

## ✅ CONFIRMED (both hypotheses, same session)

`scripts/kernel_hypothesis_test.wl`:
- **H1:** 595 checks (w ∈ 1..5, q₁ ∈ 2..8, all m, d), 0 failures.
- **H2:** 140 checks against an independent direct staircase DP, 0 failures.
- **Reassembly:** Σ_m tCreate(m)·K(m→d) ≡ R7 — 720 checks (numeric d₀, s
  sweeps, exact arithmetic), 0 failures.

`scripts/endtoend_actual_blocks.wl`: actual level-1 block transfer
matrices (√2, √3, √5, √7, √37, φ, e, 1+π/10; w ∈ {1,2,6}) —
Δ = T − M matches R7 with **d₀ = input dimension, support rows
j = d₀..d₀+q₁−1, depth d = j − d₀**. ALL MATCH.

## The proof (now in the paper)

1. **Step 1 (dynamics):** δ = T − M obeys: within-stair → L;
   rise m → pad + L + scalar injection t_m = T_{j_m}(mw)
   = C(d₀−2+m(w+1)−s, mw−1) at the new row j_m = d₀+m−1.
   (4-line computation from the DP recurrences; the "mysterious"
   offset A = d₀−2 is just this Toeplitz entry rewritten.)
2. **Step 2 (linearity):** δ_d = Σ_m t_m·K_m(d), K_m = unit-injection
   kernel, independent of d₀, s; lower-triangularity kills m > d+1.
3. **Step 3 (self-similarity):** the truncated propagation schedule of
   K_m is verbatim the within/rise DP of the two-term staircase
   ⌊q_res·x/P⌋, q_res = q₁−m, P = wq_res+1 = p₁−wm (rises at
   x = rw+1 = ⌈rP/q_res⌉). Hence K_m(d) = v_{d−m+1}(p₁−wm) by
   two-term exactness (cycle lemma / Irving–Rattan). ∎

**R7 is now proven for all q₁, w, d₀, s.** Open Problem 1 of
`ballot-closed-form.tex` is resolved. No Zeilberger certificate needed —
the truncation that breaks naive Vandermonde composition (free kernel
gives 6 where truth is 5 at w=1, q₁=4, m=1, d=2) is precisely the
staircase constraint reappearing one level down.

## Errata found in the draft paper (fixed)

The draft had an internal index inconsistency (+2 shift) between the
theorem statement and reality:
- **Thm 4.2 / intro:** support claimed on rows j ≥ d₀+2, d ≤ q₁−2 →
  actually j ≥ d₀, d ≤ q₁−1 (verified on actual blocks).
- **Prop 4.1:** "M = T for j ≤ d₀+1" → correct is j ≤ d₀−1; new
  one-line proof via monotonicity (path height ≤ endpoint height).
- **Example 4.3 (√5):** stated rows 6,7 with Δ[6,s] = C(7−s,1),
  Δ[7,s] = 3C(7−s,1)+C(10−s,3) — wrong rows, wrong coefficient
  (v₁(7) = 5, not 3), wrong binomial shifts. Correct: rows 4..7,
  Δ[4,s] = C(5−s,1), Δ[5,s] = 5C(5−s,1)+C(8−s,3).
- Two cosmetic row labels in §5 (Rothe–Hagen, hypergeom classification).

## Files changed

- `docs/papers/ballot-closed-form.tex` — proof of Thm 4.2 replaced
  (Steps 1–3 above), Prop 4.1 fixed + new proof, Example 4.3 corrected,
  Remark (Offset) rewritten as an identity, Open Problem 1 removed,
  index errata fixed. Compiles clean (2× pdflatex, 0 errors).
- `scripts/kernel_hypothesis_test.wl`, `scripts/endtoend_actual_blocks.wl`,
  `scripts/index_dictionary_check.wl` — verification scripts.

## Remaining soft spots (not blocking, for future polish)

- **Thm 5.1 (w=1 Rothe–Hagen collapse):** still "verified symbolically
  for d ≤ 5"; tightening = exhibit the explicit Rothe–Hagen parameter
  substitution (mechanical, classical identity).
- **Thm 5.2 (Saalschützian classification):** proof is per-fixed-w via
  Mathematica `Sum`; fine as stated (classification claim).

