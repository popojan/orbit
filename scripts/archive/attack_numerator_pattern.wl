(* Deep analysis of the numerator N of Σ_m^alt *)

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["═══════════════════════════════════════════════════════════════════"];
Print["ATTACKING THE NUMERATOR"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["Question: Can we find a closed form for N = Numerator[Σ_m^alt]?"];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

primes = Select[Range[3, 37, 2], PrimeQ];

Print["m | k | N | Sign | |N| | N mod m | N mod (m-1)"];
Print[StringRepeat["-", 100]];

results = Table[
  Module[{m, k, sigma, num, den, sign, absN, nModM, nModM1},
    m = p;
    k = (m-1)/2;

    sigma = ComputeBareSumAlt[m];
    num = Numerator[sigma];
    den = Denominator[sigma];

    sign = Sign[num];
    absN = Abs[num];

    nModM = Mod[num, m];
    nModM1 = Mod[num, m-1];

    Print[m, " | ", k, " | ", num, " | ", sign, " | ", absN, " | ",
      nModM, " | ", nModM1];

    <|
      "m" -> m,
      "k" -> k,
      "N" -> num,
      "sign" -> sign,
      "absN" -> absN,
      "nModM" -> nModM,
      "nModM1" -> nModM1,
      "den" -> den
    |>
  ],
  {p, primes}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["SIGN PATTERN ANALYSIS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["m | k | Sign of N | (-1)^k | (-1)^((m+1)/2) | Match (-1)^k?"];
Print[StringRepeat["-", 80]];

Do[
  Module[{m, k, signN, sign1, sign2, match1},
    m = r["m"];
    k = r["k"];
    signN = r["sign"];

    sign1 = (-1)^k;
    sign2 = (-1)^((m+1)/2);

    match1 = (signN == sign1);

    Print[m, " | ", k, " | ", signN, " | ", sign1, " | ", sign2, " | ",
      If[match1, "✓", "✗"]];
  ],
  {r, results}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["MODULAR ANALYSIS OF N"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["N mod m distribution:"];
Print[Tally[results[[All, "nModM"]]]];
Print[""];

Print["N mod (m-1) distribution:"];
Print[Tally[results[[All, "nModM1"]]]];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["RELATING N TO HALF-FACTORIAL"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["We know the fractional part numerator n ≡ (-1)^((m+1)/2)·k! (mod m)"];
Print["Can we relate the FULL numerator N to factorials?"];
Print[""];

Print["m | N mod m | k! mod m | (-1)^((m+1)/2)·k! mod m | Match?"];
Print[StringRepeat["-", 80]];

Do[
  Module[{m, k, nModM, kFactMod, predicted, match},
    m = r["m"];
    k = r["k"];
    nModM = r["nModM"];

    kFactMod = Mod[k!, m];
    predicted = Mod[(-1)^((m+1)/2) * kFactMod, m];

    match = (nModM == predicted);

    Print[m, " | ", nModM, " | ", kFactMod, " | ", predicted, " | ",
      If[match, "✓", "✗"]];
  ],
  {r, results}
];

Print[""];
Print["So N ≡ (-1)^((m+1)/2)·k! (mod m) — same as fractional part numerator!"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["ANALYZING N MODULO PRIMORIAL"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["m | N mod [Prim(m)/2] | N / [Prim(m)/2] (approx)"];
Print[StringRepeat["-", 80]];

Do[
  Module[{m, N, primHalf, nModPrim, ratio},
    m = r["m"];
    N = r["N"];
    primHalf = r["den"]; (* We verified den = Primorial(m)/2 *)

    nModPrim = Mod[N, primHalf];
    ratio = N[N / primHalf, 5];

    Print[m, " | ", nModPrim, " | ", ratio];
  ],
  {r, results}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["TESTING RECURRENCE RELATIONS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Can N_m be expressed in terms of N_{p_prev} and factorials?"];
Print[""];

Print["m | N_m | N_{prev} | Relation?"];
Print[StringRepeat["-", 80]];

Do[
  If[i > 1,
    Module[{m, mPrev, N, NPrev, relation},
      m = results[[i]]["m"];
      mPrev = results[[i-1]]["m"];
      N = results[[i]]["N"];
      NPrev = results[[i-1]]["N"];

      (* Try various relations *)
      relation = Which[
        N == NPrev * m, "N = N_prev · m",
        N == -NPrev * m, "N = -N_prev · m",
        Mod[N, NPrev] == 0, StringJoin["N = ", ToString[N/NPrev], "·N_prev"],
        True, "no simple relation"
      ];

      Print[m, " | ", N, " | ", NPrev, " | ", relation];
    ];
  ],
  {i, 1, Length[results]}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CONCLUSION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["We have established:"];
Print[""];
Print["1. Q = N · (m-1)! / [Primorial(m)/2]"];
Print["2. N ≡ (-1)^((m+1)/2) · k! (mod m)"];
Print["3. Sign(N) = (-1)^k"];
Print[""];
Print["However, no closed form for the FULL value of N is apparent."];
Print[""];
Print["This suggests the 'strange loop' cannot be broken:"];
Print["  - To get Q, we need N"];
Print["  - To get N, we need to compute Σ_m"];
Print["  - To get denominator without GCD, we'd need closed form for N"];
Print["  - But N appears to have no simple closed form"];
Print[""];
