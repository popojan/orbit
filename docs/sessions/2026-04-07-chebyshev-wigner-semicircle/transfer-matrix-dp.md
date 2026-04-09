# Transfer Matrix Decomposition of DP(x)

**Date:** 2026-04-09
**Status:** Verified numerically, structural insight (not a shortcut)
**Context:** Arose from exploring DP(x) between convergents of the Beatty Ballot Theorem

## Setup

For irrational alpha > 1, the staircase S(x) = Floor[x/alpha] defines a lattice path
counting problem: DP(x) = number of monotonic paths from (1,0) to (x, S(x)) staying
weakly below S.

The Beatty Ballot Theorem shows DP(p) = B(p,q) at convergent/semi-convergent
numerators p. Between convergents, DP(x) is not a ballot number. What is it?

## Transfer matrix formulation

The DP recurrence dp(x, y) = dp(x-1, y) + dp(x, y-1) with constraint y <= S(x)
can be reformulated as matrix multiplication on column vectors.

**State vector:** v(x) = (dp(x, 0), dp(x, 1), ..., dp(x, m))^T where m = S(x).

**Transfer matrix:** L_m is the (m+1) x (m+1) lower triangular all-ones matrix:

    (L_m)_{ij} = 1 if i >= j, else 0

**Step rules:**
- Within stair (S(x) = S(x-1)): v(x) = L_m . v(x-1)
- At rise (S(x) = S(x-1) + 1): v(x) = L_{m+1} . Append[v(x-1), 0]

**DP(x) = Last[v(x)]** always.

## Powers of L_m

L_m^j has explicit entries: (L_m^j)_{rs} = Binomial[r - s + j - 1, j - 1].

This gives a closed form within each stair: if the stair at height m starts at
position a with state vector v, then:

    DP(a + j) = Sum_{s=0}^{m} Binomial[m - s + j - 1, j - 1] * v_s

## Stair widths and Sturmian structure

The staircase S(x) = Floor[x/alpha] has stairs of width Floor[alpha] or Ceil[alpha],
alternating in the Sturmian pattern determined by CF(alpha).

For alpha = Pi = [3; 7, 15, 1, 292, ...]:
- First 7 stairs: all width 3 (= Floor[Pi])
- Then one stair of width 4 (= Ceil[Pi])
- Pattern: {3,3,3,3,3,3,3, 4, 3,3,3,3,3,3, 4, ...}

## State vectors at convergent positions

Verified for alpha = Pi, convergent numerators 3, 7, 10, 13, 16, 19, 22:

    x=3   v = {1}                                          DP = 1
    x=7   v = {1, 4, 4}                                    DP = 4
    x=10  v = {1, 7, 22, 22}                               DP = 22
    x=13  v = {1, 10, 49, 140, 140}                        DP = 140
    x=16  v = {1, 13, 85, 357, 969, 969}                   DP = 969
    x=19  v = {1, 16, 130, 700, 2695, 7084, 7084}          DP = 7084
    x=22  v = {1, 19, 184, 1196, 5750, 20930, 53820, 53820}  DP = 53820

**Pattern at convergent positions:** Last two entries are always equal (v_m = v_{m-1}).
This is a consequence of the rise operation: the new top entry copies from below.
Last entry = ballot number B(p, q).

Between convergents (e.g., x=25..46 for Pi): state vectors grow more complex,
last two entries differ, and DP is not a ballot number.

## What this IS and ISN'T

**IS:** A structured decomposition of DP(x) as a product of explicit transfer matrices
(powers of L_m) along the Sturmian word. Each matrix has binomial-coefficient entries.

**ISN'T:** A computational shortcut (still need CF of alpha to determine stair widths)
or a single closed-form formula (the product depends on the full Sturmian history).

## Circularity note

To determine the transfer matrices between convergents, you need the stair widths,
which form the Sturmian word — and to know the Sturmian word, you need the CF of alpha,
which already gives you the convergents. So the decomposition doesn't help you
*find* ballot hits; it helps you *understand* what DP(x) does between them.

## Why convergent positions are special

At a convergent position p_k, the product of transfer matrices telescopes:
all stair widths in [p_{k-1}, p_k] are uniform (= Floor[alpha] or Ceil[alpha]),
and the repeated application of L^w with the same w gives a structured state vector
whose top entry is the ballot number. The uniformity of stair widths between
convergents is equivalent to the floor agreement lemma.

## Open question

The state vector v(x) at convergent positions has the structure {1, ?, ?, ..., B, B}.
Is there a closed form for the intermediate entries? They appear to involve
rising factorials or generalized ballot numbers. If so, the transfer matrix product
between convergents might have a clean factored form.

## Scripts

- `scripts/transfer_matrix_v2.wl` — Verified implementation, all 50 points match
- `scripts/dp_between_convergents.wl` — DP/B ratio analysis
- `scripts/dp_pi_detail.wl` — Exact ratios for alpha = Pi
- `scripts/dp_pi_hierarchy.wl` — Within-stair ratio structure
