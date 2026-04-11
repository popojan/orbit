<< Orbit`

polyRational[alpha_Rational, j_, windowSize_: 400] := Module[
  {maxN, row, firstNZ, pts},
  maxN = Ceiling[j * alpha] + windowSize;
  row = BeattyBallotCount[alpha, All, {maxN, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Return[$Failed]];
  firstNZ = firstNZ[[1]];
  pts = Table[{nn, row[[nn]]}, {nn, firstNZ, Min[firstNZ + 2 j + 10, maxN]}];
  InterpolatingPolynomial[pts, n] // Expand
]

polyIrrational[alpha_, j_] := Module[
  {convs, maxK, cv, a, b, maxPos, prevPos, row, pts},
  convs = Convergents[alpha, 25];
  maxK = First@FirstPosition[Denominator /@ convs, _?(# > 2 j &)] + 1;
  cv = Convergents[alpha, maxK];
  {a, b} = Take[cv, -2];
  maxPos = Numerator[b];
  prevPos = Numerator[a];
  row = BeattyBallotCount[alpha, All, {maxPos, j}];
  pts = Table[{nn, row[[nn]]}, {nn, prevPos, maxPos}];
  InterpolatingPolynomial[pts, n] // Expand
]

(* Test cases: vary w and a1 *)
cases = {
  {Sqrt[2], "[1;2,...]", 1, 2},   (* w=1, a1=2 *)
  {Sqrt[3], "[1;1,...]", 1, 1},   (* w=1, a1=1 *)
  {GoldenRatio, "[1;1,...]", 1, 1}, (* w=1, a1=1 *)
  {Sqrt[5], "[2;4,...]", 2, 4},   (* w=2, a1=4 *)
  {Sqrt[6], "[2;2,...]", 2, 2},   (* w=2, a1=2 *)
  {Pi, "[3;7,...]", 3, 7}          (* w=3, a1=7 *)
};

Do[
  {alpha, cfStr, w, a1} = cas;

  (* The "short" rational: [w; a1, 1] *)
  shortAlpha = FromContinuedFraction[{w, a1, 1}];
  q1 = a1;
  p0 = 1; p1 = w a1 + 1;
  pShort = p0 + p1;  (* = p2 for a2=1 *)
  qShort = 1 + a1;   (* = q2 for a2=1 *)
  bCorr = Binomial[pShort + qShort - 1, qShort] / pShort;

  Print["=== ", cfStr, "  w=", w, " a1=", a1,
    "  short=[", w, ";", a1, ",1]=", shortAlpha,
    "  B(", pShort, ",", qShort, ")=", bCorr, " ==="];

  Do[
    d = j - q1 - 1;
    polyA = polyIrrational[alpha, j];
    polyR = polyRational[shortAlpha, j, 500];
    If[polyR === $Failed, Continue[]];
    diff = Expand[polyA - polyR];
    If[diff === 0, Print["  j=", j, " (d=", d, "): identical"]; Continue[]];
    factored = Factor[diff];
    Print["  j=", j, " (d=", d, "): ", factored];,
    {j, q1, q1 + 8}
  ];

  (* Extract moving root pattern *)
  Print[""];
  Print["  Moving roots:"];
  Do[
    d = j - q1 - 1;
    polyA = polyIrrational[alpha, j];
    polyR = polyRational[shortAlpha, j, 500];
    If[polyR === $Failed, Continue[]];
    diff = Expand[polyA - polyR];
    If[diff === 0, Continue[]];
    (* Find the roots *)
    intPoly = Expand[LCM @@ (Denominator /@ CoefficientList[diff, n]) * diff];
    roots = n /. Solve[intPoly == 0, n];
    intRoots = Sort[Select[roots, IntegerQ]];
    (* The moving root should be the largest positive one *)
    movRoot = If[Length[Select[intRoots, # > 0 &]] > 0,
      Max[Select[intRoots, # > 0 &]], "none"];
    Print["    j=", j, ": roots=", intRoots,
      "  moving=", movRoot,
      "  wj+1=", w j + 1,
      "  wj=", w j,
      "  match? wj+1:", movRoot === w j + 1,
      " wj:", movRoot === w j];,
    {j, q1 + 1, q1 + 7}
  ];

  Print[""];,
  {cas, cases}
];
