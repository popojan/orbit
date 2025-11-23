#!/usr/bin/env wolframscript
(* Test GammaPalindromicSqrt reciprocal property *)

<< Orbit`

Print["Testing GammaPalindromicSqrt reciprocity...\n"];

testGamma[nn_, n_] := Module[{gn, ginv, prod},
  gn = GammaPalindromicSqrt[nn, n, 5];
  ginv = GammaPalindromicSqrt[n, nn, 5];  (* Swap nn and n for reciprocal *)
  prod = gn * ginv;
  {N[gn, 8], N[ginv, 8], N[prod, 8]}
];

Print["Testing GammaPalindromicSqrt reciprocity:"];
Print["nn\tn\tG(nn,n)\t\t\tG(n,nn)\t\t\tProduct"];
Print[StringRepeat["-", 80]];

tests = {{4, 2}, {9, 3}, {25, 5}, {2, 4}, {3, 9}, {5, 25}};

Do[
  {nn, n} = tests[[i]];
  {gn, ginv, prod} = testGamma[nn, n];
  Print[nn, "\t", n, "\t", gn, "\t\t", ginv, "\t\t", prod];
, {i, 1, Length[tests]}];

Print["\nDONE!"];
