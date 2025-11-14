(* Exploration: Σ_m^alt mod 1/(m-1)! *)

(* Compute bare alternating sum *)
ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

(* Compute Σ_m^alt mod 1/(m-1)! *)
ModFactorial[m_Integer] := Module[{sigma, modulus, result},
  sigma = ComputeBareSumAlt[m];
  modulus = 1/((m-1)!);
  result = Mod[sigma, modulus];
  result
];

(* Analyze the denominator when result is a unit fraction *)
AnalyzeUnitFraction[m_Integer] := Module[{result, num, den},
  result = ModFactorial[m];
  If[result == 0,
    <|
      "m" -> m,
      "isPrime" -> PrimeQ[m],
      "result" -> 0,
      "isZero" -> True
    |>,
    {num, den} = {Numerator[result], Denominator[result]};
    <|
      "m" -> m,
      "isPrime" -> PrimeQ[m],
      "result" -> result,
      "isZero" -> False,
      "numerator" -> num,
      "denominator" -> den,
      "isUnitFraction" -> (num == 1),
      "denFactorization" -> FactorInteger[den],
      "primorial_m" -> Product[Prime[i], {i, 1, PrimePi[m]}],
      "ratio" -> N[den / Product[Prime[i], {i, 1, PrimePi[m]}]]
    |>
  ]
];

(* Test for range of odd numbers *)
Print["Testing odd numbers from 3 to 31..."];
Print[""];

results = Table[AnalyzeUnitFraction[m], {m, 3, 31, 2}];

(* Display results *)
Do[
  Print["m = ", results[[i]]["m"], " (", If[results[[i]]["isPrime"], "PRIME", "composite"], ")"];
  If[results[[i]]["isZero"],
    Print["  Result: 0"],
    Print["  Result: ", results[[i]]["result"]];
    Print["  Unit fraction: ", results[[i]]["isUnitFraction"]];
    If[results[[i]]["isUnitFraction"],
      Print["  Denominator: ", results[[i]]["denominator"]];
      Print["  Factorization: ", results[[i]]["denFactorization"]];
      Print["  Primorial(m): ", results[[i]]["primorial_m"]];
      Print["  Ratio den/Primorial: ", results[[i]]["ratio"]];
    ];
  ];
  Print[""];
  , {i, 1, Length[results]}
];

(* Look for pattern in denominators for primes *)
Print["=== PATTERN ANALYSIS FOR PRIMES ==="];
Print[""];

primeResults = Select[results, #["isPrime"] && !#["isZero"] &];

If[Length[primeResults] > 0,
  Print["Prime m | Denominator | Factorization | Ratio to Primorial"];
  Print[StringRepeat["-", 80]];
  Do[
    Print[
      primeResults[[i]]["m"], " | ",
      primeResults[[i]]["denominator"], " | ",
      primeResults[[i]]["denFactorization"], " | ",
      primeResults[[i]]["ratio"]
    ];
    , {i, 1, Length[primeResults]}
  ];
];

(* Analyze prime factorizations *)
Print[""];
Print["=== DETAILED PRIME POWER ANALYSIS ==="];
Print[""];

Do[
  m = primeResults[[i]]["m"];
  den = primeResults[[i]]["denominator"];
  fact = primeResults[[i]]["denFactorization"];
  primorial = primeResults[[i]]["primorial_m"];

  Print["m = ", m, ":"];
  Print["  Denominator factorization: ", fact];

  (* Compare with Primorial(m) factorization *)
  primorialFact = FactorInteger[primorial];
  Print["  Primorial(m) factorization: ", primorialFact];

  (* Compute excess powers *)
  Print["  Excess powers (beyond primorial):"];
  Do[
    p = fact[[j, 1]];
    pow = fact[[j, 2]];
    primorialPow = SelectFirst[primorialFact, #[[1]] == p &, {p, 0}][[2]];
    excess = pow - primorialPow;
    If[excess != 0,
      Print["    prime ", p, ": power ", pow, " vs primorial power ", primorialPow, " → excess: ", excess];
    ];
    , {j, 1, Length[fact]}
  ];
  Print[""];
  , {i, 1, Min[5, Length[primeResults]]}
];

Print["=== END ==="];
