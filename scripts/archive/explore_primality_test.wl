#!/usr/bin/env wolframscript
(* Explore the primality test: Mod[alt[m], 1/(m-1)!] *)

Print["======================================================================"];
Print["Exploring Primality Test via Mod[alt[m], 1/(m-1)!]"];
Print["======================================================================\n"];

(* Define alternating formula *)
alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}] /; m >= 3;

(* Test function *)
TestPrimality[m_] := Module[{result, num, denom, factorization},
  result = Mod[alt[m], 1/(m-1)!];

  If[result == 0,
    <|
      "m" -> m,
      "Prime?" -> PrimeQ[m],
      "Result" -> "0",
      "Numerator" -> 0,
      "Denominator" -> 0,
      "Factorization" -> "N/A"
    |>,
    num = Numerator[result];
    denom = Denominator[result];
    factorization = If[denom < 10^15, FactorInteger[denom], "TooLarge"];

    <|
      "m" -> m,
      "Prime?" -> PrimeQ[m],
      "Result" -> result,
      "Numerator" -> num,
      "Denominator" -> denom,
      "Factorization" -> factorization
    |>
  ]
];

(* Test for range of odd m *)
Print["Testing m = 3 to 31:\n"];

results = Table[TestPrimality[m], {m, 3, 31, 2}];

(* Display results *)
Print["m | Prime? | Numerator | Denominator | Factorization"];
Print[StringRepeat["-", 70]];

Do[
  m = result["m"];
  isPrime = result["Prime?"];
  num = result["Numerator"];
  denom = result["Denominator"];
  fact = result["Factorization"];

  Print[StringPadRight[ToString[m], 2], " | ",
        StringPadRight[ToString[isPrime], 6], " | ",
        StringPadRight[ToString[num], 9], " | ",
        StringPadRight[ToString[denom], 11], " | ",
        fact];
  ,
  {result, results}
];

(* Analyze the pattern *)
Print["\n======================================================================"];
Print["ANALYSIS"];
Print["======================================================================\n"];

primeResults = Select[results, #["Prime?"] &];
compositeResults = Select[results, !#["Prime?"] &];

Print["PRIMES (m is prime):\n"];
Do[
  m = result["m"];
  denom = result["Denominator"];
  fact = result["Factorization"];

  If[fact =!= "TooLarge" && fact =!= "N/A",
    (* Extract power of m *)
    mPower = SelectFirst[fact, #[[1]] == m &, {m, 0}][[2]];

    Print["m=", m, ": Denominator = ", m, "^", mPower];

    (* Check for other prime factors *)
    otherFactors = Select[fact, #[[1]] != m &];
    If[Length[otherFactors] > 0,
      Print["  Other factors: ", otherFactors];
    ];
  ];
  ,
  {result, primeResults}
];

Print["\nCOMPOSITES (m is composite):\n"];
Print["All return 0? ", AllTrue[compositeResults, #["Result"] == "0" &]];

(* Check the power pattern for primes *)
Print["\n======================================================================"];
Print["POWER PATTERN FOR PRIMES"];
Print["======================================================================\n"];

Print["For prime m, denominator appears to be m^k for some k.\n"];

powerData = Table[
  Module[{result, m, denom, fact, mPower},
    result = TestPrimality[m];
    denom = result["Denominator"];
    fact = result["Factorization"];

    If[fact =!= "TooLarge" && fact =!= "N/A" && Length[fact] > 0,
      mPower = SelectFirst[fact, #[[1]] == m &, {m, 0}][[2]];
      {m, mPower, denom == m^mPower}
    ]
  ],
  {m, Select[Range[3, 41, 2], PrimeQ]}
];

Print["m | Power k | Is m^k?"];
Print[StringRepeat["-", 30]];
Do[
  If[data =!= Null,
    {m, power, exact} = data;
    Print[StringPadRight[ToString[m], 2], " | ",
          StringPadRight[ToString[power], 7], " | ",
          exact];
  ];
  ,
  {data, powerData}
];

(* Look for pattern in powers *)
Print["\nPower sequence: ", powerData[[All, 2]]];

(* Test relationship to (m-1)/2 *)
Print["\nCompare power k to (m-1)/2:"];
Do[
  If[data =!= Null,
    {m, power, _} = data;
    k = (m-1)/2;
    Print["m=", m, ": k=", power, ", (m-1)/2=", k, ", difference=", power - k];
  ];
  ,
  {data, powerData}
];

Print["\nDone!"];
