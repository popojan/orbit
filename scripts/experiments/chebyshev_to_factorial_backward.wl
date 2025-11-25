#!/usr/bin/env wolframscript
(* Backward reasoning: Chebyshev -> Factorial *)

Print["=== BACKWARD DERIVATION: Chebyshev -> Factorial ===\n"];

chebForm[x_, k_] := ChebyshevT[Ceiling[k/2], x+1] *
  (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

factForm[x_, k_] := 1 + Sum[2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]), {i, 1, k}];

Print["Step 1: Expand Chebyshev form explicitly"];
Print["=========================================\n"];

Do[
  n = Ceiling[kval/2];
  m = Floor[kval/2];

  Print["k=", kval, ": n=", n, ", m=", m];

  cheb = chebForm[x, kval] // Expand;
  Print["  Chebyshev: ", cheb];

  fact = factForm[x, kval] // Expand;
  Print["  Factorial: ", fact];

  Print["  Match: ", cheb == fact];

  (* Coefficient comparison *)
  chebCoeffs = CoefficientList[cheb, x];
  factCoeffs = CoefficientList[fact, x];

  Print["  Coefficients:"];
  Do[
    If[i <= Length[chebCoeffs] && i <= Length[factCoeffs],
      Print["    x^", i-1, ": Cheb=", chebCoeffs[[i]], ", Fact=", factCoeffs[[i]],
        ", Match=", chebCoeffs[[i]] == factCoeffs[[i]]];
    ];
  , {i, 1, Max[Length[chebCoeffs], Length[factCoeffs]]}];

  Print[];
, {kval, 1, 5}];

Print["Step 2: Analyze Chebyshev T and U definitions"];
Print["==============================================\n"];

Print["Recursive definitions:"];
Print["  T_0(y) = 1"];
Print["  T_1(y) = y"];
Print["  T_{n+1}(y) = 2y*T_n(y) - T_{n-1}(y)"];
Print[];
Print["  U_0(y) = 1"];
Print["  U_1(y) = 2y"];
Print["  U_{n+1}(y) = 2y*U_n(y) - U_{n-1}(y)"];
Print["\n"];

Print["Explicit polynomials (for y = x+1):"];
Do[
  tn = ChebyshevT[n, x+1] // Expand;
  un = ChebyshevU[n, x+1] // Expand;
  Print["  T_", n, "(x+1) = ", tn];
  Print["  U_", n, "(x+1) = ", un];
  Print[];
, {n, 0, 3}];

Print["Step 3: Analyze product structure"];
Print["==================================\n"];

Print["For k=3: T_2 * (U_1 - U_0)"];
Print[];

t2 = ChebyshevT[2, x+1] // Expand;
u1 = ChebyshevU[1, x+1] // Expand;
u0 = ChebyshevU[0, x+1] // Expand;

Print["  T_2(x+1) = ", t2];
Print["  U_1(x+1) = ", u1];
Print["  U_0(x+1) = ", u0];
Print["  U_1 - U_0 = ", u1 - u0];
Print[];

product = t2 * (u1 - u0) // Expand;
Print["  Product = ", product];
Print[];

factSum = 1 + Sum[2^(i-1) * x^i * Factorial[3+i]/(Factorial[3-i] * Factorial[2*i]), {i, 1, 3}] // Expand;
Print["  Factorial sum = ", factSum];
Print["  Match: ", product == factSum];
Print["\n"];

Print["Step 4: Look for algebraic pattern"];
Print["===================================\n"];

Print["Hypothesis: Factorial coefficients might come from"];
Print["expanding Chebyshev product using explicit formulas.\n"];

Print["Chebyshev T_n explicit formula:"];
Print["  T_n(cos(theta)) = cos(n*theta)"];
Print["  For |y| > 1: T_n(y) = cosh(n*arccosh(y))"];
Print[];

Print["Chebyshev U_n explicit formula:"];
Print["  U_n(cos(theta)) = sin((n+1)*theta)/sin(theta)"];
Print["  For |y| > 1: U_n(y) = sinh((n+1)*arccosh(y))/sinh(arccosh(y))"];
Print["\n"];

Print["Step 5: Connection via series expansion?"];
Print["=========================================\n"];

Print["Question: Can we derive factorial coefficients"];
Print["from Taylor/Maclaurin expansion of Chebyshev products?"];
Print[];

Print["Let's try for k=2 (simpler case):\n"];

k=2;
n = Ceiling[k/2];  (* n=1 *)
m = Floor[k/2];     (* m=1 *)

Print["k=2: n=", n, ", m=", m];
Print["  T_1(x+1) = ", ChebyshevT[1, x+1] // Expand];
Print["  U_1(x+1) = ", ChebyshevU[1, x+1] // Expand];
Print["  U_0(x+1) = ", ChebyshevU[0, x+1] // Expand];
Print[];

cheb2 = chebForm[x, 2] // Expand;
fact2 = factForm[x, 2] // Expand;

Print["  Chebyshev product: ", cheb2];
Print["  Factorial sum: ", fact2];
Print["  Match: ", cheb2 == fact2];
Print["\n"];

Print["=== Key observation ==="];
Print["The factorial coefficients exactly match Chebyshev polynomial coefficients!"];
Print["This means Factorial -> Chebyshev is an IDENTITY, not a transformation.\n"];

Print["Next: Need to prove this algebraically by showing"];
Print["factorial formula generates Chebyshev polynomial coefficients."];
