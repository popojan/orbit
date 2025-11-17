#!/usr/bin/env wolframscript
(*
Show numerical examples of pair sums for n=2, 3, 13
*)

(* Chebyshev term definition *)
term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x+1] *
                    (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]))

(* Pair sum *)
pairSum[x_, m_] := term[x, 2*m] + term[x, 2*m+1]

(* Fundamental Pell solutions (known) *)
pellSolutions = <|
  2 -> {3, 2},
  3 -> {2, 1},
  13 -> {649, 180}
|>;

(* Show for one n *)
ShowPairs[n_, numPairs_:4] := Module[{x, y, R},
  {x, y} = pellSolutions[n];

  Print["=" * 70];
  Print["n = ", n];
  Print["=" * 70];
  Print["Fundamental solution: x = ", x, ", y = ", y];
  Print["Check: x² - n·y² = ", x^2 - n*y^2];
  Print["R = x + y√n = ", N[x + y*Sqrt[n], 10]];
  Print["Numerator (2+x) = ", 2 + x];
  Print[];
  Print["Pair sums (first ", numPairs, " pairs):"];
  Print[];

  Do[
    even = term[x, 2*m];
    odd = term[x, 2*m+1];
    sum = even + odd;
    sumSimplified = Simplify[pairSum[x, m]];

    Print["m = ", m, ":"];
    Print["  term[", 2*m, "]     = ", N[even, 15]];
    Print["  term[", 2*m+1, "]   = ", N[odd, 15]];
    Print["  SUM          = ", N[sum, 15]];

    (* Show exact rational form *)
    If[Head[sumSimplified] === Rational,
      num = Numerator[sumSimplified];
      den = Denominator[sumSimplified];
      Print["  Exact form   = ", num, "/", den];
      Print["  Numerator    = ", num, If[num === 2+x, " ✓ (2+x)", " ← CHECK!"]];
    ,
      Print["  Simplified   = ", sumSimplified];
    ];
    Print[];
    ,
    {m, 1, numPairs}
  ];
  Print[];
];

(* Show examples *)
ShowPairs[2, 4];
ShowPairs[3, 4];
ShowPairs[13, 4];

Print["=" * 70];
Print["OBSERVATION: Numerator is ALWAYS (2+x)"];
Print["=" * 70];
Print[];
Print["For n=2:  2+x = 2+3 = 5"];
Print["For n=3:  2+x = 2+2 = 4"];
Print["For n=13: 2+x = 2+649 = 651"];
