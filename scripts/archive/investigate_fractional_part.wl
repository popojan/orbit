(* Deep investigation of the fractional part FractionalPart[Σ_m · (m-1)!] *)

Print["==============================================================================="];
Print["INVESTIGATING FRACTIONAL PART STRUCTURE"];
Print["==============================================================================="];
Print[""];
Print["For prime m, we compute:"];
Print["  FP_m = FractionalPart[Σ_m^alt · (m-1)!]"];
Print["       = Σ_m^alt · (m-1)! - ⌊Σ_m^alt · (m-1)!⌋"];
Print[""];
Print["OBSERVATION: For m=29, FP_29 = 17/29"];
Print[""];
Print["HYPOTHESIS TO TEST:"];
Print["  H1: Denominator always equals m?"];
Print["  H2: Numerator has simple closed form?"];
Print["  H3: Related to m mod something?"];
Print[""];
Print["==============================================================================="];
Print[""];

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

AnalyzeFractionalPart[m_Integer] := Module[{sigma, product, Q, fractionalPart,
  numFP, denFP, factNum, factDen},

  If[!PrimeQ[m], Return[<|"isPrime" -> False|>]];

  sigma = ComputeBareSumAlt[m];
  product = sigma * (m-1)!;
  Q = Floor[product];
  fractionalPart = product - Q;

  If[fractionalPart == 0,
    Return[<|"m" -> m, "isPrime" -> True, "fractionalPart" -> 0, "isZero" -> True|>]
  ];

  numFP = Numerator[fractionalPart];
  denFP = Denominator[fractionalPart];

  factNum = FactorInteger[numFP];
  factDen = FactorInteger[denFP];

  <|
    "m" -> m,
    "k" -> Floor[(m-1)/2],
    "isPrime" -> True,
    "sigma" -> sigma,
    "product" -> product,
    "quotient" -> Q,
    "fractionalPart" -> fractionalPart,
    "numFP" -> numFP,
    "denFP" -> denFP,
    "factNum" -> factNum,
    "factDen" -> factDen,
    "denEqualsM" -> (denFP == m),
    "numModM" -> Mod[numFP, m],
    "mMinusNum" -> m - numFP
  |>
];

(* Compute for many primes *)
primes = Select[Range[3, 41, 2], PrimeQ];

Print["COMPUTING FRACTIONAL PARTS FOR PRIMES 3 TO 41"];
Print[StringRepeat["=", 100]];
Print[""];

results = Table[AnalyzeFractionalPart[p], {p, primes}];

(* Display table *)
Print["m | k | FP | num | den | den=m? | num mod m | m-num"];
Print[StringRepeat["-", 100]];

