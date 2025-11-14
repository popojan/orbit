(* Investigation: Quotient-Remainder Duality in Modular Factorial Sums *)

Print["==============================================================================="];
Print["CONJECTURE (Quotient-Remainder Prime Duality)"];
Print["==============================================================================="];
Print[""];
Print["For prime m, let k = Floor[(m-1)/2] and decompose:"];
Print["  Σ_m^alt = Q_m · (1/(m-1)!) + R_m"];
Print[""];
Print["where Q_m ∈ ℤ (quotient) and R_m is the remainder with 0 ≤ R_m < 1/(m-1)!."];
Print[""];
Print["CONJECTURE: For prime p with k < p < m:"];
Print["  If p ∤ k!, then:"];
Print["    (1) ν_p(Q_m) > 0  (p divides the quotient)"];
Print["    (2) ν_p(den(R_m)) = 0  (p is missing from remainder denominator)"];
Print[""];
Print["In other words: Primes 'too large' for k! get absorbed into the quotient"];
Print["during modular reduction, causing them to vanish from the remainder."];
Print[""];
Print["==============================================================================="];
Print[""];

(* Compute bare alternating sum *)
ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

(* Compute quotient and remainder *)
ComputeQuotientRemainder[m_Integer] := Module[{sigma, modulus, quotient, remainder},
  sigma = ComputeBareSumAlt[m];
  modulus = 1/((m-1)!);

  quotient = Floor[sigma / modulus];
  remainder = Mod[sigma, modulus];

  <|
    "m" -> m,
    "k" -> Floor[(m-1)/2],
    "sigma" -> sigma,
    "quotient" -> quotient,
    "remainder" -> remainder
  |>
];

