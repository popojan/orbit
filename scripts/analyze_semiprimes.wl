#!/usr/bin/env wolframscript
(* SEMIPRIME ANALYSIS: n = p×q, connecting multiplicative & additive structure *)

Print[StringRepeat["=", 80]];
Print["SEMIPRIME ANALYSIS: R(p×q) vs. mod 4 structure of factors"];
Print[StringRepeat["=", 80]];
Print[];

PellSol[D_] := Module[{sol},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];
  sol = Solve[x^2 - D*y^2 == 1, {x, y}, PositiveIntegers] /. C[1] -> 1;
  If[sol === {}, {0, 0}, {x, y} /. First[sol]]
]

Reg[D_] := Module[{sol, x, y},
  sol = PellSol[D];
  {x, y} = sol;
  If[x > 1, N[Log[x + y*Sqrt[D]], 15], 0.0]
]

(* Sum of squares check *)
IsSumOfTwoSquares[n_] := Module[{a, b2, maxA, found},
  maxA = Floor[Sqrt[n]];
  found = False;
  Do[
    b2 = n - a^2;
    If[b2 >= 0 && IntegerQ[Sqrt[b2]], found = True; Break[]];
    ,
    {a, 0, maxA}
  ];
  found
]

(* Generate semiprimes p*q with p < q < 100 *)
Print["Generating semiprimes p*q with p, q < 100..."];
Print[];

primes = Select[Range[3, 97], PrimeQ];

