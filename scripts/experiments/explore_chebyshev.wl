#!/usr/bin/env wolframscript
(* Connection between mul[k,x] and Chebyshev polynomials *)

mul[k_, a_] := (I (-I - a)^k - (I - a)^k - I (-I + a)^k + (I + a)^k)/
               ((-I - a)^k - I (I - a)^k + (-I + a)^k - I (I + a)^k)

Print["=== CHEBYSHEV CONNECTION ===\n"]

(* Chebyshev polynomials:
   T_n(cos θ) = cos(nθ)
   U_n(cos θ) = sin((n+1)θ)/sin(θ)

   For tangent parametrization with x = tan(θ):
   cos(θ) = 1/√(1+x²)
   sin(θ) = x/√(1+x²)

   tan(nθ) = sin(nθ)/cos(nθ)
*)

Print["If we write tan(nθ) = P_n(tan θ)/Q_n(tan θ),"]
Print["then mul[n, x] should match this rational function."]
Print[""]

Print["Extracting numerator and denominator polynomials:"]
Print[""]

Do[
  expr = Simplify[mul[k, x]];
  num = Numerator[Together[expr]];
  den = Denominator[Together[expr]];

  (* Factor out powers of x *)
  {numCoeff, numPoly} = If[num === 0, {0, 0},
    FactorTermsList[num, x]];
  {denCoeff, denPoly} = If[den === 0, {0, 0},
    FactorTermsList[den, x]];

  Print["k = ", k, ":"];
  Print["  Numerator:   ", num];
  Print["  Denominator: ", den];
  Print["  Simplified:  ", expr];

  (* Check parity *)
  parity = If[Simplify[expr /. x -> -x] == -expr, "odd",
           If[Simplify[expr /. x -> -x] == expr, "even", "neither"]];
  Print["  Parity: ", parity];
  Print[""];
, {k, 1, 7}]

Print["=== PATTERN OBSERVATION ===\n"]

Print["Notice that tan(nθ) has parity (-1)^(n+1)"];
Print["- Odd n → tan(nθ) is odd function"];
Print["- Even n → tan(nθ) is odd function"];
Print["(Actually tan(nθ) is always odd!)"];
Print[""];

Print["=== RELATION TO CHEBYSHEV U POLYNOMIALS ===\n"]

(* The U_n Chebyshev polynomial of second kind satisfies:
   U_n(cos θ) = sin((n+1)θ)/sin(θ)

   We can write: sin(nθ) = sin(θ) · U_{n-1}(cos θ)
   And:          cos(nθ) = T_n(cos θ)

   So: tan(nθ) = sin(nθ)/cos(nθ) = [sin(θ) U_{n-1}(cos θ)]/[T_n(cos θ)]

   With x = tan(θ), cos(θ) = 1/√(1+x²), sin(θ) = x/√(1+x²)
*)

Print["Converting to tangent parametrization:"];
Print["If c = cos(θ) = 1/√(1+x²), then x² = (1-c²)/c²"];
Print[""];

(* Let's verify for small n *)
Do[
  (* Get Chebyshev polynomials *)
  tn = ChebyshevT[n, c];
  un1 = If[n > 0, ChebyshevU[n-1, c], 0];

  (* Express tan(nθ) using Chebyshev *)
  (* tan(nθ) = sin(θ)U_{n-1}(cos θ)/T_n(cos θ) *)
  (* With x = tan θ, sin θ = x/√(1+x²), cos θ = 1/√(1+x²) *)

  (* Substitute c = 1/√(1+x²) and simplify *)
  tanFormula = (x/Sqrt[1+x^2]) * un1 / tn /. c -> 1/Sqrt[1+x^2];
  tanFormula = Simplify[tanFormula];

  mulResult = Simplify[mul[n, x]];

  Print["n = ", n, ":"];
  Print["  From Chebyshev: ", tanFormula];
  Print["  From mul[n,x]:  ", mulResult];
  Print["  Match: ", Simplify[tanFormula - mulResult] == 0];
  Print[""];
, {n, 1, 5}]

Print["=== DIRECT POLYNOMIAL FORMS ===\n"]

(* Extract the actual polynomials P_n and Q_n where tan(nθ) = P_n(tan θ)/Q_n(tan θ) *)

Print["Writing tan(nθ) = P_n(x)/Q_n(x) where x = tan(θ):"];
Print[""];

Do[
  expr = Together[mul[n, x]];
  pn = Numerator[expr];
  qn = Denominator[expr];

  Print["n = ", n, ":"];
  Print["  P_", n, "(x) = ", Expand[pn]];
  Print["  Q_", n, "(x) = ", Expand[qn]];

  (* Coefficient sequences *)
  pCoeffs = CoefficientList[pn, x];
  qCoeffs = CoefficientList[qn, x];

  Print["  P coeffs: ", pCoeffs];
  Print["  Q coeffs: ", qCoeffs];
  Print[""];
, {n, 1, 8}]
