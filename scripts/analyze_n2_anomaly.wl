#!/usr/bin/env wolframscript
(* Deep dive into n ≡ 2 (mod 8) anomaly *)

Print["Analyzing n ≡ 2 (mod 8) anomaly..."];
Print[];

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]
Modd[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] && OddQ[#] &]]

PellSol[D_] := Module[{sol},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];
  sol = Solve[x^2 - D*y^2 == 1, {x, y}, PositiveIntegers] /. C[1] -> 1;
  If[sol === {}, {0, 0}, {x, y} /. First[sol]]
]

Reg[D_] := Module[{sol, x, y},
  sol = PellSol[D];
  {x, y} = sol;
  If[x > 1, N[Log[x + y*Sqrt[D]], 10], 0.0]
]

(* Collect n ≡ 2 (mod 8) data with detailed analysis *)
n2data = Select[
  Table[
    If[!IntegerQ[Sqrt[n]],
      Module[{m, modd, R, divs, oddDivs, fact},
        m = M[n];
        modd = Modd[n];
        R = Reg[n];
        divs = Select[Divisors[n], 2 <= # <= Sqrt[n] &];
        oddDivs = Select[divs, OddQ];
        fact = FactorInteger[n];
        If[R > 0,
          {n, m, modd, R, divs, oddDivs, fact},
          Nothing
        ]
      ],
      Nothing
    ],
    {n, 2, 200, 8}  (* n ≡ 2 (mod 8) *)
  ],
  # =!= Nothing &
];

Print["Collected ", Length[n2data], " cases for n ≡ 2 (mod 8)"];
Print[];

(* Individual case analysis *)
Print["Individual cases (first 15):"];
Print[StringRepeat["=", 80]];
Print["n    M  M_odd  R      Divisors              Odd divisors     Factorization"];
Print[StringRepeat["-", 80]];

Do[
  {n, m, modd, R, divs, oddDivs, fact} = case;
  Print[
    StringPadRight[ToString[n], 5],
    StringPadRight[ToString[m], 3],
    StringPadRight[ToString[modd], 7],
    StringPadRight[ToString[N[R, 4]], 7],
    StringPadRight[ToString[divs], 22],
    StringPadRight[ToString[oddDivs], 17],
    ToString[fact]
  ];
  ,
  {case, Take[n2data, Min[15, Length[n2data]]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Statistical breakdown *)
Print["Statistical breakdown:"];
Print[StringRepeat["-", 40]];

Mvals = n2data[[All, 2]];
Moddvals = n2data[[All, 3]];
Rvals = n2data[[All, 4]];

Print["Mean M:      ", N[Mean[Mvals], 4]];
Print["Mean M_odd:  ", N[Mean[Moddvals], 4]];
Print["Mean R:      ", N[Mean[Rvals], 4]];
Print[];

Print["M ↔ R:       ", N[Correlation[N[Mvals], N[Rvals]], 4]];
Print["M_odd ↔ R:   ", N[Correlation[N[Moddvals], N[Rvals]], 4]];
Print[];

(* Key insight: Check what fraction have M_odd = 0 *)
zeroModd = Count[Moddvals, 0];
Print["Cases with M_odd = 0:  ", zeroModd, " / ", Length[Moddvals],
      " (", N[100*zeroModd/Length[Moddvals], 1], "%)"];

(* Check what fraction have M = M_odd (no factor of 2 effect) *)
sameM = Count[Table[Mvals[[i]] == Moddvals[[i]], {i, Length[Mvals]}], True];
Print["Cases with M = M_odd:  ", sameM, " / ", Length[Mvals],
      " (", N[100*sameM/Length[Mvals], 1], "%)"];

Print[];

(* Hypothesis: n ≡ 2 (mod 8) means n = 2·k where k is odd *)
(* So n has structure 2^1 · (odd), unlike n≡4,6 which have 2^2 or 2·3 *)
Print["Structure analysis:"];
Print[StringRepeat["-", 40]];

(* Count by power of 2 *)
pow2 = Table[
  fact = n2data[[i, 7]];
  If[fact[[1, 1]] == 2, fact[[1, 2]], 0],
  {i, Length[n2data]}
];

Print["Power of 2 in factorization:"];
Print["  All have 2^1: ", AllTrue[pow2, # == 1 &]];
Print[];

(* Odd part analysis *)
oddParts = Table[
  n2data[[i, 1]] / 2,  (* n = 2·k, so k = n/2 *)
  {i, Length[n2data]}
];

Print["Odd part k (n = 2·k):"];
Print["  All odd: ", AllTrue[oddParts, OddQ]];
Print["  Mean k:  ", N[Mean[oddParts], 4]];
Print[];

(* Compare R(n) with R(k) for k = n/2 *)
Print["Comparing R(n) vs R(k) for k = n/2:"];
Print[StringRepeat["-", 60]];
Print["n    k    R(n)    R(k)    Ratio"];
Print[StringRepeat["-", 60]];

Do[
  n = n2data[[i, 1]];
  k = n / 2;
  Rn = n2data[[i, 4]];
  Rk = Reg[k];
  If[Rk > 0,
    Print[
      StringPadRight[ToString[n], 5],
      StringPadRight[ToString[k], 5],
      StringPadRight[ToString[N[Rn, 4]], 8],
      StringPadRight[ToString[N[Rk, 4]], 8],
      N[Rn/Rk, 4]
    ]
  ];
  ,
  {i, Min[10, Length[n2data]]}
];

Print[];
Print["Analysis complete."];
