(* Clean spiral intersection analysis *)

Print["=== E-SPIRAL INTERSECTIONS (CLEAN ANALYSIS) ===\n"];

g[t_] := -16 t Pi E / (BesselK[2 t - 1, -1/2] BesselK[2 t + 1, -1/2]);

(* Focus on the interesting region t ∈ [-1.5, 1.5] *)
Print["=== SPIRAL TRACE (t ∈ [-1.5, 1.5]) ==="];
samples = Table[{t, g[t] // N}, {t, -1.5, 1.5, 0.1}];
Print["t\t\tRe(g)\t\tIm(g)"];
Print["-" ~StringRepeat~ 50];
Do[
  {t, gVal} = samples[[i]];
  Print[NumberForm[t, 3], "\t\t",
        NumberForm[Re[gVal], {5, 4}], "\t\t",
        NumberForm[Im[gVal], {5, 4}]];
  , {i, Length[samples]}
];

Print["\n=== X-AXIS CROSSINGS (Im = 0) ==="];
Print["g(0) = 0 (trivial, by oddness)"];
Print["Looking for non-trivial crossings..."];

(* Search for Im = 0 away from t = 0 *)
xRoots = {};
Do[
  result = Quiet[FindRoot[Im[g[t]], {t, t0}, WorkingPrecision -> 30]];
  If[ListQ[result] || Head[result] === Rule,
    tVal = t /. result;
    If[NumericQ[tVal] && Abs[tVal] > 0.1 && Abs[Im[g[tVal]]] < 10^-20,
      gVal = g[tVal] // N;
      If[Abs[Re[gVal]] > 0.001,  (* non-trivial *)
        AppendTo[xRoots, {tVal, Re[gVal]}];
      ];
    ];
  ];
  , {t0, Join[Range[-1.4, -0.2, 0.1], Range[0.2, 1.4, 0.1]]}
];
xRoots = DeleteDuplicatesBy[xRoots, Round[#[[1]], 0.01] &];
If[Length[xRoots] == 0,
  Print["No non-trivial x-axis crossings found."],
  Print["Found: ", xRoots]
];

Print["\n=== Y-AXIS CROSSINGS (Re = 0) ==="];
yRoots = {};
Do[
  result = Quiet[FindRoot[Re[g[t]], {t, t0}, WorkingPrecision -> 30]];
  If[ListQ[result] || Head[result] === Rule,
    tVal = t /. result;
    If[NumericQ[tVal] && Abs[tVal] > 0.1 && Abs[Re[g[tVal]]] < 10^-20,
      gVal = g[tVal] // N;
      If[Abs[Im[gVal]] > 0.001,  (* non-trivial *)
        AppendTo[yRoots, {tVal, Im[gVal]}];
      ];
    ];
  ];
  , {t0, Join[Range[-1.4, -0.2, 0.1], Range[0.2, 1.4, 0.1]]}
];
yRoots = DeleteDuplicatesBy[yRoots, Round[#[[1]], 0.01] &];
If[Length[yRoots] == 0,
  Print["No y-axis crossings found in search region."],
  Print["Found: ", yRoots]
];

Print["\n=== SELF-INTERSECTIONS ==="];
Print["Looking for g(t1) = g(t2) with |t1| < 1.5, |t2| < 1.5, t1 ≠ ±t2...\n"];

(* Dense sampling in interesting region *)
pts = Table[{t, g[t] // N}, {t, -1.4, 1.4, 0.02}];
pts = Select[pts, NumericQ[#[[2]]] &];

selfInt = {};
Do[
  Do[
    If[i < j,
      {t1, g1} = pts[[i]];
      {t2, g2} = pts[[j]];
      (* Skip oddness pairs and nearby points *)
      If[Abs[t1 + t2] > 0.1 && Abs[t1 - t2] > 0.1,
        dist = Abs[g1 - g2];
        (* Self-intersection if very close *)
        If[dist < 0.01 && Abs[g1] > 0.1,  (* away from origin *)
          AppendTo[selfInt, {t1, t2, g1, dist}];
        ];
      ];
    ];
    , {j, Length[pts]}
  ];
  , {i, Length[pts]}
];

If[Length[selfInt] == 0,
  Print["No self-intersections found (spiral doesn't cross itself)."],
  Print["Found ", Length[selfInt], " potential self-intersections:"];
  Do[Print[s], {s, Take[selfInt, Min[5, Length[selfInt]]]}];
];

Print["\n=== SPECIAL POINTS ==="];
Print["Series terms (t = 3/4 + n, all REAL):"];
Table[
  t = 3/4 + n;
  gVal = g[t];
  Print["g(", t, ") = ", N[gVal, 15]];
  , {n, 0, 3}
];

Print["\n=== SPIRAL BOUNDS ==="];
(* Find max |g| in interesting region *)
maxAbs = 0; maxT = 0;
Do[
  gVal = g[t] // N;
  If[NumericQ[gVal] && Abs[gVal] > maxAbs,
    maxAbs = Abs[gVal];
    maxT = t;
  ];
  , {t, -1.5, 1.5, 0.01}
];
Print["Max |g(t)| ≈ ", maxAbs, " at t ≈ ", maxT];
Print["g(", maxT, ") = ", g[maxT] // N];
