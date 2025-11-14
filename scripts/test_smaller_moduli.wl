#!/usr/bin/env wolframscript
(* Test if Mod[alt[m], 1/smaller!] gives useful structure *)

Print["Testing Alternative Moduli\n"];
Print[StringRepeat["=", 70]];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}];

primes = {3, 5, 7, 11, 13, 17, 19, 23};
composites = {9, 15, 21, 25, 27};

Print["\nFor various moduli, check if primes/composites are distinguished:\n"];

(* Test different moduli *)
moduli = {
  {"(m-1)!", Function[m, (m-1)!]},
  {"((m-1)/2)!", Function[m, Floor[(m-1)/2]!]},
  {"m!", Function[m, m!]},
  {"(m+1)!", Function[m, (m+1)!]}
};

Do[
  {name, modFunc} = modulus;
  Print["\nModulus = 1/", name];
  Print[StringRepeat["-", 70]];

  Print["PRIMES:"];
  primesResults = Table[
    Module[{mod, result, num},
      mod = 1/modFunc[m];
      result = Mod[alt[m], mod];
      num = Numerator[result];
      Print["  m=", m, ": numerator = ", num, If[num == 1, " OK", ""]];
      {m, num}
    ],
    {m, primes}
  ];

  allOnes = AllTrue[primesResults, #[[2]] == 1 &];
  Print["  All primes give numerator=1? ", allOnes];

  Print["\nCOMPOSITES:"];
  compositeResults = Table[
    Module[{mod, result, num},
      mod = 1/modFunc[m];
      result = Mod[alt[m], mod];
      num = Numerator[result];
      Print["  m=", m, ": numerator = ", num, If[num == 0, " (zero)", ""]];
      {m, num}
    ],
    {m, composites}
  ];

  allZero = AllTrue[compositeResults, #[[2]] == 0 &];
  Print["  All composites give 0? ", allZero];

  If[allOnes && allZero,
    Print["\n*** THIS MODULUS WORKS AS PRIMALITY TEST! ***"];
  ];
  ,
  {modulus, moduli}
];

Print["\n" <> StringRepeat["=", 70]];
Print["Summary: Which moduli distinguish primes from composites?\n"];

Print["Done!"];
