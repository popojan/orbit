#!/usr/bin/env wolframscript
(* Analyze coefficient pattern *)

Print["=== COEFFICIENT PATTERN ANALYSIS ===\n"];

(* Extract i-th coefficient from polynomial *)
getCoeff[poly_, var_, power_] := Coefficient[poly, var, power];

Print["Step 1: Factorial term coefficients"];
Print["====================================\n"];

factCoeff[k_, i_] := 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);

Print["Pattern for k=1 to 5:\n"];
Do[
  Print["k=", kval, ":"];
  Do[
    c = factCoeff[kval, i];
    Print["  i=", i, ": coeff = ", c];
  , {i, 1, kval}];
  Print[];
, {kval, 1, 5}];

Print["Step 2: Chebyshev polynomial coefficients"];
Print["==========================================\n"];

chebPoly[k_] := ChebyshevT[Ceiling[k/2], x+1] *
  (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]) // Expand;

Do[
  poly = chebPoly[kval];
  coeffs = CoefficientList[poly, x];

  Print["k=", kval, ":", poly];
  Print["  Coefficients: ", coeffs];
  Print[];
, {kval, 1, 5}];

Print["Step 3: Direct comparison"];
Print["=========================\n"];

Do[
  Print["k=", kval, ":"];

  (* Chebyshev coefficients *)
  chebCoeffs = CoefficientList[chebPoly[kval], x];

  (* Factorial coefficients (including constant term) *)
  factCoeffs = Table[
    If[i == 0, 1, factCoeff[kval, i]],
    {i, 0, kval}
  ];

  Print["  Chebyshev: ", chebCoeffs];
  Print["  Factorial: ", factCoeffs];
  Print["  Match: ", chebCoeffs == factCoeffs];
  Print[];
, {kval, 1, 5}];

Print["Step 4: Look for pattern in ratios"];
Print["===================================\n"];

Print["For k=3, analyze factorial coefficient structure:\n"];
k=3;
Do[
  num = Factorial[k+i];
  den = Factorial[k-i] * Factorial[2*i];
  power = 2^(i-1);

  Print["i=", i, ":"];
  Print["  Numerator: (", k+i, ")! = ", num];
  Print["  Denominator: (", k-i, ")! * (", 2*i, ")! = ", den];
  Print["  Ratio: ", num/den];
  Print["  Power of 2: ", power];
  Print["  Final: ", power * num/den];
  Print[];
, {i, 1, k}];

Print["Step 5: Connection to binomial coefficients?"];
Print["=============================================\n"];

Print["Binomial[n,k] = n!/(k!*(n-k)!)\n"];

Print["Our form: (k+i)!/((k-i)!*(2i)!)\n"];
Print["This is NOT standard binomial...\n"];

Print["But related to: Binomial[k+i, 2i] * Binomial[2i, k-i]\n"];
Print["Check:\n"];

Do[
  our = Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);
  attempt = Binomial[k+i, 2*i] * Binomial[2*i, k-i];
  Print["  i=", i, ": our=", our, ", attempt=", attempt, ", match=", our == attempt];
, {i, 1, k}];
Print[];

Print["Step 6: Central binomial coefficients"];
Print["======================================\n"];

Print["Central binomial: Binomial[2n, n]\n"];
Print["Our denominator includes (2i)! which appears in central binomial.\n"];

Print["Let's check: (2i)! = (2i)! / (i! * i!) * i! * i!\n"];
Print["So: 1/(2i)! = Binomial[2i,i] / (i!)^2 * (constant)\n"];
Print["Hmm, not immediate...\n"];

Print["Step 7: Try generating function approach"];
Print["=========================================\n"];

Print["Standard Chebyshev generating functions:"];
Print["  Sum[T_n(x)*t^n, {n,0,inf}] = (1-x*t)/(1-2*x*t+t^2)"];
Print["  Sum[U_n(x)*t^n, {n,0,inf}] = 1/(1-2*x*t+t^2)\n"];

Print["Our form doesn't match standard generating function...\n"];

Print["Step 8: Conclusion so far"];
Print["=========================\n"];

Print["OBSERVATION: The factorial formula"];
Print["  1 + Sum[2^(i-1)*x^i*(k+i)!/((k-i)!*(2i)!), {i,1,k}]"];
Print["produces EXACTLY the coefficients of"];
Print["  T[ceil(k/2), x+1] * (U[floor(k/2), x+1] - U[floor(k/2)-1, x+1])\n"];

Print["This is a COMBINATORIAL IDENTITY connecting:"];
Print["  - Factorial/power-of-2 formula"];
Print["  - Chebyshev polynomial products\n"];

Print["Next: Search literature for this specific identity,"];
Print["or prove via induction or coefficient extraction."];
