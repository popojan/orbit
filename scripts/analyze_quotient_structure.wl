(* Attack the quotient Q in: Σ_m · (m-1)! = Q + n/m *)

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["═══════════════════════════════════════════════════════════════════"];
Print["ATTACKING THE QUOTIENT"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["For prime m: Σ_m · (m-1)! = Q + n/m"];
Print[""];
Print["We know: n ≡ (-1)^((m+1)/2) · ((m-1)/2)! (mod m)"];
Print["Question: What is Q?"];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

primes = Select[Range[3, 31, 2], PrimeQ];

Print["m | k | Q | Q mod m | Q mod (m-1) | Factorization of Q"];
Print[StringRepeat["-", 100]];

results = Table[
  Module[{m, k, sigma, product, fpPart, n, Q, qModM, qModM1, factorQ},
    m = p;
    k = (m-1)/2;

    (* Compute full product *)
    sigma = ComputeBareSumAlt[m];
    product = sigma * (m-1)!;

    (* Extract fractional part *)
    fpPart = FractionalPart[product];
    n = Numerator[fpPart];

    (* Quotient *)
    Q = product - fpPart;

    (* Q modulo m and m-1 *)
    qModM = Mod[Q, m];
    qModM1 = Mod[Q, m-1];

    (* Factor Q (only if not too large) *)
    factorQ = If[Abs[Q] < 10^15, FactorInteger[Q], "too large"];

    Print[m, " | ", k, " | ", Q, " | ", qModM, " | ", qModM1, " | ",
      If[factorQ === "too large", "...", factorQ]];

    <|
      "m" -> m,
      "k" -> k,
      "Q" -> Q,
      "qModM" -> qModM,
      "qModM1" -> qModM1,
      "factorQ" -> factorQ
    |>
  ],
  {p, primes}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["PATTERN ANALYSIS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

(* Check if Q ≡ 0 mod m *)
Print["Does Q ≡ 0 (mod m)?"];
qModMZeros = Count[results[[All, "qModM"]], 0];
Print["  ", qModMZeros, "/", Length[results], " cases"];
Print[""];

(* Check Q mod (m-1) *)
Print["Distribution of Q mod (m-1):"];
qModM1Dist = Tally[results[[All, "qModM1"]]];
Print["  ", qModM1Dist];
Print[""];

(* Analyze Q in terms of factorials *)
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["RELATING Q TO FACTORIALS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["m | Q / (m-1)! | Q / ((m-1)/2)! | Pattern"];
Print[StringRepeat["-", 80]];

Do[
  Module[{m, k, Q, ratioM1, ratioK, pattern},
    m = r["m"];
    k = r["k"];
    Q = r["Q"];

    (* Q divided by factorials *)
    ratioM1 = Q / (m-1)!;
    ratioK = Q / k!;

    (* Check patterns *)
    pattern = Which[
      IntegerQ[ratioM1], "Q = c·(m-1)!",
      IntegerQ[ratioK], "Q = c·k!",
      Denominator[ratioM1] == m, "Q = c·(m-1)!/m",
      Denominator[ratioK] == m, "Q = c·k!/m",
      True, "other"
    ];

    Print[m, " | ", N[ratioM1, 3], " | ", N[ratioK, 3], " | ", pattern];
  ],
  {r, results}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["TESTING: Q = (Σ_m - n/m) · (m-1)!"];
Print["       = (Σ_m · (m-1)! - n) / (denom of Σ_m)"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["m | Den(Σ_m) | Primorial(m)/2 | Match? | Den(Σ_m)·m | Primorial(m)·m/2"];
Print[StringRepeat["-", 100]];

Do[
  Module[{m, sigma, denSigma, primHalf, match, denTimesM, primTimesM},
    m = r["m"];
    sigma = ComputeBareSumAlt[m];

    denSigma = Denominator[sigma];
    primHalf = Product[Prime[i], {i, 2, PrimePi[m]}]; (* Primorial(m)/2 *)

    match = (denSigma == primHalf);

    denTimesM = denSigma * m;
    primTimesM = primHalf * m;

    Print[m, " | ", denSigma, " | ", primHalf, " | ", If[match, "✓", "✗"],
      " | ", denTimesM, " | ", primTimesM];
  ],
  {r, results}
];

Print[""];
Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["KEY INSIGHT: Q STRUCTURE"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Q = Σ_m · (m-1)! - n/m"];
Print["  = [Σ_m · (m-1)! · m - n] / m"];
Print["  = [numerator of (Σ_m · (m-1)! · m)] / m - n/m"];
Print[""];
Print["Since Σ_m = N/D where D = Primorial(m)/2, we have:"];
Print["Q = N · (m-1)! / D - n/m"];
Print["  = N · (m-1)! / [Primorial(m)/2] - n/m"];
Print[""];

Print["m | N (num of Σ_m) | N · (m-1)! / [Prim(m)/2] | Expected Q | Match?"];
Print[StringRepeat["-", 100]];

Do[
  Module[{m, sigma, numSigma, denSigma, expectedQ, actualQ, match},
    m = r["m"];
    sigma = ComputeBareSumAlt[m];
    actualQ = r["Q"];

    numSigma = Numerator[sigma];
    denSigma = Denominator[sigma];

    (* Expected Q = numerator * (m-1)! / denominator *)
    expectedQ = numSigma * (m-1)! / denSigma;

    match = (expectedQ == actualQ);

    Print[m, " | ", numSigma, " | ", expectedQ, " | ", actualQ, " | ",
      If[match, "✓", "✗"]];
  ],
  {r, results}
];

Print[""];
Print["So Q = N · (m-1)! / [Primorial(m)/2]"];
Print[""];
Print["The question becomes: Can we find a closed form for N (numerator of Σ_m)?"];
Print[""];
