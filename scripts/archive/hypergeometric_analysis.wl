(* Hypergeometric analysis of the alternating factorial sum *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["HYPERGEOMETRIC ANALYSIS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Our sum: Σ_m = Σ_{i=1}^k (-1)^i · i! / (2i+1)"];
Print[""];

(* Try to express as hypergeometric function *)
Print["Attempting to express as hypergeometric pFq..."];
Print[""];

Print["General form: pFq([a1,...,ap], [b1,...,bq], z) = Σ (a1)_n···(ap)_n / (b1)_n···(bq)_n · z^n/n!"];
Print["where (a)_n = a(a+1)···(a+n-1) is Pochhammer symbol"];
Print[""];

Print["Our term: (-1)^i · i! / (2i+1)"];
Print["Rewrite: (-1)^i · Γ(i+1) / (2i+1)"];
Print["        = (-1)^i · Γ(i+1) / Γ(2i+2) · Γ(2i+1)"];
Print[""];

Print["This doesn't match standard hypergeometric form directly."];
Print[""];

Print["═══════════════════════════════════════════════════════════════════"];
Print["CONTINUED FRACTION REPRESENTATION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Computing CF for Σ_m for small primes..."];
Print[""];

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

primes = Select[Range[3, 31, 2], PrimeQ];

Print["m | Σ_m | ContinuedFraction[Σ_m, 15]"];
Print[StringRepeat["-", 120]];

cfResults = Table[
  Module[{m, sigma, cf},
    m = p;
    sigma = ComputeBareSumAlt[m];

    (* Get continued fraction representation *)
    cf = ContinuedFraction[sigma, 15];

    Print[m, " | ", N[sigma, 5], " | ", cf];

    <|"m" -> m, "sigma" -> sigma, "cf" -> cf|>
  ],
  {p, primes}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["EGYPTIAN FRACTION CONNECTION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Computing Egyptian fraction representation (greedy algorithm)..."];
Print[""];

(* Simple greedy Egyptian fraction *)
EgyptianFraction[r_Rational] := Module[{remaining, result, d},
  remaining = r;
  result = {};
  While[remaining > 0 && Length[result] < 20,
    d = Ceiling[1/remaining];
    AppendTo[result, 1/d];
    remaining = remaining - 1/d;
  ];
  If[remaining > 0, AppendTo[result, remaining]];
  result
];

Print["m | Σ_m | Egyptian fraction (first 10 terms)"];
Print[StringRepeat["-", 100]];

Do[
  Module[{m, sigma, egypt},
    m = r["m"];
    sigma = r["sigma"];

    egypt = EgyptianFraction[sigma];

    Print[m, " | ", sigma, " | ", Take[egypt, Min[10, Length[egypt]]]];
  ],
  {r, cfResults[[1;;5]]}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["ANALYZING CF PATTERNS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Looking for patterns in CF coefficients..."];
Print[""];

Print["m | CF length | First 10 coefficients | Pattern?"];
Print[StringRepeat["-", 100]];

Do[
  Module[{m, cf, len, first10, pattern},
    m = r["m"];
    cf = r["cf"];
    len = Length[cf];
    first10 = Take[cf, Min[10, len]];

    (* Check for patterns *)
    pattern = Which[
      MatchQ[cf, {0, __}], "Starts with 0 (|Σ| < 1)",
      MatchQ[cf, {-1, __}], "Starts with -1 (-1 < Σ < 0)",
      MatchQ[cf, {1, __}], "Starts with 1 (0 < Σ < 1)",
      True, "Other"
    ];

    Print[m, " | ", len, " | ", first10, " | ", pattern];
  ],
  {r, cfResults}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["SPECIAL VALUES & IDENTITIES"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Testing if Σ_m relates to known constants..."];
Print[""];

(* Test against known constants *)
Print["m | Σ_m | Σ_m / π | Σ_m / e | Σ_m / ln(2) | Σ_m * m"];
Print[StringRepeat["-", 100]];

Do[
  Module[{m, sigma, ratioPi, ratioE, ratioLn2, timesM},
    m = r["m"];
    sigma = r["sigma"];

    ratioPi = N[sigma / Pi, 5];
    ratioE = N[sigma / E, 5];
    ratioLn2 = N[sigma / Log[2], 5];
    timesM = sigma * m;

    Print[m, " | ", N[sigma, 5], " | ", ratioPi, " | ", ratioE, " | ",
      ratioLn2, " | ", N[timesM, 5]];
  ],
  {r, cfResults}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CONVERGENT ANALYSIS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Computing convergents from CF and comparing to actual value..."];
Print[""];

Print["For m=7:"];
sigma7 = ComputeBareSumAlt[7];
cf7 = ContinuedFraction[sigma7, 10];
Print["  Σ_7 = ", sigma7];
Print["  CF = ", cf7];
Print[""];

(* Compute convergents *)
convergents7 = Table[FromContinuedFraction[Take[cf7, i]], {i, 1, Min[10, Length[cf7]]}];
Print["  Convergents:"];
Do[
  Print["    p_", i, "/q_", i, " = ", convergents7[[i]], " = ", N[convergents7[[i]], 10]];
  Print["      Error: ", N[Abs[convergents7[[i]] - sigma7], 10]];
,{i, 1, Min[5, Length[convergents7]]}];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["KEY QUESTION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["Do the CF convergents p_i/q_i have special number-theoretic structure?"];
Print["Specifically: Do the denominators q_i relate to primorials or factorials?"];
Print[""];

Print["Analyzing convergent denominators for m=7, 11, 13:"];
Print[""];

Do[
  Module[{m, sigma, cf, convs, denoms},
    m = p;
    sigma = ComputeBareSumAlt[m];
    cf = ContinuedFraction[sigma, 10];
    convs = Table[FromContinuedFraction[Take[cf, i]], {i, 1, Min[8, Length[cf]]}];
    denoms = Denominator /@ convs;

    Print["m = ", m, ":"];
    Print["  Convergent denominators: ", denoms];
    Print["  Primorial(m)/2 = ", Product[Prime[i], {i, 2, PrimePi[m]}]];
    Print["  Final denominator matches? ",
      If[Last[denoms] == Product[Prime[i], {i, 2, PrimePi[m]}], "✓ YES!", "✗ No"]];
    Print[""];
  ],
  {p, {7, 11, 13}}
];

Print[""];
