#!/usr/bin/env wolframscript
(* TEST: Algebraic relation between half and fundamental *)

Print[StringRepeat["=", 80]];
Print["HALF-PERIOD TO FUNDAMENTAL: SEARCH FOR PATTERN"];
Print[StringRepeat["=", 80]];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

(* Get both half-period and fundamental solutions *)
GetSolutions[p_] := Module[{period, convs, halfIdx, xh, yh, normh, xf, yf, normf},
  period = CFPeriod[p];

  If[period > 0,
    convs = Convergents[ContinuedFraction[Sqrt[p], period + 5]];
    halfIdx = Ceiling[period / 2];

    If[halfIdx <= Length[convs] && period <= Length[convs],
      xh = Numerator[convs[[halfIdx]]];
      yh = Denominator[convs[[halfIdx]]];
      normh = xh^2 - p*yh^2;

      xf = Numerator[convs[[period]]];
      yf = Denominator[convs[[period]]];
      normf = xf^2 - p*yf^2;

      {p, Mod[p,8], period, xh, yh, normh, xf, yf, normf},
      Nothing
    ],
    Nothing
  ]
]

(* Test primes *)
primes = Select[Range[3, 200], PrimeQ];
results = DeleteCases[Table[GetSolutions[p], {p, primes}], Nothing];

Print["Testing ", Length[results], " primes"];
Print[];

(* Focus on p ≡ 3,7 (mod 8) where norm_h = ±2 *)
special = Select[results, Mod[#[[2]], 4] == 3 &]; (* mod8 ∈ {3,7} *)

Print["Primes p ≡ 3,7 (mod 8) with norm_h = ±2: ", Length[special]];
Print[];

Print[StringRepeat["=", 80]];
Print["TESTING VARIOUS ALGEBRAIC RELATIONS"];
Print[StringRepeat["=", 80]];
Print[];

Print["For each prime, compute:"];
Print["1. Square: (xh² + p·yh², 2xh·yh)"];
Print["2. Half of square: ((xh² + p·yh²)/2, xh·yh)"];
Print["3. Pell composition with itself"];
Print[];

Do[
  {p, m8, per, xh, yh, normh, xf, yf, normf} = special[[i]];

  (* Composition square *)
  xSquare = xh^2 + p*yh^2;
  ySquare = 2*xh*yh;

  (* Half of square *)
  xHalf = If[EvenQ[xSquare], xSquare/2, "N/A"];
  yHalf = xh*yh;

  (* Check if half-of-square matches *)
  matchHalf = (xHalf == xf && yHalf == yf);

  (* Check other patterns *)
  ratioX = N[xf / xSquare, 5];
  ratioY = N[yf / ySquare, 5];

  Print["p=", p, " (mod8=", m8, ", period=", per, ", norm_h=", normh, ")"];
  Print["  Half:   (", xh, ", ", yh, ")"];
  Print["  Fund:   (", xf, ", ", yf, ")"];
  Print["  Square: (", xSquare, ", ", ySquare, ")"];
  If[xHalf =!= "N/A",
    Print["  Half-of-square: (", xHalf, ", ", yHalf, ")",
          If[matchHalf, " ✓ MATCH!", ""]];
  ];
  Print["  Ratios: xf/xSquare=", ratioX, ", yf/ySquare=", ratioY];

  (* Check if norm_h = 2 implies special relation *)
  If[normh == 2,
    (* For norm = +2, try (xh² + p·yh²)/2 *)
    Print["  Special (norm=+2): trying (x²+py²)/2..."];
  ];

  If[normh == -2,
    (* For norm = -2, try something else *)
    Print["  Special (norm=-2): period=", per];
  ];

  Print[];
  ,
  {i, Min[15, Length[special]]}
];

Print[StringRepeat["=", 80]];
Print["PATTERN SEARCH: Period divisibility"];
Print[StringRepeat["=", 80]];
Print[];

(* Check if relation depends on period mod 4 *)
For[r = 0, r <= 3, r++,
  subset = Select[special, Mod[#[[3]], 4] == r &];

  If[Length[subset] > 0,
    Print["Period ≡ ", r, " (mod 4): n=", Length[subset]];

    (* Check pattern *)
    testPattern = Table[
      {p, m8, per, xh, yh, normh, xf, yf, normf} = subset[[j]];
      xSquare = xh^2 + p*yh^2;
      ySquare = 2*xh*yh;
      xHalf = If[EvenQ[xSquare], xSquare/2, xSquare];
      yHalf = xh*yh;

      match = (xHalf == xf && yHalf == yf);
      {p, match},
      {j, Length[subset]}
    ];

    matchCount = Count[testPattern, {_, True}];
    Print["  Half-of-square matches: ", matchCount, "/", Length[subset]];

    If[matchCount > 0,
      Print["  Examples: ", Select[testPattern, #[[2]] &][[All, 1]]];
    ];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["CONCLUSION"];
Print[StringRepeat["=", 80]];
Print[];

Print["No simple algebraic formula found (yet)."];
Print["Fundamental solution likely requires full period computation."];
Print[];
Print["However: knowing half-period norm = ±2 gives 2× speedup by"];
Print["knowing we're halfway through the period!");

Print[];
Print["TEST COMPLETE"];
