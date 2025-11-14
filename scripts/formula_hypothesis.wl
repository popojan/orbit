(* Test hypothesis for closed form of the unit fraction denominator *)

(* Compute bare alternating sum *)
ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

(* Compute Σ_m^alt mod 1/(m-1)! *)
ModFactorial[m_Integer] := Module[{sigma, modulus},
  sigma = ComputeBareSumAlt[m];
  modulus = 1/((m-1)!);
  Mod[sigma, modulus]
];

Print["=== PATTERN: Most primes p < m have excess = ν_p((m-1)!) - 1 ==="];
Print[""];
Print["Hypothesis: Denominator formula involves (m-1)! with adjusted powers"];
Print[""];

(* Test various candidate formulas *)
TestFormula[m_, label_, formula_] := Module[{result, actualDen, candidateDen, match},
  If[!PrimeQ[m], Return[Null]];

  result = ModFactorial[m];
  If[result == 0, Return[Null]];

  actualDen = Denominator[result];
  candidateDen = formula;
  match = (actualDen == candidateDen);

  Print["m=", m, " | ", label];
  Print["  Actual:    ", FactorInteger[actualDen], " = ", actualDen];
  Print["  Candidate: ", FactorInteger[candidateDen], " = ", candidateDen];
  Print["  Match: ", If[match, "✓ YES", "✗ NO"]];
  Print[""];

  match
];

primes = Select[Range[3, 31, 2], PrimeQ];

Print["=== TESTING FORMULAS ==="];
Print[""];

(* Formula 1: Just (m-1)! *)
Print["Formula 1: den = (m-1)!"];
Print[StringRepeat["=", 60]];
results1 = Table[TestFormula[p, "Just (m-1)!", (p-1)!], {p, primes}];
Print["Success rate: ", Count[results1, True], "/", Length[results1]];
Print[""];
Print[""];

(* Formula 2: LCM of terms in sum *)
Print["Formula 2: den = LCM[denominators of Σ terms]"];
Print[StringRepeat["=", 60]];
TestFormula2[m_] := Module[{k, denoms, lcmVal, actualDen, match},
  If[!PrimeQ[m], Return[Null]];
  k = Floor[(m-1)/2];
  denoms = Table[2*i+1, {i, 1, k}];
  lcmVal = LCM @@ denoms;

  actualDen = Denominator[ModFactorial[m]];
  If[actualDen == 0, Return[Null]];

  match = (actualDen == lcmVal);

  Print["m=", m, " | LCM of denominators"];
  Print["  Denoms: ", denoms];
  Print["  LCM: ", FactorInteger[lcmVal], " = ", lcmVal];
  Print["  Actual: ", FactorInteger[actualDen], " = ", actualDen];
  Print["  Match: ", If[match, "✓ YES", "✗ NO"]];
  Print[""];

  match
];
results2 = Table[TestFormula2[p], {p, primes}];
Print["Success rate: ", Count[results2, True], "/", Length[results2]];
Print[""];
Print[""];

(* Formula 3: Constructed from p-adic valuations *)
Print["Formula 3: Numerically construct from observed pattern"];
Print[StringRepeat["=", 60]];
TestFormula3[m_] := Module[{k, actualDen, actualFact, constructedDen, constructedFact, match},
  If[!PrimeQ[m], Return[Null]];
  k = Floor[(m-1)/2];

  actualDen = Denominator[ModFactorial[m]];
  If[actualDen == 0, Return[Null]];
  actualFact = FactorInteger[actualDen];

  (* Try to find pattern based on k and m-1 *)
  (* From data: seems related to factorials and double factorials *)

  (* Empirical guess based on m=3,5,7,11,13... *)
  constructedDen = LCM[(m-1)!, 2*Product[2*i+1, {i, 1, k}]];

  constructedFact = FactorInteger[constructedDen];
  match = (actualDen == constructedDen);

  Print["m=", m, " (k=", k, ")"];
  Print["  Actual: ", actualFact, " = ", actualDen];
  Print["  Constructed: ", constructedFact, " = ", constructedDen];
  Print["  Match: ", If[match, "✓ YES", "✗ NO"]];
  Print[""];

  match
];
results3 = Table[TestFormula3[p], {p, primes}];
Print["Success rate: ", Count[results3, True], "/", Length[results3]];
Print[""];

Print["=== RAW DENOMINATORS FOR PATTERN RECOGNITION ==="];
Print[""];
Print["m | den | factorization | k! | (2k+1)!! | (m-1)!"];
Print[StringRepeat["-", 100]];
Do[
  If[PrimeQ[p],
    Module[{k, den, kfact, doublefact, m1fact},
      k = Floor[(p-1)/2];
      den = Denominator[ModFactorial[p]];
      If[den != 0,
        kfact = k!;
        doublefact = Product[2*i+1, {i, 1, k}];
        m1fact = (p-1)!;

        Print[p, " | ", den, " | ", FactorInteger[den], " | ", kfact, " | ", doublefact, " | ", m1fact];
      ];
    ];
  ];
  , {p, primes}
];

Print[""];
Print["=== END ==="];
