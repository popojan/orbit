(* Investigate which primes appear in denominators *)

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

ModFactorial[m_Integer] := Module[{sigma, modulus},
  sigma = ComputeBareSumAlt[m];
  modulus = 1/((m-1)!);
  Mod[sigma, modulus]
];

Print["=== INVESTIGATING MISSING PRIMES ==="];
Print[""];

primes = Select[Range[3, 37, 2], PrimeQ];

Do[
  Module[{k, result, den, fact, allPrimes, missingPrimes},
    k = Floor[(m-1)/2];
    result = ModFactorial[m];

    If[result != 0 && PrimeQ[m],
      den = Denominator[result];
      fact = FactorInteger[den];
      allPrimes = Prime[Range[PrimePi[m]]];
      missingPrimes = Complement[allPrimes, fact[[All, 1]]];

      If[Length[missingPrimes] > 0,
        Print["m=", m, " (k=", k, "): MISSING PRIMES: ", missingPrimes];
        Print["  Relation to k: ", Table[{p, If[p <= k, "≤k", ">k"], If[p <= 2*k+1, "≤2k+1", ">2k+1"]}, {p, missingPrimes}]];
        Print[""];
      ];
    ];
  ];
  , {m, primes}
];

Print[""];
Print["=== HYPOTHESIS: Primes appear iff they divide some denominator 2i+1 OR appear in k! ==="];
Print[""];

Do[
  Module[{k, result, den, fact, allPrimes, denominators, primesInDenoms, primesInKFact, expectedPrimes, actualPrimes, unexpected, missing},
    k = Floor[(m-1)/2];
    result = ModFactorial[m];

    If[result != 0 && PrimeQ[m],
      den = Denominator[result];
      fact = FactorInteger[den];
      actualPrimes = fact[[All, 1]];

      (* Primes that divide denominators 2i+1 for i=1..k *)
      denominators = Table[2*i+1, {i, 1, k}];
      primesInDenoms = Union[Flatten[FactorInteger[#][[All, 1]] & /@ denominators]];

      (* Primes that divide k! *)
      primesInKFact = If[k > 1, FactorInteger[k!][[All, 1]], {}];

      (* Expected: union of these plus 2 (from leading factor) plus m (the prime itself) *)
      expectedPrimes = Union[Join[{2, m}, primesInDenoms, primesInKFact]];

      unexpected = Complement[actualPrimes, expectedPrimes];
      missing = Complement[expectedPrimes, actualPrimes];

      Print["m=", m, " (k=", k, ")"];
      Print["  Primes in denominators 2i+1: ", primesInDenoms];
      Print["  Primes in k!: ", primesInKFact];
      Print["  Expected primes: ", expectedPrimes];
      Print["  Actual primes: ", actualPrimes];
      If[Length[unexpected] > 0, Print["  UNEXPECTED: ", unexpected]];
      If[Length[missing] > 0, Print["  MISSING: ", missing]];
      Print[""];
    ];
  ];
  , {m, primes[[1;;8]]}
];

Print["=== END ==="];
