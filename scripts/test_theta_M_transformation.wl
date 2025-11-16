#!/usr/bin/env wolframscript
(* Test Theta Function Transformation for M(n) *)
(* Based on Riemann's 1859 technique with Jacobi theta *)

Print["=== Testing Theta_M Transformation ===\n"];

(* Define M(n) - count of divisors 2 ≤ d ≤ √n *)
M[n_Integer] := Module[{divs},
  divs = Select[Divisors[n], 2 <= # <= Sqrt[n] &];
  Length[divs]
];

(* Theta function with quadratic exponential (like Jacobi) *)
ThetaM[x_, nmax_:500] := Module[{sum},
  sum = Sum[M[n] Exp[-n^2 Pi x], {n, 1, nmax}];
  N[sum, 20]
];

(* Alternative: Linear exponential (closer to Riemann's ψ) *)
PsiM[x_, nmax_:500] := Module[{sum},
  sum = Sum[M[n] Exp[-n Pi x], {n, 1, nmax}];
  N[sum, 20]
];

Print["Testing quadratic theta function Θ_M(x) = Σ M(n) e^(-n²πx)\n"];

(* Test transformation at several x values *)
testValues = {0.5, 1.0, 2.0, 3.0, 5.0, 10.0};

Print["Testing Θ_M(1/x) vs x^α Θ_M(x):\n"];
Print[StringForm["%-10s %-20s %-20s %-15s %-15s",
  "x", "Θ_M(x)", "Θ_M(1/x)", "Ratio", "x*Ratio"]];
Print[StringRepeat["-", 80]];

Do[
  val1 = ThetaM[x];
  val2 = ThetaM[1/x];
  ratio = val2/val1;
  xRatio = x * ratio;

  Print[StringForm["%-10s %-20s %-20s %-15s %-15s",
    N[x, 4],
    N[val1, 12],
    N[val2, 12],
    N[ratio, 10],
    N[xRatio, 10]
  ]];
, {x, testValues}];

Print["\n"];

(* Look for power law: ratio = x^α *)
Print["If ratio ≈ x^α, then α = log(ratio)/log(x):\n"];
Print[StringForm["%-10s %-15s", "x", "α estimate"]];
Print[StringRepeat["-", 30]];

alphaEstimates = {};
Do[
  If[x != 1,
    val1 = ThetaM[x];
    val2 = ThetaM[1/x];
    ratio = val2/val1;
    alpha = Log[ratio]/Log[x];
    AppendTo[alphaEstimates, alpha];
    Print[StringForm["%-10s %-15s", N[x, 4], N[alpha, 10]]];
  ];
, {x, testValues}];

Print["\nMean α estimate: ", N[Mean[alphaEstimates], 10]];
Print["Std dev: ", N[StandardDeviation[alphaEstimates], 10]];

Print["\n" <> StringRepeat["=", 80]];

(* Now test linear exponential Ψ_M *)
Print["\nTesting linear Ψ_M(x) = Σ M(n) e^(-nπx)\n"];

Print[StringForm["%-10s %-20s %-20s %-15s %-15s",
  "x", "Ψ_M(x)", "Ψ_M(1/x)", "Ratio", "x*Ratio"]];
Print[StringRepeat["-", 80]];

Do[
  val1 = PsiM[x];
  val2 = PsiM[1/x];
  ratio = val2/val1;
  xRatio = x * ratio;

  Print[StringForm["%-10s %-20s %-20s %-15s %-15s",
    N[x, 4],
    N[val1, 12],
    N[val2, 12],
    N[ratio, 10],
    N[xRatio, 10]
  ]];
, {x, testValues}];

Print["\n"];

(* Check for x^α pattern in Ψ_M *)
Print["Alpha estimates for Ψ_M:\n"];
Print[StringForm["%-10s %-15s", "x", "α estimate"]];
Print[StringRepeat["-", 30]];

alphaEstimatesPsi = {};
Do[
  If[x != 1,
    val1 = PsiM[x];
    val2 = PsiM[1/x];
    ratio = val2/val1;
    alpha = Log[ratio]/Log[x];
    AppendTo[alphaEstimatesPsi, alpha];
    Print[StringForm["%-10s %-15s", N[x, 4], N[alpha, 10]]];
  ];
, {x, testValues}];

Print["\nMean α estimate: ", N[Mean[alphaEstimatesPsi], 10]];
Print["Std dev: ", N[StandardDeviation[alphaEstimatesPsi], 10]];

Print["\n" <> StringRepeat["=", 80]];

(* Compare with zeta's theta *)
Print["\nFor comparison: Riemann's theta for ζ(s):\n"];
Print["ψ(x) = Σ e^(-n²πx) satisfies: 2ψ(x) + 1 = x^(-1/2)[2ψ(1/x) + 1]\n"];

RiemannPsi[x_, nmax_:500] := Sum[Exp[-n^2 Pi x], {n, 1, nmax}];

Print["Testing: (2ψ(x) + 1) vs x^(-1/2)(2ψ(1/x) + 1):\n"];
Print[StringForm["%-10s %-20s %-20s %-15s", "x", "LHS", "RHS", "Ratio"]];
Print[StringRepeat["-", 70]];

Do[
  lhs = 2*RiemannPsi[x] + 1;
  rhs = x^(-0.5) * (2*RiemannPsi[1/x] + 1);
  ratio = rhs/lhs;

  Print[StringForm["%-10s %-20s %-20s %-15s",
    N[x, 4],
    N[lhs, 12],
    N[rhs, 12],
    N[ratio, 10]
  ]];
, {x, testValues}];

Print["\n(Ratio should be ≈ 1.0 for Jacobi theta)\n"];

Print["=== Test Complete ==="];
Print["If α estimates are consistent, we have found the gamma factor!"];
