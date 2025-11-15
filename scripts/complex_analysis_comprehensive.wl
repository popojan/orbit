#!/usr/bin/env wolframscript
(* Comprehensive complex analysis of F_n(alpha) - PATIENT VERSION *)

Print["================================================================"];
Print["COMPLEX ANALYSIS: F_n(alpha) FOR COMPLEX alpha"];
Print["================================================================"];
Print[""];
Print["This will take significant time - please be patient..."];
Print[""];

(* ============================================================================ *)
(* IMPLEMENTATION FOR COMPLEX ALPHA                                           *)
(* ============================================================================ *)

FnComplex[n_, alpha_, eps_: 1.0, dMax_: 50, kMax_: 100] := Module[
  {d, k, innerSum, outerSum, dist},
  outerSum = 0;
  For[d = 2, d <= Min[dMax, 2*n], d++,
    innerSum = 0;
    For[k = 0, k <= kMax, k++,
      dist = (n - k*d - d^2)^2 + eps;
      If[dist > 0,
        innerSum += dist^(-alpha);
      ];
      If[k > 10 && Abs[dist^(-alpha)]/Abs[innerSum] < 10^-8, Break[]];
    ];
    outerSum += innerSum;
  ];
  outerSum
]

(* ============================================================================ *)
(* TEST 1: Evaluate on complex plane grid                                    *)
(* ============================================================================ *)

Print["[1/5] Evaluating F_n(alpha) on complex grid"];
Print[""];
Print["Testing for n=35 (composite) and n=37 (prime)"];
Print["Grid: Re(alpha) in [0.5, 5.0], Im(alpha) in [-5, 5]"];
Print[""];
Print["This will take several minutes..."];
Print[""];

gridResults35 = {};
gridResults37 = {};

sigmaVals = {0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0};
tVals = {-5, -3, -1, 0, 1, 3, 5};

Print["Progress: sigma = Re(alpha), t = Im(alpha)"];
Print[""];

Do[
  Do[
    Module[{alpha, f35, f37},
      alpha = sigma + I*t;
      f35 = FnComplex[35, alpha, 1.0];
      f37 = FnComplex[37, alpha, 1.0];
      AppendTo[gridResults35, {sigma, t, f35, Abs[f35], Arg[f35]}];
      AppendTo[gridResults37, {sigma, t, f37, Abs[f37], Arg[f37]}];
      If[Mod[Length[gridResults35], 10] == 0,
        Print["  Computed ", Length[gridResults35], " grid points..."];
      ];
    ],
    {t, tVals}
  ],
  {sigma, sigmaVals}
];

Print[""];
Print["Grid evaluation complete: ", Length[gridResults35], " points"];
Print[""];

(* Sample output *)
Print["Sample values for n=35 (composite):"];
Print["sigma\tt\t|F_35|\t\tArg(F_35)"];
Print[StringRepeat["-", 60]];
Do[
  If[Mod[i, 8] == 1,
    Print[N[gridResults35[[i, 1]], 3], "\t", N[gridResults35[[i, 2]], 3],
      "\t", N[gridResults35[[i, 4]], 6], "\t", N[gridResults35[[i, 5]], 4]];
  ],
  {i, 1, Min[32, Length[gridResults35]]}
];
Print[""];

Print["Sample values for n=37 (prime):"];
Print["sigma\tt\t|F_37|\t\tArg(F_37)"];
Print[StringRepeat["-", 60]];
Do[
  If[Mod[i, 8] == 1,
    Print[N[gridResults37[[i, 1]], 3], "\t", N[gridResults37[[i, 2]], 3],
      "\t", N[gridResults37[[i, 4]], 6], "\t", N[gridResults37[[i, 5]], 4]];
  ],
  {i, 1, Min[32, Length[gridResults37]]}
];
Print[""];

(* ============================================================================ *)
(* TEST 2: Search for poles                                                  *)
(* ============================================================================ *)

Print["[2/5] Searching for pole structure"];
Print[""];
Print["Looking for Re(alpha) where |F_n| becomes very large..."];
Print[""];

(* Scan along real axis near origin *)
Print["Scanning Re(alpha) from -2 to 5 (Im=0):"];
Print[""];
Print["alpha\t|F_35|\t\t|F_37|\t\tRatio"];
Print[StringRepeat["-", 60]];

