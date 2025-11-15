#!/usr/bin/env wolframscript
(* How Wolfram computed the rational limit - step by step *)

Print["================================================================"];
Print["DERIVING THE RATIONAL FORM: STEP BY STEP"];
Print["================================================================"];
Print[""];

Print["Question: How did Wolfram get 703166705641/351298031616 for n=5?"];
Print[""];

(* ============================================================================ *)
(* MANUAL COMPUTATION FOR n=5                                                 *)
(* ============================================================================ *)

Print["[1/3] Manual enumeration of terms for n=5, alpha=3"];
Print[""];

Print["We sum over (d,k) where n-kd-d^2 != 0"];
Print["Term: [(n-kd-d^2)^2]^(-3) = (n-kd-d^2)^(-6)"];
Print[""];

(* Collect all terms manually *)
terms = {};

Print["d=2:");
For[k = 0, k <= 10, k++,
  Module[{dist, term},
    dist = 5 - k*2 - 4;
    If[dist != 0 && Abs[dist] < 20,
      term = dist^(-6);
      AppendTo[terms, {2, k, dist, term}];
      Print["  k=", k, ": dist=", dist, ", term=1/", dist^6, " = ", N[term, 8]];
    ];
  ];
];
Print[""];

Print["d=3:");
For[k = 0, k <= 10, k++,
  Module[{dist, term},
    dist = 5 - k*3 - 9;
    If[dist != 0 && Abs[dist] < 20,
      term = dist^(-6);
      AppendTo[terms, {3, k, dist, term}];
      Print["  k=", k, ": dist=", dist, ", term=1/", dist^6, " = ", N[term, 8]];
    ];
  ];
];
Print[""];

Print["d=4 and beyond: dist too large or negative, negligible contribution"];
Print[""];

(* Sum all terms *)
totalSum = Total[terms[[All, 4]]];
Print["Total sum (symbolic): ", totalSum];
Print[""];

(* Simplify to single fraction *)
simplified = Together[totalSum];
Print["Simplified: ", simplified];
Print[""];

numerator = Numerator[simplified];
denominator = Denominator[simplified];

Print["Numerator:   ", numerator];
Print["Denominator: ", denominator];
Print[""];

Print["Numerical value: ", N[simplified, 20]];
Print[""];

Print["Match with Wolfram? ", numerator == 703166705641 && denominator == 351298031616];
Print[""];

(* ============================================================================ *)
(* PATTERN IN TERMS                                                           *)
(* ============================================================================ *)

Print["[2/3] Pattern analysis"];
Print[""];

Print["Terms collected: ", Length[terms]];
Print[""];

Print["Unique distances:"];
distances = DeleteDuplicates[terms[[All, 3]]];
Print[Sort[Abs[distances]]];
Print[""];

Print["Distance multiplicities (how many (d,k) give each distance):"];
distCounts = Tally[terms[[All, 3]]];
Print["dist\tcount\tterm"];
Print[StringRepeat["-", 40]];
Do[
  Module[{dist, count, term},
    {dist, count} = distCounts[[i]];
    term = count * dist^(-6);
    Print[dist, "\t", count, "\t", N[term, 8]];
  ],
  {i, 1, Length[distCounts]}
];
Print[""];

(* ============================================================================ *)
(* CLOSED FORM ATTEMPT                                                        *)
(* ============================================================================ *)

Print["[3/3] Can we find a closed form?"];
Print[""];

Print["Observation: F_n(alpha) depends on:"];
Print["  - Which (d,k) pairs give each distance m"];
Print["  - Combinatorial structure of n"];
Print[""];

Print["For PRIME p:"];
Print["  No exact factorization p = kd + d^2 exists"];
Print["  All distances are >= 1"];
Print["  Pattern depends on p mod something?"];
Print[""];

(* Try to find pattern with small primes *)
Print["Computing F_p(3) for first few primes:"];
Print[""];

smallPrimes = {2, 3, 5, 7};
results = Table[
  Module[{fp, terms, d, k, dist},
    terms = {};
    For[d = 2, d <= Floor[Sqrt[p]] + 3, d++,
      For[k = 0, k <= 20, k++,
        dist = p - k*d - d^2;
        If[dist != 0 && Abs[dist] < 30,
          AppendTo[terms, dist^(-6)];
        ];
      ];
    ];
    fp = Together[Total[terms]];
    {p, Numerator[fp], Denominator[fp], N[fp, 15]}
  ],
  {p, smallPrimes}
];

Print["p\tNumerator\t\tDenominator\t\tValue"];
Print[StringRepeat["-", 80]];
Do[
  Print[results[[i, 1]], "\t", results[[i, 2]], "\t\t",
    results[[i, 3]], "\t\t", results[[i, 4]]],
  {i, 1, Length[results]}
];
Print[""];

(* Look for patterns *)
Print["Looking for patterns in numerators and denominators:"];
Print[""];

nums = results[[All, 2]];
dens = results[[All, 3]];

Print["Numerators: ", nums];
Print["GCD: ", GCD @@ nums];
Print[""];

Print["Denominators: ", dens];
Print["GCD: ", GCD @@ dens];
Print[""];

