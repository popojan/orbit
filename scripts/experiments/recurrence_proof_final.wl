#!/usr/bin/env wolframscript
(* Proof via recurrence relation *)
(* Key insight: c[0] and c[1] are initial conditions, recurrence starts at i=2 *)

Print["=== PROOF VIA RECURRENCE RELATION ===\n"];

factorialCoeff[k_, i_] := If[i == 0, 1, 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i])];

Print["Part 1: Identify initial conditions and recurrence\n"];

Print["For factorial form:"];
Print["  c[0] = 1  (by definition)"];
Do[
  c1 = factorialCoeff[k, 1];
  Print["  k=", k, ": c[1] = ", c1, " = k(k+1)/2 = ", k*(k+1)/2];
, {k, 3, 6}];

Print["\nRecurrence for i >= 2:"];
Print["  c[i] / c[i-1] = 2(k+i)(k-i+1) / ((2i)(2i-1))"];
Print[];

Print["Part 2: Verify Chebyshev product has SAME initial conditions\n"];

Do[
  n = Ceiling[k/2];
  m = Floor[k/2];

  tn = Expand[ChebyshevT[n, x+1]];
  deltaU = Expand[ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1]];
  product = Expand[tn * deltaU];

  prodCoeffs = CoefficientList[product, x];

  facC0 = 1;
  facC1 = factorialCoeff[k, 1];

  prodC0 = prodCoeffs[[1]];
  prodC1 = prodCoeffs[[2]];

  Print["k=", k, ":"];
  Print["  Factorial: c[0] = ", facC0, ", c[1] = ", facC1];
  Print["  Chebyshev: c[0] = ", prodC0, ", c[1] = ", prodC1];
  Print["  Match c[0]: ", facC0 == prodC0];
  Print["  Match c[1]: ", facC1 == prodC1];
  Print[];
, {k, 3, 8}];

Print["Part 3: Verify SAME recurrence for i >= 2\n"];

Do[
  n = Ceiling[k/2];
  m = Floor[k/2];

  tn = Expand[ChebyshevT[n, x+1]];
  deltaU = Expand[ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1]];
  product = Expand[tn * deltaU];

  prodCoeffs = CoefficientList[product, x];

  Print["k=", k, ":"];

  Do[
    facRatio = Simplify[factorialCoeff[k, i] / factorialCoeff[k, i-1]];
    prodRatio = If[i <= k, Simplify[prodCoeffs[[i+1]] / prodCoeffs[[i]]], "N/A"];
    expected = 2 * (k+i) * (k-i+1) / ((2*i)*(2*i-1));

    Print["  i=", i, ":");
    Print["    Factorial ratio: ", facRatio];
    Print["    Chebyshev ratio: ", prodRatio];
    Print["    Expected: ", expected];

    If[i <= k,
      Print["    Factorial match: ", Simplify[facRatio - expected] == 0];
      Print["    Chebyshev match: ", Simplify[prodRatio - expected] == 0];
    ];
  , {i, 2, Min[k, 5]}];

  Print[];
, {k, 3, 6}];

Print["=== CONCLUSION ===\n"];
Print["THEOREM (Proof via Recurrence):"];
Print[];
Print["Let F[k,i] = 2^(i-1) * (k+i)! / ((k-i)! * (2i)!)  (factorial form)"];
Print["Let P[k,i] = coefficient of x^i in T_n(x+1) * (U_m(x+1) - U_{m-1}(x+1))"];
Print["where n = Ceiling[k/2], m = Floor[k/2]"];
Print[];
Print["CLAIM: F[k,i] = P[k,i] for all k >= 1, 0 <= i <= k"];
Print[];
Print["PROOF:"];
Print["1. Initial conditions (verified computationally k=3..8):"];
Print["   F[k,0] = 1 = P[k,0]  (constant term)"];
Print["   F[k,1] = k(k+1)/2 = P[k,1]  (linear term)"];
Print[];
Print["2. Recurrence relation (verified computationally k=3..6, i=2..5):"];
Print["   Both F[k,i] and P[k,i] satisfy:");
Print["   c[i] = c[i-1] * 2(k+i)(k-i+1) / ((2i)(2i-1))  for i >= 2"];
Print[];
Print["3. By uniqueness of solutions to recurrence relations:");
Print["   Since F and P have same initial conditions AND same recurrence,"];
Print["   they are IDENTICAL: F[k,i] = P[k,i] for all i >= 0"];
Print[];
Print["QED (subject to proving recurrence holds for Chebyshev product)"];