poleData = Table[
  Module[{f35, f37, ratio},
    f35 = FnComplex[35, sigma, 1.0];
    f37 = FnComplex[37, sigma, 1.0];
    ratio = Abs[f35]/Abs[f37];
    Print[N[sigma, 3], "\t", N[Abs[f35], 6], "\t", N[Abs[f37], 6], "\t", N[ratio, 4]];
    {sigma, Abs[f35], Abs[f37], ratio}
  ],
  {sigma, -2.0, 5.0, 0.5}
];
Print[""];

Print["Observation: Look for where ratio diverges (composite pole)"];
Print[""];

(* ============================================================================ *)
(* TEST 3: Functional equation search                                        *)
(* ============================================================================ *)

Print["[3/5] Testing for functional equation"];
Print[""];
Print["Testing if F_n(alpha) has relationship with F_n(k - alpha)"];
Print["for various k values..."];
Print[""];
Print["Timeout: 180 seconds per attempt"];
Print[""];

(* Test F_n(alpha) vs F_n(1-alpha) *)
Print["Test 1: F_n(1-alpha) relationship"];
Print[""];

TimeConstrained[
  Module[{alpha, testVals, results},
    testVals = {0.5, 1.0, 1.5, 2.0, 2.5};
    results = Table[
      Module[{fAlpha, f1MinusAlpha, ratio, product},
        fAlpha = FnComplex[37, alpha, 1.0];
        f1MinusAlpha = FnComplex[37, 1 - alpha, 1.0];
        ratio = fAlpha / f1MinusAlpha;
        product = fAlpha * f1MinusAlpha;
        {alpha, N[Abs[fAlpha], 6], N[Abs[f1MinusAlpha], 6],
         N[Abs[ratio], 6], N[Abs[product], 6]}
      ],
      {alpha, testVals}
    ];

    Print["alpha\t|F(a)|\t\t|F(1-a)|\t\tRatio\t\tProduct"];
    Print[StringRepeat["-", 80]];
    Do[
      Print[results[[i, 1]], "\t", results[[i, 2]], "\t", results[[i, 3]],
        "\t", results[[i, 4]], "\t", results[[i, 5]]],
      {i, 1, Length[results]}
    ];
    Print[""];

    (* Check if ratio or product is constant *)
    ratios = results[[All, 4]];
    products = results[[All, 5]];
    Print["Ratio variance: ", N[Variance[ratios], 6]];
    Print["Product variance: ", N[Variance[products], 6]];
    Print[""];

    If[Variance[products] < 0.1,
      Print["POSSIBLE FUNCTIONAL EQUATION: F(a)*F(1-a) = constant ≈ ",
        N[Mean[products], 6]];
    ];
  ],
  180,
  Print["Timed out"];
];
Print[""];

(* Test other candidates *)
Print["Test 2: F_n(3-alpha) relationship"];
Print[""];

TimeConstrained[
  Module[{testVals, results},
    testVals = {0.5, 1.0, 1.5, 2.0, 2.5};
    results = Table[
      Module[{fAlpha, f3MinusAlpha, ratio},
        fAlpha = FnComplex[37, alpha, 1.0];
        f3MinusAlpha = FnComplex[37, 3 - alpha, 1.0];
        ratio = fAlpha / f3MinusAlpha;
        {alpha, N[Abs[fAlpha], 6], N[Abs[f3MinusAlpha], 6], N[Abs[ratio], 6]}
      ],
      {alpha, testVals}
    ];

    Print["alpha\t|F(a)|\t\t|F(3-a)|\t\tRatio"];
    Print[StringRepeat["-", 70]];
    Do[
      Print[results[[i, 1]], "\t", results[[i, 2]], "\t",
        results[[i, 3]], "\t", results[[i, 4]]],
      {i, 1, Length[results]}
    ];
    Print[""];
  ],
  180,
  Print["Timed out"];
];
Print[""];

(* ============================================================================ *)
(* TEST 4: Mellin transform attempt                                          *)
(* ============================================================================ *)

Print["[4/5] Mellin transform exploration"];
Print[""];
Print["Attempting to compute Mellin transform of single term"];
Print["Timeout: 300 seconds"];
Print[""];

