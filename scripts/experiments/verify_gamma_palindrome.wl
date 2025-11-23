#!/usr/bin/env wolframscript
(* Verify palindromic structure in Gamma weights *)

Print["=== GAMMA PALINDROME VERIFICATION ===\n"];

Print["Weight structure:"];
Print["  w[i] = n^(2-2i+2*Ceiling[k/2]) * nn^i / (Gamma[-1+2i] * Gamma[4-2i+k])\n"];

(* Test for specific k *)
k = 5;
lim = 1 + 1/2 (1 - (-1)^k) + Floor[k/2];

Print["For k = ", k, ", limit = ", lim, "\n"];

Print["Table of Gamma arguments and their sum:"];
Print["i\tGamma_1\t\tGamma_2\t\tSum"];
Print["-------------------------------------------"];

gammaArgs = Table[
  {i, -1 + 2*i, 4 - 2*i + k, (-1 + 2*i) + (4 - 2*i + k)},
  {i, 1, lim}
];

Do[
  Print[row[[1]], "\t", row[[2]], "\t\t", row[[3]], "\t\t", row[[4]]];
, {row, gammaArgs}];

Print["\nOBSERVATION: Sum is constant = ", 3+k];
Print["This is Beta function property: B(a,b) = Gamma[a]*Gamma[b]/Gamma[a+b]\n"];

Print["=== PALINDROME CHECK ===\n"];

Print["Comparing i with (limit+1-i):"];
Print["i\t(lim+1-i)\tGamma_1[i]\tGamma_2[i]\tGamma_1[j]\tGamma_2[j]\tSwap?"];
Print["-------------------------------------------------------------------------------"];

Do[
  i1 = i;
  i2 = lim + 1 - i;

  g1_i = -1 + 2*i1;
  g2_i = 4 - 2*i1 + k;

  g1_j = -1 + 2*i2;
  g2_j = 4 - 2*i2 + k;

  swap = (g1_i == g2_j) && (g2_i == g1_j);

  Print[i1, "\t", i2, "\t\t", g1_i, "\t\t", g2_i, "\t\t", g1_j, "\t\t", g2_j, "\t\t", swap];

, {i, 1, Floor[lim/2]}];

Print["\n=== WEIGHT VALUES ===\n"];

(* Compute actual weights *)
nn = 7; n = 2;

weights = Table[
  (n^(2 - 2*i + 2*Ceiling[k/2]) * nn^i) / (Gamma[-1 + 2*i] * Gamma[4 - 2*i + k]),
  {i, 1, lim}
];

Print["For nn=", nn, ", n=", n, ", k=", k, ":"];
Print["i\tw[i]"];
Print["------------------------------"];
Do[
  Print[i, "\t", N[weights[[i]], 8]];
, {i, 1, lim}];

Print["\n=== PALINDROME IN WEIGHTS? ===\n"];

Print["Comparing w[i] with w[limit+1-i]:"];
Print["i\tw[i]\t\t\tw[lim+1-i]\t\tRatio"];
Print["---------------------------------------------------------------"];

Do[
  i1 = i;
  i2 = lim + 1 - i;

  If[i1 <= i2,
    ratio = N[weights[[i1]] / weights[[i2]], 6];
    Print[i1, "\t", N[weights[[i1]], 8], "\t", N[weights[[i2]], 8], "\t", ratio];
  ];
, {i, 1, lim}];

Print["\n=== EXPLANATION ===\n"];

Print["Weights are NOT exactly palindromic because of n^(2-2i) factor"];
Print["But Gamma parts ARE palindromic due to Beta symmetry!\n"];

Print["Gamma contribution at i and (lim+1-i):"];
Print["  Gamma[a_i] * Gamma[b_i] where a_i + b_i = const"];
Print["  Gamma[a_j] * Gamma[b_j] where a_j + b_j = const"];
Print["  With a_i = b_j and b_i = a_j  (swap!)"];
Print["  Therefore: Gamma[a_i]*Gamma[b_i] = Gamma[b_j]*Gamma[a_j] by commutativity\n"];

Print["The RATIO of weights w[i]/w[j] depends on n^(2-2i)*nn^i / (n^(2-2j)*nn^j)"];
Print["This creates approximate palindrome when n ~ nn ~ sqrt[target]\n"];

Print["=== CONCLUSION ===\n"];

Print["Palindromic structure in Gamma arguments creates SYMMETRIC weight pattern"];
Print["Exact palindrome: NO (due to n/nn power factors)"];
Print["Symmetric structure: YES (due to Beta function B(a,b)=B(b,a))"];
Print["This symmetry is KEY to convergence properties of sqrt approximation"];
