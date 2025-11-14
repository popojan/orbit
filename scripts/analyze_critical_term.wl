#!/usr/bin/env wolframscript
(* Analyze the critical term at i=(p-1)/2 *)

Print["Analysis of the Critical Term at i=(p-1)/2\n"];
Print[StringRepeat["=", 70], "\n"];

AnalyzeCriticalTerm[n_] := Module[{p, q, m, i0, term, poch1, poch2, product,
                                     denom, num, D, termNum, halfFact, halfFactSq},
  {p, q} = FactorInteger[n][[All, 1]];
  m = Floor[(Sqrt[n] - 1)/2];
  i0 = (p-1)/2;

  Print["n = ", n, " = ", p, " × ", q];
  Print["m = ", m, " (summation runs i=1 to ", m, ")"];
  Print["p = ", p, " → critical index i₀ = (p-1)/2 = ", i0];
  Print["At i=i₀: 2i+1 = ", 2*i0+1, " = p\n"];

  (* Compute the critical term *)
  poch1 = Pochhammer[1-n, i0];
  poch2 = Pochhammer[1+n, i0];
  product = poch1 * poch2;
  denom = 2*i0 + 1;

  Print["Critical term (before sign):"];
  Print["  Poch(1-n, i₀) = Poch(", 1-n, ", ", i0, ") = ", poch1];
  Print["  Poch(1+n, i₀) = Poch(", 1+n, ", ", i0, ") = ", poch2];
  Print["  Product = ", product];
  Print["  Denominator = 2i₀+1 = ", denom, "\n"];

  (* Analyze modulo p *)
  halfFact = Factorial[i0];
  halfFactSq = halfFact^2;

  Print["Connection to Wilson's theorem:"];
  Print["  ((p-1)/2)! = ", halfFact];
  Print["  ((p-1)/2)!² = ", halfFactSq];
  Print["  Poch(1-n,i₀)·Poch(1+n,i₀) ≡ ((p-1)/2)!² (mod p)? ",
        Mod[product, p] == Mod[halfFactSq, p]];
  Print["  Both mod p = ", Mod[product, p], "\n"];

  (* Wilson: (p-1)! ≡ -1 (mod p) *)
  factPm1 = Factorial[p-1];
  Print["  (p-1)! = ", factPm1];
  Print["  (p-1)! mod p = ", Mod[factPm1, p], " (should be ", Mod[-1, p], " by Wilson)"];
  Print["  (p-1)! = ((p-1)/2)! · [(p+1)/2···(p-1)]"];
  Print["           = ((p-1)/2)! · (-1)^((p-1)/2) · ((p-1)/2)!"];
  Print["           = (-1)^((p-1)/2) · ((p-1)/2)!²\n"];

  sign = (-1)^i0;
  Print["  Therefore: ((p-1)/2)!² ≡ (-1) / (-1)^((p-1)/2) = (-1)^(1-(p-1)/2) (mod p)"];
  Print["                        ≡ (-1)^((p+1)/2) (mod p)"];
  Print["                        ≡ ", Mod[(-1)^((p+1)/2), p], " (mod p)\n"];

  (* Now compute contribution to numerator *)
  Print["Contribution to sum (with alternating sign):"];
  Print["  Sign: (-1)^i₀ = (-1)^", i0, " = ", sign];
  Print["  Term = (-1)^i₀ · Poch(...)·Poch(...) / p"];
  Print["       = ", sign, " · ", product, " / ", p];
  termNum = sign * product;
  Print["       = ", termNum, " / ", p, "\n"];

  (* Analyze the full sum's numerator *)
  sum = Sum[(-1)^i * Pochhammer[1-n, i] * Pochhammer[1+n, i] / (2*i+1), {i, 1, m}];
  num = Numerator[sum];
  D = Denominator[sum];

  Print["Full unreduced sum:"];
  Print["  Numerator N = ", num];
  Print["  Denominator D = ", D];
  Print["  N mod p = ", Mod[num, p], " (should equal p-1 = ", p-1, ")"];
  Print["  D mod p = ", Mod[D, p], " (should equal 0 since p|D)\n"];

  (* Key insight: all other terms contribute 0 mod p *)
  Print["KEY INSIGHT:"];
  Print["  When computing N with common denominator D:"];
  Print["  N = Σ [(-1)^i · Poch(...)·Poch(...) · D/(2i+1)]"];
  Print["  For i≠i₀: D/(2i+1) ≡ 0 (mod p) [since p|D and gcd(2i+1,p)=1]"];
  Print["  For i=i₀: D/p has no factor of p"];
  Print["  So: N ≡ (-1)^i₀ · ((p-1)/2)!² · (D/p) (mod p)"];
  Print["        ≡ ", sign, " · ", Mod[halfFactSq, p], " · (D/p) (mod p)"];
  Print["        ≡ ", sign * Mod[halfFactSq, p], " · (D/p) (mod p)\n"];

  (* Compute D/p *)
  If[Divisible[D, p],
    Print["  D/p = ", D/p];
    Print["  (D/p) mod p = ", Mod[D/p, p]];
    Print["  Expected: N ≡ ", Mod[num, p], " (mod p)"];
    Print["  Check: ", sign * Mod[halfFactSq, p] * Mod[D/p, p], " ≡ ",
          Mod[sign * Mod[halfFactSq, p] * Mod[D/p, p], p], " (mod p)"];
  ];

  Print["\n", StringRepeat["=", 70], "\n"];
];

(* Test several semiprimes *)
semiprimes = {15, 21, 35, 55, 77, 91};

Do[AnalyzeCriticalTerm[n], {n, semiprimes}];