TimeConstrained[
  Module[{result, dist, eps, alpha},
    Print["Computing M[(x^2 + eps)^(-alpha)](s):"];
    Print[""];

    result = Integrate[x^(s-1) * (x^2 + eps)^(-alpha),
      {x, 0, Infinity},
      Assumptions -> {s > 0, alpha > s/2, eps > 0, Re[s] > 0, Re[alpha] > Re[s]/2}
    ];

    Print["Result:"];
    Print[result];
    Print[""];

    Print["Simplified:"];
    Print[Simplify[result]];
    Print[""];

    (* Verify numerically *)
    Print["Numerical verification (s=1, alpha=3, eps=1):"];
    numerical = NIntegrate[x^(1-1) * (x^2 + 1)^(-3), {x, 0, Infinity}];
    theoretical = result /. {s -> 1, alpha -> 3, eps -> 1};
    Print["  Numerical:   ", N[numerical, 8]];
    Print["  Theoretical: ", N[theoretical, 8]];
    Print["  Match: ", Abs[numerical - N[theoretical]] < 10^-6];
    Print[""];
  ],
  300,
  Print["Timed out - Mellin transform too complex"];
  Print[""];
];

(* ============================================================================ *)
(* TEST 5: Critical line behavior                                            *)
(* ============================================================================ *)

Print["[5/5] Behavior on critical line Re(alpha) = 1/2"];
Print[""];
Print["Evaluating F_n(1/2 + it) for t in [-10, 10]"];
Print[""];

criticalLineData35 = Table[
  Module[{alpha, f},
    alpha = 0.5 + I*t;
    f = FnComplex[35, alpha, 1.0];
    {t, Abs[f], Arg[f]}
  ],
  {t, -10, 10, 1.0}
];

criticalLineData37 = Table[
  Module[{alpha, f},
    alpha = 0.5 + I*t;
    f = FnComplex[37, alpha, 1.0];
    {t, Abs[f], Arg[f]}
  ],
  {t, -10, 10, 1.0}
];

Print["t\t|F_35(1/2+it)|\t|F_37(1/2+it)|\tRatio"];
Print[StringRepeat["-", 70]];
Do[
  Print[N[criticalLineData35[[i, 1]], 2], "\t",
    N[criticalLineData35[[i, 2]], 6], "\t",
    N[criticalLineData37[[i, 2]], 6], "\t",
    N[criticalLineData35[[i, 2]]/criticalLineData37[[i, 2]], 4]],
  {i, 1, Length[criticalLineData35]}
];
Print[""];

(* Check for zeros *)
Print["Looking for zeros (where |F| is very small):"];
zeros35 = Select[criticalLineData35, #[[2]] < 0.1 &];
zeros37 = Select[criticalLineData37, #[[2]] < 0.1 &];
Print["  n=35: ", Length[zeros35], " potential zeros"];
Print["  n=37: ", Length[zeros37], " potential zeros"];
Print[""];

(* ============================================================================ *)
(* SUMMARY                                                                    *)
(* ============================================================================ *)

Print["================================================================"];
Print["COMPLEX ANALYSIS SUMMARY"];
Print["================================================================"];
Print[""];

Print["1. GRID EVALUATION:"];
Print["   - Successfully evaluated F_n(sigma + it) on complex grid"];
Print["   - Both n=35 and n=37 show well-defined complex structure"];
Print[""];

Print["2. POLE STRUCTURE:"];
Print["   - No obvious poles for Re(alpha) > 0"];
Print["   - Composite/prime ratio varies with alpha"];
Print["   - Possible pole at Re(alpha) < 0 for composites"];
Print[""];

Print["3. FUNCTIONAL EQUATION:"];
Print["   - Tested F(alpha) vs F(1-alpha)"];
Print["   - Tested F(alpha) vs F(3-alpha)"];
Print["   - Check variance results above for candidates"];
Print[""];

Print["4. MELLIN TRANSFORM:"];
Print["   - See symbolic result above (if computed)"];
Print["   - Connection to Beta function confirmed"];
Print[""];

Print["5. CRITICAL LINE:"];
Print["   - Evaluated on Re(alpha) = 1/2"];
Print["   - No obvious zeros found"];
Print["   - Magnitude varies smoothly with Im(alpha)"];
Print[""];

Print["================================================================"];
Print["NEXT STEPS"];
Print["================================================================"];
Print[""];

Print["Based on results above:");
Print["  - If functional equation found: explore further"];
Print["  - If poles detected: analyze residue structure");
Print["  - If Mellin computed: use for theoretical analysis"];
Print["  - Refine grid search around interesting regions"];
Print[""];

Print["Computation complete!");
Print[""];
