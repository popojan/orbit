#!/usr/bin/env wolframscript
(* Analyze the UNREDUCED semiprime sum *)

Print["Unreduced Semiprime Formula Analysis\n"];
Print[StringRepeat["=", 70], "\n"];

AnalyzeUnreducedSemiprime[n_] := Module[{p, q, m, sum, num, denom, gcd,
                                          numRed, denomRed},
  {p, q} = FactorInteger[n][[All, 1]];
  m = Floor[(Sqrt[n] - 1)/2];

  (* Unreduced sum (no Mod[.,1]) *)
  sum = Sum[
    (-1)^i * Pochhammer[1-n, i] * Pochhammer[1+n, i] / (2*i+1),
    {i, 1, m}
  ];

  num = Numerator[sum];
  denom = Denominator[sum];
  gcd = GCD[num, denom];
  numRed = num / gcd;
  denomRed = denom / gcd;

  Print["n = ", n, " = ", p, " × ", q, " (m = ", m, " terms)"];
  Print["  Unreduced: ", num, " / ", denom];
  Print["  GCD: ", gcd];

  (* Factor GCD if small enough *)
  If[gcd < 10^15,
    Print["  GCD factorization: ", FactorInteger[gcd]];
  ];

  Print["  Reduced: ", numRed, " / ", denomRed];
  Print["  Expected: ", (p-1)/p, " = ", Numerator[(p-1)/p], "/", Denominator[(p-1)/p]];
  Print["  Match? ", numRed/denomRed == (p-1)/p];

  (* Check denominator structure *)
  Print["  Denominator factorization: ", FactorInteger[denom]];
  Print["  Does denominator contain p? ", Divisible[denom, p]];
  Print["  ν_p(denom) = ", IntegerExponent[denom, p]];

  (* Check if reduced denominator = p *)
  Print["  Reduced denominator = p? ", denomRed == p];
  Print[];

  {n, p, q, num, denom, gcd, numRed, denomRed}
];

(* Test several semiprimes *)
semiprimes = {15, 21, 35, 55, 77, 91, 143, 221};

results = Table[AnalyzeUnreducedSemiprime[n], {n, semiprimes}];

Print[StringRepeat["=", 70]];
Print["PATTERN ANALYSIS\n"];
Print[StringRepeat["=", 70], "\n"];

Print["Checking patterns:\n"];

Print["1. Are reduced numerators always p-1?"];
Do[
  {n, p, q, num, denom, gcd, numRed, denomRed} = result;
  Print["  n=", n, " (p=", p, "): numRed=", numRed, ", p-1=", p-1,
        " → ", If[numRed == p-1, "YES", "NO"]];
  ,
  {result, results}
];

Print["\n2. Are reduced denominators always p?"];
Do[
  {n, p, q, numRed, denomRed} = result[[{1,2,3,7,8}]];
  Print["  n=", n, " (p=", p, "): denomRed=", denomRed,
        " → ", If[denomRed == p, "YES", "NO"]];
  ,
  {result, results}
];

Print["\n3. GCD structure - does it have a pattern?"];
Print["n | p | q | GCD | GCD/q | Other factors"];
Print[StringRepeat["-", 70]];

Do[
  {n, p, q, gcd} = result[[{1,2,3,6}]];
  ratio = If[Divisible[gcd, q], gcd/q, "not divisible"];
  gcdFact = If[gcd < 10^15, FactorInteger[gcd], "too large"];
  Print[n, " | ", p, " | ", q, " | ", gcd, " | ", ratio, " | ", gcdFact];
  ,
  {result, results}
];

Print["\nDone! Looking for GCD pattern like primorial formula...");
