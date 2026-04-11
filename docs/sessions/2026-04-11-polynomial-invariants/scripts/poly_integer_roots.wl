<< Orbit`

(* Compute P_j(n; alpha) and check if all roots are integers *)
polyRootTest[alpha_, j_, maxN_: Automatic] := Module[
  {w, convs, maxK, cv, a, b, maxPos, prevPos, row, pts, poly,
   intPoly, roots, allInt},
  w = Floor[alpha];
  convs = Convergents[alpha, 25];
  maxK = First@FirstPosition[Denominator /@ convs, _?(# > 2 j &)];
  If[MissingQ[maxK], Return[Missing["convergents too small"]]];
  maxK = maxK + 1;
  cv = Convergents[alpha, maxK];
  {a, b} = Take[cv, -2];
  maxPos = Numerator[b];
  prevPos = Numerator[a];
  If[maxPos > 50000, Return[Missing["too large"]]];
  row = BeattyBallotCount[alpha, All, {maxPos, j}];
  pts = Table[{nn, row[[nn]]}, {nn, prevPos, maxPos}];
  poly = InterpolatingPolynomial[pts, n] // Expand;
  intPoly = Expand[j! * poly];
  roots = n /. Solve[intPoly == 0, n];
  allInt = AllTrue[roots, IntegerQ];
  {allInt, Sort[roots]}
]

(* ============================================================ *)
(* Scan many irrationals, find all-integer-root heights          *)
(* ============================================================ *)

alphaList = {
  {GoldenRatio, "phi", "[1;1,1,1,...]"},
  {Sqrt[2], "Sqrt2", "[1;2,2,2,...]"},
  {Sqrt[3], "Sqrt3", "[1;1,2,1,2,...]"},
  {Sqrt[5], "Sqrt5", "[2;4,4,4,...]"},
  {Sqrt[6], "Sqrt6", "[2;2,4,2,4,...]"},
  {Sqrt[7], "Sqrt7", "[2;1,1,1,4,...]"},
  {E, "e", "[2;1,2,1,1,4,...]"},
  {Pi, "Pi", "[3;7,15,1,292,...]"}
};

Do[
  {al, name, cf} = entry;
  w = Floor[al];
  convs = Convergents[al, 15];
  qDens = Denominator /@ convs;

  Print["=== ", name, " : CF=", cf, ", w=", w, " ==="];
  Print["  q_k: ", Take[qDens, Min[10, Length[qDens]]]];

  maxJ = Min[30, qDens[[Min[8, Length[qDens]]]]];
  intHeights = {};

  Do[
    result = polyRootTest[al, j];
    If[MissingQ[result], Continue[]];
    {allInt, roots} = result;
    isQk = MemberQ[qDens, j];
    If[allInt,
      AppendTo[intHeights, j];
      Print["  j=", j, ": ALL INTEGER roots: ", roots,
        If[isQk, "  [j = q_k]", ""]];
    ];,
    {j, 1, maxJ}
  ];

  Print["  Integer-root heights: ", intHeights];
  Print["  Convergent denominators: ", Select[qDens, # <= maxJ &]];
  Print["  Match? ", intHeights === Select[qDens, # <= maxJ &]];
  Print[""];,
  {entry, alphaList}
];
