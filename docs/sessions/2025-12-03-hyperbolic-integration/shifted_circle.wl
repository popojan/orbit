(* Circle centered at (1/2, 0) with radius 1/2 *)
(* Should enclose ONLY positive poles! *)

Print["=== CIRCLE CENTERED AT (1/2, 0) ==="];
Print[""];
Print["Center: c = 1/2, Radius: r = 1/2"];
Print["Circle passes through n = 0 and n = 1"];
Print[""];

(* Check which poles are inside *)
center = 1/2;
radius = 1/2;

Print["Distance from center to poles:"];
Print[""];
Print["POSITIVE poles:"];
Do[
  pole = 1/m;
  dist = Abs[pole - center];
  inside = If[dist < radius, "INSIDE", If[dist == radius, "ON BOUNDARY", "OUTSIDE"]];
  Print["n = 1/", m, " = ", N[pole, 3], ": dist = ", N[dist, 3], " → ", inside],
  {m, 1, 6}
];

Print[""];
Print["NEGATIVE poles:"];
Do[
  pole = -1/m;
  dist = Abs[pole - center];
  inside = If[dist < radius, "INSIDE", If[dist == radius, "ON BOUNDARY", "OUTSIDE"]];
  Print["n = -1/", m, " = ", N[pole, 3], ": dist = ", N[dist, 3], " → ", inside],
  {m, 1, 6}
];

Print[""];
Print["=== PERFECT! ==="];
Print["All positive poles (except n=1 on boundary): INSIDE"];
Print["All negative poles: OUTSIDE"];
Print[""];
Print["n = 0 (cluster point): ON BOUNDARY"];

Print[""];
Print["=== CONTOUR INTEGRAL ==="];
Print[""];

beta[n_] := (n - Cot[Pi/n])/(4n)
B[n_, k_] := 1 + beta[n] * Cos[(2k - 1) Pi/n]

(* Parametrize: n = center + radius * e^{iθ} *)
(* For slightly larger radius to include n=1 *)

shiftedCircleIntegral[c_, r_, k_, s_] := Module[{},
  NIntegrate[
    ((c + r Exp[I theta])^(s-1) * B[c + r Exp[I theta], k]) * I * r * Exp[I theta],
    {theta, 0, 2 Pi},
    MaxRecursion -> 20,
    Method -> "GlobalAdaptive"
  ] / (2 Pi I)
]

Print["Testing with center=0.5, radius=0.51 (slightly larger to include n=1):"];
Print[""];

s = 1; k = 1;
ci = shiftedCircleIntegral[0.5, 0.51, k, s] // Chop;
expected = -Log[2]/(4 Pi);
Print["Contour integral / (2πi) = ", ci // N];
Print["Expected -η(1)/(4π)      = ", expected // N];
Print[""];

Print["Testing s = 2:"];
s = 2;
ci2 = shiftedCircleIntegral[0.5, 0.51, k, s] // Chop;
expected2 = -Pi/48;
Print["Contour integral / (2πi) = ", ci2 // N];
Print["Expected -η(2)/(4π)      = ", expected2 // N];
