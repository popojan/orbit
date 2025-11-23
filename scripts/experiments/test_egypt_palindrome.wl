#!/usr/bin/env wolframscript
(* Test if Egypt sum has palindromic coefficients *)

<< Orbit`

Print["Testing Egypt palindrome structure...\n"];

(* Get coefficients of Egypt sum as polynomial *)
testEgyptCoeffs[k_] := Module[{sum, expanded, coeffs},
  sum = Sum[FactorialTerm[x, j], {j, 1, k}];
  expanded = Together[sum];  (* Combine fractions *)
  Print["Egypt sum (k=", k, "):"];
  Print["  ", expanded];
  Print[];

  (* Extract numerator and denominator *)
  num = Numerator[expanded];
  den = Denominator[expanded];

  Print["Numerator coefficients:"];
  numCoeffs = CoefficientList[num, x];
  Print["  ", numCoeffs];
  Print["  Reversed: ", Reverse[numCoeffs]];
  Print["  Palindrome? ", numCoeffs == Reverse[numCoeffs]];
  Print[];

  Print["Denominator coefficients:"];
  denCoeffs = CoefficientList[den, x];
  Print["  ", denCoeffs];
  Print["  Reversed: ", Reverse[denCoeffs]];
  Print["  Palindrome? ", denCoeffs == Reverse[denCoeffs]];
  Print[];
];

(* Test for k=1 to 5 *)
Do[
  testEgyptCoeffs[k];
  Print[StringRepeat["=", 70]];
  Print[];
, {k, 1, 5}];

Print["DONE!"];
