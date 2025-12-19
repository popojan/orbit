(* Find real self-intersections away from origin *)

Print["=== FINDING REAL SELF-INTERSECTIONS ===\n"];

g[t_] := -16 t Pi E / (BesselK[2 t - 1, -1/2] BesselK[2 t + 1, -1/2]);

(* Sample densely, exclude points near origin *)
samples = Table[{t, g[t] // N}, {t, -1.6, 1.6, 0.005}];
samples = Select[samples, NumericQ[#[[2]]] && Abs[#[[2]]] > 0.1 &];

Print["Samples away from origin: ", Length[samples], "\n"];

(* Find close pairs *)
Print["Searching for curve crossings (|g(t1) - g(t2)| < 0.02, |g| > 0.1)...\n"];

crossings = {};
Do[
  Do[
    If[i < j,
      {t1, g1} = samples[[i]];
      {t2, g2} = samples[[j]];
      dist = Abs[g1 - g2];
      (* Exclude oddness pairs and nearby t *)
      If[dist < 0.02 && Abs[t1 + t2] > 0.05 && Abs[t1 - t2] > 0.05,
        AppendTo[crossings, {t1, t2, g1, g2, dist}];
      ];
    ];
    , {j, Length[samples]}
  ];
  , {i, Length[samples]}
];

crossings = SortBy[crossings, #[[5]] &];

If[Length[crossings] > 0,
  Print["Found ", Length[crossings], " potential crossings:\n"];
  Do[
    {t1, t2, g1, g2, dist} = crossings[[k]];
    Print["--- Crossing ", k, " ---"];
    Print["t1 = ", t1, "  →  g = ", g1];
    Print["t2 = ", t2, "  →  g = ", g2];
    Print["|diff| = ", dist];
    Print["Re(g) ≈ ", (Re[g1] + Re[g2])/2, ", Im(g) ≈ ", (Im[g1] + Im[g2])/2];
    Print[""];
    , {k, Min[20, Length[crossings]]}
  ];
  ,
  Print["No crossings found with threshold 0.02."];
  Print["Trying larger threshold...\n"];
];

(* Try with larger threshold *)
Print["=== WITH THRESHOLD 0.1 ===\n"];
crossings2 = {};
Do[
  Do[
    If[i < j,
      {t1, g1} = samples[[i]];
      {t2, g2} = samples[[j]];
      dist = Abs[g1 - g2];
      If[dist < 0.1 && Abs[t1 + t2] > 0.1 && Abs[t1 - t2] > 0.2,
        AppendTo[crossings2, {t1, t2, g1, g2, dist}];
      ];
    ];
    , {j, Length[samples]}
  ];
  , {i, Length[samples]}
];

crossings2 = SortBy[crossings2, #[[5]] &];

If[Length[crossings2] > 0,
  Print["Found ", Length[crossings2], " candidates:\n"];
  (* Group by approximate location *)
  Do[
    {t1, t2, g1, g2, dist} = crossings2[[k]];
    midRe = (Re[g1] + Re[g2])/2;
    midIm = (Im[g1] + Im[g2])/2;
    Print["t1=", NumberForm[t1, 3], " t2=", NumberForm[t2, 3],
          " at ≈(", NumberForm[midRe, 3], ",", NumberForm[midIm, 3], ")",
          " |Δ|=", NumberForm[dist, 3]];
    , {k, Min[30, Length[crossings2]]}
  ];
];

(* Refine the best candidates *)
Print["\n=== REFINING BEST CANDIDATES ===\n"];

If[Length[crossings2] > 0,
  {t1init, t2init, g1, g2, dist} = crossings2[[1]];
  Print["Starting from t1=", t1init, ", t2=", t2init];

  (* Use FindRoot to find exact intersection *)
  result = Quiet[FindRoot[
    {Re[g[t1] - g[t2]], Im[g[t1] - g[t2]]},
    {{t1, t1init}, {t2, t2init}},
    WorkingPrecision -> 30
  ]];

  If[Head[result] === List,
    {t1exact, t2exact} = {t1, t2} /. result;
    Print["Refined: t1 = ", N[t1exact, 10], ", t2 = ", N[t2exact, 10]];
    Print["g(t1) = ", g[t1exact] // N];
    Print["g(t2) = ", g[t2exact] // N];
    Print["|g(t1) - g(t2)| = ", Abs[g[t1exact] - g[t2exact]] // N];
    ,
    Print["Refinement failed."];
  ];
];
