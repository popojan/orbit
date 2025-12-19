(* Check for self-intersections more carefully *)

Print["=== CHECKING SELF-INTERSECTIONS ===\n"];

g[t_] := -16 t Pi E / (BesselK[2 t - 1, -1/2] BesselK[2 t + 1, -1/2]);

(* User's observation: g(15/4) vs g(-15/4 + 3/4) = g(-3) *)
Print["User's observation:"];
Print["g(15/4) = ", g[15/4] // N];
Print["g(-3) = ", g[-3] // N];
Print["g(3) = ", g[3] // N];
Print[""];
Print["Note: g(-3) = -g(3) by oddness, so these are opposite points.\n"];

(* But maybe the user means comparing |g(t1)| = |g(t2)| for different t values? *)
(* Or perhaps actual curve crossings? *)

Print["=== LOOKING FOR ACTUAL SELF-INTERSECTIONS ==="];
Print["Need: g(t1) = g(t2) with t1 ≠ t2 and t1 ≠ -t2\n"];

(* Sample the curve densely *)
samples = Table[{t, g[t] // N}, {t, -1.5, 1.5, 0.01}];
samples = Select[samples, NumericQ[#[[2]]] &];

Print["Searching for pairs where |g(t1) - g(t2)| < 0.05 and |t1| ≠ |t2|...\n"];

candidates = {};
Do[
  Do[
    If[i < j,
      {t1, g1} = samples[[i]];
      {t2, g2} = samples[[j]];
      dist = Abs[g1 - g2];
      (* Exclude: same t, opposite t (oddness), and close t *)
      If[dist < 0.05 && Abs[t1 + t2] > 0.1 && Abs[t1 - t2] > 0.1 && Abs[Abs[t1] - Abs[t2]] > 0.05,
        AppendTo[candidates, {t1, t2, g1, g2, dist}];
      ];
    ];
    , {j, Length[samples]}
  ];
  , {i, Length[samples]}
];

If[Length[candidates] > 0,
  Print["Found ", Length[candidates], " candidate pairs:"];
  (* Sort by distance *)
  candidates = SortBy[candidates, #[[5]] &];
  Do[
    {t1, t2, g1, g2, dist} = candidates[[k]];
    Print["t1 = ", t1, ", t2 = ", t2];
    Print["  g(t1) = ", g1];
    Print["  g(t2) = ", g2];
    Print["  |diff| = ", dist, "\n"];
    , {k, Min[10, Length[candidates]]}
  ];
  ,
  Print["No candidates found in initial search."];
];

(* Extend search to larger t range *)
Print["\n=== EXTENDED SEARCH (t ∈ [-3, 3]) ===\n"];

samples2 = Table[{t, g[t] // N}, {t, -3, 3, 0.02}];
samples2 = Select[samples2, NumericQ[#[[2]]] &];

candidates2 = {};
Do[
  Do[
    If[i < j,
      {t1, g1} = samples2[[i]];
      {t2, g2} = samples2[[j]];
      dist = Abs[g1 - g2];
      If[dist < 0.02 && Abs[t1 + t2] > 0.1 && Abs[t1 - t2] > 0.2,
        AppendTo[candidates2, {t1, t2, g1, g2, dist}];
      ];
    ];
    , {j, Length[samples2]}
  ];
  , {i, Length[samples2]}
];

If[Length[candidates2] > 0,
  Print["Found ", Length[candidates2], " candidate pairs:"];
  candidates2 = SortBy[candidates2, #[[5]] &];
  Do[
    {t1, t2, g1, g2, dist} = candidates2[[k]];
    Print["t1 = ", NumberForm[t1, 4], ", t2 = ", NumberForm[t2, 4]];
    Print["  g(t1) = ", g1];
    Print["  g(t2) = ", g2];
    Print["  |diff| = ", ScientificForm[dist, 3], "\n"];
    , {k, Min[15, Length[candidates2]]}
  ];
  ,
  Print["No candidates found."];
];

(* Check the specific comparison user mentioned *)
Print["\n=== USER'S SPECIFIC COMPARISON ==="];
Print["Abs[g(15/4) - g(-12/4)]:"];
val1 = g[15/4] // N;
val2 = g[-12/4] // N;
Print["g(15/4) = ", val1];
Print["g(-12/4) = g(-3) = ", val2];
Print["|difference| = ", Abs[val1 - val2]];
Print[""];
Print["But g(-3) = -g(3), so this compares g(15/4) with -g(3)."];
Print["These are OPPOSITE points, not equal points.\n"];

(* Maybe user means comparing magnitudes? *)
Print["Comparing magnitudes:"];
Print["|g(15/4)| = ", Abs[val1]];
Print["|g(3)| = ", Abs[g[3] // N]];
