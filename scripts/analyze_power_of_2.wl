#!/usr/bin/env wolframscript
(* Focus on power of 2 in the denominator *)

Print["======================================================================"];
Print["Power of 2 in Denominator vs Legendre Prediction"];
Print["======================================================================\n"];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}] /; m >= 3;

Legendre[n_, p_] := Sum[Floor[n/p^i], {i, 1, Floor[Log[p, n]]}];

primes = Select[Range[3, 61, 2], PrimeQ];

Print["m | ν_2(denom) | ν_2((m-1)!) | Difference"];
Print[StringRepeat["-", 50]];

data = Table[
  Module[{result, denom, fact, power2, legendre2},
    result = Mod[alt[m], 1/(m-1)!];
    denom = Denominator[result];
    fact = FactorInteger[denom];

    power2 = SelectFirst[fact, #[[1]] == 2 &, {2, 0}][[2]];
    legendre2 = Legendre[m-1, 2];

    Print[StringPadRight[ToString[m], 2], " | ",
          StringPadRight[ToString[power2], 11], " | ",
          StringPadRight[ToString[legendre2], 13], " | ",
          power2 - legendre2];

    {m, power2, legendre2, power2 - legendre2}
  ],
  {m, primes}
];

Print["\n======================================================================"];
Print["ANALYSIS"];
Print["======================================================================\n"];

differences = data[[All, 4]];

Print["Unique differences: ", DeleteDuplicates[differences]];
Print["Frequency distribution:"];
Do[
  count = Count[differences, diff];
  Print["  diff = ", StringPadRight[ToString[diff], 3], ": ", count, " primes"];
  ,
  {diff, DeleteDuplicates[Sort[differences]]}
];

(* Check pattern: when is diff=0 vs diff<0? *)
zeroDiff = Select[data, #[[4]] == 0 &][[All, 1]];
negDiff = Select[data, #[[4]] < 0 &][[All, 1]];

Print["\nPrimes with diff=0 (perfect match): ", zeroDiff];
Print["\nPrimes with diff<0 (reduced power of 2): ", negDiff];

Print["\nDone!"];
