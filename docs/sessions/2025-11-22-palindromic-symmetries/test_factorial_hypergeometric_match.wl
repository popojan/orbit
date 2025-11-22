#!/usr/bin/env wolframscript
(* Try to match FactorialTerm sum to hypergeometric with scaled argument *)

Print["Searching for hypergeometric match with scaled argument...\n"];

<< Orbit`

(* The sum for various j *)
factSum[x_, j_] := Sum[2^(i-1) * x^i * Factorial[j+i] /
                        (Factorial[j-i] * Factorial[2*i]), {i, 1, j}];

(* Try different hypergeometric forms and arguments *)
Print["Testing scaled arguments for j=3:\n"];
j = 3;
target = factSum[x, j];
Print["Target: ", target];
Print[];

(* Try 2F1 with scaled arguments *)
scales = {1, 2, 4, 1/2, 1/4, -1, -2, -4};
params = {
  {1, 1, 1},
  {1, 2, 2},
  {1, 3, 2},
  {2, 2, 3},
  {-1, -2, 1},
  {-2, -3, 1},
  {-j, j+1, 1},
  {j+1, j+2, 2*j+2},
  {1, j+1, j+2}
};

Print["Testing 2F1[a,b,c,s*x]:\n"];
Do[
  {a, b, c} = params[[p]];
  Do[
    s = scales[[k]];
    hyp = s^j * Hypergeometric2F1[a, b, c, s*x];
    diff = Simplify[target - hyp];
    If[diff === 0,
      Print["  MATCH! 2F1[", a, ",", b, ",", c, ",", s, "*x] * ", s, "^", j];
      Print["    = ", hyp];
    ];
  , {k, 1, Length[scales]}];
, {p, 1, Length[params]}];
Print[];

(* Try 3F2 with various parameters *)
Print["Testing 3F2 forms:\n"];
params3F2 = {
  {{1, 1, 1}, {2, 2}},
  {{1, 1, j+1}, {2, 2}},
  {{1, -j, j+1}, {1, 2}},
  {{1, -j, j+1}, {1, 1}},
  {{-j, -j, j+1}, {1, 1}},
  {{1, 1, 2}, {3/2, 3/2}}
};

Do[
  {aList, bList} = params3F2[[p]];
  Do[
    s = scales[[k]];
    hyp = HypergeometricPFQ[aList, bList, s*x];
    diff = Simplify[target - hyp];
    If[diff === 0,
      Print["  MATCH! 3F2[", aList, ",", bList, ",", s, "*x]"];
    ];
  , {k, 1, Length[scales]}];
, {p, 1, Length[params3F2]}];
Print[];

(* Check the pattern in coefficients *)
Print["Coefficient pattern analysis:\n"];
Do[
  s = factSum[x, jval];
  coeffs = CoefficientList[s, x];
  Print["j=", jval, ": ", coeffs];
, {jval, 1, 6}];
Print[];

(* Leading coefficient is triangular number *)
Print["Leading coefficients (triangular numbers):\n"];
Do[
  s = factSum[x, jval];
  leadCoeff = Coefficient[s, x, 1];
  triangular = jval*(jval+1)/2;
  Print["j=", jval, ": ", leadCoeff, " = ", triangular, " (", leadCoeff == triangular, ")"];
, {jval, 1, 6}];
Print[];

(* Try expressing as derivative or integral of hypergeometric *)
Print["Testing if it's derivative/integral of hypergeometric:\n"];
j = 3;
target = factSum[x, j];

(* d/dx of 2F1 *)
hyp = Hypergeometric2F1[1, 2, 2, x];
dhyp = D[hyp, x];
Print["D[2F1[1,2,2,x], x] = ", dhyp];
Print["Match? ", Simplify[target - dhyp] === 0];
Print[];

(* Check OEIS for coefficient sequences *)
Print["OEIS lookup hints:\n"];
Do[
  s = factSum[x, jval];
  coeffs = CoefficientList[s, x];
  coeffs = Drop[coeffs, 1]; (* Remove constant term *)
  Print["j=", jval, ": ", coeffs];
, {jval, 1, 6}];
Print[];

Print["DONE!"];
