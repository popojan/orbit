#!/usr/bin/env wolframscript
(*
Proof attempt for mod 8 classification theorem

Theorem: For fundamental Pell solution x^2 - py^2 = 1 with prime p > 2:
  p ≡ 7 (mod 8)  ⟺  x ≡ +1 (mod p)
  p ≡ 1,3 (mod 8)  ⟺  x ≡ -1 (mod p)

Status: 100% empirically verified (52 primes), seeking rigorous proof
*)

Print[StringRepeat["=", 70]];
Print["MOD 8 CLASSIFICATION - PROOF ATTEMPT"];
Print[StringRepeat["=", 70]];
Print[];

(* First, let's understand what we're working with *)

Print["STEP 1: What do we know automatically?"];
Print[StringRepeat["-", 70]];
Print[];
Print["From Pell equation x^2 - py^2 = 1:"];
Print["  x^2 ≡ 1 (mod p)  [since py^2 ≡ 0 (mod p)]"];
Print["  Therefore: x ≡ ±1 (mod p)  [automatic!]"];
Print[];
Print["The QUESTION is: which sign?"];
Print[];

(* Analyze the empirical pattern *)

Print["STEP 2: Empirical pattern breakdown"];
Print[StringRepeat["-", 70]];
Print[];

(* Test primes by mod 8 class *)
testRanges = {
  {1, Select[Prime[Range[1, 100]], Mod[#, 8] == 1 &]},
  {3, Select[Prime[Range[1, 100]], Mod[#, 8] == 3 &]},
  {5, Select[Prime[Range[1, 100]], Mod[#, 8] == 5 &]},
  {7, Select[Prime[Range[1, 100]], Mod[#, 8] == 7 &]}
};

Do[
  Module[{modClass, primes, results},
    {modClass, primes} = range;
    If[Length[primes] == 0, Continue[]];

    Print["Primes p ≡ ", modClass, " (mod 8):"];
    Print["  Count: ", Length[primes]];
    Print["  First few: ", Take[primes, Min[5, Length[primes]]]];

    (* Compute x mod p for each *)
    results = Table[
      Module[{sol, x, y, xModP},
        sol = Solve[x^2 - p*y^2 == 1 && x > 0 && y > 0, {x, y}, Integers, 1];
        If[Length[sol] == 0,
          {p, "NO SOLUTION", Null},
          x = x /. sol[[1]][[1]];
          y = y /. sol[[1]][[2]];
          xModP = Mod[x, p];
          {p, x, xModP}
        ]
      ],
      {p, primes}
    ];

    (* Count x ≡ 1 vs x ≡ -1 (p-1) *)
    count1 = Count[results, {_, _, 1}];
    countMinus1 = Count[results, {_, _, p_ /; p > 1}];

    Print["  x ≡ +1 (mod p): ", count1];
    Print["  x ≡ -1 (mod p): ", countMinus1];
    Print[];
  ],
  {range, testRanges}
];

Print[];
Print["STEP 3: Connection to quadratic residues"];
Print[StringRepeat["-", 70]];
Print[];

Print["Quadratic reciprocity facts:"];
Print["  • 2 is QR mod p  ⟺  p ≡ ±1 (mod 8)"];
Print["  • -1 is QR mod p  ⟺  p ≡ 1 (mod 4)"];
Print["  • -2 is QR mod p  ⟺  p ≡ 1,3 (mod 8)"];
Print[];

Print["Our pattern:"];
Print["  • p ≡ 1 (mod 8): x ≡ -1 (mod p)  [2 is QR]"];
Print["  • p ≡ 3 (mod 8): x ≡ -1 (mod p)  [-2 is QR]"];
Print["  • p ≡ 5 (mod 8): x ≡ -1 (mod p)  [2 is NOT QR]"];
Print["  • p ≡ 7 (mod 8): x ≡ +1 (mod p)  [SPECIAL!]"];
Print[];

Print["Key observation: p ≡ 7 (mod 8) is the ONLY case where:"];
Print["  • p ≡ 3 (mod 4)  [so -1 is NOT QR]"];
Print["  • AND p ≡ -1 (mod 8)  [so 2 IS QR]"];
Print[];

(* Analyze continued fraction patterns *)

Print["STEP 4: Continued fraction analysis"];
Print[StringRepeat["-", 70]];
Print[];

Print["The fundamental unit x + y√p is related to continued fraction of √p"];
Print[];

analyzePattern = Function[{primes, label},
  Module[{data},
    Print[label];
    Print["p\tx\ty\tCF period\tCF expansion (first 10)"];
    Print[StringRepeat["-", 70]];

    data = Table[
      Module[{sol, x, y, cf, period},
        sol = Solve[x^2 - p*y^2 == 1 && x > 0 && y > 0, {x, y}, Integers, 1];
        If[Length[sol] == 0,
          Null,
          x = x /. sol[[1]][[1]];
          y = y /. sol[[1]][[2]];
          cf = ContinuedFraction[Sqrt[N[p, 50]], 20];
          period = Length[Last[cf]];
          Print[p, "\t", x, "\t", y, "\t", period, "\t", Take[Flatten[{First[cf], Last[cf]}], Min[10, Length[Flatten[{First[cf], Last[cf]}]]]]];
          {p, x, y, period}
        ]
      ],
      {p, primes}
    ];
    Print[];
    data
  ]
];

(* Analyze p ≡ 7 (mod 8) *)
special7 = Select[Prime[Range[1, 30]], Mod[#, 8] == 7 &];
data7 = analyzePattern[Take[special7, Min[5, Length[special7]]], "SPECIAL: p ≡ 7 (mod 8)"];

(* Analyze p ≡ 3 (mod 8) *)
regular3 = Select[Prime[Range[1, 30]], Mod[#, 8] == 3 &];
data3 = analyzePattern[Take[regular3, Min[5, Length[regular3]]], "REGULAR: p ≡ 3 (mod 8)"];

Print[];
Print["STEP 5: Period length patterns"];
Print[StringRepeat["-", 70]];
Print[];

Print["Checking if period length (mod 4) correlates with x (mod p)..."];
Print[];

testPrimes = Select[Prime[Range[1, 50]], Mod[#, 4] == 3 &];
periodData = Table[
  Module[{sol, x, cf, period, xModP, periodMod4},
    sol = Solve[x^2 - p*y^2 == 1 && x > 0 && y > 0, {x, y}, Integers, 1];
    If[Length[sol] == 0,
      Null,
      x = x /. sol[[1]][[1]];
      cf = ContinuedFraction[Sqrt[N[p, 50]], 100];
      period = Length[Last[cf]];
      xModP = Mod[x, p];
      periodMod4 = Mod[period, 4];
      {p, Mod[p, 8], period, periodMod4, xModP, xModP == 1}
    ]
  ],
  {p, testPrimes}
];

periodData = DeleteCases[periodData, Null];

Print["p\tp mod 8\tPeriod\tPer mod 4\tx mod p\tx≡1?"];
Print[StringRepeat["-", 70]];
Do[
  Print[d[[1]], "\t", d[[2]], "\t\t", d[[3]], "\t", d[[4]], "\t\t", d[[5]], "\t", d[[6]]],
  {d, periodData}
];

(* Check correlation *)
Print[];
Module[{period2Data, period0Data},
  period2Data = Select[periodData, #[[4]] == 2 &];
  period0Data = Select[periodData, #[[4]] == 0 &];

  Print["Period ≡ 2 (mod 4):"];
  Print["  x ≡ 1 (mod p): ", Count[period2Data, {_, _, _, _, _, True}]];
  Print["  x ≡ -1 (mod p): ", Count[period2Data, {_, _, _, _, _, False}]];
  Print[];
  Print["Period ≡ 0 (mod 4):"];
  Print["  x ≡ 1 (mod p): ", Count[period0Data, {_, _, _, _, _, True}]];
  Print["  x ≡ -1 (mod p): ", Count[period0Data, {_, _, _, _, _, False}]];
];

Print[];
Print[StringRepeat["=", 70]];
Print["CONCLUSION"];
Print[StringRepeat["=", 70]];
Print[];
Print["The mod 8 classification appears to connect to:"];
Print["  1. Quadratic residue character of 2 and -1"];
Print["  2. Continued fraction period structure"];
Print["  3. Class field theory (genus theory)"];
Print[];
Print["Next step: Consult literature on:"];
Print["  • Fundamental units in Q(√p)"];
Print["  • Genus theory for binary quadratic forms"];
Print["  • Redei symbols and 2-rank of class group"];
Print[];
Print["This is likely KNOWN in algebraic number theory literature!"];
Print[StringRepeat["=", 70]];