data = Flatten[Table[
  Module[{n, R, pMod4, qMod4, bothMod1, oneMod1, bothMod3,
          isSOS, k, c, mod4, mod8},
    n = p * q;
    R = Reg[n];

    If[R > 0,
      pMod4 = Mod[p, 4];
      qMod4 = Mod[q, 4];

      (* Classify by factor mod 4 structure *)
      bothMod1 = (pMod4 == 1 && qMod4 == 1);
      oneMod1 = (pMod4 == 1 && qMod4 == 3) || (pMod4 == 3 && qMod4 == 1);
      bothMod3 = (pMod4 == 3 && qMod4 == 3);

      isSOS = IsSumOfTwoSquares[n];
      k = Floor[Sqrt[n]];
      c = n - k^2;
      mod4 = Mod[n, 4];
      mod8 = Mod[n, 8];

      {n, p, q, R, pMod4, qMod4, bothMod1, oneMod1, bothMod3,
       isSOS, c, mod4, mod8},
      Nothing
    ]
  ],
  {p, primes},
  {q, Select[primes, # > p &]}
], 1];

Print["Collected ", Length[data], " semiprimes"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Split by factor mod 4 pattern *)
bothMod1Cases = Select[data, #[[7]] == True &];
oneMod1Cases = Select[data, #[[8]] == True &];
bothMod3Cases = Select[data, #[[9]] == True &];

Print["SPLIT BY FACTOR MOD 4 STRUCTURE:"];
Print[StringRepeat["-", 60]];
Print["Both p,q ≡ 1 (mod 4):  ", Length[bothMod1Cases], " cases"];
Print["One ≡ 1, one ≡ 3:      ", Length[oneMod1Cases], " cases"];
Print["Both p,q ≡ 3 (mod 4):  ", Length[bothMod3Cases], " cases"];
Print[];

(* Compare R values *)
Rboth1 = bothMod1Cases[[All, 4]];
Rmixed = oneMod1Cases[[All, 4]];
Rboth3 = bothMod3Cases[[All, 4]];

Print["COMPARISON OF R VALUES:"];
Print[StringRepeat["-", 60]];
Print["Both ≡ 1 (mod 4):"];
Print["  Mean R:   ", N[Mean[Rboth1], 4]];
Print["  Median R: ", N[Median[Rboth1], 4]];
Print[];

Print["One ≡ 1, one ≡ 3 (mod 4):"];
Print["  Mean R:   ", N[Mean[Rmixed], 4]];
Print["  Median R: ", N[Median[Rmixed], 4]];
Print[];

Print["Both ≡ 3 (mod 4):"];
Print["  Mean R:   ", N[Mean[Rboth3], 4]];
Print["  Median R: ", N[Median[Rboth3], 4]];
Print[];

Print["Ratio (both ≡ 1 / both ≡ 3): ",
      N[Mean[Rboth1]/Mean[Rboth3], 3]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Sum of squares correlation *)
Print["SUM OF SQUARES CONNECTION:"];
Print[StringRepeat["-", 60]];

sosCount1 = Count[bothMod1Cases, _?(#[[10]] == True &)];
sosCount2 = Count[oneMod1Cases, _?(#[[10]] == True &)];
sosCount3 = Count[bothMod3Cases, _?(#[[10]] == True &)];

Print["Both ≡ 1: ", sosCount1, "/", Length[bothMod1Cases],
      " (", N[100.0*sosCount1/Length[bothMod1Cases], 2], "%) are sum of squares"];
Print["Mixed:    ", sosCount2, "/", Length[oneMod1Cases],
      " (", N[100.0*sosCount2/Length[oneMod1Cases], 2], "%) are sum of squares"];
Print["Both ≡ 3: ", sosCount3, "/", Length[bothMod3Cases],
      " (", N[100.0*sosCount3/Length[bothMod3Cases], 2], "%) are sum of squares"];
Print[];

Print["Expected by Fermat's theorem:"];
Print["  Both ≡ 1 (mod 4): Should be sum of squares (100%)"];
Print["  One ≡ 1, one ≡ 3: Depends on exponents (mixed)"];
Print["  Both ≡ 3 (mod 4): NEVER sum of squares (0%)"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Examples *)
Print["EXAMPLES (both p,q ≡ 1 mod 4):"];
Print[StringRepeat["-", 70]];
Print["n       p    q     R(n)    SOS?  mod 4  mod 8"];
Print[StringRepeat["-", 70]];

Do[
  {n, p, q, R, pMod4, qMod4, _, _, _, isSOS, c, mod4, mod8} = bothMod1Cases[[i]];
  Print[
    StringPadRight[ToString[n], 8],
    StringPadRight[ToString[p], 5],
    StringPadRight[ToString[q], 6],
    StringPadRight[ToString[N[R, 4]], 8],
    StringPadRight[If[isSOS, "YES", "NO"], 6],
    StringPadRight[ToString[mod4], 7],
    mod8
  ];
  ,
  {i, Min[20, Length[bothMod1Cases]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["EXAMPLES (both p,q ≡ 3 mod 4):"];
Print[StringRepeat["-", 70]];
Print["n       p    q     R(n)    SOS?  mod 4  mod 8"];
Print[StringRepeat["-", 70]];

Do[
  {n, p, q, R, pMod4, qMod4, _, _, _, isSOS, c, mod4, mod8} = bothMod3Cases[[i]];
  Print[
    StringPadRight[ToString[n], 8],
    StringPadRight[ToString[p], 5],
    StringPadRight[ToString[q], 6],
    StringPadRight[ToString[N[R, 4]], 8],
    StringPadRight[If[isSOS, "YES", "NO"], 6],
    StringPadRight[ToString[mod4], 7],
    mod8
  ];
  ,
  {i, Min[20, Length[bothMod3Cases]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Distance analysis *)
Print["DISTANCE ANALYSIS:"];
Print[StringRepeat["-", 60]];

distBoth1 = bothMod1Cases[[All, 11]];
distMixed = oneMod1Cases[[All, 11]];
distBoth3 = bothMod3Cases[[All, 11]];

Print["Mean distance to k² (c = n - k²):"];
Print["  Both ≡ 1: ", N[Mean[distBoth1], 3]];
Print["  Mixed:    ", N[Mean[distMixed], 3]];
Print["  Both ≡ 3: ", N[Mean[distBoth3], 3]];
Print[];

Print["Correlation c ↔ R:"];
Print["  Both ≡ 1: ", N[Correlation[N[distBoth1], N[Rboth1]], 3]];
Print["  Mixed:    ", N[Correlation[N[distMixed], N[Rmixed]], 3]];
Print["  Both ≡ 3: ", N[Correlation[N[distBoth3], N[Rboth3]], 3]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

Print["KEY INSIGHTS:"];
Print[StringRepeat["-", 60]];
Print[];
Print["Fermat's theorem for composites:"];
Print["  n = p×q is sum of squares ⟺ both p,q ≡ 1 (mod 4)"];
Print["                              OR one is p=2"];
Print[];
Print["Multiplicative structure → Additive property:"];
Print["  Factor mod 4 pattern → Sum of squares possibility"];
Print["  → CF structure → R(n)"];
Print[];
Print["For semiprimes: M(n) = 2 always (only divisors are p, q)"];
Print["So M doesn't vary - effect is purely from mod structure & distance"];
Print[];

Print[StringRepeat["=", 80]];
