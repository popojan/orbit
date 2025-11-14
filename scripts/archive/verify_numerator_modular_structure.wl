(* Verify and use the modular structure of N *)

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["═══════════════════════════════════════════════════════════════════"];
Print["CLARIFYING N vs n (numerator of Σ_m vs fractional part numerator)"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

primes = Select[Range[3, 23, 2], PrimeQ];

Print["m | N (num of Σ_m) | n (FP num) | N mod m | n mod m | n from formula"];
Print[StringRepeat["-", 100]];

results = Table[
  Module[{m, k, sigma, numSigma, product, fpNum, nModM, NModM, nFormula},
    m = p;
    k = (m-1)/2;

    (* Numerator of Σ_m *)
    sigma = ComputeBareSumAlt[m];
    numSigma = Numerator[sigma];

    (* Fractional part numerator *)
    product = sigma * (m-1)!;
    fpNum = Numerator[FractionalPart[product]];

    (* Modular values *)
    NModM = Mod[numSigma, m];
    nModM = Mod[fpNum, m];

    (* Formula for n *)
    nFormula = Mod[(-1)^((m+1)/2) * k!, m];

    Print[m, " | ", numSigma, " | ", fpNum, " | ", NModM, " | ",
      nModM, " | ", nFormula, If[nModM == nFormula, " ✓", " ✗"]];

    <|
      "m" -> m,
      "k" -> k,
      "N" -> numSigma,
      "n" -> fpNum,
      "NModM" -> NModM,
      "nModM" -> nModM,
      "nFormula" -> nFormula,
      "den" -> Denominator[sigma]
    |>
  ],
  {p, primes}
];

Print[""];
Print["Confirmed: n ≡ (-1)^((m+1)/2)·k! (mod m) for FRACTIONAL PART numerator"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CAN WE RELATE N (numerator of Σ_m) TO n (FP numerator)?"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["We have: Σ_m · (m-1)! = Q + n/m"];
Print["         N/D · (m-1)! = Q + n/m   where D = Primorial(m)/2"];
Print["         N·(m-1)!/D = Q + n/m"];
Print["         N·(m-1)! = Q·D + n·D/m"];
Print[""];
Print["Taking mod m:"];
Print["         N·(m-1)! ≡ n·D/m (mod m)  [since Q·D is divisible by m if...]"];
Print[""];

Print["m | N·(m-1)! mod m | n·D/m mod m | D mod m | Match?"];
Print[StringRepeat["-", 80]];

Do[
  Module[{m, N, n, D, lhs, rhs, DMod, match},
    m = r["m"];
    N = r["N"];
    n = r["n"];
    D = r["den"];

    lhs = Mod[N * (m-1)!, m];
    DMod = Mod[D, m];

    (* n·D/m mod m *)
    rhs = Mod[n * D / m, m];

    match = (lhs == rhs);

    Print[m, " | ", lhs, " | ", rhs, " | ", DMod, " | ",
      If[match, "✓", "✗"]];
  ],
  {r, results}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["USING WILSON: (m-1)! ≡ -1 (mod m)"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["m | N·(-1) mod m | N mod m | -N mod m | n·D/m mod m"];
Print[StringRepeat["-", 80]];

Do[
  Module[{m, N, n, D, lhsWilson, NMod, negNMod, rhs},
    m = r["m"];
    N = r["N"];
    n = r["n"];
    D = r["den"];

    lhsWilson = Mod[N * (-1), m];
    NMod = Mod[N, m];
    negNMod = Mod[-N, m];
    rhs = Mod[n * D / m, m];

    Print[m, " | ", lhsWilson, " | ", NMod, " | ", negNMod, " | ", rhs];
  ],
  {r, results}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["KEY QUESTION: IS THERE A MODULAR RELATIONSHIP?"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["We need: N mod [Primorial(m)/2]"];
Print[""];
Print["But Primorial(m)/2 is HUGE - this doesn't help us compute N!"];
Print[""];
Print["The strange loop persists:"];
Print["  - To break it, we'd need N mod D where D = Primorial(m)/2"];
Print["  - But N < D, so N mod D = N (trivial)"];
Print["  - Knowing N mod m is insufficient to recover N"];
Print[""];
Print["CONCLUSION: The circle cannot be broken this way."];
Print[""];
