(* Analyze Egyptian fraction structure for Σ_m *)

<< Ratio`

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["═══════════════════════════════════════════════════════════════════"];
Print["EGYPTIAN FRACTION STRUCTURE OF Σ_m"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

primes = Select[Range[3, 23, 2], PrimeQ];

Print["Extracting Raw Egyptian structure (Method -> \"Raw\"):"];
Print[""];

results = Table[
  Module[{m, k, sigma, raw, N, D, primHalf},
    m = p;
    k = (m-1)/2;
    sigma = ComputeBareSumAlt[m];

    (* Get raw Egyptian fraction structure *)
    raw = EgyptianFractions[sigma, Method -> "Raw"];

    N = Numerator[sigma];
    D = Denominator[sigma];
    primHalf = Product[Prime[i], {i, 2, PrimePi[m]}];

    Print["m = ", m, " (Σ_m = ", N, "/", D, " where D = Primorial(m)/2 = ", primHalf, ")"];
    Print["  Raw Egyptian structure: ", raw];
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
Print["ANALYZING THE STRUCTURE"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Each element is {b, v, 1, t} from the RawFractions algorithm."];
Print[""];
Print["Looking for patterns:"];
Print[""];

Do[
  Module[{m, raw, bValues, vValues, tValues},
    m = r["m"];
    raw = r["raw"];

    If[Length[raw] > 0,
      (* Extract components *)
      bValues = raw[[All, 1]];
      vValues = raw[[All, 2]];
      tValues = raw[[All, 4]];

      Print["m = ", m, ":"];
      Print["  Number of components: ", Length[raw]];
      Print["  b values (denominators): ", bValues];
      Print["  v values (modular inverses): ", vValues];
      Print["  t values (quotients): ", tValues];

      (* Check if b values are special *)
      Print["  Prime b values: ", Select[bValues, PrimeQ]];
      Print["  Factors of b values: ", FactorInteger /@ bValues];

      (* Check relations to m *)
      Print["  Any b divisible by m? ", Select[bValues, Divisible[#, m] &]];
      Print["  GCD(b values, m): ", GCD[#, m] & /@ bValues];

      Print[""];
    ];
  ],
  {r, results}
];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["KEY QUESTIONS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["1. Do the b values have primorial factors?"];
Print["2. Do the v values (modular inverses) encode prime structure?"];
Print["3. Is there a pattern in the number of components vs. m?"];
Print["4. Can we predict the structure without computing Σ_m?"];
Print[""];

Print["Testing predictability:"];
Print[""];

Print["m | # components | PrimePi(m) | k=(m-1)/2 | Pattern?"];
Print[StringRepeat["-", 80]];

Do[
  Module[{m, raw, numComps, primePi, k},
    m = r["m"];
    raw = r["raw"];
    numComps = Length[raw];
    primePi = PrimePi[m];
    k = (m-1)/2;

    Print[m, " | ", numComps, " | ", primePi, " | ", k, " | ?"];
  ],
  {r, results}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["COMPARING DIFFERENT METHODS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Testing different Egyptian fraction methods for m=7:"];
sigma7 = ComputeBareSumAlt[7];
Print["Σ_7 = ", sigma7];
Print[""];

methods = {"Raw", "Expression", "Classical", "Merge"};

Do[
  Module[{result},
    result = EgyptianFractions[sigma7, Method -> method];
    Print["Method = \"", method, "\":"];
    Print["  ", result];
    Print[""];
  ],
  {method, methods}
];

Print[""];
