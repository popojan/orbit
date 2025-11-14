#!/usr/bin/env wolframscript
(* Test user's fractional part formula *)

primorial[m_] :=
  Sum[Mod[(-1)^k * (k!)/(2k + 1)/2, 1], {k, Floor[(m - 1)/2]}];

cmp[hi_] :=
  Counts[Divide @@@
    Transpose[{
      Denominator[primorial /@ Range[3, hi]],
      (Times @@ (Prime /@ Range@PrimePi@#)) & /@ Range[3, hi]
    }]
  ];

Print["Testing fractional part formula:\n"];
Print["primorial[m_] := Sum[Mod[(-1)^k * k!/(2k+1)/2, 1], {k, Floor[(m-1)/2]}]\n"];

Print["Results for m = 3 to 100:"];
Print[cmp[100]];

Print["\nResults for m = 3 to 1000:"];
Print[cmp[1000]];

Print["\nDetailed check for small m:"];
Do[
  Module[{result, prim, denom, num},
    result = primorial[m];
    prim = Times @@ (Prime /@ Range@PrimePi@m);
    denom = Denominator[result];
    num = Numerator[result];
    Print["m=", m, ": num=", num, ", denom=", denom, ", primorial=", prim,
      ", ratio=", N[denom/prim]];
  ],
  {m, 3, 21, 2}
];
