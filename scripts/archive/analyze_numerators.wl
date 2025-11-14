#!/usr/bin/env wolframscript
(* Analyze numerators of Mod[alt[m], 1/(m-1)!] *)

Print["======================================================================"];
Print["Numerator Analysis for Prime m"];
Print["======================================================================\n"];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}] /; m >= 3;

primes = Select[Range[3, 31, 2], PrimeQ];

Print["m | Numerator | ν_2(num) | ν_2(denom) | diff | num=1?"];
Print[StringRepeat["-", 70]];

data = Table[
  Module[{result, num, denom, nu2num, nu2denom, fact},
    result = Mod[alt[m], 1/(m-1)!];
    num = Numerator[result];
    denom = Denominator[result];

    nu2num = IntegerExponent[num, 2];
    fact = FactorInteger[denom];
    nu2denom = SelectFirst[fact, #[[1]] == 2 &, {2, 0}][[2]];

    legendre2 = Sum[Floor[(m-1)/2^i], {i, 1, Floor[Log[2, m-1]]}];
    diff = nu2denom - legendre2;

    Print[StringPadRight[ToString[m], 2], " | ",
          StringPadRight[ToString[num], 10], " | ",
          StringPadRight[ToString[nu2num], 8], " | ",
          StringPadRight[ToString[nu2denom], 11], " | ",
          StringPadRight[ToString[diff], 4], " | ",
          If[num == 1, "YES", "NO"]);

    {m, num, nu2num, nu2denom, diff}
  ],
  {m, primes}
];

Print["\n======================================================================"];
Print["ANALYSIS"];
Print["======================================================================\n"];

Print["Primes where numerator = 1:"];
onesData = Select[data, #[[2]] == 1 &];
Print["  ", onesData[[All, 1]]];
Print["  These have diff = ", DeleteDuplicates[onesData[[All, 5]]]];

Print["\nPrimes where numerator > 1:"];
bigData = Select[data, #[[2]] > 1 &];
Do[
  {m, num, nu2num, nu2denom, diff} = item;
  Print["  m=", m, ": num=", num, " (ν_2=", nu2num, "), diff=", diff];
  ,
  {item, bigData}
];

Print["\nCorrelation check: ν_2(numerator) vs diff"];
Print["For primes with diff < 0, what is ν_2(numerator)?"];

negDiff = Select[data, #[[5]] < 0 &];
Do[
  {m, num, nu2num, nu2denom, diff} = item;
  Print["  m=", m, ": diff=", diff, ", ν_2(num)=", nu2num,
        If[nu2num == -diff, " ← CANCELS!", ""]];
  ,
  {item, negDiff}
];

Print["\nDone!"];
