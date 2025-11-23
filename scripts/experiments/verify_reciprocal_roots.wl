#!/usr/bin/env wolframscript
(* Verify reciprocal root properties for Chebyshev *)

Print["=== RECIPROCAL ROOTS VERIFICATION ===\n"];

(* Define Chebyshev tangent multiplication *)
tangentMult[n_, x_] := Module[{num, den},
  num = I*(-I - x)^(4*n) - (I - x)^(4*n) - I*(-I + x)^(4*n) + (I + x)^(4*n);
  den = (-I - x)^(4*n) - I*(I - x)^(4*n) + (-I + x)^(4*n) - I*(I + x)^(4*n);
  Simplify[num/den]
];

(* Extract numerator and denominator as polynomials *)
Print["Testing F_2(x) = tan(2*arctan(x)):\n"];

f2 = tangentMult[2, x];
Print["F_2(x) = ", f2];

(* Get polynomial forms *)
{num2, den2} = {Numerator[f2], Denominator[f2]};
Print["Numerator p_2(x) = ", Expand[num2]];
Print["Denominator q_2(x) = ", Expand[den2]];

(* Find roots *)
Print["\nRoots of numerator p_2:"];
rootsNum = Solve[num2 == 0, x];
Print[rootsNum];

Print["\nRoots of denominator q_2:"];
rootsDen = Solve[den2 == 0, x];
Print[rootsDen];

(* Check reciprocal property *)
Print["\n=== RECIPROCAL PROPERTY CHECK ===\n"];

Print["For each root α of p_2, checking if 1/α is also a root:\n"];
Do[
  alpha = x /. rootsNum[[i]];
  reciprocal = 1/alpha;

  Print["Root ", i, ": α = ", alpha];
  Print["  1/α = ", Simplify[reciprocal]];

  (* Check if 1/α is root of p_2 *)
  val_p = Simplify[num2 /. x -> reciprocal];
  Print["  p_2(1/α) = ", val_p];

  (* Check if 1/α is root of q_2 *)
  val_q = Simplify[den2 /. x -> reciprocal];
  Print["  q_2(1/α) = ", val_q];

  (* Check if 1/α is among roots *)
  isInNum = MemberQ[Simplify[x /. rootsNum], Simplify[reciprocal]];
  isInDen = MemberQ[Simplify[x /. rootsDen], Simplify[reciprocal]];

  Print["  1/α is root of p_2? ", isInNum];
  Print["  1/α is root of q_2? ", isInDen];
  Print[""];
, {i, 1, Length[rootsNum]}];

Print["\n=== FUNCTIONAL EQUATION VERIFICATION ===\n"];

Print["Testing F_2(x) * F_2(1/x):\n"];
f2_reciprocal = tangentMult[2, 1/x];
product = Simplify[f2 * f2_reciprocal];
Print["F_2(x) * F_2(1/x) = ", product];

Print["\n=== u = x + 1/x SUBSTITUTION ===\n"];

(* For palindromic polynomial, apply substitution *)
Print["For polynomial p(x) = 1 + 4x + 2x^2 (Egypt quadratic factor):\n"];
p = 1 + 4*x + 2*x^2;

Print["Original: p(x) = ", p];
Print["Degree: ", Exponent[p, x]];

(* Make substitution u = x + 1/x, so x^2 + 1 = ux *)
Print["\nSubstitution u = x + 1/x:"];
Print["Then x^2 - ux + 1 = 0"];
Print["So x^2 = ux - 1"];

(* Express p(x) in terms of u *)
Print["\nExpress p(x) via u:"];
Print["p(x) = 1 + 4x + 2x^2"];
Print["     = 1 + 4x + 2(ux - 1)"];
Print["     = 1 + 4x + 2ux - 2"];
Print["     = 4x + 2ux - 1"];
Print["     = (4 + 2u)x - 1"];

(* This should factor through x^2 - ux + 1 *)
pExpanded = 1 + 4*x + 2*x^2;
(* Multiply by x to make even degree *)
pTimes = x * pExpanded;
Print["\nx*p(x) = ", Expand[pTimes]];

(* Divide by (x^2 - ux + 1) to get quotient in u *)
Print["\nDividing x*p(x) by (x^2 - ux + 1):\n"];
quotient = PolynomialQuotient[pTimes /. x^2 -> u*x - 1, x, x];
Print["Quotient: ", quotient];

Print["\n=== CHEBYSHEV EXPLICIT TEST ===\n"];

Print["For F_3(x):\n"];
f3 = tangentMult[3, x];
{num3, den3} = {Numerator[f3], Denominator[f3]};

Print["p_3(x) = ", Expand[num3]];
Print["q_3(x) = ", Expand[den3]];

(* Extract coefficients *)
coeffNum3 = CoefficientList[num3, x];
coeffDen3 = CoefficientList[den3, x];

Print["\nCoefficients p_3: ", coeffNum3];
Print["Coefficients q_3: ", coeffDen3];

(* Check reversal: p_3/x vs q_3 *)
(* p_3(x) has x factor, so p_3/x has degree reduced by 1 *)
coeffNumReduced = Drop[coeffNum3, 1]; (* Remove leading 0 *)

Print["\nCoefficients p_3/x: ", coeffNumReduced];
Print["Reversed: ", Reverse[coeffNumReduced]];
Print["Coefficients q_3: ", coeffDen3];
Print["Match (up to scaling)? ", Simplify[coeffDen3/coeffNumReduced[[1]]] == Simplify[Reverse[coeffNumReduced]/Last[coeffNumReduced]]];
