<< Orbit`

vLin[n_, w_, j_] := (n - w j)/n Binomial[n + j - 1, j]

(* Use Sqrt[2]: CF = [1; 2,2,2,...], convergents grow gently *)
alpha = Sqrt[2];
w = 1;

Print["=== Sqrt[2]: CF = [1; 2,2,2,...] ==="];
convs = Convergents[alpha, 10];
Print["Convergents: ", convs];
Print[""];

(* ============================================= *)
(* TEST 1: cleanPoly at each convergent level    *)
(* ============================================= *)

Print["=== cleanPoly at each convergent level ==="];
Print[""];

Do[
  cv = Convergents[alpha, k];
  {a, b} = Take[cv, -2];
  height = Denominator[a];
  maxPos = Numerator[b];
  prevPos = Numerator[a];

  If[maxPos > 50000, Print["k=", k, ": skipped (too large)"]; Continue[]];

  row = BeattyBallotCount[alpha, All, {maxPos, height}];
  data = Drop[row, prevPos - 1];

  (* Check polynomial degree via finite differences *)
  diffs = data;
  deg = -1;
  Do[
    If[Union[diffs] === {0}, deg = d - 1; Break[]];
    diffs = Differences[diffs],
    {d, 1, Min[Length[data] - 1, 300]}
  ];
  If[deg == -1, deg = "not poly (deg > " <> ToString[Min[Length[data]-1, 300]] <> ")"];

  (* Check Result 2 *)
  predicted = Table[vLin[n, w, height], {n, prevPos, maxPos}];
  r2match = (data === predicted);

  Print["k=", k, ": height=", height,
    " range=[", prevPos, ",", maxPos, "]",
    " #points=", Length[data],
    " poly degree=", deg,
    " Result2=", r2match];,
  {k, 3, 9}
];

Print[""];

(* ============================================= *)
(* TEST 2: Vary height within fixed range        *)
(* Range [p2, p3] = [7, 17] for Sqrt[2]         *)
(* ============================================= *)

Print["=== Sqrt[2]: vary height j, range [7, 17] ==="];
Print["(p2=7, p3=17, q1=2, q2=5)"];
Print[""];

Do[
  row = BeattyBallotCount[alpha, All, {17, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Print["j=", j, ": all zeros"]; Continue[]];
  firstNZ = firstNZ[[1]];
  data = Drop[row, firstNZ - 1];

  predicted = Table[vLin[n, w, j], {n, firstNZ, 17}];
  r2match = (data === predicted);

  diffs = data;
  deg = -1;
  Do[
    If[Union[diffs] === {0}, deg = d - 1; Break[]];
    diffs = Differences[diffs],
    {d, 1, Length[data] - 1}
  ];
  If[deg == -1, deg = "not poly (all diffs nonzero)"];

  Print["j=", j, ": first nonzero at n=", firstNZ,
    " #points=", Length[data],
    " poly degree=", deg,
    " Result2=", r2match];,
  {j, 1, 10}
];

Print[""];

(* ============================================= *)
(* TEST 3: Larger range [p3, p4] = [17, 41]     *)
(* ============================================= *)

Print["=== Sqrt[2]: vary height j, range [17, 41] ==="];
Print["(p3=17, p4=41, q2=5, q3=12)"];
Print[""];

Do[
  row = BeattyBallotCount[alpha, All, {41, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Print["j=", j, ": all zeros"]; Continue[]];
  firstNZ = firstNZ[[1]];
  data = Drop[row, firstNZ - 1];

  predicted = Table[vLin[n, w, j], {n, firstNZ, 41}];
  r2match = (data === predicted);

  diffs = data;
  deg = -1;
  Do[
    If[Union[diffs] === {0}, deg = d - 1; Break[]];
    diffs = Differences[diffs],
    {d, 1, Length[data] - 1}
  ];
  If[deg == -1, deg = "not poly (all diffs nonzero)"];

  Print["j=", j, ": first nonzero at n=", firstNZ,
    " #points=", Length[data],
    " poly degree=", deg,
    " Result2=", r2match];,
  {j, 1, 15}
];

Print[""];

(* ============================================= *)
(* TEST 4: Big range [p5, p6] = [99, 239]       *)
(* Check correction structure in detail          *)
(* ============================================= *)

Print["=== Sqrt[2]: heights around q1=2, range [99, 239] ==="];
Print[""];

Do[
  row = BeattyBallotCount[alpha, All, {239, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Print["j=", j, ": all zeros"]; Continue[]];
  firstNZ = firstNZ[[1]];
  data = Drop[row, firstNZ - 1];

  predicted = Table[vLin[n, w, j], {n, firstNZ, 239}];
  r2match = (data === predicted);

  diffs = data;
  deg = -1;
  Do[
    If[Union[diffs] === {0}, deg = d - 1; Break[]];
    diffs = Differences[diffs],
    {d, 1, Min[Length[data] - 1, 250]}
  ];
  If[deg == -1, deg = "not poly"];

  (* If not Result 2, show the correction degree *)
  corrDeg = "n/a";
  If[!r2match && IntegerQ[deg],
    correction = predicted[[;;Length[data]]] - data;
    cdiffs = correction;
    corrDeg = -1;
    Do[
      If[Union[cdiffs] === {0}, corrDeg = d - 1; Break[]];
      cdiffs = Differences[cdiffs],
      {d, 1, Min[Length[correction] - 1, 250]}
    ];
  ];

  Print["j=", j, ": poly deg=", deg,
    " Result2=", r2match,
    " correction deg=", corrDeg];,
  {j, 1, 20}
];
