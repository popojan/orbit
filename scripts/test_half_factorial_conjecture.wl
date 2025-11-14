(* Test conjecture: Fractional part numerator = half-factorial structure *)

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["═══════════════════════════════════════════════════════════════════"];
Print["TESTING: Numerator = (-1)^((m+1)/2) · ((m-1)/2)! mod m"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

primes = Select[Range[3, 61, 2], PrimeQ];

Print["m | FP num | ((m-1)/2)! mod m | (-1)^((m+1)/2) · HF | Match? | m mod 4"];
Print[StringRepeat["-", 90]];

results = Table[
  Module[{m, k, sigma, product, fpNum, halfFact, halfFactMod, predicted, match, mMod4, sign},
    m = p;
    k = (m-1)/2;  (* For odd prime, this is exact *)

    (* Actual fractional part numerator *)
    sigma = ComputeBareSumAlt[m];
    product = sigma * (m-1)!;
    fpNum = Numerator[Mod[product, 1]];

    (* Half-factorial mod m *)
    halfFact = k!;
    halfFactMod = Mod[halfFact, m];

    (* Sign factor *)
    sign = (-1)^((m+1)/2);

    (* Predicted value *)
    predicted = Mod[sign * halfFactMod, m];

    (* Check match *)
    match = (fpNum == predicted);
    mMod4 = Mod[m, 4];

    Print[m, " | ", fpNum, " | ", halfFactMod, " | ", predicted, " | ",
      If[match, "✓", "✗"], " | ", mMod4];

    <|
      "m" -> m,
      "k" -> k,
      "fpNum" -> fpNum,
      "halfFactMod" -> halfFactMod,
      "predicted" -> predicted,
      "match" -> match,
      "mMod4" -> mMod4,
      "sign" -> sign
    |>
  ],
  {p, primes}
];

Print[""];
successRate = Count[results[[All, "match"]], True];
Print["SUCCESS RATE: ", successRate, "/", Length[results]];
Print[""];

If[successRate == Length[results],
  Print["✓✓✓ CONJECTURE VERIFIED! ✓✓✓"];
  Print[""];
  Print["The fractional part numerator IS the half-factorial with sign!"];
  ,
  Print["Conjecture failed. Analyzing failures..."];
  Print[""];
  failures = Select[results, !#["match"] &];
  Print["Failed for:"];
  Do[
    Print["  m=", f["m"], ": observed=", f["fpNum"], ", predicted=", f["predicted"],
      ", diff=", f["fpNum"] - f["predicted"]];
    , {f, failures[[1;;Min[10, Length[failures]]]]}
  ];
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["ANALYZING BY QUADRATIC CHARACTER"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

(* Separate by m mod 4 *)
mod1Primes = Select[results, #["mMod4"] == 1 &];
mod3Primes = Select[results, #["mMod4"] == 3 &];

Print["For primes m ≡ 1 (mod 4):"];
Print["  Sign factor (-1)^((m+1)/2) = (-1)^(even/2) = 1"];
Print["  Number of primes: ", Length[mod1Primes]];
Print["  Matches: ", Count[mod1Primes[[All, "match"]], True], "/", Length[mod1Primes]];
Print[""];

Print["m | FP num | ((m-1)/2)! mod m | Match?"];
Print[StringRepeat["-", 50]];
Do[
  r = mod1Primes[[i]];
  Print[r["m"], " | ", r["fpNum"], " | ", r["halfFactMod"], " | ",
    If[r["match"], "✓", "✗"]];
  , {i, 1, Min[8, Length[mod1Primes]]}
];

Print[""];
Print["For primes m ≡ 3 (mod 4):"];
Print["  Sign factor (-1)^((m+1)/2) = (-1)^(odd/2) = -1"];
Print["  Number of primes: ", Length[mod3Primes]];
Print["  Matches: ", Count[mod3Primes[[All, "match"]], True], "/", Length[mod3Primes]];
Print[""];

Print["m | FP num | ((m-1)/2)! mod m | -((m-1)/2)! mod m | Match?"];
Print[StringRepeat["-", 70]];
Do[
  r = mod3Primes[[i]];
  negHF = Mod[-r["halfFactMod"], r["m"]];
  Print[r["m"], " | ", r["fpNum"], " | ", r["halfFactMod"], " | ", negHF, " | ",
    If[r["match"], "✓", "✗"]];
  , {i, 1, Min[8, Length[mod3Primes]]}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CHECKING STICKELBERGER RELATION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["For m ≡ 1 (mod 4), ((m-1)/2)! should be ±√(-1) mod m"];
Print[""];

Print["m | ((m-1)/2)! mod m | Square mod m | Equals -1?"];
Print[StringRepeat["-", 60]];

Do[
  r = mod1Primes[[i]];
  square = Mod[r["halfFactMod"]^2, r["m"]];
  isMinusOne = (square == r["m"] - 1);

  Print[r["m"], " | ", r["halfFactMod"], " | ", square, " | ",
    If[isMinusOne, "✓ YES", "✗ NO"]];
  , {i, 1, Min[10, Length[mod1Primes]]}
];

Print[""];
Print["For m ≡ 3 (mod 4), ((m-1)/2)! should be ±1 mod m");
Print[""];

Print["m | ((m-1)/2)! mod m | Equals ±1?"];
Print[StringRepeat["-", 50]];

Do[
  r = mod3Primes[[i]];
  isPlusMinusOne = (r["halfFactMod"] == 1 || r["halfFactMod"] == r["m"] - 1);

  Print[r["m"], " | ", r["halfFactMod"], " | ",
    If[isPlusMinusOne, "✓ YES", "✗ NO"]];
  , {i, 1, Min[10, Length[mod3Primes]]}
];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
