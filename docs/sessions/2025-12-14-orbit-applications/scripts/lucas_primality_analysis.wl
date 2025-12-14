(* Lucas Primality Indicator Analysis
   Explores whether golden ratio structure can detect Lucas primes
   Date: 2025-12-14 *)

(* Key constants *)
invPhi = N[(Sqrt[5] - 1)/2, 30];  (* 1/phi = 0.618... *)
phi = N[(1 + Sqrt[5])/2, 30];      (* phi = 1.618... *)

(* Find optimal Fibonacci k for a given Lucas L_m *)
findOptimalK[m_, maxK_:80] := Module[{lm, bestK, bestDist, fk, n, frac, dist},
  lm = LucasL[m];
  bestK = 1; bestDist = Infinity;
  Do[
    fk = Fibonacci[k];
    n = fk * lm;
    If[n > 0,
      frac = FractionalPart[3*Sqrt[N[n, 30]]];
      dist = Min[Abs[frac - invPhi], Abs[1 - frac - invPhi]];
      If[dist < bestDist, bestDist = dist; bestK = k]
    ],
    {k, 1, maxK}
  ];
  {bestK, bestDist}
];

(* Combined metric: best separator found *)
combinedMetric[m_] := Module[{res, k, dist, n, f1, f2},
  res = findOptimalK[m];
  k = res[[1]];
  dist = res[[2]];
  n = Fibonacci[k] * LucasL[m];
  f1 = dist * N[n]^0.1;
  f2 = N[Abs[k/m - phi]];
  f1 / (1 + f2)
];

(* Analyze all Lucas numbers *)
analyzeAll[maxM_:60] := Module[{results},
  results = Table[
    Module[{lm, res, k, dist, n, score},
      lm = LucasL[m];
      res = findOptimalK[m];
      k = res[[1]];
      dist = res[[2]];
      n = Fibonacci[k] * lm;
      score = combinedMetric[m];
      <|"m" -> m, "Lm" -> lm, "prime" -> PrimeQ[lm],
        "bestK" -> k, "dist" -> dist, "score" -> score|>
    ],
    {m, 2, maxM}
  ];
  results
];

(* Summary statistics *)
summarize[results_] := Module[{primes, comps},
  primes = Select[results, #["prime"] &];
  comps = Select[results, Not[#["prime"]] &];
  Print["PRIME Lucas numbers: ", Length[primes]];
  Print["  Mean score: ", N[Mean[primes[[All, "score"]]], 4]];
  Print["COMPOSITE Lucas numbers: ", Length[comps]];
  Print["  Mean score: ", N[Mean[comps[[All, "score"]]], 4]];
  Print["Ratio (comp/prime): ", N[Mean[comps[[All, "score"]]]/Mean[primes[[All, "score"]]], 3]];
];

(* Example usage *)
If[$ScriptCommandLine =!= {},
  Print["Lucas Primality Indicator Analysis"];
  Print["====================================="];
  Print[""];
  results = analyzeAll[60];
  summarize[results];
  Print[""];
  Print["Top 10 by score (most prime-like):"];
  sorted = SortBy[results, #["score"] &];
  Do[
    r = sorted[[i]];
    Print[i, ". L_", r["m"], " = ", r["Lm"],
      If[r["prime"], " PRIME", " comp"],
      "  score=", NumberForm[r["score"], {5,4}]],
    {i, 1, 10}
  ];
];
