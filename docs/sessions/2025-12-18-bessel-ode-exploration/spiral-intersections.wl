(* Spiral intersections analysis *)

Print["=== E-SPIRAL INTERSECTIONS ===\n"];

(* The spiral function g(t) *)
g[t_] := -16 t Pi E / (BesselK[2 t - 1, -1/2] BesselK[2 t + 1, -1/2]);

(* Properties *)
Print["g(t) = -16πe·t / [K_{2t-1}(-1/2) · K_{2t+1}(-1/2)]"];
Print["Odd symmetry: g(-t) = -g(t)\n"];

(* Sample the spiral *)
Print["=== SPIRAL VALUES ==="];
Table[
  val = N[g[t], 10];
  Print["g(", t, ") = ", val, " = ", Re[val], " + ", Im[val], " i"];
  , {t, {-2, -1, -1/2, 0, 1/2, 1, 3/2, 2, 5/2, 3}}
];

Print["\n=== X-AXIS CROSSINGS (Im(g) = 0) ==="];
Print["By oddness, g(0) = 0 is on x-axis."];
Print["Looking for other crossings...\n"];

(* Find where Im(g(t)) = 0 *)
xCrossings = {};
Table[
  sol = Quiet[FindRoot[Im[g[t]], {t, t0}, WorkingPrecision -> 20]];
  If[Head[sol] === Rule,
    tVal = t /. sol;
    If[Abs[Im[g[tVal]]] < 10^-15 && Abs[tVal] > 0.01,
      AppendTo[xCrossings, tVal];
      gVal = g[tVal];
      Print["t = ", N[tVal, 10], ": g(t) = ", N[Re[gVal], 10], " (on x-axis)"];
    ];
  ];
  , {t0, Range[-3, 3, 0.3]}
];

Print["\n=== Y-AXIS CROSSINGS (Re(g) = 0) ==="];
Print["Looking for where Re(g(t)) = 0...\n"];

yCrossings = {};
Table[
  sol = Quiet[FindRoot[Re[g[t]], {t, t0}, WorkingPrecision -> 20]];
  If[Head[sol] === Rule,
    tVal = t /. sol;
    If[Abs[Re[g[tVal]]] < 10^-15 && Abs[tVal] > 0.01,
      AppendTo[yCrossings, tVal];
      gVal = g[tVal];
      Print["t = ", N[tVal, 10], ": g(t) = ", N[Im[gVal], 10], " i (on y-axis)"];
    ];
  ];
  , {t0, Range[-3, 3, 0.3]}
];

Print["\n=== SELF-INTERSECTIONS ==="];
Print["Looking for t1 ≠ t2 where g(t1) = g(t2)...\n"];

(* Sample many points and look for near-collisions *)
samples = Table[{t, g[t] // N}, {t, -3, 3, 0.05}];
samples = Select[samples, NumericQ[#[[2]]] &];

selfIntersections = {};
Do[
  Do[
    If[i < j,
      {t1, g1} = samples[[i]];
      {t2, g2} = samples[[j]];
      dist = Abs[g1 - g2];
      (* Skip if t1 ≈ -t2 (oddness) or t1 ≈ t2 *)
      If[dist < 0.1 && Abs[t1 + t2] > 0.2 && Abs[t1 - t2] > 0.2,
        Print["Potential: t1=", t1, ", t2=", t2, ", |g1-g2|=", dist];
        AppendTo[selfIntersections, {t1, t2, dist}];
      ];
    ];
    , {j, Length[samples]}
  ];
  , {i, Length[samples]}
];

If[Length[selfIntersections] == 0,
  Print["No self-intersections found (excluding oddness pairs)."],
  Print["Found ", Length[selfIntersections], " potential self-intersections."]
];

Print["\n=== SPECIAL POINTS ==="];
Print["Series sample points t = 3/4 + n:"];
Table[
  t = 3/4 + n;
  gVal = g[t] // N;
  Print["g(", t, ") = ", gVal, " (real: term in e series)"];
  , {n, 0, 4}
];
