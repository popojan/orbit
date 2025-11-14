#!/usr/bin/env wolframscript
(* Analyze Floor[alt[m] * (m-1)!] for prime m *)

Print["Analyzing Floor[alt[m] * (m-1)!] for prime m\n"];

alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, (m-1)/2}];

primes = Select[Range[3, 31, 2], PrimeQ];

Print["m | alt[m] | Floor[alt[m]*(m-1)!] | (m-1)! | Ratio"];
Print[StringRepeat["-", 70]];

data = Table[
  Module[{altVal, A, B, mFact, floorVal, ratio},
    altVal = alt[m];
    A = Numerator[altVal];
    B = Denominator[altVal];
    mFact = (m-1)!;

    floorVal = Floor[altVal * mFact];
    ratio = N[floorVal / mFact, 5];

    Print[m, " | ", A, "/", B, " | ", floorVal, " | ", mFact, " | ", ratio];

    {m, altVal, floorVal, mFact, ratio}
  ],
  {m, primes}
];

Print["\nPattern check: Is Floor[alt[m]*(m-1)!] related to (m-1)! itself?"];

Print["\nm | Floor value | (m-1)! - Floor | Factorization of difference"];
Print[StringRepeat["-", 70]];

Do[
  Module[{m, floorVal, mFact, diff},
    {m, _, floorVal, mFact} = item[[{1,2,3,4}]];
    diff = mFact - floorVal;

    Print[m, " | ", floorVal, " | ", diff, " | ",
          If[diff < 10^6, FactorInteger[diff], "too large"]];
  ],
  {item, data}
];

Print["\nDone!"];