validResults = Select[results, #["isPrime"] &];

Do[
  r = validResults[[i]];
  Print[
    r["m"], " | ",
    r["k"], " | ",
    r["fractionalPart"], " | ",
    r["numFP"], " | ",
    r["denFP"], " | ",
    If[r["denEqualsM"], "✓", "✗"], " | ",
    r["numModM"], " | ",
    r["mMinusNum"]
  ];
  , {i, 1, Length[validResults]}
];

Print[""];
Print[""];

(* Test hypotheses *)
Print["HYPOTHESIS TESTING"];
Print[StringRepeat["=", 100]];
Print[""];

(* H1: Denominator always equals m *)
h1Results = validResults[[All, "denEqualsM"]];
h1Success = Count[h1Results, True];
Print["H1: Denominator = m"];
Print["  Success rate: ", h1Success, "/", Length[h1Results]];
If[h1Success == Length[h1Results],
  Print["  ✓✓✓ CONFIRMED: Denominator ALWAYS equals m!"],
  Print["  Failed for: ", Select[validResults, !#["denEqualsM"] &][[All, "m"]]]
];
Print[""];

(* H2: Look for pattern in numerators *)
Print["H2: Numerator patterns"];
Print["  Numerators: ", validResults[[All, "numFP"]]];
Print["  m - numerator: ", validResults[[All, "mMinusNum"]]];
Print[""];

(* Check if m - num has a pattern *)
differences = validResults[[All, "mMinusNum"]];
Print["  Analyzing m - num:"];
Print["  Values: ", differences];

(* Check for divisibility patterns *)
Print["  Check if (m - num) is always even: ",
  If[AllTrue[differences, EvenQ], "✓ YES", "✗ NO"]];
Print["  Check if (m - num) always divides m-1: ",
  Table[{validResults[[i]]["m"], Divisible[validResults[[i]]["m"] - 1, validResults[[i]]["mMinusNum"]]},
    {i, 1, Length[validResults]}]];
Print[""];

(* H3: Relation to 2k+1 *)
Print["H3: Relation to k = ⌊(m-1)/2⌋"];
Print["  Check if num = 2k+1:"];
checkNum2kp1 = Table[
  {r["m"], r["k"], r["numFP"], 2*r["k"] + 1, r["numFP"] == 2*r["k"] + 1},
  {r, validResults}
];
Do[
  Print["  m=", checkNum2kp1[[i, 1]], ": num=", checkNum2kp1[[i, 3]],
    ", 2k+1=", checkNum2kp1[[i, 4]], " → ", If[checkNum2kp1[[i, 5]], "✓", "✗"]];
  , {i, 1, Min[10, Length[checkNum2kp1]]}
];
Print[""];

(* Detailed factorizations *)
Print["DETAILED FACTORIZATIONS"];
Print[StringRepeat["=", 100]];
Print[""];

Print["m | FP | num factorization | den factorization"];
Print[StringRepeat["-", 100]];
Do[
  r = validResults[[i]];
  Print[r["m"], " | ", r["fractionalPart"], " | ", r["factNum"], " | ", r["factDen"]];
  , {i, 1, Min[15, Length[validResults]]}
];

Print[""];
Print[""];

(* Ultimate test: Is FP = (2k+1)/m ? *)
Print["ULTIMATE HYPOTHESIS"];
Print[StringRepeat["=", 100]];
Print[""];
Print["Conjecture: FractionalPart[Σ_m · (m-1)!] = (2k+1) / m  where k = ⌊(m-1)/2⌋");
Print[""];

ultimateTest = Table[
  Module[{m, k, expected, actual, match},
    m = r["m"];
    k = r["k"];
    expected = (2*k + 1) / m;
    actual = r["fractionalPart"];
    match = (expected == actual);

    Print["m=", m, ", k=", k, ": FP=", actual, ", (2k+1)/m=", expected, " → ", If[match, "✓", "✗"]];

    match
  ],
  {r, validResults}
];

Print[""];
successRate = Count[ultimateTest, True];
Print["SUCCESS RATE: ", successRate, "/", Length[ultimateTest]];
Print[""];

If[successRate == Length[ultimateTest],
  Print["═══════════════════════════════════════════════════════════════════"];
  Print["✓✓✓ THEOREM DISCOVERED ✓✓✓"];
  Print["═══════════════════════════════════════════════════════════════════"];
  Print[""];
  Print["For prime m ≥ 3, let k = ⌊(m-1)/2⌋. Then:"];
  Print[""];
  Print["  FractionalPart[Σ_m^alt · (m-1)!] = (2k+1) / m"];
  Print[""];
  Print["Equivalently:"];
  Print[""];
  Print["  Σ_m^alt · (m-1)! = Q + (2k+1)/m");
  Print[""];
  Print["where Q is an integer."];
  Print[""];
  Print["COROLLARY: The last term in the alternating sum has denominator 2k+1,"];
  Print["           and this EXACT value appears as the fractional part!");
  Print[""];
  Print["═══════════════════════════════════════════════════════════════════"];
  ,
  Print["Conjecture failed for some primes"];
  failed = Select[Table[{validResults[[i]]["m"], ultimateTest[[i]]}, {i, 1, Length[ultimateTest]}],
    !Last[#] &];
  Print["Failed for m = ", failed[[All, 1]]];
];

Print[""];
Print["==============================================================================="];
Print["END OF INVESTIGATION"];
Print["==============================================================================="];
