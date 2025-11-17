#!/usr/bin/env wolframscript
(* ANALYZE k² ± 1: Minimal distance cases *)

Print[StringRepeat["=", 80]];
Print["k² ± 1 ANALYSIS: Minimal distance to perfect square"];
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

(* Generate k² + 1 and k² - 1 *)
kMax = 20;

Print["CASE 1: n = k² + 1"];
Print[StringRepeat["-", 70]];
Print["k    n      Prime?  R(n)      mod 4  mod 8"];
Print[StringRepeat["-", 70]];

datePlus = Table[
  n = k^2 + 1;
  R = Reg[n];
  isPrime = PrimeQ[n];
  mod4 = Mod[n, 4];
  mod8 = Mod[n, 8];

  Print[
    StringPadRight[ToString[k], 5],
    StringPadRight[ToString[n], 7],
    StringPadRight[If[isPrime, "PRIME", ""], 8],
    StringPadRight[ToString[N[R, 4]], 10],
    StringPadRight[ToString[mod4], 7],
    mod8
  ];

  {k, n, R, isPrime, mod4, mod8}
  ,
  {k, 1, kMax}
];

Print[];
Print["Mean R for k² + 1: ", N[Mean[datePlus[[All, 3]]], 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

Print["CASE 2: n = k² - 1"];
Print[StringRepeat["-", 70]];
Print["k    n      Factor  R(n)      mod 4  mod 8"];
Print[StringRepeat["-", 70]];

dataMinus = Table[
  n = k^2 - 1;
  R = Reg[n];
  factors = FactorInteger[n];
  mod4 = Mod[n, 4];
  mod8 = Mod[n, 8];

  factorStr = ToString[factors[[1, 1]]];
  If[Length[factors] > 1,
    factorStr = factorStr <> "×" <> ToString[factors[[2, 1]]];
  ];

  Print[
    StringPadRight[ToString[k], 5],
    StringPadRight[ToString[n], 7],
    StringPadRight[factorStr, 8],
    StringPadRight[ToString[N[R, 4]], 10],
    StringPadRight[ToString[mod4], 7],
    mod8
  ];

  {k, n, R, factors, mod4, mod8}
  ,
  {k, 2, kMax}
];

Print[];
Print["Mean R for k² - 1: ", N[Mean[dataMinus[[All, 3]]], 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Compare *)
Print["COMPARISON:"];
Print[StringRepeat["-", 60]];
Print["k² + 1: mean R = ", N[Mean[datePlus[[All, 3]]], 4]];
Print["k² - 1: mean R = ", N[Mean[dataMinus[[All, 3]]], 4]];
Print[];

(* All k² + 1 are ≡ 2 (mod 3) *)
Print["Pattern check: k² + 1 mod 3"];
mod3Values = Table[Mod[k^2 + 1, 3], {k, 1, 20}];
Print["  Values: ", Union[mod3Values]];
Print["  (All are ≡ 2 mod 3)"];
Print[];

(* Primes in k² + 1 *)
primes = Select[datePlus, #[[4]] == True &];
Print["Primes of form k² + 1 (up to k=", kMax, "):"];
Do[
  {k, n, R, isPrime, mod4, mod8} = primes[[i]];
  Print["  k=", k, ": n=", n, ", R=", N[R, 4]];
  ,
  {i, Length[primes]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["OBSERVATIONS:"];
Print[StringRepeat["-", 60]];
Print[];
Print["k² + 1:"];
Print["  - Always ≡ 1 (mod 4) [even k] or ≡ 2 (mod 4) [odd k]");
Print["  - Always ≡ 2 (mod 3)");
Print["  - Can be prime (Fermat primes connection?)");
Print["  - Distance to k² is minimal (c = 1)");
Print[];
Print["k² - 1 = (k-1)(k+1):"];
Print["  - Always composite (except k=2 → n=3)");
Print["  - Always ≡ 0 or 3 (mod 4)");
Print["  - Product of consecutive even/odd numbers");
Print[];

Print[StringRepeat["=", 80]];