(* Analyze prime distribution *)
AnalyzePrimeDistribution[m_Integer] := Module[{data, k, Q, R, denR, allPrimes, primesInQ, primesInR,
  primesBetweenKandM, primesInKFact, missingFromR, presentInQ, conjectureVerified},

  If[!PrimeQ[m], Return[<|"isPrime" -> False|>]];

  data = ComputeQuotientRemainder[m];
  k = data["k"];
  Q = data["quotient"];
  R = data["remainder"];

  If[R == 0, Return[<|"isPrime" -> False, "remainder" -> 0|>]];

  denR = Denominator[R];

  (* All primes up to m *)
  allPrimes = Prime[Range[PrimePi[m]]];

  (* Primes dividing quotient *)
  primesInQ = If[Q != 0, FactorInteger[Abs[Q]][[All, 1]], {}];

  (* Primes dividing remainder denominator *)
  primesInR = FactorInteger[denR][[All, 1]];

  (* Primes in range (k, m) *)
  primesBetweenKandM = Select[allPrimes, k < # < m &];

  (* Primes dividing k! *)
  primesInKFact = If[k > 1, FactorInteger[k!][[All, 1]], {}];

  (* Primes missing from remainder *)
  missingFromR = Complement[allPrimes, primesInR];

  (* Do missing primes divide quotient? *)
  presentInQ = Intersection[missingFromR, primesInQ];

  (* Conjecture verification: For p in (k,m) with p ∤ k!, check if p | Q and p ∤ den(R) *)
  candidatePrimes = Select[primesBetweenKandM, !MemberQ[primesInKFact, #] &];
  conjectureVerified = AllTrue[candidatePrimes,
    MemberQ[primesInQ, #] && !MemberQ[primesInR, #] &
  ];

  <|
    "m" -> m,
    "k" -> k,
    "isPrime" -> True,
    "quotient" -> Q,
    "remainder" -> R,
    "denRemainder" -> denR,
    "allPrimes" -> allPrimes,
    "primesInQ" -> primesInQ,
    "primesInR" -> primesInR,
    "primesBetweenKandM" -> primesBetweenKandM,
    "primesInKFact" -> primesInKFact,
    "missingFromR" -> missingFromR,
    "presentInQ" -> presentInQ,
    "candidatePrimes" -> candidatePrimes,
    "conjectureVerified" -> conjectureVerified,
    "factorQ" -> If[Q != 0, FactorInteger[Abs[Q]], {}],
    "factorDenR" -> FactorInteger[denR]
  |>
];

(* Test range of primes *)
primes = Select[Range[3, 31, 2], PrimeQ];

Print["TESTING CONJECTURE ON PRIMES 3 TO 31"];
Print[""];

results = Table[AnalyzePrimeDistribution[p], {p, primes}];

(* Summary table *)
Print["SUMMARY: Quotient-Remainder Prime Partition"];
Print[StringRepeat["=", 100]];
Print["m | k | Candidate Primes | Missing from R | Present in Q | Conjecture ✓?"];
Print[StringRepeat["-", 100]];

Do[
  r = results[[i]];
  If[r["isPrime"],
    Print[
      r["m"], " | ",
      r["k"], " | ",
      r["candidatePrimes"], " | ",
      r["missingFromR"], " | ",
      r["presentInQ"], " | ",
      If[r["conjectureVerified"], "✓ YES", "✗ NO"]
    ];
  ];
  , {i, 1, Length[results]}
];

Print[""];
Print[""];

(* Detailed analysis for specific cases *)
Print["DETAILED ANALYSIS"];
Print[StringRepeat["=", 100]];
Print[""];

highlightCases = {5, 29, 31};

Do[
  r = SelectFirst[results, #["m"] == m &];
  If[r =!= Missing["NotFound"] && r["isPrime"],
    Print["═══════════════════════════════════════════════════════════════════"];
    Print["m = ", m, ", k = ", r["k"]];
    Print["═══════════════════════════════════════════════════════════════════"];
    Print[""];
    Print["Quotient Q_", m, " = ", r["quotient"]];
    Print["  Factorization: ", r["factorQ"]];
    Print["  Primes dividing Q: ", r["primesInQ"]];
    Print[""];
    Print["Remainder R_", m, " = ", r["remainder"]];
    Print["  Denominator: ", r["denRemainder"]];
    Print["  Factorization: ", r["factorDenR"]];
    Print["  Primes in denominator: ", r["primesInR"]];
    Print[""];
    Print["Prime Distribution Analysis:"];
    Print["  All primes ≤ m: ", r["allPrimes"]];
    Print["  Primes in k!: ", r["primesInKFact"]];
    Print["  Primes in range (k, m): ", r["primesBetweenKandM"]];
    Print["  Candidate primes (in (k,m) and ∉ k!): ", r["candidatePrimes"]];
    Print[""];
    Print["Conjecture Test:"];
    Print["  Primes missing from den(R): ", r["missingFromR"]];
    Print["  Of these, which divide Q: ", r["presentInQ"]];
    Print["  Candidate primes all in Q? ", If[r["conjectureVerified"], "✓ YES", "✗ NO"]];
    Print[""];

    (* Check each candidate prime individually *)
    If[Length[r["candidatePrimes"]] > 0,
      Print["Individual verification:"];
      Do[
        p = r["candidatePrimes"][[j]];
        inQ = MemberQ[r["primesInQ"], p];
        inR = MemberQ[r["primesInR"], p];
        Print["  p=", p, ": divides Q? ", inQ, ", in den(R)? ", inR,
          " → ", If[inQ && !inR, "✓", "✗"]];
        , {j, 1, Length[r["candidatePrimes"]]}
      ];
      Print[""];
    ];
  ];
  , {m, highlightCases}
];

(* Overall conjecture verification *)
Print["═══════════════════════════════════════════════════════════════════"];
Print["OVERALL CONJECTURE VERIFICATION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

verificationResults = Select[results, #["isPrime"] &][[All, "conjectureVerified"]];
numVerified = Count[verificationResults, True];
numTotal = Length[verificationResults];

Print["Primes tested: ", numTotal];
Print["Conjecture verified: ", numVerified, "/", numTotal];
Print[""];

If[numVerified == numTotal,
  Print["✓✓✓ CONJECTURE HOLDS FOR ALL TESTED PRIMES! ✓✓✓"];
  ,
  Print["✗ Conjecture failed for some primes"];
  failedPrimes = Select[results, #["isPrime"] && !#["conjectureVerified"] &][[All, "m"]];
  Print["Failed for m = ", failedPrimes];
];

Print[""];
Print["==============================================================================="];
Print["END OF INVESTIGATION"];
Print["==============================================================================="];
