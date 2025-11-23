#!/usr/bin/env wolframscript
(* Analyze palindromic symmetry in sqrt approximations *)

Print["=== ANALYZING GAMMA SYMMETRIES ===\n"];

(* The two distributions *)
sqrtDist[j_, i_] := (j 4^-j Gamma[2 + 2 j])/(
  Gamma[1 + 2 i j] Gamma[2 - 2 i j + 2 j]);

sqrtDistRev[j_, i_] := (j 4^-j Gamma[2 + 2 j])/(
  Gamma[1 + 2 j - 2 i j] Gamma[2 + 2 i j]);

Print["sqrtDist[j,i]:"];
Print["  Numerator: ", Hold[j 4^-j Gamma[2 + 2 j]]];
Print["  Denominator: ", Hold[Gamma[1 + 2 i j] Gamma[2 - 2 i j + 2 j]]];
Print["  = Gamma[1 + 2ij] * Gamma[2 + 2j - 2ij]"];
Print[""];

Print["sqrtDistRev[j,i]:"];
Print["  Numerator: ", Hold[j 4^-j Gamma[2 + 2 j]]];
Print["  Denominator: ", Hold[Gamma[1 + 2 j - 2 i j] Gamma[2 + 2 i j]]];
Print["  = Gamma[1 + 2j - 2ij] * Gamma[2 + 2ij]"];
Print[""];

Print["PALINDROMIC SYMMETRY:"];
Print["If we substitute i -> (1-i):"];
Print[""];

(* Check if sqrtDist[j, 1-i] = sqrtDistRev[j, i] *)
Print["Testing: sqrtDist[j, 1-i] vs sqrtDistRev[j, i]"];
Print[""];

Do[
  j = 3;
  dist1 = sqrtDist[j, 1-i];
  dist2 = sqrtDistRev[j, i];

  Print["i = ", i, ", j = ", j, ":"];
  Print["  sqrtDist[j, 1-i] = ", N[dist1, 6]];
  Print["  sqrtDistRev[j, i] = ", N[dist2, 6]];
  Print["  Match: ", Abs[dist1 - dist2] < 10^-10];
  Print[""];
, {i, {0.1, 0.2, 0.3, 0.5, 0.7}}];

Print["\n=== POLYNOMIAL SYMMETRY ===\n"];

cpoly[nn_, n_, j_, i_] := n^(2 j - 2 i j) nn^(i j);

Print["cpoly[nn, n, j, i] = n^(2j - 2ij) * nn^(ij)"];
Print["                   = n^(2j(1-i)) * nn^(ij)"];
Print[""];

Print["Testing cpoly palindrome:"];
Print["cpoly[nn, n, j, i] vs cpoly[nn, n, j, 1-i]"];
Print[""];

Do[
  nn = 2; n = 3; j = 5;
  poly1 = cpoly[nn, n, j, i];
  poly2 = cpoly[nn, n, j, 1-i];

  Print["i = ", i, ":"];
  Print["  cpoly[nn,n,j,i]   = n^", 2*j*(1-i), " * nn^", i*j, " = ", N[poly1, 6]];
  Print["  cpoly[nn,n,j,1-i] = n^", 2*j*i, " * nn^", (1-i)*j, " = ", N[poly2, 6]];
  Print["  Ratio: ", N[poly1/poly2, 6]];
  Print[""];
, {i, {0.2, 0.4, 0.5}}];

Print["\n=== EXPONENT PATTERN ===\n"];

Print["For cpoly[nn, n, j, i]:"];
Print["  Exponent of n:  2j(1-i)"];
Print["  Exponent of nn: ij"];
Print[""];

Print["For cpoly[nn, n, j, 1-i]:"];
Print["  Exponent of n:  2j*i"];
Print["  Exponent of nn: (1-i)j"];
Print[""];

Print["PALINDROME STRUCTURE:");
Print["If we swap (n ↔ nn) and (i ↔ 1-i), we get the reverse!"];
Print[""];

(* Generate table of exponents *)
Print["Exponent table for j=5:"];
Print[""];
Print["i\t| n exponent\t| nn exponent"];
Print["--------|---------------|-------------"];
Do[
  nExp = 2*5*(1-i);
  nnExp = i*5;
  Print[N[i, 2], "\t| ", nExp, "\t\t| ", nnExp];
, {i, 0, 1, 0.2}];

Print[""];
Print["Notice: exponents are palindromic around i=0.5!"];
Print["At i=0.5: n^5 * nn^2.5 (symmetric point)"];

Print["\n=== CONNECTION TO CHEBYSHEV ===\n"];

Print["These polynomials might relate to Chebyshev via:"];
Print["- Gamma functions → Beta functions → hypergeometric"];
Print["- Exponent pattern similar to tan multiplication P_n/Q_n"];
Print["- Palindromic coefficients in both contexts"];
Print[""];

Print["Testing specific values:"];
Do[
  nn = 7; n = 2; j = 3;
  val = cpoly[nn, n, j, i];
  Print["i = ", i, ": cpoly[", nn, ", ", n, ", ", j, ", ", i, "] = ", val];
, {i, 0, 1, 1/j}];
