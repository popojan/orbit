(* ================================================================ *)
(* ANALYTIC det(W^(k)) for 3×3                                    *)
(* W_{np} = Floor[k · γ_n · ln(p_j) / (2π)]                      *)
(* For 3×3: γ = {γ1, γ2, γ3}, p = {2, 3, 5}                     *)
(*                                                                  *)
(* Floor[x] = x - {x}, so W = k·A - R where A = γ⊗ℓ/(2π)       *)
(* and R_{np} = {k·γ_n·ln(p)/(2π)} ∈ [0,1)                       *)
(*                                                                  *)
(* det(W) = det(k·A - R) — but A is rank 1, so det(k·A) = 0      *)
(* All the info is in R (residuals).                               *)
(* ================================================================ *)

g = Table[N[Im[ZetaZero[n]], 30], {n, 3}];
lp = Table[Log[N[Prime[j], 30]], {j, 3}];

(* Exact symbolic: a_n = γ_n/(2π), ℓ_j = ln(p_j) *)
(* W_{nj}(k) = Floor[k · a_n · ℓ_j] *)

(* det as piecewise constant function of k *)
(* Find ALL breakpoints where any Floor[k·a_n·ℓ_j] changes *)

Print["╔══════════════════════════════════════════════════════╗"];
Print["║  ANALYTIC: det(W^(k)_3×3) as function of k          ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

(* The products a_n · ℓ_j for 3×3 *)
products = Table[g[[n]] lp[[j]] / (2 Pi), {n, 3}, {j, 3}];
Print["a_n · ℓ_j products:"];
Do[Print["  n=", n, ": ", NumberForm[#, {10, 7}] & /@ products[[n]]],
  {n, 3}];

(* Breakpoints: k where Floor[k · products[[n,j]]] changes
   = m / products[[n,j]] for integer m *)
(* In range k ∈ [0.5, 2.0], find all breakpoints *)
kMin = 0.5; kMax = 2.0;
breakpoints = {};
Do[
  p = products[[n, j]];
  mMin = Ceiling[kMin * p];
  mMax = Floor[kMax * p];
  Do[
    bp = m / p;
    If[kMin < bp < kMax,
      AppendTo[breakpoints, {bp, n, j, m}]],
  {m, mMin, mMax}],
{n, 3}, {j, 3}];
breakpoints = SortBy[breakpoints, First];
Print["\nBreakpoints in [", kMin, ", ", kMax, "]: ", Length[breakpoints]];

(* Compute det in each interval between breakpoints *)
bpValues = Union[breakpoints[[All, 1]]];
Print["Unique breakpoint k-values: ", Length[bpValues]];

(* Sample det at midpoints of intervals *)
Print["\n=== det(k) between breakpoints near ζ(3) = 1.2021 ===\n"];

(* Focus near ζ(3) *)
z3 = N[Zeta[3], 30];
nearBP = Select[bpValues, Abs[# - z3] < 0.05 &];
Print["Breakpoints within 0.05 of ζ(3):"];
Do[
  Print["  k = ", NumberForm[bp, {15, 12}],
    "  Δ = ", NumberForm[bp - z3, {8, 8}]],
{bp, nearBP}];

(* Compute det at ζ(3) and at nearby breakpoints *)
wAtK[k_] := Table[Floor[k g[[n]] lp[[j]] / (2 Pi)], {n, 3}, {j, 3}]

Print["\ndet at and near ζ(3):"];
kSamples = Join[{z3 - 0.002, z3 - 0.001}, nearBP,
  {z3, z3 + 0.001, z3 + 0.002}] // Sort // DeleteDuplicates;
Do[
  w = wAtK[k];
  d = Det[w];
  isZ3 = If[Abs[k - z3] < 10^-10, " ← ζ(3)", ""];
  isBP = If[MemberQ[nearBP, k], " [BP]", ""];
  Print["  k=", NumberForm[k, {15, 12}], "  det=",
    PaddedForm[d, 4], isZ3, isBP],
{k, kSamples}];

(* KEY: what are the breakpoints that BRACKET ζ(3)? *)
Print["\n=== Breakpoints bracketing ζ(3) ==="];
below = Select[bpValues, # < z3 &];
above = Select[bpValues, # > z3 &];
kBelow = Last[below];
kAbove = First[above];
Print["k_below = ", NumberForm[kBelow, {20, 17}]];
Print["k_above = ", NumberForm[kAbove, {20, 17}]];
Print["ζ(3)    = ", NumberForm[z3, {20, 17}]];
Print["Gap:     ", NumberForm[kAbove - kBelow, {10, 10}]];
Print["ζ(3) position in gap: ",
  NumberForm[(z3 - kBelow) / (kAbove - kBelow), {6, 4}]];

(* Which entry changes at each bracketing breakpoint? *)
Do[
  bp = breakpoints[[All, {1}]] // Flatten;
  entries = Select[breakpoints, First[#] == bpk &];
  Print["At k=", NumberForm[bpk, {15, 12}], ": entries change: ",
    {#[[2]], #[[3]], #[[4]]} & /@ entries],
{bpk, {kBelow, kAbove}}];

(* det in the interval containing ζ(3) *)
Print["\ndet in interval [k_below, k_above]: ", Det[wAtK[(kBelow + kAbove)/2]]];
Print["det at ζ(3): ", Det[wAtK[z3]]];

(* ================================================================ *)
(* FULL PICTURE: det(k) for k ∈ [0.5, 2.0]                       *)
(* Count zeros and plot structure                                   *)
(* ================================================================ *)
Print["\n=== det(k) structure in [0.5, 2.0] ===\n"];

(* Sample det at midpoints of all intervals *)
detValues = {};
prevK = kMin;
Do[
  midK = (prevK + bpk) / 2;
  d = Det[wAtK[midK]];
  AppendTo[detValues, {midK, d}];
  prevK = bpk,
{bpk, bpValues}];
(* Last interval *)
AppendTo[detValues, {(Last[bpValues] + kMax) / 2, Det[wAtK[(Last[bpValues] + kMax) / 2]]}];

nZeros = Count[detValues, {_, 0}];
nTotal = Length[detValues];
Print["Intervals: ", nTotal];
Print["det = 0 intervals: ", nZeros, " (", NumberForm[100. nZeros / nTotal, {4, 1}], "%)"];

(* Which det values appear? *)
detTally = Tally[detValues[[All, 2]]] // SortBy[#, -Abs[#[[1]]] &] &;
Print["det value distribution: ", detTally];

(* Find ALL intervals where det = -2 (same as ζ(3)) *)
z3det = Det[wAtK[z3]];
Print["\ndet at ζ(3) = ", z3det];
sameDetIntervals = Select[detValues, #[[2]] == z3det &];
Print["Intervals with det = ", z3det, ": ", Length[sameDetIntervals]];
Print["k ranges: ", NumberForm[#[[1]], {8, 5}] & /@ sameDetIntervals];
