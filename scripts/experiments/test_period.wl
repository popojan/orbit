#!/usr/bin/env wolframscript
(* Verify the period for n=24 *)

a = 2 + Sqrt[2] + Sqrt[3] + Sqrt[6];  (* Cot[π/48] *)

Print["Testing AlgebraicCirclePoint period for a = ", a];
Print[""];

(* The construction *)
AlgebraicCirclePoint[k_] := Module[{z},
  z = (a - I)^(4*k) / (1 + a^2)^(2*k);
  {Re[z], Im[z]}
];

(* Get starting point *)
p0 = AlgebraicCirclePoint[0];
Print["Point[0] = ", N[p0, 5]];

(* Test different k values *)
Print[""];
Print["Testing which k gives return to start:"];

Do[
  pk = AlgebraicCirclePoint[k];
  dist = Norm[pk - p0];
  If[dist < 10^-10,
    Print["k = ", k, ": MATCHES! Distance = ", dist];
  ,
    If[k <= 15 || Mod[k, 5] == 0,
      Print["k = ", k, ": Distance = ", N[dist, 5]];
    ];
  ];
, {k, 1, 30}];

Print[""];
Print["Detailed check around k=12 and k=24:"];
Print["Point[12] = ", N[AlgebraicCirclePoint[12], 5]];
Print["Point[24] = ", N[AlgebraicCirclePoint[24], 5]];
Print[""];
Print["Distance[0, 12] = ", N[Norm[AlgebraicCirclePoint[12] - p0], 10]];
Print["Distance[0, 24] = ", N[Norm[AlgebraicCirclePoint[24] - p0], 10]];

Print[""];
Print["Check if it's the same point (exact comparison):"];
Print["Simplify[Point[12] == Point[0]]: ", Simplify[AlgebraicCirclePoint[12] == AlgebraicCirclePoint[0]]];
Print["Simplify[Point[24] == Point[0]]: ", Simplify[AlgebraicCirclePoint[24] == AlgebraicCirclePoint[0]]];
