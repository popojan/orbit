#!/usr/bin/env wolframscript
(* MERSENNE PRIMES + LUCAS-LEHMER CONNECTION *)

Print[StringRepeat["=", 80]];
Print["MERSENNE PRIMES: Lucas-Lehmer & Pell Connection"];
Print[StringRepeat["=", 80]];
Print[];

(* Pell helpers *)
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

(* Lucas-Lehmer test *)
LucasLehmer[p_] := Module[{Mp, s, i},
  Mp = 2^p - 1;
  s = 4;
  Do[
    s = Mod[s^2 - 2, Mp],
    {i, p - 2}
  ];
  s == 0
]

(* === KEY FACTS === *)
Print["THEORETICAL BACKGROUND:"];
Print[StringRepeat["-", 60]];
Print[];

Print["1. Mersenne numbers: M_p = 2^p - 1"];
Print["2. For p >= 3: M_p == 7 (mod 8) ALWAYS"];
Print["3. Lucas-Lehmer test (for primality):"];
Print["     S_0 = 4"];
Print["     S_{i+1} = S_i^2 - 2 (mod M_p)"];
Print["     M_p prime <=> S_{p-2} = 0 (mod M_p)"];
Print[];
Print["4. Connection to Pell: x^2 - 3y^2 = 1 appears in LL test!"];
Print["   (fundamental solution: x=2, y=1)"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Small Mersenne primes *)
mersennePrimes = {
  {2, 3},
  {3, 7},
  {5, 31},
  {7, 127},
  {13, 8191}
};

Print["MERSENNE PRIMES (small ones):"];
Print[StringRepeat["-", 60]];
Print[];

Print["p    M_p        LL test   mod 8   R(M_p)"];
Print[StringRepeat["-", 60]];

Do[
  {p, Mp} = mersennePrimes[[i]];
  ll = LucasLehmer[p];
  mod8 = Mod[Mp, 8];
  R = Reg[Mp];

  Print[
    StringPadRight[ToString[p], 5],
    StringPadRight[ToString[Mp], 11],
    StringPadRight[If[ll, "PRIME", "composite"], 10],
    StringPadRight[ToString[mod8], 8],
    N[R, 5]
  ];
  ,
  {i, Length[mersennePrimes]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* === LUCAS-LEHMER SEQUENCE ANALYSIS === *)
Print["LUCAS-LEHMER SEQUENCE FOR M_7 = 127:"];
Print[StringRepeat["-", 60]];
Print[];

Mp = 127;
p = 7;
Print["Computing S_i sequence (mod 127):"];
Print[];

s = 4;
Print["S_0 = ", s];
Do[
  s = Mod[s^2 - 2, Mp];
  Print["S_", i, " = ", s];
  ,
  {i, 1, p - 2}
];

Print[];
Print["S_{p-2} = S_5 = 0 => 127 is PRIME (confirmed)"];
Print[];

(* Connection to Pell x^2 - 3y^2 = 1 *)
Print["CONNECTION TO PELL x^2 - 3y^2 = 1:"];
Print[StringRepeat["-", 60]];
Print[];

pellSol3 = PellSol[3];
Print["Fundamental solution: ", pellSol3];
Print["x = 2, y = 1"];
Print[];

Print["Lucas-Lehmer recurrence S_{i+1} = S_i^2 - 2 is related to"];
Print["Chebyshev polynomials and Pell equation dynamics!");
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* === REGULATOR PATTERN === *)
Print["R(M_p) PATTERN:"];
Print[StringRepeat["-", 60]];
Print[];

RVals = Table[
  {p, Mp} = mersennePrimes[[i]];
  Reg[Mp],
  {i, Length[mersennePrimes]}
];

Print["p    R(2^p - 1)"];
Print[StringRepeat["-", 30]];
Do[
  Print[mersennePrimes[[i, 1]], "    ", N[RVals[[i]], 6]];
  ,
  {i, Length[RVals]}
];

Print[];
Print["Does R(M_p) grow with p?"];
Print["Ratio R(M_{p+1})/R(M_p):");
ratios = Table[RVals[[i+1]]/RVals[[i]], {i, Length[RVals]-1}];
Print[ratios];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["HYPOTHESIS: Lucas-Lehmer structure => special CF structure"];
Print["            => predictable R(M_p)"];
Print[];
Print["NEXT: Analyze CF of sqrt(2^p - 1) for pattern"];
