<< Orbit`

(* BeattyBallotCount[1/alpha, ...] uses staircase Floor[n*alpha] *)
(* For alpha > 1: slope > 1, diagonal y=x lies under staircase *)

polyDeg[data_] := Module[{diffs = data, d},
  Do[
    diffs = Differences[diffs];
    If[Length[Union[diffs]] == 1, Return[d, Module]],
    {d, 1, Min[Length[data] - 1, 500]}
  ];
  "not poly"
]

Print["=== BeattyBallotCount[1/alpha, All, {N, j}] ==="];
Print["=== Staircase: Floor[n*alpha] ==="];
Print[""];

(* Test with Sqrt[2]: 1/Sqrt[2], staircase Floor[n*Sqrt[2]] *)
alpha = Sqrt[2];
invAlpha = 1/alpha;

Print["alpha=Sqrt[2], 1/alpha=1/Sqrt[2]=", N[invAlpha, 6]];
Print["Floor[alpha]=", Floor[alpha], ", Floor[1/alpha]=", Floor[invAlpha]];
Print["Staircase slope: ", N[alpha, 6], " > 1 (diagonal y=x is below)"];
Print[""];

(* Compute rows at various heights *)
maxN = 200;
Print["=== Row polynomials at fixed heights j ==="];
Print[""];

Do[
  row = BeattyBallotCount[invAlpha, All, {maxN, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Print["j=", j, ": all zeros"]; Continue[]];
  firstNZ = firstNZ[[1]];
  data = Drop[row, firstNZ - 1];

  deg = polyDeg[data];

  (* If polynomial, extract it *)
  If[IntegerQ[deg],
    pts = Table[{nn, row[[nn]]}, {nn, firstNZ, Min[firstNZ + 2 deg + 5, maxN]}];
    poly = InterpolatingPolynomial[pts, n] // Expand // Factor;
    Print["j=", j, ": deg=", deg, " first@n=", firstNZ, "  P(n) = ", poly];,
    Print["j=", j, ": deg=", deg, " first@n=", firstNZ,
      " first values: ", Take[data, Min[10, Length[data]]]];
  ];,
  {j, 1, 20}
];

Print[""];
Print["=== Same for alpha=GoldenRatio ==="];
Print[""];

alpha2 = GoldenRatio;
invAlpha2 = 1/alpha2;
Print["alpha=phi, 1/alpha=1/phi=", N[invAlpha2, 6]];
Print[""];

Do[
  row = BeattyBallotCount[invAlpha2, All, {maxN, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Continue[]];
  firstNZ = firstNZ[[1]];
  data = Drop[row, firstNZ - 1];
  deg = polyDeg[data];
  If[IntegerQ[deg],
    pts = Table[{nn, row[[nn]]}, {nn, firstNZ, Min[firstNZ + 2 deg + 5, maxN]}];
    poly = InterpolatingPolynomial[pts, n] // Expand // Factor;
    Print["j=", j, ": deg=", deg, "  P(n) = ", poly];,
    Print["j=", j, ": deg=", deg];
  ];,
  {j, 1, 15}
];

Print[""];
Print["=== And alpha=Pi ==="];
Print[""];

alpha3 = Pi;
invAlpha3 = 1/alpha3;
Print["alpha=Pi, 1/alpha=", N[invAlpha3, 6]];
Print[""];

Do[
  row = BeattyBallotCount[invAlpha3, All, {maxN, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Continue[]];
  firstNZ = firstNZ[[1]];
  data = Drop[row, firstNZ - 1];
  deg = polyDeg[data];
  If[IntegerQ[deg],
    pts = Table[{nn, row[[nn]]}, {nn, firstNZ, Min[firstNZ + 2 deg + 5, maxN]}];
    poly = InterpolatingPolynomial[pts, n] // Expand // Factor;
    Print["j=", j, ": deg=", deg, "  P(n) = ", poly];,
    Print["j=", j, ": deg=", deg];
  ];,
  {j, 1, 10}
];
