(* Extract full Egyptian fraction structure without merging *)

<< Ratio`

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["═══════════════════════════════════════════════════════════════════"];
Print["EGYPTIAN FRACTIONS - FULL STRUCTURE (NO MERGING)"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

primes = Select[Range[3, 29, 2], PrimeQ];

Print["Using MaxItems -> Infinity to prevent merging..."];
Print[""];

results = Table[
  Module[{m, k, sigma, unitFracs, raw, N, D, primHalf},
    m = p;
    k = (m-1)/2;
    sigma = ComputeBareSumAlt[m];

    (* Get FULL unit fraction list without merging *)
    unitFracs = EgyptianFractions[sigma, MaxItems -> Infinity];

    (* Also get raw structure *)
    raw = EgyptianFractions[sigma, Method -> "Raw"];

    N = Numerator[sigma];
    D = Denominator[sigma];
    primHalf = Product[Prime[i], {i, 2, PrimePi[m]}];

    Print["m = ", m, " (Σ_m = ", N, "/", D, ")"];
    Print["  Primorial(m)/2 = ", primHalf];
    Print["  Sign: ", If[sigma > 0, "+", "-"]];
    Print[""];

    If[sigma > 0,
      Print["  Unit fractions: ", unitFracs];
      Print["  Number of terms: ", Length[unitFracs]];
      Print[""];
      Print["  Denominators: ", Denominator /@ unitFracs];
      Print["  Prime denominators: ", Select[Denominator /@ unitFracs, PrimeQ]];
      Print[""];
      Print["  Raw structure length: ", Length[raw]];
      Print[""];

      (* Check which primes appear as denominators *)
      allPrimes = Prime[Range[PrimePi[m]]];
      denomPrimes = Select[Denominator /@ unitFracs, PrimeQ];
      Print["  All primes ≤ m: ", allPrimes];
      Print["  Primes in denominators: ", denomPrimes];
      Print["  Missing from denominators: ", Complement[allPrimes, denomPrimes]];
      Print[""];
    ,
      Print["  (Negative - empty Egyptian structure)"];
      Print[""];
    ];

    <|
      "m" -> m,
      "sigma" -> sigma,
      "unitFracs" -> unitFracs,
      "raw" -> raw,
      "D" -> D,
      "primHalf" -> primHalf
    |>
  ],
  {p, primes}
];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["ANALYZING DENOMINATOR PATTERNS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["For positive cases, analyzing denominators more carefully:"];
Print[""];

positiveCases = Select[results, #["sigma"] > 0 &];

Do[
  Module[{m, denoms, primeDenoms, compositeDenoms, allPrimes},
    m = r["m"];
    denoms = Denominator /@ r["unitFracs"];
    allPrimes = Prime[Range[PrimePi[m]]];

    primeDenoms = Select[denoms, PrimeQ];
    compositeDenoms = Select[denoms, !PrimeQ[#] && # > 1 &];

    Print["m = ", m, ":"];
    Print["  Total unit fractions: ", Length[denoms]];
    Print["  Unique denominators: ", Length[DeleteDuplicates[denoms]]];
    Print["  Prime denominators: ", DeleteDuplicates[primeDenoms]];
    Print["  Composite denominators (first 10): ", Take[DeleteDuplicates[compositeDenoms], Min[10, Length[DeleteDuplicates[compositeDenoms]]]]];

    (* Factor the composites *)
    If[Length[compositeDenoms] > 0,
      Print["  Factorizations of composites (first 5):"];
      Do[
        Print["    ", d, " = ", FactorInteger[d]];
      , {d, Take[DeleteDuplicates[compositeDenoms], Min[5, Length[DeleteDuplicates[compositeDenoms]]]]}];
    ];

    Print[""];
  ],
  {r, positiveCases}
];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["KEY QUESTION: Do denominators relate to terms 2i+1?"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["For m=13, the original sum has denominators:"];
k13 = (13-1)/2;
denoms13 = Table[2*i+1, {i, 1, k13}];
Print["  {2i+1 : i=1..", k13, "} = ", denoms13];
Print[""];

unitDenoms13 = Denominator /@ results[[4]]["unitFracs"];
Print["Egyptian fraction denominators for m=13:"];
Print["  ", DeleteDuplicates[unitDenoms13]];
Print[""];

Print["Denominators from sum that appear in Egyptian: ", Intersection[denoms13, unitDenoms13]];
Print["Denominators from sum NOT in Egyptian: ", Complement[denoms13, unitDenoms13]];
Print["Egyptian denominators NOT from sum: ", Complement[unitDenoms13, denoms13]];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CHECKING PRIMORIAL RECONSTRUCTION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["If we sum all unit fractions, do we get Σ_m back?"];
Print["And does LCM of denominators give us Primorial(m)?"];
Print[""];

Do[
  Module[{m, unitFracs, sumCheck, denoms, lcmDenoms, primHalf, match},
    m = r["m"];
    unitFracs = r["unitFracs"];
    primHalf = r["primHalf"];

    If[Length[unitFracs] > 0,
      sumCheck = Total[unitFracs];
      denoms = Denominator /@ unitFracs;
      lcmDenoms = LCM @@ denoms;
      match = (sumCheck == r["sigma"]);

      Print["m = ", m, ":"];
      Print["  Sum of unit fractions: ", sumCheck];
      Print["  Original Σ_m: ", r["sigma"]];
      Print["  Match? ", If[match, "✓", "✗"]];
      Print["  LCM of denominators: ", lcmDenoms];
      Print["  Primorial(m)/2: ", primHalf];
      Print["  LCM == Primorial(m)/2? ", If[lcmDenoms == primHalf, "✓ YES!", "✗ No"]];
      Print[""];
    ];
  ],
  {r, positiveCases}
];

Print[""];
