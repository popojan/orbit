(* Investigation: Why do certain primes vanish from the remainder? *)

Print["==============================================================================="];
Print["INVESTIGATING THE MISSING PRIME MECHANISM"];
Print["==============================================================================="];
Print[""];
Print["OBSERVATION: For m=5, prime 3 is missing from den(R_5)"];
Print["             For m=29, prime 17 is missing from den(R_29)"];
Print[""];
Print["REJECTED CONJECTURE: These primes divide the quotient Q_m"];
Print["  → Q_5 = 1 (doesn't contain 3)"];
Print["  → Q_29 has huge primes, but not 17"];
Print[""];
Print["NEW APPROACH: Analyze the FULL bare sum Σ_m before modular reduction"];
Print[""];
Print["==============================================================================="];
Print[""];

(* Compute bare alternating sum *)
ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

(* Detailed term-by-term analysis *)
AnalyzeTerms[m_Integer] := Module[{k, terms, cumulativeSum, denSigma, factDenSigma, missingPrimes},
  k = Floor[(m-1)/2];

  (* Individual terms *)
  terms = Table[
    <|
      "i" -> i,
      "term" -> (-1)^i * i! / (2*i+1),
      "numerator" -> (-1)^i * i!,
      "denominator" -> 2*i+1,
      "denFactors" -> FactorInteger[2*i+1]
    |>,
    {i, 1, k}
  ];

  (* Full sum *)
  cumulativeSum = ComputeBareSumAlt[m];
  denSigma = Denominator[cumulativeSum];
  factDenSigma = FactorInteger[denSigma];

  (* Which primes are missing? *)
  allPrimes = Prime[Range[PrimePi[m]]];
  primesInDenSigma = factDenSigma[[All, 1]];
  missingPrimes = Complement[allPrimes, primesInDenSigma];

  <|
    "m" -> m,
    "k" -> k,
    "terms" -> terms,
    "sigma" -> cumulativeSum,
    "denSigma" -> denSigma,
    "factDenSigma" -> factDenSigma,
    "primesInDenSigma" -> primesInDenSigma,
    "missingPrimes" -> missingPrimes
  |>
];

(* Analyze specific cases *)
Print["CASE 1: m = 5 (prime 3 missing from remainder)"];
Print[StringRepeat["=", 80]];

r5 = AnalyzeTerms[5];
Print["k = ", r5["k"]];
Print[""];
Print["Individual terms:"];
Do[
  t = r5["terms"][[i]];
  Print["  i=", t["i"], ": term = ", t["term"], " = ", t["numerator"], "/", t["denominator"]];
  Print["         denominator factors: ", t["denFactors"]];
  , {i, 1, Length[r5["terms"]]}
];
Print[""];
Print["Full sum Σ_5 = ", r5["sigma"]];
Print["  Denominator: ", r5["denSigma"]];
Print["  Factorization: ", r5["factDenSigma"]];
Print["  Primes in denominator: ", r5["primesInDenSigma"]];
Print["  Missing primes: ", r5["missingPrimes"]];
Print[""];
Print["OBSERVATION: Σ_5 already has 3 in its denominator!"];
Print["  Term i=1 has denominator 3"];
Print["  But after Mod[Σ_5, 1/4!], prime 3 disappears"];
Print[""];
Print[""];

Print["CASE 2: m = 29 (prime 17 missing from remainder)"];
Print[StringRepeat["=", 80]];

r29 = AnalyzeTerms[29];
Print["k = ", r29["k"]];
Print[""];
Print["Full sum Σ_29 = ", r29["sigma"]];
Print["  Denominator: ", r29["denSigma"]];
Print["  Factorization: ", r29["factDenSigma"]];
Print["  Primes in denominator: ", r29["primesInDenSigma"]];
Print["  Missing primes: ", r29["missingPrimes"]];
Print[""];
Print["Check: Does 17 divide any term denominator 2i+1?"];
terminators = Table[2*i+1, {i, 1, r29["k"]}];
containing17 = Select[terminators, Divisible[#, 17] &];
Print["  Denominators divisible by 17: ", containing17];
Print["  Specifically: 2*8+1 = 17"];
Print[""];
Print["OBSERVATION: Σ_29 HAS 17 in its denominator (from term i=8)"];
Print["  But after Mod[Σ_29, 1/28!], prime 17 disappears"];
Print[""];
Print[""];

(* Check p-adic valuations *)
Print["DEEPER ANALYSIS: p-adic valuations"];
Print[StringRepeat["=", 80]];
Print[""];

AnalyzePadicCancellation[m_, p_] := Module[{k, sigma, denSigma, modulus, remainder, denRemainder,
  vpDenSigma, vpModulus, vpDenRemainder, iWithP},
  k = Floor[(m-1)/2];
  sigma = ComputeBareSumAlt[m];
  denSigma = Denominator[sigma];
  modulus = 1/((m-1)!);
  remainder = Mod[sigma, modulus];
  denRemainder = Denominator[remainder];

  (* p-adic valuations *)
  vpDenSigma = If[Mod[denSigma, p] == 0,
    Length[FactorInteger[denSigma][[All, 1]]] > 0 && MemberQ[FactorInteger[denSigma][[All, 1]], p],
    False
  ];
  vpModulus = Sum[Floor[(m-1)/p^j], {j, 1, Floor[Log[p, m-1] + 1]}];
  vpDenRemainder = If[Mod[denRemainder, p] == 0,
    SelectFirst[FactorInteger[denRemainder], #[[1]] == p &, {p, 0}][[2]],
    0
  ];

  (* Which term has denominator divisible by p? *)
  iWithP = Select[Range[1, k], Divisible[2*# + 1, p] &];

  Print["m = ", m, ", p = ", p, ":"];
  Print["  p divides den(Σ_m)? ", vpDenSigma];
  Print["  ν_p((m-1)!) = ", vpModulus];
  Print["  ν_p(den(R_m)) = ", vpDenRemainder];
  Print["  Terms with p | (2i+1): i = ", iWithP, " → denominators ", 2*iWithP + 1];
  Print["  Conclusion: ", If[vpDenRemainder == 0, "p CANCELLED", "p SURVIVED"]];
  Print[""];
];

AnalyzePadicCancellation[5, 3];
AnalyzePadicCancellation[29, 17];
AnalyzePadicCancellation[29, 19]; (* For comparison - this one survives *)
AnalyzePadicCancellation[29, 23]; (* For comparison - this one survives *)

Print["==============================================================================="];
Print["HYPOTHESIS: Cancellation via numerator divisibility"];
Print["==============================================================================="];
Print[""];
Print["If term i has denominator 2i+1 divisible by p, then:"];
Print["  numerator = (-1)^i · i!"];
Print[""];
Print["For m=5, p=3: i=1, denominator=3, numerator=(-1)^1 · 1! = -1"];
Print["  → ν_3(numerator) = 0, ν_3(denominator) = 1"];
Print["  → After summing and reducing, net ν_3 might cancel?"];
Print[""];
Print["For m=29, p=17: i=8, denominator=17, numerator=(-1)^8 · 8! = 40320"];
Print["  → ν_17(8!) = ", Sum[Floor[8/17^j], {j, 1, 10}]];
Print["  → ν_17(40320) = ", If[Mod[40320, 17] == 0, "≥1", "0"]];
Print[""];
Print["Let's check: ", Mod[40320, 17]];
Print["  40320 mod 17 = ", Mod[40320, 17], " → 17 does NOT divide 8!"];
Print[""];
Print["==============================================================================="];
Print["END"];
Print["==============================================================================="];
