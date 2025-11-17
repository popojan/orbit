#!/usr/bin/env wolframscript
(* ANALYZE: Stern-Brocot tree structure of CF convergents *)

Print[StringRepeat["=", 80]];
Print["STERN-BROCOT TREE & CF CONVERGENT STRUCTURE"];
Print[StringRepeat["=", 80]];
Print[];

Print["Wildberger's insight: Pell solutions found via SB tree descent"];
Print["Question: What is the SB tree geometry of half-period convergent?"];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

(* Analyze SB tree path for CF convergents *)
AnalyzeSBPath[p_] := Module[{period, cf, convs, halfIdx, data},
  period = CFPeriod[p];

  If[period > 0,
    cf = ContinuedFraction[Sqrt[p], period + 5];
    convs = Convergents[cf];
    halfIdx = Ceiling[period / 2];

    (* Get all convergents up to fundamental *)
    data = Table[
      Module[{x, y, norm, frac},
        x = Numerator[convs[[i]]];
        y = Denominator[convs[[i]]];
        norm = x^2 - p*y^2;
        frac = N[x/y, 10];
        {i, x, y, norm, frac}
      ],
      {i, Min[period + 1, Length[convs]]}
    ];

    {p, Mod[p,8], period, halfIdx, data},
    Nothing
  ]
]

(* Test small primes p ≡ 3,7 (mod 8) *)
testPrimes = {3, 7, 11, 19, 23, 31, 43, 47};

Print[StringRepeat["=", 80]];
Print["CF CONVERGENT PATHS (showing norm pattern)"];
Print[StringRepeat["=", 80]];
Print[];

Do[
  result = AnalyzeSBPath[p];
  If[result =!= Nothing,
    {p, m8, per, halfIdx, data} = result;

    Print["p = ", p, " (mod 8 = ", m8, ", period = ", per, ")"];
    Print["sqrt(", p, ") ≈ ", N[Sqrt[p], 8]];
    Print[];
    Print["idx  (x, y)           norm    x/y"];
    Print[StringRepeat["-", 60]];

    Do[
      {idx, x, y, norm, frac} = data[[i]];
      marker = Which[
        idx == halfIdx, " ← HALF",
        idx == per, " ← FUNDAMENTAL",
        True, ""
      ];

      Print[
        StringPadRight[ToString[idx], 4],
        StringPadRight["(" <> ToString[x] <> "," <> ToString[y] <> ")", 18],
        StringPadRight[ToString[norm], 8],
        N[frac, 6],
        marker
      ];
      ,
      {i, Length[data]}
    ];

    Print[];
    Print["Observation at half-period (idx=", halfIdx, "):");
    {_, xh, yh, normh, _} = data[[halfIdx]];
    Print["  norm = ", normh, If[Abs[normh] == 2, " ★ (±2!)", ""]];

    (* Check Wildberger composition *)
    xSquare = xh^2 + p*yh^2;
    ySquare = 2*xh*yh;
    xHalf = xSquare / 2;
    yHalf = xh*yh;

    {_, xf, yf, _, _} = data[[per]];
    Print["  Composition: (xh²+p·yh², 2xh·yh) = (", xSquare, ",", ySquare, ")"];
    Print["  Half of that: (", xHalf, ",", yHalf, ")"];
    Print["  Fundamental:  (", xf, ",", yf, ")"];
    If[xHalf == xf && yHalf == yf,
      Print["  ✓ MATCH: Fundamental = half of composition!"];
    ];

    Print[];
    Print[StringRepeat["-", 80]];
    Print[];
  ];
  ,
  {p, testPrimes}
];

Print[StringRepeat["=", 80]];
Print["STERN-BROCOT TREE GEOMETRY"];
Print[StringRepeat["=", 80]];
Print[];

Print["Classical SB tree construction:"];
Print["  Start: 0/1 ─── 1/0"];
Print["  Mediant: (p₁+p₂)/(q₁+q₂)"];
Print[];

Print["For Pell equation x²-py²=1, convergents approach sqrt(p)"];
Print["from alternating sides (over/under approximation)."];
Print[];

Print["Wildberger's descent algorithm:"];
Print["  1. Start with large approximation to sqrt(p)"];
Print["  2. Use SB tree descent to find smaller solutions"];
Print["  3. Eventually reach fundamental solution"];
Print[];

Print["OUR DISCOVERY interpretation:"];
Print["  - Half-period convergent has norm ±2"];
Print["  - This is 'halfway' in SB tree navigation"];
Print["  - Algebraic doubling: (xh,yh) → (xh²+p·yh², 2xh·yh)"];
Print["  - Then HALVE to get fundamental solution"];
Print[];

Print["Geometric meaning:"];
Print["  Norm ±2 = 'one level away' from fundamental in SB tree?"];
Print["  Composition/halving = moving between tree levels?"];
Print[];

Print[StringRepeat["=", 80]];
Print["NEXT: Check if norm sequence has SB tree pattern"];
Print[StringRepeat["=", 80]];
Print[];

(* Analyze norm sequence more carefully *)
p = 23;
Print["Detailed analysis for p=", p, ":"];
Print[];

result = AnalyzeSBPath[p];
{p, m8, per, halfIdx, data} = result;

Print["Norm sequence:"];
norms = data[[All, 4]];
Print["  ", norms];
Print[];

Print["Absolute values:"];
absNorms = Abs[norms];
Print["  ", absNorms];
Print[];

Print["Pattern observations:"];
Print["  - Norms alternate in sign (classical)"];
Print["  - |norm| decreases until reaching ±2 at half-period"];
Print["  - Then pattern REVERSES (palindrome!)"];
Print["  - Final norm = ±1 (fundamental solution)"];
Print[];

Print["SB tree interpretation:");
Print["  - Each convergent = node in SB tree"];
Print["  - Norm = 'distance' from solution manifold x²-py²=1"];
Print["  - Half-period = closest approach before reversal"];
Print["  - Reversal = symmetry in palindromic CF"];
Print[];

Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
Print[];
Print["Wildberger's SB tree provides geometric framework for"];
Print["understanding WHY norm ±2 appears at half-period!");
