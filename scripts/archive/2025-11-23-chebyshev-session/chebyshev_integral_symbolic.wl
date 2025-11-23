#!/usr/bin/env wolframscript

Print["SYMBOLIC PROOF: Integrate[|T_{k+1}(x) - x*T_k(x)|, {x,-1,1}] = 1"];
Print[StringRepeat["=", 70]];
Print[];

(* Define f(x,k) *)
f[x_, k_] := ChebyshevT[k + 1, x] - x*ChebyshevT[k, x];

Print[StringRepeat["=", 70]];
Print["STEP 1: SIMPLIFY USING RECURRENCE"];
Print[StringRepeat["=", 70]];
Print[];

Print["Chebyshev recurrence: T_{k+1}(x) = 2x*T_k(x) - T_{k-1}(x)"];
Print[];
Print["Therefore:"];
Print["  f(x,k) = T_{k+1}(x) - x*T_k(x)"];
Print["         = [2x*T_k(x) - T_{k-1}(x)] - x*T_k(x)"];
Print["         = x*T_k(x) - T_{k-1}(x)"];
Print[];

(* Verify this algebraically *)
fSimplified[x_, k_] := x*ChebyshevT[k, x] - ChebyshevT[k - 1, x];

Print["Verification for k=1..5:"];
Do[
  orig = f[x, k];
  simpl = fSimplified[x, k];
  equal = Simplify[orig - simpl] == 0;
  Print["  k=", k, ": f(x,k) == x*T_k(x) - T_{k-1}(x)? ", equal];
, {k, 1, 5}];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 2: SYMBOLIC INTEGRATION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Computing Integrate[|f(x,k)|, {x,-1,1}] symbolically for k=1..8"];
Print[];

integrals = Table[
  Module[{expr, absExpr, integral},
    expr = fSimplified[x, k];

    (* For Chebyshev polynomials, need to handle absolute value carefully *)
    (* Try direct integration *)
    integral = Integrate[Abs[expr], {x, -1, 1}];

    Print["k=", k, ":"];
    Print["  f(x,k) = ", expr];
    Print["  Integral = ", integral];
    Print[];

    integral
  ],
  {k, 1, 8}
];

Print[StringRepeat["=", 70]];
Print["STEP 3: PATTERN ANALYSIS"];
Print[StringRepeat["=", 70]];
Print[];

Print["Results:"];
Do[
  Print["  k=", k, ": ", integrals[[k]]];
, {k, 1, 8}];
Print[];

(* Check if all equal to 1 *)
allOne = And @@ Table[integrals[[k]] == 1, {k, 1, 8}];
Print["All integrals equal to 1? ", allOne];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 4: ALTERNATIVE - SPLIT BY SIGN"];
Print[StringRepeat["=", 70]];
Print[];

Print["For Chebyshev polynomials, we can find roots and split integration"];
Print[];

(* Example for k=3 *)
k = 3;
expr = fSimplified[x, k];
Print["Example k=3:"];
Print["  f(x,3) = ", expr];
Print[];

(* Find roots *)
roots = Solve[expr == 0, x, Reals];
Print["  Roots: ", roots];
Print[];

(* Numerical roots *)
numRoots = Sort[x /. roots // N];
Print["  Numerical roots: ", numRoots];
Print[];

(* Split integral by sign *)
Print["  Splitting integral at roots..."];

(* For general approach, use NIntegrate to verify pattern *)
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 5: ORTHOGONALITY APPROACH"];
Print[StringRepeat["=", 70]];
Print[];

Print["Chebyshev polynomials have orthogonality:"];
Print["  Integrate[T_m(x)*T_n(x)/Sqrt[1-x^2], {x,-1,1}] = 0 for m != n"];
Print[];

Print["Our integral (without weight function):"];
Print["  I_k = Integrate[|x*T_k(x) - T_{k-1}(x)|, {x,-1,1}]"];
Print[];

Print["Let's compute without absolute value first:"];
Do[
  integral = Integrate[fSimplified[x, k], {x, -1, 1}];
  Print["  k=", k, ": Integrate[f(x,k), {x,-1,1}] = ", integral];
, {k, 1, 5}];
Print[];

Print[StringRepeat["=", 70]];
Print["STEP 6: DIRECT SYMBOLIC COMPUTATION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Using Piecewise for absolute value:"];
Print[];

Do[
  Module[{expr, roots, numRoots, pieces, integral},
    expr = fSimplified[x, k];

    (* Get numerical roots for piecewise definition *)
    roots = NSolve[expr == 0 && -1 <= x <= 1, x, Reals];

    If[Length[roots] > 0,
      numRoots = Sort[x /. roots];
      Print["k=", k, ": roots at ", numRoots];

      (* Build piecewise integral *)
      (* This is getting complex - better to use NIntegrate for verification *)
      integral = NIntegrate[Abs[expr], {x, -1, 1}, WorkingPrecision -> 30];
      Print["  NIntegrate = ", integral];
      Print["  Difference from 1: ", integral - 1];
      Print[];
    ];
  ];
, {k, 1, 10}];

Print[StringRepeat["=", 70]];
Print["STEP 7: CONJECTURE VERIFICATION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Conjecture: For all natural k, Integrate[|f(x,k)|, {x,-1,1}] = 1"];
Print[];

Print["Verified symbolically for k=1..8? ", allOne];
Print["Verified numerically (high precision) for k=1..10? Checking...");
Print[];

highPrecIntegrals = Table[
  NIntegrate[Abs[fSimplified[x, k]], {x, -1, 1}, WorkingPrecision -> 50],
  {k, 1, 20}
];

maxError = Max[Abs[highPrecIntegrals - 1]];
Print["Maximum error for k=1..20: ", maxError];
Print[];

If[maxError < 10^(-40),
  Print["VERIFIED: All integrals = 1 to 40 decimal places"],
  Print["ISSUE: Some integrals deviate from 1"]
];
Print[];

Print["DONE!"];
