#!/usr/bin/env wolframscript
(*
Test full expression (x-1)/y * f(x-1, k) mod n
for k=EVEN vs k=ODD
*)

Print["=" * 70];
Print["FULL EXPRESSION MOD n TEST"];
Print["=" * 70];
Print[];

(* Chebyshev term *)
term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x+1] *
                    (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]))

(* Full f function *)
f[x_, kMax_] := 1 + Sum[term[x, j], {j, 1, kMax}]

(* Test for n *)
TestModN[n_, x_, y_, kMax_:20] := Module[{results},
  Print["n = ", n, ", x = ", x, ", y = ", y];
  Print["x mod n = ", Mod[x, n]];
  Print[];

  results = Table[
    Module[{fVal, fullExpr, numerator, modResult},
      fVal = f[x - 1, k];
      fullExpr = (x - 1)/y * fVal;

      (* Try to get numerator (if rational) *)
      If[Head[fullExpr] === Rational,
        numerator = Numerator[fullExpr];
        modResult = Mod[numerator, n];
        {k, If[EvenQ[k], "EVEN", "ODD"], fullExpr, modResult, modResult == 0}
      ,
        {k, If[EvenQ[k], "EVEN", "ODD"], fullExpr, "?", False}
      ]
    ],
    {k, 1, kMax}
  ];

  Print["k\tParity\tmod n\tDivisible?"];
  Print["-" * 60];
  Do[
    {k, parity, expr, modVal, divisible} = result;
    Print[k, "\t", parity, "\t", modVal, "\t", divisible];
    ,
    {result, results}
  ];

  Print[];

  (* Summary *)
  evenDivisible = Count[Select[results, #[[2]] == "EVEN" &], {_, _, _, _, True}];
  oddDivisible = Count[Select[results, #[[2]] == "ODD" &], {_, _, _, _, True}];
  evenTotal = Count[results, {_, "EVEN", __}];
  oddTotal = Count[results, {_, "ODD", __}];

  Print["SUMMARY:"];
  Print["  EVEN: ", evenDivisible, " / ", evenTotal, " divisible by ", n];
  Print["  ODD:  ", oddDivisible, " / ", oddTotal, " divisible by ", n];
  Print[];
];

(* Test n=13 *)
Print["=" * 70];
Print["n=13 (x == -1 mod n)"];
Print["=" * 70];
Print[];
TestModN[13, 649, 180, 10];

(* Test n=7 (special prime, x == +1 mod n) *)
Print["=" * 70];
Print["n=7 (SPECIAL: x == +1 mod n)"];
Print["=" * 70];
Print[];
TestModN[7, 8, 3, 10];

(* Test n=61 (x == -1 mod n) *)
Print["=" * 70];
Print["n=61 (x == -1 mod n)"];
Print["=" * 70];
Print[];
TestModN[61, 1766319049, 226153980, 10];

Print["=" * 70];
