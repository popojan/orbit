#!/usr/bin/env wolframscript
(*
Understand the parity mechanism using the structure:
- Each term has numerator = 1 (mod n)
- Pair sums have numerator = 0 (mod n)
*)

Print["=" * 70];
Print["PARITY MECHANISM ANALYSIS"];
Print["=" * 70];
Print[];

term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x+1] *
(ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]))

UnderstandMechanism[n_, x_, y_] := Module[{},
Print["n = ", n, ", x = ", x];
Print["Key facts:"];
Print["  x mod n = ", Mod[x, n], " (x == -1 mod n)"];
Print["  x+1 mod n = ", Mod[x+1, n]];
Print["  Each term numerator == 1 (mod n)"];
Print["  Pair sum numerator == x+1 == 0 (mod n)"];
Print[];

Print["Build up partial sums symbolically (mod n):"];
Print[];

(* Show how S_k builds up mod n *)
Print["S_1 = 1 + term[1]"];
Print["    = 1 + (1/den_1) mod n"];
Module[{s1, num1},
s1 = 1 + term[x-1, 1];
num1 = Numerator[s1];
Print["    = ", num1, " / den_1"];
Print["    numerator mod n = ", Mod[num1, n]];
Print["    [Total = 2 (EVEN), numerator == 0 mod n]"];
];
Print[];

Print["S_2 = 1 + term[1] + term[2]"];
Print["    = S_1 + term[2]"];
Print["    = (0/den_1) + (1/den_2) mod n"];
Print["    = (0*den_2 + den_1*1)/(den_1*den_2) mod n"];
Print["    numerator == den_1 mod n"];
Module[{s1, s2, den1, num2},
s1 = 1 + term[x-1, 1];
den1 = Denominator[s1];
s2 = 1 + term[x-1, 1] + term[x-1, 2];
num2 = Numerator[s2];
Print["    = ", num2, " / ..., num mod n = ", Mod[num2, n]];
Print["    den_1 mod n = ", Mod[den1, n]];
Print["    [Total = 3 (ODD), numerator != 0 mod n]"];
];
Print[];

Print["S_3 = 1 + term[1] + term[2] + term[3]"];
Print["    = 1 + (term[1] + term[2]) + term[3]"];
Print["    = 1 + pair_sum(m=0.5) + term[3]"];
Print["    Pair sum has numerator == 0 mod n"];
Print["    So S_3 = 1 + (0/den_pair) + (1/den_3) mod n"];
Module[{s3, num3},
s3 = 1 + Sum[term[x-1, j], {j, 1, 3}];
num3 = Numerator[s3];
Print["    numerator mod n = ", Mod[num3, n]];
Print["    [Total = 4 (EVEN), numerator == 0 mod n]"];
];
Print[];

Print["Pattern:"];
Print["  EVEN total: have even number of 'unpaired' terms"];
Print["  ODD total: have odd number of 'unpaired' terms"];
Print[];

(* Check common denominators *)
Print["Denominators of S_k:"];
Do[
Module[{sk, den},
sk = 1 + Sum[term[x-1, j], {j, 1, k}];
den = Denominator[sk];
Print["k=", k, " (total=", k+1, "): den mod n = ", Mod[den, n]];
],
{k, 1, 8}
];
Print[];
];

(* Test n=13 *)
Print["=" * 70];
Print["n=13"];
Print["=" * 70];
Print[];
UnderstandMechanism[13, 649, 180];

Print["=" * 70];
