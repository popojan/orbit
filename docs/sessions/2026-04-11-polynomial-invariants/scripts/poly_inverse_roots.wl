<< Orbit`

(* For 1/alpha, check all-integer roots of P_j *)
testRoots[alpha_, name_, maxJ_: 25] := Module[
  {invAlpha, maxN, row, firstNZ, pts, poly, intPoly, roots, allInt, w, convs, qDens},
  invAlpha = 1/alpha;
  w = Floor[invAlpha];
  convs = Convergents[invAlpha, 15];
  qDens = Denominator /@ convs;
  maxN = 300;

  Print["=== 1/", name, " = ", N[invAlpha, 6], "  w=", w, " ==="];
  Print["  CF[1/", name, "] q_k: ", Take[qDens, Min[8, Length[qDens]]]];

  intRootHeights = {};
  Do[
    row = BeattyBallotCount[invAlpha, All, {maxN, j}];
    firstNZ = FirstPosition[row, _?(# > 0 &)];
    If[MissingQ[firstNZ], Continue[]];
    firstNZ = firstNZ[[1]];
    pts = Table[{nn, row[[nn]]}, {nn, firstNZ, Min[firstNZ + 2 j + 5, maxN]}];
    poly = InterpolatingPolynomial[pts, n] // Expand;
    intPoly = Expand[j! poly];
    roots = n /. Solve[intPoly == 0, n];
    allInt = AllTrue[roots, IntegerQ];
    If[allInt,
      AppendTo[intRootHeights, j];
    ,
      (* show first failure *)
      If[Length[intRootHeights] == j - 1 || j <= 5,
        Print["  j=", j, ": NOT all integer. roots=", Sort[roots]];
      ];
    ];,
    {j, 1, maxJ}
  ];

  Print["  All-integer-root heights: ", intRootHeights];
  Print["  q_k up to ", maxJ, ": ", Select[qDens, # <= maxJ &]];
  Print[""];
]

(* Quadratic irrationals *)
testRoots[Sqrt[2], "Sqrt2"];
testRoots[Sqrt[3], "Sqrt3"];
testRoots[Sqrt[5], "Sqrt5"];
testRoots[Sqrt[6], "Sqrt6"];
testRoots[Sqrt[7], "Sqrt7"];
testRoots[GoldenRatio, "phi"];
testRoots[(1 + Sqrt[5])/2, "phi2"];  (* same as GoldenRatio, sanity *)

(* Non-quadratic for comparison *)
testRoots[Pi, "Pi"];
testRoots[E, "e"];
