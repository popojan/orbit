#!/usr/bin/env wolframscript
(* TEST: Can we get fundamental solution from half-period solution? *)

Print[StringRepeat["=", 80]];
Print["HALF-PERIOD TO FUNDAMENTAL SOLUTION"];
Print[StringRepeat["=", 80]];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

TestRelation[p_] := Module[{period, convs, halfIdx, xh, yh, normh, xf, yf, normf},
  period = CFPeriod[p];

  If[period > 0,
    convs = Convergents[ContinuedFraction[Sqrt[p], period + 5]];

    (* Half-period convergent *)
    halfIdx = Ceiling[period / 2];
    If[halfIdx <= Length[convs],
      xh = Numerator[convs[[halfIdx]]];
      yh = Denominator[convs[[halfIdx]]];
      normh = xh^2 - p*yh^2;

      (* Fundamental solution - convergent at period *)
      If[period <= Length[convs],
        xf = Numerator[convs[[period]]];
        yf = Denominator[convs[[period]]];
        normf = xf^2 - p*yf^2;

        {p, Mod[p,8], period, xh, yh, normh, xf, yf, normf},
        Nothing
      ],
      Nothing
    ],
    Nothing
  ]
]

(* Test on small primes *)
primes = Select[Range[3, 200], PrimeQ];
Print["Testing ", Length[primes], " primes < 200"];
Print[];

results = Table[TestRelation[p], {p, primes}];
results = DeleteCases[results, Nothing];

Print["Valid results: ", Length[results]];
Print[];

Print[StringRepeat["=", 80]];
Print["LOOKING FOR ALGEBRAIC RELATIONSHIPS"];
Print[StringRepeat["=", 80]];
Print[];

Print["Examples (first 20):"];
Print["p    m8  per  (xh,yh,norm_h)         (xf,yf,norm_f)"];
Print[StringRepeat["-", 80]];

Do[
  {p, m8, per, xh, yh, normh, xf, yf, normf} = results[[i]];
  Print[
    StringPadRight[ToString[p], 5],
    StringPadRight[ToString[m8], 4],
    StringPadRight[ToString[per], 5],
    "(",xh,",",yh,",",normh,")",
    StringRepeat[" ", Max[0, 20-StringLength[ToString[{xh,yh,normh}]]]],
    "(",xf,",",yf,",",normf,")"
  ];
  ,
  {i, Min[20, Length[results]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print["TESTING COMPOSITION/DOUBLING FORMULAS"];
Print[StringRepeat["=", 80]];
Print[];

(* Test if fundamental = square of half-period *)
Print["Test 1: Is (xf,yf) = (xh,yh)² via composition?"];
Print["Composition: (x₁²+py₁², 2x₁y₁) for (x₁,y₁)² norm"];
Print[];

testSquare = Table[
  {p, m8, per, xh, yh, normh, xf, yf, normf} = results[[i]];

  (* Square composition *)
  xSquare = xh^2 + p*yh^2;
  ySquare = 2*xh*yh;
  normSquare = xSquare^2 - p*ySquare^2;

  match = (xSquare == xf && ySquare == yf);

  {p, per, normh, match, normSquare},
  {i, Length[results]}
];

matchCount = Count[testSquare, {_, _, _, True, _}];
Print["Matches: ", matchCount, "/", Length[testSquare]];

If[matchCount > 0,
  Print["Examples where (xf,yf) = (xh,yh)² composition:"];
  matches = Select[testSquare, #[[4]] &];
  Do[
    {p, per, normh, _, _} = matches[[i]];
    Print["  p=", p, ", period=", per, ", norm_h=", normh];
    ,
    {i, Min[10, Length[matches]]}
  ];
];

Print[];

(* Test if there's a simpler pattern for period ≡ 0 (mod 4) *)
Print["Test 2: For period ≡ 0 (mod 4), check special cases"];
Print[];

mod4_0 = Select[results, Mod[#[[3]], 4] == 0 &];
Print["Primes with period ≡ 0 (mod 4): ", Length[mod4_0]];

If[Length[mod4_0] > 0,
  Print["First 10:"];
  Do[
    {p, m8, per, xh, yh, normh, xf, yf, normf} = mod4_0[[i]];

    (* Try square *)
    xSquare = xh^2 + p*yh^2;
    ySquare = 2*xh*yh;

    (* Try other formulas *)
    ratio = N[xf / xSquare, 4];

    Print["p=", p, ", per=", per];
    Print["  Half: (", xh, ",", yh, "), norm=", normh];
    Print["  Fund: (", xf, ",", yf, "), norm=", normf];
    Print["  Square: (", xSquare, ",", ySquare, ")"];
    Print["  Ratio xf/x_square: ", ratio];
    Print[];
    ,
    {i, Min[10, Length[mod4_0]]}
  ];
];

Print[StringRepeat["=", 80]];
Print["CONCLUSION"];
Print[StringRepeat["=", 80]];
Print[];

Print["Testing whether knowing half-period solution allows"];
Print["algebraic construction of fundamental solution.."];
Print[];

If[matchCount == Length[testSquare],
  Print["✓ ALWAYS: fundamental = square(half-period)"],
  If[matchCount > 0,
    Print["⚠ SOMETIMES: works for ", matchCount, "/", Length[testSquare], " cases"],
    Print["✗ NEVER: no direct squaring relation"]
  ]
];

Print[];
Print["TEST COMPLETE"];
