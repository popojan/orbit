<< Orbit`

vLin[n_, w_, j_] := (n - w j)/n Binomial[n + j - 1, j]
alpha = Sqrt[2]; w = 1;

(* Verify off-by-one: degree of {1,2,...,16} should be 1 *)
test = Range[16];
diffs = test;
Do[
  diffs = Differences[diffs];
  Print["After ", d, " rounds of Diff: ", Take[diffs, Min[5, Length[diffs]]],
    " constant=", Length[Union[diffs]] == 1,
    " zero=", Union[diffs] === {0}],
  {d, 1, 4}
];
Print[""];

(* Fixed degree finder: degree k iff k-th diffs constant, (k+1)-th zero *)
polyDeg[data_] := Module[{diffs = data, d},
  Do[
    diffs = Differences[diffs];
    If[Length[Union[diffs]] == 1, Return[d, Module]],
    {d, 1, Min[Length[data] - 1, 500]}
  ];
  "not poly"
]

(* Now redo the key tests *)
Print["=== cleanPoly degree (FIXED) for Sqrt[2] ==="];
Print[""];
convs = Convergents[alpha, 10];
Print["Convergents: ", convs];
qDens = Denominator /@ convs;
Print["Denominators (q_k): ", qDens];
Print[""];

Do[
  cv = Convergents[alpha, k];
  {a, b} = Take[cv, -2];
  height = Denominator[a];
  maxPos = Numerator[b];
  prevPos = Numerator[a];

  If[maxPos > 5000, Continue[]];

  row = BeattyBallotCount[alpha, All, {maxPos, height}];
  data = Drop[row, prevPos - 1];

  deg = polyDeg[data];

  Print["k=", k,
    ": height=q_{", k-2, "}=", height,
    "  range=[p_{", k-2, "},p_{", k-1, "}]=[", prevPos, ",", maxPos, "]",
    "  degree=", deg,
    "  (height==degree? ", height === deg, ")"];,
  {k, 3, 9}
];

Print[""];
Print["=== Vary height j in range [99, 239] ==="];
Print[""];

Do[
  row = BeattyBallotCount[alpha, All, {239, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Continue[]];
  firstNZ = firstNZ[[1]];
  data = Drop[row, firstNZ - 1];

  deg = polyDeg[data];

  predicted = Table[vLin[n, w, j], {n, firstNZ, 239}];
  r2match = (data === predicted);

  corrDeg = "n/a";
  If[!r2match,
    correction = predicted[[;;Length[data]]] - data;
    corrDeg = polyDeg[correction];
  ];

  Print["j=", j,
    ": degree=", deg,
    " (==j? ", deg === j, ")",
    "  Result2=", r2match,
    "  correction_deg=", corrDeg];,
  {j, 1, 20}
];

Print[""];
Print["=== What the correction polynomial looks like at j=q1+1=3 ==="];
Print[""];
row3 = BeattyBallotCount[alpha, All, {239, 3}];
firstNZ3 = FirstPosition[row3, _?(# > 0 &)][[1]];
data3 = Drop[row3, firstNZ3 - 1];
uncorr3 = Table[vLin[n, w, 3], {n, firstNZ3, 239}];
corr3 = uncorr3 - data3;
Print["j=3: correction is constant = ", First[Union[corr3]]];
Print["     B(p0+p1, q0+q1) = B(1+3, 1+2) = B(4,3) = ", Binomial[6,3]/4];

Print[""];
Print["=== Factored form at j=3, 4, 5 (within [99, 239]) ==="];
Print[""];

Do[
  row = BeattyBallotCount[alpha, All, {239, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)][[1]];
  data = Drop[row, firstNZ - 1];
  pts = MapIndexed[{First[#2], #1} &, data];
  poly = InterpolatingPolynomial[pts, x];
  Print["j=", j, ": ", Factor[Expand[poly]]];
  Print[""];,
  {j, 1, 5}
];
