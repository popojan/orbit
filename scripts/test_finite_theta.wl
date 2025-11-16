#!/usr/bin/env wolframscript
(* Test finite Theta_M for practical integral form *)

Print["=== Finite Theta_M Test ===\n"];
Print["Philosophy: Return to primal forest geometry"];
Print["Trade-off: Lose ζ(s) elegance, gain practical convergence\n"];

M[n_Integer] := Module[{divs},
  divs = Select[Divisors[n], 2 <= # <= Sqrt[n] &];
  Length[divs]
];

(* Closed form (reference, Re(s) > 1) *)
CApprox[s_, jmax_:500] := Sum[HarmonicNumber[j-1, s]/j^s, {j, 2, jmax}];
LMClosed[s_, jmax_:500] := Zeta[s]*(Zeta[s] - 1) - CApprox[s, jmax];

(* FINITE Theta function - direct M(n) computation *)
ThetaMFinite[x_, nmax_] := Sum[M[n] * Exp[-n*x], {n, 2, nmax}];

(* Integral form with FINITE theta *)
LMIntegralFinite[s_, nmax_:200] := (1/Gamma[s]) * NIntegrate[
  ThetaMFinite[x, nmax] * x^(s-1),
  {x, 0, Infinity},
  Method -> "GlobalAdaptive",
  MaxRecursion -> 8,
  PrecisionGoal -> 5,
  AccuracyGoal -> 5,
  WorkingPrecision -> 25
];

Print["Test points (including critical region):"];
Print[StringRepeat["=", 80], "\n"];

testPoints = {
  {3, "Re(s)=3 (deep convergent)"},
  {2, "Re(s)=2 (convergent)"},
  {1.5, "Re(s)=1.5 (marginal)"},
  {1/2 + 5*I, "Critical line: s=1/2+5i"},
  {1/2 + 10*I, "Critical line: s=1/2+10i"}
};

Do[
  {s0, desc} = test;
  Print["Testing: ", desc];
  Print[StringRepeat["-", 80]];

  (* Reference (if in convergent region) *)
  If[Re[s0] > 1,
    refValue = LMClosed[s0, 500];
    Print["Reference (closed form): ", N[refValue, 8]];
  ,
    Print["Reference: N/A (outside closed form domain)"];
    refValue = Null;
  ];

  (* Test different nmax *)
  Print["Finite Θ_M test:"];
  Do[
    intValue = LMIntegralFinite[s0, nmax];

    If[refValue =!= Null,
      relError = Abs[(intValue - refValue)/refValue];
      Print[StringForm["  nmax=%:  L_M = %,  RelError = %%",
        nmax, N[intValue, 8], N[relError*100, 3]
      ]];
    ,
      Print[StringForm["  nmax=%:  L_M = % (no reference)",
        nmax, N[intValue, 8]
      ]];
    ];
  , {nmax, {50, 100, 200}}];

  Print[""];
, {test, testPoints}];

Print[StringRepeat["=", 80]];
Print["Interpretation:"];
Print["- If critical line values CONVERGE as nmax increases → real behavior"];
Print["- If they DIVERGE or oscillate wildly → still truncation issues"];
Print["- Compare with closed form errors in convergent region"];
Print[StringRepeat["=", 80]];
