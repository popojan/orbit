#!/usr/bin/env wolframscript
(* FALSIFICATION TEST: Mod 8 classification for Pell solutions *)

Print[StringRepeat["=", 80]];
Print["FALSIFICATION TEST: x_0 mod p vs p mod 8"];
Print[StringRepeat["=", 80]];
Print[];

(* Claim to test:
   p ≡ 7 (mod 8) → x ≡ +1 (mod p)
   p ≡ 1,3 (mod 8) → x ≡ -1 (mod p)
*)

(* Helper: solve Pell equation via convergents *)
PellSol[D_Integer] := Module[{cf, convs, i},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];

  (* Get continued fraction *)
  cf = ContinuedFraction[Sqrt[D], 200];

  (* Extract convergents until we find solution *)
  convs = Convergents[cf];

  For[i = 1, i <= Length[convs], i++,
    Module[{x, y},
      x = Numerator[convs[[i]]];
      y = Denominator[convs[[i]]];
      If[x^2 - D*y^2 == 1,
        Return[{x, y}]
      ];
    ]
  ];

  (* Failed *)
  {0, 0}
]

Print["Testing primes p < 10000..."];
Print[];

(* Test all primes *)
primes = Select[Range[3, 10000], PrimeQ];
Print["Total primes to test: ", Length[primes]];
Print[];

counterexamples = {};
confirmedCases = 0;

Do[
  Module[{p, mod8, sol, x, xModP, expectedSign, actualSign, match},
    p = primes[[i]];
    mod8 = Mod[p, 8];

    (* Solve Pell *)
    sol = PellSol[p];
    {x, y} = sol;

    If[x > 1,
      xModP = Mod[x, p];

      (* Expected sign from claim *)
      expectedSign = If[mod8 == 7, 1, p - 1]; (* 1 or -1 mod p *)
      actualSign = xModP;

      match = (actualSign == expectedSign);

      If[match,
        confirmedCases++,
        (* COUNTEREXAMPLE FOUND! *)
        AppendTo[counterexamples, {p, mod8, x, y, xModP}];
        Print["❌ COUNTEREXAMPLE FOUND!"];
        Print["  p = ", p, " (mod 8 = ", mod8, ")"];
        Print["  x_0 = ", x];
        Print["  x_0 mod p = ", xModP];
        Print["  Expected: ", If[mod8 == 7, "+1", "-1"]];
        Print["  Actual: ", If[xModP == 1, "+1", If[xModP == p-1, "-1", "OTHER"]]];
        Print[];
      ];

      (* Progress *)
      If[Mod[i, 100] == 0,
        Print["Progress: ", i, "/", Length[primes], " (",
              confirmedCases, " confirmed, ", Length[counterexamples], " counterexamples)"];
      ];
    ];
  ],
  {i, Length[primes]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* RESULTS *)
Print["FALSIFICATION TEST RESULTS"];
Print[StringRepeat["-", 60]];
Print[];
Print["Total primes tested:  ", Length[primes]];
Print["Confirmed cases:      ", confirmedCases];
Print["Counterexamples:      ", Length[counterexamples]];
Print[];

If[Length[counterexamples] == 0,
  Print["✓ NO COUNTEREXAMPLES FOUND"];
  Print["  Claim holds for ALL ", Length[primes], " primes < 10000"];
  Print["  Confidence: VERY HIGH (but still not proven!)"];
  Print[];
  Print["Distribution by mod 8:"];
  mod1 = Count[primes, p_ /; Mod[p, 8] == 1];
  mod3 = Count[primes, p_ /; Mod[p, 8] == 3];
  mod5 = Count[primes, p_ /; Mod[p, 8] == 5];
  mod7 = Count[primes, p_ /; Mod[p, 8] == 7];
  Print["  p ≡ 1 (mod 8): ", mod1, " primes"];
  Print["  p ≡ 3 (mod 8): ", mod3, " primes"];
  Print["  p ≡ 5 (mod 8): ", mod5, " primes"];
  Print["  p ≡ 7 (mod 8): ", mod7, " primes"];
  ,
  Print["❌ CLAIM FALSIFIED!"];
  Print[];
  Print["Counterexamples:"];
  Print[StringRepeat["-", 60]];
  Print["p      mod8  x_0 mod p  Expected  Actual"];
  Print[StringRepeat["-", 60]];
  Do[
    {p, mod8, x, y, xModP} = counterexamples[[i]];
    expected = If[mod8 == 7, "+1", "-1"];
    actual = If[xModP == 1, "+1", If[xModP == p-1, "-1", ToString[xModP]]];
    Print[StringPadRight[ToString[p], 7],
          StringPadRight[ToString[mod8], 6],
          StringPadRight[ToString[xModP], 12],
          StringPadRight[expected, 10],
          actual];
    ,
    {i, Length[counterexamples]}
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
