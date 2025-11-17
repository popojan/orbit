#!/usr/bin/env wolframscript
(*
Chebyshev Pair Summation - Analytical Simplification
Suma term[x, 2m] + term[x, 2m+1] with Chebyshev polynomials
*)

Print["=" * 70];
Print["CHEBYSHEV PAIR SUMMATION"];
Print["=" * 70];
Print[];

(* Define individual terms *)
termEven[x_, m_] := 1/(ChebyshevT[m, x+1] * (ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1]))
termOdd[x_, m_] := 1/(ChebyshevT[m+1, x+1] * (ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1]))

(* Sum of pair *)
pairSum[x_, m_] := termEven[x, m] + termOdd[x, m]

Print["Testing for small m symbolically..."];
Print[];

(* Test m=1,2,3 symbolically *)
Do[
  Print["m = ", m];
  expr = pairSum[x, m];
  Print["  Raw sum: ", expr];
  simplified = Simplify[expr];
  Print["  Simplified: ", simplified];
  Print[];
  ,
  {m, 1, 3}
];

Print["=" * 70];
Print["SUBSTITUTION: x+1 = Cos[θ]"];
Print["=" * 70];
Print[];

(* Use Chebyshev identities with trigonometric substitution *)
(* T_n(cos θ) = cos(nθ) *)
(* U_n(cos θ) sin θ = sin((n+1)θ) *)

Print["For x+1 = Cos[θ], we have:"];
Print["  T_m(Cos[θ]) = Cos[m*θ]"];
Print["  U_m(Cos[θ]) - U_{m-1}(Cos[θ]) = Sin[(m+1)θ]/Sin[θ] - Sin[m*θ]/Sin[θ]"];
Print[];

(* Explicit form with trigonometric substitution *)
termEvenTrig[m_] := Module[{},
  (* 1 / (Cos[m*θ] * (Sin[(m+1)*θ] - Sin[m*θ])/Sin[θ]) *)
  Sin[θ] / (Cos[m*θ] * (Sin[(m+1)*θ] - Sin[m*θ]))
];

termOddTrig[m_] := Module[{},
  (* 1 / (Cos[(m+1)*θ] * (Sin[(m+1)*θ] - Sin[m*θ])/Sin[θ]) *)
  Sin[θ] / (Cos[(m+1)*θ] * (Sin[(m+1)*θ] - Sin[m*θ]))
];

pairSumTrig[m_] := termEvenTrig[m] + termOddTrig[m];

Print["Testing trigonometric form for m=1,2,3..."];
Print[];

Do[
  Print["m = ", m];
  expr = pairSumTrig[m];
  Print["  Raw trig sum: ", expr];
  simplified = TrigReduce[Simplify[expr]];
  Print["  TrigReduced: ", simplified];
  expanded = TrigExpand[simplified];
  Print["  TrigExpanded: ", expanded];
  Print[];
  ,
  {m, 1, 4}
];

Print["=" * 70];
Print["NUMERICAL VERIFICATION: n=13, x from Pell"];
Print["=" * 70];
Print[];

(* For n=13, fundamental solution *)
n = 13;
x = 649;  (* From Pell equation *)
y = 180;

Print["n = ", n];
Print["x = ", x, ", y = ", y];
Print["Verify: x^2 - n*y^2 = ", x^2 - n*y^2];
Print[];

Print["Numerical pair sums:"];
Do[
  pair = N[pairSum[x, m], 20];
  even = N[termEven[x, m], 20];
  odd = N[termOdd[x, m], 20];
  Print["m = ", m, ":"];
  Print["  term[x,", 2*m, "] = ", even];
  Print["  term[x,", 2*m+1, "] = ", odd];
  Print["  SUM = ", pair];
  Print["  Simplified form: ", Simplify[pairSum[x, m]]];
  Print[];
  ,
  {m, 1, 5}
];

Print["=" * 70];
