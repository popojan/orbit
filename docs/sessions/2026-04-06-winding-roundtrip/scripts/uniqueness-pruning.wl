(* ================================================================ *)
(* UNIQUENESS with column-by-column PRUNING                        *)
(* ================================================================ *)

(* Intersect a_n intervals with constraint from column with log(k). *)
intersectColumn[aInts_, wCol_, logK_] := Module[
  {nz = Length[aInts], newInts, lo, hi},
  newInts = Table[
    lo = Max[aInts[[n, 1]], wCol[[n]] / logK];
    hi = Min[aInts[[n, 2]], (wCol[[n]] + 1) / logK];
    If[lo >= hi, Return[None, Module]];
    {lo, hi},
  {n, nz}];
  newInts
]

(* Recursive: add column colIdx, extending partial solution ksAccum.
   lastK = last integer added (for monotonicity). *)
enumerate[aInts_, w_, colIdx_, ksAccum_, lastK_, maxK_] := Module[
  {nz, np, results = {}, newInts},
  {nz, np} = Dimensions[w];

  If[colIdx > np,
    Return[{ksAccum}]
  ];

  Do[
    newInts = intersectColumn[aInts, w[[All, colIdx]], Log[N[k, 20]]];
    If[newInts =!= None,
      If[colIdx == np,
        AppendTo[results, Append[ksAccum, k]],
        results = Join[results,
          enumerate[newInts, w, colIdx + 1, Append[ksAccum, k], k, maxK]]
      ]
    ],
  {k, If[EvenQ[lastK], lastK + 1, lastK + 2], maxK, 2}];  (* odd, > lastK *)

  results
]

(* Top-level: column 1 is always k=2. *)
findAllDecompositions[w_, maxK_: 100] := Module[
  {nz, np, initInts, intsAfterCol1},
  {nz, np} = Dimensions[w];
  initInts = Table[{0.001, 10000.}, {nz}];

  (* Fix column 1 = 2 *)
  intsAfterCol1 = intersectColumn[initInts, w[[All, 1]], Log[N[2, 20]]];
  If[intsAfterCol1 === None,
    Print["  ERROR: column 1 = 2 inconsistent!"];
    Return[{}]
  ];

  If[np == 1, Return[{{2}}]];

  (* Enumerate remaining columns: odd integers > 2 *)
  enumerate[intsAfterCol1, w, 2, {2}, 2, maxK]
]

(* ================================================================ *)
Print["╔══════════════════════════════════════════════════════╗"];
Print["║  UNIQUENESS: Column-pruning search (fixed)           ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

Do[
  Print["═══ ", sz, "×", sz, " ═══"];
  w = Table[Floor[N[Im[ZetaZero[n]], 20] Log[N[Prime[j], 20]] / (2 Pi)],
    {n, sz}, {j, sz}];
  truePrimes = Table[Prime[j], {j, sz}];

  t0 = AbsoluteTime[];
  mK = Max[50, Prime[sz] + 20];
  decomps = findAllDecompositions[w, mK];
  dt = AbsoluteTime[] - t0;

  Print["  k ≤ ", mK, "  found: ", Length[decomps],
    "  (", NumberForm[dt, {5, 2}], "s)"];
  Do[Print["    ", decomps[[i]]], {i, Min[10, Length[decomps]]}];
  If[Length[decomps] > 10, Print["    ... (", Length[decomps] - 10, " more)"]];
  Print["  True found: ", MemberQ[decomps, truePrimes],
    "  UNIQUE: ", Length[decomps] == 1 && MemberQ[decomps, truePrimes]];
  Print[""],
{sz, Range[3, 12]}];
