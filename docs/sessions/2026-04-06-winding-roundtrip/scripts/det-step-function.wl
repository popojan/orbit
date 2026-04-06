(* ================================================================ *)
(* det(k) as STEP FUNCTION near ζ(3) for n=5,7,10,15              *)
(* At each breakpoint: which entry changes? What's the cofactor?   *)
(* Does det avoid zero by specific cofactor structure?             *)
(* ================================================================ *)

nMax = 20;
gList = Table[N[Im[ZetaZero[n]], 25], {n, nMax}];
lpList = Table[Log[N[Prime[j], 25]], {j, nMax}];

fWM[nz_, k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nz}, {j, nz}]

z3 = N[Zeta[3], 25];

(* For each n: find breakpoints near ζ(3), track det jumps *)
analyzeDetSteps[n_, halfWidth_: 0.005] := Module[
  {products, bps, bpData, prevK, prevW, prevDet, w, d,
   changedEntries, cofactorSum},

  products = Table[gList[[i]] lpList[[j]] / (2 Pi), {i, n}, {j, n}];

  (* Find breakpoints *)
  bps = {};
  Do[
    p = products[[i, j]];
    mMin = Ceiling[(z3 - halfWidth) p];
    mMax = Floor[(z3 + halfWidth) p];
    Do[
      bp = m / p;
      If[z3 - halfWidth < bp < z3 + halfWidth,
        AppendTo[bps, {bp, i, j}]],
    {m, mMin, mMax}],
  {i, n}, {j, n}];
  bps = SortBy[bps, First];

  (* Walk through breakpoints, track det *)
  prevK = z3 - halfWidth;
  prevW = fWM[n, prevK + 10^-15];
  prevDet = Det[prevW];

  bpData = {};
  Do[
    {bpK, bi, bj} = bps[[idx]];
    w = fWM[n, bpK + 10^-15];
    d = Det[w];
    jump = d - prevDet;

    (* Cofactor at changed position *)
    cof = (-1)^(bi + bj) Det[Drop[prevW, {bi}][[All, Drop[Range[n], {bj}]]]];

    AppendTo[bpData, <|
      "k" -> bpK, "det" -> d, "jump" -> jump,
      "entry" -> {bi, bj}, "cofactor" -> cof,
      "dist_to_z3" -> bpK - z3|>];

    prevW = w; prevDet = d,
  {idx, Length[bps]}];

  bpData
]

(* ================================================================ *)
Print["╔══════════════════════════════════════════════════════╗"];
Print["║  det(k) STEP FUNCTION near ζ(3)                      ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

Do[
  hw = If[n <= 7, 0.01, If[n <= 12, 0.003, 0.001]];
  Print["═══ n=", n, " (±", hw, " around ζ(3)) ═══"];
  data = analyzeDetSteps[n, hw];
  Print["  Breakpoints: ", Length[data]];

  (* Show breakpoints nearest to ζ(3) *)
  sorted = SortBy[data, Abs[#["dist_to_z3"]] &];
  Print["  Nearest to ζ(3):"];
  Do[
    d = sorted[[i]];
    Print["    Δk=", NumberForm[d["dist_to_z3"], {6, 6}],
      "  det=", PaddedForm[d["det"], 5],
      "  jump=", PaddedForm[d["jump"], 4],
      "  entry (", d["entry"][[1]], ",", d["entry"][[2]], ")",
      "  cofactor=", PaddedForm[d["cofactor"], 4]],
  {i, Min[8, Length[sorted]]}];

  (* Key: does det pass through zero? *)
  detValues = #["det"] & /@ data;
  minAbsDet = Min[Abs[Prepend[detValues, Det[fWM[n, z3]]]]];
  nZeros = Count[detValues, 0];
  Print["  |det| range: [", minAbsDet, ", ", Max[Abs[detValues]], "]"];
  Print["  det=0 occurrences: ", nZeros, "/", Length[data]];
  Print["  det@ζ(3) = ", Det[fWM[n, z3]]];

  (* Cofactor statistics *)
  cofactors = #["cofactor"] & /@ data;
  Print["  Cofactor range: [", Min[cofactors], ", ", Max[cofactors], "]"];
  Print["  |cofactor| mean: ", NumberForm[Mean[Abs[N[cofactors]]], {4, 1}]];
  Print[""],
{n, {5, 7, 10, 13, 15, 20}}];

(* ================================================================ *)
(* ZOOM: for n=10, show full step function trajectory              *)
(* ================================================================ *)
Print["═══ DETAILED: n=10, ±0.002 ═══\n"];
data10 = analyzeDetSteps[10, 0.002];
Print["k_breakpoint          det   jump  entry  cofactor"];
Do[
  d = data10[[i]];
  marker = If[d["det"] == 0, " ← ZERO", ""];
  z3marker = "";
  If[i < Length[data10],
    next = data10[[i + 1]];
    If[d["k"] < z3 < next["k"], z3marker = "\n  ──── ζ(3) HERE ──── det=" <> ToString[d["det"]]]];
  Print[NumberForm[d["k"], {15, 12}], "  ",
    PaddedForm[d["det"], 5], " ",
    PaddedForm[d["jump"], 5], "  (",
    d["entry"][[1]], ",", d["entry"][[2]], ")  ",
    PaddedForm[d["cofactor"], 5], marker];
  If[z3marker != "", Print[z3marker]],
{i, Length[data10]}];
