<< Orbit`

vLin[n_, w_, j_] := (n - w j)/n Binomial[n + j - 1, j]
alpha = Sqrt[2]; w = 1;

(* Compute row at height j, full range, and express in terms of actual position n *)
polyInN[j_, maxN_] := Module[{row, firstNZ, data, pts, poly},
  row = BeattyBallotCount[alpha, All, {maxN, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)][[1]];
  data = Drop[row, firstNZ - 1];
  (* use actual positions as x-values *)
  pts = Table[{n, data[[n - firstNZ + 1]]}, {n, firstNZ, maxN}];
  InterpolatingPolynomial[pts, n] // Expand // Factor
]

Print["=== Factored polynomials in actual position n (Sqrt[2], range to 239) ==="];
Print[""];
Print["q1 = 2 (uniform formula valid for j <= 2)"];
Print[""];

Do[
  poly = polyInN[j, 239];
  Print["j=", j, ":  ", poly];

  (* Compare with vLin *)
  vlinExpanded = vLin[n, w, j] // Factor;
  If[j <= 2,
    Print["       vLin = ", vlinExpanded, "  MATCH=", Expand[poly] === Expand[vlinExpanded]],
    (* show the correction *)
    corr = Factor[Expand[vlinExpanded - poly]];
    Print["       vLin = ", vlinExpanded];
    Print["       correction = vLin - actual = ", corr];
  ];
  Print[""];,
  {j, 1, 8}
];

Print["=== Root structure ==="];
Print[""];
Do[
  poly = polyInN[j, 239];
  roots = n /. Solve[poly == 0, n];
  Print["j=", j, ": roots at n = ", Sort[roots]];,
  {j, 1, 6}
];

Print[""];
Print["=== Same for Pi (range to 333, q1=7) ==="];
Print[""];

polyInNPi[j_, maxN_] := Module[{row, firstNZ, data, pts, poly},
  row = BeattyBallotCount[Pi, All, {maxN, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)][[1]];
  data = Drop[row, firstNZ - 1];
  pts = Table[{n, data[[n - firstNZ + 1]]}, {n, firstNZ, maxN}];
  InterpolatingPolynomial[pts, n] // Expand // Factor
]

(* Show the transition from clean to messy *)
Do[
  poly = polyInNPi[j, 333];
  vlinPi = Factor[Expand[vLin[n, 3, j]]];
  If[j <= 7,
    Print["j=", j, ": CLEAN  ", poly, "  ==vLin? ", Expand[poly] === Expand[vlinPi]],
    corr = Factor[Expand[vlinPi - poly]];
    Print["j=", j, ": CORRECTED"];
    Print["   actual = ", poly];
    Print["   correction = ", corr];
  ];
  Print[""];,
  {j, 6, 10}
];
