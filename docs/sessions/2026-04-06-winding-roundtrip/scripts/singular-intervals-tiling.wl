(* ================================================================ *)
(* Map singular intervals S_n for n=3..15 near k = ζ(3)           *)
(* For each n: find intervals where det(W^(k)_n) = 0              *)
(* Visualize: does ζ(3) thread through gaps?                       *)
(* ================================================================ *)

nMax = 15;
gList = Table[N[Im[ZetaZero[n]], 25], {n, nMax}];
lpList = Table[Log[N[Prime[j], 25]], {j, nMax}];

fWM[nz_, k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nz}, {j, nz}]

z3 = N[Zeta[3], 25];

(* For each n, find breakpoints in [ζ(3)-0.1, ζ(3)+0.1] *)
(* and identify which intervals have det = 0 *)

kLo = z3 - 0.1;
kHi = z3 + 0.1;

Print["╔══════════════════════════════════════════════════════╗"];
Print["║  SINGULAR INTERVAL TILING near ζ(3)                  ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

Do[
  (* Find breakpoints for n×n matrix *)
  products = Table[gList[[i]] lpList[[j]] / (2 Pi), {i, n}, {j, n}];
  bps = {};
  Do[
    p = products[[i, j]];
    mMin = Ceiling[kLo * p];
    mMax = Floor[kHi * p];
    Do[AppendTo[bps, m / p], {m, mMin, mMax}],
  {i, n}, {j, n}];
  bps = Union[bps];
  bps = Select[bps, kLo < # < kHi &];

  (* Find singular intervals *)
  singIntervals = {};
  prevK = kLo;
  Do[
    midK = (prevK + bp) / 2;
    d = Det[fWM[n, midK]];
    If[d == 0, AppendTo[singIntervals, {prevK, bp}]];
    prevK = bp,
  {bp, bps}];
  (* Last interval *)
  midK = (Last[bps] + kHi) / 2;
  If[Det[fWM[n, midK]] == 0, AppendTo[singIntervals, {Last[bps], kHi}]];

  (* Find gap containing ζ(3) *)
  z3interval = Select[
    Partition[Prepend[bps, kLo], 2, 1],
    #[[1]] <= z3 < #[[2]] &];
  z3gap = If[Length[z3interval] > 0, First[z3interval], {0, 0}];
  z3det = Det[fWM[n, z3]];

  (* Distance from ζ(3) to nearest singular interval *)
  minDist = If[Length[singIntervals] > 0,
    Min[Table[Min[Abs[z3 - si[[1]]], Abs[z3 - si[[2]]]],
      {si, singIntervals}]],
    Infinity];

  Print["n=", PaddedForm[n, 2],
    "  bps=", PaddedForm[Length[bps], 4],
    "  sing intervals=", PaddedForm[Length[singIntervals], 3],
    "  det@ζ(3)=", PaddedForm[z3det, 5],
    "  gap=[", NumberForm[z3gap[[1]], {8, 6}], ",",
    NumberForm[z3gap[[2]], {8, 6}], "]",
    "  width=", NumberForm[z3gap[[2]] - z3gap[[1]], {6, 6}],
    "  dist_to_sing=", NumberForm[minDist, {6, 6}]],
{n, 3, nMax}];

(* KEY QUESTION: does the gap width shrink to zero? *)
Print["\n=== Gap width containing ζ(3) vs n ===\n"];
Print["n    gap_width        dist_to_sing     density (bps/0.2)"];
gaps = {};
Do[
  products = Table[gList[[i]] lpList[[j]] / (2 Pi), {i, n}, {j, n}];
  bps = {};
  Do[
    p = products[[i, j]];
    mMin = Ceiling[kLo * p];
    mMax = Floor[kHi * p];
    Do[AppendTo[bps, m / p], {m, mMin, mMax}],
  {i, n}, {j, n}];
  bps = Union[bps];
  bps = Select[bps, kLo < # < kHi &];

  (* Gap containing ζ(3) *)
  below = Select[bps, # < z3 &];
  above = Select[bps, # > z3 &];
  gapLo = If[Length[below] > 0, Last[below], kLo];
  gapHi = If[Length[above] > 0, First[above], kHi];
  gapWidth = gapHi - gapLo;

  (* Nearest singular *)
  singIntervals = {};
  prevK = kLo;
  Do[
    midK = (prevK + bp) / 2;
    d = Det[fWM[n, midK]];
    If[d == 0, AppendTo[singIntervals, {prevK, bp}]];
    prevK = bp,
  {bp, bps}];
  minDist = If[Length[singIntervals] > 0,
    Min[Table[Min[Abs[z3 - si[[1]]], Abs[z3 - si[[2]]]],
      {si, singIntervals}]],
    Infinity];

  AppendTo[gaps, {n, gapWidth, minDist, Length[bps]}];
  Print[PaddedForm[n, 3], "  ",
    ScientificForm[gapWidth, 4], "       ",
    ScientificForm[minDist, 4], "       ",
    PaddedForm[Length[bps], 5]],
{n, 3, nMax}];

(* Fit: does gap shrink exponentially, polynomially, or stay finite? *)
Print["\n=== Gap width scaling ==="];
gapData = gaps[[All, {1, 2}]];
logGaps = {#[[1]], Log[#[[2]]]} & /@ gapData;
fit = Fit[logGaps, {1, x}, x];
Print["ln(gap) ≈ ", fit, "  → gap ∝ exp(", Coefficient[fit, x], " · n)"];
Print["Extrapolation: gap at n=50 ≈ ", Exp[fit /. x -> 50]];
Print["Extrapolation: gap at n=200 ≈ ", Exp[fit /. x -> 200]];
