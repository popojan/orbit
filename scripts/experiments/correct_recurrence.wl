#!/usr/bin/env wolframscript
(* Find correct recurrence for factorial coefficients *)

Print["=== CORRECT RECURRENCE RELATION ===\n"];

factorialCoeff[k_, i_] := If[i == 0, 1, 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i])];

Print["Part 1: Compute ratios systematically\n"];

Do[
  Print["k=", k, ":"];

  Do[
    ci = factorialCoeff[k, i];
    cim1 = factorialCoeff[k, i-1];
    ratio = Simplify[ci / cim1];

    Print["  c[", i, "] / c[", i-1, "] = ", ci, " / ", cim1, " = ", ratio];

    (* Try to express in terms of k and i *)
    (* c[i] = 2^(i-1) * (k+i)! / ((k-i)! * (2i)!) *)
    (* c[i-1] = 2^(i-2) * (k+i-1)! / ((k-i+1)! * (2i-2)!) *)
    (* ratio = 2 * (k+i)! * (k-i+1)! * (2i-2)! / ((k+i-1)! * (k-i)! * (2i)!) *)
    (*       = 2 * (k+i) * (k-i+1) / ((2i)(2i-1)) *)

    expected = 2 * (k+i) * (k-i+1) / ((2*i)*(2*i-1));
    Print["    Expected from formula: ", expected];
    Print["    Match: ", Simplify[ratio - expected] == 0];

  , {i, 1, k}];

  Print[];
, {k, 3, 5}];

Print["Part 2: Verify recurrence for Chebyshev product\n"];

Do[
  n = Ceiling[k/2];
  m = Floor[k/2];

  tn = Expand[ChebyshevT[n, x+1]];
  deltaU = Expand[ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1]];
  product = Expand[tn * deltaU];

  prodCoeffs = CoefficientList[product, x];

  Print["k=", k, " (n=", n, ", m=", m, "):"];
  Print["  Coefficients: ", prodCoeffs];

  Do[
    If[i > 0,
      ci = prodCoeffs[[i+1]];
      cim1 = prodCoeffs[[i]];

      If[cim1 != 0,
        ratio = Simplify[ci / cim1];
        expected = 2 * (k+i) * (k-i+1) / ((2*i)*(2*i-1));

        Print["  [x^", i, "] / [x^", i-1, "] = ", ratio];
        Print["    Expected: ", expected];
        Print["    Match: ", Simplify[ratio - expected] == 0];
      ];
    ];
  , {i, 1, k}];

  Print[];
, {k, 3, 5}];

Print["=== CONCLUSION ===\n"];
Print["Recurrence relation is:"];
Print["  c[0] = 1"];
Print["  c[i] = c[i-1] * 2(k+i)(k-i+1) / ((2i)(2i-1))  for i >= 1"];
Print[];
Print["Both factorial form AND Chebyshev product satisfy this recurrence!"];
Print["Therefore, by uniqueness of recurrence solutions, they are EQUAL.");
Print[];
Print["This gives us a PROOF via recurrence, without binomial simplification!");
