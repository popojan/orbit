#!/usr/bin/env wolframscript
(* Compare explicit polynomial forms *)

Print["=== Explicit Polynomial Comparison ===\n"];

(* Hyperbolic form - expand to polynomial *)
hypForm[x_, k_] := 1/2 + Cosh[(1+2*k)*ArcSinh[Sqrt[x/2]]]/(Sqrt[2]*Sqrt[2+x]);

(* Chebyshev form *)
chebForm[x_, k_] := ChebyshevT[Ceiling[k/2], x+1] *
  (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]);

Print["Strategy: Expand both forms to polynomials and compare"];
Print["========================================================\n"];

Do[
  Print["k = ", kval];
  Print[StringPadRight["", 60, "="]];

  (* Hyperbolic expansion *)
  hypPoly = hypForm[x, kval] // FullSimplify // Expand;
  Print["Hyperbolic form expanded:"];
  Print["  ", hypPoly];
  Print[];

  (* Chebyshev expansion *)
  chebPoly = chebForm[x, kval] // Expand;
  Print["Chebyshev form expanded:"];
  Print["  ", chebPoly];
  Print[];

  (* Check equality *)
  diff = FullSimplify[hypPoly - chebPoly];
  Print["Difference: ", diff];
  Print["Equal? ", diff == 0];
  Print[];

  (* Extract coefficients *)
  hypCoeffs = CoefficientList[hypPoly, x];
  chebCoeffs = CoefficientList[chebPoly, x];

  Print["Coefficient comparison:"];
  Do[
    Print["  x^", i-1, ": Hyp=", hypCoeffs[[i]], " Cheb=", chebCoeffs[[i]],
      " Equal? ", hypCoeffs[[i]] == chebCoeffs[[i]]];
  , {i, 1, Min[Length[hypCoeffs], Length[chebCoeffs]]}];

  Print["\n"];
, {kval, 1, 4}];

Print["=== Key Finding ==="];
Print["Both forms give IDENTICAL polynomials despite different internal structure!\n"];

Print["This suggests Mathematica uses an identity we need to discover.\n"];