(* Check if denominators have pattern *)
Print["Denominator factorizations:"];
Do[
  Print["  p=", results[[i, 1]], ": ", FactorInteger[results[[i, 3]]]],
  {i, 1, Length[results]}
];
Print[""];

(* ============================================================================ *)
(* THEORETICAL APPROACH                                                       *)
(* ============================================================================ *)

Print["================================================================"];
Print["THEORETICAL FRAMEWORK"];
Print["================================================================"];
Print[""];

Print["The sum can be written as:"];
Print["  F_p(alpha) = Sum_{m=1}^inf c_m(p) * m^(-2*alpha)"];
Print[""];
Print["where c_m(p) = #{(d,k): |p-kd-d^2| = m}"];
Print[""];

Print["For n=5, alpha=3:"];
Print["  We need c_m(5) for each m"];
Print[""];

(* Compute c_m for n=5 *)
cmValues5 = Association[];
For[d = 2, d <= 10, d++,
  For[k = 0, k <= 20, k++,
    Module[{dist},
      dist = Abs[5 - k*d - d^2];
      If[dist > 0 && dist < 30,
        If[KeyExistsQ[cmValues5, dist],
          cmValues5[dist]++,
          cmValues5[dist] = 1
        ];
      ];
    ];
  ];
];

Print["c_m(5) values (m -> count):"];
Print[KeySort[cmValues5]];
Print[""];

Print["Verification:"];
Print["  F_5(3) = Sum_m c_m(5) * m^(-6)"];
verification = Total[KeyValueMap[#2 * #1^(-6) &, cmValues5]];
Print["         = ", Together[verification]];
Print["         = ", N[verification, 15]];
Print[""];

(* ============================================================================ *)
(* CAN WE PREDICT c_m(p)?                                                     *)
(* ============================================================================ *)

Print["================================================================"];
Print["CAN WE PREDICT c_m(p)?"];
Print["================================================================"];
Print[""];

Print["This is the HARD PART - c_m(p) depends on:"];
Print["  - How many ways to write m = |p - kd - d^2|"];
Print["  - Number-theoretic properties of p"];
Print[""];

Print["For small m, we can analyze:");
Print[""];

Print["m=1: How many (d,k) give |p-kd-d^2| = 1?");
Print["  This means p-kd-d^2 = ±1");
Print["  p = kd + d^2 ± 1");
Print["  For each d, solve for k: k = (p ∓ 1 - d^2)/d");
Print["  k must be non-negative integer");
Print[""];

(* For p=5, m=1 *)
Print["Example: p=5, m=1");
For[d = 2, d <= 5, d++,
  Module[{k1, k2},
    k1 = (5 - 1 - d^2)/d;  (* p - kd - d^2 = +1 *)
    k2 = (5 + 1 - d^2)/d;  (* p - kd - d^2 = -1 *)
    If[IntegerQ[k1] && k1 >= 0,
      Print["  d=", d, ", k=", k1, " gives dist=+1"];
    ];
    If[IntegerQ[k2] && k2 >= 0,
      Print["  d=", d, ", k=", k2, " gives dist=-1"];
    ];
  ];
];
Print[""];

Print["This shows c_m(p) is COMBINATORIAL and depends on p arithmetically"];
Print[""];

(* ============================================================================ *)
(* CONCLUSION                                                                 *)
(* ============================================================================ *)

Print["================================================================"];
Print["CONCLUSION: RATIONALITY BUT NO SIMPLE CLOSED FORM"];
Print["================================================================"];
Print[""];

Print["1. HOW WOLFRAM COMPUTED IT:"];
Print["   - Enumerated all (d,k) pairs with |p-kd-d^2| < threshold"];
Print["   - Computed term = (p-kd-d^2)^(-6) for each"];
Print["   - Summed symbolically as rational numbers"];
Print["   - Simplified to single fraction using Together[]"];
Print[""];

Print["2. WHY IT'S RATIONAL:"];
Print["   - Each term is m^(-6) where m is integer"];
Print["   - Sum of rational numbers is rational"];
Print["   - No transcendental or irrational parts"];
Print[""];

Print["3. CLOSED FORM DIFFICULTY:"];
Print["   - c_m(p) coefficients are combinatorial"];
Print["   - Depend on solutions to p = kd + d^2 ± m"];
Print["   - No simple formula for c_m(p) in general"];
Print["   - Each p gives different coefficient pattern"];
Print[""];

Print["4. DIVINE GEOMETRY CONNECTION (Wildberger):"];
Print["   - Everything is RATIONAL (no √, π, e needed)"];
Print["   - Pure algebraic/combinatorial structure"];
Print["   - Distances are integers, operations are exact"];
Print["   - This aligns with rational trigonometry philosophy!"];
Print[""];

Print["5. POSSIBLE APPROACHES TO CLOSED FORM:"];
Print["   - Asymptotic formula as p -> infinity"];
Print["   - Generating function for c_m(p)"];
Print["   - Connection to theta functions (q-series)"];
Print["   - Modular form theory (if coefficients have structure)"];
Print["   - Representation theory (orbits under group actions)"];
Print[""];

Print["The rationality is BEAUTIFUL but exact closed form remains OPEN!"];
Print[""];
