#!/usr/bin/env wolframscript
(* TEST: Is prime/composite bifurcation universal across all mod classes? *)

Print[StringRepeat["=", 80]];
Print["UNIVERSALITY TEST: Prime vs Composite Bifurcation"];
Print[StringRepeat["=", 80]];
Print[];

(* Helper functions *)
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

(* === COLLECT DATA === *)
Print["Collecting data for n <= 400..."];
Print[];

allData = Flatten[Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{R, mod8, isPrime},
      R = Reg[n];
      mod8 = Mod[n, 8];
      isPrime = PrimeQ[n];
      If[R > 0, {{n, R, mod8, isPrime}}, {}]
    ],
    {}
  ],
  {n, 3, 400}
], 1];

Print["Total: ", Length[allData], " odd non-square n <= 400"];
Print[];

(* === ANALYSIS BY MOD CLASS === *)
Print[StringRepeat["=", 80]];
Print[];
Print["PRIME vs COMPOSITE ANALYSIS (all n <= 400)"];
Print[StringRepeat["-", 60]];
Print[];

results = Association[];

For[mod = 1, mod <= 7, mod += 2,
  subset = Select[allData, #[[3]] == mod &];

  If[Length[subset] > 0,
    primes = Select[subset, #[[4]] &];
    composites = Select[subset, !#[[4]] &];

    If[Length[primes] > 0 && Length[composites] > 0,
      meanRPrime = Mean[primes[[All, 2]]];
      meanRComp = Mean[composites[[All, 2]]];
      ratio = meanRPrime / meanRComp;

      results[mod] = {
        Length[primes],
        Length[composites],
        meanRPrime,
        meanRComp,
        ratio
      };

      Print["mod ", mod, ":"];
      Print["  Primes (n=", Length[primes], "):     mean R = ", N[meanRPrime, 4]];
      Print["  Composites (n=", Length[composites], "): mean R = ", N[meanRComp, 4]];
      Print["  Ratio (P/C):        ", N[ratio, 4],
            If[ratio > 1.3, " ← SIGNIFICANT!", ""]];
      Print[];
    ]
  ]
];

Print[StringRepeat["=", 80]];
Print[];

(* === SUMMARY TABLE === *)
Print["SUMMARY TABLE"];
Print[StringRepeat["-", 60]];
Print[];
Print["mod  n_prime  n_comp  R_prime  R_comp  Ratio  Significant?"];
Print[StringRepeat["-", 60]];

For[mod = 1, mod <= 7, mod += 2,
  If[KeyExistsQ[results, mod],
    {nPrime, nComp, rPrime, rComp, ratio} = results[mod];
    Print[StringPadRight[ToString[mod], 5],
          StringPadRight[ToString[nPrime], 9],
          StringPadRight[ToString[nComp], 8],
          StringPadRight[ToString[N[rPrime, 3]], 9],
          StringPadRight[ToString[N[rComp, 3]], 8],
          StringPadRight[ToString[N[ratio, 3]], 7],
          If[ratio > 1.3, "YES ★", "no"]];
  ]
];

Print[];

(* === MOD 4 ANALYSIS === *)
Print[StringRepeat["=", 80]];
Print[];
Print["MOD 4 ANALYSIS (fundamental for sum-of-squares)"];
Print[StringRepeat["-", 60]];
Print[];

(* Group by mod 4 *)
mod4Data = Association[];

For[mod4 = 1, mod4 <= 3, mod4++,
  subset = Select[allData, Mod[#[[1]], 4] == mod4 &];

  If[Length[subset] > 0,
    primes = Select[subset, #[[4]] &];
    composites = Select[subset, !#[[4]] &];

    If[Length[primes] > 0 && Length[composites] > 0,
      meanRPrime = Mean[primes[[All, 2]]];
      meanRComp = Mean[composites[[All, 2]]];
      ratio = meanRPrime / meanRComp;

      mod4Data[mod4] = {
        Length[primes],
        Length[composites],
        meanRPrime,
        meanRComp,
        ratio
      };

      Print["n ≡ ", mod4, " (mod 4):"];
      Print["  Primes (n=", Length[primes], "):     mean R = ", N[meanRPrime, 4]];
      Print["  Composites (n=", Length[composites], "): mean R = ", N[meanRComp, 4]];
      Print["  Ratio (P/C):        ", N[ratio, 4],
            If[ratio > 1.3, " ← SIGNIFICANT!", ""]];
      Print["  Sum of squares?     ",
            If[mod4 == 1, "YES (primes always)", "no (mod 3) / depends (mod 2)"]];
      Print[];
    ]
  ]
];

Print[StringRepeat["=", 80]];
Print[];

(* === BREAKDOWN: MOD 8 → MOD 4 === *)
Print["MAPPING: mod 8 → mod 4"];
Print[StringRepeat["-", 60]];
Print[];

Print["mod 8 | mod 4 | sum-of-sq? | Prime ratio"];
Print[StringRepeat["-", 45]];
For[mod = 1, mod <= 7, mod += 2,
  mod4Val = Mod[mod, 4];
  sumSq = If[mod4Val == 1, "YES", "no"];
  ratioStr = If[KeyExistsQ[results, mod],
    ToString[N[results[mod][[5]], 3]],
    "N/A"
  ];
  Print[StringPadRight[ToString[mod], 7],
        StringPadRight[ToString[mod4Val], 7],
        StringPadRight[sumSq, 12],
        ratioStr];
];

Print[];

(* === HYPOTHESIS TEST === *)
Print[StringRepeat["=", 80]];
Print[];
Print["HYPOTHESIS TEST"];
Print[StringRepeat["-", 60]];
Print[];

Print["H1: Bifurcation is UNIVERSAL (all mods show P/C split)"];
Print["H2: Bifurcation is MOD 4 dependent (only mod≡1 (mod 4))"];
Print["H3: Bifurcation is MOD 5 SPECIFIC (unique property)"];
Print[];

(* Count significant bifurcations *)
significant = Count[Values[results], r_ /; r[[5]] > 1.3];

Print["Significant bifurcations (ratio > 1.3): ", significant, "/", Length[results]];
Print[];

If[significant == Length[results],
  Print["→ H1 SUPPORTED: Universal bifurcation"],
  If[significant >= 2,
    (* Check if it's mod 4 pattern *)
    mod1sig = If[KeyExistsQ[results, 1], results[1][[5]] > 1.3, False];
    mod5sig = If[KeyExistsQ[results, 5], results[5][[5]] > 1.3, False];
    mod3sig = If[KeyExistsQ[results, 3], results[3][[5]] > 1.3, False];
    mod7sig = If[KeyExistsQ[results, 7], results[7][[5]] > 1.3, False];

    If[mod1sig && mod5sig && !mod3sig && !mod7sig,
      Print["→ H2 SUPPORTED: Bifurcation for n ≡ 1 (mod 4) only"];
      Print["   (mod 1,5 have it; mod 3,7 don't)"];
      Print["   CONSISTENT with sum-of-squares theory!"],

      Print["→ MIXED PATTERN: needs further investigation"];
    ],

    If[significant == 1 && KeyExistsQ[results, 5] && results[5][[5]] > 1.3,
      Print["→ H3 SUPPORTED: Mod 5 is exceptional"],
      Print["→ NO CLEAR PATTERN: insufficient bifurcation"]
    ]
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
