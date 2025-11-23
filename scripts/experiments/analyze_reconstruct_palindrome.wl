#!/usr/bin/env wolframscript
(* Analyze palindromic structure in reconstruct function *)

reconstruct[nn_, n_, k_] :=
 Module[{lim = 1 + 1/2 (1 - (-1)^k) + Floor[k/2]},
  Function[w,
    nn Sum[w[[i]] (-24 + 16 i^2 (1 + k) + 4 i (1 + k) (2 + k) -
         k (24 + k (7 + k)))/(-1 + 4 i^2), {i, 1, lim}]/
     Sum[w[[i]], {i, 1, lim}]][
   Table[(n^(2 - 2 i + 2 Ceiling[k/2]) nn^i)/(
    Gamma[-1 + 2 i] Gamma[4 - 2 i + k]), {i, 1, lim}]]]

Print["=== ANALYZING RECONSTRUCT PALINDROME ===\n"];

Print["Weights have structure:"];
Print["  w[i] = n^(2-2i+2⌈k/2⌉) * nn^i / (Gamma[-1+2i] * Gamma[4-2i+k])"];
Print[""];

Print["Key observations:"];
Print["1. Exponent of n:  2 - 2i + 2⌈k/2⌉"];
Print["2. Exponent of nn: i"];
Print["3. Gamma arguments: [-1+2i] and [4-2i+k]"];
Print[""];

Print["Sum of Gamma arguments:"];
Print["  (-1+2i) + (4-2i+k) = 3+k  (CONSTANT!)"];
Print["  This is Beta function property -> symmetry!");
Print[""];

(* Test for specific k *)
k = 5;
lim = 1 + 1/2 (1 - (-1)^k) + Floor[k/2];
Print["For k = ", k, ", limit = ", lim];
Print[""];

Print["Table of exponents and Gamma arguments:"];
Print["i\t| n exp\t\t| nn exp\t| Γ arg 1\t| Γ arg 2\t| Sum"];
Print["--------|---------------|---------------|---------------|---------------|-------"];

Do[
  nExp = 2 - 2*i + 2*Ceiling[k/2];
  nnExp = i;
  gamma1 = -1 + 2*i;
  gamma2 = 4 - 2*i + k;
  sumGamma = gamma1 + gamma2;

  Print[i, "\t| ", nExp, "\t\t| ", nnExp, "\t\t| ", gamma1, "\t\t| ", gamma2, "\t\t| ", sumGamma];
, {i, 1, lim}];

Print[""];
Print["PALINDROME PATTERN:");
Print["Notice Gamma args are mirror symmetric around the constant sum!");
Print["gamma1[i] increases, gamma2[i] decreases, sum = ", 3+k];
Print[""];

(* Check actual weights *)
Print["Actual weight values (nn=7, n=2, k=5):"];
nn = 7; n = 2; k = 5;
weights = Table[(n^(2 - 2 i + 2 Ceiling[k/2]) nn^i)/(
    Gamma[-1 + 2 i] Gamma[4 - 2 i + k]), {i, 1, lim}];

Do[
  Print["w[", i, "] = ", N[weights[[i]], 6]];
, {i, 1, lim}];

Print[""];
Print["Normalized weights:"];
normalized = weights/Total[weights];
Do[
  Print["w[", i, "]/sum = ", N[normalized[[i]], 6]];
, {i, 1, lim}];

Print["\n=== CONNECTION TO CHEBYSHEV PALINDROMES ===\n"];

Print["In tan multiplication, we had:"];
Print["  P_n(x) / x coeffs: {5, -10, 1}"];
Print["  Q_n(x) coeffs:     {1, -10, 5}"];
Print["  -> Palindromic reversal"];
Print[""];

Print["In sqrt reconstruction:"];
Print["  Weights involve n^(decreasing) * nn^(increasing)"];
Print["  Gamma(increasing) * Gamma(decreasing) with constant sum"];
Print["  -> Same palindromic structure!");
Print[""];

Print["Both arise from:"];
Print["- Beta function symmetry: B(a,b) = B(b,a)"];
Print["- Γ(a)Γ(b) = Γ(a+b) * B(a,b)");
Print["- When a+b=const, swapping a<->b gives palindrome"];

Print["\n=== TESTING SYMMETRY ===\n"];

(* If we swap i -> (lim+1-i), do we get palindrome? *)
Print["Testing if weights are palindromic:");
Print["Comparing w[i] structure with w[lim+1-i]:"];
Print[""];

Do[
  i1 = i;
  i2 = lim + 1 - i;

  If[i1 <= i2,
    nExp1 = 2 - 2*i1 + 2*Ceiling[k/2];
    nnExp1 = i1;
    gamma1_1 = -1 + 2*i1;
    gamma2_1 = 4 - 2*i1 + k;

    nExp2 = 2 - 2*i2 + 2*Ceiling[k/2];
    nnExp2 = i2;
    gamma1_2 = -1 + 2*i2;
    gamma2_2 = 4 - 2*i2 + k;

    Print["i=", i1, " vs i=", i2, ":"];
    Print["  n exponents: ", nExp1, " vs ", nExp2];
    Print["  nn exponents: ", nnExp1, " vs ", nnExp2];
    Print["  Gamma args: (", gamma1_1, ",", gamma2_1, ") vs (", gamma1_2, ",", gamma2_2, ")"];
    Print["  Gamma swap: ", gamma1_1, "<->", gamma2_2, " and ", gamma2_1, "<->", gamma1_2];
    Print[""];
  ];
, {i, 1, lim}];
