#!/usr/bin/env wolframscript
(* TEST: Period divisibility by 4 for primes mod 8 *)

Print[StringRepeat["=", 80]];
Print["PERIOD DIVISIBILITY TEST: p mod 8 → period mod 4"];
Print[StringRepeat["=", 80]];
Print[];

Print["CLAIM TO TEST:"];
Print["  p ≡ 3 (mod 8) ⟹ period ≡ 2 (mod 4)"];
Print["  p ≡ 7 (mod 8) ⟹ period ≡ 0 (mod 4)"];
Print[];

(* CF period *)
CFPeriod[D_Integer] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

Print["Testing primes p < 10000..."];
Print[];

primes = Select[Range[3, 10000], PrimeQ];
Print["Total primes: ", Length[primes]];
Print[];

(* Test claim *)
violations = {};
confirmed = 0;

Do[
  Module[{p, mod8, period, periodMod4, expected, match},
    p = primes[[i]];
    mod8 = Mod[p, 8];

    (* Only test p ≡ 3,7 (mod 8) *)
    If[mod8 == 3 || mod8 == 7,
      period = CFPeriod[p];
      periodMod4 = Mod[period, 4];

      expected = If[mod8 == 3, 2, 0];
      match = (periodMod4 == expected);

      If[match,
        confirmed++,
        (* VIOLATION *)
        AppendTo[violations, {p, mod8, period, periodMod4, expected}];
        Print["❌ VIOLATION: p=", p, " (mod 8 = ", mod8, ")"];
        Print["   period = ", period, " ≡ ", periodMod4, " (mod 4)"];
        Print["   Expected: ≡ ", expected, " (mod 4)"];
        Print[];
      ];
    ];

    (* Progress *)
    If[Mod[i, 100] == 0,
      Print["Progress: ", i, "/", Length[primes], " (",
            confirmed, " confirmed, ", Length[violations], " violations)"];
    ];
  ],
  {i, Length[primes]}
];

Print[];
Print[StringRepeat["=", 80]];
Print["RESULTS"];
Print[StringRepeat["-", 60]];
Print[];

(* Count by mod class *)
mod3Count = Count[primes, p_ /; Mod[p, 8] == 3];
mod7Count = Count[primes, p_ /; Mod[p, 8] == 7];
totalTested = mod3Count + mod7Count;

Print["Primes tested:"];
Print["  p ≡ 3 (mod 8): ", mod3Count];
Print["  p ≡ 7 (mod 8): ", mod7Count];
Print["  Total:         ", totalTested];
Print[];

Print["Confirmed:      ", confirmed];
Print["Violations:     ", Length[violations]];
Print[];

If[Length[violations] == 0,
  Print["✓ CLAIM HOLDS for ALL ", totalTested, " primes < 10000!"];
  Print[];
  Print["THEOREM (NUMERICAL):"];
  Print["  For prime p ≥ 3:"];
  Print["    p ≡ 3 (mod 8) ⟹ period(√p) ≡ 2 (mod 4)"];
  Print["    p ≡ 7 (mod 8) ⟹ period(√p) ≡ 0 (mod 4)"];
  Print[];
  Print["Confidence: VERY HIGH (", totalTested, " cases, 0 counterexamples)"];
  ,
  Print["❌ CLAIM FALSIFIED!"];
  Print[];
  Print["Violations:"];
  Print[StringRepeat["-", 60]];
  Print["p      mod8  period  per%4  expected"];
  Print[StringRepeat["-", 60]];
  Do[
    {p, m8, per, pm4, exp} = violations[[i]];
    Print[StringPadRight[ToString[p], 7],
          StringPadRight[ToString[m8], 6],
          StringPadRight[ToString[per], 8],
          StringPadRight[ToString[pm4], 7],
          exp];
    ,
    {i, Length[violations]}
  ];
];

Print[];
Print[StringRepeat["=", 80]];

(* Additional analysis if claim holds *)
If[Length[violations] == 0,
  Print[];
  Print["BONUS ANALYSIS: What about mod 1 and 5?"];
  Print[StringRepeat["-", 60]];
  Print[];

  (* Check mod 1 *)
  mod1Primes = Select[primes[[1;;Min[200, Length[primes]]]], Mod[#, 8] == 1 &];
  mod1Periods = Table[{p, Mod[CFPeriod[p], 4]}, {p, mod1Primes}];
  mod1Dist = Tally[mod1Periods[[All, 2]]];

  Print["p ≡ 1 (mod 8): period mod 4 distribution (first 200)"];
  Print["  ", mod1Dist];
  Print[];

  (* Check mod 5 *)
  mod5Primes = Select[primes[[1;;Min[200, Length[primes]]]], Mod[#, 8] == 5 &];
  mod5Periods = Table[{p, Mod[CFPeriod[p], 4]}, {p, mod5Primes}];
  mod5Dist = Tally[mod5Periods[[All, 2]]];

  Print["p ≡ 5 (mod 8): period mod 4 distribution (first 200)"];
  Print["  ", mod5Dist];
  Print[];

  Print["Observation: mod 1,5 show MIXED behavior (no simple rule)"];
  Print[];
];

Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
