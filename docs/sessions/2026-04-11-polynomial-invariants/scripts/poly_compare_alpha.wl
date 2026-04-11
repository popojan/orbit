<< Orbit`

(* Compute universal polynomial P_j(n; alpha) at height j *)
(* Uses a large enough window to get the polynomial *)
polyAt[alpha_, j_] := Module[
  {w, convs, maxK, cv, a, b, maxPos, prevPos, row, pts, kk},
  w = Floor[alpha];
  (* find k such that q_{k-2} >= j, i.e. the window covers height j *)
  convs = Convergents[alpha, 20];
  maxK = First@FirstPosition[Denominator /@ convs, _?(# > 2 j &)] + 1;
  cv = Convergents[alpha, maxK];
  {a, b} = Take[cv, -2];
  maxPos = Numerator[b];
  prevPos = Numerator[a];
  If[maxPos > 200000, Return["too large"]];
  row = BeattyBallotCount[alpha, All, {maxPos, j}];
  pts = Table[{nn, row[[nn]]}, {nn, prevPos, maxPos}];
  InterpolatingPolynomial[pts, n] // Expand // Factor
]

(* ============================================================ *)
(* w=1 irrationals: phi, Sqrt[2], Sqrt[3]                      *)
(* phi: CF=[1;1,1,...], q1=1                                    *)
(* Sqrt[2]: CF=[1;2,2,...], q1=2                                *)
(* Sqrt[3]: CF=[1;1,2,1,2,...], q1=1                            *)
(* ============================================================ *)

alphas1 = {
  {GoldenRatio, "phi", "[1;1,1,1,...]", 1},
  {Sqrt[2], "Sqrt[2]", "[1;2,2,2,...]", 2},
  {Sqrt[3], "Sqrt[3]", "[1;1,2,1,2,...]", 1}
};

Print["=== w=1 irrationals at same heights ==="];
Print[""];

Do[
  Print["--- height j=", j, " ---"];
  Do[
    {al, name, cf, q1} = entry;
    poly = polyAt[al, j];
    roots = n /. Solve[poly == 0, n];
    intRoots = Select[roots, IntegerQ];
    Print["  ", name, " (q1=", q1, "): ", poly,
      "  roots=", Sort[roots]];,
    {entry, alphas1}
  ];
  Print[""];,
  {j, 1, 6}
];

(* ============================================================ *)
(* w=2 irrationals: Sqrt[5], e                                  *)
(* Sqrt[5]: CF=[2;4,4,...], q1=4                                *)
(* e: CF=[2;1,2,1,1,4,...], q1=1                                *)
(* ============================================================ *)

Print["=== w=2 irrationals at same heights ==="];
Print[""];

alphas2 = {
  {Sqrt[5], "Sqrt[5]", "[2;4,4,4,...]", 4},
  {E, "e", "[2;1,2,1,1,4,...]", 1}
};

Do[
  Print["--- height j=", j, " ---"];
  Do[
    {al, name, cf, q1} = entry;
    poly = polyAt[al, j];
    roots = n /. Solve[poly == 0, n];
    Print["  ", name, " (q1=", q1, "): ", poly];,
    {entry, alphas2}
  ];
  Print[""];,
  {j, 1, 6}
];

(* ============================================================ *)
(* Key test: when do two alphas with same w diverge?             *)
(* ============================================================ *)

Print["=== Divergence point: phi vs Sqrt[2] vs Sqrt[3] (all w=1) ==="];
Print[""];

Do[
  pPhi = polyAt[GoldenRatio, j] // Expand;
  pSqrt2 = polyAt[Sqrt[2], j] // Expand;
  pSqrt3 = polyAt[Sqrt[3], j] // Expand;
  Print["j=", j, ": phi==Sqrt2? ", pPhi === pSqrt2,
    "  phi==Sqrt3? ", pPhi === pSqrt3,
    "  Sqrt2==Sqrt3? ", pSqrt2 === pSqrt3];,
  {j, 1, 8}
];
