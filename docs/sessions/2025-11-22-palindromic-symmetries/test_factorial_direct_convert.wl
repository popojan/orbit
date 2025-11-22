#!/usr/bin/env wolframscript
(* Try direct conversion to hypergeometric *)

Print["Direct hypergeometric conversion attempt...\n"];

<< Orbit`

(* The sum *)
factSum[x_, j_] := Sum[2^(i-1) * x^i * Factorial[j+i] /
                        (Factorial[j-i] * Factorial[2*i]), {i, 1, j}];

(* Try for specific j *)
Print["Testing j=2:\n"];
j = 2;
s = factSum[x, j];
Print["Sum = ", s];
Print["Together: ", Together[s]];
Print["FullSimplify: ", FullSimplify[s]];
Print["FunctionExpand: ", FunctionExpand[s]];
Print[];

(* Check if Mathematica can recognize it *)
Print["Trying to express as hypergeometric:\n"];
j = 3;
s = factSum[x, j];

(* Use FindSequenceFunction on coefficients *)
coeffs = CoefficientList[s, x];
Print["Coefficients for j=3: ", coeffs];

(* Try multiple j values and find pattern *)
Print["\nCollecting coefficient patterns:\n"];
coeffTable = Table[{jval, CoefficientList[factSum[x, jval], x]}, {jval, 1, 5}];
Do[
  Print["j=", coeffTable[[i,1]], ": ", coeffTable[[i,2]]];
, {i, 1, Length[coeffTable]}];
Print[];

(* Check if it's related to Bessel functions *)
Print["Testing Bessel function relations:\n"];
j = 2;
target = factSum[x, j];
bessel = BesselI[0, 2*Sqrt[x]];
Print["BesselI[0, 2√x] = ", Series[bessel, {x, 0, 3}]];
Print["Target: ", target];
Print[];

(* Check Legendre polynomials *)
Print["Testing Legendre relations:\n"];
Do[
  leg = LegendreP[n, x];
  Print["LegendreP[", n, ", x] = ", Expand[leg]];
, {n, 1, 4}];
Print[];

(* Test if sum is related to (1-x)^(-a) series *)
Print["Testing geometric series variations:\n"];
j = 2;
target = factSum[x, j];
Print["Target: ", target];
Do[
  geo = Series[(1-a*x)^(-b), {x, 0, 3}] // Normal;
  Print["(1-", a, "*x)^(-", b, ") = ", geo];
, {a, 1, 2}, {b, 1, 2}];
Print[];

(* Direct symbolic sum *)
Print["Attempting symbolic sum:\n"];
sumExpr = Sum[2^(i-1) * z^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), {i, 1, k}];
Print["Symbolic: ", sumExpr];
Print[];

(* Try with HypergeometricPFQRegularized *)
Print["Testing regularized hypergeometric:\n"];
j = 3;
target = factSum[x, j];
reg = HypergeometricPFQRegularized[{1, -j, j+1}, {1, 1}, x];
Print["PFQRegularized[{1,-j,j+1},{1,1},x] = ", reg];
Print["Difference: ", Simplify[target - reg]];
Print[];

(* Check the Egypt factor relation *)
Print["Recall: Individual Egypt factors 1/(1+kx) = 2F1[1,1,1;-kx]\n"];
Print["But our sum is NOT a product of these factors.\n"];
Print["Our sum has (j+i)!/(j-i)! which is different structure.\n"];

(* Final attempt: Check if it's elementary *)
Print["Checking if sum is elementary (not hypergeometric):\n"];
Do[
  s = factSum[x, jval];
  rat = Together[s];
  num = Numerator[rat];
  den = Denominator[rat];
  degNum = Exponent[num, x];
  degDen = Exponent[den, x];
  Print["j=", jval, ": degree(num)=", degNum, ", degree(den)=", degDen,
        " → Rational, not hypergeometric"];
, {jval, 1, 5}];
Print[];

Print["CONCLUSION: The sum appears to be a RATIONAL FUNCTION, not hypergeometric!\n"];

Print["DONE!"];
