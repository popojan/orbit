<< Orbit`

(* Diagonal values: count at (n, n) for various 1/alpha *)

Print["=== Diagonal counts BeattyBallotCount[1/alpha, {n, n}] ==="];
Print[""];

alphas = {
  {1/2, "1/2"},
  {1/Sqrt[5], "1/Sqrt5"},
  {1/Sqrt[2], "1/Sqrt2"},
  {1/GoldenRatio, "1/phi"},
  {1/Pi, "1/Pi"}
};

Do[
  {al, name} = entry;
  vals = Table[BeattyBallotCount[al, {n, n}], {n, 1, 15}];
  Print[name, ": ", vals];,
  {entry, alphas}
];

Print[""];
Print["=== Newton form of diagonal for 1/2 ==="];
vals12 = Table[BeattyBallotCount[1/2, {n, n}], {n, 1, 15}];
interp12 = InterpolatingPolynomial[vals12, x];
Print["1/2: ", interp12];

Print[""];
Print["=== Newton form of diagonal for 1/Sqrt5 ==="];
valsSqrt5 = Table[BeattyBallotCount[1/Sqrt[5], {n, n}], {n, 1, 15}];
interpSqrt5 = InterpolatingPolynomial[valsSqrt5, x];
Print["1/Sqrt5: ", interpSqrt5];

Print[""];
Print["=== Are they the same? ==="];
Print["Match: ", Expand[interp12] === Expand[interpSqrt5]];
Print[""];

Print["=== Difference ==="];
Print[Expand[interp12 - interpSqrt5]];

Print[""];
Print["=== Newton divided differences (diagonal values) ==="];
Print[""];

(* Compute divided differences manually *)
newtonCoeffs[vals_] := Module[{dd = vals, coeffs = {vals[[1]]}, n = Length[vals]},
  Do[
    dd = Table[(dd[[i + 1]] - dd[[i]]), {i, 1, Length[dd] - 1}] /
         Table[k, {k, 1, Length[dd] - 1}]; (* NOT right, use proper formula *)
    0,
    {k, 1, n - 1}
  ];
  (* Actually just use the InterpolatingPolynomial expansion *)
  vals
]

(* Extract Newton coefficients from InterpolatingPolynomial *)
(* The form is c0 + c1(x-1) + c2(x-1)(x-2) + ... *)
Print["Newton coefficients for 1/2:"];
Do[
  coeff = SeriesCoefficient[
    Series[InterpolatingPolynomial[Take[vals12, k + 1], x], {x, Infinity, 0}],
    0] * (-1)^k;
  0;,
  {k, 0, 10}
];

(* Simpler: just read off from the nested form *)
(* InterpolatingPolynomial gives Newton form directly *)
(* Let me just compute divided differences *)
dividedDiffs[vals_] := Module[{dd, n = Length[vals], result},
  dd = vals;
  result = {dd[[1]]};
  Do[
    dd = Table[(dd[[i + 1]] - dd[[i]])/(i + k - 1 - (i - 1)), {i, 1, Length[dd] - 1}];
    (* Standard divided difference: f[x0,...,xk] *)
    dd = Table[(dd[[i + 1]] - dd[[i]]), {i, 1, Length[dd] - 1}];
    0;,
    {k, 1, n - 1}
  ];
  result
]

(* Actually, the simplest way: evaluate the Newton coefficients *)
(* For nodes x=1,2,...,n the Newton coeff c_k is the k-th divided difference *)
(* f[1], f[1,2], f[1,2,3], ... *)
newtonCoeffs2[vals_] := Module[{n = Length[vals], dd},
  dd = vals;
  Table[
    If[k > 1, dd = Table[(dd[[i + 1]] - dd[[i]])/(k - 1), {i, 1, Length[dd] - 1}]];
    dd[[1]],
    {k, 1, n}
  ]
]

(* Hmm, that's not right either. Standard Newton divided differences: *)
newtonDD[vals_] := Module[{dd = N[vals, 30], n = Length[vals]},
  result = {dd[[1]]};
  Do[
    dd = Table[(dd[[i + 1]] - dd[[i]])/k, {i, 1, Length[dd] - 1}];
    AppendTo[result, dd[[1]]];,
    {k, 1, n - 1}
  ];
  result
]

Print["Approx Newton coefficients (divided diffs at 1,2,...):"];
Print["1/2:    ", newtonDD[vals12]];
Print["1/Sqrt5: ", newtonDD[valsSqrt5]];

(* Exact: compute from the polynomial *)
Print[""];
Print["=== Exact Newton coefficients ==="];
exactNewton[poly_, n_] := Table[
  Sum[(-1)^(k - j) Binomial[k, j] (poly /. x -> j + 1), {j, 0, k}] / k!,
  {k, 0, n}
]

poly12 = InterpolatingPolynomial[vals12, x] // Expand;
polySqrt5 = InterpolatingPolynomial[valsSqrt5, x] // Expand;

nc12 = exactNewton[poly12, 12];
ncSqrt5 = exactNewton[polySqrt5, 12];

Print["1/2:     ", nc12];
Print["1/Sqrt5: ", ncSqrt5];
Print[""];
Print["Equal?:  ", nc12 === ncSqrt5];
Print["Diffs:   ", nc12 - ncSqrt5];
