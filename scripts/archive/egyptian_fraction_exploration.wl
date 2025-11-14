(* Explore Egyptian fraction structure using Ratio` package *)

<< Ratio`

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["═══════════════════════════════════════════════════════════════════"];
Print["EGYPTIAN FRACTION ANALYSIS USING Ratio` PACKAGE"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

primes = Select[Range[3, 19, 2], PrimeQ];

Print["Analyzing RawFractions structure for Σ_m..."];
Print[""];

results = Table[
  Module[{m, k, sigma, raw, N, D, primHalf},
    m = p;
    k = (m-1)/2;
    sigma = ComputeBareSumAlt[m];

    (* Use Ratio` package *)
    raw = RawFractions[sigma];

    N = Numerator[sigma];
    D = Denominator[sigma];
    primHalf = Product[Prime[i], {i, 2, PrimePi[m]}];

    Print["m = ", m, ":"];
    Print["  Σ_m = ", sigma];
    Print["  N = ", N, ", D = ", D];
    Print["  Primorial(m)/2 = ", primHalf];
    Print["  D == Primorial(m)/2? ", If[D == primHalf, "✓", "✗"]];
    Print["  RawFractions output:"];
    Print["    ", raw];
    Print[""];

    <|
      "m" -> m,
      "sigma" -> sigma,
      "N" -> N,
      "D" -> D,
      "primHalf" -> primHalf,
      "raw" -> raw
    |>
  ],
  {p, primes}
];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["ANALYZING THE RawFractions ALGORITHM"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["The RawFractions algorithm works as follows:"];
Print[""];
Print["Input: fraction a/b"];
Print["While a > 0 and b > 1:");
Print["  1. v = ModularInverse[-a, b]"];
Print["  2. {t, a} = QuotientRemainder[a, (1 + a*v)/b]"];
Print["  3. b -= t*v"];
Print["  4. Store {b, v, 1, t}"];
Print[""];
Print["Key insight: It uses MODULAR INVERSE to decompose the fraction.");
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["TRACE THE ALGORITHM FOR A SMALL CASE"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Tracing RawFractions for m=7 (Σ_7 = -83/105):"];
Print[""];

(* Manual trace *)
Module[{a, b, v, t, step = 0},
  {a, b} = {-83, 105};

  Print["Initial: a = ", a, ", b = ", b];
  Print[""];

  While[a != 0 && b > 1 && step < 10,
    step++;
    Print["Step ", step, ":"];
    Print["  a = ", a, ", b = ", b];

    v = Mod[PowerMod[-a, -1, b], b];
    Print["  v = ModularInverse[-a, b] = ModularInverse[", -a, ", ", b, "] = ", v];

    Print["  (1 + a*v)/b = (1 + ", a, "*", v, ")/", b, " = ", (1 + a*v)/b];

    {t, a} = QuotientRemainder[a, (1 + a*v)/b];
    Print["  QuotientRemainder[", a + t*(1 + a*v)/b, ", ", (1 + a*v)/b, "] = {", t, ", ", a, "}"];

    b = b - t*v;
    Print["  New b = ", b + t*v, " - ", t, "*", v, " = ", b];
    Print["  Store: {", b + t*v, ", ", v, ", 1, ", t, "}"];
    Print[""];
  ];

  Print["Final: a = ", a, ", b = ", b];
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["KEY QUESTION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["Can the RawFractions algorithm be INVERTED?"];
Print[""];
Print["If we know:");
Print["  - The final state (a=numerator/GCD, b=1)"];
Print["  - Some property we can compute cheaply"];
Print[""];
Print["Can we work BACKWARDS to recover the denominator D?"];
Print[""];
Print["This seems unlikely because:"];
Print["  - The algorithm needs a, b as input"];
Print["  - We're trying to find D = denominator"];
Print["  - Without knowing Σ_m, we don't have a or b"];
Print[""];
Print["Unless... there's a property of the SEQUENCE of {b_i, v_i, 1, t_i}"];
Print["that relates to primorials?"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["ANALYZING RawFractions OUTPUT STRUCTURE"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Looking for patterns in the {b, v, 1, t} tuples:"];
Print[""];

Do[
  Module[{m, raw, components},
    m = r["m"];
    raw = r["raw"];

    Print["m = ", m, ":"];
    Print["  RawFractions output: ", raw];

    If[Length[raw] > 0,
      components = raw[[All, 1]]; (* Extract all b values *)
      Print["  b values: ", components];
      Print["  Any primes? ", Select[components, PrimeQ]];
      Print["  Factor last b: ", If[Length[raw] > 0, FactorInteger[Last[raw][[1]]], "N/A"]];
    ];
    Print[""];
  ],
  {r, results}
];

Print[""];
Print["CONCLUSION: The RawFractions algorithm is a decomposition tool,"];
Print["not a shortcut for finding denominators without computing the fraction."];
Print[""];
