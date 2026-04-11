<< Orbit`

(* For rational alpha = p/q, compute P_j(n) in a suitable window *)
polyRational[alpha_Rational, j_, windowSize_: 200] := Module[
  {maxN, row, firstNZ, pts},
  maxN = Ceiling[j * alpha] + windowSize;
  row = BeattyBallotCount[alpha, All, {maxN, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Return[$Failed]];
  firstNZ = firstNZ[[1]];
  (* Use enough points to determine the degree-j poly *)
  pts = Table[{nn, row[[nn]]}, {nn, firstNZ, Min[firstNZ + 2 j + 5, maxN]}];
  InterpolatingPolynomial[pts, n] // Expand
]

(* Also for irrational *)
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

(* ============================================================ *)
(* Pi convergents: 3, 22/7, 333/106, 355/113                    *)
(* At heights j = 1..10 (straddling q1=7)                       *)
(* ============================================================ *)

convsPi = Convergents[Pi, 5];
Print["Pi convergents: ", convsPi];
Print[""];

(* Compare polynomials at each height *)
Print["=== Polynomials at height j for each rational convergent ==="];
Print[""];

Do[
  Print["--- j=", j, " ---"];

  (* Pi (irrational, ground truth) *)
  polyPi = polyIrrational[Pi, j];

  (* Each rational convergent *)
  Do[
    alpha = convsPi[[k]];
    If[!IntegerQ[alpha] && Denominator[alpha] < j, Continue[]];
    poly = If[IntegerQ[alpha],
      polyRational[alpha + 1/1000, j],  (* perturb integer slightly *)
      polyRational[alpha, j]
    ];
    If[poly === $Failed, Continue[]];

    diff = Expand[polyPi - poly];
    Print["  c_", k-1, "=", alpha, ": ",
      If[diff === 0,
        "IDENTICAL to Pi",
        "diff = " <> ToString[Factor[diff], InputForm]
      ]
    ];,
    {k, 2, 4}  (* skip c0=3, start from 22/7 *)
  ];
  Print[""];,
  {j, 6, 10}
];

(* ============================================================ *)
(* Deeper: fix j=8, vary a2 in [3; 7, a2]                       *)
(* ============================================================ *)

Print["=== Fix j=8, vary a2 in [w; 7, a2] = [3; 7, a2] ==="];
Print[""];

polyPi8 = polyIrrational[Pi, 8];
Print["Pi (a2=15): ", Factor[polyPi8]];
Print[""];

Do[
  alpha = FromContinuedFraction[{3, 7, a2}];
  poly = polyRational[alpha, 8, 300];
  If[poly === $Failed, Continue[]];
  diff = Expand[polyPi8 - poly];

  Print["a2=", a2, " (alpha=", alpha, "): ",
    If[diff === 0, "IDENTICAL",
      "diff = " <> ToString[Factor[diff], InputForm]
    ]
  ];,
  {a2, 1, 20}
];

Print[""];
Print["=== Coefficient-by-coefficient: j=8 polynomials ==="];
Print[""];

(* Extract coefficients in monomial basis *)
Print["Monomial coefficients [c0, c1, ..., c8]:"];
Print[""];

Do[
  alpha = FromContinuedFraction[{3, 7, a2}];
  poly = polyRational[alpha, 8, 300];
  If[poly === $Failed, Continue[]];
  coeffs = Table[Coefficient[poly, n, i], {i, 0, 8}];
  Print["  a2=", PaddedForm[a2, 3], " : ", coeffs];,
  {a2, {1, 2, 3, 5, 7, 10, 15, 20}}
];

Print[""];
Print["  Pi    : ", Table[Coefficient[polyPi8, n, i], {i, 0, 8}]];
