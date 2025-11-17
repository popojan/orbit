#!/usr/bin/env wolframscript
(*
Comprehensive analysis of primes mod 4 and the x ≡ -1 (mod p) property
Goal: Understand why some p ≡ 3 (mod 4) are "special" with x ≡ +1 (mod p)
*)

Print["=" <> StringRepeat["=", 69]];
Print["COMPREHENSIVE PRIME MOD 4 ANALYSIS"];
Print["=" <> StringRepeat["=", 69]];
Print[];

(* Test first 50 primes *)
testPrimes = Prime[Range[1, 50]];

Print["Analyzing first 50 primes..."];
Print[];

data = Table[
  Module[{sol, x, y, xMod, xIsMinusOne, xIsPlusOne, mod4, pellNorm},
    (* Solve Pell equation *)
    sol = Solve[x^2 - p*y^2 == 1 && x > 0 && y > 0 && x < 10^30, {x, y}, Integers];

    If[Length[sol] > 0,
      {x, y} = {x, y} /. sol[[1]];
      xMod = Mod[x, p];
      xIsMinusOne = (xMod == p - 1);
      xIsPlusOne = (xMod == 1);
      mod4 = Mod[p, 4];
      pellNorm = x^2 - p*y^2;

      {p, mod4, x, y, xMod, xIsMinusOne, xIsPlusOne, pellNorm}
    ,
      {p, Mod[p, 4], "NO SOLUTION", "NO SOLUTION", "N/A", False, False, "N/A"}
    ]
  ],
  {p, testPrimes}
];

Print["p\tmod4\tx\t\ty\t\tx mod p\tx≡-1?\tx≡+1?"];
Print[StringRepeat["-", 100]];

Do[
  Print[row[[1]], "\t", row[[2]], "\t",
        If[IntegerQ[row[[3]]], row[[3]], "N/A"], "\t",
        If[IntegerQ[row[[4]]], row[[4]], "N/A"], "\t",
        row[[5]], "\t\t", row[[6]], "\t", row[[7]]],
  {row, data}
];

Print[];
Print[StringRepeat["=", 69]];
Print["STATISTICS"];
Print[StringRepeat["=", 69]];
Print[];

(* Classify primes *)
mod1Primes = Select[data, #[[2]] == 1 &];
mod3Primes = Select[data, #[[2]] == 3 &];

Print["Primes p ≡ 1 (mod 4): ", Length[mod1Primes]];
Print["  with x ≡ -1 (mod p): ", Count[mod1Primes, {_, _, _, _, _, True, _}]];
Print["  with x ≡ +1 (mod p): ", Count[mod1Primes, {_, _, _, _, _, _, True}]];
Print[];

Print["Primes p ≡ 3 (mod 4): ", Length[mod3Primes]];
Print["  with x ≡ -1 (mod p): ", Count[mod3Primes, {_, _, _, _, _, True, _}]];
Print["  with x ≡ +1 (mod p): ", Count[mod3Primes, {_, _, _, _, _, _, True}]];
Print[];

(* List special primes (p ≡ 3 mod 4 with x ≡ +1 mod p) *)
specialPrimes = Select[data, #[[2]] == 3 && #[[7]] == True &];
Print["SPECIAL primes (p ≡ 3 mod 4 AND x ≡ +1 mod p):"];
Print["  ", specialPrimes[[All, 1]]];
Print[];

(* List regular primes p ≡ 3 mod 4 with x ≡ -1 mod p *)
regularMod3 = Select[data, #[[2]] == 3 && #[[6]] == True &];
Print["REGULAR primes (p ≡ 3 mod 4 AND x ≡ -1 mod p):"];
Print["  ", regularMod3[[All, 1]]];
Print[];

Print[StringRepeat["=", 69]];
Print["PATTERN INVESTIGATION: SPECIAL PRIMES"];
Print[StringRepeat["=", 69]];
Print[];

(* Analyze special primes more deeply *)
If[Length[specialPrimes] > 0,
  Print["Analyzing special primes in detail..."];
  Print[];

  Do[
    Module[{p, x, y, properties},
      {p, _, x, y, _, _, _} = prime;

      Print["p = ", p, ":"];
      Print["  x = ", x, ", y = ", y];
      Print["  x mod p = ", Mod[x, p]];
      Print["  x + 1 mod p = ", Mod[x + 1, p]];
      Print["  2 + x mod p = ", Mod[2 + x, p]];
      Print["  p mod 8 = ", Mod[p, 8]];
      Print["  p in form 4k+3 where k = ", (p-3)/4];

      (* Check if (p-3)/4 has special properties *)
      Module[{k, kFactors},
        k = (p - 3)/4;
        kFactors = FactorInteger[k];
        Print["  k = (p-3)/4 = ", k, " = ", kFactors];
      ];

      Print[];
    ],
    {prime, specialPrimes}
  ];
];

Print[StringRepeat["=", 69]];
Print["SEQUENCE ANALYSIS"];
Print[StringRepeat["=", 69]];
Print[];

(* Check if special primes form a pattern *)
If[Length[specialPrimes] >= 2,
  Module[{specialPs, diffs, ratios},
    specialPs = specialPrimes[[All, 1]];
    diffs = Differences[specialPs];
    ratios = Table[specialPs[[i+1]]/specialPs[[i]], {i, 1, Length[specialPs]-1}];

    Print["Special primes: ", specialPs];
    Print["Differences: ", diffs];
    Print["Ratios: ", N[ratios, 5]];
    Print[];

    (* Check OEIS for this sequence *)
    Print["Sequence to check in OEIS: ", specialPs];
  ];
];

Print[StringRepeat["=", 69]];
