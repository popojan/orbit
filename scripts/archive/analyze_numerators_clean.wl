#!/usr/bin/env wolframscript
(* Analyze numerators of Mod[alt[m], 1/(m-1)!] *)

Print["Numerator Analysis for Prime m\n"];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}];

primes = Select[Range[3, 31, 2], PrimeQ];

Print["m | Numerator | v2(num) | v2(denom) | diff"];
Print[StringRepeat["-", 60]];

data = Table[
  Module[{result, num, denom, nu2num, nu2denom, fact, legendre2, diff},
    result = Mod[alt[m], 1/(m-1)!];
    num = Numerator[result];
    denom = Denominator[result];

    nu2num = IntegerExponent[num, 2];
    fact = FactorInteger[denom];
    nu2denom = SelectFirst[fact, #[[1]] == 2 &, {2, 0}][[2]];

    legendre2 = Sum[Floor[(m-1)/2^i], {i, 1, Floor[Log[2, m-1]]}];
    diff = nu2denom - legendre2;

    Print[m, " | ", num, " | ", nu2num, " | ", nu2denom, " | ", diff];

    {m, num, nu2num, nu2denom, diff}
  ],
  {m, primes}
];

Print["\nPrimes where numerator = 1:"];
onesData = Select[data, #[[2]] == 1 &];
Print[onesData[[All, 1]]];

Print["\nPrimes where numerator > 1:"];
bigData = Select[data, #[[2]] > 1 &];
Do[
  Print["m=", item[[1]], ": num=", item[[2]], " (v2=", item[[3]], "), diff=", item[[5]]];
  ,
  {item, bigData}
];

Print["\nFor primes with diff < 0, check if v2(numerator) cancels:"];
negDiff = Select[data, #[[5]] < 0 &];
Do[
  Module[{m, num, nu2num, diff},
    {m, num, nu2num} = item[[{1,2,3}]];
    diff = item[[5]];
    Print["m=", m, ": diff=", diff, ", v2(num)=", nu2num,
          If[nu2num == -diff, " <- EXACT CANCELLATION", ""]];
  ],
  {item, negDiff}
];

Print["\nDone!"];
