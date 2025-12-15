(* Kolmogorov Complexity Analysis: Orbit vs Direct Encoding *)
(* Question: Can orbit encoding save ANY bits compared to direct (p,q)? *)

(* ===== SETUP ===== *)

(* 2-adic valuation *)
nu2[n_Integer] := IntegerExponent[n, 2]

(* Orbit signature {A, B} where A = odd(p), B = odd(q-p) *)
signature[frac_Rational] := Module[{p, q, diff},
  p = Numerator[frac];
  q = Denominator[frac];
  diff = q - p;
  Sort[{p/2^nu2[p], diff/2^nu2[diff]}]
]

(* Canonical representative A/(A+B) *)
canonical[frac_Rational] := Module[{sig},
  sig = signature[frac];
  sig[[1]] / (sig[[1]] + sig[[2]])
]

(* The involutions *)
sigma[x_] := (1 - x)/(1 + x)
kappa[x_] := 1 - x

(* BFS to find path length from canonical to target *)
(* Using Catch/Throw for proper early return *)
pathLength[target_Rational] := Catch[Module[{can, visited, queue, newQueue, level, x, sx, kx},
  can = canonical[target];
  If[can === target, Throw[0]];

  (* BFS *)
  visited = <|can -> 0|>;
  queue = {can};

  Do[
    newQueue = {};
    Do[
      sx = sigma[x] // Together;
      kx = kappa[x] // Together;
      If[Head[sx] === Rational && 0 < sx < 1 && !KeyExistsQ[visited, sx],
        AppendTo[newQueue, sx]; visited[sx] = level];
      If[Head[kx] === Rational && 0 < kx < 1 && !KeyExistsQ[visited, kx],
        AppendTo[newQueue, kx]; visited[kx] = level],
      {x, queue}
    ];
    queue = newQueue;
    If[KeyExistsQ[visited, target], Throw[visited[target]]];
    If[queue === {}, Throw[-1]],
    {level, 1, 30}
  ];
  Throw[-1]
]]

(* ===== ANALYSIS ===== *)

(* For fraction p/q, compute:
   - alpha = nu2(p)
   - beta = nu2(q-p)
   - path = BFS distance from canonical
   - diff = path - (alpha + beta)
   If diff < 0, orbit encoding wins
*)

analyze[frac_Rational] := Module[{p, q, alpha, beta, path, diff},
  p = Numerator[frac];
  q = Denominator[frac];
  alpha = nu2[p];
  beta = nu2[q - p];
  path = pathLength[frac];
  diff = If[path >= 0, path - (alpha + beta), Missing[]];
  <|
    "fraction" -> frac,
    "alpha" -> alpha,
    "beta" -> beta,
    "alpha+beta" -> alpha + beta,
    "path" -> path,
    "diff" -> diff,
    "winner" -> If[NumericQ[diff],
      If[diff < 0, "orbit", If[diff > 0, "direct", "tie"]],
      "unknown"
    ]
  |>
]

(* Quick test *)
Print["Quick test: analyze[2/3] = ", analyze[2/3]];
Print[""];

(* Test on Farey sequence fractions *)
Print["=== Kolmogorov Complexity: Orbit vs Direct Encoding ===\n"];

(* Sample: Farey(30) minus 0, 1 *)
fractions = Select[FareySequence[30], 0 < # < 1 &];
Print["Testing ", Length[fractions], " fractions from Farey(30)...\n"];

(* Filter to non-canonical fractions (where comparison makes sense) *)
nonCanonical = Select[fractions, # =!= canonical[#] &];
Print["Non-canonical fractions: ", Length[nonCanonical], "\n"];

(* Analyze each *)
results = analyze /@ nonCanonical;

(* Filter successful analyses *)
valid = Select[results, NumericQ[#["diff"]] &];
Print["Valid results: ", Length[valid], "\n"];

If[Length[valid] == 0,
  Print["ERROR: No valid results. Debugging needed."];
  Quit[];
];

(* Summary statistics *)
diffs = #["diff"] & /@ valid;
Print["=== RESULTS ==="];
Print["Mean diff (path - (α+β)): ", N[Mean[diffs], 4]];
Print["Median diff: ", Median[diffs]];
Print["Min diff: ", Min[diffs]];
Print["Max diff: ", Max[diffs]];
Print[""];

wins = Select[valid, #["winner"] === "orbit" &];
ties = Select[valid, #["winner"] === "tie" &];
losses = Select[valid, #["winner"] === "direct" &];

Print["Orbit wins: ", Length[wins], " (", N[100 Length[wins]/Length[valid], 3], "%)"];
Print["Ties: ", Length[ties], " (", N[100 Length[ties]/Length[valid], 3], "%)"];
Print["Direct wins: ", Length[losses], " (", N[100 Length[losses]/Length[valid], 3], "%)"];
Print[""];

(* Show some orbit wins if any *)
If[Length[wins] > 0,
  Print["=== ORBIT WINS (savings!) ==="];
  Do[
    Print[w["fraction"], ": path=", w["path"], ", α+β=", w["alpha+beta"],
      " → saves ", -w["diff"], " bits"],
    {w, Take[SortBy[wins, #["diff"] &], Min[10, Length[wins]]]}
  ];
  Print[""];
];

(* Show some direct wins *)
If[Length[losses] > 0,
  Print["=== DIRECT WINS (orbit worse) ==="];
  Do[
    Print[l["fraction"], ": path=", l["path"], ", α+β=", l["alpha+beta"],
      " → costs ", l["diff"], " extra bits"],
    {l, Take[SortBy[losses, -#["diff"] &], 5]}
  ];
  Print[""];
];

(* Final verdict *)
Print["=== VERDICT ==="];
If[Length[wins] > 0,
  Print["Orbit encoding CAN beat direct encoding in ", Length[wins],
    " cases out of ", Length[valid], " (", N[100 Length[wins]/Length[valid], 3], "%)"];
  Print["Maximum savings: ", -Min[diffs], " bits"];
  Print["Average diff: ", If[Mean[diffs] > 0, "+", ""], N[Mean[diffs], 3], " bits"];
  Print[""];
  If[Mean[diffs] < 0,
    Print["CONCLUSION: Orbit encoding is ON AVERAGE BETTER!"];
    Print["This is an UNEXPECTED finding - small but real improvement exists."],
    Print["CONCLUSION: Orbit encoding wins sometimes but loses on average."];
    Print["No general Kolmogorov advantage."]
  ],
  Print["Orbit encoding NEVER beats direct encoding in this sample."];
  Print["Direct encoding is universally better or equal."]
];
