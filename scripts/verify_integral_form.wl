#!/usr/bin/env wolframscript
(* Verify that integral form matches closed form in convergent region *)

Print["=== Verification: Integral vs Closed Form ===\n"];

M[n_Integer] := Module[{divs},
  divs = Select[Divisors[n], 2 <= # <= Sqrt[n] &];
  Length[divs]
];

(* Closed form (valid Re(s) > 1) *)
CApprox[s_, jmax_:500] := Sum[HarmonicNumber[j-1, s]/j^s, {j, 2, jmax}];
LMClosed[s_, jmax_:500] := Zeta[s]*(Zeta[s] - 1) - CApprox[s, jmax];

(* Integral form - CORRECT with Gamma normalization *)
ThetaM[x_, nmax_] := Sum[M[n] * Exp[-n*x], {n, 2, nmax}];

LMIntegral[s_, nmax_:200] := (1/Gamma[s]) * NIntegrate[
  ThetaM[x, nmax] * x^(s-1),
  {x, 0, Infinity},
  Method -> "GlobalAdaptive",
  MaxRecursion -> 10,
  PrecisionGoal -> 6,
  AccuracyGoal -> 6,
  WorkingPrecision -> 30
];

(* Test points in convergent region Re(s) > 1 *)
testPoints = {2, 3, 2 + I, 1.5, 1.2};

Print["Testing various nmax for Θ_M:"];
Print[StringRepeat["=", 80]];

Do[
  s0 = s;
  Print["\nTest point: s = ", N[s0, 6]];
  Print[StringRepeat["-", 80]];

  (* Closed form reference *)
  refValue = LMClosed[s0, 500];
  Print["Reference (closed form, jmax=500): ", N[refValue, 10]];

  (* Try different nmax for integral *)
  Do[
    intValue = LMIntegral[s0, nmax];
    relError = Abs[(intValue - refValue)/refValue];
    Print[StringForm["  nmax = %:  Integral = %, RelError = %",
      nmax,
      N[intValue, 10],
      N[relError * 100, 4], "%"
    ]];
  , {nmax, {50, 100, 200, 300}}];

, {s, testPoints}];

Print["\n" <> StringRepeat["=", 80]];
Print["Conclusion:"];
Print["If relative error < 1% for nmax=200-300, integral form is reliable."];
Print["Otherwise, need higher nmax or different integration method."];
Print[StringRepeat["=", 80]];
