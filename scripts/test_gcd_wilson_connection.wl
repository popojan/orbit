(* Test the connection between GCD, Wilson, and the modulo operation *)

(* Alternating sum formula *)
altSum[m_] := Module[{k = Floor[(m-1)/2]},
  Sum[(-1)^i * i! / (2*i + 1), {i, 1, k}] / 2
]

(* Get unreduced and reduced forms *)
analyzeSum[m_] := Module[{k, unredNum, unredDenom, sum, redNum, redDenom, gcd, primorial, composites},
  Print["  Processing m=", m, "..."];
  k = Floor[(m-1)/2];

  (* Build unreduced fraction *)
  unredDenom = 2 * Product[2*i + 1, {i, 1, k}];

  (* Get reduced form *)
  sum = altSum[m];
  redNum = Numerator[sum];
  redDenom = Denominator[sum];

  (* Compute GCD *)
  gcd = unredDenom / redDenom;

  (* Primorial - include 2! *)
  primorial = Times @@ Select[Range[2, m], PrimeQ];

  (* Odd composites *)
  composites = Select[Range[9, m, 2], CompositeQ];
  compositeProduct = If[Length[composites] > 0, Times @@ composites, 1];

  (* Wilson check for primes - skip for large m *)
  wilsonCheck = If[PrimeQ[m] && m <= 17, Mod[(m-1)!, m] == m-1, Null];

  (* Modulo operation - ONLY for small m since (m-1)! grows huge *)
  {modNum, modDenom, modFact} = If[m <= 15,
    Module[{modResult},
      modResult = Mod[sum, 1/Factorial[m-1]];
      {Numerator[modResult], Denominator[modResult],
       If[Denominator[modResult] < 10^6, FactorInteger[Denominator[modResult]], "too large"]}
    ],
    {"N/A", "N/A", "N/A"}
  ];

  <|
    "m" -> m,
    "isPrime" -> PrimeQ[m],
    "redDenom" -> redDenom,
    "primorial" -> primorial,
    "denomMatchesPrimorial" -> (redDenom == primorial/2),
    "gcd" -> gcd,
    "expectedGCD" -> If[m < 9, 2, 2 * compositeProduct],
    "gcdMatches" -> (gcd == If[m < 9, 2, 2 * compositeProduct]),
    "wilsonHolds" -> wilsonCheck,
    "modNumerator" -> modNum,
    "modDenominator" -> modDenom,
    "modIsUnitFraction" -> If[modNum =!= "N/A", modNum == 1, Null],
    "mDividesModDenom" -> If[PrimeQ[m] && modDenom =!= "N/A", Divisible[modDenom, m], Null],
    "modDenomFactors" -> modFact
  |>
]

(* Test for several values *)
Print["Testing GCD formula and Wilson connection:\n"];

results = Table[analyzeSum[m], {m, 3, 21, 2}];

(* Display results *)
Grid[{
  {"m", "Prime?", "Denom=Prim/2?", "GCD correct?", "Mod num=1?", "m|ModDenom?"}
  } ~Join~
  Table[{
    r["m"],
    r["isPrime"],
    r["denomMatchesPrimorial"],
    r["gcdMatches"],
    r["modIsUnitFraction"],
    r["mDividesModDenom"]
  }, {r, results}],
  Frame -> All,
  Alignment -> Left
]

Print["\nDetailed analysis for m=11 (prime):"];
r11 = analyzeSum[11];
Print[r11];

Print["\nDetailed analysis for m=15 (composite):"];
r15 = analyzeSum[15];
Print[r15];

(* Check the relationship between Wilson and the modulo denominator *)
Print["\n\nWilson connection analysis:"];
Print["For prime m, we have (m-1)! ≡ -1 (mod m) by Wilson"];
Print["The modulo denominator should be related to (m-1)!/Primorial(m)"];
Print[""];

primeTests = Select[results, #["isPrime"] &];
Table[
  Module[{m, fact, prim, ratio},
    m = r["m"];
    fact = Factorial[m-1];
    prim = r["primorial"];
    ratio = fact/prim;
    Print["m=", m, ": (m-1)!/Primorial = ", If[ratio < 10^10, ratio, N[ratio, 5]],
          ", ModDenom = ", r["modDenominator"],
          ", Ratio/ModDenom = ", If[r["modDenominator"] > 0, N[ratio/r["modDenominator"], 5], "N/A"]]
  ],
  {r, primeTests}
];
