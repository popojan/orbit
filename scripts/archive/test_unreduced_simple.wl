#!/usr/bin/env wolframscript
(* Simple test of unreduced tracking *)

(* Compute unreduced denominator *)
UnreducedDen[k_] := 2 * Apply[LCM, Table[2*j + 1, {j, 1, k}]]

(* Compute unreduced numerator *)
UnreducedNum[k_] := Module[{D},
  D = UnreducedDen[k];
  Sum[(-1)^j * j! * (D/2) / (2*j + 1), {j, 1, k}]
]

(* Test for k=1 to 10, p=3 *)
Print["Testing unreduced tracking for p=3:"];
Print["k\t2k+1\tnu_3(D)\tnu_3(N)\tDiff"];

Do[
  Module[{D, N, nuD, nuN},
    D = UnreducedDen[k];
    N = UnreducedNum[k];
    nuD = IntegerExponent[D, 3];
    nuN = IntegerExponent[N, 3];
    Print[k, "\t", 2*k+1, "\t", nuD, "\t", nuN, "\t", nuD-nuN]
  ],
  {k, 1, 15}
];
