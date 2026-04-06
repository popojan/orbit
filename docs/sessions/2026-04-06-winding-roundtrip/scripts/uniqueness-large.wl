(* ================================================================ *)
(* UNIQUENESS: Push to n=30, find all failure modes                *)
(* Also: for prime impostors, analyze WHY ln(p) and ln(q) are     *)
(* indistinguishable at the given matrix size.                      *)
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
Print["║  UNIQUENESS: n=3..30, impostor analysis              ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

results = {};
Do[
  w = Table[Floor[N[Im[ZetaZero[n]], 20] Log[N[Prime[j], 20]] / (2 Pi)],
    {n, sz}, {j, sz}];
  mK = Max[80, Prime[sz] + 40];
  t0 = AbsoluteTime[];
  decomps = findAllDecompositions[w, mK];
  dt = AbsoluteTime[] - t0;

  truePrimes = Table[Prime[j], {j, sz}];
  nDecomp = Length[decomps];

  If[nDecomp > 1,
    impostors = Select[decomps, # != truePrimes &];
    imp = impostors[[1]];
    diffCols = Select[Range[sz], imp[[#]] != truePrimes[[#]] &];
    impVals = imp[[diffCols]];
    trueVals = truePrimes[[diffCols]];
    isPrime = PrimeQ /@ impVals;
    logDiff = Abs[Log[N[First[impVals]]] - Log[N[First[trueVals]]]];

    Print[sz, "×", sz, "  ", nDecomp, " decomps  col ", diffCols,
      ": ", trueVals, "→", impVals,
      If[First[isPrime], " [PRIME]", " [COMPOSITE=" <> ToString[FactorInteger[First[impVals]]] <> "]"],
      "  Δln=", NumberForm[logDiff, {4, 4}],
      "  (", NumberForm[dt, {4, 2}], "s)"];
    AppendTo[results, {sz, nDecomp, First[trueVals], First[impVals], First[isPrime], logDiff}],

    (* Unique *)
    Print[sz, "×", sz, "  UNIQUE ✓  (", NumberForm[dt, {4, 2}], "s)"];
    AppendTo[results, {sz, 1, None, None, None, None}]
  ],
{sz, Range[3, 30]}];

(* Summary *)
Print["\n=== SUMMARY ==="];
failures = Select[results, #[[2]] > 1 &];
Print["Failures: ", Length[failures], " / ", Length[results]];
Print["Failure sizes: ", failures[[All, 1]]];
Print["\nImpostor types:"];
Do[
  {sz, nd, trueP, impP, isPr, dlnP} = f;
  Print["  n=", sz, ": ", trueP, "→", impP,
    If[isPr, " (prime gap = " <> ToString[impP - trueP] <> ")",
      " (composite)"],
    "  Δln=", NumberForm[dlnP, {4, 4}]],
{f, failures}];

(* Pattern: when does the prime gap allow impostors? *)
Print["\n=== Prime gaps at failure sizes ==="];
Do[
  {sz, nd, trueP, impP, isPr, dlnP} = f;
  If[isPr,
    Print["  p_", sz, "=", trueP, ", next prime=", NextPrime[trueP],
      ", gap=", NextPrime[trueP] - trueP,
      ", impostor=", impP, " (", If[impP > trueP, "above", "below"], ")"]],
{f, failures}];
