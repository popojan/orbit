#!/usr/bin/env wolframscript
(* Investigate Wilson connection via half-factorials *)

Print["Wilson's Theorem and Half-Factorials\n"];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}];

primes = Select[Range[3, 31, 2], PrimeQ];

Print["For prime p, Wilson says (p-1)! == -1 (mod p)"];
Print["What about ((p-1)/2)! mod p?\n"];

Print["p | (p-1)! mod p | ((p-1)/2)! mod p | ((p-1)/2)!^2 mod p | p mod 4"];
Print[StringRepeat["-", 75]];

Do[
  Module[{h, wilsonVal, halfFact, halfSq, pMod4},
    h = (p-1)/2;
    wilsonVal = Mod[(p-1)!, p];
    halfFact = Mod[h!, p];
    halfSq = Mod[halfFact^2, p];
    pMod4 = Mod[p, 4];

    Print[StringPadRight[ToString[p], 2], " | ",
          StringPadRight[ToString[wilsonVal], 13], " | ",
          StringPadRight[ToString[halfFact], 18], " | ",
          StringPadRight[ToString[halfSq], 19], " | ",
          pMod4];
  ],
  {p, primes}
];

Print["\nKey observation: For p == 3 (mod 4):"];
Print["  ((p-1)/2)! == ±1 (mod p)");
Print["  and ((p-1)/2)!^2 == 1 (mod p)");

Print["\nFor p == 1 (mod 4):"];
Print["  ((p-1)/2)! == ±i (mod p) where i^2 = -1 mod p");
Print["  and ((p-1)/2)!^2 == -1 (mod p)\n");

Print["Connection to alt[m] sum limits:");
Print["  alt[p] sums from k=1 to k=(p-1)/2"];
Print["  The largest factorial is ((p-1)/2)!"];
Print["  This factorial has special Wilson properties mod p!\n"];

Print["Analyzing alt[p] mod p for small primes:\n"];

Print["p | alt[p] mod p | ((p-1)/2)! mod p | Relationship?"];
Print[StringRepeat["-", 60]];

Do[
  Module[{h, altModP, halfFactModP},
    h = (p-1)/2;
    altModP = Mod[alt[p], p];
    halfFactModP = Mod[h!, p];

    Print[StringPadRight[ToString[p], 2], " | ",
          StringPadRight[ToString[altModP], 12], " | ",
          StringPadRight[ToString[halfFactModP], 18], " | ",
          If[altModP == halfFactModP, "EQUAL",
          If[altModP == Mod[-halfFactModP, p], "NEGATIVE",
          If[Mod[altModP * halfFactModP, p] == Mod[-1, p], "PRODUCT=-1", "other"]]]];
  ],
  {p, Take[primes, 10]}
];

Print["\nDone!"];
