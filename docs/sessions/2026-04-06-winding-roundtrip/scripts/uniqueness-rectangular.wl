(* ================================================================ *)
(* UNIQUENESS for rectangular W: m rows × n columns (m ≥ n)        *)
(* More rows = tighter a_n intervals = better uniqueness           *)
(* ================================================================ *)

intersectColumn[aInts_, wCol_, logK_] := Module[
  {newInts, lo, hi},
  newInts = Table[
    lo = Max[aInts[[n, 1]], wCol[[n]] / logK];
    hi = Min[aInts[[n, 2]], (wCol[[n]] + 1) / logK];
    If[lo >= hi, Return[None, Module]];
    {lo, hi},
  {n, Length[aInts]}];
  newInts
]

enumerate[aInts_, w_, colIdx_, ksAccum_, lastK_, maxK_] := Module[
  {np = Dimensions[w][[2]], results = {}, newInts},
  If[colIdx > np, Return[{ksAccum}]];
  Do[
    newInts = intersectColumn[aInts, w[[All, colIdx]], Log[N[k, 20]]];
    If[newInts =!= None,
      If[colIdx == np,
        AppendTo[results, Append[ksAccum, k]],
        results = Join[results,
          enumerate[newInts, w, colIdx + 1, Append[ksAccum, k], k, maxK]]
      ]
    ],
  {k, If[EvenQ[lastK], lastK + 1, lastK + 2], maxK, 2}];
  results
]

findAllDecompositions[w_, maxK_: 100] := Module[
  {initInts, intsAfterCol1},
  initInts = Table[{0.001, 10000.}, {Dimensions[w][[1]]}];
  intsAfterCol1 = intersectColumn[initInts, w[[All, 1]], Log[N[2, 20]]];
  If[intsAfterCol1 === None, Return[{}]];
  enumerate[intsAfterCol1, w, 2, {2}, 2, maxK]
]

(* ================================================================ *)
Print["╔══════════════════════════════════════════════════════╗"];
Print["║  UNIQUENESS: Rectangular m×n (m rows ≥ n cols)       ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

(* First: find which n×n cases fail *)
Print["=== Square n×n cases with non-unique decomposition ==="];
failedSizes = {};
Do[
  w = Table[Floor[N[Im[ZetaZero[n]], 20] Log[N[Prime[j], 20]] / (2 Pi)],
    {n, sz}, {j, sz}];
  mK = Max[50, Prime[sz] + 20];
  decomps = findAllDecompositions[w, mK];
  If[Length[decomps] > 1,
    AppendTo[failedSizes, sz];
    Print[sz, "×", sz, ": ", Length[decomps], " decomps, impostors: ",
      Select[decomps, # != Table[Prime[j], {j, sz}] &]]],
{sz, Range[3, 20]}];
Print["Failed sizes: ", failedSizes];

(* For each failed size, add rows until unique *)
Print["\n=== How many extra rows needed for uniqueness? ==="];
Do[
  np = sz;
  Print["\nnp = ", np, " columns (primes up to ", Prime[np], "):"];
  Do[
    w = Table[Floor[N[Im[ZetaZero[n]], 20] Log[N[Prime[j], 20]] / (2 Pi)],
      {n, nz}, {j, np}];
    mK = Max[50, Prime[np] + 20];
    decomps = findAllDecompositions[w, mK];
    Print["  ", nz, "×", np, ": ", Length[decomps], " decomps",
      If[Length[decomps] == 1, " ✓ UNIQUE", ""]];
    If[Length[decomps] == 1, Break[]],
  {nz, np, np + 10}],
{sz, failedSizes}];

(* Also: what composites are impostors? Analyze pattern *)
Print["\n=== Impostor analysis ==="];
Do[
  w = Table[Floor[N[Im[ZetaZero[n]], 20] Log[N[Prime[j], 20]] / (2 Pi)],
    {n, sz}, {j, sz}];
  mK = Max[80, Prime[sz] + 40];
  decomps = findAllDecompositions[w, mK];
  If[Length[decomps] > 1,
    truePrimes = Table[Prime[j], {j, sz}];
    impostors = Select[decomps, # != truePrimes &];
    Do[
      imp = impostors[[i]];
      diff = Select[Range[sz], imp[[#]] != truePrimes[[#]] &];
      Print[sz, "×", sz, " impostor #", i, ": column ", diff,
        " has ", imp[[diff]], " instead of ", truePrimes[[diff]],
        " (", FactorInteger /@ imp[[diff]], ")"],
    {i, Length[impostors]}]],
{sz, Range[3, 20]}];
