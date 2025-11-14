#!/usr/bin/env wolframscript
(* Debug tracking for small example *)

(* Track for p=3, m=100 to see what's happening *)
kMax = 49;  (* (100-1)/2 *)
p = 3;

Print["Computing partial sums for k=1 to ", kMax, "..."];
Print[];

data = Table[
  Module[{partialSum, num, den, nuD, nuN, diff},
    partialSum = 1/2 * Sum[(-1)^j * j! / (2j+1), {j, 1, k}];
    num = Numerator[partialSum];
    den = Denominator[partialSum];
    nuD = IntegerExponent[den, p];
    nuN = IntegerExponent[num, p];
    diff = nuD - nuN;
    {k, 2*k+1, nuD, nuN, diff}
  ],
  {k, 1, Min[20, kMax]}  (* Just first 20 terms for debugging *)
];

Print["k\t2k+1\tν_p(D)\tν_p(N)\tDiff"];
Print[StringRiffle[#, "\t"] & /@ data];
Print[];

(* Check which k have 2k+1 divisible by 3 *)
Print["Terms where 3 | (2k+1):"];
divisibleBy3 = Select[data, Divisible[#[[2]], 3] &];
Print[StringRiffle[#, "\t"] & /@ divisibleBy3];
Print[];

(* Check which k have 2k+1 = 3^j *)
Print["Terms where 2k+1 is a power of 3:"];
powers = Select[data, Module[{val = #[[2]]},
  val > 1 && IntegerExponent[val, 3] == Log[3, val]
] &];
Print[If[Length[powers] > 0, StringRiffle[#, "\t"] & /@ powers, "None in this range"]];
